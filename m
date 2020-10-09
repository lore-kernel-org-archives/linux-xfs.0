Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1E6C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21FE521D46
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6g7kpeJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgJIFZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730449AbgJIFZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 01:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602221116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=xulYLBULP8Nk/nf4mHgO/TqbRK1WjTSep+paJ2G1iPs=;
        b=b6g7kpeJGdNXn4am0dRjsCL9HmNfAn5bCEDLyaSDTTu6IwsQTIF8g9o+nmtPhwKuRrvNfl
        4C3fjFBaS6F7zSiZwWiZNhW271Q9s+O0hG8JoMziQ5Dz56PRUr29viqVZ66nBGqbA7m87b
        7orenSc0tbRCBIaMDIyXZXhRtcSYaL4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-9wjn9ydGOyaNlIM_7ZKkKg-1; Fri, 09 Oct 2020 01:25:14 -0400
X-MC-Unique: 9wjn9ydGOyaNlIM_7ZKkKg-1
Received: by mail-pg1-f200.google.com with SMTP id j13so5693326pgp.11
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 22:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xulYLBULP8Nk/nf4mHgO/TqbRK1WjTSep+paJ2G1iPs=;
        b=hwoSxtSyG/v/QFPxd/yTGxnhwbRjnhOu8sgoPB80bie8t9zBJzY4huVc5iITS6gDIR
         HCSxru/S8ur7TRpS4gcibomi65Hrjd2YtEblYIZUmTThPIPL0PCox1EUh05IkVVhteSE
         Du736U2KoZMdwcC1fD+j7F+07mWD7e2q2EG7y83TIensLus+q7vGAcO7T7UB4xY7EPWL
         dS0PHjRYV7AXbjOO//zTZRm0go1YBhA7nnwyEkAkUW0GjxkqWXkS2W0UyQKcU/zJmxQZ
         JYDvVmfMamYtEymslFtT7ZURTk7CZ1tDUMOOKRoRO1H0MYNQhIuj1c+p2j2u81KGqF0O
         FEvw==
X-Gm-Message-State: AOAM531ZwTxsC8qq0nAQOQBSZi/sThXVkeyMrOuD34PX90QWl5GPbPBn
        zoP1qOVMLo0ia6zhEr4NuTPR7fpbXotOwONvYxN3/8BaId3jB656PUtEj7qYqYzqOysHUrCnY/H
        QXDo8zqgDM6AgBCTgjNKR
X-Received: by 2002:a17:90a:6f21:: with SMTP id d30mr2611770pjk.165.1602221113536;
        Thu, 08 Oct 2020 22:25:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytJ3iTNOqhul6SVGogVmBw7W64k6qqtNECtRkqoa9ueYKZMmlgsBRjRQMdBcRcsZ87Gn/dDw==
X-Received: by 2002:a17:90a:6f21:: with SMTP id d30mr2611748pjk.165.1602221113332;
        Thu, 08 Oct 2020 22:25:13 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm9254042pgm.29.2020.10.08.22.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 22:25:13 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 2/3] xfs: introduce xfs_validate_stripe_factors()
Date:   Fri,  9 Oct 2020 13:24:20 +0800
Message-Id: <20201009052421.3328-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201009052421.3328-1-hsiangkao@redhat.com>
References: <20201009052421.3328-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce a common helper to consolidate stripe validation process.
Also make kernel code xfs_validate_sb_common() use it first.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/xfs_sb.c | 65 ++++++++++++++++++++++++++++++++++++++++---------
 libxfs/xfs_sb.h |  3 +++
 2 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 302eea16..0f2697ed 100644
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
 
+	if (!xfs_validate_stripe_factors(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
+					 XFS_FSB_TO_B(mp, sbp->sb_width), 0))
+		return -EFSCORRUPTED;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
@@ -1208,3 +1205,49 @@ xfs_sb_get_secondary(
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
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 92465a9a..2d3504eb 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
+extern bool	xfs_validate_stripe_factors(struct xfs_mount *mp,
+				__s64 sunit, __s64 swidth, int sectorsize);
+
 #endif	/* __XFS_SB_H__ */
-- 
2.18.1

