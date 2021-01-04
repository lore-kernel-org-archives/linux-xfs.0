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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370DBC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F912225E
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbhADKdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbhADKdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:33:06 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A59C0617A0
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:32:02 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id n7so18816952pgg.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=LUSpTahAIUcWorUbXKcc0u441o7pUrbI7mI+LYd2tM4yccN9xZbYNdrYskgmrMTmYS
         rKpnmX8izGsqZrExJQagqCeIpMGuwOEWvk7o/jZyHiUOl9Ob9Mggu3xkIeF9Q5zLBu5G
         zrk25nzoXINbVFMViIbHJw5m8qtgA4IQyXD9O3WX2jfcAUz1jM2M+Y20dzHje8LdiYf+
         Scd52cBfyMDFbQ2YOJZvjv2MBIFL0l7uL8p9CpplatUupBzfTDHMWXCEjVIpLPh7INsO
         L7MKLn2JHfBXi84zO4SpvnhWIdR9fE2/t7ZqKJMVqd4UoHSZViNkDxZ23vvKYak8DxL+
         BTcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=OhYCOZD7C5W8aRvZEdZnrZci+8+yhvtD90t94i20rTJQomusC+UuQnuK1n7E/t1y0j
         H2OOTQckTi+YZlZBVszcF0RahLYc3B8DyYIVV44AkcYDkc+NxBzJZFhIdLX7MsQs8nrA
         Ew5k5o3VnQkDHk4IexCNuBMWUS7cPICb9GKOSCEQ8GTQ4SV4bIKPvjSs6jKhOskNEOPz
         +uFr+79sJoVHWEebWvLC0bf1aak5BHeWXJEQf7sbM37INBCCj8BZfaU6Chbb3Q170rBE
         mzUFs5Kw8marQ/L3/9pOCJhp35wHWtoYD2wjYASZmDUshBCzED3HTEnLZrwfn6S7/dag
         jmbQ==
X-Gm-Message-State: AOAM531RNPWCvlE2skGFf+U/CrXehvSw6OvR5UNTrh/t0k+PS9TxwvIe
        JfyLjRR0zOaJ10FuRUEAHkai4u0YkBkV6A==
X-Google-Smtp-Source: ABdhPJwNR6z6bNDhL8RKzA5q7YWJFkwOA8ayYbQkwJDn2VO4bkTd+MEoj3JFMt1CjuLeFQFwtDGDXw==
X-Received: by 2002:a63:ca10:: with SMTP id n16mr69842831pgi.105.1609756321962;
        Mon, 04 Jan 2021 02:32:01 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:32:01 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 09/14] xfs: Check for extent overflow when swapping extents
Date:   Mon,  4 Jan 2021 16:01:15 +0530
Message-Id: <20210104103120.41158-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index c8f279edc5c1..9e2137cd7372 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -88,6 +88,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
+/*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6ac7a6ac2658..f3f8c48ff5bf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1399,6 +1399,22 @@ xfs_swap_extent_rmap(
 					irec.br_blockcount);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
+			if (xfs_bmap_is_real_extent(&uirec)) {
+				error = xfs_iext_count_may_overflow(ip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
+			if (xfs_bmap_is_real_extent(&irec)) {
+				error = xfs_iext_count_may_overflow(tip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
 			/* Remove the mapping from the donor file. */
 			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
-- 
2.29.2

