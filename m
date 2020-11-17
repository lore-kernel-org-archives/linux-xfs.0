Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D51CC2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0874206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p4djkLPm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgKQNpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732589AbgKQNpC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:02 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32429C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id js21so470118pjb.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VsmLEV28ZOMfZvVWHzIja+OeUgfAduMADRIVQ5dd5EU=;
        b=p4djkLPmPoDuSeF32q0oXhQk7DCQISph6t5r98U/TdHM8ikmp1zh4aWA2sISLh8Yke
         9vnkH4X4oTqt/tf8q+Z/qR5Vza4BxM6WJWRgowSgI8syIOtiw1Q6YIxvB58V/9KFnq8o
         cyvmGG0wSvOdMx9yxekmqabYb1zM6NyQm3ISFEw3eOwYik8sKhoKeniA+ej59Et1QkeG
         uBWQn4tzBKNkmh7Ne+Krj+fXy9sCctRhi6MKlEqyV6+4GCRxt9k5QZOnZD46raEzwqm5
         9FNWEfk5rNwq7kBJO2WSBkZSJEGHF3yFuMzISYP1Vi2UTbxk3Ns+LVe6ggQOXBn7Mts7
         om4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VsmLEV28ZOMfZvVWHzIja+OeUgfAduMADRIVQ5dd5EU=;
        b=YA/f11r8DnrNgd/onYVbn0pAqXPKItiegpHqUAvWJr/wFVObNbjKQ8tE5MVpnZh/Oa
         Cr6/UkEy8HopDwdq44RfH9epsG8kmTAd8GaQ/FX0OUQK9QPq0Su2LbBLBiBmfm51vpow
         wfMLvyQqPbOmi5wMANP0d1a/5suL/0byKf7HhsaXBakH2YEoGVqZWWqZIKPxkMOu+May
         rM4mmcHgiGK5RVfgEpZFQQK63dwuV25hB5iM3F0EiC66hzaho0w79DoHbT9gqX8cYZje
         m6BPhCd7zSLJ8SZY16GSrxS6bysGkm07Cu6UTRn6wyLKfgCXG7Nd2zaX9zFnr8kNk6aY
         usPA==
X-Gm-Message-State: AOAM5317dxnS0V13VmGj6GsMVYu5+wb9bKkhf6hNfcZfdGjlNVjf/ukD
        ee7SajMeCKRuqYpf+lJM+oI2sK6+9RQ=
X-Google-Smtp-Source: ABdhPJysvOTTsKip0Iamk/31RaGdW3JQjCpLkLhHhfPEXALGTvQSqw6dKd7MsMkYLzuqsviq3+uqQQ==
X-Received: by 2002:a17:90b:1108:: with SMTP id gi8mr4508092pjb.56.1605620701364;
        Tue, 17 Nov 2020 05:45:01 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:00 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com
Subject: [PATCH V11 05/14] xfs: Check for extent overflow when adding/removing dir entries
Date:   Tue, 17 Nov 2020 19:14:07 +0530
Message-Id: <20201117134416.207945-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

To be able to always remove an existing directory entry, when adding a
new directory entry we make sure to reserve inode fork extent count
required for removing a directory entry in addition to that required for
the directory entry add operation.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
 fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_symlink.c           |  5 +++++
 3 files changed, 45 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 5de2f07d0dd5..fd93fdc67ee4 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -57,6 +57,19 @@ struct xfs_ifork {
 #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
+/*
+ * Directory entry addition/removal can cause the following,
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
index 2bfbcf28b1bd..f7b0b7fce940 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1177,6 +1177,11 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * A newly created regular or special file just has one directory
 	 * entry pointing to them, but a directory also the "." entry
@@ -1393,6 +1398,11 @@ xfs_link(
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
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
+				XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If we are using project inheritance, we only allow renames
 	 * into our tree when the project IDs are the same; else the
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..08aa808fe290 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -220,6 +220,11 @@ xfs_symlink(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-- 
2.28.0

