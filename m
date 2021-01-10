Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48103C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F7B225AB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbhAJQK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbhAJQK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:10:58 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E942C0617A5
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:50 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id r4so8193088pls.11
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xvnqdIuJK3MkYLREbdoyXP3SJEd8e9hwamnZTRygguw=;
        b=Zw+N4XOfN0PNbcYyAB5m22Kl3K7j4Q0jB8BS57ZNqtD/gcYMpapWG4dkqCeP+XMq7z
         s7TnjQYSrUKzEwZedlxbpeGy3ttq5BP5L//qD4mvwgynTSZbrBY8hVSp2lAbV3yTYVhC
         3pb0HK59IwQyGvO9MtCf6tGmy01BkbTBrVQsX0NCWuArgkqsHikjUUROuhbG2hI4lvsm
         ah1sV4vkvVismy/yqSqjhCUpGZSjrezbX6QLxfbja/cgJSGoBXHED4sJF+wgY9gS8DHk
         DdAd/nx+3k4/L5a6Yh07OYPUt3nN5GWvz33fKi60Pp4J0ZIMIl/SptfuNjzbhGXhI0Fs
         cMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xvnqdIuJK3MkYLREbdoyXP3SJEd8e9hwamnZTRygguw=;
        b=J7CmtlPpeRbfIa84nGzYygCTqGYXHXpEOhbXZG8RpGUjLwJhIQovw8P5ka4mpnXWLv
         2j9LXyRPw3+ZKKJhzsx4QSiX/gG3+A9Ng2dBZ/geZeDF7/LAyreS+JYQlJFPzp8CGmxB
         zuBvc0Pn/q3bSgn1ya9FhZuTws8djnx7m2WaaUxU/igSuRu3uOipd+5pQbbM+ZiGMC15
         MEsG5rlQXnCrch+CnlXxL12CeIY4LTQsdSvODz22+h9lbHLzTB9gZV/YIkVr551EqJ37
         OCo7c3Vpem5rkiyCjNRCjt+/JTL4JiSxhqz/FhzEFiy3U+BzEGJQJOlLtN5qgUvBiMIu
         cUhA==
X-Gm-Message-State: AOAM533aE4zolLe0MCPdsBYHqh7Tq/M3u42c4jfyJj1+8K/rm2kwjhQx
        GHRilB3Bi2IG7WBAvVBT3cXMuIOkaQM=
X-Google-Smtp-Source: ABdhPJzW52I97SA0bxpTP395M+Dav/AS5ll+QlPlbe2i2GAqomjhMZPB62vuJ1gE2SAMZ0lYchcBuA==
X-Received: by 2002:a17:90a:4a18:: with SMTP id e24mr13919847pjh.140.1610294989980;
        Sun, 10 Jan 2021 08:09:49 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:09:49 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 06/16] xfs: Check for extent overflow when renaming dir entries
Date:   Sun, 10 Jan 2021 21:37:10 +0530
Message-Id: <20210110160720.3922965-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A rename operation is essentially a directory entry remove operation
from the perspective of parent directory (i.e. src_dp) of rename's
source. Hence the only place where we check for extent count overflow
for src_dp is in xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real()
returns -ENOSPC when it detects a possible extent count overflow and in
response, the higher layers of directory handling code do the following:
1. Data/Free blocks: XFS lets these blocks linger until a future remove
   operation removes them.
2. Dabtree blocks: XFS swaps the blocks with the last block in the Leaf
   space and unmaps the last block.

For target_dp, there are two cases depending on whether the destination
directory entry exists or not.

When destination directory entry does not exist (i.e. target_ip ==
NULL), extent count overflow check is performed only when transaction
has a non-zero sized space reservation associated with it.  With a
zero-sized space reservation, XFS allows a rename operation to continue
only when the directory has sufficient free space in its data/leaf/free
space blocks to hold the new entry.

When destination directory entry exists (i.e. target_ip != NULL), all
we need to do is change the inode number associated with the already
existing entry. Hence there is no need to perform an extent count
overflow check.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  3 +++
 fs/xfs/xfs_inode.c       | 44 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6c8f17a0e247..8ebe5f13279c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5160,6 +5160,9 @@ xfs_bmap_del_extent_real(
 		 * until a future remove operation. Dabtree blocks would be
 		 * swapped with the last block in the leaf space and then the
 		 * new last block will be unmapped.
+		 *
+		 * The above logic also applies to the source directory entry of
+		 * a rename operation.
 		 */
 		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
 		if (error) {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4cc787cc4eee..f0a6d528cbc4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3116,6 +3116,35 @@ xfs_rename(
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
+	 *
+	 * Extent count overflow check:
+	 *
+	 * From the perspective of src_dp, a rename operation is essentially a
+	 * directory entry remove operation. Hence the only place where we check
+	 * for extent count overflow for src_dp is in
+	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
+	 * -ENOSPC when it detects a possible extent count overflow and in
+	 * response, the higher layers of directory handling code do the
+	 * following:
+	 * 1. Data/Free blocks: XFS lets these blocks linger until a
+	 *    future remove operation removes them.
+	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
+	 *    Leaf space and unmaps the last block.
+	 *
+	 * For target_dp, there are two cases depending on whether the
+	 * destination directory entry exists or not.
+	 *
+	 * When destination directory entry does not exist (i.e. target_ip ==
+	 * NULL), extent count overflow check is performed only when transaction
+	 * has a non-zero sized space reservation associated with it.  With a
+	 * zero-sized space reservation, XFS allows a rename operation to
+	 * continue only when the directory has sufficient free space in its
+	 * data/leaf/free space blocks to hold the new entry.
+	 *
+	 * When destination directory entry exists (i.e. target_ip != NULL), all
+	 * we need to do is change the inode number associated with the already
+	 * existing entry. Hence there is no need to perform an extent count
+	 * overflow check.
 	 */
 	if (target_ip == NULL) {
 		/*
@@ -3126,6 +3155,12 @@ xfs_rename(
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
 				goto out_trans_cancel;
+		} else {
+			error = xfs_iext_count_may_overflow(target_dp,
+					XFS_DATA_FORK,
+					XFS_IEXT_DIR_MANIP_CNT(mp));
+			if (error)
+				goto out_trans_cancel;
 		}
 	} else {
 		/*
@@ -3283,9 +3318,16 @@ xfs_rename(
 	if (wip) {
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
 					spaceres);
-	} else
+	} else {
+		/*
+		 * NOTE: We don't need to check for extent count overflow here
+		 * because the dir remove name code will leave the dir block in
+		 * place if the extent count would overflow.
+		 */
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres);
+	}
+
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.29.2

