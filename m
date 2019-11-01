Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE02CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C4242085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kQ3WLH7/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfKAWKC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:10:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53824 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWKC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gIeA7eN9D7Qg1XPfr2Ck2tj4qT/NiOCxQlaiumEvMo4=; b=kQ3WLH7/0JaLGWJfMV7cS+kCm
        K5XUB7puNmkM4WFXDEpZ6/mn2FSO4+G6ku3QGWl/fo8fw/vRNufnNssBXcDPenkBtl3AKAuSVnbuz
        WdCdhS73G7dAnJVWsI5rweQeQhylx752LjdumSf82L9xjbfCMISPdlAB9/nO2O7fWdsYa5QpmlUGL
        Fd+Wm0xxyBrpw3L1En+muI2tMt+lDOsTXfERSEZ8LAtuWY8/lyXKNOdHNM+vm3vfmBcCVsDg37B3h
        FZGMTgo88O+ifYmNqGxvebCiiKLp5Ni6+CTEyIslErtxLs1U9G0b0G98urPcvOSaNvGrbGxhXn2sU
        tkbu8bt1A==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf7K-0006GI-5f
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:10:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 29/34] xfs: cleanup xfs_dir2_data_entsize
Date:   Fri,  1 Nov 2019 15:07:14 -0700
Message-Id: <20191101220719.29100-30-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the XFS_DIR2_DATA_ENTSIZE and XFS_DIR3_DATA_ENTSIZE and open
code them in their only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 33 ---------------------------------
 fs/xfs/libxfs/xfs_dir2_data.c | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 0e35e613fbf3..dd2389748672 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -19,39 +19,6 @@
  * Directory data block operations
  */
 
-/*
- * For special situations, the dirent size ends up fixed because we always know
- * what the size of the entry is. That's true for the "." and "..", and
- * therefore we know that they are a fixed size and hence their offsets are
- * constant, as is the first entry.
- *
- * Hence, this calculation is written as a macro to be able to be calculated at
- * compile time and so certain offsets can be calculated directly in the
- * structure initaliser via the macro. There are two macros - one for dirents
- * with ftype and without so there are no unresolvable conditionals in the
- * calculations. We also use round_up() as XFS_DIR2_DATA_ALIGN is always a power
- * of 2 and the compiler doesn't reject it (unlike roundup()).
- */
-#define XFS_DIR2_DATA_ENTSIZE(n)					\
-	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
-		 sizeof(xfs_dir2_data_off_t)), XFS_DIR2_DATA_ALIGN)
-
-#define XFS_DIR3_DATA_ENTSIZE(n)					\
-	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
-		 sizeof(xfs_dir2_data_off_t) + sizeof(uint8_t)),	\
-		XFS_DIR2_DATA_ALIGN)
-
-int
-xfs_dir2_data_entsize(
-	struct xfs_mount	*mp,
-	int			n)
-{
-	if (xfs_sb_version_hasftype(&mp->m_sb))
-		return XFS_DIR3_DATA_ENTSIZE(n);
-	else
-		return XFS_DIR2_DATA_ENTSIZE(n);
-}
-
 static uint8_t
 xfs_dir2_data_get_ftype(
 	struct xfs_dir2_data_entry *dep)
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 81ba13854f8d..c44c455b961f 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -24,6 +24,20 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_unused *dup,
 		struct xfs_dir2_data_free **bf_ent);
 
+int
+xfs_dir2_data_entsize(
+	struct xfs_mount	*mp,
+	int			namelen)
+{
+	size_t			len;
+
+	len = offsetof(struct xfs_dir2_data_entry, name[0]) + namelen +
+			sizeof(xfs_dir2_data_off_t) /* tag */;
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		len += sizeof(uint8_t);
+	return round_up(len, XFS_DIR2_DATA_ALIGN);
+}
+
 /*
  * Pointer to an entry's tag word.
  */
-- 
2.20.1

