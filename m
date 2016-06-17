Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC66C7DF6
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:26:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 454F3AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id aINCv6em0wgT46WS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:52 -0700 (PDT)
Subject: [PATCH 083/119] xfs: move mappings from cow fork to data fork after
	copy-write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:26:43 -0700
Message-ID: <146612680331.12839.3985620410576071705.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

After the write component of a copy-write operation finishes, clean up
the bookkeeping left behind.  On error, we simply free the new blocks
and pass the error up.  If we succeed, however, then we must remove
the old data fork mapping and move the cow fork mapping to the data
fork.

v2: If CoW fails, we need to remove the CoW fork mapping and free the
blocks.  Furthermore, if xfs_cancel_ioend happens, we also need to
clean out all the CoW record keeping.

v3: When we're removing CoW extents, only free one extent per
transaction to avoid running out of reservation.  Also,
xfs_cancel_ioend mustn't clean out the CoW fork because it is called
when async writeback can't get an inode lock and will try again.

v4: Use bmapi_read to iterate the CoW fork instead of calling the
iext functions directly, and make the CoW remapping atomic by
using the deferred ops mechanism which takes care of logging redo
items for us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: Call the CoW failure function during xfs_cancel_ioend]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c    |   22 ++++
 fs/xfs/xfs_reflink.c |  250 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    8 ++
 3 files changed, 278 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 802d432..232039c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -262,6 +262,23 @@ xfs_end_io(
 		error = -EIO;
 
 	/*
+	 * For a CoW extent, we need to move the mapping from the CoW fork
+	 * to the data fork.  If instead an error happened, just dump the
+	 * new blocks.
+	 */
+	if (ioend->io_type == XFS_IO_COW) {
+		if (ioend->io_bio->bi_error) {
+			error = xfs_reflink_cancel_cow_range(ip,
+					ioend->io_offset, ioend->io_size);
+			goto done;
+		}
+		error = xfs_reflink_end_cow(ip, ioend->io_offset,
+				ioend->io_size);
+		if (error)
+			goto done;
+	}
+
+	/*
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
 	 * Detecting and handling completion IO errors is done individually
@@ -276,7 +293,8 @@ xfs_end_io(
 	} else if (ioend->io_append_trans) {
 		error = xfs_setfilesize_ioend(ioend, error);
 	} else {
-		ASSERT(!xfs_ioend_is_append(ioend));
+		ASSERT(!xfs_ioend_is_append(ioend) ||
+		       ioend->io_type == XFS_IO_COW);
 	}
 
 done:
@@ -290,7 +308,7 @@ xfs_end_bio(
 	struct xfs_ioend	*ioend = bio->bi_private;
 	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
 
-	if (ioend->io_type == XFS_IO_UNWRITTEN)
+	if (ioend->io_type == XFS_IO_UNWRITTEN || ioend->io_type == XFS_IO_COW)
 		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 	else if (ioend->io_append_trans)
 		queue_work(mp->m_data_workqueue, &ioend->io_work);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f0a9e42..59c8e86 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -52,6 +52,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
+#include "xfs_rmap_btree.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -376,3 +377,252 @@ xfs_reflink_trim_irec_to_next_cow(
 
 	return 0;
 }
+
+/*
+ * Cancel all pending CoW reservations for some block range of an inode.
+ */
+int
+xfs_reflink_cancel_cow_blocks(
+	struct xfs_inode		*ip,
+	struct xfs_trans		**tpp,
+	xfs_fileoff_t			offset_fsb,
+	xfs_fileoff_t			end_fsb)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_ifork		*ifp;
+	xfs_filblks_t			count_fsb;
+	xfs_fsblock_t			firstfsb;
+	struct xfs_defer_ops		dfops;
+	int				error = 0;
+	int				nimaps;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	/* Go find the old extent in the CoW fork. */
+	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	while (count_fsb) {
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, offset_fsb, count_fsb, &irec,
+				&nimaps, XFS_BMAPI_COWFORK);
+		if (error)
+			break;
+		ASSERT(nimaps == 1);
+
+		xfs_trim_extent(&irec, offset_fsb, count_fsb);
+		trace_xfs_reflink_cancel_cow(ip, &irec);
+
+		if (irec.br_startblock == DELAYSTARTBLOCK) {
+			/* Free a delayed allocation. */
+			xfs_mod_fdblocks(ip->i_mount, irec.br_blockcount,
+					false);
+			ip->i_delayed_blks -= irec.br_blockcount;
+
+			/* Remove the mapping from the CoW fork. */
+			error = xfs_bunmapi_cow(ip, &irec);
+			if (error)
+				break;
+		} else if (irec.br_startblock == HOLESTARTBLOCK) {
+			/* empty */
+		} else {
+			xfs_trans_ijoin(*tpp, ip, 0);
+			xfs_defer_init(&dfops, &firstfsb);
+
+			xfs_bmap_add_free(ip->i_mount, &dfops,
+					irec.br_startblock, irec.br_blockcount,
+					NULL);
+
+			/* Update quota accounting */
+			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
+					-(long)irec.br_blockcount);
+
+			/* Roll the transaction */
+			error = xfs_defer_finish(tpp, &dfops, ip);
+			if (error) {
+				xfs_defer_cancel(&dfops);
+				break;
+			}
+
+			/* Remove the mapping from the CoW fork. */
+			error = xfs_bunmapi_cow(ip, &irec);
+			if (error)
+				break;
+		}
+
+		/* Roll on... */
+		count_fsb -= irec.br_startoff + irec.br_blockcount - offset_fsb;
+		offset_fsb = irec.br_startoff + irec.br_blockcount;
+	}
+
+	return error;
+}
+
+/*
+ * Cancel all pending CoW reservations for some byte range of an inode.
+ */
+int
+xfs_reflink_cancel_cow_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		count)
+{
+	struct xfs_trans	*tp;
+	xfs_fileoff_t		offset_fsb;
+	xfs_fileoff_t		end_fsb;
+	int			error;
+
+	trace_xfs_reflink_cancel_cow_range(ip, offset, count);
+
+	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+	if (count == NULLFILEOFF)
+		end_fsb = NULLFILEOFF;
+	else
+		end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
+
+	/* Start a rolling transaction to remove the mappings */
+	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
+			0, 0, 0, &tp);
+	if (error)
+		goto out;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/* Scrape out the old CoW reservations */
+	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb);
+	if (error)
+		goto out_defer;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out;
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+
+out_defer:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	trace_xfs_reflink_cancel_cow_range_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Remap parts of a file's data fork after a successful CoW.
+ */
+int
+xfs_reflink_end_cow(
+	struct xfs_inode		*ip,
+	xfs_off_t			offset,
+	xfs_off_t			count)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_bmbt_irec		uirec;
+	struct xfs_trans		*tp;
+	struct xfs_ifork		*ifp;
+	xfs_fileoff_t			offset_fsb;
+	xfs_fileoff_t			end_fsb;
+	xfs_filblks_t			count_fsb;
+	xfs_fsblock_t			firstfsb;
+	struct xfs_defer_ops		dfops;
+	int				done;
+	int				error;
+	unsigned int			resblks;
+	xfs_filblks_t			ilen;
+	xfs_filblks_t			rlen;
+	int				nimaps;
+
+	trace_xfs_reflink_end_cow(ip, offset, count);
+
+	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
+	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
+
+	/* Start a rolling transaction to switch the mappings */
+	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
+			resblks, 0, 0, &tp);
+	if (error)
+		goto out;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/* Go find the old extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	while (count_fsb) {
+		/* Read extent from the source file */
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, offset_fsb, count_fsb, &irec,
+				&nimaps, XFS_BMAPI_COWFORK);
+		if (error)
+			goto out_cancel;
+		ASSERT(nimaps == 1);
+
+		ASSERT(irec.br_startblock != DELAYSTARTBLOCK);
+		xfs_trim_extent(&irec, offset_fsb, count_fsb);
+		trace_xfs_reflink_cow_remap(ip, &irec);
+
+		/*
+		 * We can have a hole in the CoW fork if part of a directio
+		 * write is CoW but part of it isn't.
+		 */
+		rlen = ilen = irec.br_blockcount;
+		if (irec.br_startblock == HOLESTARTBLOCK)
+			goto next_extent;
+
+		/* Unmap the old blocks in the data fork. */
+		done = false;
+		while (rlen) {
+			xfs_defer_init(&dfops, &firstfsb);
+			error = __xfs_bunmapi(tp, ip, irec.br_startoff,
+					&rlen, 0, 1, &firstfsb, &dfops);
+			if (error)
+				goto out_defer;
+
+			/* Trim the extent to whatever got unmapped. */
+			uirec = irec;
+			xfs_trim_extent(&uirec, irec.br_startoff + rlen,
+					irec.br_blockcount - rlen);
+			irec.br_blockcount = rlen;
+			trace_xfs_reflink_cow_remap_piece(ip, &uirec);
+
+			/* Map the new blocks into the data fork. */
+			error = xfs_bmap_map_extent(tp->t_mountp, &dfops,
+					ip, XFS_DATA_FORK, &uirec);
+			if (error)
+				goto out_defer;
+
+			/* Remove the mapping from the CoW fork. */
+			error = xfs_bunmapi_cow(ip, &uirec);
+			if (error)
+				goto out_defer;
+
+			error = xfs_defer_finish(&tp, &dfops, ip);
+			if (error)
+				goto out_defer;
+		}
+
+next_extent:
+		/* Roll on... */
+		count_fsb -= irec.br_startoff + ilen - offset_fsb;
+		offset_fsb = irec.br_startoff + ilen;
+	}
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		goto out;
+	return 0;
+
+out_defer:
+	xfs_defer_cancel(&dfops);
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index a2a23f5..27ae6c0 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -28,4 +28,12 @@ extern int xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
 
+extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
+		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
+		xfs_fileoff_t end_fsb);
+extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t count);
+extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t count);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
