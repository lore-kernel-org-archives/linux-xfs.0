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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3D2C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A500122273
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbhAZRYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbhAZGf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:29 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28528C061788
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:06 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so9909171pfm.6
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v4koTZrjibUyCFFPlHy5feW/9IzzE5SGaw1vfxuC/SE=;
        b=BTH72UGdqrKN9T65xkkdtv1idub4X574iEECAYCD0mr4pMb5GBp3Og3chsv9jk0elS
         thIRKn3g0EaiVWrfqJVv+QwSx4YV6xpR/K+LHnv08bMV0FTMWsMLPzwqDjAztiQqPT6p
         F9h9rsMu827V1dfaEMGI/iNnNfbaCoD0UmxvZBliyInSjeV5NANuEjZPyUcSgBIeO/cv
         dX0NVVDSpW4cDMmfaIIcTRqTDrvs6NMbsvdm3p86D8+dNvG5mleZMZ3nI1GNv6eSUQ1t
         +dNu3SHLuCNS5FVsce3cb7+jUpjjUQiC1jldyAlvt2wp//eJdsbRcbAXBmcbllKclbgY
         BFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v4koTZrjibUyCFFPlHy5feW/9IzzE5SGaw1vfxuC/SE=;
        b=ttZsqVBFwsNls2Em/mVx2bENwCQvaKMpHik1MbTu6N7Lx/BpJOKUgBRQevBiFiQutz
         +qT10MwAtWMAuvxu5jKsIUsUUaTRJwX4xtb7T0/zVIbACphc12r0x5vanoqhwRODbKjl
         5+1GtNEdvARcLL7SoABX693ncmT6Z7UVUtAfenfZyL/ZlNf/9GNT2OAG4t1Fdk6pf+3M
         r1fNbZV7jIvsFVLduy6PRK0vFUe4Uq1mIQdm/Zkrb6EKbCSW97RRKjTegEvG1WBEV0wT
         Cqws5XkUqOMKGzmuTgISPdF9rZtQaelYL28COdg5yr8piQ4C74aGZfAGr92bd6mOvrPA
         I3Tg==
X-Gm-Message-State: AOAM532hKMnqIZt3Ky+N6qSROvxoomDtMMus/B9RjP4cTK8alAfIMng5
        4ks5QtqqRN5KdTUWqClKzDAJ5KwKNss=
X-Google-Smtp-Source: ABdhPJwFsQQMpNXaV0c8TIKDfmCGhunDtin5PwvQCK86J8qL4t9lAl/QndopIupr+gdeIRGy34hccQ==
X-Received: by 2002:a62:2946:0:b029:19e:6b80:669a with SMTP id p67-20020a6229460000b029019e6b80669amr3860306pfp.42.1611642785555;
        Mon, 25 Jan 2021 22:33:05 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:05 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 06/16] xfs: Check for extent overflow when renaming dir entries
Date:   Tue, 26 Jan 2021 12:02:22 +0530
Message-Id: <20210126063232.3648053-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
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

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

