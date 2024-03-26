Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4289E21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424614; cv=none; b=gUwB0kaN1KQdf8Fx7P+qxOyMOoLi4sJuqBgf2xqvWL+MWXMcwhbQBtz30nioH/w2H7DXgGCQoVTz+0EayjNUFdAGhnqhkrPPu+ANbvNfMkYk6w2IZYH1Ny8GroeZ9iLVeFaJUu+VVwc/WzyP/lBXisE4e7YMudLQY+Ym8qXuxEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424614; c=relaxed/simple;
	bh=oF0AIxVTOPVr3Nx6iWOKkzLbW9khkYV0XW6D5iT/VM4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tszbG9z+bF84UUzIzfufrmNjP+YomJXsDtc2G4xULadYLgWpcM09vEB2gq/HHUn0LfJXBZg5Noh6crb6QDrwWm7rWbESt3mbyW4jjj8PEgp2GfhP2jr0xeBGc4UdbOqgwrJL4VFwkmYRr8XbWITHaqnXovaOH+9GTxisWlg+9Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iM53f4Ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iM53f4Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEF5C433C7;
	Tue, 26 Mar 2024 03:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424613;
	bh=oF0AIxVTOPVr3Nx6iWOKkzLbW9khkYV0XW6D5iT/VM4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iM53f4Ka/5b4tWy5FTYmKLpC6m7pnai1WJbC80NSRLi8qwII2OTBNlHwQYKvrlJZN
	 EK6mqy/USExVNEfHanvmt6vfrZ5HOON7reL8M34nDJEZk9oi5Xe6MHzzEwXR8KW/Xb
	 irwWRH7T6Pcae3Le0+qMMCqWhzpSpzqm/48ugJBstXbJWZQ6dheRwV4+U9E+KmR6vi
	 JszwukcF9p0hmtOUnbocWmXBbd0ffj0J3KPMlk+CKLwSLZcb9Lv9/u7jAVC8ALQpZ9
	 HT4zpDBdPmqv866OnVKMqpuC68kFjTtu3bqvRjHIKqs0ubIqQ61B1ZmqivwV+oZxI6
	 o+n9w4W+vm3+w==
Date: Mon, 25 Mar 2024 20:43:33 -0700
Subject: [PATCH 058/110] xfs: remove xfs_refcountbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132219.2215168.4618412656606334183.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: a5c2194406f322e91b90fb813128541a9b4fed6a

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount_btree.c |   14 --------------
 libxfs/xfs_refcount_btree.h |    2 --
 repair/agbtree.c            |    4 ++--
 3 files changed, 2 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index c1ae76949692..760163ca414e 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -375,20 +375,6 @@ xfs_refcountbt_init_cursor(
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
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index d66b37259bed..1e0ab25f6c68 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -48,8 +48,6 @@ struct xbtree_afakeroot;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		struct xfs_perag *pag);
-struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 22e31c47a827..395ced6cffcb 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -719,8 +719,8 @@ init_refc_cursor(
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, est_agfreeblocks, btr);
-	btr->cur = libxfs_refcountbt_stage_cursor(sc->mp, &btr->newbt.afake,
-			pag);
+	btr->cur = libxfs_refcountbt_init_cursor(sc->mp, NULL, NULL, pag);
+	libxfs_btree_stage_afakeroot(btr->cur, &btr->newbt.afake);
 
 	btr->bload.get_records = get_refcountbt_records;
 	btr->bload.claim_block = rebuild_claim_block;

