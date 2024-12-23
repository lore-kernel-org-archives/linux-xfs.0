Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC707E76D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995490; cv=none; b=ouyVQbFouJaz4N4Wo02hjEPbuyd+GXXyBechSjUCJW+AjUduboBNpzjpS83oIyrNU2EBg/gHh+t+JZZ5vKxi+KDg/ZrgxaeidxP9lFaTl++oNxoG+WdG0r9CfTEWRIkrzHP8hgCSEwRxzUI7tJvV9EGoj5kW3qDd58mp0mChHLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995490; c=relaxed/simple;
	bh=GDfgkiZ3H0bF/1KyRQutzFdUD1zdUZFsF8rc7IlIdNc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=staqSlgTn+yMQhP76ZYKWZUOkmgSmo6WDJQ8THcQMWRO/7BtKD9TTFPZ+B3+lrF1OyaTUVN/xAo4CHo5vk8FqfX0tCKUPsPaoKO0HImq+h6AVfOu1iZ+gqVStXzHxskM+pI2qu5z+66774hJoBOhgzaycWWJT06DnY1jjwcdwfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0G5Ie6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0G5Ie6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78171C4CED3;
	Mon, 23 Dec 2024 23:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995490;
	bh=GDfgkiZ3H0bF/1KyRQutzFdUD1zdUZFsF8rc7IlIdNc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E0G5Ie6GqY95cYkYDxcXuH+1s7i5T76ZgW0iv3NoOgsoO99Qspopq4dAypuMp+A2s
	 TqSH8V0d0ySxRu1DkY37Zi/WO3XFHKh9WB44XnDAEzA3RTL7Q4IwMS9uWGSZKShF1l
	 1ZjrOZ0dM2TwJQEUWIlMzC/y/tY6QZCG9usDNM83xlkUpCU5UcBC/cjsSsLUJ/pG6i
	 DPn+mzAHpd734cePcyJdn0BsSjBOysif5DjoRNEBD6HFCZCPiucfgODm1bxaxyPocY
	 ZWHs6zWOseXBhhRvrEnwfmIkJUxQakaGhm2JapLjfIgGV+ilGUuTKH9suMasvEUaiM
	 bOferM/loldfQ==
Date: Mon, 23 Dec 2024 15:11:30 -0800
Subject: [PATCH 20/43] xfs: enable sharing of realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420281.2381378.16492392366149419508.stgit@frogsfrogsfrogs>
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

