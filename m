Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797C7C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 01:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhLPBJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLPBJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F5DC061574
        for <linux-xfs@vger.kernel.org>; Wed, 15 Dec 2021 17:09:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12303B8226C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76C0C36AE0;
        Thu, 16 Dec 2021 01:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616988;
        bh=FZUTNG5EFGJx+rII8bxVz9Ui5NlHWS8npk+Z2sLBgC0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bYlWCZxFSuZVJpFF4XeV8pvJZFIw+FgLAXLAxsFnBf12XFwTJeTIe/VMDp07UEmOl
         BkB2RPLE5K2tXo1fb3f/I6QIYV+Su23mUdv4L8pFq14gU0ZWMhPDRlmInB2pmkbniP
         qVdvuOVcGYK2ZqkvQw9LPAbLSMl1LBUvLZ87zn2wWRQJd5nrI+iK8hq0yC+3waiJH/
         0wLwJgoy0bjNqA/CS3QlkoW7d5vcmMzWv+zae3ELJfNPmDiGGIpjEVCqxjwILHGmVM
         KNEHTVXbISMcLsU/pyDKy2fUIdGmdwXCkOJR7AfTe2y9TxWY3hQByrXu3LLH8T0rQf
         C1/EHpgXOn4ug==
Subject: [PATCH 6/7] xfs: don't expose internal symlink metadata buffers to
 the vfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Ian Kent <raven@themaw.net>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:48 -0800
Message-ID: <163961698851.3129691.1262560189729839928.stgit@magnolia>
In-Reply-To: <163961695502.3129691.3496134437073533141.stgit@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ian Kent reported that for inline symlinks, it's possible for
vfs_readlink to hang on to the target buffer returned by
_vn_get_link_inline long after it's been freed by xfs inode reclaim.
This is a layering violation -- we should never expose XFS internals to
the VFS.

When the symlink has a remote target, we allocate a separate buffer,
copy the internal information, and let the VFS manage the new buffer's
lifetime.  Let's adapt the inline code paths to do this too.  It's
less efficient, but fixes the layering violation and avoids the need to
adapt the if_data lifetime to rcu rules.  Clearly I don't care about
readlink benchmarks.

As a side note, this fixes the minor locking violation where we can
access the inode data fork without taking any locks; proper locking (and
eliminating the possibility of having to switch inode_operations on a
live inode) is essential to online repair coordinating repairs
correctly.

Reported-by: Ian Kent <raven@themaw.net>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c    |   34 +---------------------------------
 fs/xfs/xfs_symlink.c |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 38 deletions(-)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a607d6aca5c4..72bdd7c79e93 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -511,27 +511,6 @@ xfs_vn_get_link(
 	return ERR_PTR(error);
 }
 
-STATIC const char *
-xfs_vn_get_link_inline(
-	struct dentry		*dentry,
-	struct inode		*inode,
-	struct delayed_call	*done)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	char			*link;
-
-	ASSERT(ip->i_df.if_format == XFS_DINODE_FMT_LOCAL);
-
-	/*
-	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
-	 * if_data is junk.
-	 */
-	link = ip->i_df.if_u1.if_data;
-	if (XFS_IS_CORRUPT(ip->i_mount, !link))
-		return ERR_PTR(-EFSCORRUPTED);
-	return link;
-}
-
 static uint32_t
 xfs_stat_blksize(
 	struct xfs_inode	*ip)
@@ -1250,14 +1229,6 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.update_time		= xfs_vn_update_time,
 };
 
-static const struct inode_operations xfs_inline_symlink_inode_operations = {
-	.get_link		= xfs_vn_get_link_inline,
-	.getattr		= xfs_vn_getattr,
-	.setattr		= xfs_vn_setattr,
-	.listxattr		= xfs_vn_listxattr,
-	.update_time		= xfs_vn_update_time,
-};
-
 /* Figure out if this file actually supports DAX. */
 static bool
 xfs_inode_supports_dax(
@@ -1408,10 +1379,7 @@ xfs_setup_iops(
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
-		if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-			inode->i_op = &xfs_inline_symlink_inode_operations;
-		else
-			inode->i_op = &xfs_symlink_inode_operations;
+		inode->i_op = &xfs_symlink_inode_operations;
 		break;
 	default:
 		inode->i_op = &xfs_inode_operations;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index fc2c6a404647..4868bd986f52 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
+#include "xfs_error.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -101,12 +102,10 @@ xfs_readlink(
 {
 	struct xfs_mount *mp = ip->i_mount;
 	xfs_fsize_t	pathlen;
-	int		error = 0;
+	int		error = -EFSCORRUPTED;
 
 	trace_xfs_readlink(ip);
 
-	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
-
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
@@ -121,12 +120,22 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		error = -EFSCORRUPTED;
 		goto out;
 	}
 
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		/*
+		 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
+		 * if_data is junk.
+		 */
+		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data))
+			goto out;
 
-	error = xfs_readlink_bmap_ilocked(ip, link);
+		memcpy(link, ip->i_df.if_u1.if_data, ip->i_disk_size + 1);
+		error = 0;
+	} else {
+		error = xfs_readlink_bmap_ilocked(ip, link);
+	}
 
  out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);

