Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D6820ADE7
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190954; cv=none; b=Jr/lEVf9V+8tJc9145QbgWZBojtA0aRVeZStnVvnVBIQDUmHZLCYLc9iFLoe+bVYGHVYmvqYxjAsJwz1Pv89roDlaSosTMPRkEA9RsclaELchigO0akHaGoCFqoZff1Cu1MsUW7EJjuXcmCPMH9CUu35z98jlR/Ha0TPOBhCALI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190954; c=relaxed/simple;
	bh=62OZDzv/ynlA2A2vTNv7MVBS5Fom0UaohCd3UT0fyrU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVCY8F0YEVXuIwCS+zHTDLMCkLEBpbW3YXFxGMVvfUFty4Wue9VbAHSYsh4WwFhMQph7e8g4hMEwiqzCqaNU6S9/k2IZBU3CTF08laurdFML8tcXWllgjgSWmZDdGSnznG2B4JnJeEPcN2K1KQue94xzqbl8CFPAylRbviybxfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKXhS3ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKXhS3ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F40C4CEC3;
	Thu, 17 Oct 2024 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190954;
	bh=62OZDzv/ynlA2A2vTNv7MVBS5Fom0UaohCd3UT0fyrU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pKXhS3ki+EpFHhc791m/vLyMezCc4lm/r9uOoEG8Xc3Zuohm0uMT++/Kt+2BDKtq5
	 CAkdUahWHHM8v9Ep/uPNqWnmrrxwRp8tj3ZVktRQg+hMx/0KZeekgFkP2VqeXHq2Yl
	 1VMZQXq6lis7YpN1nficwzR/coCXvjoAsYLJXrEuiNvL/55eIBVHThSKj73/FeIOLb
	 x+tOWcIJ5UI3QFu+NJ9AIwFCrDE1kAkTHnklNlUkWlaHBZ8v0y2GfLJqxhotA0MeH9
	 PAe4ABsVulcBt7INCb5I/6G9IyxXVhQQExq2f8gkLbmoTR//q6x29sXJ3+wpeBwhw4
	 y67RK4FVVWusQ==
Date: Thu, 17 Oct 2024 11:49:13 -0700
Subject: [PATCH 08/22] xfs: pass a pag to xfs_extent_busy_{search,reuse}
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067998.3449971.4961916899313361530.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Replace the [mp,agno] tuple with the perag structure, which will become
more useful later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       |    4 ++--
 fs/xfs/libxfs/xfs_alloc_btree.c |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c  |    2 +-
 fs/xfs/xfs_discard.c            |    2 +-
 fs/xfs/xfs_extent_busy.c        |   12 ++++--------
 fs/xfs/xfs_extent_busy.h        |    8 ++++----
 6 files changed, 13 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6b4a566bc532bf..02903ba3758931 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1252,7 +1252,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->mp, args->pag, fbno, 1,
+	xfs_extent_busy_reuse(args->pag, fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -3616,7 +3616,7 @@ xfs_alloc_vextent_finish(
 		if (error)
 			goto out_drop_perag;
 
-		ASSERT(!xfs_extent_busy_search(mp, args->pag, args->agbno,
+		ASSERT(!xfs_extent_busy_search(args->pag, args->agbno,
 				args->len));
 	}
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index aada676eee519c..5175d0b4d32e48 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -86,7 +86,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.pag, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_ag.pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index ac2f1f499b76f6..b49006c1ca7eee 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -102,7 +102,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, pag, bno, 1, false);
+	xfs_extent_busy_reuse(pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d8c4a5dcca7aea..1a91e97d25ffba 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -272,7 +272,7 @@ xfs_trim_gather_extents(
 		 * If any blocks in the range are still busy, skip the
 		 * discard and try again the next time.
 		 */
-		if (xfs_extent_busy_search(mp, pag, fbno, flen)) {
+		if (xfs_extent_busy_search(pag, fbno, flen)) {
 			trace_xfs_discard_busy(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index a73e7c73b664c6..22c16fa56bcc44 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -101,7 +101,6 @@ xfs_extent_busy_insert_discard(
  */
 int
 xfs_extent_busy_search(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
@@ -148,7 +147,6 @@ xfs_extent_busy_search(
  */
 STATIC bool
 xfs_extent_busy_update_extent(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	struct xfs_extent_busy	*busyp,
 	xfs_agblock_t		fbno,
@@ -280,24 +278,22 @@ xfs_extent_busy_update_extent(
 		ASSERT(0);
 	}
 
-	trace_xfs_extent_busy_reuse(mp, pag->pag_agno, fbno, flen);
+	trace_xfs_extent_busy_reuse(pag->pag_mount, pag->pag_agno, fbno, flen);
 	return true;
 
 out_force_log:
 	spin_unlock(&pag->pagb_lock);
-	xfs_log_force(mp, XFS_LOG_SYNC);
-	trace_xfs_extent_busy_force(mp, pag->pag_agno, fbno, flen);
+	xfs_log_force(pag->pag_mount, XFS_LOG_SYNC);
+	trace_xfs_extent_busy_force(pag->pag_mount, pag->pag_agno, fbno, flen);
 	spin_lock(&pag->pagb_lock);
 	return false;
 }
 
-
 /*
  * For a given extent [fbno, flen], make sure we can reuse it safely.
  */
 void
 xfs_extent_busy_reuse(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
@@ -323,7 +319,7 @@ xfs_extent_busy_reuse(
 			continue;
 		}
 
-		if (!xfs_extent_busy_update_extent(mp, pag, busyp, fbno, flen,
+		if (!xfs_extent_busy_update_extent(pag, busyp, fbno, flen,
 						  userdata))
 			goto restart;
 	}
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 470032de31391b..847c904a19386c 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -58,12 +58,12 @@ xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
 	bool do_discard);
 
 int
-xfs_extent_busy_search(struct xfs_mount *mp, struct xfs_perag *pag,
-	xfs_agblock_t bno, xfs_extlen_t len);
+xfs_extent_busy_search(struct xfs_perag *pag, xfs_agblock_t bno,
+		xfs_extlen_t len);
 
 void
-xfs_extent_busy_reuse(struct xfs_mount *mp, struct xfs_perag *pag,
-	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
+xfs_extent_busy_reuse(struct xfs_perag *pag, xfs_agblock_t fbno,
+		xfs_extlen_t flen, bool userdata);
 
 bool
 xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,

