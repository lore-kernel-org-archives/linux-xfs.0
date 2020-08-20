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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C90C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF700207DA
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lscIa2uq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgHTFoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgHTFoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782E1C061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so614339pgl.11
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pu2hd/KCl6mXkYJcW5ULiq2me8SngIvCViXvCcRpi6Y=;
        b=lscIa2uqJYVcGWMupeqgHEJfG3UWe32ON96yrJTZBtAC4NPn1QulUCgq1w/3FE+9BE
         Oac1GOpsnELPtkcvXX80IbSgYnZL2D5G4sX6xZWDz/Mdm6raPWCvfoQbxpdYfwL9dSsf
         aGzSllPwAK1yEMxDmpJSAIpqJlsE4rxWxGm68z1J2X6ZvNJCIOdzaWm0ULGUMUXz1Iyk
         5+OS+ogh16ij6iutjtlnpm5q0vtvZ5x0XPCyW+8/ni4TS/nsuXALs03C7R7p83c1DkPi
         044KZXKVTxB07NK3yWwHXOwETfaYpP9oPTJT+3XX1/fGR4TDhPU1RZtTRMfIWrgi8ygT
         WVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pu2hd/KCl6mXkYJcW5ULiq2me8SngIvCViXvCcRpi6Y=;
        b=XpkBxqpSIDlyq1ILzjV60U41VgFV6etvgeXYAXFTC2GxgojyeFbHIEVajRJGIJLEtM
         VGghZrOPPeYV5WvZU9EPm7NX/xITB76kpsfiXDbh78ejACBfYeZpk+enoUZHN2Lt5Scr
         0UFIfSMM5R0eolJ8tilC63e0v0QEducR1pBzD2i9e+DchXcvglv1I1Eq9Y/y6VUcw6u0
         XT8vZLjXJz5+XqcS8GC4Qle4CDGNWySIRTptOVDlYn+5C1N7rR/L/+wLf8qUVZSXyv9L
         3tkceMc/FyoRVKoeLSHjVbdV6UTVEp9xHgYeT9F+AyDRQm2co2qw8H/huAF6Veq3pYHq
         PZ6Q==
X-Gm-Message-State: AOAM530vsnHRKu9ljIaHdthofFLCtZGgPqCvO54V1kIuVJxeJihy2wWV
        ttoxchMkQ8dEY3BzpPnbEshx3iPzY9o=
X-Google-Smtp-Source: ABdhPJyFzABK6k2ImYxfR6a8YA/iXFDNmE0+/BmxdVUjD2gohxTI+m7U+oVsmlmXv60X3UX7LXOKww==
X-Received: by 2002:a63:4726:: with SMTP id u38mr1397100pga.246.1597902257781;
        Wed, 19 Aug 2020 22:44:17 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:17 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 04/10] xfs: Check for extent overflow when adding/removing xattrs
Date:   Thu, 20 Aug 2020 11:13:43 +0530
Message-Id: <20200820054349.5525-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
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
 fs/xfs/libxfs/xfs_inode_fork.h |  9 +++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d4583a0d1b3f..c481389da40f 100644
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
index 2642e4847ee0..aae8e6e80b71 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -45,6 +45,15 @@ struct xfs_ifork {
  * i.e. | Old extent | Hole | Old extent |
  */
 #define XFS_IEXT_REMOVE_CNT		(1)
+/*
+ * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
+ * be added. One extra extent for dabtree in case a local attr is
+ * large enough to cause a double split.  It can also cause extent
+ * count to increase proportional to the size of a remote xattr's
+ * value.
+ */
+#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
+	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
 /*
  * Fork handling.
-- 
2.28.0

