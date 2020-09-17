Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F90C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2027221734
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GcTM9a6X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgIQLjQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgIQLjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:39:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0E6C06178A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:39:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so1087580pjb.5
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OVf5a3IB2ZzBSVtvS513pC6i+oFF+t79O5LiUwvxX2A=;
        b=GcTM9a6XYkmubrvTHqRbelNANNRmKiDjCfUlXbjt9Clnv626nm3m6RpnaGbMynXax4
         HlhUCvjWY+hfBJP5SBgwfmxCr+7rwqntQi7WKOklyO0pO84BrEohZm6tjrXaE36cFgo5
         VR9eX2k329ssiRPSujecGESsJE7Kr1hRaWESSuUNk38owP7xt4HrDzi2/7ab+zVdY75U
         Tup6IujEBAH9KtRl1jII0iOPMg6hG0FxRw0jVgXtwuhd4Xg2ceKd70vJQTToaLsm7+gb
         QFqsrpN62Ap2tAAm4599QE4MYUvC41/DxOCF5fmYy5xSUtcW0JvHquE99dcUWzTybfqL
         N0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OVf5a3IB2ZzBSVtvS513pC6i+oFF+t79O5LiUwvxX2A=;
        b=q/umJX1Y4PfR1EB4lb9+9FbF1C6elSdgJDNjJRHi7EPXfaougun5EDP2bbuF1I8bXt
         /beU5nWlAZqcZUbadClPqmnoLyeAsHMc6X9U7JSZAFVFB8LkuClRZW6qvCHuHArsdww3
         LdIM0NT1hzjr8gYEo3LFE4l5MdwVL4zhLYj9FSM0v8dIzxux6en1E5O5jkYiZDM6YCO6
         PeRSKQ01SkWXLS+zA3se0Mf7zp2QHvavZMZp89JGmgYSDCZyVXZUakANXzuaGjE7T53C
         eWqrnnx/WciQUSmRPGCO9Vcg+ppVq/GyxzW+kL7kehLIeuW+dtaK/bxabqSzVXp851Xu
         OgUQ==
X-Gm-Message-State: AOAM5338drGa/2j7EFRopEdeEAFCdTBfCJ94wwhqv6tJQgwrzoivMxqK
        o8iKdd+AVjEYtX8QOTZYkM6YHwbBjnsb
X-Google-Smtp-Source: ABdhPJxy1WKwdV1duwG/xDZY/tYe+Om1uC01inLhj84Zu21ZAyoI2bHHAJ1YB/6aQKNQYkYR5ELk8g==
X-Received: by 2002:a17:90b:4b82:: with SMTP id lr2mr8056716pjb.184.1600342742335;
        Thu, 17 Sep 2020 04:39:02 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.39.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:39:01 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 7/7] xfs: fix some comments
Date:   Thu, 17 Sep 2020 19:38:48 +0800
Message-Id: <1600342728-21149-8-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the comments to help people understand the code.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 4 ++--
 fs/xfs/xfs_dquot.c            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 09f0f5d42728..2a72f1760169 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -35,8 +35,8 @@ typedef struct xfs_da_blkinfo {
  */
 #define XFS_DA3_NODE_MAGIC	0x3ebe	/* magic number: non-leaf blocks */
 #define XFS_ATTR3_LEAF_MAGIC	0x3bee	/* magic number: attribute leaf blks */
-#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v2 dirlf single blks */
-#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v2 dirlf multi blks */
+#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v3 dirlf single blks */
+#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v3 dirlf multi blks */
 
 struct xfs_da3_blkinfo {
 	/*
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3072814e407d..1d95ed387d66 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -831,8 +831,8 @@ xfs_qm_dqget_checks(
 }
 
 /*
- * Given the file system, id, and type (UDQUOT/GDQUOT), return a locked
- * dquot, doing an allocation (if requested) as needed.
+ * Given the file system, id, and type (UDQUOT/GDQUOT/PDQUOT), return a
+ * locked dquot, doing an allocation (if requested) as needed.
  */
 int
 xfs_qm_dqget(
-- 
2.20.0

