Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D95C43381
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B1322273
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbhAZRYw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbhAZGf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:29 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD515C06178B
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:08 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id o16so1276455pgg.5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ubOW171teC9ubdwQpqHiQv4fYIYHgh/wHn9tXIiatU4=;
        b=YKd8b0393LsMlBAGa29rR98eveUwhwGYPyZcmU3yWSp6uvlfyE5FdSHIVszZvrkJLZ
         ZeyqIhRuEz0kKWyGg4kIX0gVcjbmOiIMtZ1aatwooDyhKO7HyqFIDtM+f8nTZ4gl2eCk
         7Tz+XnzT7G9/XI2Y+tQFuxsSFuzzYfQ/pbzH1tT49JXi9OKDPfSgp3SCYpUr/QSNJ6Ft
         4yOcg87ExDI/H3b4EQg5CdghYykzDhIeK/2fD6aoqStRzxWnbyryOTwiUfbKev0piyGO
         8lnnvqnMIgLnkJ6mw41fZE5ooQt+lHnIn+Vml8VGNrP1njws1UshbO0RuEY/8fbArKwx
         m8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ubOW171teC9ubdwQpqHiQv4fYIYHgh/wHn9tXIiatU4=;
        b=U2AtXZ4HH3z3MfKd3Rk9CQJmg9PyfL2n3+sK424mHd+ErgadO8G/8YsW9J9pAjv8ao
         K1UHBrrKCwIY0CHEIZiE1WqYdxCQf092kpBk15lQ33Mtl17LJ6q0GsuZmbVGlyzBZNlw
         5brZEzm4Fm2YqGhdWpAVwO8MxmnvS0pRvUzZbrAFskvk/NuoOfIZ9dZqXCjYAN9aQRnv
         57XlrNBbHPLclFF42oK9IvyLvhbEKJV9Be2lJXCjTlebco0kskyhdU/DQMnOHRdk+FPo
         J73XDwVVdCXUMG8tVMrJHOfy5uHM0OzzF2W9nkKJgkxiJR0PSteXNSD0QD91B9IMT8kX
         eRgg==
X-Gm-Message-State: AOAM532K5kWWAkdjuuF6U8A9tF4k6mR+9HRMdbsjgAZXi/Wdl2ailL3w
        0fAWloUa0SLjlQ2MUOTNfOohNcYTUkQ=
X-Google-Smtp-Source: ABdhPJz0402G+Aj6cT2zYL0ZBJcCxPWhbfxj/A7tqU22/RmXlJ/08sY7cYFSuSlIC8WmsPF+nA+wUg==
X-Received: by 2002:a62:160b:0:b029:1bf:56ca:a594 with SMTP id 11-20020a62160b0000b02901bf56caa594mr3831231pfw.57.1611642788078;
        Mon, 25 Jan 2021 22:33:08 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:07 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 07/16] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue, 26 Jan 2021 12:02:23 +0530
Message-Id: <20210126063232.3648053-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
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

