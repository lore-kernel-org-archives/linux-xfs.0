Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587A91EA91
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347066; cv=none; b=Z8k8YUxQsx/xTifIYfcpapeJFprOYnAdWFV0uxNWfnrH/pcbHXlmfPCz2yTt7L+m76UINpD4gtDsunSxUY4/6ISUqLYpGVOBI4K1aL+wHYyzVIVyIpGuaJLGYQZMbpcxQ6u3jtpizLcuLixUgvq1o0cgThoRFtxwjd3VD2wyCRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347066; c=relaxed/simple;
	bh=iYvt6eGseBxUui2YNaAcFgbDO1sanJ/MR1gRBFoT19c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iOEqSHzPdicWFW4EHxWcao6Sv2FMCaUU63U7jTeIFyD6HrXj7242j5oS/Ivoxsv2QOP0KbDacTWfP3SLye/rdAmme7L4RqVoBIYCvHSIYwPPzGHclu6hn7mjyfx3MuCBQLa4iQ0uuUzgd11LpSmxMTlEHyKnO1t7hkGSBF62yVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u24As5qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u24As5qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA1BC2BD11;
	Wed, 22 May 2024 03:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347065;
	bh=iYvt6eGseBxUui2YNaAcFgbDO1sanJ/MR1gRBFoT19c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u24As5qwV05ORjg1s5120TGqNeK4ZU8e358kjqi0WYmnC0trsLUKI+jlgvrQWiENE
	 C1V48JcF4yZEtaGma2fqVd8z+8lxRXNLH5z5pw/IGVs2pycBnboVOjmSnH9fkN9g+m
	 DFu4VradxZIEb/qJtw1a1LpPb94FNjP1HS126Wqraim4EAKqt2dHh8hUKauBNR0YqD
	 dIUNNg6ZYjURut7aQlAb6q70mzGnWrfYXov5f8n8OR6XUz7ZUqa2oJTp7xIz2lGdHH
	 4vN7KiyqQHwd4Rxkux+98A3uutdY11xypU6lO/whcXCqzkxkDrDOo0viEylp39VSvF
	 3604oC2b4Xmdw==
Date: Tue, 21 May 2024 20:04:25 -0700
Subject: [PATCH 060/111] xfs: remove xfs_rmapbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532598.2478931.13680384269415791056.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

