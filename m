Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933055AbeCGJFO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 04:05:14 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 199CE4067734
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:14 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9552D10B0F49
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:13 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/4] Get rid of XFS_BUF_PTR() macro
Date: Wed,  7 Mar 2018 10:05:03 +0100
Message-Id: <20180307090506.30199-2-cmaiolino@redhat.com>
In-Reply-To: <20180307090506.30199-1-cmaiolino@redhat.com>
References: <20180307090506.30199-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	Fix casting

 libxfs/libxfs_io.h       |  1 -
 libxfs/rdwr.c            | 10 +++++-----
 logprint/log_print_all.c |  4 ++--
 mkfs/proto.c             |  5 +++--
 mkfs/xfs_mkfs.c          | 14 +++++++-------
 repair/agheader.c        |  8 ++++----
 repair/phase6.c          |  4 ++--
 repair/prefetch.c        |  2 +-
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 6308a742..a1c62071 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -97,7 +97,6 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 
 #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
 
-#define XFS_BUF_PTR(bp)			((char *)(bp)->b_addr)
 #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3c5def29..9acdb98c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -143,7 +143,7 @@ static char *next(
 	struct xfs_buf	*buf = (struct xfs_buf *)private;
 
 	if (buf &&
-	    (XFS_BUF_COUNT(buf) < (int)(ptr - XFS_BUF_PTR(buf)) + offset))
+	    (XFS_BUF_COUNT(buf) < (int)(ptr - (char *)buf->b_addr) + offset))
 		abort();
 
 	return ptr + offset;
@@ -204,7 +204,7 @@ libxfs_log_clear(
 	ptr = dptr;
 	if (btp) {
 		bp = libxfs_getbufr(btp, start, len);
-		ptr = XFS_BUF_PTR(bp);
+		ptr = (char *)bp->b_addr;
 	}
 	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
 			  next, bp);
