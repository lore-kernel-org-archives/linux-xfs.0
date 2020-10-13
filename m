Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE7EC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB51D20872
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Arw5jQP/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbgJMELL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 00:11:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbgJMELL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 00:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602562269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=e0Ho3gTT+bD1Vp9eXOFKLa5PxZrq4CUfDs6DXUKaQnw=;
        b=Arw5jQP//k+mBOFxmNMCgwFARymsE4NoJAcIvAe7kYNLNHQQ5sQrhy90Ion6+KKtfDoq56
        tIbav505sd14B+QIxy2znWThWsVXzGF/HS/TiGp22ZDpWU7UPs0CECvcI+rjUIkFVz1+16
        J4hacc+kFye9OBD8jxP2YCRTXFaMFoY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-TCMLRgjIP1SgyNtzS4h0qw-1; Tue, 13 Oct 2020 00:11:06 -0400
X-MC-Unique: TCMLRgjIP1SgyNtzS4h0qw-1
Received: by mail-pl1-f199.google.com with SMTP id b5so13422625plk.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 21:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e0Ho3gTT+bD1Vp9eXOFKLa5PxZrq4CUfDs6DXUKaQnw=;
        b=hYp9dhEdqpEjlH1Y8shiNkxCGj1xXSTLxgVq5XNexATiwqL/KdGli63HWm+foStj0s
         LzkkJSw7SWkzFnf9OXQQz0YfbYGbiVUQ6LqBxXlD9Lmg8V6NoriyXFwb6xZ6da4CvmjO
         nECtPYdjHgoQN7Qb9KGpQ9rohpqDd0m3eRTpd1YxOSxwRdr6GLdFvBCSk1wC3yc+8vdP
         OqmG4c8h5bL4ufJd1D3XABvOnYiiqciB8Qtk6MB+CyIvRX0JK2jBV1V3NXViNI/qV+Ru
         9WZ+JEjwb0t10kBgv1ZpJF88ZoCQf/Jf0MUpyJsArefOLqboLjLu6t1X0pa2u/gSG5MX
         RqqQ==
X-Gm-Message-State: AOAM532E/Ivf909PoyxpwV8m7tJWluwae96hySF47vLDobEBwlq6W4s+
        uyHiitTZ8v86zCyJO2SMTpQkbfW5HxoF3trIcSqzjKNRtArl1IZlpLWLCFca/cPalRXjQPWCInE
        p4P4hfXu+RCHnCC2pkFRT
X-Received: by 2002:a17:902:c1d2:b029:d3:e6e9:c391 with SMTP id c18-20020a170902c1d2b02900d3e6e9c391mr26430178plc.49.1602562265615;
        Mon, 12 Oct 2020 21:11:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzee5FsmJYlAHcOOLXXQ+vGvdXjD/XX1RIhVKdcytEdH3bNydPMWmWAvlD9kNvRe5XvRDqNDg==
X-Received: by 2002:a17:902:c1d2:b029:d3:e6e9:c391 with SMTP id c18-20020a170902c1d2b02900d3e6e9c391mr26430165plc.49.1602562265365;
        Mon, 12 Oct 2020 21:11:05 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm20387615pgi.91.2020.10.12.21.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 21:11:04 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 2/3] xfs: introduce xfs_validate_stripe_geometry()
Date:   Tue, 13 Oct 2020 12:06:26 +0800
Message-Id: <20201013040627.13932-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201013040627.13932-1-hsiangkao@redhat.com>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a common helper to consolidate stripe validation process.
Also make kernel code xfs_validate_sb_common() use it first.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/xfs_sb.c | 70 +++++++++++++++++++++++++++++++++++++++++--------
 libxfs/xfs_sb.h |  3 +++
 2 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 302eea16..9c1481d8 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -357,21 +357,18 @@ xfs_validate_sb_common(
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
@@ -1208,3 +1205,54 @@ xfs_sb_get_secondary(
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
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 92465a9a..f79f9dc6 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
+extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
+		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+
 #endif	/* __XFS_SB_H__ */
-- 
2.18.1

