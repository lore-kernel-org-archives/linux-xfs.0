Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9481DC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2236138C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhGIEOf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhGIEOf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758806138C
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jul 2021 04:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625803912;
        bh=WFlfvwcLspP3mzr2cEmCkCtFhGWFXulXstEHc/YTUEw=;
        h=Date:From:To:Subject:From;
        b=ZVWyQ9L0RTvm/+MR7IAss6i0t/xiBgrngSYIHvGduwPPuXGD0kVTkxaMyJq2DFBsu
         rQuNEjLC/RKFsOsroBhvAvlGg1Q24Gt9GYQd5iGAiVXoJL5hva9UnHCLZD1b8niqQM
         QsehzMyG8hmUK9SXtjzhrEfElX22ax18aous3yQWHY/yi6Qhu4Hk3jORbvRMyfaETC
         ZC9Xw4dqjCX2TAWCsfFIzpcpYJwhblMWeF0x+PhztbVf7Ez8RUa9LZLGhtAiO5Keq/
         yCMXJX/JyZ5S69f2VzJq0CGo1fg9x965gbHS5AxuFF8zfDx7eCXAuIcTkzVOPL1wYT
         0PXBfCmWc5vSA==
Date:   Thu, 8 Jul 2021 21:11:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: correct the narrative around misaligned
 rtinherit/extszinherit dirs
Message-ID: <20210709041152.GN11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While auditing the realtime growfs code, I realized that the GROWFSRT
ioctl (and by extension xfs_growfs) has always allowed sysadmins to
change the realtime extent size when adding a realtime section to the
filesystem.  Since we also have always allowed sysadmins to set
RTINHERIT and EXTSZINHERIT on directories even if there is no realtime
device, this invalidates the premise laid out in the comments added in
commit 603f000b15f2.

In other words, this is not a case of inadequate metadata validation.
This is a case of nearly forgotten (and apparently untested) but
supported functionality.  Update the comments to reflect what we've
learned, and remove the log message about correcting the misalignment.

Fixes: 603f000b15f2 ("xfs: validate extsz hints against rt extent size when rtinherit is set")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |   28 ++++++++++++++++------------
 fs/xfs/libxfs/xfs_trans_inode.c |   10 ++++------
 fs/xfs/xfs_ioctl.c              |    8 ++++----
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 04ce361688f7..84ea2e0af9f0 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -592,23 +592,27 @@ xfs_inode_validate_extsize(
 	/*
 	 * This comment describes a historic gap in this verifier function.
 	 *
-	 * On older kernels, the extent size hint verifier doesn't check that
-	 * the extent size hint is an integer multiple of the realtime extent
-	 * size on a directory with both RTINHERIT and EXTSZINHERIT flags set.
-	 * The verifier has always enforced the alignment rule for regular
-	 * files with the REALTIME flag set.
+	 * For a directory with both RTINHERIT and EXTSZINHERIT flags set, this
+	 * function has never checked that the extent size hint is an integer
+	 * multiple of the realtime extent size.  Since we allow users to set
+	 * this combination  on non-rt filesystems /and/ to change the rt
+	 * extent size when adding a rt device to a filesystem, the net effect
+	 * is that users can configure a filesystem anticipating one rt
+	 * geometry and change their minds later.  Directories do not use the
+	 * extent size hint, so this is harmless for them.
 	 *
 	 * If a directory with a misaligned extent size hint is allowed to
 	 * propagate that hint into a new regular realtime file, the result
 	 * is that the inode cluster buffer verifier will trigger a corruption
-	 * shutdown the next time it is run.
+	 * shutdown the next time it is run, because the verifier has always
+	 * enforced the alignment rule for regular files.
 	 *
-	 * Unfortunately, there could be filesystems with these misconfigured
-	 * directories in the wild, so we cannot add a check to this verifier
-	 * at this time because that will result a new source of directory
-	 * corruption errors when reading an existing filesystem.  Instead, we
-	 * permit the misconfiguration to pass through the verifiers so that
-	 * callers of this function can correct and mitigate externally.
+	 * Because we allow administrators to set a new rt extent size when
+	 * adding a rt section, we cannot add a check to this verifier because
+	 * that will result a new source of directory corruption errors when
+	 * reading an existing filesystem.  Instead, we rely on callers to
+	 * decide when alignment checks are appropriate, and fix things up as
+	 * needed.
 	 */
 
 	if (rt_flag)
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 8d595a5c4abd..16f723ebe8dd 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -143,16 +143,14 @@ xfs_trans_log_inode(
 	}
 
 	/*
-	 * Inode verifiers on older kernels don't check that the extent size
-	 * hint is an integer multiple of the rt extent size on a directory
-	 * with both rtinherit and extszinherit flags set.  If we're logging a
-	 * directory that is misconfigured in this way, clear the hint.
+	 * Inode verifiers do not check that the extent size hint is an integer
+	 * multiple of the rt extent size on a directory with both rtinherit
+	 * and extszinherit flags set.  If we're logging a directory that is
+	 * misconfigured in this way, clear the hint.
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
 	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
-		xfs_info_once(ip->i_mount,
-	"Correcting misaligned extent size hint in inode 0x%llx.", ip->i_ino);
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0f6794333b01..cfc2e099d558 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1292,10 +1292,10 @@ xfs_ioctl_setattr_check_extsize(
 	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 
 	/*
-	 * Inode verifiers on older kernels don't check that the extent size
-	 * hint is an integer multiple of the rt extent size on a directory
-	 * with both rtinherit and extszinherit flags set.  Don't let sysadmins
-	 * misconfigure directories.
+	 * Inode verifiers do not check that the extent size hint is an integer
+	 * multiple of the rt extent size on a directory with both rtinherit
+	 * and extszinherit flags set.  Don't let sysadmins misconfigure
+	 * directories.
 	 */
 	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
