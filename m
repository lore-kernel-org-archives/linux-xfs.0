Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805B01DDC07
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866416; cv=none; b=SLQoIh11TR7oy72u/DKKJb+Q8UmNcyPQGkGw1uWWaC+GhAsg37UAsz7XHs3BaH/et2ZYNxli8shTuRk0OQCEwhoBL+ycnP9rPEMlDWkU2EoYiqeHqdYkSI40ayV9/gIe0YfKPitu8yrMkBgWScRmZK/pScI6b7UwSs3Qp5VjsTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866416; c=relaxed/simple;
	bh=L95T+SVeHcAyRWL2PKajX/wDmmhyJ84rKNTSA6i01Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw4FnGlSPu3rySryBz1yrj+yVyP0rf0BH+dbs7P1wkNgkZ1XOA2G01Y+7t1ZnZWl0ON3M5OAPRhgM0tnMx0Ra0m5npMAwAB6ywFrV5Squtc/qmYjxbym4OqEK3vuOQbniQuLTmaaAp4RC3p/F9HjNBiurreCL5zGHJKyOqxRPwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cPBQFKkl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cPBQFKkl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KBZrD5KEnQOtpI+lJXcwrT8SgtQKGzndAHcvUy0zZFI=; b=cPBQFKklWq3wPH08e8mPzkxxW7
	fyAgCDz7rhW2keCFpg9jgQ/1b1V3h/eoNrwO/5Xftr3ij0KNY8PSEwiF6BcwKXT6SoobDmxZ9a8vB
	dixVCLdgeCGwA5ya4FHRJS9fumluV0So1I2bahiEC2Ie/Bf1KxVRZKx1dicQQ/4Tjm4gET20V9xun
	Y83qAIpTglm8b2Dk3waanPyfEGcecDY5D2o8Ekd9eVD8qv5t1sJ2F1kKbciKUaqcB+UOieITMk/Jb
	KAUfGzjXg/TcKgAy1ebZTq7U8mWmrNFI+vOSrFIOXi0ZF2w6bLKAqcQyYKDPtfNgF2PKgGePyQn9L
	VNA4Ja6Q==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjW-00000007Cjq-2qWq;
	Tue, 18 Feb 2025 08:13:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 33/45] xfs: support xchk_xref_is_used_rt_space on zoned file systems
Date: Tue, 18 Feb 2025 09:10:36 +0100
Message-ID: <20250218081153.3889537-34-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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

