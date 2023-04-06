Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91116C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbjDFTUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240566AbjDFTUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:20:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BE36589
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74DA260F3E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D413EC433EF;
        Thu,  6 Apr 2023 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808840;
        bh=EJGrPDHMSCNJMiMSi6OLp8OwM9W5EA8VQaXekRZj4PM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jEWLiB0V0OZnVetvqaTAOlEFFNICPbcWQ7wBXLLbgjaHwBEAzjYd9rQQcMftvHXt+
         JGFse0UHznGJzrjHCTTX0N52gbsC7pXXbTip1fiJTNvlZv6fTMiZv7wGNBZ+4Eg5SA
         eWH/qGk2pnmx5W4kQ9fF3GxzkfbSdV0hh8e/zBXfG6wV/KQo/Du7XzIp5bNyn9G6Sr
         0zzthDNRkkkhzkXNbIn1wPRkvyS/5YQxndgII9Z8K3zC6heC+ZRz+n/1anBD81s1SU
         jVk7yFxwD3VFTjGqHxEJtuS5Oe85VU1wqF665BeXIZEhU1Zo/pZXoS6Wan0HSH1Gn/
         f79Zd+Li6+MPA==
Date:   Thu, 06 Apr 2023 12:20:40 -0700
Subject: [PATCH 01/23] xfs: Expose init_xattrs in xfs_create_tmpfile
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824673.615225.13654780949771939812.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_iops.c  |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a62e07ae9c80..3e08a056bafe 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1109,6 +1109,7 @@ xfs_create_tmpfile(
 	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1149,7 +1150,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2750,7 +2751,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 69d21e42c10a..112fb5767233 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct mnt_idmap *idmap,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 24718adb3c16..afc3cff11cf9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,7 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, true, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;

