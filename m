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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C47C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C0522263
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1otJFtU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgJSGlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CFAC061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id h4so5094263pjk.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5B+t231keE1jTHf5wlh6nlSBqHnUwdv0amrbJatXjX4=;
        b=f1otJFtU1i78BnK9DOg/67By1pA3ZtHSNlZh0x7ezHy05LAaGqvucZc3uwo6VpdzAL
         P8vmDfMtb4B+3aP5TFA+ZbTYjByvIdyg37P1INSGt2U718W4X3kinmNDJOG6NvbNDEab
         ZfexDDhfx0ob3FiwTdXVunzt9d+JiPypOHRe3Qk9zFyfHjzIpXpLMYEMRWpBPm0aZaA+
         1qM0A2xELxU+s1n9c7VIPYCzevUyF582qR6D/UO13H4S3fkJJ8WcWlxze4C/cU93Uhkh
         fv+B/x40HfEjCfOnbLNiqdmdUvXdQaAOvgLO7uTdEkYrLZITWYqb/ZQcZjytoMu1p2f3
         ivFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5B+t231keE1jTHf5wlh6nlSBqHnUwdv0amrbJatXjX4=;
        b=FNo9t/Sroc6X5e0FjKdn55kYYNGS1339P56nr06vZjhSYPl/dgRBNZyBiHGejf+LNk
         CmIk6npmz2tOonEaBiUztJei2aj1J+jRND/zfDv+5fkXNzHQbx+nG0sJSdawknEzEbl4
         oBrn/BKuBblA1yaU9oTHi2ju2mnDRMa2dw8ETvcPuXRh8GQ/mOjTkFda5i9yLn/S3qMy
         N0rF/rqf8wh2paZ164gaCCE8pvDQXIxGBqViO/mXWGBqUiyakpUX4HAXwLfz9S68IDsw
         P4XQRxi2shepKtl6L2K5Bhl7Qsa5cPW2Qfqqzp9yIiOQT5twr3/cM2RTvQxNUGG46Pp8
         ptjA==
X-Gm-Message-State: AOAM532k4XtAQr95Z3sjGv7ysnrgJQqRV+DLjejZwuxGW/0FZRSyx/dY
        lpy6f3YQBgIDrogtyqVPb/S03xrDdPY=
X-Google-Smtp-Source: ABdhPJzYDA85/KOR2w8Ndlhe+r2qqRPLUzbf0hVu6Ub6AR5FBksReCHgeU65HyKd8JnVXHpECosvgg==
X-Received: by 2002:a17:90a:6444:: with SMTP id y4mr15516014pjm.203.1603089682609;
        Sun, 18 Oct 2020 23:41:22 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 04/14] xfs: Check for extent overflow when adding/removing xattrs
Date:   Mon, 19 Oct 2020 12:10:38 +0530
Message-Id: <20201019064048.6591-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
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

