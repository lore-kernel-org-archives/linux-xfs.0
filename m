Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951641DED44
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191522; cv=none; b=i3LMClRK/eY3TUkHoHRZOvikun+Sv/LJPjrEek7CU63qLIyHcqqFY32JmpbB9PQsyaSWjDOxMv0ufuAAtb4e+jvm+ezoAQdlOqcxx3eoEXyPNMCQstbgl8Urh/hK7mJaISVlTLaeYiRL3nV2U4ex++gmte9MaNV6zMO3G4HjRw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191522; c=relaxed/simple;
	bh=N4y74Ug4DsGm0dXdUNeQeFwMrmoGiIHFpWb+GL2ZkNg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ihd3u/cBBEC7tuEIwRZcd9s00/eawtUOpSiD8jUWZjM6e3CW/f3HWfp/PB+jMFZvcLbqMpIplP99Mq0NhJyffexH6It9+Ow2rPOyJ/5IxGIeS3gu34HcWDohEFuzQNowlJ8nRR3WQyiP4T1frh47RXVLu8LSgGsQG9pokcN/Asg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0meeSbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0meeSbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C0CC4CEC3;
	Thu, 17 Oct 2024 18:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191522;
	bh=N4y74Ug4DsGm0dXdUNeQeFwMrmoGiIHFpWb+GL2ZkNg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J0meeSblQR2N0yKDmS4awWgrF8HXTutRQUW5PS1CbaD+xY/hlySIKlPcy6hBY+q8X
	 Jze9c3FOJAmzCPtN3SYucd9kbnWgWGckxYLaXvDjZh1FeT/sp/UhKkb1TnvcbXj3Mv
	 GtH7oRqZGbiNAWeKafxZV2sbnrcdtadOOQBSrkb+hSY/dnnna8iyjDLWUzWCpQO5TV
	 DRy8RMeOYYV9D2di9il6XLGY6QMD8ye3QARqMfijF5AS7mjHdeu3LWK9M7X1LJEXRo
	 OXyRZxkIcIOlHvgK3xPJ0mPcG3J1ToXoaqT2fTcapCqCrcfwVw8WEoujIv5nHTZVhb
	 M4dVzlGDW0KGw==
Date: Thu, 17 Oct 2024 11:58:42 -0700
Subject: [PATCH 23/29] xfs: fix di_metatype field of inodes that won't load
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069847.3451313.2995475781072114353.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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

