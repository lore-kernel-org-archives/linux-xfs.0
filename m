Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242B6CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2ACE21D71
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OCwBdMLi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436922AbfJYPEh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:04:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48698 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436893AbfJYPEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 11:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BDke9cMGvfFRvGhziExbaIWQmTizMHYxI38TFAEqXVY=; b=OCwBdMLiy33OkeaTJv6jJnqrp
        /RbuvB1R7VkixseEQbRTBQfopPvGiSZsF+U96RxwhVMaCcISgq2d09NphtVinGHaVtSI4oGZOLgxq
        xOFAIFI44gzVCeNL7N58ZsTlMkUdwFCjmngbCcHD9syTkh+jKC/ukjemX1r8NYdN9Gf/3d700/3e/
        pdrjXwiDuPEBawgcIDOSz45h287ukd70OZUKIho7da0zqs36lJAvDJ0y7/2PXU5HkEd++J4ym0ONZ
        4ZDoXAuH+zPSVgqmn3ew4cJUYhDOP5afoE3Oed39layS/sy2DuLbgo3H4C50zmEW33xCHZIt+vjGO
        3O39ZcL1A==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO18l-0006kk-Jp
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 15:04:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: simplify the xfs_iomap_write_direct calling conventions
Date:   Fri, 25 Oct 2019 17:03:33 +0200
Message-Id: <20191025150336.19411-6-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025150336.19411-1-hch@lst.de>
References: <20191025150336.19411-1-hch@lst.de>
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
---
 fs/xfs/xfs_iomap.c | 82 ++++++++++++++++------------------------------
 fs/xfs/xfs_iomap.h |  6 ++--
 fs/xfs/xfs_pnfs.c  | 25 +++++++-------
 3 files changed, 45 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e3b11cda447e..4af50b101d2b 100644
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
index fa90c6334c7c..f64996ca4870 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -142,22 +142,19 @@ xfs_fs_map_blocks(
 	lock_flags = xfs_ilock_data_map_shared(ip);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				&imap, &nimaps, bmapi_flags);
-	xfs_iunlock(ip, lock_flags);
-
-	if (error)
-		goto out_unlock;
-
-	if (write &&
+	if (!error && write &&
 	    (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
 		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
 
-		/*
-		 * xfs_iomap_write_direct() expects to take ownership of the
-		 * shared ilock.
-		 */
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		error = xfs_iomap_write_direct(ip, offset, length, &imap,
-					       nimaps);
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
 
@@ -170,6 +167,8 @@ xfs_fs_map_blocks(
 				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
 		if (error)
 			goto out_unlock;
+	} else {
+		xfs_iunlock(ip, lock_flags);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-- 
2.20.1

