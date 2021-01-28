Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EA3C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A5261492
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhA1GGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:06:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhA1GF0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:05:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FEBD64DDE;
        Thu, 28 Jan 2021 06:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813885;
        bh=84rnBhgATqijiEn2kkw8dvKG0xOKjxnkI2DaV1XGt5U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kYzzodlFcYc73xud2w4FK0J96CW/17frkFJcDqYN7jv6XXP59YXaQa52tPd6d5SJd
         rHW5M87zrPkCzygJ5pnrLs2oPh6aU0hyqf+1H2PXyDNbf+06j86h8LThTFQYmUBzPS
         /11E/LabluWsSE6LbwPAD7Q9xMvpIDJmSyQD9udpiNtDo0/W6c1+fZPbygylxkYkEb
         IgO/pGbvkk/ZLZk3BHRN7P23B52hafi9xIKk36R8c+s0xjUm3T6C5LxwAa710sbN2z
         eVeAMoVfDDv/mg50ZP9h+Depd/WRKHHgl7mbu/+JUeaYkUvZYzFKQrGuiQfnSU5zYj
         nwOEh/YPaAV4w==
Subject: [PATCH 11/11] xfs: don't bounce the iolock between
 free_{eof,cow}blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:04:41 -0800
Message-ID: <161181388185.1525433.9983196119474305213.stgit@magnolia>
In-Reply-To: <161181381898.1525433.10723801103841220046.stgit@magnolia>
References: <161181381898.1525433.10723801103841220046.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since xfs_inode_free_eofblocks and xfs_inode_free_cowblocks are now
internal static functions, we can save ourselves a cycling of the iolock
by passing the lock state out to xfs_blockgc_scan_inode and letting it
do all the unlocking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ad881e92d6cd..2e14ee4bddae 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1283,11 +1283,11 @@ xfs_reclaim_worker(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
-	void			*args)
+	void			*args,
+	unsigned int		*unlockflags)
 {
 	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
-	int			ret;
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
 
@@ -1320,11 +1320,9 @@ xfs_inode_free_eofblocks(
 			return -EAGAIN;
 		return 0;
 	}
+	*unlockflags |= XFS_IOLOCK_EXCL;
 
-	ret = xfs_free_eofblocks(ip);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-
-	return ret;
+	return xfs_free_eofblocks(ip);
 }
 
 /*
@@ -1493,7 +1491,8 @@ xfs_prep_free_cowblocks(
 STATIC int
 xfs_inode_free_cowblocks(
 	struct xfs_inode	*ip,
-	void			*args)
+	void			*args,
+	unsigned int		*unlockflags)
 {
 	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
@@ -1514,16 +1513,20 @@ xfs_inode_free_cowblocks(
 	 * If the caller is waiting, return -EAGAIN to keep the background
 	 * scanner moving and revisit the inode in a subsequent pass.
 	 */
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+	if (!(*unlockflags & XFS_IOLOCK_EXCL) &&
+	    !xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (wait)
 			return -EAGAIN;
 		return 0;
 	}
+	*unlockflags |= XFS_IOLOCK_EXCL;
+
 	if (!xfs_ilock_nowait(ip, XFS_MMAPLOCK_EXCL)) {
 		if (wait)
-			ret = -EAGAIN;
-		goto out_iolock;
+			return -EAGAIN;
+		return 0;
 	}
+	*unlockflags |= XFS_MMAPLOCK_EXCL;
 
 	/*
 	 * Check again, nobody else should be able to dirty blocks or change
@@ -1531,11 +1534,6 @@ xfs_inode_free_cowblocks(
 	 */
 	if (xfs_prep_free_cowblocks(ip))
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
-
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
-out_iolock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-
 	return ret;
 }
 
@@ -1593,17 +1591,18 @@ xfs_blockgc_scan_inode(
 	struct xfs_inode	*ip,
 	void			*args)
 {
+	unsigned int		unlockflags = 0;
 	int			error;
 
-	error = xfs_inode_free_eofblocks(ip, args);
+	error = xfs_inode_free_eofblocks(ip, args, &unlockflags);
 	if (error)
-		return error;
+		goto unlock;
 
-	error = xfs_inode_free_cowblocks(ip, args);
-	if (error)
-		return error;
-
-	return 0;
+	error = xfs_inode_free_cowblocks(ip, args, &unlockflags);
+unlock:
+	if (unlockflags)
+		xfs_iunlock(ip, unlockflags);
+	return error;
 }
 
 /* Background worker that trims preallocated space. */

