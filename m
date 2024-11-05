Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310121DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845342; cv=none; b=EFBNfvLYQVr8Rzn3vZ6cp+Rrcl2VDSbLq2ul4lFTUgZ49UuwG2/SlnHaj5lk3bwS6zt4vDzolDIl4uHOr31NV4ijM8t2g4ASx6+tcQJzTOLuUNN9Dtw42LYQpMCeYGnCTZ6gVJnn87lJofhD7Sc5bl1Xu4k7yMqF5auIocQD9w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845342; c=relaxed/simple;
	bh=N4y74Ug4DsGm0dXdUNeQeFwMrmoGiIHFpWb+GL2ZkNg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X+Chj8VM6MoKzUWkO7E9WOUSGE1vt0YVlq/JPZ8TjDM6Cp6190SjPkqYsq1vilm3gDaKvsJOPyZrwlp24X58bmO03kzaCEvocBIW65wCST9leuI0iSCpsR5zTjhBU3j2NWmJSzSsj0i4KsynrALLyNY7o1y+E0Nf5zStuAWm00U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blIPsKSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blIPsKSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8A5C4CECF;
	Tue,  5 Nov 2024 22:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845342;
	bh=N4y74Ug4DsGm0dXdUNeQeFwMrmoGiIHFpWb+GL2ZkNg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=blIPsKSRoX5XXToE2k5vNGb4GMaFqd/nVXfRlFfQCtnNrtiz7dNgWrM0QquIKusHj
	 bzXcenYJJ8Mw963xa4BuvthPpGhbdAAonuLBBmqd8P7n7LNesJVrbDjJziJy1bDYSE
	 GBAChf9tQOAYdfu2y/MlFAi/Fy7jrtOAHPdqiTldpZQnZvc52IaT/CQKao8FEfS9C7
	 pi04V4bBNnWfBhLUltTAcWz0cKVp+MzfRTz9cDnOF/MunaTV8cMn8xB7yotw21uQ/H
	 FnaOlEGqsgyMVGrgdhaDvphNDb5eWKHiYW47uKUx2C/nKKWhFiyissxpxw+xcbmkDb
	 dJ9sk9tsMpZdQ==
Date: Tue, 05 Nov 2024 14:22:21 -0800
Subject: [PATCH 22/28] xfs: fix di_metatype field of inodes that won't load
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396397.1870066.1775245566414208325.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the di_metatype field is at least set plausibly so that
later scrubbers could set the real type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode.c        |    9 +++++++--
 fs/xfs/scrub/inode_repair.c |    6 +++++-
 2 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index ac5c5641653392..25ee66e7649d40 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -443,8 +443,13 @@ xchk_dinode(
 		break;
 	case 2:
 	case 3:
-		if (!xfs_dinode_is_metadir(dip) && dip->di_metatype)
-			xchk_ino_set_corrupt(sc, ino);
+		if (xfs_dinode_is_metadir(dip)) {
+			if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+				xchk_ino_set_corrupt(sc, ino);
+		} else {
+			if (dip->di_metatype != 0)
+				xchk_ino_set_corrupt(sc, ino);
+		}
 
 		if (dip->di_mode == 0 && sc->ip)
 			xchk_ino_set_corrupt(sc, ino);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index eaa1e1afe3a4d0..5a58ddd27bd2f5 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -526,8 +526,12 @@ xrep_dinode_nlinks(
 		return;
 	}
 
-	if (!xfs_dinode_is_metadir(dip))
+	if (xfs_dinode_is_metadir(dip)) {
+		if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+			dip->di_metatype = cpu_to_be16(XFS_METAFILE_UNKNOWN);
+	} else {
 		dip->di_metatype = 0;
+	}
 }
 
 /* Fix any conflicting flags that the verifiers complain about. */

