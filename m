Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630AD33D8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372596; cv=none; b=PKp0+rVy414ggfPLq5b6x2vpOtnxiUOMafRiPXhDjTdKaZMCofouPzBp2LM5LaqKRaJDKvsy4xHooTexqPx78uiqYZoT7PVZ3h6g4bZi7iphQPHi30CtsNyh6ocOQMWnHB3RN8Mo+WRrrQ80WU7Dyk2nySvCkDQHvvh7mcRiO0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372596; c=relaxed/simple;
	bh=VW2SPhg0sYzaTSIjhoxv+aT+VDQVA002e0u20lDNIsw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ffg4YiE2EKCP5ky5bW2P2NdHB8N4FID19eplWnApEWq9bdGiWBSrGDmxjk8LHzJyMNkvV2PW0BRlGukY9S+Vc+G5SudQGqoYqC0hZ2BiSRigT8TL4ug+Fzl2/AMiezfZDRMW8/oidCcNDgsqv3ddSC/CT9h428/61wRmnKgK7Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9Pzynby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9Pzynby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CEAC32782;
	Fri, 23 Aug 2024 00:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372595;
	bh=VW2SPhg0sYzaTSIjhoxv+aT+VDQVA002e0u20lDNIsw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c9PzynbyDi0CUiuOFyxkx1OMOnhCwi9exmH4T7V3RLCR+Eh4Zmaqw0t73fJAlXUXx
	 OSyyii096QoMAaFmeDymNJV6im6gv8L1bKfQOyGe5ccjPj11/es3+bqZqBh6qX4qyv
	 cWRYVI7cjtcMokTkKjthmjTQTV6q2ithV0qJAqFl8OQjKtjEhUeg6jNipHIsJBPvUi
	 VEcg5XmjqkDQcDVbda8bjQpPsN9HpR/yZQ62RyDeomxJlyzaOtNqFQxOx3zKQHYtIW
	 CFz5SYVZFaj+3z0/isLbtzVn6QWsEAxvdFOaNR9mLiJr28Y9UI86eyktPixsPkG0qw
	 SM7gIN/qFQeHQ==
Date: Thu, 22 Aug 2024 17:23:15 -0700
Subject: [PATCH 08/26] xfs: convert sick_map loops to use ARRAY_SIZE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088657.60592.5339918682104748305.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Convert these arrays to use ARRAY_SIZE insteead of requiring an empty
sentinel array element at the end.  This saves memory and would have
avoided a bug that worked its way into the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_health.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 0bdbf6807bd29..cb43bd11dcac5 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -369,6 +369,9 @@ struct ioctl_sick_map {
 	unsigned int		ioctl_mask;
 };
 
+#define for_each_sick_map(map, m) \
+	for ((m) = (map); (m) < (map) + ARRAY_SIZE(map); (m)++)
+
 static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_COUNTERS,	XFS_FSOP_GEOM_SICK_COUNTERS},
 	{ XFS_SICK_FS_UQUOTA,	XFS_FSOP_GEOM_SICK_UQUOTA },
@@ -378,13 +381,11 @@ static const struct ioctl_sick_map fs_map[] = {
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
@@ -414,11 +415,11 @@ xfs_fsop_geom_health(
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
 
@@ -434,7 +435,6 @@ static const struct ioctl_sick_map ag_map[] = {
 	{ XFS_SICK_AG_RMAPBT,	XFS_AG_GEOM_SICK_RMAPBT },
 	{ XFS_SICK_AG_REFCNTBT,	XFS_AG_GEOM_SICK_REFCNTBT },
 	{ XFS_SICK_AG_INODES,	XFS_AG_GEOM_SICK_INODES },
-	{ 0, 0 },
 };
 
 /* Fill out ag geometry health info. */
@@ -451,7 +451,7 @@ xfs_ag_geom_health(
 	ageo->ag_checked = 0;
 
 	xfs_ag_measure_sickness(pag, &sick, &checked);
-	for (m = ag_map; m->sick_mask; m++) {
+	for_each_sick_map(ag_map, m) {
 		if (checked & m->sick_mask)
 			ageo->ag_checked |= m->ioctl_mask;
 		if (sick & m->sick_mask)
@@ -473,7 +473,6 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
-	{ 0, 0 },
 };
 
 /* Fill out bulkstat health info. */
@@ -490,7 +489,7 @@ xfs_bulkstat_health(
 	bs->bs_checked = 0;
 
 	xfs_inode_measure_sickness(ip, &sick, &checked);
-	for (m = ino_map; m->sick_mask; m++) {
+	for_each_sick_map(ino_map, m) {
 		if (checked & m->sick_mask)
 			bs->bs_checked |= m->ioctl_mask;
 		if (sick & m->sick_mask)

