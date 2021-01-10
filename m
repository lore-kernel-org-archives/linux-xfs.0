Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A98C433E9
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01FD9225AB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbhAJQK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbhAJQKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:10:25 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D827C0617A3
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:45 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id e2so8186183plt.12
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CaaIKtEA+QkHkbNZmc4x83WOODezXN2Z3yH7D8rxDjE=;
        b=KJMwGF5wOcQSxkZPDsn/Nft1s8pJe5tL8kr1nq5pTGZIiIPTh7A/UVNvrHTsgCSrns
         nqhUgzAHwYSvjD78ksQcyN6go5pLXsC9kkYSRdFsHVOgJVy4xpkwnOlWTVttnH1TH9nf
         Xyjmnkk6UhOA5/QvQEcd21MAstXh6fBFtkyZ7v6/KbRV5geZ1DbUsrFcQWrSF3hrnj42
         KE+CLh8jnWo3trdXFDm9b5I1w59SaozEpQfTsa4PacY4ALy3aOfDV0b51lxhXCKQPzfl
         i9kWyoJvCH0YfGbbyOoVvbwFj7X7SEWle/QkdGGjfoWDcoeivRr3IE3qeIHFioU37AlX
         ZBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CaaIKtEA+QkHkbNZmc4x83WOODezXN2Z3yH7D8rxDjE=;
        b=VUCZJ4jRvSX41vL+9/8v0ADnVu0YkkpPA4WLTSc8zqD2Ycvwctu6KxkUwQv+HHn+A9
         hm6VhTjfzCbolqJPOJGk8S17PhPYZI30ZV6cip3HB+IK2EKYYD1Q1jvpLU+ccQLI6WQR
         RrGgVXl7CT9j+pYYFlgCtFekEhQ7/XSF6f29tApdBPqVtu3yqhmqbn1F5GMqz2ko7XGW
         JMbhbSyUAHdqwT6lm3BOnc6aIW4PQvAbvQR0YP9BXpSReLFnq5HbuxCNhqoP6KJyJA8O
         umjUn2YSG/l/W5/6XEigI0U4YTRQ2qNR7ARZfYcsU4V4LW7HUhzwDmkUy7/OE79z2pbg
         8uiw==
X-Gm-Message-State: AOAM531rYykeAExLKuiLh8gwoUevOIsEa8wmVXu/YxuG+grEeQfOmSOa
        1/9snS+szbqQGOzUhzvIx8j4J85UbqY=
X-Google-Smtp-Source: ABdhPJwhrajEjns0hvzMZcXqt6OdwFY2V1qs1RxLx62g8WRy6RY9VcnqCYeY+HC7/ahQKIURxUviQQ==
X-Received: by 2002:a17:90a:6708:: with SMTP id n8mr13778183pjj.35.1610294985002;
        Sun, 10 Jan 2021 08:09:45 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:09:44 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 04/16] xfs: Check for extent overflow when adding dir entries
Date:   Sun, 10 Jan 2021 21:37:08 +0530
Message-Id: <20210110160720.3922965-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
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

