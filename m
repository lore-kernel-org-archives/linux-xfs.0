Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53C8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiLaDCq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaDCp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:02:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF1E15816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EAB961D18
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E40C433D2;
        Sat, 31 Dec 2022 03:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455763;
        bh=GmrVkhDT8NTZSSiauui5n9ZOOBhCjZ/yPrAtJxRDPDc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DevjJ+ObwIGmZaDiQN5JnZTU5x0axFFXrg0wmd+usvxvcklB/w8msMietOFKQtncT
         mqc80axeXiTGxOFjtR6gKWZGIS8gF9q7j097m8wf6q+/8GL5qQ/9OdyTj/QW8MLGKf
         C8TQGJ0NsiBlFi1emFsamlYLejcl2dDIvf58K7OIELHACeiEv24AW1uCo9coSMfRvM
         USGzyWxKAiObr+Ifg/HIT6z6p9K1bRA2bW6EdlrDLw9nl2G4A+e9461N9tmZ2wcnc/
         pdVMO0GaGUVP8+SaEoyrKQLFMsM4REFfAV3lL9Qm6k1MxRooZfJA0cVUmmgXukAoiO
         FIsikqhyPU5AA==
Subject: [PATCH 33/41] xfs_repair: compute refcount data for the realtime
 groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:12 -0800
Message-ID: <167243881206.734096.5199782891222181431.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 9394720a1b6..85fc05945c6 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -137,6 +137,11 @@ rmaps_init_rt(
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
@@ -1061,6 +1066,7 @@ mark_reflink_inodes(
 static void
 refcount_emit(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
@@ -1070,7 +1076,7 @@ refcount_emit(
 	int			error;
 	struct xfs_slab		*rlslab;
 
-	rlslab = rmaps_for_group(false, agno)->ar_refcount_items;
+	rlslab = rmaps_for_group(isrt, agno)->ar_refcount_items;
 	ASSERT(nr_rmaps > 0);
 
 	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
@@ -1189,6 +1195,7 @@ refcount_push_rmaps_at(
 int
 compute_refcounts(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno)
 {
 	struct rcbag		*rcstack;
@@ -1204,12 +1211,12 @@ compute_refcounts(
 
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
 
@@ -1266,7 +1273,7 @@ compute_refcounts(
 			ASSERT(nbno > cbno);
 			if (rcbag_count(rcstack) != old_stack_height) {
 				if (old_stack_height > 1) {
-					refcount_emit(mp, agno, cbno,
+					refcount_emit(mp, isrt, agno, cbno,
 							nbno - cbno,
 							old_stack_height);
 				}
diff --git a/repair/rmap.h b/repair/rmap.h
index 4f49b19062c..4d20d90812b 100644
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

