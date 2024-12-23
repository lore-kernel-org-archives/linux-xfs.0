Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6028A19048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990734; cv=none; b=AMpYXp0RucF803hR2QoNVjvr31Tkao/61aLcn/xKUh+kkchwT9kc27y6TNY5Y36SZ2M8KauQQ162B++pYzkkJ1lDBit26/XuUAoS5troOInT9Kr999v1f1WXtOlwXuJ79kLEFOPlUKRVd1eYYgVskbg51oQsTUpo0dWlZ86BS78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990734; c=relaxed/simple;
	bh=bkVLn4E9uBYa03y5YwaB0CJcAc+t8TO017deArzGzPY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXtoiVblEa1TLA66p4eSu8c6x1lzvbg6O3nbcuRMlj+3Z3DR4SxQfVjJxZ2ktrvbtyYQUHGo+KD4MtB2wEeyyat2r+HXr549/OCnL0u5cI02VF1L4U4MjSDWnYuPsLGTOSep8RDLLJO1TcowVvBda6j2Hnf1UID/Bl7u1SfWrQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDxELLpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDxELLpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F51C4CED3;
	Mon, 23 Dec 2024 21:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990734;
	bh=bkVLn4E9uBYa03y5YwaB0CJcAc+t8TO017deArzGzPY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cDxELLpJiqKsYfXI/t1YowY+S+K3QqDzYQ9QXSqpxSVQuJUX8+0IxJkhh4KdQRVrK
	 Auecz6859Lg98M7TytpQISrckOCIGuyx5f12FPp99ejw01S3cQjLdw9NL1VMEZMNUQ
	 XWq5XTPTqtCz0MoXS3zNpX3m2SQIgbA/IV5VtUasqXFIqxRxq2opfLJB7D/rnQ92G1
	 xxf/tfIE1oRW7P8Bu3BagPCm7GsWZ3fNBdiXcROl2GxwjYNsA95WgTXMkPqXBlFld3
	 Vd5fqNsLUQ3KbxjCPsLWHbq5k6sMb7TM2LQh/9pDvaS4+XYrCr4lS9hXr0Yw7npuGK
	 pJ+6qT6XIKNtg==
Date: Mon, 23 Dec 2024 13:52:13 -0800
Subject: [PATCH 22/41] xfs_repair: handle sb_metadirino correctly when zeroing
 supers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941305.2294268.16758078118636673556.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The metadata directory root inumber is now the last field in the
superblock, so extend the zeroing code to know about that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/agheader.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index 3930a0ac0919b4..fe58d833b8bafa 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -319,6 +319,12 @@ check_v5_feature_mismatch(
 	return XR_AG_SB_SEC;
 }
 
+static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
+}
+
 /*
  * Possible fields that may have been set at mkfs time,
  * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
@@ -357,7 +363,10 @@ secondary_sb_whack(
 	 *
 	 * size is the size of data which is valid for this sb.
 	 */
-	if (xfs_sb_version_hasmetauuid(sb))
+	if (xfs_sb_version_hasmetadir(sb))
+		size = offsetof(struct xfs_dsb, sb_metadirino)
+			+ sizeof(sb->sb_metadirino);
+	else if (xfs_sb_version_hasmetauuid(sb))
 		size = offsetof(struct xfs_dsb, sb_meta_uuid)
 			+ sizeof(sb->sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))

