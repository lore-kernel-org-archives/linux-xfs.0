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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A39CC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6925B2068E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7GJXEE7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgHNIJ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B31AC061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:56 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o5so4179821pgb.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4CkmlP/B7k+Voc2v/ccKv01lAP2YLLq8ob4/AXbjbJw=;
        b=C7GJXEE7M3ZnXe0ttzpxogf4fl65CZLZiNmkKTnMyXtLlC4qJ7Gan5Enpr7rhysIUw
         i49WXPPgt7NQJI5hsT9Ii1PS/wNbQlQstHoQRr70gyfKxr6k6nW3+BxHJ82ORIk0Hk8Z
         U+ErcKwn7Dg7ib7y2Hl+YuqvgbqCq4zWliwWDHsVf9IgcuTay0eBkfLx/qbHTgLIwnGk
         yoKgffr6G/XYOCYAxSY9fvBXMOMansW70PjOpceEnEXDIvURyQyWYw6aEm2GQopd4WrY
         4Wr3DT8GrKK2wKJY5zM/EZN8/vDgHpbiE4Aod+JwjyKBqjCIlCJR1Ku2fb/BFe6tBchN
         Rvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4CkmlP/B7k+Voc2v/ccKv01lAP2YLLq8ob4/AXbjbJw=;
        b=I1JJZVAx48QKAF2gb0Gmcm4WdftCGBBBtbpJ1MTUq1VjyOIwzxdFVwNHmgDL/pXeA1
         Uo5onCwDg5m9rBWPUtDWQw3vec9JOiJ2DQYLlJr1FTqOaex5HRaUUBaznceTH1Dkk8Fx
         lV4tetxcIYnBmjFUhIcksn8IM80I6Zt1qcI/uEEZg1aZ35S9YIiai8tGxrlI7Jn2Xmlq
         7zk+Gf5dCMn2kcbXFOd4QJyd7FkWK8uTcW/58khXx8kmtbynF8mOYRXlhSWYCyPkjLqZ
         i4Cy39iMDHmE7mndz+nwPnCiDO2tM/5x51ZIOX0CuRA/iUMYNFwUCwGlP5t5fB4FMzWY
         F19Q==
X-Gm-Message-State: AOAM530ZPCwa+iTTHLlu+miQKgr6hco4PEij+OAxyiOBYRfrdjr6Z56K
        TQWsYC2+8lAz9GoGtAa5nWAp/d6/vTY=
X-Google-Smtp-Source: ABdhPJyUTW8G5st3wSzc6VT2H1ru9F00nmLOuxFiW3z+7UdKG8GwPcNMmF4kvcu254uI6fe+XpJB/A==
X-Received: by 2002:a63:4f1b:: with SMTP id d27mr970697pgb.389.1597392595639;
        Fri, 14 Aug 2020 01:09:55 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 07/10] xfs: Check for extent overflow when inserting a hole
Date:   Fri, 14 Aug 2020 13:38:30 +0530
Message-Id: <20200814080833.84760-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
 fs/xfs/xfs_bmap_util.c         | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a929fa094cf6..63f83a13e0a8 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -70,6 +70,12 @@ struct xfs_ifork {
  * Hence extent count can increase by 2.
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT 2
+/*
+ * The extent mapping the file offset at which a hole has to be
+ * inserted will be split into two extents causing extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_INSERT_HOLE_CNT 1
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 94abdb547c7f..f6352b5e5552 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1165,6 +1165,15 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * Splitting the extent mapping containing stop_fsb will cause
+	 * extent count to increase by 1.
+	 */
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_INSERT_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
-- 
2.28.0

