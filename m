Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C660C13A256
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441662; cv=none; b=JR7MMU/3n9QjYYp0YAk0Uj1hEFEcmfIzFkAd9dqtRuqnD+XqYD2CLl8yc7wTc41JcGL4xjGkpE5XAHTIeDOAG02G8+CKiKVmOqtDSXZw1nrbAubgvdHd6Ye8WpSyz2hoREqoIwgzPT2FmSNdM2hGTO6RB2F2/fJXp0tqERe25Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441662; c=relaxed/simple;
	bh=iFfTlAOOpdL+JJhlnsrD7tsVG5n2QTNNPrUe0ToEAs4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRHX5Ay9yAVk4PQPxtxe0TCoJguUIDKV/Abaqy8kC/trmIFcjy8Xuvf36jolYnJKBwP7AnT+e9skl5u5kHG3u7QQ2HSixcQV+zwWKgfgNxKeNZ9OIvUu0SYHzbVUfcLqWdCO5ZKRhf8/njqvEeRF9O8WSuSf4xaN5cmuPILz3sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EyMRRfC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyMRRfC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53030C2BD10;
	Mon,  3 Jun 2024 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441662;
	bh=iFfTlAOOpdL+JJhlnsrD7tsVG5n2QTNNPrUe0ToEAs4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EyMRRfC1Jtdyuvt8VyiZ/BAfuZRUKC0NmJIbJyJWW5t+tPNT35ACLPjWEnIo1JSV+
	 26k6hl+jb7+wt4f+CzK+ARjT0lckv6bTnKMQq6awjiJg2ubqX5wnkZ02BkSDsTLsYU
	 NmT+CNSbYtXAW6+RAcPDC1zERKyY25tpNdia14g55NECsNE9LuAO6EPPDn91gMKDJa
	 Ic5GRWeWHBf3E86g2Iy+7ANtiMQi7H7y2DmFnqaTW4Rc0LfXzClWAhollRGpvl0CyV
	 WTE11Eh8gzJ+KrCwIgWsylPEdajiZ6qTJRrBimdnFOkVvmYcfwOPCPm2cdLicHIiYl
	 Ja/hIM8eJ90Mg==
Date: Mon, 03 Jun 2024 12:07:41 -0700
Subject: [PATCH 060/111] xfs: remove xfs_rmapbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040275.1443973.2710537060785707861.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1317813290be04bc37196c4adf457712238c7faa

xfs_rmapbt_stage_cursor is currently unused, but future callers can
trivially open code the two calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_rmap_btree.c |   14 --------------
 libxfs/xfs_rmap_btree.h |    2 --
 repair/agbtree.c        |    3 ++-
 3 files changed, 2 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index fabab29e2..5fad7f20b 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -526,20 +526,6 @@ xfs_rmapbt_init_cursor(
 	return cur;
 }
 
-/* Create a new reverse mapping btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_rmapbt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xbtree_afakeroot	*afake,
-	struct xfs_perag	*pag)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_rmapbt_init_cursor(mp, NULL, NULL, pag);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Install a new reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 3244715dd..27536d7e1 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -44,8 +44,6 @@ struct xbtree_afakeroot;
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
 				struct xfs_perag *pag);
-struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 int xfs_rmapbt_maxrecs(int blocklen, int leaf);
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 395ced6cf..ab97c1d79 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -637,7 +637,8 @@ init_rmapbt_cursor(
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr);
-	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, pag);
+	btr->cur = libxfs_rmapbt_init_cursor(sc->mp, NULL, NULL, pag);
+	libxfs_btree_stage_afakeroot(btr->cur, &btr->newbt.afake);
 
 	btr->bload.get_records = get_rmapbt_records;
 	btr->bload.claim_block = rebuild_claim_block;

