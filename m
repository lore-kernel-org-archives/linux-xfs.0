Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595ABC2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E98F720838
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IK6YajI6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgJ2KOw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJ2KOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:52 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E319C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:52 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w11so1061226pll.8
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=IK6YajI6WGF4A4bB3ltoUXBuinWpO2GRpWJgWlBcACCApDtL+GhYxrCSsL8hv0Gx3t
         f6ClebrYJGQFK5h3BdvZ6GBmJmlZNjrIkIEzrmGo1yWqYaEV3Bc6ZT5AWcd1YAYnywTb
         R3UCN/O5u/5MupdL8lqy0OSOVn7mnqDV1VdgXDknv59S5r+IQOYXl2jbEWcT9YE9q/Vz
         PhO2792yyCO/M70wA57CvemJnp3HgbMUJxD2jGreMPFTtu9SGbBxG67XX9PB0LHDgGYC
         TXORsNSgXwXbriL3F2cTTJM21t26zgmUwe7tUEo1fL8l8GCdnAIiWLm0YYapdaOUWZTO
         NfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=A+JBRuP3U7eoyCCAniOXf8D32gGXM4FZihua/7hM3rRUpmIkvKu9k24jX5adDFVh/c
         i31JyP6CJVqq+P5px6cJyGr7bZEsp1MPurUDjbM/DGLSbuLcFMTA21BBfXj4Kkb/zgNh
         +gqVoMxpz1a9y/Wi/Yl3DHE550vP1KgAnv7dUqvfUPLM7RZLCztSefU72WYwL/Y+xCW/
         cg0j27U8bcAqwkfPJcqShDfrHz43JXlhJKA9ccqBberQJUuDC4r2FmEoBMfOATuR7j/q
         cNnCqkL4V2864h4A8GCVtv/o1rSEQqZurbSXlznpwag+nxXct9zrvq8FperX89lBzLdV
         8mjw==
X-Gm-Message-State: AOAM53271O3381d5gf9e3h2frkLn3v4nIyslRhJrBt4y1/9iyw4VrxRx
        8Vjoee+FJiU4YBgkjYJt5BmdCMhSnUk=
X-Google-Smtp-Source: ABdhPJx8LA7vZgpm5E+V7EtqbVwAINBW3Zh98uORvuEeqYIyIXMV+rG50p2blmBQf43QeFksZpA5NQ==
X-Received: by 2002:a17:902:7896:b029:d6:7f5:c408 with SMTP id q22-20020a1709027896b02900d607f5c408mr3284390pll.41.1603966491484;
        Thu, 29 Oct 2020 03:14:51 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:50 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V8 09/14] xfs: Check for extent overflow when swapping extents
Date:   Thu, 29 Oct 2020 15:43:43 +0530
Message-Id: <20201029101348.4442-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
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

