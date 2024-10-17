Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260EE1E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191916; cv=none; b=TxBKGLVzWlq2bpFckC/iTtqmwPzBl4Zcm3vznSbSjCOIIaLvUgoe94WHKtevhNTwLgFfT+VeAq0UR/Fv33ddcXFtecWk/ry/u2rHyIvhQ6Hr9S9BvABACu9ADa6WR6UsczzxpEjSfqXTuwnPj76AKyw7AY8wPmdmI+ymc14asOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191916; c=relaxed/simple;
	bh=6gPCd9Jmuq8gyKFLwPLZN9HRZN0IGiOcoQGeu4VcV9Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xorw67O1XQkc2lMVm0gtOUDzjZ9RR64MsvwGYBpOI6CUUqst+l1dEKdfGqno/Jqq5PfA/sVSHDGjEyVmQ0YP0sbtW+kF2NDKfhtgPFIEZ7/XwZrJ2Sk3/3wkItfst0hA1eUmWuhgTqJ7AxfkklXc+1MsGhSRWrmmNcZOjPCypR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vHW7+Jl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vHW7+Jl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC40C4CEC3;
	Thu, 17 Oct 2024 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191915;
	bh=6gPCd9Jmuq8gyKFLwPLZN9HRZN0IGiOcoQGeu4VcV9Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vHW7+Jl4emwqpFx9siLI02rj/AJMGPIZSr/kJv9A3/iReSkwm9PWwF+mDBzPlEUdY
	 Ic1ECLr4eKSAIQWe1p5arR6t9i3v4u7rUpYcC0bDa0jeNl7R8V6p1bC73M8QsEMUK5
	 KDEhtpfowFByrvbOM8bazxaL1JILKv2rkiVezDUlv/LHVbaG2OxaW+3QKiphbyXfe1
	 7k98B4Lm20S88kHFuPtgR6XoD2DSL4OCGQpCiGNKX4hFC6F5GeI2vxISNq8F7GfaO7
	 3y/S205NCI/rVhA7DA4kPxmsyFEeChruDbjhiyILX3h9C+ql4lTVl/p0993gzVKs0Y
	 biHgM7WgtFwCg==
Date: Thu, 17 Oct 2024 12:05:15 -0700
Subject: [PATCH 08/34] xfs: convert sick_map loops to use ARRAY_SIZE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071804.3453179.15009254087430418401.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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

