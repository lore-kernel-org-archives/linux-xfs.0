Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6787C7F3F
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 06:59:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF9FDAC007
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 04:59:55 -0700 (PDT)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id Fjcuvgx3Wl33Sl6z (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 04:59:53 -0700 (PDT)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N8E00HHG6NQD0D0@mailout4.samsung.com> for
	xfs@oss.sgi.com; Tue, 08 Jul 2014 20:59:50 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Date: Tue, 08 Jul 2014 20:59:49 +0900
Message-id: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

This patch implements fs ioctl's IOC_MOV_DATA for XFS.

The semantics of this ioctl are:
1) Like collapse range, offsets and length should be file system block size
   aligned.
2) In the receiver file, atleast length size hole should be present at
   receiver_offset
3) It does not change file size of any of donor or receiver file.
4) It leaves a hole at the place from where blocks are moved out in donor file.
5) Both (donor_offset + length) and (receiver_offset + length) should be within
   size of donor file and receiver file respectively.
   Only unwritten extents resides beyond file size and it does not make sense
   to transfer unwritten extents, leave apart the security issues it may raise.
6) If the range to be transfered from donor file contain any holes, they are
   replicated as it is in receiver file. It mean holes are preserved and
   the length of hole will be added to moved_len signifying that the hole range
   is succesfully transfered.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 148 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |   4 +
 fs/xfs/xfs_bmap_util.c   | 251 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h   |   3 +
 fs/xfs/xfs_iops.c        |   1 +
 5 files changed, 407 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3dee150..c2ae99e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5982,3 +5982,151 @@ del_cursor:
 	xfs_trans_log_inode(tp, ip, logflags);
 	return error;
 }
