Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D5387F58
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 22:58:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D350AAC003
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 20:58:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nCD6nwmeVBpqrqY5 for <xfs@oss.sgi.com>;
	Sun, 10 Feb 2013 20:58:17 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U4lT4-0000pq-8w
	for xfs@oss.sgi.com; Mon, 11 Feb 2013 15:58:14 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U4lT4-0005Iq-0B
	for xfs@oss.sgi.com; Mon, 11 Feb 2013 15:58:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: xfs_bmap_add_attrfork_local is too generic
Date: Mon, 11 Feb 2013 15:58:13 +1100
Message-Id: <1360558693-20354-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we are converting local data to an extent format as a result of
adding an attribute, the type of data contained in the local fork
determines the behaviour that needs to occur.

xfs_bmap_add_attrfork_local() already handles the directory data
case specially by using S_ISDIR() and calling out to
xfs_dir2_sf_to_block(), but with verifiers we now need to handle
each different type of metadata specially and different metadata
formats require different verifiers (and eventually block header
initialisation).

There is only a single place that we add and attribute fork to
the inode, but that is in the attribute code and it knows nothing
about the specific contents of the data fork. It is only the case of
local data that is the issue here, so adding code to hadnle this
case in the attribute specific code is wrong. Hence we are really
stuck trying to detect the data fork contents in
xfs_bmap_add_attrfork_local() and performing the correct callout
there.

Luckily the current cases can be determined by S_IS* macros, and we
can push the work off to data specific callouts, but each of those
callouts does a lot of work in common with
xfs_bmap_local_to_extents(). The only reason that this fails for
symlinks right now is is that xfs_bmap_local_to_extents() assumes
the data fork contains extent data, and so attaches a a bmap extent
data verifier to the buffer and simply copies the data fork
information straight into it.

To fix this, allow us to pass a "formatting" callback into
xfs_bmap_local_to_extents() which is responsible for setting the
buffer type, initialising it and copying the data fork contents over
to the new buffer. This allows callers to specify how they want to
format the new buffer (which is necessary for the upcoming CRC
enabled metadata blocks) and hence make xfs_bmap_local_to_extents()
useful for any type of data fork content.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c |  114 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 93 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 491f35e..b44af92 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -147,7 +147,10 @@ xfs_bmap_local_to_extents(
 	xfs_fsblock_t	*firstblock,	/* first block allocated in xaction */
 	xfs_extlen_t	total,		/* total blocks needed by transaction */
 	int		*logflagsp,	/* inode logging flags */
-	int		whichfork);	/* data or attr fork */
+	int		whichfork,	/* data or attr fork */
+	void		(*init_fn)(struct xfs_buf *bp,
+				   struct xfs_inode *ip,
+				   struct xfs_ifork *ifp));
 
 /*
  * Search the extents list for the inode, for the extent containing bno.
@@ -357,7 +360,42 @@ xfs_bmap_add_attrfork_extents(
 }
 
 /*
- * Called from xfs_bmap_add_attrfork to handle local format files.
+ * Block initialisation functions for local to extent format conversion.
+ * As these get more complex, they will be moved to the relevant files,
+ * but for now they are too simple to worry about.
+ */
+STATIC void
+xfs_bmap_local_to_extents_init_fn(
+	struct xfs_buf		*bp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp)
+{
+	bp->b_ops = &xfs_bmbt_buf_ops;
+	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+}
+
+STATIC void
+xfs_symlink_local_to_remote(
+	struct xfs_buf		*bp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp)
+{
+	/* remote symlink blocks are not verifiable until CRCs come along */
+	bp->b_ops = NULL;
+	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+}
+
+/*
+ * Called from xfs_bmap_add_attrfork to handle local format files. Each
+ * different data fork content type needs a different callout to do the
+ * conversion. Some are basic and only require special block initialisation
+ * callouts for the data formating, others (directories) are so specialised they
+ * handle everything themselves.
+ *
+ * XXX (dgc): investigate whether directory conversion can use the generic
+ * formatting callout. It should be possible - it's just a very complex
+ * formatter. it would also require passing the transaction through to the init
+ * function.
  */
 STATIC int					/* error */
 xfs_bmap_add_attrfork_local(
@@ -368,25 +406,29 @@ xfs_bmap_add_attrfork_local(
 	int			*flags)		/* inode logging flags */
 {
 	xfs_da_args_t		dargs;		/* args for dir/attr code */
-	int			error;		/* error return value */
-	xfs_mount_t		*mp;		/* mount structure pointer */
 
 	if (ip->i_df.if_bytes <= XFS_IFORK_DSIZE(ip))
 		return 0;
+
 	if (S_ISDIR(ip->i_d.di_mode)) {
-		mp = ip->i_mount;
 		memset(&dargs, 0, sizeof(dargs));
 		dargs.dp = ip;
 		dargs.firstblock = firstblock;
 		dargs.flist = flist;
-		dargs.total = mp->m_dirblkfsbs;
+		dargs.total = ip->i_mount->m_dirblkfsbs;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
-		error = xfs_dir2_sf_to_block(&dargs);
-	} else
-		error = xfs_bmap_local_to_extents(tp, ip, firstblock, 1, flags,
-			XFS_DATA_FORK);
-	return error;
+		return xfs_dir2_sf_to_block(&dargs);
+	}
+
+	if (S_ISLNK(ip->i_d.di_mode))
+		return xfs_bmap_local_to_extents(tp, ip, firstblock, 1,
+						 flags, XFS_DATA_FORK,
+						 xfs_symlink_local_to_remote);
+
+	return xfs_bmap_local_to_extents(tp, ip, firstblock, 1, flags,
+					 XFS_DATA_FORK,
+					 xfs_bmap_local_to_extents_init_fn);
 }
 
 /*
@@ -3219,7 +3261,10 @@ xfs_bmap_local_to_extents(
 	xfs_fsblock_t	*firstblock,	/* first block allocated in xaction */
 	xfs_extlen_t	total,		/* total blocks needed by transaction */
 	int		*logflagsp,	/* inode logging flags */
