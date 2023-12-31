Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBB9BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VcQLTvDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4E3C433C8;
	Sun, 31 Dec 2023 21:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059450;
	bh=D29AdvAM3W6TZFoxrtqV08LxVSoZfiToUABFj7RVwu4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VcQLTvDDmDVJUCktp5h4UeqPaCFlbv29RnzuPTcvAGuB0P/JbNByt7r0piDGWdBcX
	 n/UfudDDkDLlQL4CmUsLotN5+Og1r/8H9ABL2PuPVCBCBPN7I9xy8/4vz8yqXz1ExP
	 3LCW+UYq4e2tGHSGJIx4RmglAbzuL2QzIeUj0u6oGEYvtH4aZogYVkCDcMho27+bjs
	 QI/4KaHV8Tb2oew+QK9HjCMyC0WnWGUwrJ3uHjfvWvipxxpDNDzAtSz0LQ2ZHVTTYx
	 J4WVg0Lpw8FEwpRS7Ie0IqlT2OoplGChq+g9I47Klv4pVvTGq8xvfwZQaiye91fTjF
	 rkltQLmYuIeGg==
Date: Sun, 31 Dec 2023 13:50:49 -0800
Subject: [PATCH 24/44] xfs: apply rt extent alignment constraints to CoW
 extsize hint
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851967.1766284.11315488240210718409.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The copy-on-write extent size hint is subject to the same alignment
constraints as the regular extent size hint.  Since we're in the process
of adding reflink (and therefore CoW) to the realtime device, we must
apply the same scattered rextsize alignment validation strategies to
both hints to deal with the possibility of rextsize changing.

Therefore, fix the inode validator to perform rextsize alignment checks
on regular realtime files, and to remove misaligned directory hints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   25 ++++++++++++++++++++-----
 fs/xfs/xfs_inode_item.c       |   14 ++++++++++++++
 fs/xfs/xfs_ioctl.c            |   17 +++++++++++++++--
 3 files changed, 49 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ba37b864f6a8b..81a12ca8ec434 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -861,11 +861,29 @@ xfs_inode_validate_cowextsize(
 	bool				rt_flag;
 	bool				hint_flag;
 	uint32_t			cowextsize_bytes;
+	uint32_t			blocksize_bytes;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
 	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
+	/*
+	 * Similar to extent size hints, a directory can be configured to
+	 * propagate realtime status and a CoW extent size hint to newly
+	 * created files even if there is no realtime device, and the hints on
+	 * disk can become misaligned if the sysadmin changes the rt extent
+	 * size while adding the realtime device.
+	 *
+	 * Therefore, we can only enforce the rextsize alignment check against
+	 * regular realtime files, and rely on callers to decide when alignment
+	 * checks are appropriate, and fix things up as needed.
+	 */
+
+	if (rt_flag)
+		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+	else
+		blocksize_bytes = mp->m_sb.sb_blocksize;
+
 	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
 
@@ -879,16 +897,13 @@ xfs_inode_validate_cowextsize(
 	if (mode && !hint_flag && cowextsize != 0)
 		return __this_address;
 
-	if (hint_flag && rt_flag)
-		return __this_address;
-
-	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
+	if (cowextsize_bytes % blocksize_bytes)
 		return __this_address;
 
 	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
-	if (cowextsize > mp->m_sb.sb_agblocks / 2)
+	if (!rt_flag && cowextsize > mp->m_sb.sb_agblocks / 2)
 		return __this_address;
 
 	return NULL;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fdc0b14bb9fbb..16d7d934da6e8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -127,6 +127,20 @@ xfs_inode_item_precommit(
 	if (flags & XFS_ILOG_IVERSION)
 		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
 
+	/*
+	 * Inode verifiers do not check that the CoW extent size hint is an
+	 * integer multiple of the rt extent size on a directory with both
+	 * rtinherit and cowextsize flags set.  If we're logging a directory
+	 * that is misconfigured in this way, clear the hint.
+	 */
+	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
+		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = 0;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	if (!iip->ili_item.li_buf) {
 		struct xfs_buf	*bp;
 		int		error;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4559d122101cd..f85d5f142d180 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1058,8 +1058,21 @@ xfs_fill_fsxattr(
 		}
 	}
 
-	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
-		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		/*
+		 * Don't let a misaligned CoW extent size hint on a directory
+		 * escape to userspace if it won't pass the setattr checks
+		 * later.
+		 */
+		if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+		    ip->i_cowextsize % mp->m_sb.sb_rextsize > 0) {
+			fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
+			fa->fsx_cowextsize = 0;
+		} else {
+			fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
+		}
+	}
+
 	fa->fsx_projid = ip->i_projid;
 	if (ifp && !xfs_need_iread_extents(ifp))
 		fa->fsx_nextents = xfs_iext_count(ifp);

