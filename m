Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373C928F4
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052857; cv=none; b=e1Yg2NJ56D2phuWWKcgiznLdcALGgVf2tyTrrkskV6SBiUkKD0XaxFXymIDdfW7uKsCt0NFwvvl3/YX/ERGP7MflrIeDVFiakCX8P7TRcHCSTAsHQ0rQk8xo6J0mdDPbILdBRKd1yR865X87SXsb/bgMd4affjXzSe7BhdntwfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052857; c=relaxed/simple;
	bh=JMm0eOAgxExAd3X+67JQ9+SBuosZQ2qtpqlJlYmWZ4w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uuXP0Y5QuKOqOToYgdAabW+Wu2/Qp0JX5Pf/reoEpWRq4RYY2fZJs3d68s+82EDWuBb4Y0BXLNysc1iajsXbH5RBBWAc1hZAWxiWoFCUfCjLVK3ZgSYrd3v2k2YTPTuP9m+0l2ZQRlKIttAyUh9DaDI5c1uHgzEth/KPpltffPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDDcaW2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDDcaW2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E09C4CECE;
	Fri, 13 Dec 2024 01:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052856;
	bh=JMm0eOAgxExAd3X+67JQ9+SBuosZQ2qtpqlJlYmWZ4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mDDcaW2KgjE8urii73CQ4f3P2x5nodjPv8fcIQlMjTastWeDtdZ3iZ/d2f+KTBK7Y
	 QOZlsAePyX2A2eTdeVlbPEzkJ6U3u1DqMpb7LazLFg/p29lZpktlP6uOOUJWTr3aaI
	 HX8Mmrf6TYfIPtYOsXnaRU7PkS26ucR5Pj29pdmcSN02upuffXxt5J7ODpV62C0y86
	 iONsv4/8QmQirhyLvg+QADWNTLBz7CqMtsw628lU1XWt61h+oLc435eIm2jeQCtFyG
	 z3mmsvrAjdLL2Wk4tqo7VDnyiY6uSGjrprARK3Z4nYCxeRGaR3HodkR+0ooZ4sEp5M
	 d5KZdYop/IjVA==
Date: Thu, 12 Dec 2024 17:20:56 -0800
Subject: [PATCH 41/43] xfs: check for shared rt extents when rebuilding rt
 file's data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125269.1182620.10072286289886086140.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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
 

