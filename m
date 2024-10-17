Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9631E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192117; cv=none; b=e8ZqsnUq6FlBid9+filr+gGpLBIQ+s4CD4mHNO4f3419/j0npV7yj2USV+YdIerZQkgo1JqZVbJDF1jN6nHenMe/qWNKWJg565Ea2yxYPAu+S20HQaxVteLWGf0H2X7/SRVk103o6BlPXZvHfOyCrv/Hc+5brxijKtae5pzDQpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192117; c=relaxed/simple;
	bh=OlVhUw7txJo0pkSkxgT09n73spwlvOpZt0ap3mXOw4c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NYXKGQ0ONaF+cvPegStQF9PuDbCjLBHdLJcIqtlwpW6boI+QdUzTErfkfFd3d/qOJ/bsgOIBL8/Y5vf/awcYHXaDc5ruuhji3ELisp2fRb0PHvJlEpi+1VK+y2Z+1PceaNWXQGLPD89otPS6npyh2+iC6+V0d8MpEn9x8GVix+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPzY3Xmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPzY3Xmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EA0C4CEC3;
	Thu, 17 Oct 2024 19:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192117;
	bh=OlVhUw7txJo0pkSkxgT09n73spwlvOpZt0ap3mXOw4c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lPzY3XmvmOzRCbKyTbm8c9pU474odz9g6qPY0RSNs+tnCTFqxfEesSBiMetTBkP+1
	 fY69KbcUpbRH6l7zhM/VjKUhiVJW7JGKwD8sElR2yrabF4SoDYNfZpXTt+p4BtQMUO
	 pYRXro1XLoMxbdk+iAiNVfK8zX8D4aGc7ii9zm3xgJxULn5xe2DtAOZfqqxy6JnPMB
	 66g0zITFrHZwDy05RRM9pIVAw3W6a99lG6aSFpBAQmO+kbb1kviwhRCWuwM8ZMXFEl
	 jgx+PJK6Fuive+rzB5jPxjXL1yxbU0jEQIyGSx5WfNnMVrh9kW7mbCmroFp2mOYxe+
	 kKVKZqk5VZsdg==
Date: Thu, 17 Oct 2024 12:08:36 -0700
Subject: [PATCH 27/34] xfs: create helpers to deal with rounding xfs_fileoff_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072135.3453179.7112771506339901386.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're about to segment xfs_rtblock_t addresses, so we must create
type-specific helpers to do rt extent rounding of file block offsets
because the rtb helpers soon will not do the right thing there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 +++++++++++++----
 fs/xfs/xfs_bmap_util.c       |    6 +++---
 2 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 7be76490a31879..dc2b8beadfc331 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -135,13 +135,22 @@ xfs_rtb_roundup_rtx(
 	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/* Round this rtblock down to the nearest rt extent size. */
+/* Round this file block offset up to the nearest rt extent size. */
 static inline xfs_rtblock_t
-xfs_rtb_rounddown_rtx(
+xfs_fileoff_roundup_rtx(
 	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
+	xfs_fileoff_t		off)
 {
-	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+	return roundup_64(off, mp->m_sb.sb_rextsize);
+}
+
+/* Round this file block offset down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_fileoff_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		off)
+{
+	return rounddown_64(off, mp->m_sb.sb_rextsize);
 }
 
 /* Convert an rt extent number to a file block offset in the rt bitmap file. */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index aa745cc5922246..dff27c69fccb6f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -537,7 +537,7 @@ xfs_can_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	if (xfs_inode_has_bigrtalloc(ip))
-		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
+		end_fsb = xfs_fileoff_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;
@@ -859,8 +859,8 @@ xfs_free_file_space(
 
 	/* We can only free complete realtime extents. */
 	if (xfs_inode_has_bigrtalloc(ip)) {
-		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
-		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
+		startoffset_fsb = xfs_fileoff_roundup_rtx(mp, startoffset_fsb);
+		endoffset_fsb = xfs_fileoff_rounddown_rtx(mp, endoffset_fsb);
 	}
 
 	/*

