Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92823C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881762; cv=none; b=iZCczjKPm9AlYVW8Zdf9hF3rzQJuTtiskxDdfn21vCu507YJdueXNfA0blH471ArxeBbm+bmrvVbRFthYCRfGBDI8eDjvxYa486fVu5Gzsr3PKU6UibYySCZ0qT7I2D3SF22NnNI7tIcqgxSMeFEl8CK3WAlbBQtcm7rcA6+8sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881762; c=relaxed/simple;
	bh=zbQ68HTqt/xaqmEWDaUXqXm7Ve2i2hY/rpeCTvNG/vk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYs3K9x7XK0nc6x4OcZHP+vaBfOHhYRjIhD9rlXuc07XuOfMy0UVmOZ+v4Ie5jisaI101qkx9E3zkisL9byYqs+ANvMOoeJ+nP1G4EPuIkVY0gq1tyojsmPYgT5Pf7lWeoS+gus1FU/THTGqtxLCqC4zeUHukmmi70fOc78Ogew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uXvAwuc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uXvAwuc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CB0C4CEDD;
	Thu,  6 Feb 2025 22:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881762;
	bh=zbQ68HTqt/xaqmEWDaUXqXm7Ve2i2hY/rpeCTvNG/vk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uXvAwuc1FIEBgFrNrOyv9GveMTpq2Dl2xPQYTKRP/xfQm1zxYddaE7sKXAGfMiM6Z
	 GLnTKvWN6NzEwnNHL/BJm32st6N/k2tBDd9ODJql2SmcMrA3WaLL588cNA0wBl4Jw4
	 Wyy2WWYaE9nc7YH14cwwdsk2vY5I4zn7lzFQCM/gMgMBK67YfAjC42PG2SnpaO9wjp
	 iMhruH2XrXMYtq+feIIHh6DqFZlUPONsjSPoJfK7yrHQ3vIhyhRy1fVcpo7M/ei4uh
	 3fBVAMiVr4nftD5kA0x9112T4EW3lNC13dE5CMuIfae03je/CZ83/3so2Hrls4QD3S
	 uZsSQ+Vt5xA/g==
Date: Thu, 06 Feb 2025 14:42:41 -0800
Subject: [PATCH 29/56] xfs: online repair of the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087236.2739176.1166976795253519190.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6a849bd81b69ccbda5b766cc700f0be86194e4d1

Repair the realtime rmap btree while mounted.  Similar to the regular
rmap btree repair code, we walk the data fork mappings of every realtime
file in the filesystem to collect reverse-mapping records in an xfarray.
Then we sort the xfarray, and use the btree bulk loader to create a new
rtrmap btree ondisk.  Finally, we swap the btree roots, and reap the old
blocks in the usual way.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree_staging.c |    1 +
 libxfs/xfs_rtrmap_btree.c  |    2 +-
 libxfs/xfs_rtrmap_btree.h  |    3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index b3afb4a142a5e0..d82665ef78398e 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -134,6 +134,7 @@ xfs_btree_stage_ifakeroot(
 	cur->bc_ino.ifake = ifake;
 	cur->bc_nlevels = ifake->if_levels;
 	cur->bc_ino.forksize = ifake->if_fork_size;
+	cur->bc_ino.whichfork = XFS_STAGING_FORK;
 	cur->bc_flags |= XFS_BTREE_STAGING;
 }
 
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 387c9f17118d52..ac51e736e7e489 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -658,7 +658,7 @@ xfs_rtrmapbt_compute_maxlevels(
 }
 
 /* Calculate the rtrmap btree size for some records. */
-static unsigned long long
+unsigned long long
 xfs_rtrmapbt_calc_size(
 	struct xfs_mount	*mp,
 	unsigned long long	len)
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index bf73460be274d1..ad76ac7938b602 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -198,4 +198,7 @@ int xfs_rtrmapbt_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
 int xfs_rtrmapbt_init_rtsb(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
 		struct xfs_trans *tp);
 
+unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */

