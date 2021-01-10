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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAECC4332E
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93367229CA
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbhAJQLE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbhAJQLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:11:03 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FBCC0617AB
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:02 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id x12so8198430plr.10
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=dDbEoqbvOTu5vGiziYG7U+gVDOIxqleHwsPQIUCUbQYbEe8m+hvKrFLPn7RX9B5P6N
         6bTSqoc9rOv1yP3qocmhUOCWb/zV+L4P7LO4v1XtV/i2B62f0df7qKN712bKPGHhAVvC
         uz3n+gLWgNU13rkhl74iQJXgbbX1GniS2kcTKdSdpyM7VmNf9ZawSsoO56Vx25uqwoJO
         OwCkEPrhLR1OjUZPvevBqGV3AX/I3RUFrK3IroWb+pRB9OOoATTUVyXFqqRU0Mztzdqr
         QFdM60iA/LGDAxc47kQYRbWpf+dDxdGfT7kMLALoAtP9VKQwFujo8AUtF7nZmD3SqgSU
         woKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4La7elDz5rLfoG4JrFZntjDujjZDW53T6MIJGSY3AE=;
        b=rgggmg8afaUULV0KWZnMR/DY2B3YPXRFPhaxsmvpIq4cqM2AqmdNIXET8pmq+jF7OM
         LwvKHXqxSjCoy9m1zMqfpLSkn9qUFz1GL2cS4Cx2SrqLezUIEby0BFU2mfnkW9fvx6Y7
         oLr2tazTOCFz/HkrtknqzepjLc6N14XqAeQYlceAgHoKcVX36XrXy9do/j/qr+GfMskz
         1MsHdWJbWGZQwmOONSI+9S3QbKabyjyRiQWvjzCfqsB9LxN6Qclnsz6CgQK50wlLTCOY
         yd3ozd4cyQiQjIM977S6sYO/RjbouoLGhmM3EEKW85fseynOLYb3kGmltGnNJD5f80xl
         44WQ==
X-Gm-Message-State: AOAM532GqzdfvuNWhn1OYd/tyO3adzBzEQSCSV63ip0PZYtqd1YOkNpN
        47IUiTBVE7EihUA4z/ME9Kbz7w3ijTI=
X-Google-Smtp-Source: ABdhPJzBH1pICFML+ocFx0xzkXf94Yd2uZYnC7XPlzTCFoDiVxOPVz1ONv6O3MiW5HwVYBmJhOGeDQ==
X-Received: by 2002:a17:902:b493:b029:dc:3e1d:4dda with SMTP id y19-20020a170902b493b02900dc3e1d4ddamr12794656plr.48.1610295002021;
        Sun, 10 Jan 2021 08:10:02 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:10:01 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 11/16] xfs: Check for extent overflow when swapping extents
Date:   Sun, 10 Jan 2021 21:37:15 +0530
Message-Id: <20210110160720.3922965-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
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

