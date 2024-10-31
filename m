Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236D1DFD81
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416716; cv=none; b=QCYo1BK2t6MTQ99uO5rNjboPcbbyude4HtrJAEKba2KreLgDUEV9IXOthDuaXVaJEtGEDrJ8CvT0Mr96vU31km27piu0+2UnGHO3xb/Xk53SNlGCVGd7GJ0A/efSSy8dmKUujLlGEOWKbRF9WnaGMhiPHk0H3H1Abk4GWZ7OR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416716; c=relaxed/simple;
	bh=tGQcT9es3TRziV+P7+TXZrQR+seYjHdeyRpio1O2os0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdl4iTkPE5aPzvyyJY12pLNLQ9Qrcds7r+IAkyWmSzzfF1Hkgh3RKvasuOcChBiJAGXR2mlLuJzrzeoaHjWvKvy/yiHbXTugpFdiyZf/RfbOmLYlS1jiEmtY5+vdckXswMD+t+qCShKi5oMnFGZwmVo/wDitbqCKUXu9kbg2uJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkHrLN7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkHrLN7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE0BC4CEC3;
	Thu, 31 Oct 2024 23:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416716;
	bh=tGQcT9es3TRziV+P7+TXZrQR+seYjHdeyRpio1O2os0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QkHrLN7bNDFXVkJzAr76I4Z2/+4oi3uAyOaDeEVDiV3/Spi2EwxVOhObn56zvByJx
	 IGrjN3Gbg+l+Pog26yaJiSY3kUv07UUOGhLSTd6dkC/KpSQmUIUKlwrV3sZvoxIK1N
	 z4gpg3ypWHvEXBhNrEU42RylfnTg3GcwpxJ4frCcNkDR7JaZ+F44P96X3qBMgi1BVc
	 d8lMuPkLZ23b4C1jWGr1nr9xMKliA2W8WIKizhgW5LRMIYDfF1vfCtzcj1Y0FHNQTy
	 iExIaHgrC4INQY4FwL+ZaaHt5W3m9hLDupg363eGrBeGJn1CY15qPiyu/RHDQOCVov
	 k+Rq6mMYvBLxg==
Date: Thu, 31 Oct 2024 16:18:35 -0700
Subject: [PATCH 38/41] xfs: pass the exact range to initialize to
 xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566497.962545.4939568317650293032.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 82742f8c3f1a93787a05a00aca50c2a565231f84

Currently only the new agcount is passed to xfs_initialize_perag, which
requires lookups of existing AGs to skip them and complicates error
handling.  Also pass the previous agcount so that the range that
xfs_initialize_perag operates on is exactly defined.  That way the
extra lookups can be avoided, and error handling can clean up the
exact range from the old count to the last added perag structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.c |   28 ++++++----------------------
 libxfs/xfs_ag.h |    5 +++--
 2 files changed, 9 insertions(+), 24 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 516c76790cc0d8..3bbfefe5e46935 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -294,27 +294,16 @@ xfs_free_unused_perag_range(
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		old_agcount,
+	xfs_agnumber_t		new_agcount,
 	xfs_rfsblock_t		dblocks,
 	xfs_agnumber_t		*maxagi)
 {
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		index;
-	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
 	int			error;
 
-	/*
-	 * Walk the current per-ag tree so we don't try to initialise AGs
-	 * that already exist (growfs case). Allocate and insert all the
-	 * AGs we don't find ready for initialisation.
-	 */
-	for (index = 0; index < agcount; index++) {
-		pag = xfs_perag_get(mp, index);
-		if (pag) {
-			xfs_perag_put(pag);
-			continue;
-		}
-
+	for (index = old_agcount; index < new_agcount; index++) {
 		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!pag) {
 			error = -ENOMEM;
@@ -351,21 +340,17 @@ xfs_initialize_perag(
 		/* Active ref owned by mount indicates AG is online. */
 		atomic_set(&pag->pag_active_ref, 1);
 
-		/* first new pag is fully initialized */
-		if (first_initialised == NULLAGNUMBER)
-			first_initialised = index;
-
 		/*
 		 * Pre-calculated geometry
 		 */
-		pag->block_count = __xfs_ag_block_count(mp, index, agcount,
+		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
 				dblocks);
 		pag->min_block = XFS_AGFL_BLOCK(mp);
 		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 				&pag->agino_max);
 	}
 
-	index = xfs_set_inode_alloc(mp, agcount);
+	index = xfs_set_inode_alloc(mp, new_agcount);
 
 	if (maxagi)
 		*maxagi = index;
@@ -379,8 +364,7 @@ xfs_initialize_perag(
 out_free_pag:
 	kfree(pag);
 out_unwind_new_pags:
-	/* unwind any prior newly initialized pags */
-	xfs_free_unused_perag_range(mp, first_initialised, agcount);
+	xfs_free_unused_perag_range(mp, old_agcount, index);
 	return error;
 }
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index d9cccd093b60e0..69fc31e7b84728 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -146,8 +146,9 @@ __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
 void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
 			xfs_agnumber_t agend);
-int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
-			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
+int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
+		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
+		xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 

