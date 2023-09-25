Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BCCCE7A95
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 15:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjIYPiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjIYPiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 11:38:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3461D10E
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 08:38:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C725CC433C8;
        Mon, 25 Sep 2023 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695656290;
        bh=GHbcWyVTqDRLWAHEwSmo3U6c2MgZL44gzWHP79P+5CY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=anMkUHykJOBkKFZueoIZSidHbSHSygs+aR3yXvNPBxlPi1Y1QZguRQG9ZXRmR6BTp
         2UZlwHJdVPauJdfyN6McF4KX2nzZMa/3ydADREp1cL/d1NWehbbRqk6eRyl1vZQVKB
         FLMSqMa5lmFWd51kxlS85gQwRG0YS9ocLVH/2mOXk3MnR04jUmzOwPNTFgCMIp/gyQ
         qPOMsVsO7KxvZH/PlmRGyK7YMZVkZ6vBAg2FU1k/vRnF5qmprMVJFd6Sn30dup/O28
         KtgwsEP+5DKzb6MVq1Is1h13OeYOEIp2qhtiSGQLaFBDBb/f2CQ/WN6+rbtKbqOi2r
         Q+LzlCxMRRIiA==
Subject: [PATCH 1/1] xfs: fix reloading entire unlinked bucket lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandanbabu@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Date:   Mon, 25 Sep 2023 08:38:10 -0700
Message-ID: <169565629026.1982077.12646061547002741492.stgit@frogsfrogsfrogs>
In-Reply-To: <169565628450.1982077.8839912830345775826.stgit@frogsfrogsfrogs>
References: <169565628450.1982077.8839912830345775826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During review of the patcheset that provided reloading of the incore
iunlink list, Dave made a few suggestions, and I updated the copy in my
dev tree.  Unfortunately, I then got distracted by ... who even knows
what ... and forgot to backport those changes from my dev tree to my
release candidate branch.  I then sent multiple pull requests with stale
patches, and that's what was merged into -rc3.

So.

This patch re-adds the use of an unlocked iunlink list check to
determine if we want to allocate the resources to recreate the incore
list.  Since lost iunlinked inodes are supposed to be rare, this change
helps us avoid paying the transaction and AGF locking costs every time
we open any inode.

This also re-adds the shutdowns on failure, and re-applies the
restructuring of the inner loop in xfs_inode_reload_unlinked_bucket, and
re-adds a requested comment about the quotachecking code.

Retain the original RVB tag from Dave since there's no code change from
the last submission.

Fixes: 68b957f64fca1 ("xfs: load uncached unlinked inodes into memory on demand")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_export.c |   16 ++++++++++++----
 fs/xfs/xfs_inode.c  |   48 +++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_itable.c |    2 ++
 fs/xfs/xfs_qm.c     |   15 ++++++++++++---
 4 files changed, 61 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f71ea786a6d2..7cd09c3a82cb 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -146,10 +146,18 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
-	error = xfs_inode_reload_unlinked(ip);
-	if (error) {
-		xfs_irele(ip);
-		return ERR_PTR(error);
+	/*
+	 * Reload the incore unlinked list to avoid failure in inodegc.
+	 * Use an unlocked check here because unrecovered unlinked inodes
+	 * should be somewhat rare.
+	 */
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked(ip);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			xfs_irele(ip);
+			return ERR_PTR(error);
+		}
 	}
 
 	if (VFS_I(ip)->i_generation != generation) {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f94f7b374041..4d55f58d99b7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1743,6 +1743,14 @@ xfs_inactive(
 		truncate = 1;
 
 	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
+		/*
+		 * If this inode is being inactivated during a quotacheck and
+		 * has not yet been scanned by quotacheck, we /must/ remove
+		 * the dquots from the inode before inactivation changes the
+		 * block and inode counts.  Most probably this is a result of
+		 * reloading the incore iunlinked list to purge unrecovered
+		 * unlinked inodes.
+		 */
 		xfs_qm_dqdetach(ip);
 	} else {
 		error = xfs_qm_dqattach(ip);
@@ -3641,6 +3649,16 @@ xfs_inode_reload_unlinked_bucket(
 	if (error)
 		return error;
 
+	/*
+	 * We've taken ILOCK_SHARED and the AGI buffer lock to stabilize the
+	 * incore unlinked list pointers for this inode.  Check once more to
+	 * see if we raced with anyone else to reload the unlinked list.
+	 */
+	if (!xfs_inode_unlinked_incomplete(ip)) {
+		foundit = true;
+		goto out_agibp;
+	}
+
 	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
 	agi = agibp->b_addr;
 
@@ -3655,25 +3673,27 @@ xfs_inode_reload_unlinked_bucket(
 	while (next_agino != NULLAGINO) {
 		struct xfs_inode	*next_ip = NULL;
 
+		/* Found this caller's inode, set its backlink. */
 		if (next_agino == agino) {
-			/* Found this inode, set its backlink. */
 			next_ip = ip;
 			next_ip->i_prev_unlinked = prev_agino;
 			foundit = true;
+			goto next_inode;
 		}
-		if (!next_ip) {
-			/* Inode already in memory. */
-			next_ip = xfs_iunlink_lookup(pag, next_agino);
-		}
-		if (!next_ip) {
-			/* Inode not in memory, reload. */
-			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
-					next_agino);
-			if (error)
-				break;
 
-			next_ip = xfs_iunlink_lookup(pag, next_agino);
-		}
+		/* Try in-memory lookup first. */
+		next_ip = xfs_iunlink_lookup(pag, next_agino);
+		if (next_ip)
+			goto next_inode;
+
+		/* Inode not in memory, try reloading it. */
+		error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
+				next_agino);
+		if (error)
+			break;
+
+		/* Grab the reloaded inode. */
+		next_ip = xfs_iunlink_lookup(pag, next_agino);
 		if (!next_ip) {
 			/* No incore inode at all?  We reloaded it... */
 			ASSERT(next_ip != NULL);
@@ -3681,10 +3701,12 @@ xfs_inode_reload_unlinked_bucket(
 			break;
 		}
 
+next_inode:
 		prev_agino = next_agino;
 		next_agino = next_ip->i_next_unlinked;
 	}
 
+out_agibp:
 	xfs_trans_brelse(tp, agibp);
 	/* Should have found this inode somewhere in the iunlinked bucket. */
 	if (!error && !foundit)
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ccf0c4ff4490..f5377ba5967a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -80,10 +80,12 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out;
 
+	/* Reload the incore unlinked list to avoid failure in inodegc. */
 	if (xfs_inode_unlinked_incomplete(ip)) {
 		error = xfs_inode_reload_unlinked_bucket(tp, ip);
 		if (error) {
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			xfs_irele(ip);
 			return error;
 		}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7256090c3895..086e78a6143a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1160,9 +1160,18 @@ xfs_qm_dqusage_adjust(
 	if (error)
 		return error;
 
-	error = xfs_inode_reload_unlinked(ip);
-	if (error)
-		goto error0;
+	/*
+	 * Reload the incore unlinked list to avoid failure in inodegc.
+	 * Use an unlocked check here because unrecovered unlinked inodes
+	 * should be somewhat rare.
+	 */
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked(ip);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			goto error0;
+		}
+	}
 
 	ASSERT(ip->i_delayed_blks == 0);
 

