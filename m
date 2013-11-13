Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B8DD7FCE
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42B4A8F8040
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:31 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YYTJYxkNyDX9S1G3 for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005bV-1i
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006i8-0Y
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/36] libxfs: Minor cleanup and bug fix sync
Date: Wed, 13 Nov 2013 17:40:34 +1100
Message-Id: <1384324860-25677-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

These bring all the small single line comment, whitespace and minor
code differences into sync with the kernel code. Anything left at
this point is an intentional difference.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_fs.h         | 4 ++--
 include/xfs_quota_defs.h | 4 ++++
 libxfs/xfs_attr_leaf.c   | 4 +---
 libxfs/xfs_bmap.c        | 6 +++---
 libxfs/xfs_bmap_btree.c  | 2 +-
 libxfs/xfs_dir2_leaf.c   | 1 -
 libxfs/xfs_dir2_node.c   | 2 +-
 libxfs/xfs_ialloc.c      | 4 ++--
 libxfs/xfs_inode_buf.c   | 2 ++
 libxfs/xfs_inode_fork.c  | 5 +++--
 libxfs/xfs_trans_resv.c  | 2 +-
 11 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index c43ba98..554fd66 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -358,7 +358,7 @@ typedef struct xfs_error_injection {
  * Speculative preallocation trimming.
  */
 #define XFS_EOFBLOCKS_VERSION		1
-struct xfs_eofblocks {
+struct xfs_fs_eofblocks {
 	__u32		eof_version;
 	__u32		eof_flags;
 	uid_t		eof_uid;
@@ -516,7 +516,7 @@ typedef struct xfs_swapext
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
-#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
+#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/include/xfs_quota_defs.h b/include/xfs_quota_defs.h
index e6b0d6e..b3b2b10 100644
--- a/include/xfs_quota_defs.h
+++ b/include/xfs_quota_defs.h
@@ -154,4 +154,8 @@ typedef __uint16_t	xfs_qwarncnt_t;
 		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
+extern int xfs_dqcheck(struct xfs_mount *mp, xfs_disk_dquot_t *ddq,
+		       xfs_dqid_t id, uint type, uint flags, char *str);
+extern int xfs_calc_dquots_per_chunk(struct xfs_mount *mp, unsigned int nbblks);
+
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index c09b0f3..fd52397 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -599,7 +599,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 	xfs_attr_sf_entry_t *sfe;
 	int i;
 
-	ASSERT(args->dp->i_d.di_aformat == XFS_IFINLINE);
+	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
@@ -909,7 +909,6 @@ out:
 	return error;
 }
 
-
 /*========================================================================
  * Routines used for growing the Btree.
  *========================================================================*/
@@ -1270,7 +1269,6 @@ xfs_attr3_leaf_compact(
 	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
 						ichdr_dst->freemap[0].base;
 
-
 	/* write the header back to initialise the underlying buffer */
 	xfs_attr3_leaf_hdr_to_disk(leaf_dst, ichdr_dst);
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 7336abf..3e80c64 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -510,8 +510,8 @@ xfs_bmap_trace_exlist(
 
 /*
  * Validate that the bmbt_irecs being returned from bmapi are valid
- * given the callers original parameters.  Specifically check the
- * ranges of the returned irecs to ensure that they only extent beyond
+ * given the caller's original parameters.  Specifically check the
+ * ranges of the returned irecs to ensure that they only extend beyond
  * the given parameters if the XFS_BMAPI_ENTIRE flag was set.
  */
 STATIC void
@@ -1515,7 +1515,7 @@ xfs_bmap_first_unused(
 }
 
 /*
- * Returns the file-relative block number of the last block + 1 before
+ * Returns the file-relative block number of the last block - 1 before
  * last_block (input value) in the file.
  * This is not based on i_size, it is based on the extent records.
  * Returns 0 for local files, as they do not have extent records.
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2f6b48a..6211dc2 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -737,7 +737,7 @@ xfs_bmbt_verify(
 	 * precise.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	if (level > MAX(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
+	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
 		return false;
 	if (be16_to_cpu(block->bb_numrecs) > mp->m_bmap_dmxr[level != 0])
 		return false;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index c035c4d..683536e 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1072,7 +1072,6 @@ xfs_dir3_leaf_compact_x1(
 	*highstalep = highstale;
 }
 
-
 /*
  * Log the bests entries indicated from a leaf1 block.
  */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 6a245e5..10d1d81 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1796,7 +1796,7 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Look at the current free entry.  Is it good enough?
 		 *
-		 * The bests initialisation should be where the buffer is read in
+		 * The bests initialisation should be where the bufer is read in
 		 * the above branch. But gcc is too stupid to realise that bests
 		 * and the freehdr are actually initialised if they are placed
 		 * there, so we have to do it here to avoid warnings. Blech.
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4683287..afe1a82 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -484,7 +484,7 @@ xfs_ialloc_next_ag(
 
 /*
  * Select an allocation group to look for a free inode in, based on the parent
- * inode and then mode.  Return the allocation group buffer.
+ * inode and the mode.  Return the allocation group buffer.
  */
 STATIC xfs_agnumber_t
 xfs_ialloc_ag_select(
@@ -706,7 +706,7 @@ xfs_dialloc_ag(
 		error = xfs_inobt_get_rec(cur, &rec, &j);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		XFS_WANT_CORRUPTED_GOTO(j == 1, error0);
 
 		if (rec.ir_freecount > 0) {
 			/*
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 67d5eb4..b796556 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -101,6 +101,7 @@ xfs_inode_buf_verify(
 	xfs_inobp_check(mp, bp);
 }
 
+
 static void
 xfs_inode_buf_read_verify(
 	struct xfs_buf	*bp)
@@ -299,6 +300,7 @@ xfs_dinode_verify(
 		return false;
 	return true;
 }
+
 void
 xfs_dinode_calc_crc(
 	struct xfs_mount	*mp,
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 1c006f9..190690c 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -138,7 +138,8 @@ xfs_iformat_fork(
 			}
 
 			di_size = be64_to_cpu(dip->di_size);
-			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
+			if (unlikely(di_size < 0 ||
+				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_warn(ip->i_mount,
 			"corrupt inode %Lu (bad size %Ld for local inode).",
 					(unsigned long long) ip->i_ino,
@@ -444,7 +445,7 @@ xfs_iread_extents(
  *
  * The caller must not request to add more records than would fit in
  * the on-disk inode root.  If the if_broot is currently NULL, then
- * if we adding records one will be allocated.  The caller must also
+ * if we are adding records, one will be allocated.  The caller must also
  * not request that the number of records go below zero, although
  * it can go to zero.
  *
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 3e14b1c..1e59fad 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -49,7 +49,7 @@ xfs_calc_buf_res(
 
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
- * which means that what we write into the log doesn't directory translate into
+ * which means that what we write into the log doesn't directly translate into
  * the amount of space they use on disk.
  *
  * Case in point - btree format forks in memory format use more space than the
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