-	int		whichfork)	/* data or attr fork */
+	int		whichfork,
+	void		(*init_fn)(struct xfs_buf *bp,
+				   struct xfs_inode *ip,
+				   struct xfs_ifork *ifp))
 {
 	int		error;		/* error return value */
 	int		flags;		/* logging flags returned */
@@ -3239,12 +3284,12 @@ xfs_bmap_local_to_extents(
 		xfs_buf_t	*bp;	/* buffer for extent block */
 		xfs_bmbt_rec_host_t *ep;/* extent record pointer */
 
+		ASSERT((ifp->if_flags &
+			(XFS_IFINLINE|XFS_IFEXTENTS|XFS_IFEXTIREC)) == XFS_IFINLINE);
 		memset(&args, 0, sizeof(args));
 		args.tp = tp;
 		args.mp = ip->i_mount;
 		args.firstblock = *firstblock;
-		ASSERT((ifp->if_flags &
-			(XFS_IFINLINE|XFS_IFEXTENTS|XFS_IFEXTIREC)) == XFS_IFINLINE);
 		/*
 		 * Allocate a block.  We know we need only one, since the
 		 * file currently fits in an inode.
@@ -3258,17 +3303,20 @@ xfs_bmap_local_to_extents(
 		}
 		args.total = total;
 		args.minlen = args.maxlen = args.prod = 1;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent(&args);
+		if (error)
 			goto done;
-		/*
-		 * Can't fail, the space was reserved.
-		 */
+
+		/* Can't fail, the space was reserved. */
 		ASSERT(args.fsbno != NULLFSBLOCK);
 		ASSERT(args.len == 1);
 		*firstblock = args.fsbno;
 		bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
-		bp->b_ops = &xfs_bmbt_buf_ops;
-		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+
+		/* initialise the block and copy the data */
+		init_fn(bp, ip, ifp);
+
+		/* account for the change in fork size and log everything */
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		xfs_bmap_forkoff_reset(args.mp, ip, whichfork);
 		xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
@@ -4915,8 +4963,32 @@ xfs_bmapi_write(
 	XFS_STATS_INC(xs_blk_mapw);
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
+		/*
+		 * XXX (dgc): This assumes we are only called for inodes that
+		 * contain content neutral data in local format. Anything that
+		 * contains caller-specific data in local format that needs
+		 * transformation to move to a block format needs to do the
+		 * conversion to extent format itself.
+		 *
+		 * Directory data forks and attribute forks handle this
+		 * themselves, but with the addition of metadata verifiers every
+		 * data fork in local format now contains caller specific data
+		 * and as such conversion through this function is likely to be
+		 * broken.
+		 *
+		 * The only likely user of this branch is for remote symlinks,
+		 * but we cannot overwrite the data fork contents of the symlink
+		 * (EEXIST occurs higher up the stack) and so it will never go
+		 * from local format to extent format here. Hence I don't think
+		 * this branch is ever executed intentionally and we should
+		 * consider removing it and asserting that xfs_bmapi_write()
+		 * cannot be called directly on local format forks. i.e. callers
+		 * are completely responsible for local to extent format
+		 * conversion, not xfs_bmapi_write().
+		 */
 		error = xfs_bmap_local_to_extents(tp, ip, firstblock, total,
-						  &bma.logflags, whichfork);
+					&bma.logflags, whichfork,
+					xfs_bmap_local_to_extents_init_fn);
 		if (error)
 			goto error0;
 	}
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
