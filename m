Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9389F13777F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924789; cv=none; b=QO4qFhgAbazy8fUUtPeitZ2QOoRSQgN/9Rg66BcWemECf561PzI0IohmronThiEClC2BcDQURRvlrxXfzxG6lEa3URvUGoPQN2XG/l/3x9buwCRGyDQdcdtV8WEOx5Q0Rvo3KfypaD1+3Lazz+Feu2MpBJNR6M9nfVu5vJIfqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924789; c=relaxed/simple;
	bh=+aShNwy0d4LlIBI7nNt9tluQIjTPwONPiDyBnvC2cQE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ad4OwaF69RPe0THI9IvChXGTmps+vVvJIr/u+ACQoIFsrS4dLaxWCio11DT0vrgSi1APDar7oQhkwySac5qVkEB/K2+ixyW5LaU6sBa8AMaHUzvFzOiDsHMM38+IfWZmw/22b2YGQ67KmKCdTSlDNmrqwkwnOXiuN4C4gsd0+4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAUMLvd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAUMLvd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7542EC2BD10;
	Thu, 20 Jun 2024 23:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924789;
	bh=+aShNwy0d4LlIBI7nNt9tluQIjTPwONPiDyBnvC2cQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QAUMLvd8wp/Y85Qdkamp0TdmvQWqVNg1M5qzhGzI1o+Q90knBAv6VpXkqVBls+X8J
	 ynzhnUty+0tHys4zOE8VFmo3G1q6ZSE8k7JuxH45wF8SREAcAMZsnZzA6vhbc5ISsl
	 Pndf944qeDSWbiwIgvkYHds7eSZX6fkLnM11QwHAC1PxIFGETOZbQPc4dzmnJW1AGF
	 R4aI3RwhSxKuXlWj/ovU893cfORtD6hNMfF4TLJmaWjf7IA5Y1rwWDOi0MHlUSrT3a
	 0E10tKt662Os/5CmK9NI9y5Q7vZuyMyCTANtsD1apDN5yhe97ICgGR9dkOOiQF3RYQ
	 /P536eBqVFb4w==
Date: Thu, 20 Jun 2024 16:06:29 -0700
Subject: [PATCH 7/9] xfs: remove duplicate asserts in xfs_defer_extent_free
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418817.3183906.7626439031136647728.stgit@frogsfrogsfrogs>
In-Reply-To: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The bno/len verification is already done by the calls to
xfs_verify_rtbext / xfs_verify_fsbext, and reporting a corruption error
seem like the better handling than tripping an assert anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   13 -------------
 1 file changed, 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9c6dc82539639..03a0a4289d943 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2593,23 +2593,10 @@ xfs_defer_extent_free(
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
-#ifdef DEBUG
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
 
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(len > 0);
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
-	agno = XFS_FSB_TO_AGNO(mp, bno);
-	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno < mp->m_sb.sb_agblocks);
-	ASSERT(len < mp->m_sb.sb_agblocks);
-	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
-#endif
 	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
-	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))

