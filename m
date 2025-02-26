Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4080E236A73
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596247; cv=none; b=HWf/pHEI8VVp9H2UokFGvRG/6gr3t225Hjo5ninLAnPKOO31PGhe+lyk2Hz8D8XD01BxdoNPJOr2yq0R5l1wjUJQ2L2xBIHUCsslpVKY7Ro3RlHJbPqD3PxoD0wMGl2eQtcgQ4pgANZUz9zvLlyYdj6yoW9liqbyf1gZOPaqhmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596247; c=relaxed/simple;
	bh=8RuZmjrHohduWzVaBHuj0mMqR3rxIx7OJYV1qQh1h/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGPm6fpSNu8xviZ05w0NCexqTwTi6T6MZnMeApYgALvvjrglWfSYtK62KjWLwG8W8VZLcLJ8ieIXKOr+c/3goEr2txJcbhpAvD8AZd+9QBzpkWusK4wx5tybfzfmcKt84z1ht+VNlbG002ELqB9coRVoOZsj04bU2fSjB1iKOyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fnyv81CZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fnyv81CZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=M5oX5JoDrVwOIiuMKStfI4dNeUlpsHD6UBaUrMdPfyY=; b=fnyv81CZMLYqSpIJFRbUZEF76p
	kTgV5HQkPwVY3/Se9o9h+sYhQ5WYgaeSAus7NVmXXmCH0hTzfKMrhRnWRKALk55IX9KjqiaxATUyA
	LoIBNaCblJ9R6FfEe786YLbnIPOPAEgm/tysgF+B36C7C/pYidrl/+B0lz1d7d7Ty0M6NvBpQbpgP
	PW5jn8XgiN3W6M78Pm820p5h4dMDcgfSk15VCdgcrc7IpYvPTLJdLcuoPKeWKR+aKcrrcUQ1Q2ieN
	gv6HNTG1XsSlNUeVSuPapjfRTkGfDh0f7O+ZlhFMq+qtkr4g1yjU/mBXTqIUDaGhB0j8EwQADCw6N
	7VBLPmDA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMaz-000000053rl-3Wty;
	Wed, 26 Feb 2025 18:57:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/44] xfs: fixup the metabtree reservation in xrep_reap_metadir_fsblocks
Date: Wed, 26 Feb 2025 10:56:37 -0800
Message-ID: <20250226185723.518867-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All callers of xrep_reap_metadir_fsblocks need to fix up the metabtree
reservation, otherwise they'd leave the reservations in an incoherent
state.  Move the call to xrep_reset_metafile_resv into
xrep_reap_metadir_fsblocks so it always is taken care of, and remove
now superfluous helper functions in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c              |  9 ++++++---
 fs/xfs/scrub/rtrefcount_repair.c | 34 ++++++--------------------------
 fs/xfs/scrub/rtrmap_repair.c     | 29 +++++----------------------
 3 files changed, 17 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index b32fb233cf84..8703897c0a9c 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -935,10 +935,13 @@ xrep_reap_metadir_fsblocks(
 	if (error)
 		return error;
 
-	if (xreap_dirty(&rs))
-		return xrep_defer_finish(sc);
+	if (xreap_dirty(&rs)) {
+		error = xrep_defer_finish(sc);
+		if (error)
+			return error;
+	}
 
-	return 0;
+	return xrep_reset_metafile_resv(sc);
 }
 
 /*
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 257cfb24beb4..983362447826 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -697,32 +697,6 @@ xrep_rtrefc_build_new_tree(
 	return error;
 }
 
-/*
- * Now that we've logged the roots of the new btrees, invalidate all of the
- * old blocks and free them.
- */
-STATIC int
-xrep_rtrefc_remove_old_tree(
-	struct xrep_rtrefc	*rr)
-{
-	int			error;
-
-	/*
-	 * Free all the extents that were allocated to the former rtrefcountbt
-	 * and aren't cross-linked with something else.
-	 */
-	error = xrep_reap_metadir_fsblocks(rr->sc,
-			&rr->old_rtrefcountbt_blocks);
-	if (error)
-		return error;
-
-	/*
-	 * Ensure the proper reservation for the rtrefcount inode so that we
-	 * don't fail to expand the btree.
-	 */
-	return xrep_reset_metafile_resv(rr->sc);
-}
-
 /* Rebuild the rt refcount btree. */
 int
 xrep_rtrefcountbt(
@@ -769,8 +743,12 @@ xrep_rtrefcountbt(
 	if (error)
 		goto out_bitmap;
 
-	/* Kill the old tree. */
-	error = xrep_rtrefc_remove_old_tree(rr);
+	/*
+	 * Free all the extents that were allocated to the former rtrefcountbt
+	 * and aren't cross-linked with something else.
+	 */
+	error = xrep_reap_metadir_fsblocks(rr->sc,
+			&rr->old_rtrefcountbt_blocks);
 	if (error)
 		goto out_bitmap;
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index f2fdd7a9fc24..fc2592c53af5 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -810,28 +810,6 @@ xrep_rtrmap_build_new_tree(
 
 /* Reaping the old btree. */
 
-/* Reap the old rtrmapbt blocks. */
-STATIC int
-xrep_rtrmap_remove_old_tree(
-	struct xrep_rtrmap	*rr)
-{
-	int			error;
-
-	/*
-	 * Free all the extents that were allocated to the former rtrmapbt and
-	 * aren't cross-linked with something else.
-	 */
-	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
-	if (error)
-		return error;
-
-	/*
-	 * Ensure the proper reservation for the rtrmap inode so that we don't
-	 * fail to expand the new btree.
-	 */
-	return xrep_reset_metafile_resv(rr->sc);
-}
-
 static inline bool
 xrep_rtrmapbt_want_live_update(
 	struct xchk_iscan		*iscan,
@@ -995,8 +973,11 @@ xrep_rtrmapbt(
 	if (error)
 		goto out_records;
 
-	/* Kill the old tree. */
-	error = xrep_rtrmap_remove_old_tree(rr);
+	/*
+	 * Free all the extents that were allocated to the former rtrmapbt and
+	 * aren't cross-linked with something else.
+	 */
+	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
 	if (error)
 		goto out_records;
 
-- 
2.45.2

