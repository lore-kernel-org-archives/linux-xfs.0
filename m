Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD85A225783
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824404; cv=none; b=DRQXVMdHkJiA0DGVSuPYy02hzcgu5L43RuiE9sraSsiIteWDtTkZapVyUxSh/WV3eQMWBlBBEHTaGWFHPEIQV8zgQ6DMNWoo9bTIKt0nosUEFCAit2RyuPDQ1IFkiwjA+5sWZIvK9gwBUno1OtPKyc0liJFC827HpomUa9OjG0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824404; c=relaxed/simple;
	bh=L95T+SVeHcAyRWL2PKajX/wDmmhyJ84rKNTSA6i01Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8OxQxloMgLI99zggvfej7tU37ijrjIKRI+3pq8hg8pdB5FUctEXgwtCrZ+Gv8SVrQaleyZVyB+F+5Fr0sTtuTY+oDxZ9xjXQuslFl0Gy2A6eHyWKNWBqWzOr8c/IizN8hH0mD3XMB+j2RB+sfBAWQ6gLMEYgR1gV0W547ZHv5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NsmFA1aw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NsmFA1aw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KBZrD5KEnQOtpI+lJXcwrT8SgtQKGzndAHcvUy0zZFI=; b=NsmFA1awn9jdZNI+CBBUtFy0lP
	6k7sUHiKHQM3p/AGI00dmznsckc9kO0T6hgmKoZ74L0Uid/kjymblVGr3xn9NebzHtIvk1w1bB1kq
	xMgNz1gIYzfb74biO1188FiE2tMmFu9ppc8o3kpeFxfLKjVBe4jW/EKmzLOJ/GS8pUEXMuK3fC3pj
	nRMXvxQkMBfBPsZeCK1kfGB8vGR558Luh4PyqeXU1coIKHaWNf/SBMyPOiCMvhpGlflZ4KO8Jdgms
	XG6zbKC/sxfrSa4LxsU47lvadieRLbKJTqEtQch/B9qY5P790VoQzGW2QXMt4C0SLfS0sm5NsfBqm
	tHsYPSZQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfves-00000005QjV-15tf;
	Thu, 06 Feb 2025 06:46:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 31/43] xfs: support xchk_xref_is_used_rt_space on zoned file systems
Date: Thu,  6 Feb 2025 07:44:47 +0100
Message-ID: <20250206064511.2323878-32-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Space usage is tracked by the rmap, which already is separately
cross-referenced.  But on top of that we have the write pointer and can
do a basic sanity check here that the block is not beyond the write
pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rtbitmap.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index e8c776a34c1d..d5ff8609dbfb 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -21,6 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_exchmaps.h"
+#include "xfs_zone_alloc.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -272,7 +273,6 @@ xchk_xref_is_used_rt_space(
 	xfs_extlen_t		len)
 {
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
-	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
 	xfs_rtxnum_t		startext;
 	xfs_rtxnum_t		endext;
 	bool			is_free;
@@ -281,6 +281,13 @@ xchk_xref_is_used_rt_space(
 	if (xchk_skip_xref(sc->sm))
 		return;
 
+	if (xfs_has_zoned(sc->mp)) {
+		if (!xfs_zone_rgbno_is_valid(rtg,
+				xfs_rtb_to_rgbno(sc->mp, rtbno) + len - 1))
+			xchk_ino_xref_set_corrupt(sc, rtg_rmap(rtg)->i_ino);
+		return;
+	}
+
 	startext = xfs_rtb_to_rtx(sc->mp, rtbno);
 	endext = xfs_rtb_to_rtx(sc->mp, rtbno + len - 1);
 	error = xfs_rtalloc_extent_is_free(rtg, sc->tp, startext,
@@ -288,5 +295,5 @@ xchk_xref_is_used_rt_space(
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (is_free)
-		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
+		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
 }
-- 
2.45.2

