Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FD8C388F2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C58EC222E8
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpYAYdHJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgKBJvM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:12 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DADEC0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:12 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i26so10320806pgl.5
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnzW6ZRTk6jYpEdb9hSauPeHwb+Af98DVjIElOxlMOU=;
        b=IpYAYdHJ9ATF/VIdVOdkuxzDOJXWpG6/NC9pVYalgV2t6iSzEIDgRCjPyrk6qUSb2/
         rERx3ihvk5UKEHQXSSadaKF88SWhHFSqm97ERp0DrUIRWFEvuaidVCUpv/XBPQXROdMV
         Jsxg8CYdXedy+jiAXReSq0tugrTukC+ZhKwXHdAp8dwguEpwiRN6+ko9tZyBkOm7W/wX
         DPGYBc/Cx6FhW8/RAKcGggf0/f5kTusLDGu6wBPL2VehoFTBzJnLm9y9g32eI6BA83p+
         2ttSNXdBYaSjayufVgtN/BbLb+AjE2CkV9QlWnud477A9CNMyojpILjWK+5l3TN5LRtN
         nNpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BnzW6ZRTk6jYpEdb9hSauPeHwb+Af98DVjIElOxlMOU=;
        b=cVsDETMHpFtqVlmzaO0+N6MXMxzcvAH+1U2SXL2rsg6ltXwfK0uaVJVdumNZhgagxa
         Bh2ny5qSI1KGGlpo9n6c/RuhPG+CBPMTRMfFPpRaKrCF1ImjDQzaVXehkWIjPAX9f0u9
         BBZkLjMZPujz8lnnplYsQPZhsa/B6Z8gXsMJYZiuUGR/gyPay7m7SetlDU/mYCP5eDFH
         h4y9pUsBLCnoasQANOVkthrJjuNBllZJNoHO9+lMu4Vecm0QSo5GLYqxO+KR52hrsNW5
         YPfsTGNRc2dCZdLxeQQ3L40u3h2yAWn/W8/c4EbzKXzYCZkJQrZmnA2dRnTzW1U8k8Sx
         MhzA==
X-Gm-Message-State: AOAM532HY3nKe9yPkPhmJey3MJ5ud1y8J59G+Ly1CCi+vwauCFNSo22F
        MIvuXg9ZhY2gYVcRi2pLb5kSZstgVUQ=
X-Google-Smtp-Source: ABdhPJyzbeA2ri0eH0sbOQwT1wt7v1jw7WTKkAQIJ4+jhfMvMGscgGgCHmQFtCrL1D5T0rdcFTN3uw==
X-Received: by 2002:aa7:87c2:0:b029:163:d092:86bb with SMTP id i2-20020aa787c20000b0290163d09286bbmr20885402pfo.68.1604310671506;
        Mon, 02 Nov 2020 01:51:11 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:10 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V9 04/14] xfs: Check for extent overflow when adding/removing xattrs
Date:   Mon,  2 Nov 2020 15:20:38 +0530
Message-Id: <20201102095048.100956-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
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

