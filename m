Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19BF2417C9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882825; cv=none; b=B+C6Jx6L7DG6/bgAgSxOz5ru4yOXWPO1IAe/GQtlNvxdwg15tmXMkh4v/2NPeg14QUXnXH/90WIBFel1Mdx6sEKlc9gF4SLw5Q9g8LVpTrHkp1Mtx3V2N9ebqZmntIGnhVRMGRWLa1s3qJf45qhOFM6FNucgDnE8EeXybCkh5gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882825; c=relaxed/simple;
	bh=jkpuSZgOJfZtZtXi9uecRZKMCPxX672uVCQsj6GdIpw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LYvmH9BURx4YTW6ZjN/1jFmMQwNqHhmoUOPMspG8kPUJEPFqrT9UxAyixiUlakzoVf1OAEdhU+mysH0z/O/67IcMhxGv9r/jfTOFb7hltiOb20Vl1CusqB+z11aOdelrsbHYwJbuhQKXkEw3sVTFf/snsRyVe4hNg+sF7c3Uprc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajtCWMit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajtCWMit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2E5C4CEDD;
	Thu,  6 Feb 2025 23:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882825;
	bh=jkpuSZgOJfZtZtXi9uecRZKMCPxX672uVCQsj6GdIpw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ajtCWMitZ3GCelkF/8Xjh/9N/bQJKukhf+YfvJ+OHcpJHlc2IsPlY26SGYr4s50b+
	 eyRP9HND2V/mjdz6o5nupHurMRhhgGsGeGDNx4/aupoj4EuDHjpnrf9P1+pTfXD8lA
	 1ACzGTsXHlFKfThBUsGMCJj+lwKLkDuwIEvHk/5+OBv5TXF0NJWlztjHDXITW7oG6b
	 l6/c6iK1UjIWlh+kzo92lJvJalzBYBURFWhjvMsnSCyfF1jgvcWda55Ed5d1pI9pl2
	 VSYW2K9HXX7IRsmdgfvS+zHkmG+EwufuDx05Ruxny1t+HJDHjsDB3rc39Pr/9zDObi
	 bLUIUIYV/A1jQ==
Date: Thu, 06 Feb 2025 15:00:25 -0800
Subject: [PATCH 14/22] xfs_repair: compute refcount data for the realtime
 groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089146.2741962.17033508683404359801.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

At the end of phase 4, compute reference count information for realtime
groups from the realtime rmap information collected, just like we do for
AGs in the data section.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase4.c |   21 ++++++++++++++++++++-
 repair/rmap.c   |   17 ++++++++++++-----
 repair/rmap.h   |    2 +-
 3 files changed, 33 insertions(+), 7 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 29efa58af33178..4cfad1a6911764 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -177,13 +177,28 @@ compute_ag_refcounts(
 {
 	int		error;
 
-	error = compute_refcounts(wq->wq_ctx, agno);
+	error = compute_refcounts(wq->wq_ctx, false, agno);
 	if (error)
 		do_error(
 _("%s while computing reference count records.\n"),
 			 strerror(error));
 }
 
+static void
+compute_rt_refcounts(
+	struct workqueue*wq,
+	xfs_agnumber_t	rgno,
+	void		*arg)
+{
+	int		error;
+
+	error = compute_refcounts(wq->wq_ctx, true, rgno);
+	if (error)
+		do_error(
+_("%s while computing realtime reference count records.\n"),
+			 strerror(error));
+}
+
 static void
 process_inode_reflink_flags(
 	struct workqueue	*wq,
@@ -233,6 +248,10 @@ process_rmap_data(
 	create_work_queue(&wq, mp, platform_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, compute_ag_refcounts, i, NULL);
+	if (xfs_has_rtreflink(mp)) {
+		for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+			queue_work(&wq, compute_rt_refcounts, i, NULL);
+	}
 	destroy_work_queue(&wq);
 
 	create_work_queue(&wq, mp, platform_nproc());
diff --git a/repair/rmap.c b/repair/rmap.c
index e39c74cc7b44f7..64a9f06d0ee915 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -125,6 +125,11 @@ rmaps_init_rt(
 	if (error)
 		goto nomem;
 
+	error = init_slab(&ag_rmap->ar_refcount_items,
+			  sizeof(struct xfs_refcount_irec));
+	if (error)
+		goto nomem;
+
 	return;
 nomem:
 	do_error(
@@ -878,6 +883,7 @@ mark_reflink_inodes(
 static void
 refcount_emit(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
@@ -887,7 +893,7 @@ refcount_emit(
 	int			error;
 	struct xfs_slab		*rlslab;
 
-	rlslab = rmaps_for_group(false, agno)->ar_refcount_items;
+	rlslab = rmaps_for_group(isrt, agno)->ar_refcount_items;
 	ASSERT(nr_rmaps > 0);
 
 	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
@@ -1005,6 +1011,7 @@ refcount_push_rmaps_at(
 int
 compute_refcounts(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno)
 {
 	struct xfs_btree_cur	*rmcur;
@@ -1020,12 +1027,12 @@ compute_refcounts(
 
 	if (!xfs_has_reflink(mp))
 		return 0;
-	if (!rmaps_has_observations(rmaps_for_group(false, agno)))
+	if (!rmaps_has_observations(rmaps_for_group(isrt, agno)))
 		return 0;
 
-	nr_rmaps = rmap_record_count(mp, false, agno);
+	nr_rmaps = rmap_record_count(mp, isrt, agno);
 
-	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, NULL, isrt, agno, &rmcur);
 	if (error)
 		return error;
 
@@ -1082,7 +1089,7 @@ compute_refcounts(
 			ASSERT(nbno > cbno);
 			if (rcbag_count(rcstack) != old_stack_height) {
 				if (old_stack_height > 1) {
-					refcount_emit(mp, agno, cbno,
+					refcount_emit(mp, isrt, agno, cbno,
 							nbno - cbno,
 							old_stack_height);
 				}
diff --git a/repair/rmap.h b/repair/rmap.h
index c0984d97322861..98f2891692a6f8 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -38,7 +38,7 @@ extern int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
 extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 		struct xfs_rmap_irec *key);
 
-extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
+int compute_refcounts(struct xfs_mount *mp, bool isrt, xfs_agnumber_t agno);
 uint64_t refcount_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void refcount_avoid_check(struct xfs_mount *mp);

