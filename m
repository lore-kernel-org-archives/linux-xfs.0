Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DC99441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882987; cv=none; b=u0UEu4/aRvAT9NYTOJU1XPckESBuTvNm+MKK95zPRLCbS/AEGuPTqXOezcvSap84+cqbWeigtgvLRRERPN/a8dbdnz5B4MA8rRVNa4GDn1W8fzHBvfRssiAj6ioI6Ky6OPgj34gTibr1V21mK8SvEMvggRWIhCNK/o0xh4GuLsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882987; c=relaxed/simple;
	bh=ri2ifs8s1+vUD8EK0cABpzG+bi+ir42D0++/MjWroCw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AL6TQaJDNVvdai1sR9apFZqumiLn1OPZfuIUctum1iRDaRDLf7rIDZy6Gz77q8nJST/P7R6Im97gyvPqZQ7rWo8JRO7wICUNN0K/heUd3ClVhBr/zK2NlP1wb3eLLh5xaO2bPrTKOc3SkWveWleKWuZ2xq2J1OZrhigGV+7yV/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvXgq+xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvXgq+xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13022C116B1;
	Tue,  2 Jul 2024 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882986;
	bh=ri2ifs8s1+vUD8EK0cABpzG+bi+ir42D0++/MjWroCw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RvXgq+xdWxDjXRclQvDv+BvMxWa+EbeEP5ITN3px9GaQMidU9ydyNwvtPoAzIaYKh
	 ClaTm99sjkih3vJUGSyWApd3wHDSiKzQV2HzZuyDL1+AWWj2hSOjCBNo7eFlQ7DJ05
	 Z8xHBCkL+vvGgoYqD7Vl+BwqowRovbq2OHWSU/hOaxvMwTna7k7RaSkcNtkEIeeKbn
	 i32PVOEDKM6tStDW0YdlFeq+OEg51j9ywuyvsEKOt1LarKPdnZQsxJQfPErN0xaSS7
	 kXU1AwCj90FQmhRSX76eWS7GFb1A0bZ2RNePOhMLXjx74IT/xcj5dqDH5Pk7/e4BaX
	 eWLsTIJUIRDqA==
Date: Mon, 01 Jul 2024 18:16:25 -0700
Subject: [PATCH 22/24] libxfs: create new files with attr forks if necessary
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121402.2009260.4605471859392366056.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

Create new files with attr forks if they're going to have parent
pointers.  In the next patch we'll fix mkfs to use the same parent
creation functions as the kernel, so we're going to need this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    4 ++++
 libxfs/util.c |   19 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 95de1e6d1d4f..90a539e04161 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -602,14 +602,18 @@ void
 libxfs_compute_all_maxlevels(
 	struct xfs_mount	*mp)
 {
+	struct xfs_ino_geometry *igeo = M_IGEO(mp);
+
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
 	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
+
 }
 
 /*
diff --git a/libxfs/util.c b/libxfs/util.c
index 74eea0fcbe07..373749457cc1 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -274,11 +274,12 @@ libxfs_init_new_inode(
 	struct fsxattr		*fsx,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
 	int			error;
 
-	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
+	error = libxfs_iget(mp, tp, ino, XFS_IGET_CREATE, &ip);
 	if (error != 0)
 		return error;
 	ASSERT(ip != NULL);
@@ -340,6 +341,22 @@ libxfs_init_new_inode(
 		ASSERT(0);
 	}
 
+	/*
+	 * If we're going to set a parent pointer on this file, we need to
+	 * create an attr fork to receive that parent pointer.
+	 */
+	if (pip && xfs_has_parent(mp)) {
+		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
+		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
+
+		if (!xfs_has_attr(mp)) {
+			spin_lock(&mp->m_sb_lock);
+			xfs_add_attr(mp);
+			spin_unlock(&mp->m_sb_lock);
+			xfs_log_sb(tp);
+		}
+	}
+
 	/*
 	 * Log the new values stuffed into the inode.
 	 */

