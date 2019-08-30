Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71545C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EED421670
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KmRKrM88"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfH3KYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:24:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34678 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfH3KYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nd4/H5VkrAcBzF4aQIJMzKbM8nv5cEPWSBtHZ0JHfVA=; b=KmRKrM88FwbPjo6AZdPOghITs
        W8sLqW/eyYcqSnk69fX/or3h9PnVdFFUgPsTUhJ24gfyk+WhPCU1GTf3GQ5tb8onGIUtehdIgehrB
        fmR7qQnNgimfQ5zeap9j6PCeyfzxa4vRkDzm86jdF6zr0XtBNPf43wZVG7RK2TH2alrgS5T8T54eG
        5aSxLmkr8tWPg4CwrtppMVmxXV0IP9tklJFJHtY6Kk6LyiRqD85P29XlwttcrMysIdQoBWd94wm92
        70Auerd7Yo4kNfEJu41pI+oySthPM7BJRaZ5ZxUbbckm5vCS6qy6UT758uVLlVLeEmyDPnnjBvbGR
        UAUHqW3rQ==;
Received: from [2001:4bb8:180:3f4c:863:2ead:e9d4:da9f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3e4m-0003oV-Qc
        for linux-xfs@vger.kernel.org; Fri, 30 Aug 2019 10:24:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Date:   Fri, 30 Aug 2019 12:24:09 +0200
Message-Id: <20190830102411.519-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190830102411.519-1-hch@lst.de>
References: <20190830102411.519-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a helper that validates the startblock is valid.  This checks for a
non-zero block on the main device, but skips that check for blocks on
the realtime device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/libxfs/xfs_bmap.h | 3 +++
 fs/xfs/xfs_iomap.c       | 6 +++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 05aedf4a538c..80b25e21e708 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4519,7 +4519,7 @@ xfs_bmapi_convert_delalloc(
 	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
 		goto out_finish;
 	error = -EFSCORRUPTED;
-	if (WARN_ON_ONCE(!bma.got.br_startblock && !XFS_IS_REALTIME_INODE(ip)))
+	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
 		goto out_finish;
 
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index c409871a096e..7efa56e8750f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -171,6 +171,9 @@ static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
 		!isnullstartblock(irec->br_startblock);
 }
 
+#define xfs_valid_startblock(ip, startblock) \
+	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))
+
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3a4310d7cb59..f780e223b118 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -58,7 +58,7 @@ xfs_bmbt_to_iomap(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (unlikely(!imap->br_startblock && !XFS_IS_REALTIME_INODE(ip)))
+	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
 		return xfs_alert_fsblock_zero(ip, imap);
 
 	if (imap->br_startblock == HOLESTARTBLOCK) {
@@ -297,7 +297,7 @@ xfs_iomap_write_direct(
 		goto out_unlock;
 	}
 
-	if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
+	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
 		error = xfs_alert_fsblock_zero(ip, imap);
 
 out_unlock:
@@ -814,7 +814,7 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip)))
+		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock)))
 			return xfs_alert_fsblock_zero(ip, &imap);
 
 		if ((numblks_fsb = imap.br_blockcount) == 0) {
-- 
2.20.1

