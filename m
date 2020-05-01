Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BA1C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7ED2071C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OSpLn/Lg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgEAIOc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDF9C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=75LOrnV1h/wAx/Po+DSrG+T7yAVvh4RZwQle+vwHt4Q=; b=OSpLn/LgayIGJUUeU3KLEZpTEd
        hG1Zvg5YYHCwvyvrHsseXZOpM8slmkLeE05Quw/usuupP68iIBIHUn7Dy32pH40fmwODZiWJDRP+e
        TCRlJGjTMzyJ4RDQVI4OavztzOHwTcDei2D0n656Pt0p4fS86/EwYXv8VH+QnxwrBhHJ6cEUUrxFf
        snNA3E1Mgi5CnzmXcbccA/7Najm47A+2i0r0X/SOxdwUYiTVzE1UC/eJ7tT0C99mIjH72dPsOyclY
        EjCHVhgmsOkpKcCt79xZikuNFCMHl7TF3f8wd3QSkDYQE6WAwVkiVfjSlzlYwIZMyCYS1z+8Nl17K
        OMcT3S9w==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQoY-0002s6-Ve
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: call xfs_iformat_fork from xfs_inode_from_disk
Date:   Fri,  1 May 2020 10:14:14 +0200
Message-Id: <20200501081424.2598914-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501081424.2598914-1-hch@lst.de>
References: <20200501081424.2598914-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We always need to fill out the fork structures when reading the inode,
so call xfs_iformat_fork from the tail of xfs_inode_from_disk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 7 ++++---
 fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
 fs/xfs/xfs_log_recover.c      | 4 +---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 39c5a6e24915c..02f06dec0a5a6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -186,7 +186,7 @@ xfs_imap_to_bp(
 	return 0;
 }
 
-void
+int
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
@@ -247,6 +247,8 @@ xfs_inode_from_disk(
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
+
+	return xfs_iformat_fork(ip, from);
 }
 
 void
@@ -647,8 +649,7 @@ xfs_iread(
 	 * Otherwise, just get the truly permanent information.
 	 */
 	if (dip->di_mode) {
-		xfs_inode_from_disk(ip, dip);
-		error = xfs_iformat_fork(ip, dip);
+		error = xfs_inode_from_disk(ip, dip);
 		if (error)  {
 #ifdef DEBUG
 			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 9b373dcf9e34d..081230faf7bdc 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -54,7 +54,7 @@ int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
-void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
+int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 11c3502b07b13..464388125d20b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2870,9 +2870,7 @@ xfs_recover_inode_owner_change(
 
 	/* instantiate the inode */
 	ASSERT(dip->di_version >= 3);
-	xfs_inode_from_disk(ip, dip);
-
-	error = xfs_iformat_fork(ip, dip);
+	error = xfs_inode_from_disk(ip, dip);
 	if (error)
 		goto out_free_ip;
 
-- 
2.26.2

