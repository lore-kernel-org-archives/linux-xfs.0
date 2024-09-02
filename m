Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E219719CC01
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301686; cv=none; b=RODtCulCLmpKDBxjlDy4rr/eHB3AMf3E9rr1YFVNoBTTNKRh6zExFB9hoy4x6dQ1wkg3IG10QjwDGFh9jfETJg4uCT4u11dcF2uTs7GbWgOBHLY/s47iCI57f1GRSh5Rmkal5cs43weanVwyZYNkpsoeK2d6yCZCmV/f3BHjLb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301686; c=relaxed/simple;
	bh=89vM3RFVE+tcTmJjPeOCaaJWn65IA/Qe4Geyg6AOX9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C53auXTWRKr+byNGOlhS/WzA7iF0elVPo9hErkGlg1voDZJgnaG7HxAA1kPoqqFE7NSrnwbZWF7OO3suW3lv1+eVUVzJtLljkmjDc62PswJGlHSqgh7vgfd5S9/9ZiW2AlYpAlU+mB2aGVjy+2YFikLElmXVARKjun7NQtCfG9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwIdVrzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwIdVrzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61885C4CEC2;
	Mon,  2 Sep 2024 18:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301685;
	bh=89vM3RFVE+tcTmJjPeOCaaJWn65IA/Qe4Geyg6AOX9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lwIdVrzxFeauvtNN+qMrrjetwBazwrINbp7vLdU2GUZ0+tGj0zBs7p61W4RE98kx8
	 CqCYUfyJ5W+LJiayaKiPSF+E37BLUkaTS6i/cgV9THTBTy1t54BrjvpRjeOcKg9r0K
	 S+b4WbRXm3gRw7n9vDfGCamNmN52JnGIMfsFd+WF7kMgTRFfVc5cq+g/0yzmXSVEE8
	 kjcM4MW//ilfmfM9SQYFOG1ZVPFiSZpcs+SXZe35vinWmv7pdPXB1COUr6PtEhod3o
	 nFq6ceXoNt+DzuVKjinCj8k75wU7/AfzktucA5hmIcuHAxvKBRJPc0fI3wbFKJXq5w
	 k2B+BX69lLX6Q==
Date: Mon, 02 Sep 2024 11:28:04 -0700
Subject: [PATCH 04/10] xfs: don't scan off the end of the rt volume in
 xfs_rtallocate_extent_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106324.3325667.17423376504109071004.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
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

The loop conditional here is not quite correct because an rtbitmap block
can represent rtextents beyond the end of the rt volume.  There's no way
that it makes sense to scan for free space beyond EOFS, so don't do it.
This overrun has been present since v2.6.0.

Also fix the type of bestlen, which was incorrectly converted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c65ee8d1d38d..58081ce5247b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -229,22 +229,20 @@ xfs_rtallocate_extent_block(
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
 	struct xfs_mount	*mp = args->mp;
-	xfs_rtxnum_t		besti;	/* best rtext found so far */
-	xfs_rtxnum_t		bestlen;/* best length found so far */
+	xfs_rtxnum_t		besti = -1; /* best rtext found so far */
 	xfs_rtxnum_t		end;	/* last rtext in chunk */
-	int			error;
 	xfs_rtxnum_t		i;	/* current rtext trying */
 	xfs_rtxnum_t		next;	/* next rtext to try */
+	xfs_rtxlen_t		bestlen = 0; /* best length found so far */
 	int			stat;	/* status from internal calls */
+	int			error;
 
 	/*
-	 * Loop over all the extents starting in this bitmap block,
-	 * looking for one that's long enough.
+	 * Loop over all the extents starting in this bitmap block up to the
+	 * end of the rt volume, looking for one that's long enough.
 	 */
-	for (i = xfs_rbmblock_to_rtx(mp, bbno), besti = -1, bestlen = 0,
-		end = xfs_rbmblock_to_rtx(mp, bbno + 1) - 1;
-	     i <= end;
-	     i++) {
+	end = min(mp->m_sb.sb_rextents, xfs_rbmblock_to_rtx(mp, bbno + 1)) - 1;
+	for (i = xfs_rbmblock_to_rtx(mp, bbno); i <= end; i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
 		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
 

