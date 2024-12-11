Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825081E9B2A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907496; cv=none; b=OjoGQQhfb7tVNXdZO/AAEbXOGN53DLBAI0P24tRwKNzVp0I56aqMwNxQn8Pyc/mS1XbEfznZysVgfyPq5i7sRULPRO8nSJVadk2MPQYtSKvc6s14mQEGcbhWd/XD+TZDs71sxLCIz5ECWsUW9oBkBZZxuAl9eMvpFwGaW4o2qGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907496; c=relaxed/simple;
	bh=EUsF0xNvP1P/K/Tce+s8O9s/u7DjOzbKvwej73PYWzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnJ7MaFEhcB0URrclLalZmSaIMBjIKKZ/sWg/Vj9fwXEZqrkGSmK6VMRvdVTU+ep/VlGoyOuP8pfIyAw/gs2g/RqC/Ji1qPZEDPgSvJoSYC/1EAh6nLixaUXgP0r231IG9pgasri0MXaapralRbQfUvY+6xzi+dALQdk0Sx4m/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eDeWC8rD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eDeWC8rD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=y14/KGegdH86zBIFW8OVWsdjjEc6XmCT1RkqYffUX68=; b=eDeWC8rDd0FhN01LIF3wVs2O1x
	cD7RaKY6Qa6lkvCmKQjzuYgL0GsdUnFnxHjKe5YHZw5kDzr/0HsovmOKxUhLY9l8to9kKihlflbg1
	aC/wSqKSiua1XjLZhP/v84TmsNc36LkS5Ytbp5/8HM7/vGVuLxWMKM9/V5G91yOvO3MbtBRGXZNkJ
	H+TlPfR+DWci3HwHqmvigaHSeMttecLkRI12KACqMjQ5WIgpx0RaFfaJEwsGEPML7PoITuWYM8FX1
	AehfvTg2BhmsJF/Xh0ZLiUTQfUpgfUcxCPV2BlTp/bje8p0NrKhCcBysTxB6PYZgrFcdIHVbTWKZ3
	rAu1hYCA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXu-0000000EJR4-38S6;
	Wed, 11 Dec 2024 08:58:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 34/43] xfs: support xrep_require_rtext_inuse on zoned file systems
Date: Wed, 11 Dec 2024 09:54:59 +0100
Message-ID: <20241211085636.1380516-35-hch@lst.de>
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
 fs/xfs/scrub/repair.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 90740718ac70..dd88a237d629 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -43,6 +43,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_metafile.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_zone_alloc.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1048,7 +1049,13 @@ xrep_require_rtext_inuse(
 	xfs_rtxnum_t		startrtx;
 	xfs_rtxnum_t		endrtx;
 	bool			is_free = false;
-	int			error;
+	int			error = 0;
+
+	if (xfs_has_zoned(mp)) {
+		if (!xfs_zone_rgbno_is_valid(sc->sr.rtg, rgbno + len - 1))
+			return -EFSCORRUPTED;
+		return 0;
+	}
 
 	startrtx = xfs_rgbno_to_rtx(mp, rgbno);
 	endrtx = xfs_rgbno_to_rtx(mp, rgbno + len - 1);
-- 
2.45.2

