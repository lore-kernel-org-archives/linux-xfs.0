Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C59C5517A
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2577E223C7
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byNs5f1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgKCPHj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCPHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:21 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C841C0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:21 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id r10so8692561plx.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=byNs5f1sa2Fs8Liu4Ddsf/kojz0OOsYkNJFBH3V7rDuQ4tSiMOip6T4xsz46uOwoGF
         vDBnab8bo71ozSSV9QVMWKVJcsYGD6YAny5SisUu9Aq/SyTeQm64JNyrtvdi679udXb5
         9ShHaZOjUU/NONpAaYEsRNEHq3tXi6PPzYtXiwa18ubYpyHAgKQxVRS/NUWZMZmJJ1Hm
         0IC89BEFRg/ZVsmfNA5Q6oos73UXTiMT+xjWmE9Q39SkxrkV7QGhj1AxOxG/mE7d1LxP
         t/gBkwPTQ8jcXdoY2+fR4oSb4x5jS+MybzI+rNjj4Mgug7Mne2DhgDJ8quumxVDPuP3Z
         cPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=mM77wcnopcnxPbOCoIv9qF75UCvnPCxKFZkxj8Dj+8Nm6tEfYJT9dUkt5sf07IFSWm
         +rTiB3ah0PQYZooBB6mAXNOI8rbk7O0ltHhsCAlxk+W/ADOS97BKi4VL0CVUWimcaW+B
         Cozwe/cWJFUlXfqD9MEMYywKZBDeq1eZO02SsMQbKHdoRDEQbGl6Um7FidLnyeeFcoXT
         ON/knkfhuotsDCXNTEy8se/8sD1Z6JCFpyH1C7ErKp7nQnlUq69I8VLwoNcPrTZIY0Dc
         V8tLZUba8fCZtuD6z1jT9+Ar3Tqviptv1ttMKc3+1aPd6yfwLm6yd7odWshjxX0K2tDP
         rZVA==
X-Gm-Message-State: AOAM531bdPgwlYV1YFI+JY75PRelCBZOXn4UD6l/wlqtafePC4OlF6Dg
        ltgp+ASK4rNjqJGXHAw6IH04Vq17ai+9XA==
X-Google-Smtp-Source: ABdhPJzTXnPCm8tRgFA8fbbtPtO7xuc3VxJzVzjVnZ2ZApDsZWeRGpnewi9fMAVc58oT0Ijs6y7p5w==
X-Received: by 2002:a17:902:8c88:b029:d6:d0e4:7e1b with SMTP id t8-20020a1709028c88b02900d6d0e47e1bmr8386304plo.70.1604416040856;
        Tue, 03 Nov 2020 07:07:20 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:20 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V10 09/14] xfs: Check for extent overflow when swapping extents
Date:   Tue,  3 Nov 2020 20:36:37 +0530
Message-Id: <20201103150642.2032284-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
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

