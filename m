Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DA3C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C31E321D7B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CWyIZCgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgIRJsl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFCBC06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so3117025pfk.2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=druk7Lat4GoRfwFJZReJkIQMKuIUdAgXOVtXjP44X6M=;
        b=CWyIZCgDsspc2WHIqDdtlkOASTRDQT4ND4pGH+Vb9ZK6FNDauVoH6DxbITK4PO7+kS
         DIHRiFESf31mzW2YSqENaTE9k6PyHBogCe9PKugT5dwvaspbyil17/GkcrKkvRu25tY9
         CXHxvZRcuj656940iVlWL7/+8JQCoi6ur6d3nGirOYE1FztQX92/J3OJ75H1OqugwOCs
         sDlPidPZ8HQo2R+FXprncXm1ceQnTI60Os9v5jpzYFp1lX8erbNgsbMIIhobbwEMSpRr
         AUUfowtzNyg+5FfLQ+6Y47i+8Ceu9hZeCXyBoGG0eYiedPldgaqoWV9YESQrb1R1W6hf
         ugsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=druk7Lat4GoRfwFJZReJkIQMKuIUdAgXOVtXjP44X6M=;
        b=pbZ67xxjIIj4krMr0ylcmj+vZ3IWCim4pyakjy4g7XVYuSdCVXrv2uIa3r594UkOu6
         6BGs1JmskEOehsdTC5PJfZnlSQyrJrMME0VCX0rKW1YOy+mDNjHf8aIKemZ/X6h74afl
         4VogK0r5414MTvQ9vk8sjNRtJjFPJt3o0nelvAyP0ryiemt93j1BRMXbNm4T+cvI2LDE
         lnxqe3sU9YAKse8Ll5ar/PtwpyIPsJDveO6flAPM5fRPs9zHv9It0srpsyW12tt0T1+e
         uMULRGvSnDFRxk0mhMloIcw4D9UHAgdoGBy+UG1UIWOc1y0GCYjN7l460WFzNjkd4dAd
         4WOQ==
X-Gm-Message-State: AOAM530LpNUDCVll+U9J6jXR7nhU+JZ97TdM0GShMflpR2f5HIYdPSgQ
        OietTddQ74ZipACbmw+JcMa8qwGbw78=
X-Google-Smtp-Source: ABdhPJw0Nic4e7lw5QV7WqO8qK+ZtcrlkSRCKkpPmv4WnZl7PyigkPmVKa7fP3J87tRTzy2xYONykQ==
X-Received: by 2002:a63:ec4c:: with SMTP id r12mr25413656pgj.74.1600422520473;
        Fri, 18 Sep 2020 02:48:40 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:39 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 08/10] xfs: Check for extent overflow when remapping an extent
Date:   Fri, 18 Sep 2020 15:17:57 +0530
Message-Id: <20200918094759.2727564-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
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

