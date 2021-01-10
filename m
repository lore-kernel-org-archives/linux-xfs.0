Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28447C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D3F22AAA
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAJDbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbhAJDbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:05 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF128C0617A7
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:29:58 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id v19so10294315pgj.12
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ubOW171teC9ubdwQpqHiQv4fYIYHgh/wHn9tXIiatU4=;
        b=SspcM/lfG5rAR7UJ0oLwrYXl8T14OZPsoEWQy0Qxun79eNq2tMQjDYJe0464vlmIac
         PRgs/FC0WGfnS0O8q1skfyiRXmp5VVyAcemWhI7DEiCFm6CkWubmpWdK1t7spaZvcuO0
         /yFpJd9CAOkNWvbylbzdmvIEeZOFtaIz/Atozjkxgh26IBIGk2l+eF+kjMblTWB0ZhkU
         t0sQv2xv6vhcr5V5aBmiLH/jy1lVUSlnBRjoqzSok9yhQZ0koZ/SRj9Qic7utyuTqyeL
         hsKWQJj5JDllqnRlomIb6PF6+/IdmteVzbNHCFD7Vdb4uxHGvz3JLBO8/SnBuFPrgpgO
         pb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ubOW171teC9ubdwQpqHiQv4fYIYHgh/wHn9tXIiatU4=;
        b=klKGTbvT+jO6Sj4Eae9f6eDfNDTqc54aI90aU9kt/0MJ21o4+GtsMkCAenaIwXefE2
         OaBkpFDr8Tk2rLQD0LjVzqqeDYseg4Lkh8zEOllyaU1zyrV40wFmAelgSwhHHhQ2HB8J
         0hE8v5a5XjaPsEcnRkzBP5diRnX7aDq+3z0xXby8ZfOOtbPaie/hz8vluSQOs432fqnV
         M0GtPd/0tr/eWJJrYwcV3uZvwSuw2QT+5ymWSlAFLM+oIQhrR1vCvKODxeK39/LA6HiX
         rdwim3PFU8ZVEEWnBo3c1hGXCAO6U8aAiOVHVQuxBsAbQ+gyLnqM0MMD48fcwfRRt6UR
         u2JA==
X-Gm-Message-State: AOAM5323hZT6KZt/rhixHexaXgUJA4KdXjNDYQyPkOD8Df2eTkjxS11l
        v+sf+mASvb0dYdQ8iAM4MYsG/EUn65dWUw==
X-Google-Smtp-Source: ABdhPJyoqI+imvtiPbv+SNjhbMna3TaQmPUMFZYAfREGyt6XCdUf4rEUKuj5v+YId0tpbhu0TIKlMw==
X-Received: by 2002:a62:1816:0:b029:1ae:6d39:b92e with SMTP id 22-20020a6218160000b02901ae6d39b92emr10652994pfy.81.1610249398032;
        Sat, 09 Jan 2021 19:29:58 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:29:57 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 07/16] xfs: Check for extent overflow when adding/removing xattrs
Date:   Sun, 10 Jan 2021 08:59:19 +0530
Message-Id: <20210110032928.3120861-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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
index ea1a9dd8a763..8d89838e23f8 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -60,6 +60,16 @@ struct xfs_ifork {
 #define XFS_IEXT_DIR_MANIP_CNT(mp) \
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
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
2.29.2

