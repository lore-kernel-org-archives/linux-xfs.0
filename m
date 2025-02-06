Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6D8223316
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882043; cv=none; b=SKQ13TxPt3FNfxtGY5TpM/moGABd2nKZfJivpESnZbXG4IZh+NptfQ6hfNuScApNkspp+IznsZSGGsIXbePOPnKZK6q4hZ9eDxJfZKVD2RnyzejEs6XdQPweICi7c0xa6WTvJxO47rxriGXJP9eWg7OunmhsYqrub5LCJoT+BQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882043; c=relaxed/simple;
	bh=Z7n+eeadKJgC/RT6Uut9UekxsH1SV5nqvRC0a1t2aAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjPnXt/0ZXvobGXCyrmUfR9qxzc2wA3k5CQjjPFPNUWvri56kxbaAScCoVd0K80uLuZG2bjvUAhxZoAgfWRWyBcRDiVs1A6mJ6YFvIAN8OCx/R2kxWq6E1iOryZYywWQd7j7cyBxkxRS04TNLgDmLTuEzKHpcCLzX8uV4pW2rBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Na+5Cdg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Na+5Cdg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C5CC4CEDD;
	Thu,  6 Feb 2025 22:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882043;
	bh=Z7n+eeadKJgC/RT6Uut9UekxsH1SV5nqvRC0a1t2aAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Na+5Cdg0kUgrNl392Uo7wZE82NIEode+14xmG++MbhjwqjL4UY+hAAFfWPqllYm6A
	 /QtUJazvMDEyR1dwvTdTs0jKXAExLdwzcOeiM5tveTlfAmJOp2XsRJbaAFPa1gE067
	 p9BQGseMb9977T5kc24HN4bV+tdWlGamoo9LtlRSPD81s8cUONX543LY4R7JaXF+Ih
	 1unbsZZ1rzgW4JzRcIslYU7vQ3OwNCAIecZOZtke9f3fzG+AAafYtvglC8MnYkFg82
	 2bxlrEXRotpccYgO8vtWxuWHfZeV/ZrEufNL3VpWRr6vpClM7sVF3aiwbdaktzlkvY
	 j3USBRcdh5vlA==
Date: Thu, 06 Feb 2025 14:47:23 -0800
Subject: [PATCH 47/56] xfs: apply rt extent alignment constraints to CoW
 extsize hint
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087512.2739176.11821916343211222974.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4de1a7ba4171db681691bd80506d0cf43c5cb46a

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
 libxfs/xfs_inode_buf.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index a7774fc32e2755..5ca857ca2dc10e 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -907,11 +907,29 @@ xfs_inode_validate_cowextsize(
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
 
@@ -925,16 +943,13 @@ xfs_inode_validate_cowextsize(
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

