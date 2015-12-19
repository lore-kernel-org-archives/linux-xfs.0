Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A45D080E0
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A4388F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:08 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HL4ty98Y82xZMrNW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:04 -0800 (PST)
Subject: [PATCH 59/76] xfs: move mappings from cow fork to data fork after
	copy-write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:00 -0800
Message-ID: <20151219090300.12713.13025.stgit@birch.djwong.org>
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

After the write component of a copy-write operation finishes, clean up
the bookkeeping left behind.  On error, we simply free the new blocks
and pass the error up.  If we succeed, however, then we must remove
the old data fork mapping and move the cow fork mapping to the data
fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   23 +++++
 fs/xfs/xfs_reflink.c |  223 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    4 +
 3 files changed, 248 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7179b25..8101d6a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -195,7 +195,8 @@ xfs_finish_ioend(
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
 		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
 
-		if (ioend->io_type == XFS_IO_UNWRITTEN)
+		if (ioend->io_type == XFS_IO_UNWRITTEN ||
+		    xfs_ioend_is_cow(ioend))
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 		else if (ioend->io_append_trans)
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
@@ -221,6 +222,23 @@ xfs_end_io(
 	}
 
 	/*
+	 * For a CoW extent, we need to move the mapping from the CoW fork
+	 * to the data fork.  If instead an error happened, just dump the
+	 * new blocks.
+	 */
+	if (xfs_ioend_is_cow(ioend)) {
+		if (ioend->io_error) {
+			error = xfs_reflink_end_cow_failed(ip, ioend->io_offset,
+					ioend->io_size);
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
@@ -235,7 +253,7 @@ xfs_end_io(
 	} else if (ioend->io_append_trans) {
 		error = xfs_setfilesize_ioend(ioend);
 	} else {
-		ASSERT(!xfs_ioend_is_append(ioend));
+		ASSERT(!xfs_ioend_is_append(ioend) || xfs_ioend_is_cow(ioend));
 	}
 
 done:
@@ -274,6 +292,7 @@ xfs_alloc_ioend(
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
 	ioend->io_append_trans = NULL;
+	ioend->io_flags = 0;
 
 	INIT_WORK(&ioend->io_work, xfs_end_io);
 	return ioend;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 65d4c2d..9c1c262 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -321,3 +321,226 @@ xfs_reflink_find_cow_mapping(
 
 	return 0;
 }
+
+/**
+ * xfs_reflink_end_cow_failed() -- Throw out a CoW mapping if there was an I/O
+ *				   error while writing the new block.
+ * @ip: The XFS inode.
+ * @offset: File offset, in bytes.
+ * @count: Number of bytes.
+ */
+int
+xfs_reflink_end_cow_failed(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	size_t			count)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_trans	*tp;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		offset_fsb;
+	xfs_fileoff_t		end_fsb;
+	xfs_filblks_t		count_fsb;
+	xfs_fsblock_t		firstfsb;
+	xfs_extnum_t		idx;
+	struct xfs_bmap_free	free_list;
+	int			committed;
+	int			error;
+	struct xfs_bmbt_rec_host	*gotp;
+
+	trace_xfs_reflink_end_cow_failed(ip, offset, count);
+
+	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+	end_fsb = XFS_B_TO_FSB(ip->i_mount, (xfs_ufsize_t)offset + count);
+	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
+
+	/* Start a rolling transaction to switch the mappings */
+	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_write, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_bmap_init(&free_list, &firstfsb);
+
+	/* Go find the old extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	gotp = xfs_iext_bno_to_ext(ifp, offset_fsb, &idx);
+	while (gotp) {
+		xfs_bmbt_get_all(gotp, &irec);
+
+		if (irec.br_startoff >= end_fsb)
+			break;
+
+		ASSERT(!isnullstartblock(irec.br_startblock));
+		xfs_trim_extent(&irec, offset_fsb, count_fsb);
+		trace_xfs_reflink_cow_remap(ip, &irec);
+
+		/* Remove the EFD. */
+#if 0
+		efd = xfs_trans_get_efd(tp, eio->rlei_efi, 1);
+		xfs_trans_undelete_extent(tp, efd, imap->br_startblock,
+					 imap->br_blockcount);
+#endif
+
+		xfs_bmap_add_free(ip->i_mount, &free_list, irec.br_startblock,
+				irec.br_blockcount, NULL);
+
+		/* Roll on... */
+		idx++;
+		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			break;
+		gotp = xfs_iext_get_ext(ifp, idx);
+	}
+
+	/* Process all the deferred stuff. */
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		goto out;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	trace_xfs_reflink_end_cow_failed_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_reflink_end_cow() -- Remap the data fork after a successful CoW.
+ * @ip: The XFS inode.
+ * @offset: File offset, in bytes.
+ * @count: Number of bytes.
+ */
+int
+xfs_reflink_end_cow(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	size_t			count)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_bmbt_irec	imap;
+	int			nimaps = 1;
+	struct xfs_trans	*tp;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		offset_fsb;
+	xfs_fileoff_t		end_fsb;
+	xfs_filblks_t		count_fsb;
+	xfs_fsblock_t		firstfsb;
+	xfs_extnum_t		idx;
+	struct xfs_bmap_free	free_list;
+	int			committed;
+	int			done;
+	int			error;
+	unsigned int		resblks;
+	struct xfs_bmbt_rec_host	*gotp;
+
+	trace_xfs_reflink_end_cow(ip, offset, count);
+
+	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+	end_fsb = XFS_B_TO_FSB(ip->i_mount, (xfs_ufsize_t)offset + count);
+	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
+
+	/* Start a rolling transaction to switch the mappings */
+	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_write,
+			resblks, 0);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_bmap_init(&free_list, &firstfsb);
+
+	/* Go find the old extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	gotp = xfs_iext_bno_to_ext(ifp, offset_fsb, &idx);
+	while (gotp) {
+		xfs_bmbt_get_all(gotp, &irec);
+
+		if (irec.br_startoff >= end_fsb)
+			break;
+
+		ASSERT(!isnullstartblock(irec.br_startblock));
+		xfs_trim_extent(&irec, offset_fsb, count_fsb);
+		trace_xfs_reflink_cow_remap(ip, &irec);
+
+		/* Unmap the old blocks in the data fork. */
+		done = false;
+		while (!done) {
+			error = xfs_bunmapi(tp, ip, irec.br_startoff,
+					irec.br_blockcount, 0, 1,
+					&firstfsb, &free_list, &done);
+			if (error)
+				goto out_freelist;
+
+			error = xfs_trans_roll(&tp, ip);
+			if (error)
+				goto out_freelist;
+		}
+
+		/* Remove the EFD. */
+#if 0
+		efd = xfs_trans_get_efd(tp, eio->rlei_efi, 1);
+		xfs_trans_undelete_extent(tp, efd, imap->br_startblock,
+					 imap->br_blockcount);
+#endif
+
+		/* Map the new blocks into the data fork. */
+		firstfsb = irec.br_startblock;
+		error = xfs_bmapi_write(tp, ip, irec.br_startoff,
+					irec.br_blockcount,
+					XFS_BMAPI_REMAP, &firstfsb,
+					irec.br_blockcount, &imap, &nimaps,
+					&free_list);
+		if (error)
+			goto out_freelist;
+
+		/* Remove the mapping from the CoW fork. */
+		error = xfs_bunmapi_cow(ip, &idx, &irec);
+		if (error)
+			goto out_freelist;
+
+		error = xfs_trans_roll(&tp, ip);
+		if (error)
+			goto out_freelist;
+
+		/* Roll on... */
+		idx++;
+		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			break;
+		gotp = xfs_iext_get_ext(ifp, idx);
+	}
+
+	/* Process all the deferred stuff. */
+	error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		goto out;
+	return 0;
+
+out_freelist:
+	xfs_bmap_cancel(&free_list);
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 1018ac9..8ec1ebb 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -23,5 +23,9 @@ extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip, xfs_off_t pos,
 extern bool xfs_reflink_is_cow_pending(struct xfs_inode *ip, xfs_off_t offset);
 extern int xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
 		struct xfs_bmbt_irec *imap, bool *need_alloc);
+extern int xfs_reflink_end_cow_failed(struct xfs_inode *ip, xfs_off_t offset,
+		size_t count);
+extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
+		size_t count);
 
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
