Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D100E13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991828; cv=none; b=HfJpQxjjCdAc/Iupl/dAkYm/43uG4e/7lvpy2n4E/KrlTrHihvFWfNwXFJw0X9odrQLwPj9oLCC4l523mOwR+qKy638GldzhzaOR8LRR2CgswSZRB2Ho9GyIuQpOznlo0yU2QgPCCPBJqgHvDEsSzEw3tjhag3zI4AKQELiGiUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991828; c=relaxed/simple;
	bh=+O6/vjIHgrNnoxHStnuzJPvZfDaRg54qwJVe694I978=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gz13oOjCveYoivUnBgYZ3JCI6WdqxIf1DVDcoHwSTs+Z7WC+07NQLf2tNSOxpqDsV4XxnTriYulxd5tf9ikCv9dVzCiwfIL2Ii+YrtdEFcDvOrKAooVWaIy1E6XERYqAvCdHnpZh28sVKxzllN1jowVJDpdREXt+ygkt2HaU9QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZqrMYs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZqrMYs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5E0C4CED3;
	Mon, 23 Dec 2024 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991828;
	bh=+O6/vjIHgrNnoxHStnuzJPvZfDaRg54qwJVe694I978=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CZqrMYs4JqKyoabuRxOuriMN5GNDFuIs+Mp50MFyLoCBGHMk+wnQ49MFiwIv+bHuH
	 strI2tXOv/IINaDI7azx9I9lDBCr/hdccjvEhYeGXZHuVegVFKAqwcdIISCwB4Rt33
	 cuYVPPK5tdUF5RCxnq4IfdaDROmhgdOR7bXtgAk8dGGBtA2Y1QkPAN6c/M02t8K31x
	 ylJt/GyvZhMApqJgKeZXH+suL9YgYR378yO9f7T8fMt/nzntyCV2gQjK/MUyOU+Vze
	 muXEvvJC1C27ooJd/8OzbRMToF37ACJ1fQxp1DfiJySEq7Sg8wV9cUX3l21Rqs9AO7
	 yDkoudurydI9A==
Date: Mon, 23 Dec 2024 14:10:28 -0800
Subject: [PATCH 47/52] xfs: don't call xfs_bmap_same_rtgroup in
 xfs_bmap_add_extent_hole_delay
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173498943210.2295836.680604652012708875.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: cc2dba08cc33daf8acd6e560957ef0e0f4d034ed

xfs_bmap_add_extent_hole_delay works entirely on delalloc extents, for
which xfs_bmap_same_rtgroup doesn't make sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 552d292bf35412..16ee7403a75f3b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -2614,8 +2614,7 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
-	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
@@ -2623,8 +2622,7 @@ xfs_bmap_add_extent_hole_delay(
 	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)) &&
-	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*

