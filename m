Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C001DBB2E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529567; cv=none; b=Hy+YmvGRb2FScBJcVTscRolYlI4BwPC0778rCr9LAr693KpKO+uIbxhjXIkYaAwRKvkLhrg9pjJM/FkMyYoOlUIiahogr8g17i0f+bewSodoFVBKOTw86qnBKgDHXAVjjVpWDCWwDITuC9hrkY06/zq3d10lvvZXBD7qcSi3sR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529567; c=relaxed/simple;
	bh=tENxhF4cNRbyI9xjwZ4UWqk4F+jiesZyG1xwOJR2Y4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfNm2DcKGI6I3GeeRSjwlSJae0Rb18wX/zZtZ8QWXkBydsz+OmWz+A3QXnbkPsbedXUsSHLGj3ooKynKwHv5m/K3F+MsbYsXtl9+5Blzq6cc51oNBEeWHa2mPKQBtqUMKokX8GI5Vt873ycU5qnayPB/VoLD7Ul0aAwYH4mgUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwAXr0nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwAXr0nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C944C4CED1;
	Fri,  6 Dec 2024 23:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529566;
	bh=tENxhF4cNRbyI9xjwZ4UWqk4F+jiesZyG1xwOJR2Y4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lwAXr0nlZWFmzLRqDXqwtk1w1tG+6OA/7D8GJq21FDD00iFJJLyLvcB8D5rD0xMla
	 GrDEZyIlGqBMODIlwaKAByrQ/ivJfkvbukTzkm1nAoDdyJ2H6fUy7Q2BkHYax+s/LD
	 vysaSD0SSO/woPXhP3QOqRSB59QJJSFW+N+6eNo3QdBXGvBIOA9NXcW7XegzzS8GED
	 rp7RgTYcGTRnxiAU08y5PuHdFvf9WTE8WGiyC+x6AaTtRd/x2yK4QnLMKwmWFoWVN9
	 GKybomt28LFdudbPpBYFZm36SKJeXHk8YOMvm7ONZVZgQjHPguEKQ2ECg+JX6lKF0O
	 H5VKOoKgNcoDg==
Date: Fri, 06 Dec 2024 15:59:26 -0800
Subject: [PATCH 31/46] xfs: mask off the rtbitmap and summary inodes when
 metadir in use
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750469.124560.17907415454629134060.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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
 

