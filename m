Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3D7C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C73D922260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NYxvHDdy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgJSGlj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8ACC061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:37 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t4so1859837plq.13
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afcVxSMdw5ij0Fda1eIlXjC2ynyXV9Z8I6bZTS5RiBw=;
        b=NYxvHDdyG6kWuQ0a/p4HPbhNnzGJBrL2XFRVHNNVE8vbJBIqpRrMl60VF/ThBNLZvN
         UdjM8LU/Pos7lb9JiS0Jp+DoJJtIuTA8ksOm1TtTsi8XVMbqcpjk6lG2r6fsh7SaTx/D
         3j8OB8Z+ZlUM37Izw1LGD2gbcMp9YmGmBA6g8lt0DQ9rHVDbsza3dbXoIaz1NMmdqHa6
         07YfqEjwotF4mK/xM5vvdXFnpTKbsbL1j+nPIf5GUXlt16Hbhj0lulXllDCYdg7x/ze2
         x0VqN7aCWurr5bQJKi2txrdW8tgKJdpQleWGlVD3F+I7yjH28FkBqUycWjE9b9w3lQAi
         cbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afcVxSMdw5ij0Fda1eIlXjC2ynyXV9Z8I6bZTS5RiBw=;
        b=rmd4v6ioepOThcc3PRHrIPzGVqF2ZBgcIF79vNcjf1sIU2tSB6xPJXtfvlRxc95NsH
         QRN5hkrdmEhQavS3R89dOsoDhqZ+A9AOCHWj5PnoG/OE2Lk7Zi6Dx/sJVhV7m63+OzfF
         ZdHpeYOeiNoKH0JHMiCZ0o6h1AACYzgQevrwdjmZMgEoYlWCND59wr024zq1KN3OoH1K
         pFS4HYVuq1hAZOv6XjD2EfGH6Yp8D9Xbj2CiTbRgU6mIVL43rocYMdZxSWTq9jacVstO
         W7sM3bodApLLXrOw7yLgsKB1yjoaPGryDYwEQ3Bm+mgFFgQcvDZpTjl3is/r1vanENBB
         9lRQ==
X-Gm-Message-State: AOAM531VmsEihPwF+yW2Ci020QtDXoHo1Gl39pVlCt/CkLtjBuOggi1A
        ElPKpI0qE0MGQEhjf8IDuhXPHSAV6eM=
X-Google-Smtp-Source: ABdhPJwAhhnebIlKzUWISq4Vq+c+BGBOnOzvY7E4RseW0JNezJT9DNZGPU0i2cLu7u9Pwk4+XPlHuA==
X-Received: by 2002:a17:902:7c02:b029:d4:bf4e:4fc6 with SMTP id x2-20020a1709027c02b02900d4bf4e4fc6mr15183763pll.75.1603089697161;
        Sun, 18 Oct 2020 23:41:37 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:36 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V7 09/14] xfs: Check for extent overflow when swapping extents
Date:   Mon, 19 Oct 2020 12:10:43 +0530
Message-Id: <20201019064048.6591-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index b99e67e7b59b..969b06160d44 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -87,6 +87,13 @@ struct xfs_ifork {
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
index 0776abd0103c..b6728fdf50ae 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1407,6 +1407,22 @@ xfs_swap_extent_rmap(
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
2.28.0

