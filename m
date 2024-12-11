Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA9E1E9B2A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907493; cv=none; b=Hn+/SHdYxlzYKd9h0qBdLLs97ACfU1Ai5sbnwjgAli9V01A8H0ZD3DJF9Fv59MwrnkkcDqr9XDFH4LjUnAHR/IKz4aAGa48u5TcDlt/feWc4MzbQNmOAnIk4GeD7HXdi5MgKRNhLTRaJgdUbpVRmnb0AW4DIN/VrRo2RkHsMQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907493; c=relaxed/simple;
	bh=NHLvVud9SQ7I0QD9cj3u6FbpBZvFPsu2jrCR//p6EYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHlvCCQkVs6zvp9LW8IcDXKxYpKk+6nWW2W0JOYxZWV16ZTtuAtncNnT4J5mn3vlTI+RAFuhg9ONku/gczI7jKOvlQqZct6uFOdYVcMx5xijYvIOmXPS9gY7KU3wMSd/lLH47CMg1LGUph4WYnoG5jc3mKYDpl7GPpYdSQWKqL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LFLVmHuE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LFLVmHuE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pIp5tP517NPBuiJ/5AhNXlkM+2ab1jyqx8K4NHRsSUA=; b=LFLVmHuEJ61CNLDkr3q4hRYkES
	Q9j+WTKK4AMnzXiXn2b9va3ghsiIL6nTPf2+LoJVqmhUCOsQdPsaMxCjququk1igQQt8ZVQTsRMvs
	1J7iMKqmA9qgWWuyYFwW27GSZjdpAsjA5q6xQsTPosP14sMyXQ/FEpyoNJgzF4Y+hOZx3brp4SdT2
	Q43CdW9bG4h8TQ4545rGHoGxBLpRx9aoywXNFqktot082vE+0Qqc4pJ2PWKez9yw8QkFo23Ksw1Pl
	L8TzTiAMsUbHWOrzxt8m3Ncs/MmKyXtZiWIxP4PFkCVHbD3zgjldy+EpmjzJvDKCQjt4GgzYinm8o
	lzzGMUZg==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXr-0000000EJQF-44V1;
	Wed, 11 Dec 2024 08:58:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 33/43] xfs: support xchk_xref_is_used_rt_space on zoned file systems
Date: Wed, 11 Dec 2024 09:54:58 +0100
Message-ID: <20241211085636.1380516-34-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Space usage is tracked by the rmap, which already is separately
cross-reference.  But on top of that we have the write pointer and can
do a basic sanity check here that the block is not beyond the write
pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

