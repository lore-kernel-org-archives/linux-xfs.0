Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371BEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbiLaBKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiLaBKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E8718B37
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA619B81DCA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64474C433EF;
        Sat, 31 Dec 2022 01:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449004;
        bh=GiSLFhkUD8jfo9UCzouRNsoX/x/YcJpoCtTOFHc5+NU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T2R+q6bBk+s+KLZXEoVOGs/bxVzAUTu7/OAthqaYnzsBaMnbwYFzAOGd6bGiKeuu1
         lFIssz8ROmohAyFCoFjNhjEADzr9q3aDcqwY4rQrC41g5t2sRT6tvog7eNpwkSilwW
         2yycW1mFo0tj1B/Hp1+CsnG59+47pCC54q6wF9x4lpzIrieH04XGJsBPbSxp5GKFgC
         vAT7uv31eTLTwBwQpXc36Tl2mY7ZFbg198hXw/XmpYNQ27/BgvENrC8g9EEKWezleV
         baKowRf29pFyqICppyijareURyi78JR5a/fsa71nNttNChVzEQkSehp/jN4sRKZOot
         F/i8d23S+/T6w==
Subject: [PATCH 19/20] xfs: create libxfs helper to rename two directory
 entries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:21 -0800
Message-ID: <167243864103.707335.9081114896106292572.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new libxfs function to rename two directory entries.  The
upcoming metadata directory feature will need this to replace a metadata
inode directory entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |  203 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    5 +
 fs/xfs/xfs_inode.c       |  177 ++--------------------------------------
 3 files changed, 218 insertions(+), 167 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 6d7851a613e7..e8f4a84a97c8 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_ag.h"
+#include "xfs_ialloc.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -1057,3 +1058,205 @@ xfs_dir_exchange(
 
 	return 0;
 }
