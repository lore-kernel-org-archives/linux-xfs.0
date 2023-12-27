Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B5E1362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViPM225u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDF5C433C7;
	Mon,  1 Jan 2024 00:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069285;
	bh=gRx+OHYqQKFjzb3CAvRdMnJdHn/SYYaJ/ItmIQXIMgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ViPM225uWUubrY6lriabnkf+iFTF2mZTYL0HuPPRH3Lgx5r81Tvo3kSewp/9+q0wa
	 +DbtLq9WW2FVq1JwopACaL1W5uVBjuYHbpr6UU3LPQHN1vHHrl1sSjvUEFIwY4Goin
	 K+f0emzC0fdzN7wrNs+ts0iwcYwkTxNYgFQs4Cj/jBXpSb6GlqJDjTudjPReougO+f
	 boNVEVdC0fJttgHIU/RPU67NMQuObSvjBYpsmACF/1jZSlR4HZqAXD2zTtvww8667r
	 tRrtNOsolwlmNs65Z9TeEt6Xe3QEx8QmH1ZZsbiS6myGvw6NRmyEx/88QRnr67tEzN
	 TeCT/E56LXing==
Date: Sun, 31 Dec 2023 16:34:45 +9900
Subject: [PATCH 33/42] xfs_repair: compute refcount data for the realtime
 groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017567.1817107.13512075903044003457.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

At the end of phase 4, compute reference count information for realtime
groups from the realtime rmap information collected, just like we do for
AGs in the data section.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase4.c |   19 ++++++++++++++++++-
 repair/rmap.c   |   17 ++++++++++++-----
 repair/rmap.h   |    2 +-
 3 files changed, 31 insertions(+), 7 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index b0cb805f30c..e90533689e0 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -173,13 +173,28 @@ compute_ag_refcounts(
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
@@ -227,6 +242,8 @@ process_rmap_data(
 	create_work_queue(&wq, mp, platform_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, compute_ag_refcounts, i, NULL);
+	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+		queue_work(&wq, compute_rt_refcounts, i, NULL);
 	destroy_work_queue(&wq);
 
 	create_work_queue(&wq, mp, platform_nproc());
diff --git a/repair/rmap.c b/repair/rmap.c
index 55b41cfa540..38a508ced16 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -135,6 +135,11 @@ rmaps_init_rt(
 	if (error)
 		goto nomem;
 
+	error = init_slab(&ag_rmap->ar_refcount_items,
+			  sizeof(struct xfs_refcount_irec));
+	if (error)
+		goto nomem;
+
 	ag_rmap->rg_rmap_ino = NULLFSINO;
 	ag_rmap->rg_refcount_ino = NULLFSINO;
 	return;
@@ -1080,6 +1085,7 @@ mark_reflink_inodes(
 static void
 refcount_emit(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
@@ -1089,7 +1095,7 @@ refcount_emit(
 	int			error;
 	struct xfs_slab		*rlslab;
 
-	rlslab = rmaps_for_group(false, agno)->ar_refcount_items;
+	rlslab = rmaps_for_group(isrt, agno)->ar_refcount_items;
 	ASSERT(nr_rmaps > 0);
 
 	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
@@ -1208,6 +1214,7 @@ refcount_push_rmaps_at(
 int
 compute_refcounts(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno)
 {
 	struct rcbag		*rcstack;
@@ -1223,12 +1230,12 @@ compute_refcounts(
 
 	if (!xfs_has_reflink(mp))
 		return 0;
-	if (rmaps_for_group(false, agno)->ar_xfbtree == NULL)
+	if (rmaps_for_group(isrt, agno)->ar_xfbtree == NULL)
 		return 0;
 
-	nr_rmaps = rmap_record_count(mp, false, agno);
+	nr_rmaps = rmap_record_count(mp, isrt, agno);
 
-	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rmcur);
+	error = rmap_init_mem_cursor(mp, NULL, isrt, agno, &rmcur);
 	if (error)
 		return error;
 
@@ -1285,7 +1292,7 @@ compute_refcounts(
 			ASSERT(nbno > cbno);
 			if (rcbag_count(rcstack) != old_stack_height) {
 				if (old_stack_height > 1) {
-					refcount_emit(mp, agno, cbno,
+					refcount_emit(mp, isrt, agno, cbno,
 							nbno - cbno,
 							old_stack_height);
 				}
diff --git a/repair/rmap.h b/repair/rmap.h
index 3e210fac87b..9663b3e3a20 100644
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

