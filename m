Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16D3C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E5A220B1F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKY5FVF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgJMXOu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:14:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727344AbgJMXOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 19:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602630888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=v+nDGrKXRkauai9bbQI0dTlrDFejpRSbGmXDJqymDmo=;
        b=dKY5FVF6mcRZ5spjFcd3PaUO6oezBn/Uu/bxTOAOA+u/kKfgl69tYTGTAW6c8UnayMzmHj
        j+UmzEmfqb6tXhrkMpdnmIoU0pzaRw/6d5IMkCdhPecRffB1fVqwjKjP67mCvYl5wSTlJ8
        +nSqGOe3pTXvQrUIMFGlrtBtjzTpeoc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-HzibYN7EMWu6SOEXpkKmPQ-1; Tue, 13 Oct 2020 19:14:46 -0400
X-MC-Unique: HzibYN7EMWu6SOEXpkKmPQ-1
Received: by mail-pj1-f70.google.com with SMTP id co16so283965pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 16:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v+nDGrKXRkauai9bbQI0dTlrDFejpRSbGmXDJqymDmo=;
        b=I9MKrr+73loqF0nGOYCv3ExaM5+Np93jX0kUbS1qhTNqG5OLxDIq0LJd97PR6HkwQ7
         YclaJQzxuZMVbi8mZeN1AYHDiNC2cE3b4kMAXPWUISw8rIYa025O4TaxI9dT5yEizu0B
         XVtjE2PBvBApKkjMxjuWwyrbvOSl3KQWESqdNHUZ3dyh1ehi58T7MvLmRkyVbKE4kUnw
         9+7qxuKgSnRTuPVgptA7IyiaLtolWxkr87dEfJuzx3o99nXDMXWX2mZwAo0fKTVGBq9O
         FM6ze/cpxBtfW+ZuMc5zy8sN9mi3oc0Mkog7fI8f9LmAKjWMLpcNrNcaEm+2bSSf3Vxx
         H1iQ==
X-Gm-Message-State: AOAM533Gsx3CsbxJ3ssg/IHDJQRP0nnK22CaKqc9bVCggwYJFzHf5rUT
        LIto6W7xAeghC7Mj5T981k2STJovwta8NvqTxVrOgSTJoerc8YJTZ5ajKgv0LMCC/ndSb8/6avN
        7pm2d49AvMojr6suNuLt0
X-Received: by 2002:a17:90a:fa8c:: with SMTP id cu12mr598756pjb.99.1602630885302;
        Tue, 13 Oct 2020 16:14:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAUrahKLY7C2mb2y8s9/5LcfRfpBUqmvwuYiGg53N8sUnLKXEINpewWCkjLc59Y8zdG8MwXA==
X-Received: by 2002:a17:90a:fa8c:: with SMTP id cu12mr598732pjb.99.1602630885021;
        Tue, 13 Oct 2020 16:14:45 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j4sm754141pfd.101.2020.10.13.16.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 16:14:44 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3] xfs: introduce xfs_validate_stripe_geometry()
Date:   Wed, 14 Oct 2020 07:13:59 +0800
Message-Id: <20201013231359.12860-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a common helper to consolidate stripe validation process.
Also make kernel code xfs_validate_sb_common() use it first.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v2: https://lore.kernel.org/r/20201013034853.28236-1-hsiangkao@redhat.com

Changes since v2:
 - update the expression on sb_unit and hasdalign check (Brian);
 - drop parentheses since modulus operation is a basic
   math operation (Brian);
 - (I missed earlier..) avoid div_s64_rem on modulus operation
   by checking swidth, sunit range first and casting to 32-bit
   integer. since sunit/swidth in the callers are in FSB or BB,
   so need to check the overflow first...

 Anyway, since logic change is made due to div_s64_rem() issue,
 please kindly help review again...

Thanks,
Gao Xiang


 fs/xfs/libxfs/xfs_sb.c | 78 ++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_sb.h |  3 ++
 2 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..fe424f872822 100644
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
+	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
 		xfs_notice(mp, "SB stripe alignment sanity check failed");
 		return -EFSCORRUPTED;
-	} else if (sbp->sb_width) {
-		xfs_notice(mp, "SB stripe width sanity check failed");
-		return -EFSCORRUPTED;
 	}
 
+	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
+			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
+		return -EFSCORRUPTED;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
@@ -1233,3 +1230,62 @@ xfs_sb_get_secondary(
 	*bpp = bp;
 	return 0;
 }
+
+/*
+ * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
+ * so users won't be confused by values in error messages.
+ */
+bool
+xfs_validate_stripe_geometry(
+	struct xfs_mount	*mp,
+	__s64			sunit,
+	__s64			swidth,
+	int			sectorsize,
+	bool			silent)
+{
+	if (swidth > INT_MAX) {
+		if (!silent) {
+			xfs_notice(mp,
+"stripe width (%lld) is too large", swidth);
+		}
+		return false;
+	}
+
+	if (sunit > swidth) {
+		if (!silent)
+			xfs_notice(mp,
+"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
+		return false;
+	}
+
+	if (sectorsize && (int)sunit % sectorsize) {
+		if (!silent)
+			xfs_notice(mp,
+"stripe unit (%lld) must be a multiple of the sector size (%d)",
+				   sunit, sectorsize);
+		return false;
+	}
+
+	if (sunit && !swidth) {
+		if (!silent)
+			xfs_notice(mp,
+"invalid stripe unit (%lld) and stripe width of 0", sunit);
+		return false;
+	}
+
+	if (!sunit && swidth) {
+		if (!silent)
+			xfs_notice(mp,
+"invalid stripe width (%lld) and stripe unit of 0", swidth);
+		return false;
+	}
+
+	if (sunit && (int)swidth % (int)sunit) {
+		if (!silent)
+			xfs_notice(mp,
+"stripe width (%lld) must be a multiple of the stripe unit (%lld)",
+				   swidth, sunit);
+		return false;
+	}
+	return true;
+}
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 92465a9a5162..f79f9dc632b6 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
+extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
+		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+
 #endif	/* __XFS_SB_H__ */
-- 
2.18.1

