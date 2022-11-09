Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143ABC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKICFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKICFu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77C154B21
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41715617E1
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32F6C433C1;
        Wed,  9 Nov 2022 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959548;
        bh=GRXFldNWnhEE8HHb7Flp4X6cHg63k82xl0dYoBjuFZc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MffFeACVlc48SOy7J0t6W245BZa9VM2sDWljA0ytCHwHEqvnpGDlkjOgHHGrtfhyy
         s0oJqlsoMqaq9Rk7Wb5WbkQ5I57MugCGx27A/ERH44/7XFTyEgS5xgPRCRNmhVudB6
         QDUEpyqRU5WRM7sTa/mzAd4idu9Qyg1yTG+bBN/VYSentHbtnbzK0C4teUl73JOgLm
         fmLw0uhAnKJbvPmI5fW4C5KGG7jN6vAdzANrun9HEdv4qGaQlfiAuQnjHoZS3psnUl
         mbR0ahy4xOnW2G23T96nBpOr+rNhpKH3Oi62jxhzKP6AGnXjoeJpoRNL6eYN5hkziG
         VYgVJQmmy79lA==
Subject: [PATCH 01/24] xfs: clean up "%Ld/%Lu" which doesn't meet C standard
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Zeng Heng <zengheng4@huawei.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:48 -0800
Message-ID: <166795954825.3761583.9121404007612201905.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zeng Heng <zengheng4@huawei.com>

Source kernel commit: 78b0f58bdfef45aa9f3c7fbbd9b4d41abad6d85f

The "%Ld" specifier, which represents long long unsigned,
doesn't meet C language standard, and even more,
it makes people easily mistake with "%ld", which represent
long unsigned. So replace "%Ld" with "lld".

Do the same with "%Lu".

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_bmap.c       |    2 +-
 libxfs/xfs_inode_fork.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 123255b646..6d6f9e7dd6 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -287,7 +287,7 @@ xfs_check_block(
 			else
 				thispa = XFS_BMBT_PTR_ADDR(mp, block, j, dmxr);
 			if (*thispa == *pp) {
-				xfs_warn(mp, "%s: thispa(%d) == pp(%d) %Ld",
+				xfs_warn(mp, "%s: thispa(%d) == pp(%d) %lld",
 					__func__, j, i,
 					(unsigned long long)be64_to_cpu(*thispa));
 				xfs_err(mp, "%s: ptrs are equal in node\n",
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index bed0c1b08a..f16b8ccc05 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -76,7 +76,7 @@ xfs_iformat_local(
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
-	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
+	"corrupt inode %llu (bad size %d for local fork, size = %zd).",
 			(unsigned long long) ip->i_ino, size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
@@ -190,7 +190,7 @@ xfs_iformat_btree(
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
 		     ifp->if_nextents > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
-		xfs_warn(mp, "corrupt inode %Lu (btree).",
+		xfs_warn(mp, "corrupt inode %llu (btree).",
 					(unsigned long long) ip->i_ino);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_btree", dfp, size,

