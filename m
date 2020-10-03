Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A99C4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51F82072E
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vPc36Hyb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJCF45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:56:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AC0C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:56:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so2449604pjd.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sYWqESdT3CFEP/9SblnZ7bhEP9vwdWStxz+7/UAVdpM=;
        b=vPc36HybHmTc2oTgpdElGPaYvybJHXi+OiOPm/vC6zRhm5xTm59M5fBaB2SAqoDx2L
         4WKA8uKeOTaPSRj3yquZEmylSGaucAMhdjcnjx6+gYXlMhhKEbeVoftv9lAU91/tBSeJ
         Wo6nJYkZcQokazqXbywalkbfoKHIalknHrX0XJJxLpRjpotnS0ckaW5YdD0Y181qSEZA
         bK6TELuUH1hx5JJJdN+7t3HuoZXLYIkkftmkZnO2EnDS0SabIyqX2D2d04ZR0C4VQzdn
         AW5M47uNYgv2wpvLt3qYhoKaXqT//uXaToaemOv5eO5fHlfgvIuBnw7Pb4Ds2Ji7q7Z9
         mGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYWqESdT3CFEP/9SblnZ7bhEP9vwdWStxz+7/UAVdpM=;
        b=i7KxqriiP8okBQL0Os9ucLO5C4jw1g1SDw+tUhQWwBjjOZ3TvxxO9xcF3HLKhbonQp
         ptMXkVElr6LxWKXad+rfnzBzCr7CbYdKkbSpJCBIJw0dW5IZ0RkvleWy9uj7mdl33YE4
         dMleFXwba6JYOyAcdqVPMJv+lgXgPaORtnmmzRoIuuJgyAV5VUnaVtMiLCyGYU+yNUn+
         8przM9KxFOqSFRjuRqcv3+7Oj5Yt0lywj+WI22s3R7lgEg7G3KfPJ54gWdHeghP4tNye
         z9oWkn9EF2pFP05mdHGlTyRkMM0SZf9u/RwNkLeFAs8PC+/fWe2CqEcfiPkFlu8biqVX
         zfCg==
X-Gm-Message-State: AOAM530rsMbW7I5WHQSIvAYdaDd6VRSKN1GPX56AF4S6HFyr156L6+VK
        aF7H6nJrLbAN7tIUHtXcFr/gkUeO780kfw==
X-Google-Smtp-Source: ABdhPJxLfjFMWORqMMTFzuaNy3UgrQIeKw0fZOCDDgTNNKVFCrXGZf7B8i5JZTDJZMqMuPWu6Ox4DQ==
X-Received: by 2002:a17:90b:1297:: with SMTP id fw23mr5968602pjb.184.1601704615340;
        Fri, 02 Oct 2020 22:56:55 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:56:54 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 04/12] xfs: Check for extent overflow when adding/removing xattrs
Date:   Sat,  3 Oct 2020 11:26:25 +0530
Message-Id: <20201003055633.9379-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
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

