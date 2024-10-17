Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D182621BAF3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192106; cv=none; b=Bc5B3/cCRogjJ307Zp7rKBZc/nCzO156bBj/rVTRtepZd8ddv6xPxptIjVZGhhN5vm6Xn6etS0iRx2Gk2DloAg2veeAnRF7Urik7M8BOmr4TTIcXDWbh7JRww2EWSuFiUlBO+F5+mc4FI1osfPWON5Ce4VOfFNdJVwKxNCXA7fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192106; c=relaxed/simple;
	bh=ICwET0+B/TMK4Uuaz63TV3TNGsd0X2v+DEMH0t9wmtA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EnAKUIVMP6dkwLU22YrOSyip9bJXZcw3E3234/9TOD51aEfb9C3DzsC33B/WOplzbxJwwnOmw5fbpZoQdZdIsEIegCoIPr2qMwPdTUaLiLVsht8SS1EAUmbTJ/BnCPUzFnrm0wWKIjWhlPVCkY9S73HETBArwF18w8Uall4oQ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnXK5jR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnXK5jR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57458C4CEC3;
	Thu, 17 Oct 2024 19:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192106;
	bh=ICwET0+B/TMK4Uuaz63TV3TNGsd0X2v+DEMH0t9wmtA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CnXK5jR4umZn5TMYA1/P/n2vg9jbZnA+PRFcggbWorqTR9Ckr45aj/Is6Pgr1/5+f
	 bjV5GH2EWxqgDviQr7q1eF3ZP2NM6Z1U8+N8hY8bR71+AjeSPFDD+hGKum0+Hy40Gk
	 vGc3TMoN7/0XXU3/aSymwYT4ELEccmfbh+ykc5GW7D6VY1RBEodNY4VHMVlZQTuxl2
	 4L6+CsjGZkFbWB7YKqKhn7lWq3Ut3SmWNr/5fbvAgS1UvM+4O8k2b96+qe2SM6YCRN
	 Cg4ROOIUmLjEOuoMb8DszLf9dBSNFjpOnfnWgBnCInNMBTbFUkp26K0l1O8Fs5SjbL
	 0pBX3QgCQAYCw==
Date: Thu, 17 Oct 2024 12:08:25 -0700
Subject: [PATCH 26/34] xfs: mask off the rtbitmap and summary inodes when
 metadir in use
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072118.3453179.14385122365574800490.stgit@frogsfrogsfrogs>
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

Set the rtbitmap and summary file inumbers to NULLFSINO in the
superblock and make sure they're zeroed whenever we write the superblock
to disk, to mimic mkfs behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index c55ccecaccbda4..1af7029753ea15 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -655,6 +655,14 @@ xfs_validate_sb_common(
 void
 xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 {
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
+		sbp->sb_uquotino = NULLFSINO;
+		sbp->sb_gquotino = NULLFSINO;
+		sbp->sb_pquotino = NULLFSINO;
+		return;
+	}
+
 	/*
 	 * older mkfs doesn't initialize quota inodes to NULLFSINO. This
 	 * leads to in-core values having two different values for a quota
@@ -783,6 +791,8 @@ __xfs_sb_from_disk(
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
 		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
 		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
 	} else {
 		to->sb_metadirino = NULLFSINO;
 		to->sb_rgcount = 1;
@@ -805,6 +815,14 @@ xfs_sb_quota_to_disk(
 {
 	uint16_t	qflags = from->sb_qflags;
 
+	if (xfs_sb_is_v5(from) &&
+	    (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
+		to->sb_uquotino = cpu_to_be64(0);
+		to->sb_gquotino = cpu_to_be64(0);
+		to->sb_pquotino = cpu_to_be64(0);
+		return;
+	}
+
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
 
 	/*
@@ -940,6 +958,8 @@ xfs_sb_to_disk(
 		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
 		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
 		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
+		to->sb_rbmino = cpu_to_be64(0);
+		to->sb_rsumino = cpu_to_be64(0);
 	}
 }
 

