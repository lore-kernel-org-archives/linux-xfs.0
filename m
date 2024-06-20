Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B122514374E
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925102; cv=none; b=Fr/c4f5tisMAv/g0fDZlRx1+oaPYO+tatfgHjsZg1IYLzsDpnJxVky1ROOOvieSQD8ntECLhcoon/bhypu1BRw51UitfHxZhwqMbk1/xSbGQAvkr6CK35tUy2OXf7Q/x5AQpDozbWQeyPcZJ46D3Zb4nkIPRXjaRvUDLvsqxEyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925102; c=relaxed/simple;
	bh=eR2jrI5Q9F2z0pcvj2CigA1FRfkeZRMFnOa+Zez2BJw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XMcCJ5gVxUEBBYa5qBe8K7NpqWbqcRwm26d9jSPgRZ7vQIjsF3+cUzUeyDDcx1asgM5tELuLwrv7AbjqHncK7alWShYPy0cMi1UIDY8dE/WsIJjD9ReSAtIxEjOq+qZtulycYvQw6Q+z/ABTI5upl7Nz9LWUqsrtdkPYR0CM/dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITL2G88c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITL2G88c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E99C2BD10;
	Thu, 20 Jun 2024 23:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925102;
	bh=eR2jrI5Q9F2z0pcvj2CigA1FRfkeZRMFnOa+Zez2BJw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ITL2G88cVuNTKZzzKLKLTUYX5TUz7U/K/SBclInPxL4RqSKKbzxtUK8noLg+Ih9++
	 stYnN9HSm7QqeM5t+z85YE3eWeFp1WB3XuTRtTCazoK/60oTJMnwGo8qFKhZBzhsG2
	 ptWYSNLcFyoHJCz7exleVQ+iL5tziAcQtrgYvhEORgJZasLTPIgLu0pVqPppJZNtSK
	 h0SJ8qcQD/HkAUkL7ZyUmI6yVJYwdYePNytKcN9jVuTLC8BunZ0HASDRTfRGuS6LO3
	 xif3qOfLou0aJ+X+p+dkA5ss9ONGC0ID8mOOaRcCxJR0VlAjLa8cqZEibKW13pKcfM
	 8IG40ZW7CTufw==
Date: Thu, 20 Jun 2024 16:11:41 -0700
Subject: [PATCH 09/10] xfs: simplify usage of the rcur local variable in
 xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419926.3184748.7669666442192075027.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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

Only update rcur when we know the final *pcur value.

Inspired-by: Christoph Hellwig <hch@lst.de>
[djwong: don't leave the caller with a dangling ref]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 10a16635d93f2..4137a8d1ac13d 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1341,7 +1341,7 @@ xfs_refcount_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
 	xfs_agblock_t			bno;
@@ -1359,7 +1359,6 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
@@ -1373,11 +1372,11 @@ xfs_refcount_finish_one(
 		if (error)
 			return error;
 
-		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		*pcur = rcur = xfs_refcountbt_init_cursor(mp, tp, agbp,
+							  ri->ri_pag);
 		rcur->bc_refc.nr_ops = nr_ops;
 		rcur->bc_refc.shape_changes = shape_changes;
 	}
-	*pcur = rcur;
 
 	switch (ri->ri_type) {
 	case XFS_REFCOUNT_INCREASE:

