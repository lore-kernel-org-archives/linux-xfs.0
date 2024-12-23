Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE32161328
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995741; cv=none; b=DobU45sEF+FcAqN6C65yB38QO0JTKeOdtT8hXd4VTzgyyewMB802ZAL4R8aalyvFFf/RqR/GLl7QWUz2sNBLiJTwyOg84DjJBMdptkY04pHvgkyQXSoI/bTFa0P8tr/nRLmq/nF10Q+tgyxSFVtzibVz58i4eF/mV8bukaqGOSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995741; c=relaxed/simple;
	bh=s7KcGpDJWZQnni2AJkxNN55cJhIiI0gCNDk9M+9rMtA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dfNPBy5DvgUfrF+B14PaoyUQ+kHktSSNSAx0AdynROTbkX7Ig1+xOG03VJk9SULi8VynerNd3bseM40pQWCcq40SDGQACVFdk8/c8hAKU8HeA8Mx0CYIztBOlPEYM7u5DLSQOOgGh5rQLOwpZxiI65nmQHfz6DLqeiIIuOKAVKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbXEoQaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbXEoQaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F90AC4CED3;
	Mon, 23 Dec 2024 23:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995740;
	bh=s7KcGpDJWZQnni2AJkxNN55cJhIiI0gCNDk9M+9rMtA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IbXEoQaCYn6S2AB1VmtZOXI1Jx55LoA5JIbyoymvykObuA2XHgf4a42G4rAp5e8bO
	 5njSsB9MiPJRB0OHw14qHhOYlmEKFNEEaOpWd5holQ0AIvZuW/hb0UFcpkE4FfpCrb
	 1skBj5uglIEFwvSQvxkECJitbeB7zbCcTn36vWfjrzgN7G3PEoEaBmHAYNXqy5f95g
	 4DylXIjUc/UnVivZHM8bLlwaHpCRuNts0Yw42JHJUtQ0Il9AlMSsU/eqybkeP1doJA
	 7QihHkNUHmNKAsHJP6k3jUCzXtw3OHnHgMg18EGogQyJuL3EBmtsmnYOkfK7422ADA
	 hv+0vYjirk52g==
Date: Mon, 23 Dec 2024 15:15:39 -0800
Subject: [PATCH 36/43] xfs: check new rtbitmap records against rt refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420555.2381378.3419913864761763283.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.c          |    6 ++++++
 fs/xfs/scrub/rtbitmap_repair.c |   24 +++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 61e414c81253af..3b5288d3ef4e34 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -42,6 +42,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
 #include "xfs_metafile.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1009,6 +1010,11 @@ xrep_rtgroup_btcur_init(
 	    (sr->rtlock_flags & XFS_RTGLOCK_RMAP) &&
 	    xfs_has_rtrmapbt(mp))
 		sr->rmap_cur = xfs_rtrmapbt_init_cursor(sc->tp, sr->rtg);
+
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_RTREFCBT &&
+	    (sr->rtlock_flags & XFS_RTGLOCK_REFCOUNT) &&
+	    xfs_has_rtreflink(mp))
+		sr->refc_cur = xfs_rtrefcountbt_init_cursor(sc->tp, sr->rtg);
 }
 
 /*
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index c6e33834c5ae98..203a1a97c5026e 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -23,6 +23,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_extent_busy.h"
+#include "xfs_refcount.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -183,7 +184,8 @@ xrep_rtbitmap_mark_free(
 	xfs_rgblock_t		rgbno)
 {
 	struct xfs_mount	*mp = rtb->sc->mp;
-	struct xfs_rtgroup	*rtg = rtb->sc->sr.rtg;
+	struct xchk_rt		*sr = &rtb->sc->sr;
+	struct xfs_rtgroup	*rtg = sr->rtg;
 	xfs_rtxnum_t		startrtx;
 	xfs_rtxnum_t		nextrtx;
 	xrep_wordoff_t		wordoff, nextwordoff;
@@ -191,6 +193,7 @@ xrep_rtbitmap_mark_free(
 	unsigned int		bufwsize;
 	xfs_extlen_t		mod;
 	xfs_rtword_t		mask;
+	enum xbtree_recpacking	outcome;
 	int			error;
 
 	if (!xfs_verify_rgbext(rtg, rtb->next_rgbno, rgbno - rtb->next_rgbno))
@@ -210,6 +213,25 @@ xrep_rtbitmap_mark_free(
 	if (mod != mp->m_sb.sb_rextsize - 1)
 		return -EFSCORRUPTED;
 
+	/* Must not be shared or CoW staging. */
+	if (sr->refc_cur) {
+		error = xfs_refcount_has_records(sr->refc_cur,
+				XFS_REFC_DOMAIN_SHARED, rtb->next_rgbno,
+				rgbno - rtb->next_rgbno, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+
+		error = xfs_refcount_has_records(sr->refc_cur,
+				XFS_REFC_DOMAIN_COW, rtb->next_rgbno,
+				rgbno - rtb->next_rgbno, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+	}
+
 	trace_xrep_rtbitmap_record_free(mp, startrtx, nextrtx - 1);
 
 	/* Set bits as needed to round startrtx up to the nearest word. */

