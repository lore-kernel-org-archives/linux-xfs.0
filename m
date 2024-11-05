Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDD918E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845920; cv=none; b=LfeWA5k8spLV/HFl2GSE1gamvgl41Hy/HiU+390vjdBSr2d9PqznrUNhGVQI3c/pyXTAVxJahwiVtuAihPvphjxdgBlA5Oo4AzrPLHJx2gTRdzDGyeOQNCDaKAgh8lyu2WBBBqoRSGEWXSbaBXXwk2nZU2wV7ssO+KQBaNvx3wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845920; c=relaxed/simple;
	bh=6gPCd9Jmuq8gyKFLwPLZN9HRZN0IGiOcoQGeu4VcV9Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6m5BnnpukMJtEq2pKxxvMXpqUdr9ifuPYFwHSyQ/NHosruQUOmiiVss9XkYWD3/zqvA1IxSen+UxdevrYxv/nXk15+BTWozUkDclxVLLWUyVg29EUM0+osYttGj+vJJLHU9TBLFTU11l8W5QiEl3wPjfUGSm2nuyS/Ge24Xq2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+etNa9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+etNa9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71E7C4CECF;
	Tue,  5 Nov 2024 22:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845919;
	bh=6gPCd9Jmuq8gyKFLwPLZN9HRZN0IGiOcoQGeu4VcV9Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a+etNa9M1iZ6Df2D+OVQ4soZmnNab5c/TmlERKWq1C031k6WO9kiEtqOMAe3hFcZM
	 bFSqtoKII4EKA5gIe6qH/9NKkpj7BwWjYbey1N3AoFlU6FrCQAVZpv//ZACu4YttUm
	 eVMOp6Y44w6m9Fll8VCLRd1dLx4zdR2k0AkA3vhzUMAi9XDJdwpFGUnvyPuKQjEQQW
	 nPoS9irVgrPKIbaon6CxD7JPHaLV8rzIpzqc0mPEfwt906tizdOt/iFq9taRDD79Qp
	 7w4TO3X9/NbhpFrnfwm0SHGCh355bcvnmkBsu3dAZxe3QO2YLOqz/8sSZ/7xeKcIIU
	 J3rSZSZWSDCqg==
Date: Tue, 05 Nov 2024 14:31:59 -0800
Subject: [PATCH 08/34] xfs: convert sick_map loops to use ARRAY_SIZE
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398320.1871887.14264737585437670359.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert these arrays to use ARRAY_SIZE insteead of requiring an empty
sentinel array element at the end.  This saves memory and would have
avoided a bug that worked its way into the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_health.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index e5663e2ac9b853..b0d0c6bd9fa29c 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -373,6 +373,9 @@ struct ioctl_sick_map {
 	unsigned int		ioctl_mask;
 };
 
+#define for_each_sick_map(map, m) \
+	for ((m) = (map); (m) < (map) + ARRAY_SIZE(map); (m)++)
+
 static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_COUNTERS,	XFS_FSOP_GEOM_SICK_COUNTERS},
 	{ XFS_SICK_FS_UQUOTA,	XFS_FSOP_GEOM_SICK_UQUOTA },
@@ -382,13 +385,11 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
 	{ XFS_SICK_FS_METADIR,	XFS_FSOP_GEOM_SICK_METADIR },
 	{ XFS_SICK_FS_METAPATH,	XFS_FSOP_GEOM_SICK_METAPATH },
-	{ 0, 0 },
 };
 
 static const struct ioctl_sick_map rt_map[] = {
 	{ XFS_SICK_RT_BITMAP,	XFS_FSOP_GEOM_SICK_RT_BITMAP },
 	{ XFS_SICK_RT_SUMMARY,	XFS_FSOP_GEOM_SICK_RT_SUMMARY },
-	{ 0, 0 },
 };
 
 static inline void
@@ -418,11 +419,11 @@ xfs_fsop_geom_health(
 	geo->checked = 0;
 
 	xfs_fs_measure_sickness(mp, &sick, &checked);
-	for (m = fs_map; m->sick_mask; m++)
+	for_each_sick_map(fs_map, m)
 		xfgeo_health_tick(geo, sick, checked, m);
 
 	xfs_rt_measure_sickness(mp, &sick, &checked);
-	for (m = rt_map; m->sick_mask; m++)
+	for_each_sick_map(rt_map, m)
 		xfgeo_health_tick(geo, sick, checked, m);
 }
 
@@ -438,7 +439,6 @@ static const struct ioctl_sick_map ag_map[] = {
 	{ XFS_SICK_AG_RMAPBT,	XFS_AG_GEOM_SICK_RMAPBT },
 	{ XFS_SICK_AG_REFCNTBT,	XFS_AG_GEOM_SICK_REFCNTBT },
 	{ XFS_SICK_AG_INODES,	XFS_AG_GEOM_SICK_INODES },
-	{ 0, 0 },
 };
 
 /* Fill out ag geometry health info. */
@@ -455,7 +455,7 @@ xfs_ag_geom_health(
 	ageo->ag_checked = 0;
 
 	xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
-	for (m = ag_map; m->sick_mask; m++) {
+	for_each_sick_map(ag_map, m) {
 		if (checked & m->sick_mask)
 			ageo->ag_checked |= m->ioctl_mask;
 		if (sick & m->sick_mask)
@@ -477,7 +477,6 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
-	{ 0, 0 },
 };
 
 /* Fill out bulkstat health info. */
@@ -494,7 +493,7 @@ xfs_bulkstat_health(
 	bs->bs_checked = 0;
 
 	xfs_inode_measure_sickness(ip, &sick, &checked);
-	for (m = ino_map; m->sick_mask; m++) {
+	for_each_sick_map(ino_map, m) {
 		if (checked & m->sick_mask)
 			bs->bs_checked |= m->ioctl_mask;
 		if (sick & m->sick_mask)

