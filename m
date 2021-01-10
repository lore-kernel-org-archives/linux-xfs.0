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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C637C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6627722A99
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbhAJDbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbhAJDbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:10 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A05CC0617B0
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:30:08 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id t6so7743295plq.1
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=Bm5nCpxeCT/rsrrjX0Bvn8jIGBx504gjKPql84A3ey8HGoIpmxH2a1SYozXuaz3HHy
         4/ZXWPGjHrqHi2YSjUJLqM1OPW89heeC8iBgt1gAscKvpJ6t2qdkJ1uppct7JLJ/g9tB
         KtJ0CbAbjgFdKj34hmetbKixyrmfE0qMcN/CRwyLuxARUOFjSH77ZlmGTJZ/L1iVPNq9
         kg5Mxi+f1guJUvKJ0Hexp8MTu1lz1OpetErElgLJHj/Mc1f8C33VNN9QMPu3h3COCLE/
         JtaA5DuJ4P4DsLVj/tmJAYAIy8R/Z21lwL0BE7oQZWKfWFBIZtF7rgj78BnuJ1uugbk7
         zESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=JOcv3NXqDYdAznZrneuAAwWZuKhVV9XAJwTXY5ZOt4go7vm/Yxx08YpXIkkO4HWfbS
         UBplae15nT73z6Tst/6Bx/z7HcZeAOxdeSlJGx8JvkaN80lkxtvSS7bRh/TbSJBEQAWc
         9kovI7z2f3JnhLOjlfS03soxK1cMDA2GS5NdQ5mbkHYFHY8iRgUivh44YLO+oXHFGbDw
         5k8LlsgazTd4f98ciLCF18KZgU6xWXKvZLYCg3WXXksUUtiChdmdhFYAgPHZzMTul7lH
         ldQy02wgBqIzB/sYjXEqEGlQltxDEoOROdL5SzNI1lzLFYFhQceGtr/41/rkUT/aQQ5q
         /RfA==
X-Gm-Message-State: AOAM530aE1jrYHvpeUld6xBxHAOIJtM4mD3RqOG/qo0DuEnzcc5VMyF9
        XHgKcXWJem/ug+1pjcX2TgbeQbPcv8STeg==
X-Google-Smtp-Source: ABdhPJx+U+hxCoW+v3oAkozCYf1S89vLgenHuy76aC4cob2r8mHq6/JyH+dwcf7VT9okytYimwlL/A==
X-Received: by 2002:a17:902:bd8d:b029:da:fcd1:664 with SMTP id q13-20020a170902bd8db02900dafcd10664mr11064773pls.30.1610249407630;
        Sat, 09 Jan 2021 19:30:07 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:30:07 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 11/16] xfs: Check for extent overflow when swapping extents
Date:   Sun, 10 Jan 2021 08:59:23 +0530
Message-Id: <20210110032928.3120861-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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

