Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4429C48BDF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7EA61284
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhFMRW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhFMRW0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A770C61078;
        Sun, 13 Jun 2021 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604824;
        bh=eGqhITI7uxnulhLZj+DBJdw+G5jKdmTUT/agH5YTFu0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vD6iCBUjB6h4tvUrEHmusFL+UZKT10WwrizRffE8KK1LSplTJYMhTaxhoifeI5Ci6
         DY0pDg+nEeK8RjE1wESYiYnRqJ89b6YNh+weoxh6wxYfAY7njVjbxB7I/9HtL0K9uV
         F7LdmrAHlIRVB+txAFQWcpH3fZdGxdYohukLRDoQH/n96usmvRW0btSNwbhbujdQ+F
         88pFU38gUwl//dx+MSDmjwyc7QxMP+1o0BEtS8YXtJrFgIQwmbFl6w9z2i+RTvJCol
         mL9mVId+tK1Hq6dvzNz4XNV7T7T77JOLfgdH4uxI0zVig6OCVI5hBr48pm2orRm1Hk
         IYddPgoWRCnuw==
Subject: [PATCH 05/16] xfs: separate primary inode selection criteria in
 xfs_iget_cache_hit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:24 -0700
Message-ID: <162360482438.1530792.18197198406001465325.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During review of the v6 deferred inode inactivation patchset[1], Dave
commented that _cache_hit should have a clear separation between inode
selection criteria and actions performed on a selected inode.  Move a
hunk to make this true, and compact the shrink cases in the function.

[1] https://lore.kernel.org/linux-xfs/162310469340.3465262.504398465311182657.stgit@locust/T/#mca6d958521cb88bbc1bfe1a30767203328d410b5
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7939eced3a47..4002f0b84401 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -562,13 +562,8 @@ xfs_iget_cache_hit(
 	 * will not match, so check for that, too.
 	 */
 	spin_lock(&ip->i_flags_lock);
-	if (ip->i_ino != ino) {
-		trace_xfs_iget_skip(ip);
-		XFS_STATS_INC(mp, xs_ig_frecycle);
-		error = -EAGAIN;
-		goto out_error;
-	}
-
+	if (ip->i_ino != ino)
+		goto out_skip;
 
 	/*
 	 * If we are racing with another cache hit that is currently
@@ -580,12 +575,8 @@ xfs_iget_cache_hit(
 	 *	     wait_on_inode to wait for these flags to be cleared
 	 *	     instead of polling for it.
 	 */
-	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
-		trace_xfs_iget_skip(ip);
-		XFS_STATS_INC(mp, xs_ig_frecycle);
-		error = -EAGAIN;
-		goto out_error;
-	}
+	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM))
+		goto out_skip;
 
 	/*
 	 * Check the inode free state is valid. This also detects lookup
@@ -595,23 +586,21 @@ xfs_iget_cache_hit(
 	if (error)
 		goto out_error;
 
+	/* Skip inodes that have no vfs state. */
+	if ((flags & XFS_IGET_INCORE) &&
+	    (ip->i_flags & XFS_IRECLAIMABLE))
+		goto out_skip;
+
+	/* The inode fits the selection criteria; process it. */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
-		if (flags & XFS_IGET_INCORE) {
-			error = -EAGAIN;
-			goto out_error;
-		}
-
 		/* Drops i_flags_lock and RCU read lock. */
 		error = xfs_iget_recycle(pag, ip);
 		if (error)
 			return error;
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
-		if (!igrab(inode)) {
-			trace_xfs_iget_skip(ip);
-			error = -EAGAIN;
-			goto out_error;
-		}
+		if (!igrab(inode))
+			goto out_skip;
 
 		/* We've got a live one. */
 		spin_unlock(&ip->i_flags_lock);
@@ -628,6 +617,10 @@ xfs_iget_cache_hit(
 
 	return 0;
 
+out_skip:
+	trace_xfs_iget_skip(ip);
+	XFS_STATS_INC(mp, xs_ig_frecycle);
+	error = -EAGAIN;
 out_error:
 	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();

