Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E375D7462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995819; cv=none; b=XndBZjswPe9dCNT1um05zmr5aNMzCGVHjEHXSRK52C6apqGO27GhFEi1esZckb815ElBk8JVXhNBl/2ehG72DSZG8lENJbv7oVA2oWaoV63XzOYamDRklUkHMMFNoAy4zw2/QIe1lELIQJeS2F6ykVSrBH8RXT7wS0kaawH5k5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995819; c=relaxed/simple;
	bh=mW4i29yb2BnpL8CGSPV1NoxbmzQce5kgH58agdHxmFs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqOrHCKb2va1JuxFGr6JK4GxeNNzfefhDAMbQs4Tw60kOngoPr2mIiEeGqR5LjehzDIzrCVnIVuwYLZiA/tOgSY6syWzAsz6CTkXHgEWRYmgooZYJx64kVQoCXO2YLNya+Mjhe7b4Gfj5be7T599zJUyKW++Pw/xNV7anr8nS80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoitIEFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoitIEFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7913EC4CED3;
	Mon, 23 Dec 2024 23:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995818;
	bh=mW4i29yb2BnpL8CGSPV1NoxbmzQce5kgH58agdHxmFs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WoitIEFlzZbang66cSbkj+nLE39IT1ZvksVgIlNfabcakh7fa83wiDW4tU+CGQwtJ
	 hAKxpFEa2fWdRq13zqewpWGr+SgcCEn4xALh4O+0Z7tlLYdZmuyulebnslapl6IZfb
	 SE6l0+4JSxHht6T6l354mTjuc6ZjiFDmErdL0u54HM+Kaz8ch04/9SWN3/l2TCY061
	 nl6JVy1IbMzomxDbl87RDAXjGl8gNra20exaqOZuTMaMt4LsbEwZFVkFYeFvai1qny
	 C+/L23pljmmh4Vs8iSXVsaSlg5Dpkz12JfE+YAQNWr0b3wZpRE4qXow8Pks2qZfQZK
	 wUcabhjfhSaIQ==
Date: Mon, 23 Dec 2024 15:16:58 -0800
Subject: [PATCH 41/43] xfs: check for shared rt extents when rebuilding rt
 file's data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420640.2381378.3973490666055293319.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data fork of a realtime file, we need to
cross-reference each mapping with the rt refcount btree to ensure that
the reflink flag is set if there are any shared extents found.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap_repair.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index fd64bdf4e13887..1084213b8e9b88 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -101,14 +101,21 @@ xrep_bmap_discover_shared(
 	xfs_filblks_t		blockcount)
 {
 	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_btree_cur	*cur;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
 	int			error;
 
-	agbno = XFS_FSB_TO_AGBNO(sc->mp, startblock);
-	error = xfs_refcount_find_shared(sc->sa.refc_cur, agbno, blockcount,
-			&fbno, &flen, false);
+	if (XFS_IS_REALTIME_INODE(sc->ip)) {
+		agbno = xfs_rtb_to_rgbno(sc->mp, startblock);
+		cur = sc->sr.refc_cur;
+	} else {
+		agbno = XFS_FSB_TO_AGBNO(sc->mp, startblock);
+		cur = sc->sa.refc_cur;
+	}
+	error = xfs_refcount_find_shared(cur, agbno, blockcount, &fbno, &flen,
+			false);
 	if (error)
 		return error;
 
@@ -450,7 +457,9 @@ xrep_bmap_scan_rtgroup(
 		return 0;
 
 	error = xrep_rtgroup_init(sc, rtg, &sc->sr,
-			XFS_RTGLOCK_RMAP | XFS_RTGLOCK_BITMAP_SHARED);
+			XFS_RTGLOCK_RMAP |
+			XFS_RTGLOCK_REFCOUNT |
+			XFS_RTGLOCK_BITMAP_SHARED);
 	if (error)
 		return error;
 
@@ -903,10 +912,6 @@ xrep_bmap_init_reflink_scan(
 	if (whichfork != XFS_DATA_FORK)
 		return RLS_IRRELEVANT;
 
-	/* cannot share realtime extents */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return RLS_IRRELEVANT;
-
 	return RLS_UNKNOWN;
 }
 

