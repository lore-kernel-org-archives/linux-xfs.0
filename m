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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B75C43381
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3739D22211
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhADKca (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbhADKca (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:32:30 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A105C061796
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:31:50 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id s21so16197443pfu.13
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbnL4tpNi6ygMWadA4Ppj3OqzFP/kaV/4bufxDiHbb8=;
        b=a9zIgmh11E42hM9qPsuDkiJKsZgA9c2iFOUD68V6N6jNemqzQCQvpAbc2d1FTg6UlI
         tG0Hj0r8Wl9d77hrCZ8uxb7JlI04aCeCU/NSTTIJ03b4mnqhpquj1+otcDlYCStf/YP4
         Zn8dojtYT/FtlVQvsyRNOJtFMJF78B/D/SsvLYpRBN/xYpzRis44RJIo9p2ZFWQdJFHy
         CF0c65QGg79BevXllt00zReqsQnjKKw4wMmwMayeHNvg3P3i4jjiyhcNbYRcBIOMDQ1s
         OdrT1EhWVPZaRdPFBne9rnrDAwG1rJJOtc9J7PMWRRVcGCwas8s0uYTvRRZVGdDxmY3f
         MB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbnL4tpNi6ygMWadA4Ppj3OqzFP/kaV/4bufxDiHbb8=;
        b=X3H6rmnVflQj7mv+ECRAVjvOulowpmRrTVfwl0B3FU+TjjIJZkxb0lPDeCbV9ZuuWI
         6a30Oa61v+2HK3J+gtMBthl1jH27u398GZ7s+Q0Oe0ldwX2aBllysbX1Z6l4rYwVqt4h
         ijTb8213ZJbx+p7Qn4W0NWBn/4A4WtXn8ozIEKaEp1NWTA9TnTC7VvRQmCi/bdMd6vJE
         8Z0olIrYYCQoG4Wctfx0BrODoCMP6+sfEdNck9Rax64obnoFRiEVX7Tsqtxj/riMJo5b
         Cx6FsaVx3Eh1KbJPm9uSoYo5n8x5+49Pz5tpmJJ3zHw1+oVT0YcQ/XR0zXwGtdg6QFZ4
         ZZKQ==
X-Gm-Message-State: AOAM531lkxncEBvB/SGZl5bSs/xySvK1lUOyoJH2CeN4ue548QojDC+A
        GYHC+AZDfkaJuu2304sTbo1amnAdyh2l3w==
X-Google-Smtp-Source: ABdhPJybw55HCtvpxqrE9YM7QNPotISXievDueHSTcKO8lrq1R/RvJNDrTvzsusdP56WDtFt8e1Nyw==
X-Received: by 2002:a63:a516:: with SMTP id n22mr69179563pgf.125.1609756309755;
        Mon, 04 Jan 2021 02:31:49 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:31:49 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 04/14] xfs: Check for extent overflow when adding/removing dir entries
Date:   Mon,  4 Jan 2021 16:01:10 +0530
Message-Id: <20210104103120.41158-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
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

Directory entry remove and rename (applicable only to the source
directory entry) operations are handled specially to allow them to
succeed in low extent count availability scenarios
i.e. xfs_bmap_del_extent_real() will now return -ENOSPC when a possible
extent count overflow is detected. -ENOSPC is already handled by higher
layers of XFS by letting,
1. Empty Data/Free space index blocks to linger around until a future
   remove operation frees them.
2. Dabtree blocks would be swapped with the last block in the leaf space
   followed by unmapping of the new last block.

Also, Extent overflow check is performed for the target directory entry
of the rename operation only when the entry does not exist and a
non-zero space reservation is obtained successfully.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 15 ++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 13 ++++++++++
 fs/xfs/xfs_inode.c             | 45 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_symlink.c           |  5 ++++
 4 files changed, 78 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 32aeacf6f055..5fd804534e67 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5151,6 +5151,21 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the middle of the extent.
 		 */
+
+		/*
+		 * For directories, -ENOSPC will be handled by higher layers of
+		 * XFS by letting the corresponding empty Data/Free blocks to
+		 * linger around until a future remove operation. Dabtree blocks
+		 * would be swapped with the last block in the leaf space and
+		 * then the new last block will be unmapped.
+		 */
+		if (S_ISDIR(VFS_I(ip)->i_mode) &&
+		    whichfork == XFS_DATA_FORK &&
+		    xfs_iext_count_may_overflow(ip, whichfork, 1)) {
+			error = -ENOSPC;
+			goto done;
+		}
+
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
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
index b7352bc4c815..0db21368c7e1 100644
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
@@ -3106,6 +3116,35 @@ xfs_rename(
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
+	 *
+	 * Extent count overflow check:
+	 *
+	 * From the perspective of src_dp, a rename operation is essentially a
+	 * directory entry remove operation. Hence the only place where we check
+	 * for extent count overflow for src_dp is in
+	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
+	 * -ENOSPC when it detects a possible extent count overflow and in
+	 * response, the higher layers of directory handling code do the
+	 * following:
+	 * 1. Data/Free blocks: XFS lets these blocks linger around until a
+	 *    future remove operation removes them.
+	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
+	 *    Leaf space and unmaps the last block.
+	 *
+	 * For target_dp, there are two cases depending on whether the
+	 * destination directory entry exists or not.
+	 *
+	 * When destination directory entry does not exist (i.e. target_ip ==
+	 * NULL), extent count overflow check is performed only when transaction
+	 * has a non-zero sized space reservation associated with it.  With a
+	 * zero-sized space reservation, XFS allows a rename operation to
+	 * continue only when the directory has sufficient free space in its
+	 * data/leaf/free space blocks to hold the new entry.
+	 *
+	 * When destination directory entry exists (i.e. target_ip != NULL), all
+	 * we need to do is change the inode number associated with the already
+	 * existing entry. Hence there is no need to perform an extent count
+	 * overflow check.
 	 */
 	if (target_ip == NULL) {
 		/*
@@ -3116,6 +3155,12 @@ xfs_rename(
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
 				goto out_trans_cancel;
+		} else {
+			error = xfs_iext_count_may_overflow(target_dp,
+					XFS_DATA_FORK,
+					XFS_IEXT_DIR_MANIP_CNT(mp));
+			if (error)
+				goto out_trans_cancel;
 		}
 	} else {
 		/*
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

