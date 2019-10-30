Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257D2CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C5E2087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fNBXnFn9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfJ3SE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 14:04:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbfJ3SE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8m+10NElTAlt+Oo15HYygzKlc14uk5ce4bPPt4SXPzk=; b=fNBXnFn98TgPm7PXtz/n77+rkO
        d0K2GpK2vYyvus6ab9mVucRfMGSOzhRpE5FVB9cUhLH+0JMR4wnL8Txn463XU9Kg1jPNvM94SogSE
        IG541OdZq/B0xqf1Ty0T5ZSPmGZfMFJfQ1g7QRf33uvt0YY8NPSTF2wFqbcLsrnoFjmQ2S/f/aQ5l
        GpO/kwKIY9Aio2J85gi9cGAiVtQ5PwfNEs0Tx4T0TAXkdMkJMRBRQKovslTPNmTzBxY8VkwRSEG/o
        P6E/5sda5w5nPdbOEGjdpLZrGMmHEwon905/fao/HrTZL56ssbyRovXzs4O0bgexnOFXBJNwU4AzO
        iEBFnBrw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsL5-0005fv-3k; Wed, 30 Oct 2019 18:04:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/9] xfs: simplify the xfs_iomap_write_direct calling conventions
Date:   Wed, 30 Oct 2019 11:04:16 -0700
Message-Id: <20191030180419.13045-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030180419.13045-1-hch@lst.de>
References: <20191030180419.13045-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the EOF alignment and checking for the next allocated extent into
the callers to avoid the need to pass the byte based offset and count
as well as looking at the incoming imap.  The added benefit is that
the caller can unlock the incoming ilock and the function doesn't have
funny unbalanced locking contexts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c | 82 ++++++++++++++++------------------------------
 fs/xfs/xfs_iomap.h |  6 ++--
 fs/xfs/xfs_pnfs.c  | 25 +++++++-------
 3 files changed, 46 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c21c4f7a7389..217eb44c1159 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -148,7 +148,7 @@ xfs_eof_alignment(
  * Check if last_fsb is outside the last extent, and if so grow it to the next
  * stripe unit boundary.
  */
-static xfs_fileoff_t
+xfs_fileoff_t
 xfs_iomap_eof_align_last_fsb(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		end_fsb)
@@ -185,61 +185,36 @@ xfs_iomap_eof_align_last_fsb(
 
 int
 xfs_iomap_write_direct(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	size_t		count,
-	xfs_bmbt_irec_t *imap,
-	int		nmaps)
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		count_fsb,
+	struct xfs_bmbt_irec	*imap)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_fileoff_t	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t	last_fsb = xfs_iomap_end_fsb(mp, offset, count);
-	xfs_filblks_t	count_fsb, resaligned;
-	xfs_extlen_t	extsz;
-	int		nimaps;
-	int		quota_flag;
-	int		rt;
-	xfs_trans_t	*tp;
-	uint		qblocks, resblks, resrtextents;
-	int		error;
-	int		lockmode;
-	int		bmapi_flags = XFS_BMAPI_PREALLOC;
-	uint		tflags = 0;
-
-	rt = XFS_IS_REALTIME_INODE(ip);
-	extsz = xfs_get_extsz_hint(ip);
-	lockmode = XFS_ILOCK_SHARED;	/* locked by caller */
-
-	ASSERT(xfs_isilocked(ip, lockmode));
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_filblks_t		resaligned;
+	int			nimaps;
+	int			quota_flag;
+	uint			qblocks, resblks;
+	unsigned int		resrtextents = 0;
+	int			error;
+	int			bmapi_flags = XFS_BMAPI_PREALLOC;
+	uint			tflags = 0;
 
-	if (offset + count > XFS_ISIZE(ip)) {
-		last_fsb = xfs_iomap_eof_align_last_fsb(ip, last_fsb);
-	} else {
-		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
-			last_fsb = min(last_fsb, (xfs_fileoff_t)
-					imap->br_blockcount +
-					imap->br_startoff);
-	}
-	count_fsb = last_fsb - offset_fsb;
 	ASSERT(count_fsb > 0);
-	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb, extsz);
 
-	if (unlikely(rt)) {
+	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
+					   xfs_get_extsz_hint(ip));
+	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
 		resrtextents = qblocks = resaligned;
 		resrtextents /= mp->m_sb.sb_rextsize;
 		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 		quota_flag = XFS_QMOPT_RES_RTBLKS;
 	} else {
-		resrtextents = 0;
 		resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 		quota_flag = XFS_QMOPT_RES_REGBLKS;
 	}
 
-	/*
-	 * Drop the shared lock acquired by the caller, attach the dquot if
-	 * necessary and move on to transaction setup.
-	 */
-	xfs_iunlock(ip, lockmode);
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
@@ -269,8 +244,7 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	lockmode = XFS_ILOCK_EXCL;
-	xfs_ilock(ip, lockmode);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
 	if (error)
@@ -307,7 +281,7 @@ xfs_iomap_write_direct(
 		error = xfs_alert_fsblock_zero(ip, imap);
 
 out_unlock:
-	xfs_iunlock(ip, lockmode);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
 out_res_cancel:
@@ -807,14 +781,16 @@ xfs_direct_write_iomap_begin(
 	 * lower level functions are updated.
 	 */
 	length = min_t(loff_t, length, 1024 * PAGE_SIZE);
+	end_fsb = xfs_iomap_end_fsb(mp, offset, length);
 
-	/*
-	 * xfs_iomap_write_direct() expects the shared lock. It is unlocked on
-	 * return.
-	 */
-	if (lockmode == XFS_ILOCK_EXCL)
-		xfs_ilock_demote(ip, lockmode);
-	error = xfs_iomap_write_direct(ip, offset, length, &imap, nimaps);
+	if (offset + length > XFS_ISIZE(ip))
+		end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
+	else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
+		end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
+	xfs_iunlock(ip, lockmode);
+
+	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb,
+			&imap);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index d5b292bdaf82..7d3703556d0e 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -11,9 +11,11 @@
 struct xfs_inode;
 struct xfs_bmbt_irec;
 
-int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
-			struct xfs_bmbt_irec *, int);
+int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
+		xfs_fileoff_t count_fsb, struct xfs_bmbt_irec *imap);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
+xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
+		xfs_fileoff_t end_fsb);
 
 int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *, u16);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ada46e9f5ff1..ae3f00cb6a43 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -143,21 +143,20 @@ xfs_fs_map_blocks(
 	lock_flags = xfs_ilock_data_map_shared(ip);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				&imap, &nimaps, bmapi_flags);
-	xfs_iunlock(ip, lock_flags);
-
-	if (error)
-		goto out_unlock;
 
 	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
 
-	if (write && (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
-		/*
-		 * xfs_iomap_write_direct() expects to take ownership of the
-		 * shared ilock.
-		 */
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		error = xfs_iomap_write_direct(ip, offset, length, &imap,
-					       nimaps);
+	if (!error && write &&
+	    (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
+		if (offset + length > XFS_ISIZE(ip))
+			end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
+		else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
+			end_fsb = min(end_fsb, imap.br_startoff +
+					       imap.br_blockcount);
+		xfs_iunlock(ip, lock_flags);
+
+		error = xfs_iomap_write_direct(ip, offset_fsb,
+				end_fsb - offset_fsb, &imap);
 		if (error)
 			goto out_unlock;
 
@@ -170,6 +169,8 @@ xfs_fs_map_blocks(
 				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
 		if (error)
 			goto out_unlock;
+	} else {
+		xfs_iunlock(ip, lock_flags);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-- 
2.20.1

