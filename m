Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4644196
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529865; cv=none; b=fSNKYKPdtaj8EDVfvpZQzYNuEqBQMY/dXMqXEiiwP4uFMP9sw0kuBlTy+jb1TXzqv++2yvCDN6iw8W0Me+WIemhyJuaYWKnjkI6nZxlywEyHw0IX7DXl/bHy048Yhg7oQ13HBu6KsBjGf5Sk6okNKdAQ796U2BLWQCJFpzATEzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529865; c=relaxed/simple;
	bh=/OraPJtyhNBbqUzkSPSuZA/HGBJEqT5hh7WVcU8sGYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jL8gIGgkPRtyZGQyxF8pRRQWdOvPE67K/qHYPIeCfbFWv24Ta9yigQTRSJ/DIRQ7oODmmXc2CjmuGu+OlVbP0NJzn2GF3qDo4ih/+0DwcRqFVg8oj28QxrmGQdFgiaDGLT318bNbyNMRYEokDwTGtwZcXJaIZNEUs9hFR4IGjXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZY0gGAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZY0gGAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F50C4CED1;
	Sat,  7 Dec 2024 00:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529864;
	bh=/OraPJtyhNBbqUzkSPSuZA/HGBJEqT5hh7WVcU8sGYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CZY0gGAT3ytMNA6Sc3c8CPQ4cnfrbu04gEnSoAS4hT+E74pHhsW36VI4ZA6L1D19a
	 8lo/uC+55wd6sdH6uVueW/hEc0j0dnvMWFl4hJKpghv4On7uGeH5mqNElOIopv1fTt
	 x3F442aQJyzDYfIczwy+Ltu8N5dEf/jm1AZWtB2b2u4/35sQlVvVl1wyKTdO4326F1
	 RnRwQL7nKiXu1f1J3hvmWf5TeosILcOPQxwgr2ispWAhjAaQk8NRN5xgaCpGH9wugB
	 CwR1BLLrGpTrp0k0BJoswT9EyPvJXFnV6Cr44AMO410BSnEASFf+O4h5Krla+ZitHi
	 qHY+hl0oiC0Ng==
Date: Fri, 06 Dec 2024 16:04:23 -0800
Subject: [PATCH 4/6] xfs: don't call xfs_bmap_same_rtgroup in
 xfs_bmap_add_extent_hole_delay
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751260.126106.6805684880756196870.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
References: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_bmap_add_extent_hole_delay works entirely on delalloc extents, for
which xfs_bmap_same_rtgroup doesn't make sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

