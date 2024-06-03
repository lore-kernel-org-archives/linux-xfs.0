Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A16259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441600; cv=none; b=fPKi59r4Dp5XiuhEjBbfBJlEAgX9FLcqBHIcjujx4K3umXCV0SBTbS7pEQ4Dcq2nyd5q8HjucdcKNXsoWj3weo7QrbzfYB5Z3ipZvwuHPBsRiEk+l61uS6yTJNzRMwIMAxoeqRd6yN3+FhmaTkAhdgqyIripPfZdgoiukp1hyjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441600; c=relaxed/simple;
	bh=0G94kGOf7vUDYBPPQjZh7vu9/jZT+WN7eC7F9FzgzKU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FzB8n+jia8tICHlpSGuseqKvFE99YH1V0NxtIiVUYjXy9oPFjYGmTMz2hotbx+t9s6Q8rrzG/SRLYY0Hn7HntMgkoHA9lECZkE5lY0QpcnlKls1IPCKsWFZZpOfTxIBeSsbrF3kiJK+8vavlesrgBGrILlh3vxmynaI65FyCec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwVbLDjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwVbLDjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB23C2BD10;
	Mon,  3 Jun 2024 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441599;
	bh=0G94kGOf7vUDYBPPQjZh7vu9/jZT+WN7eC7F9FzgzKU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BwVbLDjQ7mA0/Eh9JUE9Q3DDhA5mFIuPgZnTd5Bjk+llO3w5hJ2mh3EezwwXGQ5Ny
	 srROv+Zar9nRjcQi73I1rSmqV5jrWJNx/9TBNWJODSe8ld8yqeXX+3NCelIWoCFWEM
	 oWnEUsOAEKwODcPn9FNeLqkSRlECgIxQxJVWLkdDEzTJ26lWH3Z3j/Xdn6Ln8Yf0h9
	 M8wGpfQwfssjPan+N4fntHUpWBtF79zWZhrUKqGBqYEHc7KaEhASeBIjGe3E7ph5RC
	 7mqjqcS7ioTBJAMDfDJFanBd0KwboXEij5SxxKeUw5hF6TsFKQC6AVBbIKGY3Ly8DB
	 OVWTEL9gaBtfw==
Date: Mon, 03 Jun 2024 12:06:39 -0700
Subject: [PATCH 056/111] xfs: remove xfs_inobt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040215.1443973.11647277209137250330.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6234dee7e6f58676379f3a2d8b0629a6e9a427fd

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/libxfs_api_defs.h  |    1 +
 libxfs/xfs_ialloc_btree.c |   14 --------------
 libxfs/xfs_ialloc_btree.h |    2 --
 repair/agbtree.c          |    8 +++++---
 4 files changed, 6 insertions(+), 19 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9a2968906..2adf20ce8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -147,6 +147,7 @@
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
 
+#define xfs_inobt_init_cursor		libxfs_inobt_init_cursor
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index aa3f586da..6a34de282 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -488,20 +488,6 @@ xfs_inobt_init_cursor(
 	return cur;
 }
 
-/* Create an inode btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_inobt_stage_cursor(
-	struct xfs_perag	*pag,
-	struct xbtree_afakeroot	*afake,
-	xfs_btnum_t		btnum)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_inobt_init_cursor(pag, NULL, NULL, btnum);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Install a new inobt btree root.  Caller is responsible for invalidating
  * and freeing the old btree blocks.
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 3262c3fe5..40f0fc0e8 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -48,8 +48,6 @@ struct xfs_perag;
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
-struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_perag *pag,
-		struct xbtree_afakeroot *afake, xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
diff --git a/repair/agbtree.c b/repair/agbtree.c
index d5fa4eafb..22e31c47a 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -524,8 +524,9 @@ init_ino_cursors(
 			fino_recs++;
 	}
 
-	btr_ino->cur = libxfs_inobt_stage_cursor(pag, &btr_ino->newbt.afake,
+	btr_ino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
 			XFS_BTNUM_INO);
+	libxfs_btree_stage_afakeroot(btr_ino->cur, &btr_ino->newbt.afake);
 
 	btr_ino->bload.get_records = get_inobt_records;
 	btr_ino->bload.claim_block = rebuild_claim_block;
@@ -544,8 +545,9 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, est_agfreeblocks, btr_fino);
-	btr_fino->cur = libxfs_inobt_stage_cursor(pag,
-			&btr_fino->newbt.afake, XFS_BTNUM_FINO);
+	btr_fino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
+			XFS_BTNUM_FINO);
+	libxfs_btree_stage_afakeroot(btr_fino->cur, &btr_fino->newbt.afake);
 
 	btr_fino->bload.get_records = get_inobt_records;
 	btr_fino->bload.claim_block = rebuild_claim_block;

