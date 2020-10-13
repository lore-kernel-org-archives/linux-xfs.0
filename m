Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468D4C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 03:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB07620797
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 03:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LeHQI2fy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgJMDts (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 23:49:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730566AbgJMDts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 23:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602560986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=SGKXjZz82w8vZ2kzN44JA780p4CjjI+JiUl1MBhwae8=;
        b=LeHQI2fycu+sbxk7aPNRBpWvLfqsJrGUKC7r4sPvNd6hdmKE0SspOc+yLuWgOJmb1CZQ5V
        nNeQaneI33CpkiFXjI/rShw5aziyQubg2+I6I0iHoipO6KzEBOkxeb3BtNx4MdrCUZzORE
        2Y7KWKNuYM28tWTYdFrV3zQo5u+cxGg=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-s7SjOfnyNMaUbRRDMYrPyQ-1; Mon, 12 Oct 2020 23:49:44 -0400
X-MC-Unique: s7SjOfnyNMaUbRRDMYrPyQ-1
Received: by mail-pg1-f199.google.com with SMTP id e13so13826011pgk.6
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 20:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SGKXjZz82w8vZ2kzN44JA780p4CjjI+JiUl1MBhwae8=;
        b=B8tgt1z1pHfHCxBVod9F/hDbB/RpMt6lWE5wlawdtQsf0YeL0infLlWdAXYL6PCmby
         zw9hlcVWD7GWM5ukOfSsReII2qJuQOf8LeurhulhKYnSGPK+pFIZ0zL+YMbgRNhmlmpJ
         eo6OPn5qH3XLURH1l+g6o2tg2eA95csuYtab6W/6vQ1Xh0WfQeXPmtg/IAw1WJFE9KJv
         VLYT0z4zcJu+RX9J6MSbyZs0pQYGDVxZTIkxgxQWUxr36YjB51BJJcfTmELa6plMkkVc
         hGIV9x86ITnQROg92VF5rgIAPn5JcBvPqblFp4wvdTrckBTML8+7tQAmVng/jFvjRYyI
         8dGg==
X-Gm-Message-State: AOAM533A53tIueIg6Q8o332w+IiBz4qoaU4/yICk4cJClZHj5FX7UHn3
        dN+H2w286A9L5eWegswy6tp6x3LFZCOsdbuuy0ih/gKzM4CyX+urbhFy3kGjjcxupVsz9p+IQT/
        tX4E0ccHtOpY9Z6YyDMUi
X-Received: by 2002:a17:90a:b38f:: with SMTP id e15mr23810401pjr.226.1602560983118;
        Mon, 12 Oct 2020 20:49:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoooUt5HIqkYB5A4ff3+zamKliVnicWR8T/d2sGw/eo7Z28xYg1PYzJk+9Lc1AumuK2/C8kA==
X-Received: by 2002:a17:90a:b38f:: with SMTP id e15mr23810365pjr.226.1602560982731;
        Mon, 12 Oct 2020 20:49:42 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h13sm2893604pgs.66.2020.10.12.20.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 20:49:42 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2] xfs: introduce xfs_validate_stripe_geometry()
Date:   Tue, 13 Oct 2020 11:48:53 +0800
Message-Id: <20201013034853.28236-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a common helper to consolidate stripe validation process.
Also make kernel code xfs_validate_sb_common() use it first.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v1: https://lore.kernel.org/r/20201009050546.32174-1-hsiangkao@redhat.com

changes since v1:
 - rename the helper to xfs_validate_stripe_geometry() (Brian);
 - drop a new added trailing newline in xfs_sb.c (Brian);
 - add a "bool silent" argument to avoid too many error messages (Brian).

 fs/xfs/libxfs/xfs_sb.c | 70 +++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_sb.h |  3 ++
 2 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..9178715ded45 100644
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
 
+	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
+			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
+		return -EFSCORRUPTED;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
@@ -1233,3 +1230,54 @@ xfs_sb_get_secondary(
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
+	if (sectorsize && sunit % sectorsize) {
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
+	if (sunit > swidth) {
+		if (!silent)
+			xfs_notice(mp,
+"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
+		return false;
+	}
+
+	if (sunit && (swidth % sunit)) {
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

