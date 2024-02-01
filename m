Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8BD43AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816459; cv=none; b=PX/uWp7rkxZLuiXNIWthLtq1L54jy+YKxOpgHw/aF3wfAkCfvTMP0IbZ5cFRHVWbUsHU6jLjNPtFJ+72az6I8K3hEBdJBR+4TvYXIG7cBnyRr+qeE2f/dBXOVjyMk3GpkK5cvp2oBH9Sjuz7uDWUWwx7NDTAf3GwwSrwOv6qslo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816459; c=relaxed/simple;
	bh=WDueHFLXbj455d34lWxwD2gyUMIBJTMOClc1945cxCc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kV+aaqzc278h0m+OZftL1ztRnjJmz8FYlc3P2E2SQZaEjdHFysMCo3HpdyjMGpjb+XDXQjjwwJJbEo2PHaUIp7bGne9KW2HwVyo+rT+NSDDAdqmpnvdpBFYfd0xe0/o8yUhukXaJdR8ReZDJHrrHGK9F2QopfY4uS6/LUYQivEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlSg62ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlSg62ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF8CC433F1;
	Thu,  1 Feb 2024 19:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816459;
	bh=WDueHFLXbj455d34lWxwD2gyUMIBJTMOClc1945cxCc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LlSg62urxBDpRqwLQmflzMDqVjDyUz7LwEmTt5c43JkHwW66swAKDhlven//9xoXa
	 2Jyns1ssCgLhjxjMLqUZA0jR1HfBWJpY4dx8vmEzntZZIWqN/+dVyqpnVPIfAOkSou
	 RIJOIU4gI0MhwIexioHtffzHVdf5k1ifIf281hGHjcuvH6Uc4Z77k+cmBF3I2/1+UA
	 WVqJwQE2/Bqs36f3uGhSUAlUQrZ6/vvXMEy/6MKyYhbI2xiLyaXgMV/DPZXj+HcOGz
	 IdYNs5sj7RgyGMvEh6Ei2UwK/71HpkxpmcjiSf/aPB2AMh+GpyQ2VC3NxbDL4Ih1aC
	 LpgnmWFjyhIEg==
Date: Thu, 01 Feb 2024 11:40:58 -0800
Subject: [PATCH 05/23] xfs: fix imprecise logic in
 xchk_btree_check_block_owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334018.1604831.5903341339229401614.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Christoph got confused by the init_sa logic in this function, and upon
reviewing it, I discovered that the code is imprecise.  What we want to
do here is check that there is an ownership record in the rmap btree for
the AG that contains a btree block.

For an inode-rooted btree (e.g. the bmbt) the per-AG btree cursors have
not been initialized because inode btrees can span multiple AGs.
Therefore, we must initialize the per-AG btree cursors in sc->sa before
proceeding.  That is what init_sa controls, and hence the logic should
be gated on XFS_BTREE_ROOT_IN_INODE, not XFS_BTREE_LONG_PTRS.

In practice, ROOT_IN_INODE and LONG_PTRS are coincident so this hasn't
mattered.  However, we're about to refactor both of those flags into
separate btree_ops fields so we want this the logic to make sense
afterwards.

Fixes: 858333dcf021a ("xfs: check btree block ownership with bnobt/rmapbt when scrubbing btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 1935b9ce1885c..c3a9f33e5a8d1 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -385,7 +385,12 @@ xchk_btree_check_block_owner(
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
-	init_sa = bs->cur->bc_flags & XFS_BTREE_LONG_PTRS;
+	/*
+	 * If the btree being examined is not itself a per-AG btree, initialize
+	 * sc->sa so that we can check for the presence of an ownership record
+	 * in the rmap btree for the AG containing the block.
+	 */
+	init_sa = bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE;
 	if (init_sa) {
 		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
 		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,

