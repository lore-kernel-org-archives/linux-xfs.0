Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98554A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299574; cv=none; b=piS13d82i87MaMMA8vkHj/Fwv1ENAcZniZf5ezCOnYVYUSCPPj/Hiwi6wXy+tSMHuGxf1pkwlCpPoa3okeCGVwbDdtsDNev+dKnYN210cLZKSmvQX+JkeJ4G+JEhKmfU1SEfIU+OmlVo7H3U4CYFeTpXTxqmaFzvSBwhBJCRm80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299574; c=relaxed/simple;
	bh=uV7utVH6iHCc/XGcFQF/lrIbIwh06hNRth5HCMVofnI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j10k0sLShVOp2j32ERLxT6ku9DzZGFR7Rh0ky8cNvZgPAj7kSQQHWqSlrfeuc3K9tdkl99UhAUgsH1TTmubEUCV69YKzmBKSalD6jbvLjnX21lpYfxM0FciarqSjEYKBOgNmGZ/99Dst3Z4iBAdY0aZvV4IiM5Zo0h8LLIEpQZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSeB9cPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSeB9cPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C74C32786;
	Tue, 30 Jul 2024 00:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299574;
	bh=uV7utVH6iHCc/XGcFQF/lrIbIwh06hNRth5HCMVofnI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bSeB9cPhwLBOCYn7SeKSCj5JNDhtZ6HNdB/6VLi7vJ3bGXWro0nOqvw7kMhZ66jqM
	 CWlJuuauomuFx/YrE5FANPDKHMZHp1fjoHdYWBy39qSLzKjeHOc21JaTmr0br9TEvH
	 XvakUTVfn8WEFiYT9pAIZAJTnRy2cmpnmxKJqonkyeJNx4m5Oc2nyKXPUmkH3RtGck
	 +n1+LUIdK4XKNTsKE/02PHSZzaMQ6CzKT5VyrbOL/UuthLMPAgTZnAoEXLx49JI1qr
	 fLErNMwhfVk7LU4uXCyVz+mdHwmOrCoAqiMVg1U84WkgYtvNWBt9/JdC0tgXS/iij0
	 v3Q9CGaRv9aog==
Date: Mon, 29 Jul 2024 17:32:54 -0700
Subject: [PATCH 035/115] xfs: split xfs_mod_freecounter
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842934.1338752.17070490377969133733.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: f30f656e25eb72c4309e76b16fa45062e183a2ee

xfs_mod_freecounter has two entirely separate code paths for adding or
subtracting from the free counters.  Only the subtract case looks at the
rsvd flag and can return an error.

Split xfs_mod_freecounter into separate helpers for subtracting or
adding the freecounter, and remove all the impossible to reach error
handling for the addition case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/libxfs_priv.h |   10 +++++++---
 libxfs/xfs_ag.c      |    4 +---
 libxfs/xfs_ag_resv.c |   24 ++++++------------------
 libxfs/xfs_ag_resv.h |    2 +-
 libxfs/xfs_alloc.c   |    4 ++--
 libxfs/xfs_bmap.c    |   23 ++++++++++++-----------
 6 files changed, 29 insertions(+), 38 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index fa7cad0e0..40c418f54 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -541,10 +541,14 @@ struct xfs_buf *xfs_trans_buf_item_match(struct xfs_trans *,
 			struct xfs_buftarg *, struct xfs_buf_map *, int);
 
 /* local source files */
-#define xfs_mod_fdblocks(mp, delta, rsvd) \
-	libxfs_mod_incore_sb(mp, XFS_TRANS_SB_FDBLOCKS, delta, rsvd)
-#define xfs_mod_frextents(mp, delta) \
+#define xfs_add_fdblocks(mp, delta) \
+	libxfs_mod_incore_sb(mp, XFS_TRANS_SB_FDBLOCKS, delta, false)
+#define xfs_dec_fdblocks(mp, delta, rsvd) \
+	libxfs_mod_incore_sb(mp, XFS_TRANS_SB_FDBLOCKS, -(int64_t)(delta), rsvd)
+#define xfs_add_frextents(mp, delta) \
 	libxfs_mod_incore_sb(mp, XFS_TRANS_SB_FREXTENTS, delta, 0)
