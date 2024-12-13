Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BDF136327
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052778; cv=none; b=I/t3uMNzxeU7/sGo8zSXG4O/aSMUpabB23J/m21+sYw4hZLIRNBJZ0jCf/678VRzHi8sh43ytL0nUsFwGNFAfiPoOXzEyXH1htwseVel9dSq1lo2xU8CNROGwW31iikymy5FGeYLWhcLF/cMp9OP8yMQXx3MGEI4hhWTF3xl9vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052778; c=relaxed/simple;
	bh=Y9mX8Jo2NPJ7lh2LNqXiB+d81l/2MFIeV1gC8l632sQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uu+UkxBXN6cV7q4cLMBJK39+VXAv/IiNn4E9C7AqhozqDH/6A8sjhK14K2qWHGOgy1sl0P2Im7hjerpQt8gKh5WxOkn/9CIoZPJxvRuDEFG5BCUrRD/xyyHXFfMBX6/scs9nplwdtC3bldO4TaNDDlC8+knbKvcwWAVNkqvOIhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KneQFayh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KneQFayh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DFDC4CEDE;
	Fri, 13 Dec 2024 01:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052778;
	bh=Y9mX8Jo2NPJ7lh2LNqXiB+d81l/2MFIeV1gC8l632sQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KneQFayhzVeM9fI9JpsbUZmDz+pbUTIcD3zFcYux1LmsuaXlh2JRGSMmVEdHhnGOZ
	 4a8YfBhN4v1LnGj64iq4UNK/CnL4eZ+J08Ev8UkSGNPsy5cS/219DAfNjWy3YdM143
	 WQcyDUD4gkFe+JXmlwVckDq8JFpFRoa6JruzMfBsQowOshfxCI9sWjFfdMPpCzvD0Y
	 JX5j5kZPMXhDOxY+5KrUUkSE7TFLUvbWVAtFhTvH5d61DnJLqSLa+xoZ6+I9xkJ80U
	 CUK3V5yzkN8vhBCSOE8jW13chZRJMt3JVvmbg0RxVftiFPoMPF7oO0Src7dhYvERAA
	 Ywt0aLhCWPGyQ==
Date: Thu, 12 Dec 2024 17:19:37 -0800
Subject: [PATCH 36/43] xfs: check new rtbitmap records against rt refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125183.1182620.16371102582007178677.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/repair.c          |    6 ++++++
 fs/xfs/scrub/rtbitmap_repair.c |   24 +++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index d58843017391be..90740718ac70d3 100644
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
@@ -1007,6 +1008,11 @@ xrep_rtgroup_btcur_init(
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

