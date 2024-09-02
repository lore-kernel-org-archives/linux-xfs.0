Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877D19CC0A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301482; cv=none; b=MiT/uY7431IhTfqRzOo0ipLuYsPNa4Y5KYCpyhZzUOnOMGrkmddJm2GtYFrOruiEL0N40nDAV/ec0gTE/u1anF/P86+drcuNEvxuSdWpcTr01J6n0OdYgtNgIOPPBSnb2c7cAW2qy1Pp/CdR7xC1oLkvIqD3FGK/eW/hZA+hl30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301482; c=relaxed/simple;
	bh=MKOfmd3IPxxxV40cPS7kGn0Id5rJrkaGf9nI2zhSRKU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcPxLqXtFs0hQrd4Z4fsxncihcmDgu7zXiTdedhhjIB5MjuPDo8XwxTKAvNofX7E61X3fr63EqOZrfYxIvtWn7fDfhhZrSkcOufdpuU7LraJKVI+JUzoT1Lo8+whUmipEe9Vg+qQygSReNdHtZRd15T72aNuz+9dmcKsCfG+vAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JULRdaGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JULRdaGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE6FC4CEC2;
	Mon,  2 Sep 2024 18:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301481;
	bh=MKOfmd3IPxxxV40cPS7kGn0Id5rJrkaGf9nI2zhSRKU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JULRdaGwnG9NyeNn4t+XYB6jYKMUwiLTkbicD8c6VGLODqOC7OF80pu6zcGnroCwY
	 fKdGuIAHY/i2JbN1PdGSP8J2CjcWztDCaOibT6V9tNzkIvJMBHf6izx2a43dwdOPKY
	 hI4TACMHV2Q0y2XFjFcUoOYNx4w1RH5lRhaY9luVL5GuyXNGhJW5r0Un+xWy1sdCBR
	 l+CG2EK3JxE9+u+4Cs9ZwLEw9toH/ug88ro10Sxoi2p0CRJVJuIvaO56/Xtpl3wNgh
	 TV68UCBGa4v0VmePl1g0+k8nHz8aKrKbZlRSdfyNSxQbIxFs5Yu4UdG40KjZH1CekW
	 OKG/4Olr/aA6w==
Date: Mon, 02 Sep 2024 11:24:41 -0700
Subject: [PATCH 03/12] xfs: make the RT rsum_cache mandatory
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105765.3325146.266426096031623491.stgit@frogsfrogsfrogs>
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

Currently the RT mount code simply ignores an allocation failure for the
rsum_cache.  The code mostly works fine with it, but not having it leads
to nasty corner cases in the growfs code that we don't really handle
well.  Switch to failing the mount if we can't allocate the memory, the
file system would not exactly be useful in such a constrained environment
to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d28395abdd02..26eab1b408c8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -767,21 +767,20 @@ xfs_growfs_rt_alloc(
 	return error;
 }
 
-static void
+static int
 xfs_alloc_rsum_cache(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_extlen_t	rbmblocks)	/* number of rt bitmap blocks */
+	struct xfs_mount	*mp,
+	xfs_extlen_t		rbmblocks)
 {
 	/*
 	 * The rsum cache is initialized to the maximum value, which is
 	 * trivially an upper bound on the maximum level with any free extents.
-	 * We can continue without the cache if it couldn't be allocated.
 	 */
 	mp->m_rsum_cache = kvmalloc(rbmblocks, GFP_KERNEL);
-	if (mp->m_rsum_cache)
-		memset(mp->m_rsum_cache, -1, rbmblocks);
-	else
-		xfs_warn(mp, "could not allocate realtime summary cache");
+	if (!mp->m_rsum_cache)
+		return -ENOMEM;
+	memset(mp->m_rsum_cache, -1, rbmblocks);
+	return 0;
 }
 
 /*
@@ -939,8 +938,11 @@ xfs_growfs_rt(
 		goto out_unlock;
 
 	rsum_cache = mp->m_rsum_cache;
-	if (nrbmblocks != sbp->sb_rbmblocks)
-		xfs_alloc_rsum_cache(mp, nrbmblocks);
+	if (nrbmblocks != sbp->sb_rbmblocks) {
+		error = xfs_alloc_rsum_cache(mp, nrbmblocks);
+		if (error)
+			goto out_unlock;
+	}
 
 	/*
 	 * Allocate a new (fake) mount/sb.
@@ -1268,7 +1270,9 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
-	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
+	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
+	if (error)
+		goto out_rele_summary;
 	return 0;
 
 out_rele_summary:

