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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C37C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 702992068E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oz6kZl6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgHNIJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569B7C061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r11so4176749pfl.11
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8W5cvIIWzE9EtYvDSv/lTYlra3JGo7xOtylNStP0mK4=;
        b=oz6kZl6jExRxBAibBSYiOTbsMA2nQ3qd0kcI/SFuP6SA8Yk9xZrD9aCT68HXAaW/0a
         iuhTr+9y2eDm81bZBKave1k2hJAoAnhBoYu5XUxOpJ2gHlH5KQcCb8MyCr9QwhVXMBOI
         92evs5m68vUIGVFls9VZlRUqmgApV5iqkPQneZASLezxNEH0Q79I5PWVW/Cxiin/Ph4o
         TVOBXfx9vi2R1aYq+M190ffDDCbMTWsFh3ybH3co5law7KpkBptBuCtNlRbGfzIuF7wI
         kTIMS91oiHUCMPts8Synh5PptXKYOUK/WkQ3ASa781PVZC8QWW0u200aOq6Wpo1dHPxf
         qGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8W5cvIIWzE9EtYvDSv/lTYlra3JGo7xOtylNStP0mK4=;
        b=iicOeWZOiUS7iDm0hMIUl41vEleVS1W9mFvxnVjDbVxYf/hnPlcZsIWLhKiEMQUcyK
         ZFYH7XvRQN6Kf5Rdzd1WqnYBQiRvBsfjgl/eLg/DES75d4QINssG6DJUXG+U7tIwr1KE
         zd4tjh28TqIVEOugWAuX8VOvZuDUp55HicS2yvo8/iokPcfu7qdMMfon9HULbwate90Q
         QznJMr74sxx1OPx1kHDo4Bv4OsxxlN9GbfVB8FKFcIscw33+vkhyKXy1zmlzsauvmThs
         e2fHI39guF1RrypjtvjTcNOiYxyR+eLHoc656wqkfKmh+AcoXAF8p3SImuG1/ZZOWCwa
         Cpgw==
X-Gm-Message-State: AOAM530pJWypK905QSnxKkZbHdlZZjlPrTveC4Vg0ksHJ+xwqw5xPymE
        JSAXJeLc+FhmyofRa2+MiUUoclvfAoM=
X-Google-Smtp-Source: ABdhPJwB8WH9RZLXAR2qEm2IjVNJtOZcnbiAy3egBEPswIrWK3QMvssCpdl6AjXwWRgkhVHtqIvoAg==
X-Received: by 2002:a63:dc4a:: with SMTP id f10mr986504pgj.394.1597392588597;
        Fri, 14 Aug 2020 01:09:48 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:48 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 04/10] xfs: Check for extent overflow when adding/removing xattrs
Date:   Fri, 14 Aug 2020 13:38:27 +0530
Message-Id: <20200814080833.84760-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
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
index 228359cf9738..72a9daf5df16 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -41,6 +41,15 @@ struct xfs_ifork {
  * i.e. | Old extent | Hole | Old extent |
  */
 #define XFS_IEXT_REMOVE_CNT 1
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