+
+/*
+ * Given an entry (@src_name, @src_ip) in directory @src_dp, make the entry
+ * @target_name in directory @target_dp point to @src_ip and remove the
+ * original entry, cleaning up everything left behind.
+ *
+ * Cleanup involves dropping a link count on @target_ip, and either removing
+ * the (@src_name, @src_ip) entry from @src_dp or simply replacing the entry
+ * with (@src_name, @wip) if a whiteout inode @wip is supplied.
+ *
+ * All inodes must have the ILOCK held.  We assume that if @src_ip is a
+ * directory then its '..' doesn't already point to @target_dp, and that @wip
+ * is a freshly allocated whiteout.
+ */
+int
+xfs_dir_rename(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*src_dp,
+	struct xfs_name		*src_name,
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_dp,
+	struct xfs_name		*target_name,
+	struct xfs_inode	*target_ip,
+	unsigned int		spaceres,
+	struct xfs_inode	*wip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	bool			new_parent = (src_dp != target_dp);
+	bool			src_is_directory;
+	int			error;
+
+	src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
+
+	/*
+	 * Check for expected errors before we dirty the transaction
+	 * so we can return an error without a transaction abort.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If there's no space reservation, check the entry will
+		 * fit before actually inserting it.
+		 */
+		if (!spaceres) {
+			error = xfs_dir_canenter(tp, target_dp, target_name);
+			if (error)
+				return error;
+		}
+	} else {
+		/*
+		 * If target exists and it's a directory, check that whether
+		 * it can be destroyed.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
+		    (!xfs_dir_isempty(target_ip) ||
+		     (VFS_I(target_ip)->i_nlink > 2)))
+			return -EEXIST;
+	}
+
+	/*
+	 * Directory entry creation below may acquire the AGF. Remove
+	 * the whiteout from the unlinked list first to preserve correct
+	 * AGI/AGF locking order. This dirties the transaction so failures
+	 * after this point will abort and log recovery will clean up the
+	 * mess.
+	 *
+	 * For whiteouts, we need to bump the link count on the whiteout
+	 * inode. After this point, we have a real link, clear the tmpfile
+	 * state flag from the inode so it doesn't accidentally get misused
+	 * in future.
+	 */
+	if (wip) {
+		struct xfs_perag	*pag;
+
+		ASSERT(VFS_I(wip)->i_nlink == 0);
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, wip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, wip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+
+		xfs_bumplink(tp, wip);
+	}
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
+		/*
+		 * If target does not exist and the rename crosses
+		 * directories, adjust the target directory link count
+		 * to account for the ".." reference from the new entry.
+		 */
+		error = xfs_dir_createname(tp, target_dp, target_name,
+					   src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		if (new_parent && src_is_directory) {
+			xfs_bumplink(tp, target_dp);
+		}
+	} else { /* target_ip != NULL */
+		/*
+		 * Link the source inode under the target name.
+		 * If the source inode is a directory and we are moving
+		 * it across directories, its ".." entry will be
+		 * inconsistent until we replace that down below.
+		 *
+		 * In case there is already an entry with the same
+		 * name at the destination directory, remove it first.
+		 */
+		error = xfs_dir_replace(tp, target_dp, target_name,
+					src_ip->i_ino, spaceres);
+		if (error)
+			return error;
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		/*
+		 * Decrement the link count on the target since the target
+		 * dir no longer points to it.
+		 */
+		error = xfs_droplink(tp, target_ip);
+		if (error)
+			return error;
+
+		if (src_is_directory) {
+			/*
+			 * Drop the link from the old "." entry.
+			 */
+			error = xfs_droplink(tp, target_ip);
+			if (error)
+				return error;
+		}
+	} /* target_ip != NULL */
+
+	/*
+	 * Remove the source.
+	 */
+	if (new_parent && src_is_directory) {
+		/*
+		 * Rewrite the ".." entry to point to the new
+		 * directory.
+		 */
+		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
+					target_dp->i_ino, spaceres);
+		ASSERT(error != -EEXIST);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * We always want to hit the ctime on the source inode.
+	 *
+	 * This isn't strictly required by the standards since the source
+	 * inode isn't really being changed, but old unix file systems did
+	 * it and some incremental backup programs won't work without it.
+	 */
+	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
+
+	/*
+	 * Adjust the link count on src_dp.  This is necessary when
+	 * renaming a directory, either within one parent when
+	 * the target existed, or across two parent directories.
+	 */
+	if (src_is_directory && (new_parent || target_ip != NULL)) {
+
+		/*
+		 * Decrement link count on src_directory since the
+		 * entry that's moved no longer points to it.
+		 */
+		error = xfs_droplink(tp, src_dp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * For whiteouts, we only need to update the source dirent with the
+	 * inode number of the whiteout inode rather than removing it
+	 * altogether.
+	 */
+	if (wip)
+		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
+					spaceres);
+	else
+		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+					   spaceres);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
+	if (new_parent)
+		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f63390236f09..00b4642bc8a8 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -266,5 +266,10 @@ int xfs_dir_exchange(struct xfs_trans *tp, struct xfs_inode *dp1,
 		struct xfs_name *name1, struct xfs_inode *ip1,
 		struct xfs_inode *dp2, struct xfs_name *name2,
 		struct xfs_inode *ip2, unsigned int spaceres);
+int xfs_dir_rename(struct xfs_trans *tp, struct xfs_inode *src_dp,
+		struct xfs_name *src_name, struct xfs_inode *src_ip,
+		struct xfs_inode *target_dp, struct xfs_name *target_name,
+		struct xfs_inode *target_ip, unsigned int spaceres,
+		struct xfs_inode *wip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 591721755b78..4b9d680c5268 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2408,33 +2408,6 @@ xfs_rename(
 			goto out_trans_cancel;
 	}
 
-	/*
-	 * Check for expected errors before we dirty the transaction
-	 * so we can return an error without a transaction abort.
-	 */
-	if (target_ip == NULL) {
-		/*
-		 * If there's no space reservation, check the entry will
-		 * fit before actually inserting it.
-		 */
-		if (!spaceres) {
-			error = xfs_dir_canenter(tp, target_dp, target_name);
-			if (error)
-				goto out_trans_cancel;
-		}
-	} else {
-		/*
-		 * If target exists and it's a directory, check that whether
-		 * it can be destroyed.
-		 */
-		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
-		    (!xfs_dir_isempty(target_ip) ||
-		     (VFS_I(target_ip)->i_nlink > 2))) {
-			error = -EEXIST;
-			goto out_trans_cancel;
-		}
-	}
-
 	/*
 	 * Lock the AGI buffers we need to handle bumping the nlink of the
 	 * whiteout inode off the unlinked list and to handle dropping the
@@ -2461,150 +2434,20 @@ xfs_rename(
 		}
 	}
 
-	/*
-	 * Directory entry creation below may acquire the AGF. Remove
-	 * the whiteout from the unlinked list first to preserve correct
-	 * AGI/AGF locking order. This dirties the transaction so failures
-	 * after this point will abort and log recovery will clean up the
-	 * mess.
-	 *
-	 * For whiteouts, we need to bump the link count on the whiteout
-	 * inode. After this point, we have a real link, clear the tmpfile
-	 * state flag from the inode so it doesn't accidentally get misused
-	 * in future.
-	 */
+	error = xfs_dir_rename(tp, src_dp, src_name, src_ip, target_dp,
+			target_name, target_ip, spaceres, wip);
+	if (error)
+		goto out_trans_cancel;
+
 	if (wip) {
-		struct xfs_perag	*pag;
-
-		ASSERT(VFS_I(wip)->i_nlink == 0);
-
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, wip->i_ino));
-		error = xfs_iunlink_remove(tp, pag, wip);
-		xfs_perag_put(pag);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_bumplink(tp, wip);
+		/*
+		 * Now we have a real link, clear the "I'm a tmpfile" state
+		 * flag from the inode so it doesn't accidentally get misused in
+		 * future.
+		 */
 		VFS_I(wip)->i_state &= ~I_LINKABLE;
 	}
 
