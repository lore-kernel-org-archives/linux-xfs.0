Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BFFC4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C083206F8
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cr9k1X6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCF5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:57:05 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A096AC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:57:05 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id p21so2460201pju.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=druk7Lat4GoRfwFJZReJkIQMKuIUdAgXOVtXjP44X6M=;
        b=cr9k1X6cwssjwh/97koyagFcsOmnegJ+Rsw1LBNeRBKHaghp3w2hdnkds35s1gCEKx
         q8zpOHUtYln4rhMxYjW0M2lYR95oNQvlYQmx3tPzx3PZZytHcIkxq80UMv1UetAFk5SJ
         Ii95sVpL9IcY+jjC9m7hey4vHkjwl6hgQWDuo+NeJfyGQ3/JEWYOF9Jjq2R7rkRMIuXA
         2CPbQTZoNxwm0ZIEaEtwyHMnoidFRtniovvDHhncWCkgmcYTwpeHuMVaGuabehRoD2WG
         JGgjt9CA9cnoQze989eBAta4dSA48nf2xngAat9B8ahpQI5sTwAS0jfjEJg21r6W5vwW
         IQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=druk7Lat4GoRfwFJZReJkIQMKuIUdAgXOVtXjP44X6M=;
        b=UAdB4jtxw1CG6MieJX2qtk8E06oEuz5y97fx3A+on+7Vaw+E3hHue8y6sg+F+C28QK
         MGOvsJ7/Zcc7+Ane+h4dLRiEJxWKzmYQmlGBmy3BHcphpAlGifeMWrC7+IbIOFrVxgYO
         kSmLrrZFY+tpJPG3ylQw6yhyQ6oiHky1YayWn1rdgGnpPWIigp77+wYddxw/lM78lxaZ
         BY4Ng0Gc7tuXPqj9xxArNqmoyhbtzriawtW79iv7cYU+d55SQG97SzExjk3rUXhDPb9q
         IWo4ngaJfV5JhWFXcEjcuj4kT5DmdACqr/gaqJZy2SUwKQM6p6Fp41L24IibjQIZLnFf
         SLAg==
X-Gm-Message-State: AOAM532b2P+xFfTSQIGQ0pc+v1rLcG15vOHmX3ImWej8EjK2I1i1p9Ti
        96wG1IVPWbYr28sq7VI0nR68+TZOMbCj3g==
X-Google-Smtp-Source: ABdhPJz3XpBHgz0fmBus37T3bykLhJF7fURcULgyA7gNqzSxAIPshNupwnCBjqnZY2hRYAWwtXrISA==
X-Received: by 2002:a17:90a:7486:: with SMTP id p6mr6406794pjk.162.1601704624891;
        Fri, 02 Oct 2020 22:57:04 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:57:04 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 08/12] xfs: Check for extent overflow when remapping an extent
Date:   Sat,  3 Oct 2020 11:26:29 +0530
Message-Id: <20201003055633.9379-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remapping an extent involves unmapping the existing extent and mapping
in the new extent. When unmapping, an extent containing the entire unmap
range can be split into two extents,
i.e. | Old extent | hole | Old extent |
Hence extent count increases by 1.

Mapping in the new extent into the destination file can increase the
extent count by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 15 +++++++++++++++
 fs/xfs/xfs_reflink.c           |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index b99e67e7b59b..ded3c1b56c94 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -87,6 +87,21 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
+/*
+ * Remapping an extent involves unmapping the existing extent and mapping in the
+ * new extent.
+ *
+ * When unmapping, an extent containing the entire unmap range can be split into
+ * two extents,
+ * i.e. | Old extent | hole | Old extent |
+ * Hence extent count increases by 1.
+ *
+ * Mapping in the new extent into the destination file can increase the extent
+ * count by 1.
+ */
+#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
+	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4f0198f636ad..c9f9ff68b5bb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1099,6 +1099,11 @@ xfs_reflink_remap_extent(
 			goto out_cancel;
 	}
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written));
+	if (error)
+		goto out_cancel;
+
 	if (smap_real) {
 		/*
 		 * If the extent we're unmapping is backed by storage (written
-- 
2.28.0

