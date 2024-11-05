Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7854021219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844561; cv=none; b=mgyyotQ0VaOnEFVaHc4R9JLkmkhZatwEiLeiWTDw+EY/5LhZShcy9JmrwcNkjDrMZEbdFfwTdPY014KLUuSNHJl7LQx2PNOIoJu3iSdTCTQuCQ18FVFVEYYzvjbs3AS2iSv1vrQ8aRTHD6/6tB3EGqRqQyOZ2uH8SalFcZUmYnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844561; c=relaxed/simple;
	bh=sNydzTANHNQSl6G87FPHe0ErqUCrWLtQjC3Ejbo3cIU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGCXJ2PhJBCcpHyNUWqu7wua0nQ5C8+bSHrNrMOHEs4X0ICEE53Uslpai9K6hOQwNebfd9snXRyfB6+iacW80keER+aX/FbrdX0KNkunqWnbzySZCqJOJBxFqrGyVrhN3UeALbpHg+wtfp342YVPzixJ2Bf/KO5VMNtM755xNNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TX5bmPjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TX5bmPjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E86C4CECF;
	Tue,  5 Nov 2024 22:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844561;
	bh=sNydzTANHNQSl6G87FPHe0ErqUCrWLtQjC3Ejbo3cIU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TX5bmPjBXOLJsCOvH1aeDKxkzVovoU8mBvDAMuNX1lK9ThTvcoFAzEgRo1MMhVUcI
	 2wnBcn2KAlbnda/lIBYb1j5B2dHjXJszJoboZTASW+JHzH5d4dKsZ5gdVQWb7JuRR1
	 ZQVGdDaCQJG6zYtwniqxA2EM8t47hB3ZiOzQwFea2hfCNaKFJ+diIkxHSow5EKS73n
	 oOs/Rufa5jfAFEWQUMAGsOkGLmHgfFvSAL/Ai489bezOarPsErY6DuOEYWaJJsDtpg
	 Eb8ID3HdcwYYtrEspaK+JgnRFeS02AsPocvP2Ul4qPaM7H1TZD8I/fs7PHPue9z56H
	 bgOJizyatbQOg==
Date: Tue, 05 Nov 2024 14:09:20 -0800
Subject: [PATCH 11/23] xfs: remove the mount field from struct
 xfs_busy_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394640.1868694.1471949155726848235.stgit@frogsfrogsfrogs>
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

The mount field is only passed to xfs_extent_busy_clear, which never uses
it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c     |    5 ++---
 fs/xfs/xfs_extent_busy.c |    1 -
 fs/xfs/xfs_extent_busy.h |    4 +---
 fs/xfs/xfs_log_cil.c     |    3 +--
 fs/xfs/xfs_trans.c       |    2 +-
 5 files changed, 5 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 5c00904e439305..e1b4a8c59d0cc8 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -81,7 +81,7 @@ xfs_discard_endio_work(
 	struct xfs_busy_extents	*extents =
 		container_of(work, struct xfs_busy_extents, endio_work);
 
-	xfs_extent_busy_clear(extents->mount, &extents->extent_list, false);
+	xfs_extent_busy_clear(&extents->extent_list, false);
 	kfree(extents->owner);
 }
 
@@ -301,7 +301,7 @@ xfs_trim_gather_extents(
 	 * we aren't going to issue a discard on them any more.
 	 */
 	if (error)
-		xfs_extent_busy_clear(mp, &extents->extent_list, false);
+		xfs_extent_busy_clear(&extents->extent_list, false);
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
 out_trans_cancel:
@@ -347,7 +347,6 @@ xfs_trim_perag_extents(
 			break;
 		}
 
-		extents->mount = pag->pag_mount;
 		extents->owner = extents;
 		INIT_LIST_HEAD(&extents->extent_list);
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 7c0595db29857f..7353f9844684b0 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -545,7 +545,6 @@ xfs_extent_busy_clear_one(
  */
 void
 xfs_extent_busy_clear(
-	struct xfs_mount	*mp,
 	struct list_head	*list,
 	bool			do_discard)
 {
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 72be61912c005f..7241035ce4ef9d 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -33,7 +33,6 @@ struct xfs_extent_busy {
  * to discard completion.
  */
 struct xfs_busy_extents {
-	struct xfs_mount	*mount;
 	struct list_head	extent_list;
 	struct work_struct	endio_work;
 
@@ -54,8 +53,7 @@ xfs_extent_busy_insert_discard(struct xfs_perag *pag, xfs_agblock_t bno,
 	xfs_extlen_t len, struct list_head *busy_list);
 
 void
-xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
-	bool do_discard);
+xfs_extent_busy_clear(struct list_head *list, bool do_discard);
 
 int
 xfs_extent_busy_search(struct xfs_perag *pag, xfs_agblock_t bno,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 80da0cf87d7a45..2e9157b650e647 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -907,7 +907,7 @@ xlog_cil_committed(
 	xlog_cil_ail_insert(ctx, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
-	xfs_extent_busy_clear(mp, &ctx->busy_extents.extent_list,
+	xfs_extent_busy_clear(&ctx->busy_extents.extent_list,
 			      xfs_has_discard(mp) && !abort);
 
 	spin_lock(&ctx->cil->xc_push_lock);
@@ -917,7 +917,6 @@ xlog_cil_committed(
 	xlog_cil_free_logvec(&ctx->lv_chain);
 
 	if (!list_empty(&ctx->busy_extents.extent_list)) {
-		ctx->busy_extents.mount = mp;
 		ctx->busy_extents.owner = ctx;
 		xfs_discard_extents(mp, &ctx->busy_extents);
 		return;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bdf3704dc30118..cee7f0564409bd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -67,7 +67,7 @@ xfs_trans_free(
 	struct xfs_trans	*tp)
 {
 	xfs_extent_busy_sort(&tp->t_busy);
-	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
+	xfs_extent_busy_clear(&tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
 	xfs_trans_clear_context(tp);

