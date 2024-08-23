Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4151195
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371892; cv=none; b=kCOsZ5BmzjAfeDXoY7KIr/dBbQv+ZiO8H1aOomF7GrsLAv01zK/RVI9Q9g01MdnCbY0LZu2kJXTtxNw9NoSWJua/AUQD6tDAC7iCDQVuWRmufSv4D1OJYXWJFX18RtoqIKPPjpLb14Hj7ZRogU2e2qsbF0NYVtCykSN35rKLXco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371892; c=relaxed/simple;
	bh=xFNNsQWboymbRGTHO07M3xy+kyzbZgmondCLWi2RXlQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnnWx3hKVEZMi8M6Cs5m4Crq3RoDFxBQfGUvnTvuetgDHodSsQUQ7TwXmqn2ALMiUKyF1I9bCjKw8pYTwhq0g5vq0YDBsBbrkPQzpkO+HLCEtbpaVA4BsBj+Q/mrM/ugqBP2WAuK56ur/J6WPV57KVom35kjtnGPqaNg73mWXJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rO0QMsyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rO0QMsyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943B4C32782;
	Fri, 23 Aug 2024 00:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371892;
	bh=xFNNsQWboymbRGTHO07M3xy+kyzbZgmondCLWi2RXlQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rO0QMsyUYH6nlTWJ99lb6mWkpB5X0V5P0NnJuSJgA+UxWsDnpNnBP7r/3swpgcw5i
	 y4mGXwU+2P5CO/tmLdZ6NbqlLamY02mbYphavdp9ynHbxfdp+7Z1jVj/6sDDujWgLy
	 9HvmBRbOx4fbvCxGCxR174RcYwxKp7vSG6BbvyO8oulgxaeXH/KVhOgJcYWVLvc8YH
	 lSMNLF1dKaeSv4DiwPGr3RKn36UI5PsCrY+gygwbJthhlhxsEWyDpC9Yqvr7e2ekdO
	 WvKppOBJZ9w0Y0J7ntayQ875g5WhMaxDRUhL032G8A4trl15EUzBFdzk/MVJf76x43
	 AeXLvHILD+HRQ==
Date: Thu, 22 Aug 2024 17:11:32 -0700
Subject: [PATCH 10/12] xfs: factor out a xfs_last_rt_bmblock helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086191.58604.6683754743526908512.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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
index 5a637166cc788..5bead4db164e9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -950,6 +950,23 @@ xfs_growfs_rt_bmblock(
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
@@ -1061,16 +1078,8 @@ xfs_growfs_rt(
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