+#define xfs_dec_frextents(mp, delta) \
+	libxfs_mod_incore_sb(mp, XFS_TRANS_SB_FREXTENTS, -(int64_t)(delta), 0)
 int  libxfs_mod_incore_sb(struct xfs_mount *, int, int64_t, int);
 /* percpu counters in mp are #defined to the superblock sb_ counters */
 #define xfs_reinit_percpu_counters(mp)
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ad721c192..47522d0fc 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -961,9 +961,7 @@ xfs_ag_shrink_space(
 	 * Disable perag reservations so it doesn't cause the allocation request
 	 * to fail. We'll reestablish reservation before we return.
 	 */
-	error = xfs_ag_resv_free(pag);
-	if (error)
-		return error;
+	xfs_ag_resv_free(pag);
 
 	/* internal log shouldn't also show up in the free space btrees */
 	error = xfs_alloc_vextent_exact_bno(&args,
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 3a80b1613..7e5cbe0cb 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -125,14 +125,13 @@ xfs_ag_resv_needed(
 }
 
 /* Clean out a reservation */
-static int
+static void
 __xfs_ag_resv_free(
 	struct xfs_perag		*pag,
 	enum xfs_ag_resv_type		type)
 {
 	struct xfs_ag_resv		*resv;
 	xfs_extlen_t			oldresv;
-	int				error;
 
 	trace_xfs_ag_resv_free(pag, type, 0);
 
@@ -148,30 +147,19 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
-	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
+	xfs_add_fdblocks(pag->pag_mount, oldresv);
 	resv->ar_reserved = 0;
 	resv->ar_asked = 0;
 	resv->ar_orig_reserved = 0;
-
-	if (error)
-		trace_xfs_ag_resv_free_error(pag->pag_mount, pag->pag_agno,
-				error, _RET_IP_);
-	return error;
 }
 
 /* Free a per-AG reservation. */
-int
+void
 xfs_ag_resv_free(
 	struct xfs_perag		*pag)
 {
-	int				error;
-	int				err2;
-
-	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
-	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
-	if (err2 && !error)
-		error = err2;
-	return error;
+	__xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
+	__xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
 }
 
 static int
@@ -215,7 +203,7 @@ __xfs_ag_resv_init(
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
 		error = -ENOSPC;
 	else
-		error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
+		error = xfs_dec_fdblocks(mp, hidden_space, true);
 	if (error) {
 		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
 				error, _RET_IP_);
diff --git a/libxfs/xfs_ag_resv.h b/libxfs/xfs_ag_resv.h
index b74b21000..ff20ed93d 100644
--- a/libxfs/xfs_ag_resv.h
+++ b/libxfs/xfs_ag_resv.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_AG_RESV_H__
 #define	__XFS_AG_RESV_H__
 
-int xfs_ag_resv_free(struct xfs_perag *pag);
+void xfs_ag_resv_free(struct xfs_perag *pag);
 int xfs_ag_resv_init(struct xfs_perag *pag, struct xfs_trans *tp);
 
 bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 0eefb16cc..b86f788f4 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -75,7 +75,7 @@ xfs_prealloc_blocks(
 }
 
 /*
- * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
+ * The number of blocks per AG that we withhold from xfs_dec_fdblocks to
  * guarantee that we can refill the AGFL prior to allocating space in a nearly
  * full AG.  Although the space described by the free space btrees, the
  * blocks used by the freesp btrees themselves, and the blocks owned by the
@@ -85,7 +85,7 @@ xfs_prealloc_blocks(
  * until the fs goes down, we subtract this many AG blocks from the incore
  * fdblocks to ensure user allocation does not overcommit the space the
  * filesystem needs for the AGFLs.  The rmap btree uses a per-AG reservation to
- * withhold space from xfs_mod_fdblocks, so we do not account for that here.
+ * withhold space from xfs_dec_fdblocks, so we do not account for that here.
  */
 #define XFS_ALLOCBT_AGFL_RESERVE	4
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c16db82a2..3f70f24ba 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1979,10 +1979,11 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
-	if (da_new != da_old) {
-		ASSERT(state == 0 || da_new < da_old);
-		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
-				false);
+	if (da_new < da_old) {
+		xfs_add_fdblocks(mp, da_old - da_new);
+	} else if (da_new > da_old) {
+		ASSERT(state == 0);
+		error = xfs_dec_fdblocks(mp, da_new - da_old, false);
 	}
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
@@ -2684,8 +2685,8 @@ xfs_bmap_add_extent_hole_delay(
 	}
 	if (oldlen != newlen) {
 		ASSERT(oldlen > newlen);
-		xfs_mod_fdblocks(ip->i_mount, (int64_t)(oldlen - newlen),
-				 false);
+		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
+
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
@@ -4104,11 +4105,11 @@ xfs_bmapi_reserve_delalloc(
 	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
 	ASSERT(indlen > 0);
 
-	error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
+	error = xfs_dec_fdblocks(mp, alen, false);
 	if (error)
 		goto out_unreserve_quota;
 
-	error = xfs_mod_fdblocks(mp, -((int64_t)indlen), false);
+	error = xfs_dec_fdblocks(mp, indlen, false);
 	if (error)
 		goto out_unreserve_blocks;
 
@@ -4136,7 +4137,7 @@ xfs_bmapi_reserve_delalloc(
 	return 0;
 
 out_unreserve_blocks:
-	xfs_mod_fdblocks(mp, alen, false);
+	xfs_add_fdblocks(mp, alen);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
@@ -4922,7 +4923,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt)
-		xfs_mod_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
+		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
 
 	/*
 	 * Update the inode delalloc counter now and wait to update the
@@ -5009,7 +5010,7 @@ xfs_bmap_del_extent_delay(
 	if (!isrt)
 		da_diff += del->br_blockcount;
 	if (da_diff) {
-		xfs_mod_fdblocks(mp, da_diff, false);
+		xfs_add_fdblocks(mp, da_diff);
 		xfs_mod_delalloc(mp, -da_diff);
 	}
 	return error;

