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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB06C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A04422228
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbhAZRZD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730523AbhAZGfm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:42 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6C2C061794
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:18 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l18so1637045pji.3
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=MQu8ENHUy0Ozfoez4B/aJlBxBiwYGHFmyFsQ6eiwwpcYfsdglnCr/77jXMovWnJpzX
         X68dRG89vFU9f+SUAKCJFF2nqJWRWrVLmN6sswBQMHZs3SGAjCQ8TlDmMRvCGXCTDSi0
         rWrVPOuUXKGjXH5yWndHspRtGr/rG9OX+vmYmLs4l2kztnohkkhr726Opml01CqXStP+
         qtXsaDonnkiHnx/AhvmeyIOHEe9vtvBp5Az7JESdh4WjScbFuM5VPSkYSPM9N3NcpMWP
         LYQlQ3gcgXKxajJvf8xaYzG5AXsHpIH4NMNzFLXlRztYTwDbLFJcNz3izX8g3yB3GoEt
         38RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=UOkoYDX3oj5/ftLmJQs69IXrdLwYQ7irzvqvuvkS+9rIy38WWb8WibFiSNT5N5N8oK
         QdvwG06+rzVWvXpkgTsJKrvAnYkHddYgzbCqPkDyZ72skRCGO3zeI3I/gc+7HnmIYywD
         MW0CJb21lJEHd4dTIgrz0i+6bghRJflNsdAJldsliWP4lk40Q5Oy5N97ZyMQF17kBnSH
         EadXy6/qKmirh/LSGFoxYe23KfETUbYYJ5kbulvtMJ8mzJcmTmVxYwRr8CbOcr0DEt3f
         MBeYuXrt9gsUAkSucYSYjlKSmfwPLyDxft1JW3Cf+6QC6bPwpoPEy7TT2ULNei2yIbzi
         4eFQ==
X-Gm-Message-State: AOAM532Mh1q6OQqebCQRxttJ9MWQ+M++FBbJI8PWZn2lWzHIzq42NQSB
        s3RFDisl1cxOrv9gNWAg71TpXLhG7y0=
X-Google-Smtp-Source: ABdhPJyLv9KDmJt1sZ8UfF58neDRZo4TBPzS7ySv4qMCRl0X4UnR2UBMobcVT2GluTiSCJBeiwMNoQ==
X-Received: by 2002:a17:90b:f08:: with SMTP id br8mr4388241pjb.134.1611642797841;
        Mon, 25 Jan 2021 22:33:17 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:17 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 11/16] xfs: Check for extent overflow when swapping extents
Date:   Tue, 26 Jan 2021 12:02:27 +0530
Message-Id: <20210126063232.3648053-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
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

