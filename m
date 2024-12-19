Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CD01990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637283; cv=none; b=fRn2/ZoKOcz2QicJhfrfc0x9gzXwGLVgEtAk43P2eV6IM5nlsdlzMQClC2bVOxHqGNXPsJpFTqcqd/aUFhpDO/bsoxr4HkzqixVqEMYQKFjJMCjXMSgmGTHVFPDISblDiXYDx1C/LI3jWeu1MU0rjr/9l+gGq/Zm90UO6Ljlv9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637283; c=relaxed/simple;
	bh=arbOWgl3Veh440k50ZM4W7xCfpC2MznMhe6f/fM1NqA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrPdr91IZULcwF952YDZegkJhTE4cZ7fb3nevsnuda++90ia0cgOYI8of0AogaVUv/c6wpmPoi4c2lY3v9RASAoNRanIXMuI/q/E6/Qe+ln9P/PE8tZiCWmx6W11VmhQeFh1174zNI6rU0ondf8JNG0jzU6rbrmTdRC33nNf558=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGzPsFAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGzPsFAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89B6C4CECE;
	Thu, 19 Dec 2024 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637282;
	bh=arbOWgl3Veh440k50ZM4W7xCfpC2MznMhe6f/fM1NqA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aGzPsFAPUBJggffakeqPikxortA/HsZunDCM8zvlEJQxJ4dO2zw6oj7Ri32l823tL
	 uFnAtd2F5wDXDJkUL+QGhNH6jpq/akqmRKNsZy/RDqFFxSd9cFF0q4a9OYNZcjSq+W
	 AlP1KAwtjbwsa3tcuQFyWjLW6BF765C1NNpkDpM4phuPUxI5ehKMM0O0DnzsA3N0J0
	 kyHgmAQTVxkwQc7iQlF+77qsc+9i/YzGlbZn7C4Qu5eZpPTfPApHsX/ktmnFWgx7pt
	 6R2VxysykseDnQH/8DFbBDhlSujm7NZfg6fKEAm4Rc5t317KUgmYfP2rhPNuBOCFIe
	 ekDb3N9txPvUQ==
Date: Thu, 19 Dec 2024 11:41:22 -0800
Subject: [PATCH 32/43] xfs: allow dquot rt block count to exceed rt blocks on
 reflink fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581526.1572761.10813599358753651805.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the quota scrubber to allow dquots where the realtime block count
exceeds the block count of the rt volume if reflink is enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 183d531875eae5..58d6d4ed2853b3 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -212,12 +212,18 @@ xchk_quota_item(
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
+					offset);
 	} else {
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					offset);
 	}
-	if (dq->q_ino.count > fs_icount || dq->q_rtb.count > mp->m_sb.sb_rblocks)
+	if (dq->q_ino.count > fs_icount)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/*

