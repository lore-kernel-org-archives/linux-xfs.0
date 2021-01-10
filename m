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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233F0C433E6
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAFC7229EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAJDbD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbhAJDbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:03 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA85C0617A6
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:29:56 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s15so7714790plr.9
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tPqQFUkTyQMKAVlwHoryKUGzUBtBK79OUw3IcgmGk9A=;
        b=cVZpZZfZpswcSnjjeChlRTgJcEvrf2YczpaH/V0u/nP5RgYwR+6FTLvNcNh/96cfkT
         WjsTPVNZVxkSPT2/WswOgQ6Qg2e1raZcZrevGB16VHcKirbrL6yeXy1m5JYsQVWxyfuO
         2nzolLKLDOR8+rMlgHdMhvzJjH8H8on7M/uKIpyfAl4e83yNTmT5zNCMO76X4sBg4RV+
         Z3IjnnRN3yGX5Wt8V13TkOj4Z/ylK//vIOZ9ltU9ZU3oIGTK2+ao0fRHCZ1YrXIWEQPD
         7E52ehTuE5t0kJjARuJg2W8Ikx7sG910p+xSQgzxli2zj8RSX/B9oxPW+bmxFkaIYs/P
         UOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPqQFUkTyQMKAVlwHoryKUGzUBtBK79OUw3IcgmGk9A=;
        b=J1uzCTGJ/xeEvfzlf4E+TB/AHgREcfwAQpiJ0wnIev+gRmFJY27GqIo5cmgxzJDDU2
         fZUQ6/ZuEKkwjtiZiFjgyJ1R7uSs0nx+LC1U1vy1gcnaALkMmFLYmdRtxYmfcTV6Db1R
         LbfBodpKJh/lHt/Axb935uCuzRkj6OKYwnsTsWfjoayqwCC1izgaI5/7oWZLtNlojOtr
         mhUESUPiukMGpq9NIdaonjf1HBrKAxaz9MVzEdo20NmLzvo7u1pZmdDHQb24mEmM5JkB
         XW/0CCFjlSbU2co9LIa2VoZK4QzD6IdcVlz55KNQbsPT3lIO5kELcNaGUQgwSvc45BJT
         gkjg==
X-Gm-Message-State: AOAM532ew8IdA8gDmmCrL2LsSXHBzthsgXSVOxecD5UR/z6zTkNW0pdW
        548eUop0zI9kdvp9z9RhzDlTAkL+nJi8AA==
X-Google-Smtp-Source: ABdhPJzP+kBhJYBan2bYg6amfp1ArhdOC9nbTYqklnEHhAQ8ieU/pVbhjabMV/KDvaQeUnOnYBwviw==
X-Received: by 2002:a17:90b:1187:: with SMTP id gk7mr11305241pjb.162.1610249395731;
        Sat, 09 Jan 2021 19:29:55 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:29:55 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 06/16] xfs: Check for extent overflow when renaming dir entries
Date:   Sun, 10 Jan 2021 08:59:18 +0530
Message-Id: <20210110032928.3120861-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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
index 94063ac1d085..44ed30d0f662 100644
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
 		if (error == -ENOSPC) {
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

