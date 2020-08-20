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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B51C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13146207DA
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sMATffRR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgHTFoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgHTFoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEABC061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d4so498155pjx.5
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=44Iv1kgKTiqTo6p00WcQz6bKyzKvV4a7ttaZdiIZZJ8=;
        b=sMATffRR/HpHiGx6aSSO6O3ZDZtBAP6ThMDzp1dRlh0WjccQiLU7J2PS0W0ys7Hjog
         vW9zECrnlr3/6yc067Dh7Yo44RwpUQ+xUpsD3TLwVVd5d28wc7UJp+ub7Mv12quAbnZG
         p4nijZAYGQtGG4tpoMcAZBtw/9W4hDFWOnTxgTHxgvk0gX0omFL6jCtGk5HiEkE0Rcnu
         C25kr/2jYI/snuM21GsN3fNuj9HaJuXssH1uV9yM7qzy/SUSBe2IbOR2IBe5VMOyqNzD
         eMof8FtEWvl2cSUEBo+l/jCTKy1WV2lfpHwUEPtn3suFnTdCEumvNOygp89QsKBU2KCj
         uOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=44Iv1kgKTiqTo6p00WcQz6bKyzKvV4a7ttaZdiIZZJ8=;
        b=S+e49DLBXXuDaqj4LVoV+UlGFqVu864ztQXjeKJVjw292wI6nYAhAzXztiOGa7s6xa
         bfv/DtVkfc5YvVLhw7OGJVHLBPnUqag3l0+/uwSkqUxEzhE2UBLkA9c1stIMsEK2kGcz
         MDqjpJUGp+gzFNRfURnlbn/sOBQlc2+VyQdPyjVhaK6XEV+7kF6+zKtrZ94IV6s14cpu
         4aFRwVrcz6bcoR3xx4g9Jz8J3nQAbXquvFzmBBNXMZyJS0xQ/8qyOEhQNARUQJcrTKCm
         caiIga6EocQgYesechN8Iah2l3qHr5+YvgFvsZMnS2yIACdp1NXP1b8Y+5ge+L9gmUTV
         bOpA==
X-Gm-Message-State: AOAM533lDjY4zkp+b+Gvw/GJijp1tQ21+m2dLx2XB/nBuYNFAzGZvCay
        Jq3ulyU8s0HVfxCqRpy7KnU/6IubUIU=
X-Google-Smtp-Source: ABdhPJxrBXjzxecJfr3gHUKrmsxHG4evbUOco9OFro5/RjEAwQMknWX8/wLBVZzDlGl4kNGiKwsfLg==
X-Received: by 2002:a17:902:7202:: with SMTP id ba2mr1377198plb.4.1597902252172;
        Wed, 19 Aug 2020 22:44:12 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:11 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 02/10] xfs: Check for extent overflow when trivally adding a new extent
Date:   Thu, 20 Aug 2020 11:13:41 +0530
Message-Id: <20200820054349.5525-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When adding a new data extent (without modifying an inode's existing
extents) the extent count increases only by 1. This commit checks for
extent count overflow in such cases.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 6 ++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
 fs/xfs/xfs_bmap_util.c         | 5 +++++
 fs/xfs/xfs_dquot.c             | 8 +++++++-
 fs/xfs/xfs_iomap.c             | 5 +++++
 fs/xfs/xfs_rtalloc.c           | 5 +++++
 6 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9c40d5971035..dcc8eeecd571 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4527,6 +4527,12 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_may_overflow(ip, whichfork,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 0beb8e2a00be..7fc2b129a2e7 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -34,6 +34,12 @@ struct xfs_ifork {
 #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
 #define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
 
+/*
+ * Worst-case increase in the fork extent count when we're adding a single
+ * extent to a fork and there's no possibility of splitting an existing mapping.
+ */
+#define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index afdc7f8e0e70..7b76a48b0885 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -822,6 +822,11 @@ xfs_alloc_file_space(
 		if (error)
 			goto error1;
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto error0;
+
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 04dc2be19c3a..59ea9485ebda 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -290,8 +290,14 @@ xfs_dquot_disk_alloc(
 		return -ESRCH;
 	}
 
-	/* Create the block mapping. */
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		return error;
+
+	/* Create the block mapping. */
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
 			&nmaps);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0e3f62cde375..37b0c743c116 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -250,6 +250,11 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895..9508ab00a00b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -787,6 +787,11 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto out_trans_cancel;
+
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
-- 
2.28.0

