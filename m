Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5106D12838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422734; cv=none; b=YBmmbiPTpnORTLP+AQx/XwzrMKbzy1spTK9jqsyEJlzHiKkyhEv/ZzWZ/f53tykF18np5FqxNBNpCAWFzo86dgC7UUTZkzKqcRAu43eZQUQ48CK9JQQfsDg0qtk1m85jWpyeVlHgRwcrDcMR2OAPbW6WX1iu8nuUypnyGQ3uzTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422734; c=relaxed/simple;
	bh=SjDieRexLh60F+QH9l0Wxy/O2lYDSNjZCXpcP8i+f3o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWhJpJ2iyvuZRYe0FaHMJ/dH2th1pPPulUO3gE9u73Xj4zO3ynzNiv9fomq7qPCWqEJj4Ryb/7eLeAyyMpH/IHeA63vv7ll2k3+1sZaprr3vynZD3fdqKXUcPSfsrsVEAjBC+Tp7B1cJHODhEIA9AS8I6FxYRHJJlyEiDzet8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdWNNZ/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdWNNZ/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C22C433C7;
	Tue, 26 Mar 2024 03:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422734;
	bh=SjDieRexLh60F+QH9l0Wxy/O2lYDSNjZCXpcP8i+f3o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qdWNNZ/U1oZ9RvWcyrT5PZyGpr4weKYCThCfBc9QSIu9LLugLc+klZIjeD8xjkLXl
	 fOkaskUAU6/6s9B4GCG7IjK9AmSs+uMiD4T7QauzO8slfsKiRAP+aZjktvHvR9GaXv
	 tky5PzvP8cMzzvA3FmGpLKyEdTHz5t54GldngALGBERzEeDimWtKpmozefatXZn8Y/
	 9USBKxqTDfS+GkUpG1uWaMDXpe7eNxzY3aUDTNwB6q55ot4vyEIisJGe65fLQOir3e
	 qLCbCcDi6+ZXTKGgEb6k6cJV6cH6pHb1imlwol6CfxLx4GUeyYKZn3PjWyXNeEolK3
	 NI4no8kPjItPg==
Date: Mon, 25 Mar 2024 20:12:13 -0700
Subject: [PATCH 36/67] xfs: repair refcount btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127481.2212320.16465660586143561250.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9099cd38002f8029c9a1da08e6832d1cd18e8451

Reconstruct the refcount data from the rmap btree.

Link: https://docs.kernel.org/filesystems/xfs-online-fsck-design.html#case-study-rebuilding-the-space-reference-counts
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_ag.h             |    1 +
 libxfs/xfs_btree.c          |   26 ++++++++++++++++++++++++++
 libxfs/xfs_btree.h          |    2 ++
 libxfs/xfs_refcount.c       |    8 +++-----
 libxfs/xfs_refcount.h       |    2 +-
 libxfs/xfs_refcount_btree.c |   13 ++++++++++++-
 6 files changed, 45 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index f16cb7a174d4..67c3260ee789 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -87,6 +87,7 @@ struct xfs_perag {
 	 * verifiers while rebuilding the AG btrees.
 	 */
 	uint8_t		pagf_repair_levels[XFS_BTNUM_AGF];
+	uint8_t		pagf_repair_refcount_level;
 #endif
 
 	spinlock_t	pag_state_lock;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 97962fc16ec4..0022bb641bee 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5209,3 +5209,29 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
 }
+
+/* Move the btree cursor before the first record. */
+int
+xfs_btree_goto_left_edge(
+	struct xfs_btree_cur	*cur)
+{
+	int			stat = 0;
+	int			error;
+
+	memset(&cur->bc_rec, 0, sizeof(cur->bc_rec));
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, &stat);
+	if (error)
+		return error;
+	if (!stat)
+		return 0;
+
+	error = xfs_btree_decrement(cur, 0, &stat);
+	if (error)
+		return error;
+	if (stat != 0) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index e0875cec4939..d906324e25c8 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -738,4 +738,6 @@ xfs_btree_alloc_cursor(
 int __init xfs_btree_init_cur_caches(void);
 void xfs_btree_destroy_cur_caches(void);
 
+int xfs_btree_goto_left_edge(struct xfs_btree_cur *cur);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 45f8134e4314..3377fac1283b 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -122,11 +122,9 @@ xfs_refcount_btrec_to_irec(
 /* Simple checks for refcount records. */
 xfs_failaddr_t
 xfs_refcount_check_irec(
-	struct xfs_btree_cur		*cur,
+	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	struct xfs_perag		*pag = cur->bc_ag.pag;
-
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		return __this_address;
 
@@ -178,7 +176,7 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	fa = xfs_refcount_check_irec(cur, irec);
+	fa = xfs_refcount_check_irec(cur->bc_ag.pag, irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
@@ -1898,7 +1896,7 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (xfs_refcount_check_irec(cur, &rr->rr_rrec) != NULL ||
+	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		kfree(rr);
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 783cd89ca195..5c207f1c619c 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -117,7 +117,7 @@ extern int xfs_refcount_has_records(struct xfs_btree_cur *cur,
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
-xfs_failaddr_t xfs_refcount_check_irec(struct xfs_btree_cur *cur,
+xfs_failaddr_t xfs_refcount_check_irec(struct xfs_perag *pag,
 		const struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index bc8bd867eee7..ac1c3ab868e0 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -225,7 +225,18 @@ xfs_refcountbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_refcount_level)
+		unsigned int	maxlevel = pag->pagf_refcount_level;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the refcount btree, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				pag->pagf_repair_refcount_level);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_refc_maxlevels)
 		return __this_address;

