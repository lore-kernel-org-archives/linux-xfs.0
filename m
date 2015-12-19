Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AEA02809B
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:02:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A0AF08F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:01 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PU8pO7sQZOqxqUqE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:00 -0800 (PST)
Subject: [PATCH 50/76] xfs: map an inode's offset to an exact physical block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:01:56 -0800
Message-ID: <20151219090156.12713.39662.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Teach the bmap routine to know how to map a range of file blocks to a
specific range of physical blocks, instead of simply allocating fresh
blocks.  This enables reflink to map a file to blocks that are already
in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |   10 +++++++
 2 files changed, 71 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6cc4aeb..ac669d58 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4003,6 +4003,54 @@ xfs_bmap_btalloc(
 }
 
 /*
+ * For a remap operation, just "allocate" an extent at the address that the
+ * caller passed in, and ensure that the AGFL is the right size.  The caller
+ * will then map the "allocated" extent into the file somewhere.
+ */
+STATIC int
+xfs_bmap_remap_alloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_trans	*tp = ap->tp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agblock_t		bno;
+	struct xfs_alloc_arg	args;
+	int			error;
+
+	/*
+	 * validate that the block number is legal - the enables us to detect
+	 * and handle a silent filesystem corruption rather than crashing.
+	 */
+	memset(&args, 0, sizeof(struct xfs_alloc_arg));
+	args.tp = ap->tp;
+	args.mp = ap->tp->t_mountp;
+	bno = *ap->firstblock;
+	args.agno = XFS_FSB_TO_AGNO(mp, bno);
+	ASSERT(args.agno < mp->m_sb.sb_agcount);
+	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	ASSERT(args.agbno < mp->m_sb.sb_agblocks);
+
+	/* "Allocate" the extent from the range we passed in. */
+	trace_xfs_bmap_remap_alloc(ap->ip, *ap->firstblock, ap->length);
+	ap->blkno = bno;
+	ap->ip->i_d.di_nblocks += ap->length;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+
+	/* Fix the freelist, like a real allocator does. */
+	args.pag = xfs_perag_get(args.mp, args.agno);
+	ASSERT(args.pag);
+
+	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
+	if (error)
+		goto error0;
+error0:
+	xfs_perag_put(args.pag);
+	if (error)
+		trace_xfs_bmap_remap_alloc_error(ap->ip, error, _RET_IP_);
+	return error;
+}
+
+/*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
  * It figures out where to ask the underlying allocator to put the new extent.
  */
@@ -4010,6 +4058,8 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
+	if (ap->flags & XFS_BMAPI_REMAP)
+		return xfs_bmap_remap_alloc(ap);
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
 	return xfs_bmap_btalloc(ap);
@@ -4645,6 +4695,12 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (whichfork == XFS_ATTR_FORK)
+		ASSERT(!(flags & XFS_BMAPI_REMAP));
+	if (flags & XFS_BMAPI_REMAP) {
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
 
 	/* zeroing is for currently only for data extents, not metadata */
 	ASSERT((flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ZERO)) !=
@@ -4707,6 +4763,12 @@ xfs_bmapi_write(
 		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
 
 		/*
+		 * Make sure we only reflink into a hole.
+		 */
+		if (flags & XFS_BMAPI_REMAP)
+			ASSERT(inhole);
+
+		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index fcea496..7b78fb8 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -127,6 +127,13 @@ typedef	struct xfs_bmap_free
  */
 #define XFS_BMAPI_ZERO		0x080
 
+/*
+ * Map the inode offset to the block given in ap->firstblock.  Primarily
+ * used for reflink.  The range must be in a hole, and this flag cannot be
+ * turned on with PREALLOC or CONVERT, and cannot be used on the attr fork.
+ */
+#define XFS_BMAPI_REMAP		0x100
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -135,7 +142,8 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
 	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
-	{ XFS_BMAPI_ZERO,	"ZERO" }
+	{ XFS_BMAPI_ZERO,	"ZERO" }, \
+	{ XFS_BMAPI_REMAP,	"REMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
