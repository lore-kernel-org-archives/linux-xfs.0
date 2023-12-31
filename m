Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF836BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZ+4Ac/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45699C433C8;
	Sun, 31 Dec 2023 21:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057963;
	bh=v23wjC29Vjugc9kHSyRQkpGmdhFfUZGkWFvo7uc6WAc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oZ+4Ac/U7QPNoK+ri9EEeS/CunEvbkNz95CwDK8rcj7csbDtV7mJpBGuOhb3ZVCem
	 KDTVaP+W1R44gz8nkUbk03T91x3Cpn0EjQV2tsFPYZ8coqUhNcD2uKzB0rZvaQM+rZ
	 hYl6KXM0uqt7yBU9xH7ozJQ2NfQfOHzyzxCxJp2HygPowlK1VfDtBhdIiHg0IXky72
	 /ehBEgSg3QO4bYPBrACkuMdf0pzl1jfH5tz47rcoyLrwCyyUaKjANPdg3QqBu3KnIe
	 nO53cUHpHpnaM6DMoC3hayhN2JDFrylU5+fD3vQQu9FrYdEbXZblt+Hvizt71WcvFb
	 y3uudrtHbYQuQ==
Date: Sun, 31 Dec 2023 13:26:02 -0800
Subject: [PATCH 1/2] xfs: simplify xfs_ag_resv_free signature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847946.1764226.10841381744800434703.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847925.1764226.3996380045217070282.stgit@frogsfrogsfrogs>
References: <170404847925.1764226.3996380045217070282.stgit@frogsfrogsfrogs>
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

It's not possible to fail at increasing fdblocks, so get rid of all the
error returns here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c      |    4 +---
 fs/xfs/libxfs/xfs_ag_resv.c |   22 +++++-----------------
 fs/xfs/libxfs/xfs_ag_resv.h |    2 +-
 fs/xfs/scrub/repair.c       |    5 +----
 fs/xfs/xfs_fsops.c          |   24 ++++++------------------
 fs/xfs/xfs_fsops.h          |    2 +-
 fs/xfs/xfs_super.c          |    6 +-----
 fs/xfs/xfs_trace.h          |    1 -
 8 files changed, 16 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 77309a1ce12fb..136e02bb1c9eb 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -944,9 +944,7 @@ xfs_ag_shrink_space(
 	 * Disable perag reservations so it doesn't cause the allocation request
 	 * to fail. We'll reestablish reservation before we return.
 	 */
-	error = xfs_ag_resv_free(pag);
-	if (error)
-		return error;
+	xfs_ag_resv_free(pag);
 
 	/* internal log shouldn't also show up in the free space btrees */
 	error = xfs_alloc_vextent_exact_bno(&args,
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index da1057bd0e606..c9594254304b2 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -126,14 +126,13 @@ xfs_ag_resv_needed(
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
 
@@ -149,30 +148,19 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
-	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
+	xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
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
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index b74b210008ea7..ff20ed93de772 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_AG_RESV_H__
 #define	__XFS_AG_RESV_H__
 
-int xfs_ag_resv_free(struct xfs_perag *pag);
+void xfs_ag_resv_free(struct xfs_perag *pag);
 int xfs_ag_resv_init(struct xfs_perag *pag, struct xfs_trans *tp);
 
 bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 12cbc14b24810..24d99891a634c 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -968,9 +968,7 @@ xrep_reset_perag_resv(
 	ASSERT(sc->tp);
 
 	sc->flags &= ~XREP_RESET_PERAG_RESV;
-	error = xfs_ag_resv_free(sc->sa.pag);
-	if (error)
-		goto out;
+	xfs_ag_resv_free(sc->sa.pag);
 	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
 	if (error == -ENOSPC) {
 		xfs_err(sc->mp,
@@ -979,7 +977,6 @@ xrep_reset_perag_resv(
 		error = 0;
 	}
 
-out:
 	return error;
 }
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 84b311bd185af..bd37a7ef28178 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -214,11 +214,10 @@ xfs_growfs_data_private(
 			struct xfs_perag	*pag;
 
 			pag = xfs_perag_get(mp, id.agno);
-			error = xfs_ag_resv_free(pag);
+			xfs_ag_resv_free(pag);
 			xfs_perag_put(pag);
-			if (error)
-				return error;
 		}
+
 		/*
 		 * Reserve AG metadata blocks. ENOSPC here does not mean there
 		 * was a growfs failure, just that there still isn't space for
@@ -601,24 +600,13 @@ xfs_fs_reserve_ag_blocks(
 /*
  * Free space reserved for per-AG metadata.
  */
-int
+void
 xfs_fs_unreserve_ag_blocks(
 	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t		agno;
 	struct xfs_perag	*pag;
-	int			error = 0;
-	int			err2;
+	xfs_agnumber_t		agno;
 
-	for_each_perag(mp, agno, pag) {
-		err2 = xfs_ag_resv_free(pag);
-		if (err2 && !error)
-			error = err2;
-	}
-
-	if (error)
-		xfs_warn(mp,
-	"Error %d freeing per-AG metadata reserve pool.", error);
-
-	return error;
+	for_each_perag(mp, agno, pag)
+		xfs_ag_resv_free(pag);
 }
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 2cffe51a31e8b..dba17c404e7d1 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -14,6 +14,6 @@ extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
 
 extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
-extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
+extern void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f3a5e194c535b..4a3119a48ef08 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1900,11 +1900,7 @@ xfs_remount_ro(
 	xfs_inodegc_stop(mp);
 
 	/* Free the per-AG metadata reservation pool. */
-	error = xfs_fs_unreserve_ag_blocks(mp);
-	if (error) {
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
+	xfs_fs_unreserve_ag_blocks(mp);
 
 	/*
 	 * Before we sync the metadata, we need to free up the reserve block
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 063b1ee79de2f..87c3fe0f078be 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3149,7 +3149,6 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_critical);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
 
-DEFINE_AG_ERROR_EVENT(xfs_ag_resv_free_error);
 DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 
 /* refcount tracepoint classes */

