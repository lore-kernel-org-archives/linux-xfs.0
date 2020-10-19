Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93489C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D93722260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1YEYZNa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgJSGl1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGl0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF5BC061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o9so4472399plx.10
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ti45b1pUkN0XCWDswhQqiLSKHoMU4Xp4vqOvltLMQKE=;
        b=Z1YEYZNaiVeRGdX47nuX9es7Dywmy7bxZYvt96GJDfUn6yPQk4kxLmU5UT8a+WVXQt
         CANgM2W2v4iX1YCVxZGOgHIi1RGpaxe0D3JWCH69wljIjdCYq+j81eZdNbODcQ2C0+y7
         F1vben1S8R69tTzoYYMxJK1Bxh4nwvuvaQG4ClmHcZlGKtzmREMyV2YgITv2wW7isrTO
         3gRS9ay7CL8zbL4QJgiiBI85ymmT2+9kF0GGCR3dBsp4qIWpCt6VTsLclDvKBxCbRWDk
         uFaJ92/6sd6MiVbb1fncm7IEsNw3vxMqNmwM4YEL/Phc4BDJKI2Vl2+/449yLRQACLzC
         dD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ti45b1pUkN0XCWDswhQqiLSKHoMU4Xp4vqOvltLMQKE=;
        b=k0Pq4HL5oVr2JazZ7Kh5YzS3kn5dxxPoxjEzKpUHkJUD9hUCDzdM8jZLgSdH9yif63
         +KEdZNkrXWlQNakshw6AuoKBjQfmhbkucIC7dsAmbHUPrfa4Q/4parEjE8mNP1A7rU3q
         ca2fkye/Qzn0x4KDQQI1sWKop5ob2Lzi8AiPfrFFohGekYi2S0bC2daaNJTpN0LZDBrc
         3PXL4QSVcHBRt0tRZhfVZzc4VmXuhRmM1NtGf1rdj8MB9Vvn/pqEjiiRpkY4M0pCR8AD
         xn4+V4yTL606rnXsKDJ/gkAayFBgOq9uOF6Cb5CqDJk/AREKH0Ck2X52mobGIWIL9MyR
         NeCQ==
X-Gm-Message-State: AOAM532fdQAJ+I8kC0SDnwvfD+Islqmf8eoEcHBkCsKwiJBFRgaLuRF1
        kulbeLiPoMndPxvi6AwHifMdIDD+rNg=
X-Google-Smtp-Source: ABdhPJzQb7JtAWBU0Y6r/DvvEHlEbFLbO/dLtSfmM7cIn6SjrawcnC437ZbRjBEEShEkxY4PR0SVag==
X-Received: by 2002:a17:90a:be05:: with SMTP id a5mr16769356pjs.118.1603089685937;
        Sun, 18 Oct 2020 23:41:25 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 05/14] xfs: Check for extent overflow when adding/removing dir entries
Date:   Mon, 19 Oct 2020 12:10:39 +0530
Message-Id: <20201019064048.6591-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
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

