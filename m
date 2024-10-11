Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D87E1FC8
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607265; cv=none; b=YneWwF/ZsZdUKQ/PKaQ30ZtVPGyhogkfPSKAb6BKhb/6pZs2WIyrVIBaTL/UfCMhX5I0sdqsHJcDOuRJwfip+Nf+L7RC90F5mDPRZ1IMBNs9r7xzGE5sG8kCpoO583Y4zBXrAHmXIJPe8yj1M7RbBgLw+vt7kXOO5DTrNul/CGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607265; c=relaxed/simple;
	bh=G9g7oelG5HgAtWFZakMn0oESZgUvKcN925y9BNrtdIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kt5/djz816pkfqzBTVs6DowJetQLa93VrUEmk+yVaGxBYTaapGvjJ1P+gAB//9aJpOLueYy+4zldkWaG1P8YOWAwx97O+dSAkdurdETLp5ZYxKqt1Tk+FzPpuiiEc7qXtfSdnpd0kBiY4RAb5oG1FvoL6YcbdV/IHe+c2DL4Y9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ia08k8VB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ia08k8VB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67BFC4CEC5;
	Fri, 11 Oct 2024 00:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607264;
	bh=G9g7oelG5HgAtWFZakMn0oESZgUvKcN925y9BNrtdIs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ia08k8VBgyQsr6GtmlAtcvHJuse4GUUmQLxNrMzTA3ugmPxs0qoqa6FlbUddBOLV1
	 c0tF8dV6Pm3t4VkI/ASI9mL8ljcKuJOfFVqdtfRk4FnZVazecMgRIuuerAuZhjWnQw
	 5T+JHh1ZWIiaxhvwX2n8LLRoJzJMncnI2wQChBlttCwiyNqMpC40SGiumQlwz0YXxC
	 QPEZWvO1qN82spCX2Tx9ffWymqEYXC7tMlee/L/q1YqxId+/qOMHCgGLoItedRP4eK
	 G2AKdK7kkXt78GLI+9t0HmrXTmIymaoiddwtDuLgNy2D4kvhI7oSMrFynEu0PAZ4sN
	 G9kMyjoL+Jtlw==
Date: Thu, 10 Oct 2024 17:41:04 -0700
Subject: [PATCH 13/25] xfs: remove the mount field from struct
 xfs_busy_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640635.4175438.410788615255088887.stgit@frogsfrogsfrogs>
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
index 391a938d690c59..1764ab590f4658 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -910,7 +910,7 @@ xlog_cil_committed(
 	xlog_cil_ail_insert(ctx, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
-	xfs_extent_busy_clear(mp, &ctx->busy_extents.extent_list,
+	xfs_extent_busy_clear(&ctx->busy_extents.extent_list,
 			      xfs_has_discard(mp) && !abort);
 
 	spin_lock(&ctx->cil->xc_push_lock);
@@ -920,7 +920,6 @@ xlog_cil_committed(
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

