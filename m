Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A228EC2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447C120790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUgyhfnB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgJ2KOg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgJ2KOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:36 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72136C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:36 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x13so1938196pgp.7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnzW6ZRTk6jYpEdb9hSauPeHwb+Af98DVjIElOxlMOU=;
        b=PUgyhfnB4eC5hH06b5Iz2OVBpzD1Dp+0W71cqWx2l0E/whZV6nkXyVgZXdaqfPsIwJ
         MV7kQgx6cF8TrOob3UKCabY+cESZvgtK302ElRyvAeK1LniMqebI7uGwC1A+YNnbEsUX
         oy28c12hvilCCJMUXASRuucDP23ebb+rNy3wUT5NK/8nhGPnw1zXHj6+FhRl0C0jSwwV
         2H/iCuH9qQCWm7Bp1iwtG241Bk1xbLEXYUz5+Ulru+KSxwvZR2Bm/bM+hRw7V+3mueMO
         rf4y7TOi7z+CY04RC9R4V4Fo+lDc/SBbiOkYqV8zM3N3Rcx9RsoVHMV2XDPLGUf4DFuq
         EFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BnzW6ZRTk6jYpEdb9hSauPeHwb+Af98DVjIElOxlMOU=;
        b=epChjfIjwtWxVTsyH6RW9JLOhlSJ7LLdMDR0M4ThO34RZ5ekPrQ7hQFxT8NbCJossI
         gaiLpKlL168930kt2U+aQ7CTlHeqJQZ7sRYlC642W4g6+GyPWwnWR5lVWlljnG1/jdPy
         OUWlvTlIWloAzMDAblIgA/PgFCK0FA0BYwNWJdU0AUXku1S2YlXc5jJvqdKn76K93YC7
         idPtOtknI30nM9tWWwTc8zr+EDHyLPHwUQ6vlN+rxrOrSspg3HBRmp67jSBTQEZ5v9xI
         SwhmLx2bspQ4ymm9gcf5DzAoZWTv/x/En3eKrw0oi0Ns+3/ikl8cgV+84MW4ynK1WC1f
         lO2w==
X-Gm-Message-State: AOAM533fo5oaglzJzpzDeondl/pqHDyUFOebFk7Gvu48C2b/iyYQAFxt
        Er8LcIll9VQvS8pivw8c92kuhg6CdLE=
X-Google-Smtp-Source: ABdhPJzicmjoVqXVV4qDZHH9B3IaDXLdxPVLCu5AMLItk0p9/zrMeby8RXPGQ50Oy5yOqTMhdfiVoQ==
X-Received: by 2002:a17:90a:4587:: with SMTP id v7mr3634844pjg.217.1603966475769;
        Thu, 29 Oct 2020 03:14:35 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:35 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V8 04/14] xfs: Check for extent overflow when adding/removing xattrs
Date:   Thu, 29 Oct 2020 15:43:38 +0530
Message-Id: <20201029101348.4442-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
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

