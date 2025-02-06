Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8DF225794
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824406; cv=none; b=tMi7vmbNmvU/J8HdUeObeZ0POlxPeVyoBFWY3dtoXdmK2IAUZXn/Q0JXo6YMw1Q2PDs7hteTQwodOoczo8ps3uHBGkiFlVD4uACgkBUFdBy8g/iTwaSm4e0aIUs9szf2HWpb62JJCPqVOwkUmImWZ9TZZ/R0CeSARjGSM5UNsg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824406; c=relaxed/simple;
	bh=YaRSDc37e9SSI07H4umeqHUnh8G7PRy3OFvtCy8N8fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzCuxdQuKwV4Bx+R+9ovfGXMSarBlKtV1r5v+gOXCpVwpaupB6xqCf0LL8rCzhhdeMqr/P1EmJ85vCqcQI9gBIE9iXbcfvLYE8PREDhIxAwnt4dDq/J7lv1sJRAiAwV7gFw9aV8vepKlEbo1z7KmW01caSc5zGWEh4KCn3cQEV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=43nC46C5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="43nC46C5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aNS/FCyuRkY6wB/BekV8qeaTNuun9ZK3wiprwFV8Upk=; b=43nC46C5fCBoBC2bbbn2pUzuYl
	no2eZGqplTZoW9x2Nxa5vFnHmoHYXxXkWFkkVLltubpO7cOvnRwg/J74ZfmM90ulcSaowhnglvAB8
	NV35c5ZoGhTA3GKz6sF5Ze5S3pgbi0SrnEjccer2ukEeb+o5C+gnPcmpSnKqoFj7S5Zp3K11a1loA
	fYCn2tX11UmuGnkmiAzeJoWOVcI2xdK7MC/yWMf1YxJMdie+9Tf9j62v3D77KvbiSTD6fQYtXhWok
	vAVUUmEGAqNCjyVRzIHKCunsJYqnZ0YY6PdrrrvIXVUmsINoO+37nYvd/BkMLk5CPlPU4iaOXbIr1
	+O5fFQkQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfveu-00000005Qke-3zbI;
	Thu, 06 Feb 2025 06:46:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 32/43] xfs: support xrep_require_rtext_inuse on zoned file systems
Date: Thu,  6 Feb 2025 07:44:48 +0100
Message-ID: <20250206064511.2323878-33-hch@lst.de>
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
 fs/xfs/scrub/repair.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 5cdaf82aee7b..8e4d60567a21 100644
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
@@ -1050,7 +1051,13 @@ xrep_require_rtext_inuse(
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

