Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B087EC64E90
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60890206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8mKvDsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733195AbgKQNpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732808AbgKQNo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:44:59 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADB3C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:44:59 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id k7so10256149plk.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sW8VLSVzgzwY91vdEfqsNHlu7FJTr4mIT1Hq/R3vhyo=;
        b=m8mKvDskH58HEKPEC77r1PykYiVMZvUKJ7k1MDYAeLYlst/jMSGW3OVN74ZMuSUdlE
         183MQzRDMzBopYwr/5Z9wCZcH0mL9knm183tkBQuHtwct1CuCNy58MvtAViBt/c2wYkp
         mN4lhm7e8yYXFzF0ecTEi+Ypy6po8pcIvT9/gL+8oCOn1tBodMoccEYDWGQ14LXZOMFn
         zaa0XgG8JAjxFVrz7UKge0utKgr5zLUjYC/n9KkszxJiuzeSde0qVOAf7dgh/qUSPDk0
         fvKrlwXTmfzi5vBwCpF7fTAb0LzbXjyH43NIaBTyJQJXunDr7f7CNlbzvYGO8x2JySA6
         j45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sW8VLSVzgzwY91vdEfqsNHlu7FJTr4mIT1Hq/R3vhyo=;
        b=pqasDImvHT4FGeKs/mXWu061+Gr5nPAXfQYShi3cVmJgZo/sZCvJteYUCTvFroKDAc
         ElfKXYiGV5zLTqTnEPmhPbAlXBIDGw2N0/aW9y+MrTTi/P/ne5FRDNpM4UPdzfR+GGWt
         LLsEix8DcCxtA1ctcJgBPIh3QeTjrsOu3ypCErzP1ae0GjmIXVtN/W9O7tXAE5HA9SbT
         CncOQrw70wtV6OPbM3PQFCAzS33Dh5Z0rnSHgqjxKQ/ldX4i7KXk7Ssbdgg9webQJ6bM
         GRzg9CVN7OHBJoRjAD7TRtyRiQI68gYDIPSH91NN24ZDJmB6L40iq79YurfA2pJhZcxr
         /ttA==
X-Gm-Message-State: AOAM531u7wDhvQpFIkxVTLJqDMWMZOQn2HuXMEXcvSmKOh1R4wdJorpt
        p2EKCPE/CAm6lI+ucilPLLqGgcc7yRI=
X-Google-Smtp-Source: ABdhPJwpHkXzaBBokMcashZA3uiOoWSWWwFO2XA3Otpzkb4iePqKwJlRzrAQ+nqlnmr/D6EzO65GGA==
X-Received: by 2002:a17:90a:4816:: with SMTP id a22mr4840445pjh.228.1605620699058;
        Tue, 17 Nov 2020 05:44:59 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:44:58 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com
Subject: [PATCH V11 04/14] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue, 17 Nov 2020 19:14:06 +0530
Message-Id: <20201117134416.207945-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
added. One extra extent for dabtree in case a local attr is large enough
to cause a double split.  It can also cause extent count to increase
proportional to the size of a remote xattr's value.

To be able to always remove an existing xattr, when adding an xattr we
make sure to reserve inode fork extent count required for removing max
sized xattr in addition to that required by the xattr add operation.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 20 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
 2 files changed, 30 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd8e6418a0d3..d53b3867b308 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -396,6 +396,8 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
+	int			iext_cnt;
+	int			rmt_blks;
 	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -416,6 +418,9 @@ xfs_attr_set(
 	 */
 	args->op_flags = XFS_DA_OP_OKNOENT;
 
+	rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+	iext_cnt = XFS_IEXT_ATTR_MANIP_CNT(rmt_blks);
+
 	if (args->value) {
 		XFS_STATS_INC(mp, xs_attr_set);
 
@@ -442,6 +447,13 @@ xfs_attr_set(
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		total = args->total;
+
+		if (local)
+			rmt_blks = 0;
+		else
+			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+
+		iext_cnt += XFS_IEXT_ATTR_MANIP_CNT(rmt_blks);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
@@ -460,6 +472,14 @@ xfs_attr_set(
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(args->trans, dp, 0);
+
+	if (args->value || xfs_inode_hasattr(dp)) {
+		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+				iext_cnt);
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

