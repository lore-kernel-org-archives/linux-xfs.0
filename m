Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1573DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot0oJJqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B573C433C8;
	Fri, 24 Nov 2023 23:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869708;
	bh=GJ3J5me8622dszUZcHW3PkIi/ftx8AiurRqzvIMU/Rs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ot0oJJqBGeDgW/UogeW2KMtIUKzgXYL4EdDGoJnrWmBmi6lLyTOhDEqaG/cHgb8TF
	 gE9Jj73KUfdeHBfIT9CLFubDDmOLnVdbza8SK+AqUyuSv3f+jYVT7hq1Vcm+OhTov0
	 AJfcCuHiitv8j1d3ISn/LkDyYGjOMR8DzcXjxwbOFMmtj9Fx/XVLOac2iqhvV1MiRf
	 qAZWh6RC9SPUlx3RASzBV3YQ6luae/GO2qKGPtEFf2UuFSkCWcMm3ATph+KVzrXpH4
	 DtvcAN1QMUunwQMsv+StnmdYdZZ+3vZG3+uiiMrLGsSp7e7OgcZ1aqd22SueJ5OQ35
	 QC5CBrH6zErFw==
Date: Fri, 24 Nov 2023 15:48:28 -0800
Subject: [PATCH 6/7] xfs: log EFIs for all btree blocks being used to stage a
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086926222.2768790.3545458743634941117.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
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

We need to log EFIs for every extent that we allocate for the purpose of
staging a new btree so that if we fail then the blocks will be freed
during log recovery.  Use the autoreaping mechanism provided by the
previous patch to attach paused freeing work to the scrub transaction.
We can then mark the EFIs stale if we decide to commit the new btree, or
we can unpause the EFIs if we decide to abort the repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/newbt.c |   34 ++++++++++++++++++++++++++--------
 fs/xfs/scrub/newbt.h |    3 +++
 2 files changed, 29 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 4e8d6637426e4..2932fd317ab23 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -136,6 +136,7 @@ xrep_newbt_add_blocks(
 {
 	struct xfs_mount		*mp = xnr->sc->mp;
 	struct xrep_newbt_resv		*resv;
+	int				error;
 
 	resv = kmalloc(sizeof(struct xrep_newbt_resv), XCHK_GFP_FLAGS);
 	if (!resv)
@@ -147,8 +148,18 @@ xrep_newbt_add_blocks(
 	resv->used = 0;
 	resv->pag = xfs_perag_hold(pag);
 
+	ASSERT(xnr->oinfo.oi_offset == 0);
+
+	error = xfs_alloc_schedule_autoreap(args, true, &resv->autoreap);
+	if (error)
+		goto out_pag;
+
 	list_add_tail(&resv->list, &xnr->resv_list);
 	return 0;
+out_pag:
+	xfs_perag_put(resv->pag);
+	kfree(resv);
+	return error;
 }
 
 /* Don't let our allocation hint take us beyond this AG */
@@ -327,16 +338,21 @@ xrep_newbt_free_extent(
 	if (!btree_committed || resv->used == 0) {
 		/*
 		 * If we're not committing a new btree or we didn't use the
-		 * space reservation, free the entire space extent.
+		 * space reservation, let the existing EFI free the entire
+		 * space extent.
 		 */
-		goto free;
+		trace_xrep_newbt_free_blocks(sc->mp, resv->pag->pag_agno,
+				free_agbno, free_aglen, xnr->oinfo.oi_owner);
+		xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
+		return 1;
 	}
 
 	/*
-	 * We used space and committed the btree.  Remove the written blocks
-	 * from the reservation and possibly log a new EFI to free any unused
-	 * reservation space.
+	 * We used space and committed the btree.  Cancel the autoreap, remove
+	 * the written blocks from the reservation, and possibly log a new EFI
+	 * to free any unused reservation space.
 	 */
+	xfs_alloc_cancel_autoreap(sc->tp, &resv->autoreap);
 	free_agbno += resv->used;
 	free_aglen -= resv->used;
 
@@ -348,7 +364,6 @@ xrep_newbt_free_extent(
 
 	ASSERT(xnr->resv != XFS_AG_RESV_AGFL);
 
-free:
 	/*
 	 * Use EFIs to free the reservations.  This reduces the chance
 	 * that we leak blocks if the system goes down.
@@ -408,9 +423,10 @@ xrep_newbt_free(
 	/*
 	 * If we still have reservations attached to @newbt, cleanup must have
 	 * failed and the filesystem is about to go down.  Clean up the incore
-	 * reservations.
+	 * reservations and try to commit to freeing the space we used.
 	 */
 	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
 		list_del(&resv->list);
 		xfs_perag_put(resv->pag);
 		kfree(resv);
@@ -488,5 +504,7 @@ xrep_newbt_claim_block(
 								agbno));
 	else
 		ptr->s = cpu_to_be32(agbno);
-	return 0;
+
+	/* Relog all the EFIs. */
+	return xrep_defer_finish(xnr->sc);
 }
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index ca53271f3a4c6..d2baffa17b1ae 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -12,6 +12,9 @@ struct xrep_newbt_resv {
 
 	struct xfs_perag	*pag;
 
+	/* Auto-freeing this reservation if we don't commit. */
+	struct xfs_alloc_autoreap autoreap;
+
 	/* AG block of the extent we reserved. */
 	xfs_agblock_t		agbno;
 

