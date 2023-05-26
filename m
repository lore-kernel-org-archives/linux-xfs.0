Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A18CC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjEZCLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjEZCLa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:11:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E21A3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:11:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65BF061834
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCD9C433EF;
        Fri, 26 May 2023 02:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067087;
        bh=duLhdxcwbrkR/BpK7poP2dCaIinTLoQIdJNTeW/KfG0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rc46qcDc1NpfHLsK6eGOA9jj7a6idrhbwxYkb+zGbJrlgb9ty2NkNs3OIMUM6kFIV
         5OfhRwAO3lHKHxYG+C2AMxXX664cExcU6YB95iW8JYxehEBiC0aAMYpAQKHXeQoSWz
         ZQZonFr88vABjTeV5mMMiKA2gEJqfRY+w7mSUIFI91oGrP9Rvr0j+i9FmUdc8Fc/C2
         r0+0E7wTm4hb9tmbTRs9AINl33Q2PnEQWFestjm9Pet4Auyk6IOOPCkMm3iXyRVuqQ
         Z4XYFiJjnsDfxmJ4cjJQlBfy+7xodFufEYTEDMLTsQQY6ZsbuwLg7W373kmwFrgtIu
         QAsFeIfgmgxuA==
Date:   Thu, 25 May 2023 19:11:27 -0700
Subject: [PATCH 06/18] xfs: add parent attributes to link
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072782.3744191.9405816408407261884.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
References: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.c |   14 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    3 +--
 fs/xfs/scrub/dir_repair.c       |    2 +-
 fs/xfs/scrub/orphanage.c        |    2 +-
 fs/xfs/xfs_inode.c              |   43 ++++++++++++++++++++++++++++++++++-----
 5 files changed, 54 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index 90532c3fa205..cf775750120e 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -50,3 +50,17 @@ xfs_mkdir_space_res(
 {
 	return xfs_create_space_res(mp, namelen);
 }
+
+unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 6cda87153b38..5539634009fb 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -86,8 +86,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
@@ -107,5 +105,6 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 60578de031ca..c44da2f46b76 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -701,7 +701,7 @@ xrep_dir_replay_update(
 	uint				resblks;
 	int				error;
 
-	resblks = XFS_LINK_SPACE_RES(mp, dirent->namelen);
+	resblks = xfs_link_space_res(mp, dirent->namelen);
 	error = xchk_trans_alloc(rd->sc, resblks);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 5daa69923641..2a093eb08f2a 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -262,7 +262,7 @@ xrep_adoption_init(
 	unsigned int		child_blkres = 0;
 
 	adopt->sc = sc;
-	adopt->orphanage_blkres = XFS_LINK_SPACE_RES(mp, MAXNAMELEN);
+	adopt->orphanage_blkres = xfs_link_space_res(mp, MAXNAMELEN);
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		child_blkres = XFS_RENAME_SPACE_RES(sc->mp,
 							xfs_name_dotdot.len);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8e7e763345a6..34e99f293698 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1298,14 +1298,15 @@ xfs_create_tmpfile(
 
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1322,11 +1323,25 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto std_return;
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto out_parent;
+
+	/*
+	 * We don't allow reservationless or quotaless hardlinking when parent
+	 * pointers are enabled because we can't back out if the xattrs must
+	 * grow.
+	 */
+	if (parent && nospace_error) {
+		error = nospace_error;
+		goto error_return;
+	}
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1366,6 +1381,19 @@ xfs_link(
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
+
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_add(tp, parent, tdp, target_name, sip);
+		if (error)
+			goto error_return;
+	}
+
 	xfs_dir_update_hook(tdp, sip, 1, target_name);
 
 	/*
@@ -1379,12 +1407,15 @@ xfs_link(
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+ out_parent:
+	xfs_parent_finish(mp, parent);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;