-	/*
-	 * Set up the target.
-	 */
-	if (target_ip == NULL) {
-		/*
-		 * If target does not exist and the rename crosses
-		 * directories, adjust the target directory link count
-		 * to account for the ".." reference from the new entry.
-		 */
-		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-		if (new_parent && src_is_directory) {
-			xfs_bumplink(tp, target_dp);
-		}
-	} else { /* target_ip != NULL */
-		/*
-		 * Link the source inode under the target name.
-		 * If the source inode is a directory and we are moving
-		 * it across directories, its ".." entry will be
-		 * inconsistent until we replace that down below.
-		 *
-		 * In case there is already an entry with the same
-		 * name at the destination directory, remove it first.
-		 */
-		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
-		if (error)
-			goto out_trans_cancel;
-
-		xfs_trans_ichgtime(tp, target_dp,
-					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-		/*
-		 * Decrement the link count on the target since the target
-		 * dir no longer points to it.
-		 */
-		error = xfs_droplink(tp, target_ip);
-		if (error)
-			goto out_trans_cancel;
-
-		if (src_is_directory) {
-			/*
-			 * Drop the link from the old "." entry.
-			 */
-			error = xfs_droplink(tp, target_ip);
-			if (error)
-				goto out_trans_cancel;
-		}
-	} /* target_ip != NULL */
-
-	/*
-	 * Remove the source.
-	 */
-	if (new_parent && src_is_directory) {
-		/*
-		 * Rewrite the ".." entry to point to the new
-		 * directory.
-		 */
-		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
-		ASSERT(error != -EEXIST);
-		if (error)
-			goto out_trans_cancel;
-	}
-
-	/*
-	 * We always want to hit the ctime on the source inode.
-	 *
-	 * This isn't strictly required by the standards since the source
-	 * inode isn't really being changed, but old unix file systems did
-	 * it and some incremental backup programs won't work without it.
-	 */
-	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
-
-	/*
-	 * Adjust the link count on src_dp.  This is necessary when
-	 * renaming a directory, either within one parent when
-	 * the target existed, or across two parent directories.
-	 */
-	if (src_is_directory && (new_parent || target_ip != NULL)) {
-
-		/*
-		 * Decrement link count on src_directory since the
-		 * entry that's moved no longer points to it.
-		 */
-		error = xfs_droplink(tp, src_dp);
-		if (error)
-			goto out_trans_cancel;
-	}
-
-	/*
-	 * For whiteouts, we only need to update the source dirent with the
-	 * inode number of the whiteout inode rather than removing it
-	 * altogether.
-	 */
-	if (wip)
-		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
-	else
-		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
-
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
-	if (new_parent)
-		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
-
 	if (xfs_hooks_switched_on(&xfs_nlinks_hooks_switch))
 		xfs_rename_call_nlink_hooks(src_dp, src_name, src_ip,
 				target_dp, target_name, target_ip, wip, flags);

