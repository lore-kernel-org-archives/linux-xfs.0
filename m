Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DD88F5B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302676; cv=none; b=BwLHaYDl4wXo5LoCUMrLz1FTnv18goIsGCMHGGUjMKiAw0GgrHfZS4+t9K37zhV5AP4q6bC98yedYgFmy0pYNqZpvfGw/dYDE4j5k80pqtLoVAUZ4XVn5lWIQ1fMLSTuBTgMlV0ZKS1a/ZtHNg8tcrz15e085eVdERKsumDQEGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302676; c=relaxed/simple;
	bh=osdPGj/N7tTFM4tAjB2KxAXbdWPPkAXD26hXkuPye5g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOstZ/RrF060NQMJ/xc3zG/tVOWmBCGF6lvN0OA7JqvmvlDYJJfdWrYerdntNLkdnRM+keZoXZdf00+HpPkNVafWRgVMihXG7ksi+vZHLTGQcRn6Mb1RAM1jLNbZRSo7ukdjkXusVP4D5vIw06cstxT0SPcI+hVS8ORM3vg7qCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0WAXVJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0WAXVJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CC1C32786;
	Tue, 30 Jul 2024 01:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302676;
	bh=osdPGj/N7tTFM4tAjB2KxAXbdWPPkAXD26hXkuPye5g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i0WAXVJVIsMJQYZqev9y6Y1ienWtWzq+PftokHzSMsKOK9auEYDF9P6H8ctf+y/Dd
	 Bs5W2R3UUiKb9oSDe+pSUPNfrcqsDIaYnG6nsthIrEoABTG2TNCtUV5Scftt/DhWfO
	 aeArKk0FCujsfgerWaufP8HwjN1ucmAHHHWczZynhSP/xdN0KGq5Wc8e2u8MitaisT
	 TaZANPjh/mnSXnUN5gh6mdOOdRdSA5LGeaVNufhkQWKgkHkxJdU8VejlJbZAxKMD/I
	 M7gnOcRinFw/pyrSXueGykjRYbq5j3d7pWbNFgpWv4s94d5sbQFtCCTN9YlnUiTO5e
	 i2iv4R9M2RSLA==
Date: Mon, 29 Jul 2024 18:24:35 -0700
Subject: [PATCH 22/24] libxfs: create new files with attr forks if necessary
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850805.1350924.11137344337326390148.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c |    4 ++++
 libxfs/util.c |   19 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 95de1e6d1..90a539e04 100644
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
index 74eea0fcb..373749457 100644
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

