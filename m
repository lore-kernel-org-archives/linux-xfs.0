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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7017C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6D422211
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhADKdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbhADKdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:33:01 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D71BC061798
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:31:52 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c79so16228467pfc.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ubOW171teC9ubdwQpqHiQv4fYIYHgh/wHn9tXIiatU4=;
        b=X4qaBkDGK/Dzui19FEKDW24z8WLa0AxIFL1+Jk9Od9e7tU2BZ45EW49BVJ+sHy2qnx
         2kaGbBNPHIl+sNW3QlBR87p6EqxZzajHe5F1xan+dQODJek1/KRoFJzjIgKCfgcMs0Wz
         lFcwu+ic7aCn9Xq+IWGT8VQvNCegYCIxPzMwJSYbGQi0NeM9MkHruK307SZdbV6Xc3rc
         TQwc5QMn+R5mzLo8Am23tV62Tdx/v09Tk+bs/PNSxj9BiLcysTeONrWTIuwcIAwK7MA6
         xYsws36cAc/DJYb2uAc81Yr8q/UbhYv/TeGRpNqYE06h+VuWzzEXvnE4Y6woKS9OJxkM
         Nvxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ubOW171teC9ubdwQpqHiQv4fYIYHgh/wHn9tXIiatU4=;
        b=XZEk3Fwk+YezWvwUv9Ccc28F+bQUUQnZ+/Wkrxs2obuwmlv50N/wBmnSUivUTWf7x/
         oNt1BBlTIh21vnc2bIW/hhxiV8KqwANCCeIS0u0fPyLRlSkCQwaCJcAvln2KA0C8r5/d
         HapTo7XDJ+KwfynRM6IbRQqFJYf5J20be9iqDr9+jBXXejGvzYm8n8AW0XqnhICMUdb2
         7VLePjJFJrpKcAPjMvoK2F3KjGpBC1Vn6DwZPLOT4erI5hvf0g4xcbRtkC6AsQrvvLCK
         ClJiTtkiJgK1LHf77SNLRYZqbHakVlCOjDzz9VIFempkrLl7QzpoaKBY/k4DeZHfdVjN
         ij0w==
X-Gm-Message-State: AOAM53146vLMonJUFUtv8Ao1P/PQyeb+46BcgIunChv9oPH1YTzW6VI+
        YwMGeFcOScJEuyXW4uRH5eII97rrdPeLyw==
X-Google-Smtp-Source: ABdhPJymtxbn3SP4cR6cdEaDmcVfBUwJVRVoFGcWECcIBlidVHNIvupw6tctKVovxOiSZradi4YCkg==
X-Received: by 2002:a63:c501:: with SMTP id f1mr62229981pgd.1.1609756312180;
        Mon, 04 Jan 2021 02:31:52 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:31:51 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 05/14] xfs: Check for extent overflow when adding/removing xattrs
Date:   Mon,  4 Jan 2021 16:01:11 +0530
Message-Id: <20210104103120.41158-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
added. One extra extent for dabtree in case a local attr is large enough
to cause a double split.  It can also cause extent count to increase
proportional to the size of a remote xattr's value.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 13 +++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd8e6418a0d3..be51e7068dcd 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -396,6 +396,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
+	int			rmt_blks = 0;
 	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -442,11 +443,15 @@ xfs_attr_set(
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		total = args->total;
+
+		if (!local)
+			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
 		tres = M_RES(mp)->tr_attrrm;
 		total = XFS_ATTRRM_SPACE_RES(mp);
+		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
 	/*
@@ -460,6 +465,14 @@ xfs_attr_set(
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(args->trans, dp, 0);
+
+	if (args->value || xfs_inode_hasattr(dp)) {
+		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index ea1a9dd8a763..8d89838e23f8 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -60,6 +60,16 @@ struct xfs_ifork {
 #define XFS_IEXT_DIR_MANIP_CNT(mp) \
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
+/*
+ * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
+ * be added. One extra extent for dabtree in case a local attr is
+ * large enough to cause a double split.  It can also cause extent
+ * count to increase proportional to the size of a remote xattr's
+ * value.
+ */
+#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
+	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
+
 /*
  * Fork handling.
  */
-- 
2.29.2

