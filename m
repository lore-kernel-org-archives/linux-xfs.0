Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49838C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBPUsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBPUsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:48:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2ABEC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:48:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2966660C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B38C433D2;
        Thu, 16 Feb 2023 20:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580483;
        bh=16ARWnkDXfjc7l6xgvmPkKzT+e7sXnVKcxOQM8flfQo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GiMIAiIHM94HcgXhb9WituaMcpIzyMRR0KD9/G0wKCtrhS9LHZpRgJW6nhn5OcfXD
         d2njgHykaqqqedO/Wx8oCfk6Nj741xjEL1SCcYXvZ3CDc8IrqMz7FI2amnrrDGItyi
         o1UV9Rntzfu9EOdQYil5aYuE4oYD3wJXalzj1vRCXCvFRGSSk7dEA0G+jklE0UuiD8
         0JYbiIkVsDPzRnp8r1eNhIMftLQzH5vXkNnsvHwxgIJKFbPldjSZiZSOyUAkIyF4oq
         AjlgbYwdusOXt08VNnuXhLw1Qnt173MXxi+hU978OjPCJl9e5QWFRyI3Ssy+Z9TnyD
         4obgAqhf7cLsw==
Date:   Thu, 16 Feb 2023 12:48:03 -0800
Subject: [PATCH 1/7] xfs: pass directory offsets as part of the dirent hook
 data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874482.3474898.1437280787820551301.stgit@magnolia>
