Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DAAC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED20222211
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbhADKc0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbhADKcZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:32:25 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6E7C061794
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:31:45 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n3so5062399pjm.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f2y3tRispCdnrzAnaMKzGUWJKa7b7cfGubZ2uu6yCUg=;
        b=Ts6Mx6eiMJ8uSj2M3upUFg/IGu3yFNfv0rCeUdylrjYHLgOOC+V7M6jtJDTExsRmwW
         aWdcD/gKD1yJOWN2AMvQVZPjbR8Mkmjq9mDpjuBluXFtR2w8EBKcVXwFG25Hjhf8XGGK
         5zyM3V1YCHBlKA+bXjdVs/WNoOdrUFLWZQpevenY9CdfB9UR/gsBU3AuAItH/MXOMlJI
         b+aBhaDdtwU+W1ZZEwaTyW5hFjDAUWMQmZboQkKCBJWYIkkQEGHxEIB9KwMOTib8Cmxh
         uunoH+0iOBv0rQUV8mA5UgM2qS6RahcgeO7xtLvG//MJzXLSv//UCzH++g5i7HJczpd+
         OWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f2y3tRispCdnrzAnaMKzGUWJKa7b7cfGubZ2uu6yCUg=;
        b=lihruCl5qLs4qUhEs0Lg1KcFqNjAMbLNVccYKM5pNixKehQHvFOSoeXjgjw/MWJcLI
         3aWJzMwTMWFNhxhJuSa/KHQ2d0E0TRo822KhSIfhZ1lT8EXrZLrQ/lr3NVGpb8M/QAV0
         P2res6yejmU4m46m00RoRg6jmT2721aipSMYHFsheF0T4KQXX0+fnAvyznUa8zhFqDi7
         aE7gyrVJZHvOGX6GZhaNifAGgC/rEyBGMfyURVnyJ5rNM+P6HnRgZS721vg4Ciw+Zkoc
         f5Gkkrjm+P3vbpf3AEcYrtSF/PG560rZqYrn/lSOMH3Z6GYpFvdc9SSsMIPBpPZqqqnm
         i9SA==
X-Gm-Message-State: AOAM530e0c4ETbCXwR+0uI2F8tlL03uDF1AibvrYgfZFO4ui5HDD5npy
        ejvdNrB/5E+uKDka2eBNmH5n7ZaMooeg9g==
X-Google-Smtp-Source: ABdhPJxNlz+MfLtpdWckxBNNYi8E5nSxcL3kBAHYQn+ITUSJ9uTtLZPcjZFmAbEYMddE+xRvkaJlrA==
X-Received: by 2002:a17:90b:815:: with SMTP id bk21mr28945195pjb.21.1609756304681;
        Mon, 04 Jan 2021 02:31:44 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:31:44 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 02/14] xfs: Check for extent overflow when trivally adding a new extent
Date:   Mon,  4 Jan 2021 16:01:08 +0530
Message-Id: <20210104103120.41158-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When adding a new data extent (without modifying an inode's existing
extents) the extent count increases only by 1. This commit checks for
extent count overflow in such cases.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 6 ++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
 fs/xfs/xfs_bmap_item.c         | 7 +++++++
 fs/xfs/xfs_bmap_util.c         | 5 +++++
 fs/xfs/xfs_dquot.c             | 8 +++++++-
 fs/xfs/xfs_iomap.c             | 5 +++++
 fs/xfs/xfs_rtalloc.c           | 5 +++++
 7 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bc446418e227..32aeacf6f055 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4527,6 +4527,12 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_may_overflow(ip, whichfork,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 0beb8e2a00be..7fc2b129a2e7 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -34,6 +34,12 @@ struct xfs_ifork {
 #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
 #define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
 
+/*
+ * Worst-case increase in the fork extent count when we're adding a single
+ * extent to a fork and there's no possibility of splitting an existing mapping.
+ */
+#define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 93e4d8ae6e92..0534304ed0a7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -508,6 +508,13 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	if (bui_type == XFS_BMAP_MAP) {
+		error = xfs_iext_count_may_overflow(ip, whichfork,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto err_cancel;
+	}
+
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
 			whichfork, bmap->me_startoff, bmap->me_startblock,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7371a7f7c652..db44bfaabe88 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -822,6 +822,11 @@ xfs_alloc_file_space(
 		if (error)
 			goto error1;
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto error0;
+
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1d95ed387d66..175f544f7c45 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -314,8 +314,14 @@ xfs_dquot_disk_alloc(
 		return -ESRCH;
 	}
 
-	/* Create the block mapping. */
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		return error;
+
+	/* Create the block mapping. */
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
 			&nmaps);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7b9ff824e82d..f53690febb22 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -250,6 +250,11 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b4999fb01ff7..161b0e8992ba 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -804,6 +804,11 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto out_trans_cancel;
+
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
-- 
2.29.2

