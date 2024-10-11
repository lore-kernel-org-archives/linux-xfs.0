Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3654D4400
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607093; cv=none; b=npiYSK3VUQO5IhWAC2GsmMNSkkidkWWhQKI8MQlBwCS6rnOVOCOvnsStR4TPBbQuDJ1RF7DT4AUD5OHBFNujelKWPb6wNmRdeSc2CPofroPtev6Jto2s1qRxI39ON5pC72ICx4AtaOv3kcFlJZ9gyFeweWEI6yAuN4S0fT8en2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607093; c=relaxed/simple;
	bh=Pu2Ig5I2iAsXUGYtB466gMW+wqKuS28QbR57+3r1OC8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tx/S1eXzFUndVmXsoaBPBK4hS4XEMAH7x4D9rLeYEhIMqq2M1pVhGprDvSlEq+uOElM4huU4/LhwyBxuO3mjLa2hC48OacK34TzaL4y9ygkJ0q1RleqhadQ+9/8ateBV+MIZcUSIbNfJYbELYoNV2Pkx/nJxhAyiQDkuCr6DX9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivwi+H5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivwi+H5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7A6C4CEC5;
	Fri, 11 Oct 2024 00:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607092;
	bh=Pu2Ig5I2iAsXUGYtB466gMW+wqKuS28QbR57+3r1OC8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ivwi+H5bKN8qdSI4TZpn3ZeDgqfmcIuJ2/wHyHAtoPGjktH5MTEJSH53DE7JjjhQa
	 /06bXvN8xW8gAr4dh9QvHiNOe02sx5j+0EmnAkHL/aON9MAaWgcrDnq9XN43hpru86
	 gGRsL+Z9JWKPjynxSvolmgzwgYFFzXav2VNmKVr8zIhWkTW+wQnC0P/uSGd42mfLqq
	 WjxqxR6hUdHgr7pxtGkaScsZOm2TVoXIBqUKu7EGNs+VKEYoPgQo2m+TtudczeucTu
	 pSLEsIcHWTD85Zpe2+U7/klWh/4gnNWhik2yAiHmk17ymq5HhcdYCCPC5z+wpTj3Ce
	 Rk7Cz40YLnOxg==
Date: Thu, 10 Oct 2024 17:38:12 -0700
Subject: [PATCH 02/25] xfs: merge the perag freeing helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640442.4175438.3669977660883127771.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
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

There is no good reason to have two different routines for freeing perag
structures for the unmount and error cases.  Add two arguments to specify
the range of AGs to free to xfs_free_perag, and use that to replace
xfs_free_unused_perag_range.

The addition RCU grace period for the error case is harmless, and the
extra check for the AG to actually exist is not required now that the
callers pass the exact known allocated range.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |   40 ++++++++++------------------------------
 fs/xfs/libxfs/xfs_ag.h |    5 ++---
 fs/xfs/xfs_fsops.c     |    2 +-
 fs/xfs/xfs_mount.c     |    5 ++---
 4 files changed, 15 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 652376aa52e990..8fac0ce45b1559 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -185,17 +185,20 @@ xfs_initialize_perag_data(
 }
 
 /*
- * Free up the per-ag resources associated with the mount structure.
+ * Free up the per-ag resources  within the specified AG range.
  */
 void
-xfs_free_perag(
-	struct xfs_mount	*mp)
+xfs_free_perag_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first_agno,
+	xfs_agnumber_t		end_agno)
+
 {
-	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xa_erase(&mp->m_perags, agno);
+	for (agno = first_agno; agno < end_agno; agno++) {
+		struct xfs_perag	*pag = xa_erase(&mp->m_perags, agno);
+
 		ASSERT(pag);
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
@@ -270,29 +273,6 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
-/*
- * Free perag within the specified AG range, it is only used to free unused
- * perags under the error handling path.
- */
-void
-xfs_free_unused_perag_range(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agstart,
-	xfs_agnumber_t		agend)
-{
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		index;
-
-	for (index = agstart; index < agend; index++) {
-		pag = xa_erase(&mp->m_perags, index);
-		if (!pag)
-			break;
-		xfs_buf_cache_destroy(&pag->pag_bcache);
-		xfs_defer_drain_free(&pag->pag_intents_drain);
-		kfree(pag);
-	}
-}
-
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -369,7 +349,7 @@ xfs_initialize_perag(
 out_free_pag:
 	kfree(pag);
 out_unwind_new_pags:
-	xfs_free_unused_perag_range(mp, old_agcount, index);
+	xfs_free_perag_range(mp, old_agcount, index);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 69fc31e7b84728..6e68d6a3161a0f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -144,13 +144,12 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
-void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
-			xfs_agnumber_t agend);
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
 		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
 		xfs_agnumber_t *maxagi);
+void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
+		xfs_agnumber_t end_agno);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
-void xfs_free_perag(struct xfs_mount *mp);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index de2bf0594cb474..b247d895c276d2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -229,7 +229,7 @@ xfs_growfs_data_private(
 	xfs_trans_cancel(tp);
 out_free_unused_perag:
 	if (nagcount > oagcount)
-		xfs_free_unused_perag_range(mp, oagcount, nagcount);
+		xfs_free_perag_range(mp, oagcount, nagcount);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6fa7239a4a01b6..25bbcc3f4ee08b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1048,7 +1048,7 @@ xfs_mountfs(
 		xfs_buftarg_drain(mp->m_logdev_targp);
 	xfs_buftarg_drain(mp->m_ddev_targp);
  out_free_perag:
-	xfs_free_perag(mp);
+	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
  out_free_dir:
 	xfs_da_unmount(mp);
  out_remove_uuid:
@@ -1129,8 +1129,7 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp);
 #endif
 	shrinker_free(mp->m_inodegc_shrinker);
-	xfs_free_perag(mp);
-
+	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
 	xfs_errortag_del(mp);
 	xfs_error_sysfs_del(mp);
 	xchk_stats_unregister(mp->m_scrub_stats);

