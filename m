Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DE5C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B9221D6C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LFUlTw2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgJIFGl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:06:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbgJIFGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 01:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602219999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=2lpvlfS1kU3fLfausn+2ajVbetB7HLcHMAo5tDRf7l4=;
        b=LFUlTw2qMASU7TjqnVBBFTNzCihgkCooI7IdsGniktzxbnRCfcgyChSgQQVOYJX9APjItb
        eTHQyhZqB8fObXLG4jJ9tx2XPihLKTodfw2jvO5IB+WnBul32p8URAIu+uvD9EgIZVcmur
        U3S1bLJ3b+agDEb3Otg5fbzzK2IamEE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-jx6gQJxQMsy-kyI9EtQjig-1; Fri, 09 Oct 2020 01:06:38 -0400
X-MC-Unique: jx6gQJxQMsy-kyI9EtQjig-1
Received: by mail-pg1-f199.google.com with SMTP id g5so5709370pgn.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 22:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2lpvlfS1kU3fLfausn+2ajVbetB7HLcHMAo5tDRf7l4=;
        b=jJqLAiqnghTaNAdoibQgzSJReBNKbvNF0QF51MSyBxkJ2QAv2+7H31xoPN9GjkAWif
         /W7yOcL/GR8dfvvJdefpgfbu8V7to1tHvScxvoKVeKJ8zludC/0raUx9P9KdbjA8iyhq
         4fk0LHMHDL/YZ/MyOCsNcEUzjFcLuwnVUO6n/NVjkLNPP4hb28beT1aF+hxRlx0NUniM
         1ZUY9ow7j4EwHeVg8+GE5Gtkr7rThU8RkCZpuABEiDxUzg4Voi2iOAbnaN2Kk5ypH1zp
         nmUOC+gOOALnJF/uSUz/JBI8B1ADm4xcS71X4aX4zD4WaQA3ccHdqIvit+zQbkZZQJsx
         blJQ==
X-Gm-Message-State: AOAM530HQIgPRTw8tP0F9F0zGPBZt0wlM2U+eagpoiBIKcXrkdHEoHr7
        OTtz2/B6y7UGTSXMpQ+6nRwEafx3R+W2lXAgVxKS4jvwKYO+sEhUxUBUqr7SGa0YJYxEiSNpjLF
        PQr0Ulco55mlVvfC+7mJK
X-Received: by 2002:a62:e104:0:b029:152:4f37:99da with SMTP id q4-20020a62e1040000b02901524f3799damr10605776pfh.17.1602219996836;
        Thu, 08 Oct 2020 22:06:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLaGCYEEzF8EjZeMg4PyvF9sOYLY6s9+0u1lExSkb7by7sLc0hwfYK0n/FJvBwUmXXsJjRJA==
X-Received: by 2002:a62:e104:0:b029:152:4f37:99da with SMTP id q4-20020a62e1040000b02901524f3799damr10605761pfh.17.1602219996533;
        Thu, 08 Oct 2020 22:06:36 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b3sm956348pjz.57.2020.10.08.22.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 22:06:35 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] xfs: introduce xfs_validate_stripe_factors()
Date:   Fri,  9 Oct 2020 13:05:46 +0800
Message-Id: <20201009050546.32174-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a common helper to consolidate stripe validation process.
Also make kernel code xfs_validate_sb_common() use it first.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---

kernel side of:
https://lore.kernel.org/r/20201007140402.14295-3-hsiangkao@aol.com
with update suggested by Darrick:
 - stretch columns for commit message;
 - add comments to hasdalign check;
 - break old sunit / swidth != 0 check into two seperate checks;
 - update an error message description.

also use bytes for sunit / swidth representation, so users can
see values in the unique unit.

see
https://lore.kernel.org/r/20201007140402.14295-1-hsiangkao@aol.com
for the background.

 fs/xfs/libxfs/xfs_sb.c | 65 +++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_sb.h |  3 ++
 2 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..cb2a7aa0ad51 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -360,21 +360,18 @@ xfs_validate_sb_common(
 		}
 	}
 
-	if (sbp->sb_unit) {
-		if (!xfs_sb_version_hasdalign(sbp) ||
-		    sbp->sb_unit > sbp->sb_width ||
-		    (sbp->sb_width % sbp->sb_unit) != 0) {
-			xfs_notice(mp, "SB stripe unit sanity check failed");
-			return -EFSCORRUPTED;
-		}
-	} else if (xfs_sb_version_hasdalign(sbp)) {
+	/*
+	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
+	 * would imply the image is corrupted.
+	 */
+	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
 		xfs_notice(mp, "SB stripe alignment sanity check failed");
 		return -EFSCORRUPTED;
-	} else if (sbp->sb_width) {
-		xfs_notice(mp, "SB stripe width sanity check failed");
-		return -EFSCORRUPTED;
 	}
 
+	if (!xfs_validate_stripe_factors(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
+					 XFS_FSB_TO_B(mp, sbp->sb_width), 0))
+		return -EFSCORRUPTED;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
@@ -1233,3 +1230,49 @@ xfs_sb_get_secondary(
 	*bpp = bp;
 	return 0;
 }
+
+/*
+ * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
+ * so users won't be confused by values in error messages.
+ */
+bool
+xfs_validate_stripe_factors(
+	struct xfs_mount	*mp,
+	__s64			sunit,
+	__s64			swidth,
+	int			sectorsize)
+{
+	if (sectorsize && sunit % sectorsize) {
+		xfs_notice(mp,
+"stripe unit (%lld) must be a multiple of the sector size (%d)",
+			   sunit, sectorsize);
+		return false;
+	}
+
+	if (sunit && !swidth) {
+		xfs_notice(mp,
+"invalid stripe unit (%lld) and stripe width of 0", sunit);
+		return false;
+	}
+
+	if (!sunit && swidth) {
+		xfs_notice(mp,
+"invalid stripe width (%lld) and stripe unit of 0", swidth);
+		return false;
+	}
+
+	if (sunit > swidth) {
+		xfs_notice(mp,
+"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
+		return false;
+	}
+
+	if (sunit && (swidth % sunit)) {
+		xfs_notice(mp,
+"stripe width (%lld) must be a multiple of the stripe unit (%lld)",
+			   swidth, sunit);
+		return false;
+	}
+	return true;
+}
+
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 92465a9a5162..2d3504eb9886 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
+extern bool	xfs_validate_stripe_factors(struct xfs_mount *mp,
+				__s64 sunit, __s64 swidth, int sectorsize);
+
 #endif	/* __XFS_SB_H__ */
-- 
2.18.1

