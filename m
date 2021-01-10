Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397BDC433E9
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EDA22B2E
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbhAJDaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbhAJDaa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:30:30 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC92C0617A3
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:29:50 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id be12so7734596plb.4
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hfxy4dQ7UU+MA/AWL+J4vikfJv/jhTTSkVAkRx6cF/Y=;
        b=QtBE4uxqLmFY1k3+SvWaeUmIIr/REoMjE6kCNYx9Q6x2qgmnpT3QEkR0+MqxhYBWjn
         OQCW2nrPMiMzJy5O92Wc1I+SF7Lf4matebA3Bsr/hNUcwSYFoXYMyl1BATz5uQ7JTIeL
         3rYDAuu/gPv/HzhgVjw5YJAMlM0B4g/tpqueG9DQ67bcaYc+y+53jCE4ijoxG/75bOsF
         hHfD4HM9T/wPRMhwse5+AfZoMzNoF2ozDXnTQVTeelmwCztPyr35todeXIPOkpnCUmPH
         igjJcLuy5REc+ZuexgE7HTGYF/yPsiu1OD/fAtHLPHtgr8XJIyqfJgRFqoTVUgIqow1U
         AVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hfxy4dQ7UU+MA/AWL+J4vikfJv/jhTTSkVAkRx6cF/Y=;
        b=SKep8oquvQvYB5xP9qEDfTYJQAblhJn1tFAuicaA+Q0RJIHDpH1cHEhfVnNsOVi0ZG
         4E/XGumX0odK3nmvbZvXLBra+3JzYrMcGafN+DHBLj/rN/WoqscS9VMYAOqelqDHZMRf
         4nIdGF5lK3b/u06nuiDjZbZRBsca/t69s92qkn7fVZkWAY7wEHXU8NvnbVpCXaush5Kt
         /gmCg252aAXeJH+Bcks+wP5vEsW5f5BpUCfErBS6aeAUKLMxLju25pYVwAvw5+QY0MuB
         aeneoaYICCMhczk8PHLa9G6Hbg2vP04ZBDaYXa422Dw0xhdbiQOhjqSFwQ2ELuLYhGoj
         U1Xg==
X-Gm-Message-State: AOAM533idsuPU3B53FX2LJO4WAed3ODaksSMY/jiOkF27PNeZR3mS2k0
        tBYjFV/Eg7a+FE22RjGuvBPRW2kZ/h1SHg==
X-Google-Smtp-Source: ABdhPJzjnDLm4d1+WjzkFDR0V1heffE5wXt/UFqGjlnuWPbyUgAoAHRCT5OBfUG8YU0vbx1U+UDb6A==
X-Received: by 2002:a17:902:7592:b029:dc:3c87:1c63 with SMTP id j18-20020a1709027592b02900dc3c871c63mr10800201pll.47.1610249388662;
        Sat, 09 Jan 2021 19:29:48 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:29:48 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 03/16] xfs: Check for extent overflow when punching a hole
Date:   Sun, 10 Jan 2021 08:59:15 +0530
Message-Id: <20210110032928.3120861-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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

