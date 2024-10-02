Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135478F54
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832145; cv=none; b=ej37GqnmUXxiEtUhuu8T8WtuDly2voHhOrFatOl92b7+24V7/k4bNGAohw0njtTK7yVhVq4J9B2Xb5nP+kwRFyQ9oO1/2yjFbdALyvYrlRYj1PK+7eVW5z4SUbjmZvl9DUzNjB/qCIusFqrhBqO62oZ44E0r0KpdkzAqcwdLPC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832145; c=relaxed/simple;
	bh=dTCIbgYJznjfWiLH4O3k9JBIlbZisfgXDbQJeriSvgs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYTeIdc9vCUoiX8fgBfZyKdNygBaW+fuZ4+73nCvALBUwVNm5Eq1HXLkSo6wLobaR1+PC0xzLem0D0zzeYv2pxDRFvFxtJ9ys23XZvEBs5JL3z9fcbCPLB6HAL9oaQ1cAcF5bkHVBzYHLk142XIUFlcmHnWSLvjIL8I7pNIdUmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKbIq12z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKbIq12z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF441C4CEC6;
	Wed,  2 Oct 2024 01:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832144;
	bh=dTCIbgYJznjfWiLH4O3k9JBIlbZisfgXDbQJeriSvgs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kKbIq12zBtFrDDapUTyDTWxeStq7AMi87r9sU6I4zzS2HgeQbZII9TrBc1qniWmBP
	 vis7du6aXAWWesvdd08S4qcA4wi5DrK80lTVbdnQBB6D7Gxe6pNJjHESGFB1JwvmbC
	 vpE4Kz7JVt0qZLoUdKbAYy/9wE2gsJLzYqOYdMIBAch3Ykw/ykmWosOtIjlFyWqdIT
	 voZyTxcEi0hIlqu6VHjnmwp6Xr0nrm2KuGN21EZ9Z76sRD4x/hJwGv31rZ5z99AwbR
	 T/wElA2KLc7PzXSJePl4tT53FkSqHthA/2mKqOCAXUm/0NVeu+8G/i5MbFqCpUlpMs
	 Vu/QocETURpLw==
Date: Tue, 01 Oct 2024 18:22:24 -0700
Subject: [PATCH 56/64] xfs: simplify usage of the rcur local variable in
 xfs_refcount_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102626.4036371.1349742062847524118.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: e51987a12cb57ca3702bff5df8a615037b2c8f8a

Only update rcur when we know the final *pcur value.

Inspired-by: Christoph Hellwig <hch@lst.de>
[djwong: don't leave the caller with a dangling ref]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 4b9a8be36..d0a057f5c 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1340,7 +1340,7 @@ xfs_refcount_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
 	xfs_agblock_t			bno;
@@ -1358,7 +1358,6 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
@@ -1372,11 +1371,11 @@ xfs_refcount_finish_one(
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

