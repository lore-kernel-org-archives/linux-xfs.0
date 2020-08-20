Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A867C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A7DA2075E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHbkWGkz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHTFo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgHTFo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87530C061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t11so535435plr.5
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pXPi9yq6qolo1lMFgGE9r/lwIm5vPdpEZXV7tE05Sk4=;
        b=GHbkWGkza1yHwQwFzL4siw6lTlfbdAPtuOaNvmwTllMVFaggT4IxVGTMG+cIuMHh8E
         VG5zJL5xUYepg2MCmrMICa4pvJF3CpM5N8hNJB14CqEvYtN8eV+rzqcsxmMExphHpqV8
         Ej85duJiMZeJlz/pfdKmYqS23VEGzyRpxv5bnznYkW5k7svuWt4BvJkY7VerLLIs10/S
         AGNXPOgtrnwNHpzvF52OZATTO0nDDHXHr8n7BMPRybKWztkMFisUEPLd9LXyUS/XI1RG
         uv0IU+Jvah+Bi9mTvuLoZj1iKUo9lZWpLr92saHGPPiHzJTXO7Smtpm3kh7fA9tsT2E9
         wOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pXPi9yq6qolo1lMFgGE9r/lwIm5vPdpEZXV7tE05Sk4=;
        b=VytSGgtZ9Khe9PjToukd9xFdevaA+tXtjjZogF/vyo5aBhaMcvJ06kt8+P5K2w1ZAd
         ADva491OKFII2YIn2HIoeG5WT0pgyY/A9w3Y3Seo/4/gB4cLSPen7Dlc6euwaobNLnNJ
         9PGFoh85KEx7Nd8hnXAXLSFphSxYlqoitllnBJSSk0JCa97MB7GaLuhhsig8hrcTKvxu
         PgxmwxmuncD3qvH8MeGNwAvcBzOHE9pR6gA3C9IkLgrWk/v4kXLzs9+sr6U6JRwWtMsV
         EE6TMc4ISKd8TGUvyQhczyyzAXVXqZhT6Okb+jELlyD+YvfrHsP9RxwP2Qqd6DLMOVbh
         KxHQ==
X-Gm-Message-State: AOAM533iUa2VpGGldG6RL7IemFe5Z4NHlwrJk5PXLwXW+SlU3vrVB6Nc
        Sadboqm4XK+olPqsq/6nC/iVskI7FYU=
X-Google-Smtp-Source: ABdhPJwl7wmW/0anLxa/PffqluaokB4VzY8SLyXDRzVZUJwUIR1F0uA25c6AYTLtTCrOFlDm4TEzAA==
X-Received: by 2002:a17:90a:f489:: with SMTP id bx9mr1149528pjb.115.1597902265832;
        Wed, 19 Aug 2020 22:44:25 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 07/10] xfs: Check for extent overflow when inserting a hole
Date:   Thu, 20 Aug 2020 11:13:46 +0530
Message-Id: <20200820054349.5525-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
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
index 83ff90e2a5fe..d0e49b015b62 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -73,6 +73,12 @@ struct xfs_ifork {
  * Hence extent count can increase by 2.
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+/*
+ * The extent mapping the file offset at which a hole has to be inserted will be
+ * split into two extents causing extent count to increase by 1.
+ */
+#define XFS_IEXT_INSERT_HOLE_CNT	(1)
+
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 59d4da38aadf..e682eecebb1f 100644
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

