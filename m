Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458B826B0BC
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 05:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493645; cv=none; b=IKb6VcE38yD2BHDUcElYuoE3T6En25Ah+/xiWm+kTnJeH93U/kdnufvqo80DJ2u+3mL5Ob+eT46t1yGtnHEX4f4vdS3g3gsA18icmk+g0PhQ3NUvOFBQUtE5gbOf0kuCZgjh2wN5zMvBFNjnwweO8tkSXUNepa9Seo1i0rq8M10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493645; c=relaxed/simple;
	bh=smPf3HQHlGL8bj9ImfSCLnQMSvvZIdxxS5/y97UCfEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4GHiZChuMIa/OPwRzvm1x+NykoTRdVmitVGrum8zKI/G/xjLHbGSt20EXiDaVs3tCuuc50tb3yxxZR5MFkyHP+6TzR7kxC4bJMItgn5XWBgiqkqXo4OCfRRD1TnMYWCYkHJAuB72nZ61mDiVMa8sREwlA4YDw+ZgIDT2WX4zqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T4tWxeOa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T4tWxeOa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lDfPrvRhSBcBBEhf6MXV+SXYA3jQVEOe1twBcHcuI1A=; b=T4tWxeOaTLfu59Tb77lwvSI1ng
	cvh9i29KcqwQVenLH6HSJ2eXWq5HaE3r6wDFqPlLIOlG9NJ9VR/ReOKh99GvwG4/GVwbuweefbkOx
	LA0+yaZnAb6aVm3DqevYyJPkdIKz8lPI7pdpReA0jsKLytt5knuIB7Xy/w0iE3capTwysnEOQtU3K
	nkGsf9tV+PDdoGNYTEEDDQE5dvcC16+zF2K1frsOCeiycnwrsL5tKlx1g/WAIQpW9fSnFGKQvsCKY
	KU200Mp/C4pXfc3upojSq9DWPRDVkrIAY95ymZ0fwehKqEZu3d4wvfzdIz7+7ljq8nsdJvzpKOhMO
	LKpd7llA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uns5b-00000006WYI-1f4j;
	Mon, 18 Aug 2025 05:07:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: kick off inodegc when failing to reserve zoned blocks
Date: Mon, 18 Aug 2025 07:06:44 +0200
Message-ID: <20250818050716.1485521-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250818050716.1485521-1-hch@lst.de>
References: <20250818050716.1485521-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

XFS processes truncating unlinked inodes asynchronously and thus the free
space pool only sees them with a delay.  The non-zoned write path thus
calls into inodegc to accelerate this processing before failing an
allocation due the lack of free blocks.  Do the same for the zoned space
reservation.

Fixes: 0bb2193056b5 ("xfs: add support for zoned space reservations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_space_resv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 1313c55b8cbe..9cd38716fd25 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -10,6 +10,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
@@ -230,6 +231,11 @@ xfs_zoned_space_reserve(
 
 	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
 			flags & XFS_ZR_RESERVED);
+	if (error == -ENOSPC && !(flags & XFS_ZR_NOWAIT)) {
+		xfs_inodegc_flush(mp);
+		error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
+				flags & XFS_ZR_RESERVED);
+	}
 	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
 		error = xfs_zoned_reserve_extents_greedy(mp, &count_fsb, flags);
 	if (error)
-- 
2.47.2

