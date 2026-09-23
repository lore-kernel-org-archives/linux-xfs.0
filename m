Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851E131B80D;
	Wed, 23 Sep 2026 06:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143324; cv=none; b=F5J/ZRvCGsXUfVKJm3HJRFyxEx7yzFHDLwMigY6ybO3K56vNjfeG/BSw7KFmd+qNL3QaiOg+M66BG0wjYvlbstLMLCmHPFVHZh6920g17qpM/5nhj2vRiCHGNkM1JNJGCJMRc3tTK8rLS5F8IsTk82iw3GfNoTuoowqM8p4pH78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143324; c=relaxed/simple;
	bh=f6jRifPWVXyoaotfjMYfC0/g8wO8hQsErIEZp8jdoNw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fxPstCDkjaYm4+h+rjFx8jEtDJiSivKsIFDtZPiqazWC+jd2UX75sfSyTh3RkNtsDspK1Cma4naejY3nO/0PZ9ZBgtNi00V9S9tG6tdFMbUVUxyyRmXP03bKcoX+0/HT374t7ENZjCBP2UcdEp2bAath7SXEeZBq4o9DY8LDfY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d93BAOKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d93BAOKd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D17D1F000FF;
	Wed, 23 Sep 2026 06:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143323;
	bh=vwkEqZvYz5r6sB95nAdx5WBsyPiMtBqSDsIvBcTNSJA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=d93BAOKd+0OHfxZz0+kqix0P4ZtESZHseZ+SSoXhqNH3VJzU0ij+7KONQzVC1QfCf
	 3C01EDzYE3C4975c+aiVu5/XO/UhuKMfODrdFPItot887Diid1jFj4idclrgVJS1kr
	 hJNFfhcwlq6dvoN5XTBDiKWdYRpX9aUfF/blER8d9utyCuMhbKv6traN1tfZWMBVz2
	 yycOGt1z0ZLLr3e2Q2hvoZNcp2oSr2WUugwh25IuEi2KoeQCh9K1ItzOus6YdP9756
	 Y0r3Y3KgUyzftQWScE92CmdUN7A99NVIvkBXThoysH0FLvPCUN/TraVb+kO1yaJIxo
	 T6CLCjSgYjwVA==
Date: Tue, 22 Sep 2026 23:02:02 -0700
Subject: [PATCH 05/12] xfs: fix inode btree repair when a cluster is larger
 than a chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159650.1875436.8215876643273751378.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that on filesystems where an inode cluster buffer is
larger than an inode chunk, we can run through the loop body in
xrep_ibt_process_cluster more than once, and the number of inodes that
we pass to xrep_ibt_cluster_record is incorrectly large.  In this case
we can run right off the end of the buffer.  Fix this by moving the
nr_inodes computation inside the loop.

Note that this is only likely to happen on filesystems with (say) 512b
inodes and 64k fsblocks.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: dbfbf3bdf639a2 ("xfs: repair inode btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/ialloc_repair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 46b1c8ac5543fb..43846b3bbf4ed4 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -293,12 +293,8 @@ xrep_ibt_process_cluster(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_agino_t		cluster_ag_base;
 	xfs_agino_t		irec_index;
-	unsigned int		nr_inodes;
 	int			error;
 
-	nr_inodes = min_t(unsigned int, igeo->inodes_per_cluster,
-			XFS_INODES_PER_CHUNK);
-
 	/*
 	 * Grab the inode cluster buffer.  This is safe to do with a broken
 	 * inobt because imap_to_bp directly maps the buffer without touching
@@ -317,6 +313,10 @@ xrep_ibt_process_cluster(
 	for (irec_index = 0;
 	     irec_index < igeo->inodes_per_cluster;
 	     irec_index += XFS_INODES_PER_CHUNK) {
+		unsigned int	nr_inodes =
+			min_t(unsigned int, XFS_INODES_PER_CHUNK,
+					igeo->inodes_per_cluster - irec_index);
+
 		error = xrep_ibt_cluster_record(ri,
 				cluster_ag_base + irec_index, cluster_bp,
 				nr_inodes);

