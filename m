Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F722C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0330E22228
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbhAZRYl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731838AbhAZGdj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:33:39 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9288C0613D6
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:32:58 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m6so9909047pfm.6
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hfxy4dQ7UU+MA/AWL+J4vikfJv/jhTTSkVAkRx6cF/Y=;
        b=V+gC0+mnvIjJ4sC5MDhDXGbXwC2hR2n1nES+YvufBy5ZCnFx6MHmt0JtyPtLJprh0E
         XC4uBI3Gt1tJ0Mlow6Mw/95lMXkdgjY8ePL26rjplUaD3toNkmPPz4kiwP55QqxhANMo
         5IbWmEw2o72zy2SZ2ywGMe1cCkYaTrza87eyMNjAZAb8HBFcdsgAIDyjnSQto3Dp6amb
         g9TJ2o8D6q2Ok5yo1MRPXL0JXywkE+oxOsYj+oHQgzKWxh1KthNoidI6nXTF69NFmR/l
         zx6WYJ3Uk+0D0bRRyzfYGNpfhVNiIOhkUUDyhNd1MBdAvEJYeMwUuZ818Z6trGpOmSA9
         RohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hfxy4dQ7UU+MA/AWL+J4vikfJv/jhTTSkVAkRx6cF/Y=;
        b=uSRu+T2B7Jrjt3ArGYvhARJn7pT1NJxjiARRWppcWyudhynjEXI+WDgW7EFlvRdiOE
         NtYMSSv2rwLS/MVmobfuFicC6Y8SLu7Uwl0vxLJqrAAMca7iyPD0fvC3W/Gx4o7cc6lv
         J7mbxGBl0owkGHrF6JEMubwPMLhy7kA2GoGoa0DY/dMZCpR7GJO9/M3/lGtIa0Y8n4zZ
         nKe/wjLAOCZ+tBUo7kCrYJ9duPuYMcR9YN0H+9mPIUCRBkAsFB8ZRbpXT14ZQzi4kKCI
         kjLdcSXXxjMi4R3neH5YgsQXX4T/2CYfAr0oTq5W444E01qK0WK7YaPm2ntUCVKB90Sq
         y9Kg==
X-Gm-Message-State: AOAM53362PGhybWlimQPxH9+ptjhvCjydCSHVjeoLCs3Gy8aGJM/VI6E
        mIzoQbTqI4T4enxoNUob42MQB/jKKa4=
X-Google-Smtp-Source: ABdhPJzF0vz/dLSQtEUeEeTRhdAKGBqK7ZM3D2FGaVJAtl9+WBQng6iOdlLjSq8ch3ymNEgiIn6gOg==
X-Received: by 2002:a63:564f:: with SMTP id g15mr4298295pgm.334.1611642778207;
        Mon, 25 Jan 2021 22:32:58 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:32:57 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 03/16] xfs: Check for extent overflow when punching a hole
Date:   Tue, 26 Jan 2021 12:02:19 +0530
Message-Id: <20210126063232.3648053-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_item.c         | 15 +++++++++------
 fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fc2b129a2e7..bcac769a7df6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -40,6 +40,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
+/*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 0534304ed0a7..2344757ede63 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -471,6 +471,7 @@ xfs_bui_item_recover(
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
+	int				iext_delta;
 	int				error = 0;
 
 	if (!xfs_bui_validate(mp, buip)) {
@@ -508,12 +509,14 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (bui_type == XFS_BMAP_MAP) {
-		error = xfs_iext_count_may_overflow(ip, whichfork,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
-			goto err_cancel;
-	}
+	if (bui_type == XFS_BMAP_MAP)
+		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
+	else
+		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
+
+	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	if (error)
+		goto err_cancel;
 
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index db44bfaabe88..6ac7a6ac2658 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1168,6 +1173,11 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
-- 
2.29.2

