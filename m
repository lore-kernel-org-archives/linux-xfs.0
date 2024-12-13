Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2932907
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052529; cv=none; b=atvRCfU+oPLpuWbIYUDJxXf/zwFitPj758wY1/I9bubsrCCnq7/stVSuVxYjqB8smgwtmWdW3W7uLS5eM+8ii1Zz4p0g2DQ2ZZMFceq5rldeqAUPUdb7ak4nD371XBgVSz2TRgcxlu2IDWA7HeN5/Kbmw9kI7a4Lwk6pR8Bs93o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052529; c=relaxed/simple;
	bh=LRNkg2KtqFgAtC/QjUE8pU5AD7cYslgcjecLZ+2eErQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ms6VoBMBm09qOYfVey8WKEq6HQvIJbKu7n6bo95ztnmPlJMM8NdT44gM4Pg7E9KRDp2ZnXdhfMEk8EzfGw3MFMhIKEgP9ys5efyVj6vepf8Go75vCL+6BaCD5PVEPmXTonvGbMZrV95PrwMx+wjXyLVkY5TJK1gj19DIyTQ7Q4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2gLNiy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2gLNiy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D70C4CED3;
	Fri, 13 Dec 2024 01:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052527;
	bh=LRNkg2KtqFgAtC/QjUE8pU5AD7cYslgcjecLZ+2eErQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B2gLNiy4Aib3W53KodCAxcEPMHQVR/bcz8WaaNnm1Mmy46TKBmP3E7TJBYmW3UZ7a
	 pLQOhW3QFCbuvFPsA6MiR7K0sGGAw0QwVrJGWp6kQNnYqlgHmiSf+UAKDMuvPuWXEa
	 dj2yd5AUuO36dpVb1sOmt6juXAWCwg+bkcvg9+JsJYxoA8pxPiXZbLzZc1urvDrilL
	 FQoOcIUxKvmzY9V38vhpdqLhg+opT4SLrcXy4tbIyIepNUu02Qi4c+mEADL34TpROe
	 ekeK4xzIsRP0LDBP5cdbE8LFkKFkdLNziVapYxqTXDLTe+X1wpebmiWmBt4Z0E8IKy
	 yX7zCg1KQYjDQ==
Date: Thu, 12 Dec 2024 17:15:27 -0800
Subject: [PATCH 20/43] xfs: enable sharing of realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124910.1182620.7183592337728397486.stgit@frogsfrogsfrogs>
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

Update the remapping routines to be able to handle realtime files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 24f545687b8730..78b47b2ac12453 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -33,6 +33,7 @@
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_metafile.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -1187,14 +1188,28 @@ xfs_reflink_update_dest(
 static int
 xfs_reflink_ag_has_free_space(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		fsb)
 {
 	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
 	int			error = 0;
 
 	if (!xfs_has_rmapbt(mp))
 		return 0;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		struct xfs_rtgroup	*rtg;
+		xfs_rgnumber_t		rgno;
 
+		rgno = xfs_rtb_to_rgno(mp, fsb);
+		rtg = xfs_rtgroup_get(mp, rgno);
+		if (xfs_metafile_resv_critical(rtg_rmap(rtg)))
+			error = -ENOSPC;
+		xfs_rtgroup_put(rtg);
+		return error;
+	}
+
+	agno = XFS_FSB_TO_AGNO(mp, fsb);
 	pag = xfs_perag_get(mp, agno);
 	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_RMAPBT) ||
 	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
@@ -1308,8 +1323,8 @@ xfs_reflink_remap_extent(
 
 	/* No reflinking if the AG of the dest mapping is low on space. */
 	if (dmap_written) {
-		error = xfs_reflink_ag_has_free_space(mp,
-				XFS_FSB_TO_AGNO(mp, dmap->br_startblock));
+		error = xfs_reflink_ag_has_free_space(mp, ip,
+				dmap->br_startblock);
 		if (error)
 			goto out_cancel;
 	}
@@ -1568,8 +1583,8 @@ xfs_reflink_remap_prep(
 
 	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;
-	/* Don't reflink realtime inodes */
-	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
+	/* Can't reflink between data and rt volumes */
+	if (XFS_IS_REALTIME_INODE(src) != XFS_IS_REALTIME_INODE(dest))
 		goto out_unlock;
 
 	/* Don't share DAX file data with non-DAX file. */

