Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E21C43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1225921D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CB9JSv5h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIRJs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:29 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF74C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k13so2728533plk.3
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sYWqESdT3CFEP/9SblnZ7bhEP9vwdWStxz+7/UAVdpM=;
        b=CB9JSv5hwwQ1tlUiu300nPf6Jf/TBPRzOtksTbpEuWW3IucT6x14tWeSGthyyGfZOV
         rEfg5oIL0g7CkKKoVGX+KxCelUDgTqxJzVLV8Z/izsVOF+HfG2ru9K7dta/evMAWUGQy
         39EXBzGsjhRRIhOktMpp5FV0JxOcVcISyePX7XzRcI9mCCCWdw3d+e89OMLIt7chfJCt
         ulm3CezhrH9EEzzx6wiuILKUPSAfUmJKVQF+NnzwhmxulCQb6xysBJ/Bwow9d5AduFll
         IRQ/khfYVh6ekcjxCqEIcRw2K1og5h0kf4PtvMTNIjqVNbHse/BB/qL6vknKMX9fsajW
         o3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYWqESdT3CFEP/9SblnZ7bhEP9vwdWStxz+7/UAVdpM=;
        b=JPmKAQebMoy1Plp+QO8UgOGoKpvbZ8Yt79ZEKXTrNoNnWX2i6BWrSeiupPkEOT4BRe
         ElUzahHe/BBNe6chyaR7b5M8LW4xwqkE6n3dNJ4NtHyBxN1a8vJ6qYkk5HJFUw57QexZ
         0LMOUv5ryRTQrhTDyulBUF9yrq1nnEhEuM8MicY9yW+QTFKJIPVSRpgH9FwJqg5AwqSi
         kKHI5s4COMm5y4+uvxnY4gpXzCSFc9hkyKfn9Y1R9O7hQWn4eCmNtMBaD7FNcV0Jvp3A
         s0QMfIMiJYYxLo09Grs9PImJJapiAOExIxu7h5bfe6azDmX7vuUhBknBhLdADLw0Txi6
         vK1Q==
X-Gm-Message-State: AOAM532qbsoKwuBJ7kM8kATpNX6c4BJZR9kfTGU+FC2cSlXqve61Jmjy
        AmEz2hPmm6IUCTUw0ySfkqLtIRTdYL0=
X-Google-Smtp-Source: ABdhPJwT4Z2e8GIkXbbsYVLG8kXx9IcjW36YiYRRwieoIZ++3zEWlOYQCVHm5i1Nxnu3JqGqjRoy3Q==
X-Received: by 2002:a17:90b:e90:: with SMTP id fv16mr12174200pjb.69.1600422508790;
        Fri, 18 Sep 2020 02:48:28 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:28 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 04/10] xfs: Check for extent overflow when adding/removing xattrs
Date:   Fri, 18 Sep 2020 15:17:53 +0530
Message-Id: <20200918094759.2727564-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
added. One extra extent for dabtree in case a local attr is large enough
to cause a double split.  It can also cause extent count to increase
proportional to the size of a remote xattr's value.

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

