Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BD3C388F9
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6357F2344C
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtD4ZdBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgKCPHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgKCPHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:07 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE81C0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:07 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id u4so2077364pgr.9
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnzW6ZRTk6jYpEdb9hSauPeHwb+Af98DVjIElOxlMOU=;
        b=WtD4ZdBTgLyxurH+ujaLpTY8aWkKLQW9ujQRzb4XO13p3RY6161xUP1ezep2Vyrgrd
         0+SU1LO6K12LcibREAyMHuoCJzJ7ZAt9cpRgFKBb6lfdxkScp7oCgyH2Vq2hFhy+5zXI
         PQFQ8YTv6zINmyuouwHqzQrsiWwlbE9asDevrImSipnoL4BkEPXZZ0mtdk+/SVv+573k
         ppThLh/JdFdVVR78REkU4SuUSRo0c8tU0L0jatr82ZXOaU+2qwCmgpjpbC5VaUU9W5Pv
         3kleETG69pd0WECXEMXV5bugrUtFwATu673xySrXqq9dMMyOsltweKFfyMGOXlV7F3ky
         c6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BnzW6ZRTk6jYpEdb9hSauPeHwb+Af98DVjIElOxlMOU=;
        b=DhwY/crN+5S5z+pXUpv9yFCs1d9iadoUS1Ip8QT7MQnA8gtWyK8ACmfzcbXaS1JozW
         LBCJ4vMuRjxFnxB/d+WXed2aiRNIwuMEchfk8wdiZHfPBewX/pzPq6Irh2cA6IJHd8t8
         8SnoCXeUwiB9n7D0qgbKRJZsRr0f4UkHkPa1mOF4I/d0LnlMBuONjFj2tkb9KJRSQBYa
         ZdVCuSlPF8LM7rrDvl3D31/SkeoWxwC1nEBmAQmmCgu3E+UR7yEJRa6kLb+NetF4JD09
         s23mxzNBH9vDSpYTMChVT74+x8dSXTCXvOwt/RcuyemP41dcZ1a1kZ52OUMKLBZ89i5M
         4vwg==
X-Gm-Message-State: AOAM533FzPrOiQNue3GpITktAdXerR2qWZhtVpk9vLLgZ4DtwES6sG1f
        I9ipQChp7VSoNOWVkkClcYDs0vgorKrwKw==
X-Google-Smtp-Source: ABdhPJzocrrxL0Bq9DA0izBtpDs3k2rhAfT948pagpBuKqPhcgTOwVL51aZeQAQ3ZC+BSvZkfoOlFA==
X-Received: by 2002:aa7:9e03:0:b029:164:427a:8f94 with SMTP id y3-20020aa79e030000b0290164427a8f94mr25362598pfq.5.1604416026403;
        Tue, 03 Nov 2020 07:07:06 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:05 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V10 04/14] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue,  3 Nov 2020 20:36:32 +0530
Message-Id: <20201103150642.2032284-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
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
index bcac769a7df6..5de2f07d0dd5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -47,6 +47,16 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
 
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
2.28.0

