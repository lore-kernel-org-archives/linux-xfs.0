Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F7DC433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD9C2075E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IwLkK1En"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHTFoQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgHTFoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CFCC061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g33so631951pgb.4
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DQTbRCGA8eC9HmrtOZiWR3oUGqm1kAxku1j65nRLYlI=;
        b=IwLkK1En48HNegdyOIFw1JFi2aecCkgh3LeZqfVoOeMGr/jO7HjdHfGZjFxchxdDsG
         1urWiM5ICQsFAdjkAZ6BXwqMkl8wEzDYFWX7qSapsMTCOXlxMwyryEFQhPeVKHlkt1ch
         nTLTmqcZZ83TrNLwJpv/MSlTnXQVmfbLHJETeoIZ3fBlalIRfQOrRRepO/7dMnEZpRWw
         qOEs8zxRrTLwfQCqws9KdsoirpKBhtRzeR9B05/0hX5Yy583KKJaFmUG3d/z1sKGNjpB
         4oQ9R+MaVUgRdd6vnlsqKdWTEQAtNTojKQwIwNceInedYYrSX7SfOWomwuziLwbLWRuA
         nWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DQTbRCGA8eC9HmrtOZiWR3oUGqm1kAxku1j65nRLYlI=;
        b=csObCjDFjgDI87qY38k7cNDY5icO3NUNfJDwXubVa46MwkzLch9IB0dgo67/LqwGm2
         uyGLe/4GEEDbTM6Ok2PoLR8Kr9FiqZX4rM8rzCHBe52iV+EZ02JumvqHXEbMGmyAcH8K
         qYBTwu6isRvgc856R5r/xTMKQVx2QzHnAmakWETpRPpbVT80AMT/DxDmhcxl+uOv4OmI
         eIwuCa351otKl+kkxrfTr+g3jvEGuG+Mz455i9mrGHfKdYwfkil9mxIlkFWRTG+WXqiV
         Snbya3JavahNpxtV3g3jZBu7zAuzRHDme3FaqrW5B/r13/gR7IB1Yr+Ku2VCvdvdufw3
         DGzw==
X-Gm-Message-State: AOAM530f2Y1hPtQlZX8zMgDwlfTGLL4FxFfTap0rB+dcySEOoYfGyPqj
        qwn2/c1PdHcPNO0pmBnBzcIV9tOxY38=
X-Google-Smtp-Source: ABdhPJwVc3pMfGctdxazTXqE7Qx5BKNTR/dLDo0QGgtG4HJXFRWXLxJ6a/SNcqGrH/FN2DLiSP6IrA==
X-Received: by 2002:a63:e24d:: with SMTP id y13mr1392563pgj.248.1597902254871;
        Wed, 19 Aug 2020 22:44:14 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:14 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 03/10] xfs: Check for extent overflow when deleting an extent
Date:   Thu, 20 Aug 2020 11:13:42 +0530
Message-Id: <20200820054349.5525-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Deleting a file range from the middle of an existing extent can cause
the per-inode extent count to increase by 1. This commit checks for
extent count overflow in such cases.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
 fs/xfs/xfs_bmap_item.c         | 4 ++++
 fs/xfs/xfs_bmap_util.c         | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fc2b129a2e7..2642e4847ee0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -39,6 +39,12 @@ struct xfs_ifork {
  * extent to a fork and there's no possibility of splitting an existing mapping.
  */
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
+/*
+ * Removing an extent from the middle of an existing extent can cause the extent
+ * count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_REMOVE_CNT		(1)
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ec3691372e7c..b9c35fb10de4 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -519,6 +519,10 @@ xfs_bui_item_recover(
 	}
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, whichfork, XFS_IEXT_REMOVE_CNT);
+	if (error)
+		goto err_inode;
+
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
 			bmap->me_startoff, bmap->me_startblock, &count, state);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7b76a48b0885..59d4da38aadf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REMOVE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
-- 
2.28.0

