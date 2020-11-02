Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB76BC00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84425222B9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V11GXDv2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgKBJvR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:16 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585F2C0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:15 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 72so3940779pfv.7
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4jR8INSWSC6ttwbiQgR4/JGrIIg0yQz4NSER0DYDRnc=;
        b=V11GXDv2elDKqtu+GVGuLQcJVcdF+E5VRahRS2rAfpUSYYUV5/+qF4UoFVD3t0MJJo
         LT2PhpMdph+qJul0q4HR0vIpXC6/F3SB58EADknHiwWT48xEMs89r2GSY+sZKROcNOw9
         GKXwbvw4PxvJ/tOU4qAmSpEUyol747qQ3ZLd55jcOVYImBV8z+54xMzfYfrqqNHn9inX
         PvNY5ta1fNqnXUBeaTQS4g/Xf0We2MO8IgZc8ob/fKo93M/helU+Q5s8Qun3J1A5P90c
         L4a5M+FiSQgju81sQ208bWhlVJSTNObuX3qVfll4dXdX5v1zvEkp6U3JIGo+TBojjW3D
         nLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4jR8INSWSC6ttwbiQgR4/JGrIIg0yQz4NSER0DYDRnc=;
        b=HC9tX/0CWc+7jCMZTNOcbzGOo2dtvIZV45KSQ6P4Qk7Hj5ziNrYO5mpCsQVzy02ENr
         3zI+qBBZOtgz4NhwKHUWuJhobD3cZnHlZ1vZdP3bIQnOdlQXQNR2dLaxgvVCcA5fbQTI
         YLT+c1vPLi3DqSDTdErbKOiTGslAvktNx9VO5eDADD76m7RFlGc8vYEvaBtTU4KDMNSD
         EwQXaMobQkPdr6wCwkbtppdwPYYihUSEPKYSdtlRqtiNz+hDFIx9A4iNfmJ+ifmXDUcb
         JRzAc/ikFK2fGFZMz0tE4XTQWFbgxSmWExHrYNfahaWYgKG8eTHF3DkZ+y3gX1NG2cqv
         mDNg==
X-Gm-Message-State: AOAM532LnSu9JHiKKKl1fYebtn4axp1Dqzjgnyz3yHgvpe3D8Iml2yQS
        wLZGBlCWMiARoxUzZ5c0sFHTUOVJ9vo=
X-Google-Smtp-Source: ABdhPJzNsQ5Vuyq9xSfdNkCfa1C3rAEXM1y/GgmhI3xnpgqJLjevsoFnFCde9JPPwg/ODzm5vsS10w==
X-Received: by 2002:a05:6a00:88d:b029:164:5a00:29b8 with SMTP id q13-20020a056a00088db02901645a0029b8mr21708281pfj.10.1604310674626;
        Mon, 02 Nov 2020 01:51:14 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:14 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V9 05/14] xfs: Check for extent overflow when adding/removing dir entries
Date:   Mon,  2 Nov 2020 15:20:39 +0530
Message-Id: <20201102095048.100956-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
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

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
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
index 2bfbcf28b1bd..5b41ffaf04d7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1177,6 +1177,11 @@ xfs_create(
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
@@ -1393,6 +1398,11 @@ xfs_link(
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

