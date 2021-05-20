Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3393C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 16:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C48796101B
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 16:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhETQnt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 12:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234410AbhETQnt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 12:43:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9077060FDC;
        Thu, 20 May 2021 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621528947;
        bh=IUeOG84ho7kide4miRL2YvgIBu6iLv54UAZjgmRzc+o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SKKwoujHaHUVdUlBm8xEKKfBckIMMCCilTzCA2oHf0jcF3/OxEpy6zrXTZFH/2wB5
         aeDX/wr9I45NPrxM9s4dKu84yqSxCl+XZECa9Z8s2eLaT+iLP3HPYcv4Mo22/NfUIZ
         aP91OgXZwdTQd6M6PqaM8D8DaSoDak0s8Zd9An4bpyssvn0wG9s0x01923wE6/4OTB
         OU5MZCAlFtXxCfeKMvZz1b6I+1CxFiGXMvCs7A9Hn/J//uE4EvgLtZyk6s4dh+7JiR
         CVEMjYsz9QFc4KP3b5qZ+nyKv825kGiaQ4+lDphDORBg/JEHKmrsIOa0hMluowtUjo
         SByMm9IGpRpow==
Subject: [PATCH 2/2] xfs: validate extsz hints against rt extent size when
 rtinherit is set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 20 May 2021 09:42:27 -0700
Message-ID: <162152894725.2694219.2966158387963381824.stgit@magnolia>
In-Reply-To: <162152893588.2694219.2462663047828018294.stgit@magnolia>
References: <162152893588.2694219.2462663047828018294.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The RTINHERIT bit can be set on a directory so that newly created
regular files will have the REALTIME bit set to store their data on the
realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
the directory, the hint will also be copied into the new file.

As pointed out in previous patches, for realtime files we require the
extent size hint be an integer multiple of the realtime extent, but we
don't perform the same validation on a directory with both RTINHERIT and
EXTSZINHERIT set, even though the only use-case of that combination is
to propagate extent size hints into new realtime files.  This leads to
inode corruption errors when the bad values are propagated.

Because there may be existing filesystems with such a configuration, we
cannot simply amend the inode verifier to trip on these directories and
call it a day because that will cause previously "working" filesystems
to start throwing errors abruptly.  Note that it's valid to have
directories with rtinherit set even if there is no realtime volume, in
which case the problem does not manifest because rtinherit is ignored if
there's no realtime device; and it's possible that someone set the flag,
crashed, repaired the filesystem (which clears the hint on the realtime
file) and continued.

