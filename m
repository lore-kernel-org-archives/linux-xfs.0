Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C9121219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844545; cv=none; b=HMplk2ZQP+/FAHCq6OCKMfODhk69ISRTbBEaGUnWRZkPkjRgF5dBLuosk+jZb8rAPN0hdRWmaEoUhh6WXtE/9pytznZcKe9YPR7JtMfpiJTSh3pYnGAZVXDipZswnI2k0m+LrvFECRUvXMAJnA7mATOGE2HE+LmM0JvBv+ZVeh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844545; c=relaxed/simple;
	bh=zVjXzrBoB+v+Ly71o3jpegDafoehVrmff5I4IZBIyEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jyz5EebYZ+ziGFmx3pTHoZAUmQfLc/1GeqXz7mm/Qt4Y/U8NAxO4N7ZULeU2ZExBAsUTJF5xOTGOj+/zhNsUZ6VPbHy46eZipnLYtbA0JyZWBNEf5KX04t98z65fw70rq8vplrAptuUPRv5FZmDXhuhSH5bs9AqWflU26Hwkfrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7WbG3bS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7WbG3bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8154C4CECF;
	Tue,  5 Nov 2024 22:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844545;
	bh=zVjXzrBoB+v+Ly71o3jpegDafoehVrmff5I4IZBIyEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C7WbG3bSJbL6qm+jldCdFhM2/xp3lrb7eD/f9tBF4jQfXQPatkN2WeOFK0GTH+pI5
	 +LLja2ySNr1VboHlue/17OX6hRX2UkbzJiRgr3p+Bkr0lGhryXzZ3Vij5QosfSzCn/
	 TvEPJs0rO+DhP+NyWbk3injJ42VkYAYLb1QYo5YRbsLbgfJPZQysHG+utoAJ1Jn/o5
	 xM+a90b/nUKRqt4VkODqid4+Q0z555FVq+YT7nqyCFAC9WT8xQtXD9g1KO2cEWqJ9j
	 GduIxBaK8d3dj41BMFUDkGOi6VwZbYZZWsVzci6j5GAonHIdO70oZdmommkiGFtNq6
	 9cZOuuc7XgHaw==
Date: Tue, 05 Nov 2024 14:09:05 -0800
Subject: [PATCH 10/23] xfs: keep a reference to the pag for busy extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394623.1868694.14794920802145881465.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Processing of busy extents requires the perag structure, so keep the
reference while they are in flight.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c     |    4 ++--
 fs/xfs/xfs_extent_busy.c |   15 ++++++++-------
 fs/xfs/xfs_extent_busy.h |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 1a91e97d25ffba..5c00904e439305 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -117,11 +117,11 @@ xfs_discard_extents(
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
-		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
+		trace_xfs_discard_extent(mp, busyp->pag->pag_agno, busyp->bno,
 					 busyp->length);
 
 		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
+				xfs_agbno_to_daddr(busyp->pag, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_KERNEL, &bio);
 		if (error && error != -EOPNOTSUPP) {
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 22c16fa56bcc44..7c0595db29857f 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -34,7 +34,7 @@ xfs_extent_busy_insert_list(
 
 	new = kzalloc(sizeof(struct xfs_extent_busy),
 			GFP_KERNEL | __GFP_NOFAIL);
-	new->agno = pag->pag_agno;
+	new->pag = xfs_perag_hold(pag);
 	new->bno = bno;
 	new->length = len;
 	INIT_LIST_HEAD(&new->list);
@@ -526,12 +526,14 @@ xfs_extent_busy_clear_one(
 			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
 			return false;
 		}
-		trace_xfs_extent_busy_clear(pag->pag_mount, busyp->agno,
-				busyp->bno, busyp->length);
+		trace_xfs_extent_busy_clear(pag->pag_mount,
+				busyp->pag->pag_agno, busyp->bno,
+				busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
 
 	list_del_init(&busyp->list);
+	xfs_perag_put(busyp->pag);
 	kfree(busyp);
 	return true;
 }
@@ -554,10 +556,9 @@ xfs_extent_busy_clear(
 		return;
 
 	do {
+		struct xfs_perag	*pag = xfs_perag_hold(busyp->pag);
 		bool			wakeup = false;
-		struct xfs_perag	*pag;
 
-		pag = xfs_perag_get(mp, busyp->agno);
 		spin_lock(&pag->pagb_lock);
 		do {
 			next = list_next_entry(busyp, list);
@@ -565,7 +566,7 @@ xfs_extent_busy_clear(
 				wakeup = true;
 			busyp = next;
 		} while (!list_entry_is_head(busyp, list, list) &&
-			 busyp->agno == pag->pag_agno);
+			 busyp->pag == pag);
 
 		if (wakeup) {
 			pag->pagb_gen++;
@@ -662,7 +663,7 @@ xfs_extent_busy_ag_cmp(
 		container_of(l2, struct xfs_extent_busy, list);
 	s32 diff;
 
-	diff = b1->agno - b2->agno;
+	diff = b1->pag->pag_agno - b2->pag->pag_agno;
 	if (!diff)
 		diff = b1->bno - b2->bno;
 	return diff;
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 847c904a19386c..72be61912c005f 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -20,7 +20,7 @@ struct xfs_alloc_arg;
 struct xfs_extent_busy {
 	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
 	struct list_head list;		/* transaction busy extent list */
-	xfs_agnumber_t	agno;
+	struct xfs_perag *pag;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
 	unsigned int	flags;

