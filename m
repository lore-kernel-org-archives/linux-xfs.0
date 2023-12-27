Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495411370
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKrt7bQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FF5C433C7;
	Mon,  1 Jan 2024 00:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069051;
	bh=mTWu4p1X3SxMwEtIWdn/pUKdB611SHaJr3FexIgNazk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YKrt7bQa9NLeQboqHjxO+KTtHD3tGaSN1DuqKfd2REjm4N+aHAN/0RwbTS7/jh4fR
	 d4tFfO3HTOhvrCLZF0GfaP1SSg/mA2rnQ4/JgGDqdfFSb+ZlaD0XiXA45E9shzw/mM
	 nDpTsvVUfN5hcCDSPQyvpxEMWYRRvhIVY+13xvpobvcpnHuBtdKvsUU/R2/bT3iblD
	 pq715OduR7vlIEbzy4QFKHBTtnovr/1GzIlhera0Bt+SbHY4iO6t6qWBNG4AhyWik6
	 sWsDeG2thiUaepFox8uJ3+jypKI1u1kk9y+h6afCYXT8ZdaRay2HqKCQamgfahCehq
	 ng0RHQwf+ngHA==
Date: Sun, 31 Dec 2023 16:30:50 +9900
Subject: [PATCH 18/42] xfs: apply rt extent alignment constraints to CoW
 extsize hint
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017366.1817107.12769277685395608027.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/logitem.c       |   14 ++++++++++++++
 libxfs/xfs_inode_buf.c |   25 ++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)


diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 3ce2d7574a3..60f8fcb187d 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -233,6 +233,20 @@ xfs_inode_item_precommit(
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index f4eabd99a60..d9fc254b354 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -858,11 +858,29 @@ xfs_inode_validate_cowextsize(
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
 
@@ -876,16 +894,13 @@ xfs_inode_validate_cowextsize(
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

