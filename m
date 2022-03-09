Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41005C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiCITXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiCITXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:23:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF7B6CA76
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3EB82CE20F8
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F622C340F3;
        Wed,  9 Mar 2022 19:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853732;
        bh=5UcXU0y3yf46Bbvpd/6b4XPTcaSUyIl7owmHxI8JWNY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qJyagVLRKaGsBVl7DaA5ije2SRWBDJ1UZDB4xMliTnBeDy2kkg3mN/+f/pR/RMUnR
         73emomUy6qW8pIq+fgN9fO6xNJCsNvvY+N2aE4nUGzEOlqTwwPOUio/i+tX9pEqWcO
         LDo4kFQcCunEnBW16rjcooxjlw1m16dd4bLheDXVooJ76eDZwjjG+1FWd+3pirtmN/
         HaT3jLlLc57FXWQsQujgd5eGz/OQbUawerrbF7QVMGHzlBrfqTcAgXChEBMcOpMbFY
         AnfjultbiRJD9dEVVEE2+cQHi7AW9ReZmvnbNmZvck1q+hxTs+PrOAExCn3LsHUyAN
         19jNWqhbk3gyQ==
Subject: [PATCH 1/2] xfs: use setattr_copy to set vfs inode attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, brauner@kernel.org,
        david@fromorbit.com, hch@lst.de
Date:   Wed, 09 Mar 2022 11:22:11 -0800
Message-ID: <164685373184.495833.7593050602112292799.stgit@magnolia>
In-Reply-To: <164685372611.495833.8601145506549093582.stgit@magnolia>
References: <164685372611.495833.8601145506549093582.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
revocation isn't consistent with btrfs[1] or ext4.  Those two
filesystems use the VFS function setattr_copy to convey certain
attributes from struct iattr into the VFS inode structure.

Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
decide if it should clear setgid and setuid on a file attribute update.
This is a second symptom of the problem that Filipe noticed.

XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
/not/ a simple copy function; it contains additional logic to clear the
setgid bit when setting the mode, and XFS' version no longer matches.

The VFS implements its own setuid/setgid stripping logic, which
establishes consistent behavior.  It's a tad unfortunate that it's
scattered across notify_change, should_remove_suid, and setattr_copy but
XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
functions and get rid of the old functions.

[1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/

Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c |   56 +++--------------------------------------------------
 fs/xfs/xfs_pnfs.c |    3 ++-
 2 files changed, 5 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b79b3846e71b..4132026f5fb0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -613,37 +613,6 @@ xfs_vn_getattr(
 	return 0;
 }
 
-static void
-xfs_setattr_mode(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-	umode_t			mode = iattr->ia_mode;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	inode->i_mode &= S_IFMT;
-	inode->i_mode |= mode & ~S_IFMT;
-}
-
-void
-xfs_setattr_time(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
-	if (iattr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = iattr->ia_ctime;
-	if (iattr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = iattr->ia_mtime;
-}
-
 static int
 xfs_vn_change_ok(
 	struct user_namespace	*mnt_userns,
@@ -742,16 +711,6 @@ xfs_setattr_nonsize(
 		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			inode->i_mode &= ~(S_ISUID|S_ISGID);
-
 		/*
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
@@ -763,7 +722,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_GQUOTA_ON(mp)) {
@@ -774,15 +732,10 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			inode->i_gid = gid;
 		}
 	}
 
-	if (mask & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
@@ -1006,11 +959,8 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	if (iattr->ia_valid & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 4abe17312c2b..37a24f0f7cd4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -319,7 +319,8 @@ xfs_fs_commit_blocks(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_setattr_time(ip, iattr);
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(&init_user_ns, inode, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
 		ip->i_disk_size = iattr->ia_size;

