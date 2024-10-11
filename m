Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3008F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608626; cv=none; b=F3S3rVSap0K9hudC1wkLdq2+CyTKuRvQvoB8AVRze966LvzZ0tlH6gsWxPRl9Wp0MnNSkn+ifPYVld8FHqPwTvmlvnafCpT4dTkVJ5n/PhF0lk1YCW/8jKSx6Dw26fQLvfjcdyhxR3Ugc2t5UMQp3aqyJVXopu2+2sutEtrZ+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608626; c=relaxed/simple;
	bh=mI5ZzXJuI+k6drJ9hT9Vh45ew3Sw3u2WWEiNsMOSXoo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uhj871lDlv44viGZo/i1JEzMFxZZ5ezhdlmw5N8Sg6b8Z1z2Pt2kt0uFgobhKExddiPWg4okSPkzad0Sdj5I4egHDZDATQI3Y+Ua/D9tMTCzhq7nwBSe9NXuy7RMPyyWsdUhpBEC1x9tPMzTrOb64ifAk/gK9lZz2vzrnBuzGIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TG4Rnaf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TG4Rnaf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7ECC4CEC5;
	Fri, 11 Oct 2024 01:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608626;
	bh=mI5ZzXJuI+k6drJ9hT9Vh45ew3Sw3u2WWEiNsMOSXoo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TG4Rnaf2l8GnmVcMllk8exbFBf3OrrM9o1rYWUj5h+S9bgSdqeEG0GSXRZAjMBS1m
	 2uMetkNQfmqe9Krkpmlcddrb3YaO5LHcZlGtMVwqQVKEljhknTX5ovfVj0ia9+Ftlf
	 XKb5fI+3VX4XuUVPx72KWThTfFkvg1FM5f8OASGGJqUdjZI2aMO0LmtCKQGTed71E9
	 TR75Orv1kva8zMG1sftgfSACi0oUnyhwlGQ3Eq0YxFoo4Xf9OdlP3radWHRrmpV5N+
	 dDY3nrnN1Pa5rJdmdE2xm1pEF+jJFlsluzeCc9andy5apXZTAooEnMrz6zDpVcjOdu
	 BSL/KnCB796oQ==
Date: Thu, 10 Oct 2024 18:03:46 -0700
Subject: [PATCH 08/36] xfs: convert sick_map loops to use ARRAY_SIZE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644377.4178701.97435701073037596.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_health.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b2272c7f737e3d..f38d0e1495e84a 100644
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
 
 	xfs_group_measure_sickness(&pag->pag_group, &sick, &checked);
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

