Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC402C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7309B206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkYL6Szl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733190AbgKQNo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732520AbgKQNo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:44:56 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8B1C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:44:54 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id p68so5647062pga.6
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GhuaEjtbG0//r4IvHlnEcQuD/mUoLWUJcwfcoO/yi10=;
        b=ZkYL6SzluCFa34+fsCxLU9qV3ZdsInyek9Ls37VheDGo6+XhNp9J8uVa4v3pS2gxZ6
         Q9tM3C0IWCHm3sfy6LiGgoKEcb9WEK0xulILZlpY2ufMx5H/pm1hNJWzznM0+L7P+yCy
         nuJvf1nfGY9Sjb7KZM3lHzDm+xV6/bwf+eSbTf9pIci0CSkaEe224rQ+QNVvdau7kAPN
         f1ybGNcZEP8lwtG1cnGh1NWTaUu5J+JPGQh7qQD/fhSulSSj77ykqXnTQbNxf+lhRLtk
         PhOQRrKhUuWRwqHD9zuEGLTx64capw3loQkn6aLUot+CxkxxdtQpNShdPqeX3NJ7opDj
         tbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GhuaEjtbG0//r4IvHlnEcQuD/mUoLWUJcwfcoO/yi10=;
        b=UERALRmFSvmOq4HFaayQPWcSrIByWq/WIpFwm2a8y6RHEyZ9U8RXqh6QA6N+JfDOG+
         2oH3GitGPbAiaICgMGk9UEnSMBOnLogrSod34m63NOzJdaQzcUYCcGaE+ocGtopG1QsH
         3KYA9ObukAFYXurPIC1ZXFsgj/1tEMBLhQgSUclvCVexVpTLFB5pjxmUkisEt1oxugjO
         fgHq/U2usXTZHoI2GXx64PF8HjCcAIKrE+OzYEnBJzFqierRsYlK7E2jBkxelDf1f1gr
         QB+63JtpsPbeZOwtecVj+K4L7FdevUiWB76ME+0RPPQhdaSSBww/85ZuUzpD+z7bhxE9
         N60g==
X-Gm-Message-State: AOAM532zwAs5SPv/g3yppvDDBJlyvgEeHi5Xoh+I8gn0AnIGHc01cwtB
        +NaEWOBrC4pJA8VsnSWoHdiiw2QXYoY=
X-Google-Smtp-Source: ABdhPJzFm+ofhJIRQka7sbRRqM6wfuSqKa6K2HwCZ7G1Pe9JTI9aeOLmfiAFhmP+Y9Xri0xqIynQEA==
X-Received: by 2002:aa7:9f8b:0:b029:18b:9c0e:a617 with SMTP id z11-20020aa79f8b0000b029018b9c0ea617mr18011693pfr.16.1605620693775;
        Tue, 17 Nov 2020 05:44:53 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:44:53 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH V11 02/14] xfs: Check for extent overflow when trivally adding a new extent
Date:   Tue, 17 Nov 2020 19:14:04 +0530
Message-Id: <20201117134416.207945-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When adding a new data extent (without modifying an inode's existing
extents) the extent count increases only by 1. This commit checks for
extent count overflow in such cases.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 6 ++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
 fs/xfs/xfs_bmap_item.c         | 7 +++++++
 fs/xfs/xfs_bmap_util.c         | 5 +++++
 fs/xfs/xfs_dquot.c             | 8 +++++++-
 fs/xfs/xfs_iomap.c             | 5 +++++
 fs/xfs/xfs_rtalloc.c           | 5 +++++
 7 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d9a692484eae..505358839d2f 100644
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
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9e16a4d0f97c..1610d6ad089b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -497,6 +497,13 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	if (bui_type == XFS_BMAP_MAP) {
+		error = xfs_iext_count_may_overflow(ip, whichfork,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto err_cancel;
+	}
+
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
 			whichfork, bmap->me_startoff, bmap->me_startblock,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f2a8a0e75e1f..dcd6e61df711 100644
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
index 1d95ed387d66..175f544f7c45 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -314,8 +314,14 @@ xfs_dquot_disk_alloc(
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
index 3abb8b9d6f4c..a302a96823b8 100644
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
index 1c3969807fb9..45ef7fa69e1d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -804,6 +804,11 @@ xfs_growfs_rt_alloc(
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

