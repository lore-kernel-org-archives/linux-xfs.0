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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA24CC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 17:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86A9E2083E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 17:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbhAZRYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbhAZGeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:34:22 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36156C0613ED
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:01 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r38so4993458pgk.13
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DvuAysnNj647KYLM2zsgf7kVk3Uqaq+To7asMmfFFus=;
        b=YVf68IDQwphjeTBG/RlYLKta6No9LqSiigKInFd5Ux/SM+gfXRQzr1p79iE/idqeu8
         ZQMo88XvRM3/lVCWyeLJKlx26jcDzcLrMEPGLPY6ri1eWZZdareXoJNuPh4wVxCLNpH/
         m7bLUuw12mFwjhPqrTNHBmCY/ypzvisynvbjKS+2RrVQ5Jnst/d3QlwqZj2fsb3yulPs
         m6Znl8AEuzf/EiPg28Sz3vKd5BY3LVeUo0buF+Sg3g5sezgBCOAbrm1RSHyVkXeaWfb6
         m7MhxGMKOO6RYcRljdTXPkLfeAKiPPUSBUOeFk2p1IHbhrPIAvRaS7Y+dkY+bkSwoIZ3
         oEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DvuAysnNj647KYLM2zsgf7kVk3Uqaq+To7asMmfFFus=;
        b=Cqi1zgJZEthugHeu7eF60kASzsUPjZh/3z7jjRIceu0CnBuytQCUqoYdMQrBVlCP+3
         bXqqf8W3aK9FWVwIy9NQkrBciNC+FuvVG4DvUVzShnI0GFTdI/Uhj+fGYat4pR+bESb2
         mYOSBZjfpJoZh5QDpbufqYdG8dT4EyioQA2Gf+XX3ZNwdNtwWsEm4w4UaNwdf3wYyxKU
         gQCQD77ZSPL4+uKneKgxBqT7+QQbhoEvb3LlgttKAndTkTI2Oi0Rs7D4C0ZquNTIP6Eb
         Xkpiw1KD9Tvw3SXpfoRdoGIanIn9v/VdfJcvo/3p68c/23tX6U/bf31o2Nu+vKD8eGV+
         5HrQ==
X-Gm-Message-State: AOAM533IMbJoIRir4BuWGzNZGxIO5BZApF9sjyMDr/3zBSyCBt8bq/bx
        efiRp5+NGnJ25n5Xa8HXFVoSPuzk+CU=
X-Google-Smtp-Source: ABdhPJz/tyYM0LQGp3bhSfqMcxX5El9YJaPA7sCrNZMsgYPkPRYhs8/6bY98zJFgcvfe/aLGFfuTug==
X-Received: by 2002:a63:d42:: with SMTP id 2mr4458116pgn.236.1611642780674;
        Mon, 25 Jan 2021 22:33:00 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:00 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 04/16] xfs: Check for extent overflow when adding dir entries
Date:   Tue, 26 Jan 2021 12:02:20 +0530
Message-Id: <20210126063232.3648053-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
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

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

