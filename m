Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2128EA
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347034; cv=none; b=DvZua6RE0kj+IYuOdny+SEZIoK+jcFXvKQr7TETv8lYtt8UImfpdHGzMEG/ooIs6jZUWRjBL4kKwtQ3B1tKxNUtbUqiELFQkudWGYTuR3QBT8XyPKBabcuoPCMFZbJezgrwQoK32WPupcOglDEeHHrceXEmkEKa8QkhsRVFh4gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347034; c=relaxed/simple;
	bh=bJavIl77aHHvLaHSdykpz3rkGAyRP2oPMfGDNewaAbs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoGhm1BlJdTVXlOGTwmE8sZjaoRJGDXlanFtkU+AevemEIZTHBH+IgNrH6XJME/iOvk5b4dpqsnvY68STbyMJY/x6kQk86eBtwbpYpJOA+D6MHJjsJkkfpUC6UYan8+hgW6Qc7vjE8wMm1moxClRLSGa9ODEK5TkqyHHad273JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/7NZ26C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/7NZ26C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C2AC2BD11;
	Wed, 22 May 2024 03:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347034;
	bh=bJavIl77aHHvLaHSdykpz3rkGAyRP2oPMfGDNewaAbs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A/7NZ26CyI5hD1sZ55hdtCITTOfqFzVqpJNb1hUcmjFIdewLM2Vs/PbwkyoTmhFLX
	 kGJOYX3AkHbUbjeWNXpsOgMxuzO5s/rS8q43UxR5TtnD0a/T5v4CPePC6Mek2u+z6H
	 HeJA4a29+wPULL9T634QSRr6r1E9m10LDtCLTliwSJVU+TuwZI5erSC/OzsQop0BV5
	 TzAjR4ZRmAly9hySapcPBHCqCgjvVRcx+ctREgrdMtJJ6qxMSuj65Rq0tK2374sWKt
	 zCoS/CgXsIIiDJWvnID/Pn44NMwGkL0ga6HcEO5hFktv2Z40lM0B//bdIIt0eAsQWT
	 XoJPGfHQG/uQQ==
Date: Tue, 21 May 2024 20:03:54 -0700
Subject: [PATCH 058/111] xfs: remove xfs_refcountbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532568.2478931.10772814269385008418.stgit@frogsfrogsfrogs>
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
index c1ae76949..760163ca4 100644
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
index d66b37259..1e0ab25f6 100644
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
index 22e31c47a..395ced6cf 100644
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

