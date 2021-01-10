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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7FDC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E56E229EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAJDac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbhAJDab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:30:31 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1212C0617A4
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:29:51 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so3298252pfk.1
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CaaIKtEA+QkHkbNZmc4x83WOODezXN2Z3yH7D8rxDjE=;
        b=H4070fxqkMR9HlRls+tyBn8hZAwxSjd2lU+s26ZTbY+HFrFDNfT4YKADERZUgffXyT
         8DtXT2YNnG6HVUqg6+wQnTQIKzsGMniyfHRQDMsFKSR3uiEGUt0xtj1sEoc+oPg2Ib0X
         bjsQJsW7YGgKV5aaqgQndeRY+2kfVizm2TRGTSJosVkdmlN6k8jz+7l4pGTV79Lxvr7I
         f7sJ+14cunINePgfnc+u68vI2TtqNTidiV3xwNhwju+EQTTpS45H0TFiHbKFa9RlL0Pr
         8yVIe43y2cDLFgrv+GSGsqWkel4TOG7+lEaVeBl2YxG4/h7bljcCRsnLgJJcQGyQtL1E
         K4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CaaIKtEA+QkHkbNZmc4x83WOODezXN2Z3yH7D8rxDjE=;
        b=o+TBmlL1ID5kL2qpkQMxZKqTEGzAgMCTyQeFc7wuNIO4GZeObNUV4J7x8mpgosGEs2
         V1OhkXL1vDZV/yvZF0IFlH5p/cLihc4bbD5nOkSRKUSh332rDau6QET0rsFjA+k38C9g
         q7oNpxtC6zRwV7WLL9pvYdTz2keeRKCm5ynIsIGca5osLYv1m8dPC1dX6oFDmL9HzR6Y
         LdpwcgjNQYnAlMshPkbqM4uj1aTspdVjA3va2GFxDJw8tsbBDy5b/4Zmaix5FPJTjX4Q
         wbruH3NX4N1pEtpw3rY1E4m0xo82k4bwr6jXIyqupzACqrWYx324DQzbJnY1LE+jxZet
         /RBw==
X-Gm-Message-State: AOAM533Z/Yg4aFYuYqviUwTRX6VWywHtVD/FaVp44m8+SIYz32TcXX9S
        9URVkFGIBduU905kfa+YnPNYgFv2uZKZWg==
X-Google-Smtp-Source: ABdhPJwKgVkeE1m70tJODqBUm+eW65Y8lOkIZ8Ph9tz+7w4IUcQWFarY3DDh5qC5pLBApi3zTRD1Zg==
X-Received: by 2002:a63:5416:: with SMTP id i22mr14057219pgb.43.1610249391001;
        Sat, 09 Jan 2021 19:29:51 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:29:50 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 04/16] xfs: Check for extent overflow when adding dir entries
Date:   Sun, 10 Jan 2021 08:59:16 +0530
Message-Id: <20210110032928.3120861-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directory entry addition can cause the following,
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
 fs/xfs/xfs_inode.c             | 10 ++++++++++
 fs/xfs/xfs_symlink.c           |  5 +++++
 3 files changed, 28 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index bcac769a7df6..ea1a9dd8a763 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -47,6 +47,19 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
 
+/*
+ * Directory entry addition can cause the following,
+ * 1. Data block can be added/removed.
+ *    A new extent can cause extent count to increase by 1.
+ * 2. Free disk block can be added/removed.
+ *    Same behaviour as described above for Data block.
+ * 3. Dabtree blocks.
+ *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
+ *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
+ */
+#define XFS_IEXT_DIR_MANIP_CNT(mp) \
+	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b7352bc4c815..4cc787cc4eee 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1042,6 +1042,11 @@ xfs_create(
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
@@ -1258,6 +1263,11 @@ xfs_link(
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
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 1f43fd7f3209..0b8136a32484 100644
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
2.29.2

