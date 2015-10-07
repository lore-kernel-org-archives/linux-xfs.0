Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD2147FB3
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:59:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3DA01AC009
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:59:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2kZgtptbHu6WyW3F (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:59:55 -0700 (PDT)
Subject: [PATCH 43/58] xfs: map an inode's offset to an exact physical block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:59:52 -0700
Message-ID: <20151007045952.30457.35484.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Teach the bmap routine to know how to map a range of file blocks to a
specific range of physical blocks, instead of simply allocating fresh
blocks.  This enables reflink to map a file to blocks that are already
in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    9 ++++++
 2 files changed, 72 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f6812ba..5f457b4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4003,6 +4003,56 @@ xfs_bmap_btalloc(
 }
 
 /*
+ * For a remap operation, just "allocate" an extent at the address that the
+ * caller passed in, and ensure that the AGFL is the right size.  The caller
+ * will then map the "allocated" extent into the file somewhere.
+ */
+static int
+xfs_bmap_remap(
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
+	if (args.agno >= mp->m_sb.sb_agcount)
+		return -EFSCORRUPTED;
+
+	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	if (args.agbno >= mp->m_sb.sb_agblocks)
+		return -EFSCORRUPTED;
+
+	/* "Allocate" the extent from the range we passed in. */
+	trace_xfs_reflink_relink_blocks(ap->ip, *ap->firstblock,
+			ap->length);
+	ap->blkno = bno;
+	ap->ip->i_d.di_nblocks += ap->length;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+
+	/* Fix the freelist, like a real allocator does. */
+
+	args.pag = xfs_perag_get(args.mp, args.agno);
+	ASSERT(args.pag);
+
+	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
+	if (error)
+		goto error0;
+error0:
+	xfs_perag_put(args.pag);
+	return error;
+}
+/*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
  * It figures out where to ask the underlying allocator to put the new extent.
  */
@@ -4010,6 +4060,8 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
+	if (ap->flags & XFS_BMAPI_REMAP)
+		return xfs_bmap_remap(ap);
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
 	return xfs_bmap_btalloc(ap);
@@ -4694,6 +4746,12 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (whichfork == XFS_ATTR_FORK)
+		ASSERT(!(flags & XFS_BMAPI_REMAP));
+	if (flags & XFS_BMAPI_REMAP) {
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4743,6 +4801,12 @@ xfs_bmapi_write(
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
index 59f26cf..78a56b69 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -110,6 +110,12 @@ typedef	struct xfs_bmap_free
  * from written to unwritten, otherwise convert from unwritten to written.
  */
 #define XFS_BMAPI_CONVERT	0x040
+/*
+ * Map the inode offset to the block given in ap->firstblock.  Primarily
+ * used for reflink.  The range must be in a hole, and this flag cannot be
+ * turned on with PREALLOC or CONVERT, and cannot be used on the attr fork.
+ */
+#define XFS_BMAPI_REMAP		0x100
 
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
@@ -118,7 +124,8 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
-	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
+	{ XFS_BMAPI_REMAP,	"REMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
