Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB1220D51E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846202; cv=none; b=WQA3xF19y5onE7gNv1hWtIGRehwBSZJdMoDmuB9ssQLKdRiwK3Z2LTi5SPU9fH2tDZ007W6muX22G6Fac9q1i9zjL8QgxNsOHLPM14bRkV1SdSInzeKpFap+PEtNRPeVYrtj616ltdDu9eAcA+4/83igtfKbgRe+11bwgyom0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846202; c=relaxed/simple;
	bh=ICwET0+B/TMK4Uuaz63TV3TNGsd0X2v+DEMH0t9wmtA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2i/aqE8egIZ8YuhWfjKz0FCICnZyaOIBpwMlr/KQ2c3Dep5B0y5aYS8GJlaqhlYepkLMD295B4uzKQUQAfTftGQy06Dx1Jw0NuPENbyjJTDSJHN4leFDSEQ4UI5akPLdf05iVXefR6wm/r5xs2+TlVLmbhGDjYbuHNrNQt/INo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dva3RLk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dva3RLk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11A3C4CECF;
	Tue,  5 Nov 2024 22:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846200;
	bh=ICwET0+B/TMK4Uuaz63TV3TNGsd0X2v+DEMH0t9wmtA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dva3RLk2UgQPzqe7AMIulQjiIzKISKCe19sfcuFLLQEUcjuZkU8eZ0cJBfS5NaGwy
	 u93bVZ8SKJUsgcABA/Wspfjso+70Y0mpscIQM4NMvzDWovLcgwKNTHHbX9ZUWgBDa6
	 GFCAwOJ9qPpAOLZ2as6DMP+SwN/daYMN+oduLzeYRXGtxJckyu4o1cPqx6/Ohmbabq
	 0I3mjO+T7LpSVn6rUlWlcZR3RLFuzRSDdqQ73K9+cWS2A9NjbmCp9aiNnQGmaHzbfi
	 M6IQg4yIZDW7fJs9eoSRxFOkYwDctAxMk7EiBrcB6rUa+sS1rhGMvYqpIaRd+vMJP7
	 bwN3g5CHw1urw==
Date: Tue, 05 Nov 2024 14:36:40 -0800
Subject: [PATCH 26/34] xfs: mask off the rtbitmap and summary inodes when
 metadir in use
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398628.1871887.10471379269686322391.stgit@frogsfrogsfrogs>
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
 

