Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9BFDF51
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwR6GhDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7DAC433C7;
	Sun, 31 Dec 2023 21:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059653;
	bh=WmWM0LxfWAFIYIsKnjfwElglz+CZ/h9IU8iQDb48Dfc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mwR6GhDm4QumFYeOjYKrvLY+5vkKo1ghqBNCRt4Kr8+gxHXD6f7jEYBnb2v78ebvC
	 YGvktT2UHWprRewvRKrUIRL5txmrtjSVh7wBkCtJay2lGjUlfC4wZy1/V4eBLC/jHO
	 X6BkfoZ8FL1fJRvJBjeMSgl3MRNwdiGIuo1TvIfVeIDTT3QE9PA5EREBo+oiMEESxa
	 hDXaWVI0iGONbB/Ug7sSG8RFyynBzt6BJxGvhrZABKfzNVQPUTOCrNo3sJuZ6cgdLI
	 05nprVXUmLvR6H25n0cCDU91E0dnXx4wmhE4WyQnED7lcmbukUXOKQ55Znl5D4iZDs
	 hK7c5qOkF0x8w==
Date: Sun, 31 Dec 2023 13:54:12 -0800
Subject: [PATCH 37/44] xfs: check new rtbitmap records against rt refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852175.1766284.18016890871197639875.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

When we're rebuilding the realtime bitmap, check the proposed free
extents against the rt refcount btree to make sure we don't commit any
grievous errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c          |    7 +++++++
 fs/xfs/scrub/rtbitmap_repair.c |   24 +++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c9c538083c722..fdd12933fd47f 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -41,6 +41,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
 #include "xfs_imeta.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1008,6 +1009,12 @@ xrep_rtgroup_btcur_init(
 	    xfs_has_rtrmapbt(mp))
 		sr->rmap_cur = xfs_rtrmapbt_init_cursor(mp, sc->tp, sr->rtg,
 				sr->rtg->rtg_rmapip);
+
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_RTREFCBT &&
+	    (sr->rtlock_flags & XFS_RTGLOCK_REFCOUNT) &&
+	    xfs_has_rtreflink(mp))
+		sr->refc_cur = xfs_rtrefcountbt_init_cursor(mp, sc->tp,
+				sr->rtg, sr->rtg->rtg_refcountip);
 }
 
 /*
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index db87ce51c35fc..24d7d0ff49ea3 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -22,6 +22,7 @@
 #include "xfs_swapext.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_refcount.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -418,7 +419,8 @@ xrep_rgbitmap_mark_free(
 	xfs_rgblock_t		rgbno)
 {
 	struct xfs_mount	*mp = rgb->sc->mp;
-	struct xfs_rtgroup	*rtg = rgb->sc->sr.rtg;
+	struct xchk_rt		*sr =  &rgb->sc->sr;
+	struct xfs_rtgroup	*rtg = sr->rtg;
 	xfs_rtblock_t		rtbno;
 	xfs_rtxnum_t		startrtx;
 	xfs_rtxnum_t		nextrtx;
@@ -427,6 +429,7 @@ xrep_rgbitmap_mark_free(
 	unsigned int		bufwsize;
 	xfs_extlen_t		mod;
 	xfs_rtword_t		mask;
+	enum xbtree_recpacking	outcome;
 	int			error;
 
 	if (!xfs_verify_rgbext(rtg, rgb->next_rgbno, rgbno - rgb->next_rgbno))
@@ -446,6 +449,25 @@ xrep_rgbitmap_mark_free(
 	if (mod != mp->m_sb.sb_rextsize - 1)
 		return -EFSCORRUPTED;
 
+	/* Must not be shared or CoW staging. */
+	if (sr->refc_cur) {
+		error = xfs_refcount_has_records(sr->refc_cur,
+				XFS_REFC_DOMAIN_SHARED, rgb->next_rgbno,
+				rgbno - rgb->next_rgbno, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+
+		error = xfs_refcount_has_records(sr->refc_cur,
+				XFS_REFC_DOMAIN_COW, rgb->next_rgbno,
+				rgbno - rgb->next_rgbno, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+	}
+
 	trace_xrep_rgbitmap_record_free(mp, startrtx, nextrtx - 1);
 
 	/* Set bits as needed to round startrtx up to the nearest word. */

