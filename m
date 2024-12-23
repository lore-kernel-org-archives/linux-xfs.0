Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB492837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995553; cv=none; b=VeEkW6XDwRZn1QfgJ23jQyRcXh5m3NIP0KnSQuEaZ4p1hKJX+e4KL+PV8Q1YM4c/MJKEgknNfF2JMpnmLVMvsjkzfHf50WYcsTM30dc6wqaTOEeDaEM5J7dl+IdkXYuetnFZaROoP2jtvfa/WUnTqBvQ0NFOx/wZ9WY7vNitS14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995553; c=relaxed/simple;
	bh=vJW0p/dPYF4Jy9k++3p70S6MVJeNt5JbsqDsVJRkWtg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMiXbPNC0k0xacFhN4km9pbztlRW5acDPIgKmtjOj5b098GZnnfE5ig3IjDpt1ujQJYOlKFHRrTdVHeVQJEx7curBIYIp6BEotCKveoD4GZAi1Vi9n2vCaepHcHmYp5SIv8QVhOWrMgiuMUUvAX0jxAwp187Kjh+Vkt+kM9/wac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAFllYwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAFllYwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA67EC4CED3;
	Mon, 23 Dec 2024 23:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995553;
	bh=vJW0p/dPYF4Jy9k++3p70S6MVJeNt5JbsqDsVJRkWtg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YAFllYwO+O9KUgz9VccGeHGctFKFPSE094cthEHcgu2aK9b63jfZGvvKxmol5oM0F
	 bp0axQ4QZtqMog3lHitxFE4Lr0KiOyGc/9GdS8neg9UW+BicHim4506yf9/msWXXOc
	 df+WTSAy5lv1HMAOMRORt/uGcnYbANtS9PCrRIGo0SnU9ixj5foFkW5Jx876INk7ox
	 281B7wgtUtzec1pXijkb2LO1dLr3G6CAdnn9lpUlbOZT/OA9430bA+Ygnr6B0TJNVw
	 U0vn5k+4nj13O1O04nhaoPVXMnjJFUeqCo75GV9UTygIbui1hCoh+FtHG1u5+bQYdR
	 1QKeDvgFU8Dmw==
Date: Mon, 23 Dec 2024 15:12:32 -0800
Subject: [PATCH 24/43] xfs: apply rt extent alignment constraints to CoW
 extsize hint
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420349.2381378.11480616460705957571.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   25 ++++++++++++++++++++-----
 fs/xfs/xfs_inode_item.c       |   14 ++++++++++++++
 fs/xfs/xfs_ioctl.c            |   17 +++++++++++++++--
 3 files changed, 49 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 4273d096fb0a9c..f24fa628fecf1e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -910,11 +910,29 @@ xfs_inode_validate_cowextsize(
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
 
@@ -928,16 +946,13 @@ xfs_inode_validate_cowextsize(
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
index a174f64b8bb250..70283c6419fd30 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -157,6 +157,20 @@ xfs_inode_item_precommit(
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
index 4caf29cc59b9ef..726282e74d546d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -469,8 +469,21 @@ xfs_fill_fsxattr(
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

