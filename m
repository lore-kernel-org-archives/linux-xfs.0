Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF832BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCjJ/5zP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAF9C433C7;
	Sun, 31 Dec 2023 21:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059387;
	bh=bNOETkBHVW83kXWD/wKV9Oq2nW9WtdnEulw8izNR6PQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OCjJ/5zPM99Fz3yWZfvjCRm49TKYOJf2orZ97c/P7fDA/1dkX/4xr6JE2mvSfl6RX
	 fbOdGKn0oz3xHbvI9by5KoFbE+he0nsqS2r9C3Gn5QIwVzLZiZHDzZT9O8v275g2Q0
	 eWLdvTIUjaZH9BuwwIaZ1rJn7Ea24Skg6+5qacqP1htnGfidJMy/+EJNGpqcOabKW/
	 d5QcSNyGJsKT1JAL0/QHJNPCe0VTaWLVR4sImDzUOb98Pw28KY4JLYJj6BrB71658T
	 caG2rCqrkDA2z8eJm+p5QCIB4PobOCQToPsDkUrCsVWEZQp4x754jEuPz8KujutJep
	 QVV9JC1dsBSJw==
Date: Sun, 31 Dec 2023 13:49:47 -0800
Subject: [PATCH 20/44] xfs: enable sharing of realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851904.1766284.7432229795185385143.stgit@frogsfrogsfrogs>
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

Update the remapping routines to be able to handle realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ed9f4ca34fcea..d05ab2c91bd98 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -33,6 +33,7 @@
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_imeta.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -1211,14 +1212,29 @@ xfs_reflink_update_dest(
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
+		if (xfs_imeta_resv_critical(rtg->rtg_rmapip) ||
+		    xfs_imeta_resv_critical(rtg->rtg_refcountip))
+			error = -ENOSPC;
+		xfs_rtgroup_put(rtg);
+		return error;
+	}
+
+	agno = XFS_FSB_TO_AGNO(mp, fsb);
 	pag = xfs_perag_get(mp, agno);
 	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_RMAPBT) ||
 	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
@@ -1332,8 +1348,8 @@ xfs_reflink_remap_extent(
 
 	/* No reflinking if the AG of the dest mapping is low on space. */
 	if (dmap_written) {
-		error = xfs_reflink_ag_has_free_space(mp,
-				XFS_FSB_TO_AGNO(mp, dmap->br_startblock));
+		error = xfs_reflink_ag_has_free_space(mp, ip,
+				dmap->br_startblock);
 		if (error)
 			goto out_cancel;
 	}
@@ -1593,8 +1609,8 @@ xfs_reflink_remap_prep(
 
 	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;
-	/* Don't reflink realtime inodes */
-	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
+	/* Can't reflink between data and rt volumes */
+	if (XFS_IS_REALTIME_INODE(src) != XFS_IS_REALTIME_INODE(dest))
 		goto out_unlock;
 
 	/* Don't share DAX file data with non-DAX file. */

