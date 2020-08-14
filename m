Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8CBC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F82207DA
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZ0TI9ao"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgHNIJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:51 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A1BC061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f10so3831271plj.8
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bFfR12tqZBInOj7X6PLo9DGMHuPa9ErXDt7MBFGap3Q=;
        b=dZ0TI9aorHOILacrh8gq6vHDv0LrFq9ePCCcpremLFAZqLfE9GhNaBtNGOD5p89Fy2
         mfi9afOtOB0ihtTy0bx4Khnz2st6UKd8XkxICAFTVJn5TmFOCXpXyD9cNe5ELaygxpsz
         MDwz5TX1JMCqBVrrpvnF74l0hrhaKuJPGmunX4a5xXK6fu+Tx0Dh7wRj2CsXsPdaNaG/
         D2Z+QBL2j2T+41Sx3WxuP2b3+1HzQz0iPb4uD44vQ1WfASj+dksv8nlLyU6oiXEUXkj0
         233KOmWFtfKyfv6LYCBfQrwArV55y7EVfrum643YILOtn+OmsW2zfHbDMYNOQgeHLI0d
         zqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bFfR12tqZBInOj7X6PLo9DGMHuPa9ErXDt7MBFGap3Q=;
        b=PTN5jaCpIYa/G4lTsL9LMu94IW+1x7t0kfVA55d7Bp7+LMwYIzNAUse8WYfCqJwHxt
         g78+O0gMjXPqJe6PvzePf0kBv/aorFi/MOsjq2N+nXux9UDmB9vIEdECV50WZigkJpSv
         PXE1k358o4qECpekUH1N7MxeqTXCb5mU7QN/yiF67BiW9WFk/A8FugQdGDDgED1XsVX+
         lHEC7IRI+X3GyCtQmpJeiZd14EKTYi275of2UpBdQRRfyZtovPyDfGxS5RN9onCd37PQ
         oC9REbXupBLMbVEeHN/Fif0sB6AYmLiCR1hT9CzRgvyLRjo8hD9kh4ItF5FaBYfOANCr
         f/WQ==
X-Gm-Message-State: AOAM531W9QeEyswHP0TEGcQ8M2ddCqdw6n+oIdXFl7M4sAItpeFdOswO
        fzHOgq1AZRTISMtUZHBKr0oxsQUdijc=
X-Google-Smtp-Source: ABdhPJy5OQIiwIZRJhg/PmxXJ7sV8b9Z+PZEp09EYcB3vxvxncaQdsLi2UFE0LCJYpLXiG2ZXwK7yA==
X-Received: by 2002:a17:90a:36ee:: with SMTP id t101mr1401435pjb.47.1597392590987;
        Fri, 14 Aug 2020 01:09:50 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:50 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 05/10] xfs: Check for extent overflow when adding/removing dir entries
Date:   Fri, 14 Aug 2020 13:38:28 +0530
Message-Id: <20200814080833.84760-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directory entry addition/removal can cause the following,
1. Data block can be added/removed.
   A new extent can cause extent count to increase by 1.
2. Free disk block can be added/removed.
   Same behaviour as described above for Data block.
3. Dabtree blocks.
   XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
   can be new extents. Hence extent count can increase by
   XFS_DA_NODE_MAXDEPTH.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
 fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_symlink.c           |  5 +++++
 3 files changed, 45 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 72a9daf5df16..e39ce09a824f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -50,6 +50,19 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
+/*
+ * Directory entry addition/removal can cause the following,
+ * 1. Data block can be added/removed.
+ *    A new extent can cause extent count to increase by 1.
+ * 2. Free disk block can be added/removed.
+ *    Same behaviour as described above for Data block.
+ * 3. Dabtree blocks.
+ *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
+ *    can be new extents. Hence extent count can increase by
+ *    XFS_DA_NODE_MAXDEPTH.
+ */
+#define XFS_IEXT_DIR_MANIP_CNT(mp) \
+	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 407d6299606d..8d195b6ef326 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1175,6 +1175,11 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * A newly created regular or special file just has one directory
 	 * entry pointing to them, but a directory also the "." entry
@@ -1391,6 +1396,11 @@ xfs_link(
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto error_return;
+
 	/*
 	 * If we are using project inheritance, we only allow hard link
 	 * creation in our tree when the project IDs are the same; else
@@ -2861,6 +2871,11 @@ xfs_remove(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
@@ -3221,6 +3236,18 @@ xfs_rename(
 	if (wip)
 		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(src_dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
+	if (target_ip == NULL) {
+		error = xfs_iext_count_may_overflow(target_dp, XFS_DATA_FORK,
+				XFS_IEXT_DIR_MANIP_CNT(mp));
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If we are using project inheritance, we only allow renames
 	 * into our tree when the project IDs are the same; else the
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..581a4032a817 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -220,6 +220,11 @@ xfs_symlink(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-- 
2.28.0