+/*
+ * Move an extent record pointed by got and whose extent number is stored in
+ * donor_ext from donor inode dip to receiver inode rip.
+ * Extent will be moved at roffset_fsb inside receiver inode.
+ * Caller of this function must make sure there is atleast got->br_blockcount
+ * size hole at roffset_fsb.
+ */
+int xfs_move_extent(
+	struct xfs_trans	*tp,
+	xfs_inode_t		*dip,
+	xfs_inode_t		*rip,
+	xfs_extnum_t		donor_ext,
+	struct xfs_bmbt_irec	*got,
+	xfs_fileoff_t		roffset_fsb,
+	xfs_fsblock_t		*dfirstblock,
+	struct xfs_bmap_free	*dflist,
+	xfs_fsblock_t		*rfirstblock,
+	struct xfs_bmap_free	*rflist)
+
+{
+	struct xfs_mount		*mp = dip->i_mount;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_btree_cur		*dcur;
+	struct xfs_btree_cur		*rcur;
+	xfs_ifork_t			*difp;
+	xfs_ifork_t			*rifp;
+	xfs_extnum_t			idx;
+	int                             i;
+	int                             dlogflags;
+	int                             rlogflags;
+	int                             tmp_logflags;
+	int				error;
+	int				whichfork = XFS_DATA_FORK;
+	struct xfs_bmalloca		bma = { NULL };
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(dip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(dip, whichfork) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_move_extent",
+				XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(rip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(rip, whichfork) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_move_extent",
+				XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	dlogflags = XFS_ILOG_CORE;
+	difp = XFS_IFORK_PTR(dip, whichfork);
+
+	if (difp->if_flags & XFS_IFBROOT) {
+		dcur = xfs_bmbt_init_cursor(mp, tp, dip, whichfork);
+		dcur->bc_private.b.firstblock = *dfirstblock;
+		dcur->bc_private.b.flist = dflist;
+		dcur->bc_private.b.flags = 0;
+	} else {
+		dcur = NULL;
+		dlogflags |= XFS_ILOG_DEXT;
+	}
+
+	rlogflags = XFS_ILOG_CORE;
+	rifp = XFS_IFORK_PTR(rip, whichfork);
+
+	if (rifp->if_flags & XFS_IFBROOT) {
+		rcur = xfs_bmbt_init_cursor(mp, tp, rip, whichfork);
+		rcur->bc_private.b.firstblock = *rfirstblock;
+		rcur->bc_private.b.flist = rflist;
+		rcur->bc_private.b.flags = 0;
+	} else {
+		rcur = NULL;
+		rlogflags |= XFS_ILOG_DEXT;
+	}
+
+	if (dcur) {
+		error = xfs_bmbt_lookup_eq(dcur,
+					   got->br_startoff,
+					   got->br_startblock,
+					   got->br_blockcount,
+					   &i);
+		if (error)
+			goto del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+	}
+
+	gotp = xfs_iext_bno_to_ext(rifp, roffset_fsb, &idx);
+
+	/* Initialize bma */
+	bma.tp = tp;
+	bma.ip = rip;
+	bma.flist = rflist;
+	bma.firstblock = rfirstblock;
+	bma.cur = rcur;
+	bma.got.br_startoff = roffset_fsb;
+	bma.got.br_startblock = got->br_startblock;
+	bma.got.br_blockcount = got->br_blockcount;
+	bma.got.br_state = got->br_state;
+	bma.idx = idx;
+
+	error = xfs_bmap_add_extent_hole_real(&bma, whichfork);
+	if (error)
+		goto del_cursor;
+	rlogflags |= bma.logflags;
+	rip->i_d.di_nblocks += got->br_blockcount;
+
+	xfs_iext_remove(dip, donor_ext, 1, 0);
+	if (dcur) {
+		error = xfs_btree_delete(dcur, &i);
+		if (error)
+			goto del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+	}
+	XFS_IFORK_NEXT_SET(dip, whichfork,
+			   XFS_IFORK_NEXTENTS(dip, whichfork) - 1);
+	dip->i_d.di_nblocks -= got->br_blockcount;
+
+	if (xfs_bmap_wants_extents(dip, whichfork)) {
+		ASSERT(dcur != NULL);
+		error = xfs_bmap_btree_to_extents(tp, dip, dcur, &tmp_logflags,
+				whichfork);
+		dlogflags |= tmp_logflags;
+	}
+
+del_cursor:
+	if (dcur) {
+		dcur->bc_private.b.allocated = 0;
+		xfs_btree_del_cursor(dcur,
+				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	}
+	xfs_trans_log_inode(tp, dip, dlogflags);
+
+	if (rcur) {
+		rcur->bc_private.b.allocated = 0;
+		xfs_btree_del_cursor(rcur,
+				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	}
+	xfs_trans_log_inode(tp, rip, rlogflags);
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index af05899..ebfe584 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -191,5 +191,9 @@ int	xfs_bmap_shift_extents_right(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extnum_t *current_ext, xfs_extnum_t end_ext,
 		xfs_fsblock_t *firstblock, struct xfs_bmap_free *flist,
 		int num_exts);
+int	xfs_move_extent(struct xfs_trans *, xfs_inode_t *, xfs_inode_t *,
+		xfs_extnum_t, struct xfs_bmbt_irec *, xfs_fileoff_t,
+		xfs_fsblock_t *, struct xfs_bmap_free *, xfs_fsblock_t *,
+		struct xfs_bmap_free *);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3c05843..c004b25 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -2071,3 +2071,254 @@ out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	goto out_unlock;
 }
+
+/*
+ * Compute and return the size of hole, if present, @offset_fsb.
+ * The hole size is distance between offset_fsb and till we reach the next
+ * allocated extent. If next extent is beyond isize, the size is computed
+ * till isize.
+ */
+int
+xfs_compute_hole_size(
+	xfs_inode_t		*ip,
+	xfs_fileoff_t		offset_fsb,
+	struct xfs_trans	*tp,
+	xfs_fileoff_t		*count)
+{
+	struct xfs_ifork		*ifp;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		got;
+	xfs_extnum_t			current_ext;
+	xfs_fileoff_t			isize_fsb;
+	int				error = 0;
+
+	*count = 0;
+	isize_fsb = XFS_B_TO_FSB(ip->i_mount, VFS_I(ip)->i_size);
+	ASSERT(isize_fsb > offset_fsb);
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	gotp = xfs_iext_bno_to_ext(ifp, offset_fsb, &current_ext);
+	if (gotp) {
+		xfs_bmbt_get_all(gotp, &got);
+		if (got.br_startoff != offset_fsb) {
+			ASSERT(got.br_startoff > offset_fsb);
+			*count = (isize_fsb > got.br_startoff) ?
+				 (got.br_startoff - offset_fsb) :
+				 (isize_fsb - offset_fsb);
+		}
+	} else
+		*count = isize_fsb - offset_fsb;
+
+	return error;
+}
+
+int
+xfs_vn_move_data(
+	struct inode	*donor,
+	struct inode	*receiver,
+	loff_t		doffset,
+	loff_t		roffset,
+	loff_t		len,
+	loff_t		*moved_len)
+{
+	struct xfs_mount		*mp;
+	struct xfs_ifork		*ifp;
+	struct xfs_trans		*tp;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		got;
+	struct xfs_bmap_free		dfree_list;
+	struct xfs_bmap_free		rfree_list;
+	xfs_inode_t			*dip;
+	xfs_inode_t			*rip;
+	xfs_extnum_t			split_ext;
+	xfs_extnum_t			dcurrent_ext = 0;
+	xfs_fsblock_t			dfirstblock;
+	xfs_fsblock_t			rfirstblock;
+	xfs_fileoff_t			dcurrent_fsb;
+	xfs_fileoff_t			rcurrent_fsb;
+	xfs_fileoff_t			len_fsb;
+	xfs_fileoff_t			moved_blocks = 0;
+	xfs_fileoff_t			hole_blkcnt = 0;
+	xfs_off_t			pg_start;
+	int				committed;
+	int				error;
+	unsigned			mask = (1 << donor->i_blkbits) - 1;
+
+	dip = XFS_I(donor);
+	rip = XFS_I(receiver);
+	mp = dip->i_mount;
+
+	if (XFS_FORCED_SHUTDOWN(dip->i_mount))
+		return -EIO;
+
+	xfs_lock_two_inodes(dip, rip, XFS_IOLOCK_EXCL);
+
+	if (doffset + len > donor->i_size || roffset + len > receiver->i_size) {
+		error = EINVAL;
+		goto out;
+	}
+
+	if (doffset & mask || roffset & mask || len & mask) {
+		error = EINVAL;
+		goto out;
+	}
+
+	dcurrent_fsb = XFS_B_TO_FSB(mp, doffset);
+	rcurrent_fsb = XFS_B_TO_FSB(mp, roffset);
+	len_fsb = XFS_B_TO_FSB(mp, len);
+
+	pg_start = round_down(doffset, PAGE_SIZE);
+	error = -filemap_write_and_wait_range(donor->i_mapping, pg_start, -1);
+	if (error)
+		goto out;
+	truncate_pagecache_range(donor, pg_start, -1);
+
+	pg_start = round_down(roffset, PAGE_SIZE);
+	error = -filemap_write_and_wait_range(receiver->i_mapping,
+					     pg_start, -1);
+	if (error)
+		goto out;
+	truncate_pagecache_range(receiver, pg_start, -1);
+
+	error = xfs_qm_dqattach(dip, 0);
+	if (error)
+		goto out;
+
+	error = xfs_qm_dqattach(rip, 0);
+	if (error)
+		goto out;
+
+	error = xfs_bmap_split_extent(dip, dcurrent_fsb, &split_ext);
+	if (error)
+		goto out;
+
+	error = xfs_bmap_split_extent(dip, dcurrent_fsb + len_fsb,
+				      &split_ext);
+	if (error)
+		goto out;
+
+	ifp = XFS_IFORK_PTR(dip, XFS_DATA_FORK);
+
+	while (moved_blocks < len_fsb && !error) {
+		gotp = xfs_iext_bno_to_ext(ifp, dcurrent_fsb, &dcurrent_ext);
+		if (!gotp) {
+			/* No more data blocks left in donor */
+			moved_blocks = len_fsb;
+			break;
+		}
+
+		xfs_bmbt_get_all(gotp, &got);
+		if (dcurrent_fsb != got.br_startoff) {
+			if (dcurrent_fsb > got.br_startoff) {
+				error = -EFSCORRUPTED;
+				break;
+			}
+			hole_blkcnt = got.br_startoff - dcurrent_fsb;
+			dcurrent_fsb += hole_blkcnt;
+			rcurrent_fsb += hole_blkcnt;
+			moved_blocks += hole_blkcnt;
+			if (moved_blocks >= len_fsb) {
+				moved_blocks = len_fsb;
+				break;
+			}
+		}
+
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+
+		/*
+		 * We would need to reserve permanent block for transaction.
+		 * This will come into picture when after shifting extent into
+		 * hole we found that adjacent extents can be merged which
+		 * may lead to freeing of a block during record update.
+		 */
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+					  XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+		if (error) {
+			xfs_trans_cancel(tp, 0);
+			break;
+		}
+
+		xfs_lock_two_inodes(dip, rip, XFS_ILOCK_EXCL);
+
+		error = xfs_trans_reserve_quota(tp, mp, dip->i_udquot,
+				dip->i_gdquot, dip->i_pdquot,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error2;
+
+		error = xfs_trans_reserve_quota(tp, mp, rip->i_udquot,
+				rip->i_gdquot, rip->i_pdquot,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error2;
+
+		xfs_trans_ijoin(tp, dip, 0);
+		xfs_trans_ijoin(tp, rip, 0);
+
+		xfs_bmap_init(&dfree_list, &dfirstblock);
+		xfs_bmap_init(&rfree_list, &rfirstblock);
+
+		/* compute the hole size in first iteration */
+		if (moved_blocks == hole_blkcnt) {
+			error = xfs_compute_hole_size(rip, rcurrent_fsb,
+						      tp, &hole_blkcnt);
+			if (error)
+				goto error0;
+			if (hole_blkcnt < len_fsb) {
+				error = EINVAL;
+				goto error0;
+			}
+		}
+
+		error = xfs_move_extent(tp, dip, rip, dcurrent_ext, &got,
+					rcurrent_fsb, &dfirstblock,
+					&dfree_list, &rfirstblock, &rfree_list);
+		if (error)
+			goto error0;
+
+		error = xfs_bmap_finish(&tp, &dfree_list, &committed);
+		if (error)
+			goto error0;
+
+		error = xfs_bmap_finish(&tp, &rfree_list, &committed);
+		if (error)
+			goto error1;
+
+		error = xfs_trans_commit(tp, 0);
+
+		if (!error) {
+			dcurrent_fsb += got.br_blockcount;
+			moved_blocks += got.br_blockcount;
+			rcurrent_fsb += got.br_blockcount;
+		}
+
+		xfs_iunlock(dip, XFS_ILOCK_EXCL);
+		xfs_iunlock(rip, XFS_ILOCK_EXCL);
+	}
+out:
+	*moved_len = moved_blocks << donor->i_blkbits;
+	xfs_iunlock(dip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(rip, XFS_IOLOCK_EXCL);
+	return -error;
+
+error0:
+	xfs_bmap_cancel(&dfree_list);
+error1:
+	xfs_bmap_cancel(&rfree_list);
+error2:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_iunlock(dip, XFS_ILOCK_EXCL);
+	xfs_iunlock(rip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(rip, XFS_IOLOCK_EXCL);
+	*moved_len = moved_blocks << donor->i_blkbits;
+	return -error;
+}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 9a18a4b..b2ae123 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -104,6 +104,9 @@ int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
+int	xfs_vn_move_data(struct inode *donor, struct inode *receiver,
+			 loff_t doffset, loff_t roffset, loff_t len,
+			 loff_t *moved_len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d75621a..63c1621 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1100,6 +1100,7 @@ static const struct inode_operations xfs_inode_operations = {
 	.listxattr		= xfs_vn_listxattr,
 	.fiemap			= xfs_vn_fiemap,
 	.update_time		= xfs_vn_update_time,
+	.mov_data		= xfs_vn_move_data,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
