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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0CEC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E5CF22260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2vwAMn9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgJSGle (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65043C061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:32 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b19so4499950pld.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oVyvNGULGulgdR7oslYUMz3NcAvyS5HBRlENdd6QKHA=;
        b=e2vwAMn9dCwBZ0yEAQPXwnZh2REwNOHfHzKLG03BABg6idUt7ncmRromE5a8wrnoo7
         GoV06aIDG/zpE011TVzDnpYV5EKJALA0zLIWGH7rD3IjVvwmwrCAwyymVBbAqG9Jab+E
         RPIJ+U5z85nXA95SfFRPQ8J8bGjukRBsO2ZvubTS3pUt1XyiM5Vh6y7Oz0XCT3GSosEn
         //wQeFZMyXcfKyETNmdZFzDVIlF/Cvtrd8L2HxlJ+OtRvlTexRezeRUt+neVnFPk1dce
         1jHpqJ85i9hczCQ3EcSbPnHlyvAmgWN+RVgWIVglSfb8YM73fRxdDEuoM3TgWCn+/bpm
         26Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oVyvNGULGulgdR7oslYUMz3NcAvyS5HBRlENdd6QKHA=;
        b=KvMwXnBavFvmZxs9s3dxNfYM3/BhePEj9EChS2y8WuSeLx4ws5SyEZb/pb1vTJIbAG
         Fc4m15mzuWs5T2uGrBqYB6Jw26WqdS5Naa/nnF6aa5zVAJhYkf/GQsRGhUOCTwq6L3NK
         CJeyjipROyeud2VzxzLZrupnbxTPliMYWqKFQz6ZP+sCVlhqvKYZYqkTGem5A6I3RCJ/
         UIwbmi1bLDloJsVVuS5JYMHYQ7+6KYwQ9Dk/xNenOWN0cVC50Ja4u0ClzF+hlJ37uOIp
         WQJ7hk2FGJVPSXnPFqR8kfmgxYZmESUH/XBZ7IQS9f76PzBWa66rwQlONWbNzejrUN/T
         uOpA==
X-Gm-Message-State: AOAM533U8CBvR10dArD901/XXW7Dbdw2IgXeFmk0JyLd1Ype0rtiWtZe
        M+aboMqgj3V1l7qoQ3yN5CMWtxKOlGM=
X-Google-Smtp-Source: ABdhPJxWTkIQx1mYCqMBawVXxXOU5KpniSF8v7BEB7SDfFee9ZacWf4AXFGKg/Qq89IpmDqCaDY1OA==
X-Received: by 2002:a17:90a:f187:: with SMTP id bv7mr16502651pjb.198.1603089691680;
        Sun, 18 Oct 2020 23:41:31 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:31 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 07/14] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Mon, 19 Oct 2020 12:10:41 +0530
Message-Id: <20201019064048.6591-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index afb647e1e3fa..b99e67e7b59b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,6 +78,15 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 16098dc42add..4f0198f636ad 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
-- 
2.28.0

