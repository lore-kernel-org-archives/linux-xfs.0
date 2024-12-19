Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF661B4F04
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637095; cv=none; b=Ok9ajkLGQtpuKyqnzaKtr7udgay42ptxj2S7JzJbSY2x6TyntndWZukU85ckLzdHVSsumx7jW30+dUv8wM+igwEqUDPI+nM4M4vuHVVd84ys0l4tHA/Oq/bdEI06/0c5eCxztsViqcK+UWL0r7TDBbHYPXhRecZu1BHITdpCq4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637095; c=relaxed/simple;
	bh=GDfgkiZ3H0bF/1KyRQutzFdUD1zdUZFsF8rc7IlIdNc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t65wR9QiwJVNDf2K2XnA6CzkDa95TJjc11Ag0IZBYkBCxCf0OHZYL+kbz5l7O1UkBxd2RtuiE4u+0qrIkCrGj/igMbl77FeIN3A03IhPoY+Zhas/fuD5wXt2saxdP1+6CupeT6moz+QJpySPbGc4W9v4lJxwQ3alUMqoez2JhtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wv+fHRas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wv+fHRas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E49EC4CECE;
	Thu, 19 Dec 2024 19:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637095;
	bh=GDfgkiZ3H0bF/1KyRQutzFdUD1zdUZFsF8rc7IlIdNc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wv+fHRasMk22AV9cpBCB5mqR5vS5IVX+/YsMGH7Eq2Dj3s0i/x1u5JJJaE0Jq47OF
	 PPYrpXuFtmhJKqYkyzdYgaSOyxmMi3CsveuTAnnotpgHfMAvP7D34lI0Tc1Bu+Cz3w
	 hz7hg0jPMo5PacZRR1RNnuXq5A4hCvqVwIgdNu+/rIuHiIYpoRQTU+6Td/YhIGiktU
	 V8ltRAc4WKO7Sq6q5AVadmnLTIoodXX4jxyB1BcIKhGTx94GctCsABUFmLk5KnYhcS
	 7PdIgrUnV0xvIfTQELuWL8iogFC2Frd14Q0/neXh3slgfqPXarSy8x9nY5nBsvmIP/
	 RfKCL3tcjT9UQ==
Date: Thu, 19 Dec 2024 11:38:14 -0800
Subject: [PATCH 20/43] xfs: enable sharing of realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581321.1572761.3233283111774533052.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

