Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73E9C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFBE661108
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhEMBC6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhEMBC4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1445461090;
        Thu, 13 May 2021 01:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867708;
        bh=Mhx9KmhFwI+OY9gIJO0+h8P6yhWDcYNO/kcCV3z4qmQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uHvjKk3MbUvHglK4/e80GWWVsxAW0+sF5JToe7GiIvWw6o7jyKkJBa+RQLvY99M72
         ds67NDgaU3t9bfeDVo6a8CqPEXhTu6UM/repDSikBQSoeocVsxXwrL/zp6+QWpkU3r
         pfbKv6+NKa5fKRhh+yOrrtblKcXXsDqBRDe5nhSN7Ge095/6En6g2ABSyG2lxHL64A
         8fspFzrud8V1V7EJLwXHYkaHdocQjETgS2pObRw3WLnlfQYtuOrX23rZK9NptaykNJ
         Ojta4QoJJ98vUfB4wAhbXfclk7tOYGLuCjXF5U7puN1wFrDzuIV2uHhSN/UzWNV4jW
         DNUbxZWcLSINg==
Subject: [PATCH 1/4] xfs: standardize extent size hint validation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:01:47 -0700
Message-ID: <162086770773.3685783.9402329351753257007.stgit@magnolia>
In-Reply-To: <162086770193.3685783.14418051698714099173.stgit@magnolia>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While chasing a bug involving invalid extent size hints being propagated
into newly created realtime files, I noticed that the xfs_ioctl_setattr
checks for the extent size hints weren't the same as the ones now
encoded in libxfs and used for validation in repair and mkfs.

Because the checks in libxfs are more stringent than the ones in the
ioctl, it's possible for a live system to set inode flags that
immediately result in corruption warnings.  Specifically, it's possible
to set an extent size hint on an rtinherit directory without checking if
the hint is aligned to the realtime extent size, which makes no sense
since that combination is used only to seed new realtime files.

Replace the open-coded and inadequate checks with the libxfs verifier
versions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |   90 +++++++++++-----------------------------------------
 1 file changed, 19 insertions(+), 71 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3925bfcb2365..44d55ebdea09 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1266,108 +1266,56 @@ xfs_ioctl_setattr_get_trans(
 	return ERR_PTR(error);
 }
 
-/*
- * extent size hint validation is somewhat cumbersome. Rules are:
- *
- * 1. extent size hint is only valid for directories and regular files
- * 2. FS_XFLAG_EXTSIZE is only valid for regular files
- * 3. FS_XFLAG_EXTSZINHERIT is only valid for directories.
- * 4. can only be changed on regular files if no extents are allocated
- * 5. can be changed on directories at any time
- * 6. extsize hint of 0 turns off hints, clears inode flags.
- * 7. Extent size must be a multiple of the appropriate block size.
- * 8. for non-realtime files, the extent size hint must be limited
- *    to half the AG size to avoid alignment extending the extent beyond the
- *    limits of the AG.
- *
- * Please keep this function in sync with xfs_scrub_inode_extsize.
- */
 static int
 xfs_ioctl_setattr_check_extsize(
 	struct xfs_inode	*ip,
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_extlen_t		size;
-	xfs_fsblock_t		extsize_fsb;
+	xfs_failaddr_t		failaddr;
+	uint16_t		new_diflags;
 
 	if (!fa->fsx_valid)
 		return 0;
 
 	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
-	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
+	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
 		return -EINVAL;
 
-	if (fa->fsx_extsize == 0)
-		return 0;
-
-	extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
-	if (extsize_fsb > MAXEXTLEN)
+	if (fa->fsx_extsize & mp->m_blockmask)
 		return -EINVAL;
 
-	if (XFS_IS_REALTIME_INODE(ip) ||
-	    (fa->fsx_xflags & FS_XFLAG_REALTIME)) {
-		size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
-	} else {
-		size = mp->m_sb.sb_blocksize;
-		if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
-			return -EINVAL;
-	}
-
-	if (fa->fsx_extsize % size)
-		return -EINVAL;
+	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 
-	return 0;
+	failaddr = xfs_inode_validate_extsize(ip->i_mount,
+			XFS_B_TO_FSB(mp, fa->fsx_extsize),
+			VFS_I(ip)->i_mode, new_diflags);
+	return failaddr != NULL ? -EINVAL : 0;
 }
 
-/*
- * CoW extent size hint validation rules are:
- *
- * 1. CoW extent size hint can only be set if reflink is enabled on the fs.
- *    The inode does not have to have any shared blocks, but it must be a v3.
- * 2. FS_XFLAG_COWEXTSIZE is only valid for directories and regular files;
- *    for a directory, the hint is propagated to new files.
- * 3. Can be changed on files & directories at any time.
- * 4. CoW extsize hint of 0 turns off hints, clears inode flags.
- * 5. Extent size must be a multiple of the appropriate block size.
- * 6. The extent size hint must be limited to half the AG size to avoid
- *    alignment extending the extent beyond the limits of the AG.
- *
- * Please keep this function in sync with xfs_scrub_inode_cowextsize.
- */
 static int
 xfs_ioctl_setattr_check_cowextsize(
 	struct xfs_inode	*ip,
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_extlen_t		size;
-	xfs_fsblock_t		cowextsize_fsb;
+	xfs_failaddr_t		failaddr;
+	uint64_t		new_diflags2;
+	uint16_t		new_diflags;
 
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
-		return 0;
-
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
-		return -EINVAL;
-
-	if (fa->fsx_cowextsize == 0)
-		return 0;
-
-	cowextsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
-	if (cowextsize_fsb > MAXEXTLEN)
+	if (fa->fsx_cowextsize & mp->m_blockmask)
 		return -EINVAL;
 
-	size = mp->m_sb.sb_blocksize;
-	if (cowextsize_fsb > mp->m_sb.sb_agblocks / 2)
-		return -EINVAL;
-
-	if (fa->fsx_cowextsize % size)
-		return -EINVAL;
+	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
+	new_diflags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
 
-	return 0;
+	failaddr = xfs_inode_validate_cowextsize(ip->i_mount,
+			XFS_B_TO_FSB(mp, fa->fsx_cowextsize),
+			VFS_I(ip)->i_mode, new_diflags, new_diflags2);
+	return failaddr != NULL ? -EINVAL : 0;
 }
 
 static int

