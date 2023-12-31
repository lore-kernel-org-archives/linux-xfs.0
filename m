Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EECFBEA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdIlks7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD3EC433C7;
	Sun, 31 Dec 2023 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059731;
	bh=kZARMGHDb3CF9VOQC4TkmLKkGtBTylDrTVMQsPVr/pk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DdIlks7AlCoRGvPTMUrihFVpBC6C3U+MEzDiNxs4/djyY3Q07GRt9X4pcIUNVz0GO
	 RePJcmzQ3obZxpQekDlElAf1z/qKOsLLXiyzZaZftIgXhdDWJttZBXiPt+kqaEmU+d
	 XLavOQhMQ4nL3ZxwhgsD9SEPhLnpFcDHe9+mRhLK9wEta1YNfOkN5vgmKEGgfiSX+/
	 +5vxA1ShnviiPykDdXK1y+sbJcvSCybOefVQdixTRxQyycXGA2JfVJgZcHYSBRXwA7
	 nodt/FNvhSjZ8wibEqV0uyBt1RDYOI0DAtEREGppTUu1vCUeKwWhsrhm2bwTaf+SDa
	 uc1k3Xen3Jd+A==
Date: Sun, 31 Dec 2023 13:55:31 -0800
Subject: [PATCH 42/44] xfs: check for shared rt extents when rebuilding rt
 file's data fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852255.1766284.11484868844063893927.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap_repair.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 98618821ad975..c4f9a8ba8cf73 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -101,14 +101,23 @@ xrep_bmap_discover_shared(
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
+		xfs_rgnumber_t		rgno;
+
+		agbno = xfs_rtb_to_rgbno(sc->mp, startblock, &rgno);
+		cur = sc->sr.refc_cur;
+	} else {
+		agbno = XFS_FSB_TO_AGBNO(sc->mp, startblock);
+		cur = sc->sa.refc_cur;
+	}
+	error = xfs_refcount_find_shared(cur, agbno, blockcount, &fbno, &flen,
+			false);
 	if (error)
 		return error;
 
@@ -456,7 +465,9 @@ xrep_bmap_scan_rtgroup(
 		return 0;
 
 	error = xrep_rtgroup_init(sc, rtg, &sc->sr,
-			XFS_RTGLOCK_RMAP | XFS_RTGLOCK_BITMAP_SHARED);
+			XFS_RTGLOCK_RMAP |
+			XFS_RTGLOCK_REFCOUNT |
+			XFS_RTGLOCK_BITMAP_SHARED);
 	if (error)
 		return error;
 
@@ -900,10 +911,6 @@ xrep_bmap_init_reflink_scan(
 	if (whichfork != XFS_DATA_FORK)
 		return RLS_IRRELEVANT;
 
-	/* cannot share realtime extents */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return RLS_IRRELEVANT;
-
 	return RLS_UNKNOWN;
 }
 

