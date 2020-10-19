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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B44FC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3067022260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhcicWTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgJSGlU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGlU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5B3C061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:20 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id q21so5422402pgi.13
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkZp74bfuwYpotYVA4sm/s+ckInyUHSobHDhs1qTZVo=;
        b=NhcicWTW9ngIUP76K/pPc6o2CAwrcBwPBpe1IgN+CPxtyjk6dshT80gSu3fmhVRFD+
         C/IYc8/39JlhqHThkR41cdta0acEyxuh7bGc5xiAQzv4DhWZyRipiasgAQMB1M8SVdvI
         0g29w8TJ2SutbtgNlKLj9sUMOL/qWTPlm0J+EmOVOfzZ9+YtNTck3DY/92GzNKWp+pOn
         R6IOuVLbLPbDMU84KYwXxAN31jr+P1yXqUuwml8MApakpTQkRIZNBNASpoCJiBXmEl4q
         ee4qG7mT5yshj3Aa1w2IA/PPBobolju+fDRIK7VZEmtLxSP+ByN+F4ySFSW6lNyMWMza
         AOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kkZp74bfuwYpotYVA4sm/s+ckInyUHSobHDhs1qTZVo=;
        b=oN12mvyVYa+AeYUBNiiAqfrIfHDOVFYT5AQh+VJLUhcUf9zmjbNbXUOhnjeVFWccaj
         qy3jdovd3rh8CoaXWKgc411RrCfKX9ypyxl6ArWYqcKW2fispLZJyFK5s2pdZNAWQ021
         XDbQs/8LCSuPTq2YW6n9U5/Wx8ZKLQqk/NhkRgeopvf8ws4q8dr8qrHPGPa0s0ZUEmuU
         Z1gyh1eXilgBkr9WqG+pc4ecbg/fvkCLy4EBDGj1PWyrK9KdUx7hoOUJRfe048k8LNEH
         70d5BfY1uG9gsLYAJfzyLapv1lZLRyun6cG9CQopsN6vc+x+5MzBenq6ZSKaWTVKTclG
         4oqw==
X-Gm-Message-State: AOAM531gv4rm7aDt4GzK5Y+Xv7WPQm+Ha37AQUoOFEWduP8BJErX49+/
        CiCG0+/s7aBgL+4JndM+kUH7FFYQDjg=
X-Google-Smtp-Source: ABdhPJz8duwf0I02+Kwk3Gs+EU4PX7mal2dd85o8XfHBFJUVX6F02EStLMAA7cdwsbmehtpbI+q1sw==
X-Received: by 2002:a63:4644:: with SMTP id v4mr13078169pgk.351.1603089679728;
        Sun, 18 Oct 2020 23:41:19 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 03/14] xfs: Check for extent overflow when punching a hole
Date:   Mon, 19 Oct 2020 12:10:37 +0530
Message-Id: <20201019064048.6591-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_item.c         | 15 +++++++++------
 fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fc2b129a2e7..bcac769a7df6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -40,6 +40,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
+/*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 1610d6ad089b..80d828394158 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -439,6 +439,7 @@ xfs_bui_item_recover(
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
+	int				iext_delta;
 	int				error = 0;
 
 	/* Only one mapping operation per BUI... */
@@ -497,12 +498,14 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (bui_type == XFS_BMAP_MAP) {
-		error = xfs_iext_count_may_overflow(ip, whichfork,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
-			goto err_cancel;
-	}
+	if (bui_type == XFS_BMAP_MAP)
+		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
+	else
+		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
+
+	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	if (error)
+		goto err_cancel;
 
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dcd6e61df711..0776abd0103c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1176,6 +1181,11 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
-- 
2.28.0