Therefore, mitigate this issue in several ways: First, if we try to
write out an inode with both rtinherit/extszinherit set and an unaligned
extent size hint, we'll simply turn off the hint to correct the error.
Second, if someone tries to misconfigure a file via the fssetxattr
ioctl, we'll fail the ioctl.  Third, we reverify both extent size hint
values when we propagate heritable inode attributes from parent to
child, so that we prevent misconfigurations from spreading.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |   15 ++++++++++++-
 fs/xfs/libxfs/xfs_trans_inode.c |   13 +++++++++++
 fs/xfs/xfs_inode.c              |   46 ++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_ioctl.c              |   14 ++++++++++++
 4 files changed, 74 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 045118c7bf78..dce267dbea5f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -589,8 +589,21 @@ xfs_inode_validate_extsize(
 	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
 	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
 
+	/*
+	 * Historically, XFS didn't check that the extent size hint was an
+	 * integer multiple of the rt extent size on a directory with both
+	 * rtinherit and extszinherit flags set.  This results in math errors
+	 * in the rt allocator and inode verifier errors when the unaligned
+	 * hint value propagates into new realtime files.  Since there might
+	 * be filesystems in the wild, the best we can do for now is to
+	 * mitigate the harms by stopping the propagation.
+	 *
+	 * The next time we add a new inode feature, the if test below should
+	 * also trigger if that new feature is enabled and (rtinherit_flag &&
+	 * inherit_flag).
+	 */
 	if (rt_flag)
-		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
+		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
 	else
 		blocksize_bytes = mp->m_sb.sb_blocksize;
 
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 78324e043e25..cb5e04ed2654 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -142,6 +142,19 @@ xfs_trans_log_inode(
 		flags |= XFS_ILOG_CORE;
 	}
 
+	/*
+	 * Clear invalid extent size hints set on files with rtinherit and
+	 * extszinherit set.  See the comments in xfs_inode_validate_extsize
+	 * for details.
+	 */
+	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
+	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT);
+		ip->i_extsize = 0;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	/*
 	 * Record the specific change for fdatasync optimisation. This allows
 	 * fdatasync to skip log forces for inodes that are only timestamp
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0369eb22c1bb..32458f3f686c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -689,46 +689,56 @@ xfs_inode_inherit_flags(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
-	unsigned int		di_flags = 0;
+	xfs_failaddr_t		failaddr;
 	umode_t			mode = VFS_I(ip)->i_mode;
 
 	if (S_ISDIR(mode)) {
 		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
-			di_flags |= XFS_DIFLAG_RTINHERIT;
+			ip->i_diflags |= XFS_DIFLAG_RTINHERIT;
 		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+			ip->i_diflags |= XFS_DIFLAG_EXTSZINHERIT;
 			ip->i_extsize = pip->i_extsize;
 		}
 		if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
-			di_flags |= XFS_DIFLAG_PROJINHERIT;
+			ip->i_diflags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(mode)) {
 		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
-			di_flags |= XFS_DIFLAG_REALTIME;
+			ip->i_diflags |= XFS_DIFLAG_REALTIME;
 		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSIZE;
+			ip->i_diflags |= XFS_DIFLAG_EXTSIZE;
 			ip->i_extsize = pip->i_extsize;
 		}
 	}
 	if ((pip->i_diflags & XFS_DIFLAG_NOATIME) &&
 	    xfs_inherit_noatime)
-		di_flags |= XFS_DIFLAG_NOATIME;
+		ip->i_diflags |= XFS_DIFLAG_NOATIME;
 	if ((pip->i_diflags & XFS_DIFLAG_NODUMP) &&
 	    xfs_inherit_nodump)
-		di_flags |= XFS_DIFLAG_NODUMP;
+		ip->i_diflags |= XFS_DIFLAG_NODUMP;
 	if ((pip->i_diflags & XFS_DIFLAG_SYNC) &&
 	    xfs_inherit_sync)
-		di_flags |= XFS_DIFLAG_SYNC;
+		ip->i_diflags |= XFS_DIFLAG_SYNC;
 	if ((pip->i_diflags & XFS_DIFLAG_NOSYMLINKS) &&
 	    xfs_inherit_nosymlinks)
-		di_flags |= XFS_DIFLAG_NOSYMLINKS;
+		ip->i_diflags |= XFS_DIFLAG_NOSYMLINKS;
 	if ((pip->i_diflags & XFS_DIFLAG_NODEFRAG) &&
 	    xfs_inherit_nodefrag)
-		di_flags |= XFS_DIFLAG_NODEFRAG;
+		ip->i_diflags |= XFS_DIFLAG_NODEFRAG;
 	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
-		di_flags |= XFS_DIFLAG_FILESTREAM;
+		ip->i_diflags |= XFS_DIFLAG_FILESTREAM;
 
-	ip->i_diflags |= di_flags;
+	/*
+	 * Make sure the extsize actually validates properly.  See the
+	 * comments in xfs_inode_validate_extsize for details.
+	 */
+	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
+			VFS_I(ip)->i_mode, ip->i_diflags);
+	if (failaddr) {
+		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
+				   XFS_DIFLAG_EXTSZINHERIT);
+		ip->i_extsize = 0;
+	}
 }
 
 /* Propagate di_flags2 from a parent inode to a child inode. */
@@ -737,12 +747,22 @@ xfs_inode_inherit_flags2(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
+	xfs_failaddr_t		failaddr;
+
 	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
 		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 		ip->i_cowextsize = pip->i_cowextsize;
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+
+	/* Make sure the cowextsize actually validates properly. */
+	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
+			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
+	if (failaddr) {
+		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = 0;
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6407921aca96..0d1d5e32ab9d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1291,6 +1291,20 @@ xfs_ioctl_setattr_check_extsize(
 
 	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 
+	/*
+	 * Prevent the sysadmin from misconfiguring files to have an invalid
+	 * extent size hint set if rtinherit and extszinherit are set.  See the
+	 * comments in xfs_inode_validate_extsize for details.
+	 */
+	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
+		unsigned int	rtextsize_bytes;
+
+		rtextsize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+		if (fa->fsx_extsize % rtextsize_bytes)
+			return -EINVAL;
+	}
+
 	failaddr = xfs_inode_validate_extsize(ip->i_mount,
 			XFS_B_TO_FSB(mp, fa->fsx_extsize),
 			VFS_I(ip)->i_mode, new_diflags);

