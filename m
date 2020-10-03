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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2525C4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA1F2072E
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6VUFZBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgJCF5I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:57:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBC3C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:57:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f18so2926752pfa.10
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ywwxaWegq7wJFWe6P4AjCvm9F/012YEjv+rllIjHHJo=;
        b=W6VUFZBaJLki0e8im2GEQAu6rAW56R4UYPRRVZgCyR9ydbMNb6Rr9L26zs5TxRQcxP
         sRBPWDMO45HvbKBBNJFifqqjhNhmrIvr4Aq9ESGkkVnYBGb6CYpXJynRwVgSnXH/4K8J
         EYm8KlU0886LXaAIhgNFAIb6AtcGLD1nd+iSChWj1moJ7Q6hDCxAiA718FE6KyshvLOb
         EVUyoYD8yO0LbyrEA/gJMYFT/TWUygbOzrX69KWGWjj+ss5n1octS3uJuw+F85nbngqS
         th8EraUXc+++p9Yn89ZxFVNL2GcYUF1+TWn4QEpvP6nX5JanICZwoRY//+r+8DgNDdDs
         NfQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ywwxaWegq7wJFWe6P4AjCvm9F/012YEjv+rllIjHHJo=;
        b=K2UP3AkpO5upkwYkbpepwJ8nbfhVXPPg8zkHqAVzZNiDX4Vv61TCW8QvcbMGwWeotX
         b8bnrXAQGSSxo92YqVq+iAmAOv9KE7DLwjM6pmYdpwJrH5BCpRsdELfsTArL8mgpIIie
         oABDK1ijyudEbdxKgemoPdYswOHQ2IGVQpacYyGQxITpVODyOlx68IlHulTjuNvRDhun
         r58R756AhGkEjsYbmBJsB4CX/fG70PB1Bxawmb/vHhl19YB98lXIXoiJEUG8BoXpqzmu
         GoHp+Ibu9VlXEfNPycRbosTKqOuJLoQx20AGfZk0LG8YAk+bm42/PMkS/BT0pePheyCU
         rNVg==
X-Gm-Message-State: AOAM5323CxvZy8muJIP6VKOwaqC5UgW+1jwzME9lVqrjLBd/Jn8uZEB3
        OPLvg54gK8LUGfftd2wAnAQjqv9qWRMA/Q==
X-Google-Smtp-Source: ABdhPJzV8VjzS3zaLNxsexT/PCOyab0ma0E/wtGUzFbURW2/4oMO6BP9ID24TmpFcjQSfRlYTlCXWg==
X-Received: by 2002:a63:524c:: with SMTP id s12mr5126116pgl.287.1601704627233;
        Fri, 02 Oct 2020 22:57:07 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:57:06 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 09/12] xfs: Check for extent overflow when swapping extents
Date:   Sat,  3 Oct 2020 11:26:30 +0530
Message-Id: <20201003055633.9379-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index ded3c1b56c94..837c01595439 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -102,6 +102,13 @@ struct xfs_ifork {
 #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
 	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
 
+/*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0776abd0103c..b6728fdf50ae 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1407,6 +1407,22 @@ xfs_swap_extent_rmap(
 					irec.br_blockcount);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
+			if (xfs_bmap_is_real_extent(&uirec)) {
+				error = xfs_iext_count_may_overflow(ip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
+			if (xfs_bmap_is_real_extent(&irec)) {
+				error = xfs_iext_count_may_overflow(tip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
 			/* Remove the mapping from the donor file. */
 			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
-- 
2.28.0

