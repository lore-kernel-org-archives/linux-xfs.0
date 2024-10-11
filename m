Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F7B1372
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607249; cv=none; b=kpDJN86Rd8Ft78R+JIWPxlSp0tHF3kSs6MFqlXw22p/vZ9WdZrM0YCYV+Hgfmf969MhbxnZYOjQUzE8L12hsrLdeu5G7Rh2QIKdcf/Dr5a484TNsuIQTJhX2Jk3pRPwKP+fXNPDEDJF4oD5wrbfSClPs22bDWYfJocbh3jdcV0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607249; c=relaxed/simple;
	bh=zVjXzrBoB+v+Ly71o3jpegDafoehVrmff5I4IZBIyEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbSg8a8PPCehh79XURa8ynMODwvYhj8jQi/CqUvLyfOKDCtc9ZQFvK9cwFkD2It5pkP61OJ31zRaaNDtIIjmKbMgP/fBFD0qBcGeckKg9S845fEqTleK41sn6tLf2AvxAHTdph83cfXXzfPtv4t7mD6qohFmlfUbs8ahDAukPCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6OcQPmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6OcQPmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C45EC4CEC5;
	Fri, 11 Oct 2024 00:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607249;
	bh=zVjXzrBoB+v+Ly71o3jpegDafoehVrmff5I4IZBIyEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l6OcQPmrGAUkhWR7AS5hHQWR7e3BTvlFam72ZDs+9PykX3/EWoWIOYB1Vsn1sJU3k
	 EDug6gd4X7pKY/aF4lSmr7RrJG3Slwefr3ID1hUmRuVH1Q+TD23WSR7D83HozntrFa
	 eow4RZdm9TkYnb3cKrOFLD0DkaXG1WEfcF5t8okwwBTNNNvGH3Pm49K9lg/31eOtgp
	 Fwkxc+SCZQPAp1jVT8TaKyifVTb6zjRRLVbmuM15Y/CWInf0wPMxrlvp0L5A2aAVDB
	 yDH9uJ1Vm8qLjPygmezZ/in7SBcF++UW3QXrCHxolqKKqpWDg54EYXDuo88ezxnh5h
	 s3/OlMjwtNjYA==
Date: Thu, 10 Oct 2024 17:40:48 -0700
Subject: [PATCH 12/25] xfs: keep a reference to the pag for busy extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640618.4175438.10788954055439694158.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

