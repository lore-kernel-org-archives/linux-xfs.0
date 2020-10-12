Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B82DC43467
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDCD9208B6
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AiklLaVb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgJLJa2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgJLJa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E99C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o9so8247461plx.10
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GZrgXZdcOQfSNK4QatFmPk/9hbBhcVwf2vjKjM1KdZ8=;
        b=AiklLaVbTJnQY88apT6W2tKvpSbxWG2lzrtvyiEJkCjQr8JBZO1p1Zq8OSR7yO/G1j
         GDRjtsaBj/8yCWvqvrxNSgrsQsKLIdfECuCZPmCEolEMvYVA7+gG1id5zsv3JYes5fys
         nBJ/tRfh8KO2mjk44nBUh11LcQ9O9NmJ+LtH4uplgGJWoGNsWnqJ2FDxRBOzeKSc/EKr
         s9//FGJy3AyC/PVZ1fN1c9OqDqdzNOC3ytdYboMfQqcl64do3fjA+ZE9QN5mYU6PlZ8r
         t8VdSAUwCNLD79IZIMOYNFHitG/l2Pm/ezSmpZEvFtD2kujfZ+Cx0SCL9NHo50BSvH/m
         fxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GZrgXZdcOQfSNK4QatFmPk/9hbBhcVwf2vjKjM1KdZ8=;
        b=ALttRB04y5GwqPChvz2KJOiVYXZWAMKIhwqSqpQvbd3rDhjShWo6OtKTKLJgz9zbpw
         Lcd/CPiYV2aUCZNp4XCaIwVRXjw/wIsEibZXPkHUyaFt8QILVQCWkWkxsfY14AMXPb7g
         h7klPqd5SJnbs0HRCiMsnvNlWjzC93gAcLT9WE4WOkLPOn5u0Pz0K1nWy9NiWhQIkzL5
         TnfcL2vIrVvU1gCvDnBiI6FmSkGRfEfyG9OU3MS190ePtw8tKYalipWxh7R7PWDo65bq
         T1G8vyZzufqCQDz9HHputUg7STUbmwlJV1s+tilYL7grcz0lRCWffoDxd1Sm2txR5zkS
         lloA==
X-Gm-Message-State: AOAM531EuAind/xq8g9HhKQcJDaqkadKcUuRMA6YrBoITXukCUsqgbYw
        krYVlRYRkTQ3ga5ASm/CUoLLcz8Qcns=
X-Google-Smtp-Source: ABdhPJw2IEgqM1cbvV1Gqu9JEVbBpE28ppixPC+sK5Z9ZjJ3a3vh/NDRfDoRZk/PI5KPTKMvIPo/dw==
X-Received: by 2002:a17:902:7294:b029:d3:f1e6:10fb with SMTP id d20-20020a1709027294b02900d3f1e610fbmr23545186pll.6.1602495027524;
        Mon, 12 Oct 2020 02:30:27 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 09/11] xfs: Check for extent overflow when swapping extents
Date:   Mon, 12 Oct 2020 14:59:36 +0530
Message-Id: <20201012092938.50946-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index ded3c1b56c94..837c01595439 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -102,6 +102,13 @@ struct xfs_ifork {
 #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
 	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
 
+/*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0776abd0103c..b6728fdf50ae 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1407,6 +1407,22 @@ xfs_swap_extent_rmap(
 					irec.br_blockcount);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
+			if (xfs_bmap_is_real_extent(&uirec)) {
+				error = xfs_iext_count_may_overflow(ip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
+			if (xfs_bmap_is_real_extent(&irec)) {
+				error = xfs_iext_count_may_overflow(tip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
 			/* Remove the mapping from the donor file. */
 			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
-- 
2.28.0