In-Reply-To: <167657874461.3474898.12919390014293805981.stgit@magnolia>
References: <167657874461.3474898.12919390014293805981.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're calling the dirent hooks about a directory entry update, be
sure to pass the diroffset associated with the change.  We're going to
need this in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |   40 +++++++++++++++++++++++++---------------
 fs/xfs/xfs_inode.h   |    5 +++--
 fs/xfs/xfs_symlink.c |    2 +-
 3 files changed, 29 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ad646beee75..ce1f6d03c3a9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1042,7 +1042,8 @@ xfs_dirent_child_delta(
 	struct xfs_inode		*dp,
 	struct xfs_inode		*ip,
 	int				delta,
-	struct xfs_name			*name)
+	struct xfs_name			*name,
+	unsigned int			diroffset)
 {
 	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch)) {
 		struct xfs_dirent_update_params	p = {
@@ -1050,6 +1051,7 @@ xfs_dirent_child_delta(
 			.ip		= ip,
 			.delta		= delta,
 			.name		= name,
+			.diroffset	= diroffset,
 		};
 		struct xfs_mount	*mp = ip->i_mount;
 
@@ -1210,7 +1212,7 @@ xfs_create(
 	 * Create ip with a reference from dp, and add '.' and '..' references
 	 * if it's a directory.
 	 */
-	xfs_dirent_child_delta(dp, ip, 1, name);
+	xfs_dirent_child_delta(dp, ip, 1, name, diroffset);
 	if (is_dir) {
 		xfs_dirent_self_delta(ip, 1);
 		xfs_dirent_backref_delta(dp, ip, 1);
@@ -1481,7 +1483,7 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_dirent_child_delta(tdp, sip, 1, target_name);
+	xfs_dirent_child_delta(tdp, sip, 1, target_name, diroffset);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -2757,7 +2759,7 @@ xfs_remove(
 	 * Drop the link from dp to ip, and if ip was a directory, remove the
 	 * '.' and '..' references since we freed the directory.
 	 */
-	xfs_dirent_child_delta(dp, ip, -1, name);
+	xfs_dirent_child_delta(dp, ip, -1, name, dir_offset);
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		xfs_dirent_backref_delta(dp, ip, -1);
 		xfs_dirent_self_delta(ip, -1);
@@ -2873,18 +2875,22 @@ static inline void
 xfs_exchange_call_nlink_hooks(
 	struct xfs_inode	*src_dp,
 	struct xfs_name		*src_name,
+	xfs_dir2_dataptr_t	src_diroffset,
 	struct xfs_inode	*src_ip,
 	struct xfs_inode	*target_dp,
 	struct xfs_name		*target_name,
+	xfs_dir2_dataptr_t	target_diroffset,
 	struct xfs_inode	*target_ip)
 {
 	/* Exchange files in the source directory. */
-	xfs_dirent_child_delta(src_dp, src_ip, -1, src_name);
-	xfs_dirent_child_delta(src_dp, target_ip, 1, src_name);
+	xfs_dirent_child_delta(src_dp, src_ip, -1, src_name, src_diroffset);
+	xfs_dirent_child_delta(src_dp, target_ip, 1, src_name, src_diroffset);
 
 	/* Exchange files in the target directory. */
-	xfs_dirent_child_delta(target_dp, target_ip, -1, target_name);
-	xfs_dirent_child_delta(target_dp, src_ip, 1, target_name);
+	xfs_dirent_child_delta(target_dp, target_ip, -1, target_name,
+			target_diroffset);
+	xfs_dirent_child_delta(target_dp, src_ip, 1, target_name,
+			target_diroffset);
 
 	/* If the source file is a dir, update its dotdot entry. */
 	if (S_ISDIR(VFS_I(src_ip)->i_mode)) {
@@ -2903,9 +2909,11 @@ static inline void
 xfs_rename_call_nlink_hooks(
 	struct xfs_inode	*src_dp,
 	struct xfs_name		*src_name,
+	xfs_dir2_dataptr_t	src_diroffset,
 	struct xfs_inode	*src_ip,
 	struct xfs_inode	*target_dp,
 	struct xfs_name		*target_name,
+	xfs_dir2_dataptr_t	target_diroffset,
 	struct xfs_inode	*target_ip,
 	struct xfs_inode	*wip)
 {
@@ -2914,16 +2922,16 @@ xfs_rename_call_nlink_hooks(
 	 * move the source file to the target directory.
 	 */
 	if (target_ip)
-		xfs_dirent_child_delta(target_dp, target_ip, -1, target_name);
-	xfs_dirent_child_delta(target_dp, src_ip, 1, target_name);
+		xfs_dirent_child_delta(target_dp, target_ip, -1, target_name, target_diroffset);
+	xfs_dirent_child_delta(target_dp, src_ip, 1, target_name, target_diroffset);
 
 	/*
 	 * Remove the source file from the source directory, and possibly move
 	 * the whiteout file into its place.
 	 */
-	xfs_dirent_child_delta(src_dp, src_ip, -1, src_name);
+	xfs_dirent_child_delta(src_dp, src_ip, -1, src_name, src_diroffset);
 	if (wip)
-		xfs_dirent_child_delta(src_dp, wip, 1, src_name);
+		xfs_dirent_child_delta(src_dp, wip, 1, src_name, src_diroffset);
 
 	/* If the source file is a dir, update its dotdot entry. */
 	if (S_ISDIR(VFS_I(src_ip)->i_mode)) {
@@ -3080,7 +3088,8 @@ xfs_cross_rename(
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
 
 	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch))
-		xfs_exchange_call_nlink_hooks(dp1, name1, ip1, dp2, name2, ip2);
+		xfs_exchange_call_nlink_hooks(dp1, name1, old_diroffset, ip1,
+				dp2, name2, new_diroffset, ip2);
 
 	return xfs_finish_rename(tp);
 
@@ -3560,8 +3569,9 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch))
-		xfs_rename_call_nlink_hooks(src_dp, src_name, src_ip,
-				target_dp, target_name, target_ip, wip);
+		xfs_rename_call_nlink_hooks(src_dp, src_name, old_diroffset,
+				src_ip, target_dp, target_name, new_diroffset,
+				target_ip, wip);
 
 	error = xfs_finish_rename(tp);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 94a1490fb7b0..403b0f4cb5c0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -592,12 +592,13 @@ struct xfs_dirent_update_params {
 	const struct xfs_inode	*dp;
 	const struct xfs_inode	*ip;
 	const struct xfs_name	*name;
+	unsigned int		diroffset;
 	int			delta;
 };
 
 #ifdef CONFIG_XFS_LIVE_HOOKS
 void xfs_dirent_child_delta(struct xfs_inode *dp, struct xfs_inode *ip,
-		int delta, struct xfs_name *name);
+		int delta, struct xfs_name *name, unsigned int diroffset);
 
 struct xfs_dirent_hook {
 	struct xfs_hook		delta_hook;
@@ -610,7 +611,7 @@ int xfs_dirent_hook_add(struct xfs_mount *mp, struct xfs_dirent_hook *hook);
 void xfs_dirent_hook_del(struct xfs_mount *mp, struct xfs_dirent_hook *hook);
 
 #else
-# define xfs_dirent_child_delta(dp, ip, delta, name)	((void)0)
+# define xfs_dirent_child_delta(dp, ip, delta, name, doff)	((void)0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 77427a50a760..fdfaab466f5d 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -354,7 +354,7 @@ xfs_symlink(
 			goto out_trans_cancel;
 	}
 
-	xfs_dirent_child_delta(dp, ip, 1, link_name);
+	xfs_dirent_child_delta(dp, ip, 1, link_name, diroffset);
 
 	/*
 	 * If this is a synchronous mount, make sure that the

