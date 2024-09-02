Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8319819CC0A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301591; cv=none; b=MGYifsHsIyw5HTraAQm7Qj0ePLPN0nvQMayng3WZNYgh4lrkwDLba3TMal30BFmGCEw1opHCYghz7DiDlcvKRDPBh4rL3c2sFDBUgdhRJQV57qsTuAQCMyw9QZSgtqiwGS/jfd45CSwfq5fdk+o30dQY9z3gby9D3ApZcErMDHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301591; c=relaxed/simple;
	bh=gz9mvcBNrKM8wp+CbBRRfrEthdil0oyVGQaATShjTu8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGwpttZn8fBIgwLApw8sFXUlLU4O8aDTpb0TkCce+2s2ATH+SzzhDcixpgzR95uW3CqXECRdIpsanQEyrTjyCMyKCNdeaGJHAY/ZThpxMdVFHlZzBR+4Fe+V3EUCFReCK2nX6vVr+c8TMXxJtjb99XT0vb5qR93EpisBS7mcvbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vPYv5pQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vPYv5pQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A6DC4CEC2;
	Mon,  2 Sep 2024 18:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301591;
	bh=gz9mvcBNrKM8wp+CbBRRfrEthdil0oyVGQaATShjTu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vPYv5pQHIhTRBQLNZ5ys4wVBS5IMyxF3i3xmykWpY4j/m8Ha1+JfJB1S6zmn0S+Zf
	 sizRcCtK4qA38FxqfWGuuSAZYBFR8N5pZWXHWK1KfkAv5x/TrhQPw6Pb+O95a/rovT
	 fXTnPP4GsJPd6g73S6O2zMeXxqP8KEB1r1ZAD0A7pa019yazqmGBHbLrxFp+w88xjr
	 ADyiZu+AXQP7KNY+qC0HPuC01QYoZqaQYfxl+7R1+1THMMclJ9r6LCwdHY9cDwKzUV
	 21XC88uBNF8iNHNXjQQ7tNubgiZlqEbv37vR4/XtWo3VZQyYK6Kt6ahOa5x0Xcm+B4
	 qyMICO4tPduhQ==
Date: Mon, 02 Sep 2024 11:26:30 -0700
Subject: [PATCH 10/12] xfs: factor out a xfs_last_rt_bmblock helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105879.3325146.1820867524326666305.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
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

Add helper to calculate the last currently used rt bitmap block to
better structure the growfs code and prepare for future changes to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index febd039718ee..45a0d29949ea 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -948,6 +948,23 @@ xfs_growfs_rt_bmblock(
 	return error;
 }
 
+/*
+ * Calculate the last rbmblock currently used.
+ *
+ * This also deals with the case where there were no rtextents before.
+ */
+static xfs_fileoff_t
+xfs_last_rt_bmblock(
+	struct xfs_mount	*mp)
+{
+	xfs_fileoff_t		bmbno = mp->m_sb.sb_rbmblocks;
+
+	/* Skip the current block if it is exactly full. */
+	if (xfs_rtx_to_rbmword(mp, mp->m_sb.sb_rextents) != 0)
+		bmbno--;
+	return bmbno;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -1059,16 +1076,8 @@ xfs_growfs_rt(
 			goto out_unlock;
 	}
 
-	/*
-	 * Loop over the bitmap blocks.
-	 * We will do everything one bitmap block at a time.
-	 * Skip the current block if it is exactly full.
-	 * This also deals with the case where there were no rtextents before.
-	 */
-	bmbno = mp->m_sb.sb_rbmblocks;
-	if (xfs_rtx_to_rbmword(mp, mp->m_sb.sb_rextents) != 0)
-		bmbno--;
-	for (; bmbno < nrbmblocks; bmbno++) {
+	/* Initialize the free space bitmap one bitmap block at a time. */
+	for (bmbno = xfs_last_rt_bmblock(mp); bmbno < nrbmblocks; bmbno++) {
 		error = xfs_growfs_rt_bmblock(mp, in->newblocks, in->extsize,
 				bmbno);
 		if (error)

