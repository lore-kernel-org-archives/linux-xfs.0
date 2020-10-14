Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A150C433E7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 07:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB27421582
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 07:46:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORStpUon"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgJNHqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 03:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbgJNHqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 03:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602661596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=XcNW/K3AjZFgZbr6jJTJu5tzNewi2ohDYamLCbqh4aQ=;
        b=ORStpUonpErg11wbxCfzLUc0hOSj3yjHF1JCh6iRsflrb2QY29ofvgsJSpTXmtIgyUc18z
        RPqFMgj8NiLg+BtSjP1eLg/1M09EI6tswx9pa/T0N2Mx04+cGjFZVSLJhsGlQuVWcK+AH0
        yNyB4sW3GSHDSQ6+BJ1+8CxKRRnrgX8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-wcQFJwvgPW-Uxop0MY7CpA-1; Wed, 14 Oct 2020 03:46:34 -0400
X-MC-Unique: wcQFJwvgPW-Uxop0MY7CpA-1
Received: by mail-pf1-f198.google.com with SMTP id f15so1315913pfj.19
        for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2020 00:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XcNW/K3AjZFgZbr6jJTJu5tzNewi2ohDYamLCbqh4aQ=;
        b=Bwft0v4vTaBevtqOwUNCYwFNiAvjyq2OIfUcynhXp+8DCjvcU2CbO0ueNk8oqCY6DQ
         K0SQX88zPo1fX5QLJQO7gEOacL268f2qaWqS+d5XNNhCLQ1XzMncdxC7CtxCYfIMPRDS
         7Or3KTlxtDWKPmsKT3B1OLM1CpjOXg1i76PLEmSU1tR4KT3SbmzdKDALNgRMPqX8SZ2W
         IERPYQ1BA8H48gFO6K9V7fFxFGOBdLbYIfMPtXMVZJY/cTefddxDHznIdj8wmgAkxY6W
         aBdc8lWXSlNWSU3pMRUPlFaV07yZkKsqsnWTfc6uYb9uhnQWQPM1U2jW47/Tr6WxD2sH
         DnKA==
X-Gm-Message-State: AOAM530ENa4vBsU+EiimvOj+z713hYkpg9j+fTt3PF020yiv8XUA7VaY
        oY5bShqzbKxk55CWYpB2e3zCR/E8lvX+zY+YOqSABgj2dSOt4eMQqaDKjsI1oVdVhUsO1zY8enM
        Gr3VZBa7+bxrpjlZl0/TG
X-Received: by 2002:a62:2985:0:b029:142:2501:35d3 with SMTP id p127-20020a6229850000b0290142250135d3mr3260898pfp.51.1602661590224;
        Wed, 14 Oct 2020 00:46:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxUSFyHRllL3ScBO7zMY/MEaMMfP48teI2zdFqIe0hp+fr0VU84+LcHHrLF07uaBniQUkS6Q==
X-Received: by 2002:a62:2985:0:b029:142:2501:35d3 with SMTP id p127-20020a6229850000b0290142250135d3mr3260881pfp.51.1602661589872;
        Wed, 14 Oct 2020 00:46:29 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e4sm1810584pjt.31.2020.10.14.00.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 00:46:29 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 RESEND] xfs: introduce xfs_validate_stripe_geometry()
Date:   Wed, 14 Oct 2020 15:45:50 +0800
Message-Id: <20201014074550.20552-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201013231359.12860-1-hsiangkao@redhat.com>
References: <20201013231359.12860-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a common helper to consolidate stripe validation process.
Also make kernel code xfs_validate_sb_common() use it first.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
[v3 RESEND]:
 sorry forget to drop a pair of unnecessary brace brackets.

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

 fs/xfs/libxfs/xfs_sb.c | 77 ++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_sb.h |  3 ++
 2 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..2078f4fe93b2 100644
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
@@ -1233,3 +1230,61 @@ xfs_sb_get_secondary(
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
+		if (!silent)
+			xfs_notice(mp,
+"stripe width (%lld) is too large", swidth);
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

