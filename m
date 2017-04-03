Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753045AbdDCMTI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 08:19:08 -0400
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cv0wj-0005XT-44
        for linux-xfs@vger.kernel.org; Mon, 03 Apr 2017 12:18:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] xfs: remove xfs_bmap_remap_alloc
Date: Mon,  3 Apr 2017 14:18:32 +0200
Message-Id: <20170403121833.7825-6-hch@lst.de>
In-Reply-To: <20170403121833.7825-1-hch@lst.de>
References: <20170403121833.7825-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The main thing that xfs_bmap_remap_alloc does is fixing the AGFL, similar
to what we do in the space allocator.  But the reflink code doesn't touch
the allocation btree unlike the normal space allocator, so we couldn't
care less about the state of the AGFL.

So remove xfs_bmap_remap_alloc and just handle the di_nblocks update in
the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 60 ++----------------------------------------------
 fs/xfs/xfs_trace.h       | 25 --------------------
 2 files changed, 2 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index caadfe27af39..0035f96a6e5a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3856,61 +3856,6 @@ xfs_bmap_btalloc(
 }
 
 /*
- * For a remap operation, just "allocate" an extent at the address that the
- * caller passed in, and ensure that the AGFL is the right size.  The caller
- * will then map the "allocated" extent into the file somewhere.
- */
-STATIC int
-xfs_bmap_remap_alloc(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	xfs_fsblock_t		startblock,
-	xfs_extlen_t		length)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_alloc_arg	args;
-	int			error;
-
-	/*
-	 * validate that the block number is legal - the enables us to detect
-	 * and handle a silent filesystem corruption rather than crashing.
-	 */
-	memset(&args, 0, sizeof(struct xfs_alloc_arg));
-	args.tp = tp;
-	args.mp = mp;
-	args.agno = XFS_FSB_TO_AGNO(mp, startblock);
-	args.agbno = XFS_FSB_TO_AGBNO(mp, startblock);
-
-	if (args.agno >= mp->m_sb.sb_agcount ||
-	    args.agbno >= mp->m_sb.sb_agblocks)
-		return -EFSCORRUPTED;
-
-	/* "Allocate" the extent from the range we passed in. */
-	trace_xfs_bmap_remap_alloc(ip, startblock, length);
-
-	ip->i_d.di_nblocks += length;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	/* Fix the freelist, like a real allocator does. */
-	args.datatype = XFS_ALLOC_USERDATA | XFS_ALLOC_NOBUSY;
-	args.pag = xfs_perag_get(mp, args.agno);
-	ASSERT(args.pag);
-
-	/*
-	 * The freelist fixing code will decline the allocation if
-	 * the size and shape of the free space doesn't allow for
-	 * allocating the extent and updating all the metadata that
-	 * happens during an allocation.  We're remapping, not
-	 * allocating, so skip that check by pretending to be freeing.
-	 */
-	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
-	xfs_perag_put(args.pag);
-	if (error)
-		trace_xfs_bmap_remap_alloc_error(ip, error, _RET_IP_);
-	return error;
-}
-
-/*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
  * It figures out where to ask the underlying allocator to put the new extent.
  */
@@ -4806,9 +4751,8 @@ xfs_bmapi_remap(
 		ASSERT(got.br_startoff - bno >= len);
 	}
 
-	error = xfs_bmap_remap_alloc(tp, ip, startblock, len);
-	if (error)
-		goto error0;
+	ip->i_d.di_nblocks += len;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4f96dc953fbe..cba10daf8391 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3003,31 +3003,6 @@ DEFINE_EVENT(xfs_inode_error_class, name, \
 		 unsigned long caller_ip), \
 	TP_ARGS(ip, error, caller_ip))
 
-/* reflink allocator */
-TRACE_EVENT(xfs_bmap_remap_alloc,
-	TP_PROTO(struct xfs_inode *ip, xfs_fsblock_t fsbno,
-		 xfs_extlen_t len),
-	TP_ARGS(ip, fsbno, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsblock_t, fsbno)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->fsbno = fsbno;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d ino 0x%llx fsbno 0x%llx len %x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->fsbno,
-		  __entry->len)
-);
-DEFINE_INODE_ERROR_EVENT(xfs_bmap_remap_alloc_error);
-
 /* reflink tracepoint classes */
 
 /* two-file io tracepoint class */
-- 
2.11.0

