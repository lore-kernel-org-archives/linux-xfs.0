Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D29C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjBPUee (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBPUed (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:34:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89F87288
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:34:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61817B82970
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD66C433D2;
        Thu, 16 Feb 2023 20:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579670;
        bh=IvXZ2/ELhJsXM8A/GUm6uKrcJRT55NRyUH7W/3dgins=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qepATzOQamisu9zJpXNl5kRv0wadSzdeISjjrLQXESQU2U6RPdaxWaiR1vsehIBQp
         bXSVd7Wm/dfqSg34xVktiCPS4OUn0bnhkiwox+wuBUZGX5wR8Sha0us6rvq8gdCrj+
         wrSvANrNPmJ5+2xgrIOFFTjPz4xpWDLuhZHGrcRwOK6B9Br+yw4kyGLQl18r2bn+ie
         ZY/U4yFf8AbPqdBonZBQ0yucJBBGWU0YXAKtY8P6xTskWJNs/Yj3m/7v3J5DZZ9gfM
         JPhdXROJncRp6IUadOQvlQ/zg4+nFiQG0upyRw4w1lBTKeJzh52ZoSWmbBQpO3yPMT
         cNE6yPXH5yYTQ==
Date:   Thu, 16 Feb 2023 12:34:29 -0800
Subject: [PATCH 07/28] xfs: Expose init_xattrs in xfs_create_tmpfile
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872470.3473407.6718782019226919297.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |    5 +++--
 fs/xfs/xfs_inode.h |    2 +-
 fs/xfs/xfs_iops.c  |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 131abf84ea87..267d629a33d9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1109,6 +1109,7 @@ xfs_create_tmpfile(
 	struct user_namespace	*mnt_userns,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1149,7 +1150,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2750,7 +2751,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2eaed98af814..5735de32beeb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 515318dfbc38..45e66c961829 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,8 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, true,
+					   &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;

