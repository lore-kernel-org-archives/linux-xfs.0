Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AE31D6DAD
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991578; cv=none; b=ZquBeX78rimTHMqYa8pVCmMzBlGPFa/5thxYOBT2IA+ym0kj1fl1DoPRxyLGS0e8ssF0T4rv+vRSa18k8Jj90CXft9GBU274LB6wsDc28J1SiOmykuFxytbCw0y1eGx4cw3d9WL1l5Z9hZ19PZbbd07bOQShpzdNz752UBcfZO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991578; c=relaxed/simple;
	bh=tENxhF4cNRbyI9xjwZ4UWqk4F+jiesZyG1xwOJR2Y4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JV5F0FO4rWy0dNm+ZlbaOHxWovevJw7QiyQcrB+Hi7gQztc3cEiFm0L0TxVLh+dw4gZ9N53LZcJpYDsWDjRmKM+4GAHOuzEJsaziRhPAFHtJ42jb5xSERjF6BQlUhO0XjC2yoJbkwrQP/hSRP8QAgOB7DiOrtwsRZ/sWvWWID4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUFKy5yP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUFKy5yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DA3C4CED3;
	Mon, 23 Dec 2024 22:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991578;
	bh=tENxhF4cNRbyI9xjwZ4UWqk4F+jiesZyG1xwOJR2Y4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZUFKy5yPEgpMOMfTiIiarpNlfNG+gK2hYrYFvX/mbv5Ix94vrMEN3w2ErKtbSAcXl
	 Ri239edPszMNHHdfSQPZfCzItzfbMRLoycarp+v0uKXR85/c4MrV+4LS2NbR1idMH5
	 dr3k5mlPvQcm5L5U1dRsePe8J9cPuHOBxoCBYLyWdZFgDd4joJKIV75uJ3tEeeWFH+
	 jFl/0EDlQyq5w1R/RQ8/g2hmhIuya4Tol0+hiWUCwzdW8oXTPzx7QNYgp3zgv3Fe6W
	 1T1J5sEPljlJ/ZRgVziZ72fIXT2D7kHJ9OMhwHNag74eTvNQ16euFGtYiG43wN/8vh
	 7ZqZ/AN6usHkQ==
Date: Mon, 23 Dec 2024 14:06:18 -0800
Subject: [PATCH 31/52] xfs: mask off the rtbitmap and summary inodes when
 metadir in use
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942970.2295836.3762908405377036051.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ea99122b18ca6cf902417e1acbc19a197f662299

Set the rtbitmap and summary file inumbers to NULLFSINO in the
superblock and make sure they're zeroed whenever we write the superblock
to disk, to mimic mkfs behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_sb.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 87be47083aa571..fe760d38fd7673 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -666,6 +666,14 @@ xfs_validate_sb_common(
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
@@ -794,6 +802,8 @@ __xfs_sb_from_disk(
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
 		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
 		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
 	} else {
 		to->sb_metadirino = NULLFSINO;
 		to->sb_rgcount = 1;
@@ -816,6 +826,14 @@ xfs_sb_quota_to_disk(
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
@@ -951,6 +969,8 @@ xfs_sb_to_disk(
 		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
 		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
 		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
+		to->sb_rbmino = cpu_to_be64(0);
+		to->sb_rsumino = cpu_to_be64(0);
 	}
 }
 

