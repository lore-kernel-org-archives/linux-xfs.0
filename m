Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BE943AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816881; cv=none; b=IklSNcRoe4DdEIFAlSEnQUjaGAS3bStEVlvOEqnf1BtubirmRlJChJm3e2Oryoqiio5wVlW973yKCwyBcNQGbw8OjiaOF4Np3+jE1ndL0daRIQ6ps0lxYS+wd9GNSnkcf3bVLBlit7u21BH7auiZlyKlxS4frdgQ9+CIAFs8hnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816881; c=relaxed/simple;
	bh=eduwgg6oluvmy/Ijcr3445BXfJGhD/QllXswlIQbQ0o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIvGdkhMwBb6vwibgL2jt8ixZcsNohMzgSxqYxv64wdwiNzACLVwdZZsdnDhGZ5lAVU8NKKHONv3KovQ0m+SPcXDYJpZbOP5s4wGCJ7+C3FA3zF4BR4y9XwNea7gb83wac1EyQIsYK2z3DUOxkMpjwaDUZHechwliIFO3BzlYBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiJ92s4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiJ92s4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27623C433C7;
	Thu,  1 Feb 2024 19:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816881;
	bh=eduwgg6oluvmy/Ijcr3445BXfJGhD/QllXswlIQbQ0o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BiJ92s4rHtpxHo5wfVWpQO+u26KqPvdfIJ6xHzN8o5kDZwzq9KSJOxALflNz88rvd
	 5nYBCG2XhRH4mnqO1uteEiWk9UZoJ/vF9lj8jt8rVIhsnolPd72ZMqt14Em5mBU9CO
	 NyTMRk2eEeuDQmH7eQtX3aJLGnZHF0PTChz2+df9dI5vx658y/md7Fy0DfVxsCDRpn
	 AlmeLHQGueK2mnVgoWY0QHBaRN65qWk+SpSE/rnJmUY3SLfb3uE9SqCYiCrf4mWS1g
	 iZq+Per1wYKZ4PvG/TP2xiEb3LEKtrrAT8HN+04lGJ3huHwWThvh3Obumx4ZzJJIrx
	 K8lkn8oZbvkfQ==
Date: Thu, 01 Feb 2024 11:48:00 -0800
Subject: [PATCH 09/27] xfs: remove xfs_refcountbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334932.1605438.2814627786548431428.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount_btree.c |   14 --------------
 fs/xfs/libxfs/xfs_refcount_btree.h |    2 --
 fs/xfs/scrub/refcount_repair.c     |    4 ++--
 3 files changed, 2 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 57710856ae347..4dcf6295e683b 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -376,20 +376,6 @@ xfs_refcountbt_init_cursor(
 	return cur;
 }
 
-/* Create a btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_refcountbt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xbtree_afakeroot	*afake,
-	struct xfs_perag	*pag)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_refcountbt_init_cursor(mp, NULL, NULL, pag);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Swap in the new btree root.  Once we pass this point the newly rebuilt btree
  * is in place and we have to kill off all the old btree blocks.
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index d66b37259bedb..1e0ab25f6c680 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -48,8 +48,6 @@ struct xbtree_afakeroot;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		struct xfs_perag *pag);
-struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 9c39af03ee1d8..8240c993061b2 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -658,8 +658,8 @@ xrep_refc_build_new_tree(
 	rr->new_btree.bload.claim_block = xrep_refc_claim_block;
 
 	/* Compute how many blocks we'll need. */
-	refc_cur = xfs_refcountbt_stage_cursor(sc->mp, &rr->new_btree.afake,
-			pag);
+	refc_cur = xfs_refcountbt_init_cursor(sc->mp, NULL, NULL, pag);
+	xfs_btree_stage_afakeroot(refc_cur, &rr->new_btree.afake);
 	error = xfs_btree_bload_compute_geometry(refc_cur,
 			&rr->new_btree.bload,
 			xfarray_length(rr->refcount_records));