@@ -252,7 +252,7 @@ libxfs_log_clear(
 		ptr = dptr;
 		if (btp) {
 			bp = libxfs_getbufr(btp, blk, len);
-			ptr = XFS_BUF_PTR(bp);
+			ptr = (char *)bp->b_addr;
 		}
 		/*
 		 * Note: pass the full buffer length as the sunit to initialize
@@ -1026,7 +1026,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 {
 	int	fd;
 	int	error = 0;
-	char	*buf;
+	void	*buf;
 	int	i;
 
 	fd = libxfs_device_to_fd(btp->dev);
@@ -1147,7 +1147,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
 	} else {
 		int	i;
-		char	*buf = bp->b_addr;
+		void	*buf = bp->b_addr;
 
 		for (i = 0; i < bp->b_nmaps; i++) {
 			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index cdaf77bf..4eaf184f 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -39,10 +39,10 @@ xlog_print_find_oldest(
 	first_blk = 0;		/* read first block */
 	bp = xlog_get_bp(log, 1);
 	xlog_bread_noalign(log, 0, 1, bp);
-	first_half_cycle = xlog_get_cycle(XFS_BUF_PTR(bp));
+	first_half_cycle = xlog_get_cycle((char *)bp->b_addr);
 	*last_blk = log->l_logBBsize-1;	/* read last block */
 	xlog_bread_noalign(log, *last_blk, 1, bp);
-	last_half_cycle = xlog_get_cycle(XFS_BUF_PTR(bp));
+	last_half_cycle = xlog_get_cycle((char *)bp->b_addr);
 	ASSERT(last_half_cycle != 0);
 
 	if (first_half_cycle == last_half_cycle) /* all cycle nos are same */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index bc383458..15545ad1 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -275,9 +275,10 @@ newfile(
 		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 		bp = libxfs_trans_get_buf(logit ? tp : 0, mp->m_dev, d,
 			nb << mp->m_blkbb_log, 0);
-		memmove(XFS_BUF_PTR(bp), buf, len);
+		memmove(bp->b_addr, buf, len);
 		if (len < XFS_BUF_COUNT(bp))
-			memset(XFS_BUF_PTR(bp) + len, 0, XFS_BUF_COUNT(bp) - len);
+			memset((char *)bp->b_addr + len, 0,
+			       XFS_BUF_COUNT(bp) - len);
 		if (logit)
 			libxfs_trans_log_buf(tp, bp, 0, XFS_BUF_COUNT(bp) - 1);
 		else
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f973b6bc..5467b901 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3299,7 +3299,7 @@ prepare_devices(
 	 */
 	buf = libxfs_getbuf(mp->m_ddev_targp, (xi->dsize - whack_blks),
 			    whack_blks);
-	memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
+	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	libxfs_purgebuf(buf);
 
@@ -3310,15 +3310,15 @@ prepare_devices(
 	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
 	 */
 	buf = libxfs_getbuf(mp->m_ddev_targp, 0, whack_blks);
-	memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
+	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	libxfs_purgebuf(buf);
 
 	/* OK, now write the superblock... */
 	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
 	buf->b_ops = &xfs_sb_buf_ops;
-	memset(XFS_BUF_PTR(buf), 0, cfg->sectorsize);
-	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
+	memset(buf->b_addr, 0, cfg->sectorsize);
+	libxfs_sb_to_disk(buf->b_addr, sbp);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	libxfs_purgebuf(buf);
 
@@ -3338,7 +3338,7 @@ prepare_devices(
 		buf = libxfs_getbuf(mp->m_rtdev_targp,
 				    XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				    BTOBB(cfg->blocksize));
-		memset(XFS_BUF_PTR(buf), 0, cfg->blocksize);
+		memset(buf->b_addr, 0, cfg->blocksize);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 		libxfs_purgebuf(buf);
 	}
@@ -3382,8 +3382,8 @@ initialise_ag_headers(
 			XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1));
 	buf->b_ops = &xfs_sb_buf_ops;
-	memset(XFS_BUF_PTR(buf), 0, cfg->sectorsize);
-	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
+	memset(buf->b_addr, 0, cfg->sectorsize);
+	libxfs_sb_to_disk(buf->b_addr, sbp);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 	/*
diff --git a/repair/agheader.c b/repair/agheader.c
index cce376f2..1f6c82f3 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -290,8 +290,8 @@ secondary_sb_whack(
 			+ sizeof(sb->sb_dirblklog);
 
 	/* Check the buffer we read from disk for garbage outside size */
-	for (ip = XFS_BUF_PTR(sbuf) + size;
-	     ip < XFS_BUF_PTR(sbuf) + mp->m_sb.sb_sectsize;
+	for (ip = (char *)sbuf->b_addr + size;
+	     ip < (char *)sbuf->b_addr + mp->m_sb.sb_sectsize;
 	     ip++)  {
 		if (*ip)  {
 			do_bzero = 1;
@@ -314,7 +314,7 @@ secondary_sb_whack(
 			memcpy(&tmpuuid, &sb->sb_meta_uuid, sizeof(uuid_t));
 			memset((void *)((intptr_t)sb + size), 0,
 				mp->m_sb.sb_sectsize - size);
-			memset(XFS_BUF_PTR(sbuf) + size, 0,
+			memset((char *)sbuf->b_addr + size, 0,
 				mp->m_sb.sb_sectsize - size);
 			/* Preserve meta_uuid so we don't fail uuid checks */
 			memcpy(&sb->sb_meta_uuid, &tmpuuid, sizeof(uuid_t));
@@ -486,7 +486,7 @@ verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 	int status = XR_OK;
 	int status_sb = XR_OK;
 
-	status = verify_sb(sbuf->b_addr, sb, (i == 0));
+	status = verify_sb((char *)sbuf->b_addr, sb, (i == 0));
 
 	if (status != XR_OK)  {
 		do_warn(_("bad on-disk superblock %d - %s\n"),
diff --git a/repair/phase6.c b/repair/phase6.c
index 1a398aa1..65d2fd9e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -632,7 +632,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 			return(1);
 		}
 
-		memmove(XFS_BUF_PTR(bp), bmp, mp->m_sb.sb_blocksize);
+		memmove(bp->b_addr, bmp, mp->m_sb.sb_blocksize);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
@@ -704,7 +704,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 			return(1);
 		}
 
-		memmove(XFS_BUF_PTR(bp), smp, mp->m_sb.sb_blocksize);
+		memmove(bp->b_addr, smp, mp->m_sb.sb_blocksize);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 9c68e35c..0783d225 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -591,7 +591,7 @@ pf_batch_read(
 				size = XFS_BUF_SIZE(bplist[i]);
 				if (len < size)
 					break;
-				memcpy(XFS_BUF_PTR(bplist[i]), pbuf, size);
+				memcpy(bplist[i]->b_addr, pbuf, size);
 				bplist[i]->b_flags |= (LIBXFS_B_UPTODATE |
 						       LIBXFS_B_UNCHECKED);
 				len -= size;
-- 
2.14.3

