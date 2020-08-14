Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0D2C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4684720771
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5AbLLsp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgHNIJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:44 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9162C061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u20so4202198pfn.0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zwsByGDQ/Brl0QGJOkczOMSoK9UiaUPqznnIa4fy0hQ=;
        b=c5AbLLspqYVnAwTHiv8ix6jzHdPF0BtUB3QDgVD1gOh4FzUREPDQejTwd8RyolDPpD
         5FdiCADp3oKZEdbTpUtCaXtr0aGttwa6fv0RoNGYL1GVu5ZJDJca+09sk5IpeBUGarFn
         sV/DukqfesH+45p9RZeX4unWnJrxnz5G5EguX/oC2/10nrCJhjQYGnQNsNfuFAUvDz++
         qVjsNPBDlNGqnB+OENkf/Ylgr8RPouX+kUx5S9UAwMOUe5ZeSVjcgLe69WXDk/hwSFAr
         4NJhxvP6gsjkyqsOtOWPFwJlJ6RJK7pi7REempHJICIeEZ6DDw5H7wafGgPRfWmThayh
         IElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zwsByGDQ/Brl0QGJOkczOMSoK9UiaUPqznnIa4fy0hQ=;
        b=Svgg7DNMX/cRTOm0bc7ne3hnwGQ2wo/7dPXheSb5QYBkiUAm43K2eFyIYtlO1tjxwX
         KWKpgcOkMVh3cfTDLDsmYdHC3rg4AblFWL6oiEXHmCai1CnTrJPl+K+gRX9HXDWEKBVa
         Heuat4Rb5EbRls+ve+nD0gbGSQ6wMMDBumm7/3CbZZoG3BUOfvsdLYKpPyV8+VNjmuNl
         tUx/ZBM92BQUGPzIIBfLPOreK1dIKDXFLvTYRBZ38dGNwjDKT+UP5eEW4MLx3X1yj0b7
         WYXqi67MNaHwlpJl9viteW7o7DtR9SnPHvD9H03MzhEysonlfEiQxaFDkC3sX5xytp6B
         wv3w==
X-Gm-Message-State: AOAM532XTmiSKEBoSBscDFptl5KljoYcOhH1TyyRwzPKSSAle6YqAD3H
        bgwmOXB7c1B0pls7KnGr3aZSDqsFRh4=
X-Google-Smtp-Source: ABdhPJy7dpt67l+hlRQ5oyfJ/mCfXgYv7WS9MEQIc6U0lFoAnH3vtfAFG25h0JnIvHfNIS88PytFbw==
X-Received: by 2002:a62:82c1:: with SMTP id w184mr1048752pfd.202.1597392583993;
        Fri, 14 Aug 2020 01:09:43 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:43 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 02/10] xfs: Check for extent overflow when trivally adding a new extent
Date:   Fri, 14 Aug 2020 13:38:25 +0530
Message-Id: <20200814080833.84760-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_bmap.c       | 8 ++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 2 ++
 fs/xfs/xfs_bmap_util.c         | 5 +++++
 fs/xfs/xfs_dquot.c             | 8 +++++++-
 fs/xfs/xfs_iomap.c             | 5 +++++
 fs/xfs/xfs_rtalloc.c           | 5 +++++
 6 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9c40d5971035..e64f645415b1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4527,6 +4527,14 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	if (whichfork == XFS_DATA_FORK) {
+		error = xfs_iext_count_may_overflow(ip, whichfork,
+				XFS_IEXT_ADD_CNT);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a4953e95c4f3..3e7e4b980d49 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -34,6 +34,8 @@ struct xfs_ifork {
 #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
 #define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
 
+#define XFS_IEXT_ADD_CNT 1
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index afdc7f8e0e70..c470f2cd6e66 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -822,6 +822,11 @@ xfs_alloc_file_space(
 		if (error)
 			goto error1;
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_CNT);
+		if (error)
+			goto error0;
+
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 04dc2be19c3a..1293e7a752c8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -290,8 +290,14 @@ xfs_dquot_disk_alloc(
 		return -ESRCH;
 	}
 
-	/* Create the block mapping. */
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_CNT);
+	if (error)
+		return error;
+
+	/* Create the block mapping. */
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
 			&nmaps);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0e3f62cde375..0af679ef9a33 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -250,6 +250,11 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895..c2bca6ad2533 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -787,6 +787,11 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_CNT);
+		if (error)
+			goto out_trans_cancel;
+
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
-- 
2.28.0

