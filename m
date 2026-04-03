Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5110C3D669F;
	Fri,  3 Apr 2026 19:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775244982; cv=none; b=Tx1zABw9UeuGLWLejPvR4s3pp2sxu04HYfuEmk0TVJVwOC+Whpwh/X3I/hK5n7+CZLRYhKiZWg1xhJqlUxRyZCDmjg3ZEhYiIcHh+OG5ogqx+vjtfylnXu5jpZKgf3cxUZEcYqfyyQ/P6jRMlwCd9j+6MFOYkc337QPmoCBs1TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775244982; c=relaxed/simple;
	bh=ycG1vAoajTYWTQidO+jgNfLzn8hwwFmi4Xb0pSLdzKA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CMPMgK6UYfCz1/htTfiIKrqg6ZrbR8k8u2jnjyZmY3zbvq/hGZ1MNY+bQWMe4pOmGL0gsf9GrtuupBHIwionbFWI9ZULdUdfZwELsBw2ZJiRPMLdouTkHUVLwaUN4Y1p8+RfYT2JSoy5aCpw7nDqOJeBx+P7OGQDCpg2UXk2Sfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=c2Ae9m58; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="c2Ae9m58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1775244981; x=1806780981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EyFJJlejxGzTWLtg5fvYIh3yb3XlIEjqtxfx4waTmGo=;
  b=c2Ae9m589rlrdT4TE9NYUecvxjQ3SxuI7EDiK395LO8dVjRWPXg6ibO3
   SjV2oe4CYCwRsd/qwGio/bP/t/AIsSTgzNh/GhiFKLiJCL0lbWBwHFIaA
   5E9wn+Fq8/BW8ATclG93fBvG8FAXFTLbJwlyu3f4yZCY5/0y6UgWRLk7T
   H23DzGTohamRc6+zFghiAtnbV8XuiFGc1vNvr9z8BQUHzEw3XCQpl7pL5
   xN8PV5kLfn4kCgX2cW9cr5tGnSE3mvuBrjkprzBxwbvx1U/XnoHDmMEzI
   JLKMb9IFcTMw6XEMpHkRDJfa9SEjpXsKpc49J52UKhiJPl4/mi938w3gl
   w==;
X-CSE-ConnectionGUID: sFefx9B8RsmiP8qCy2pInA==
X-CSE-MsgGUID: 5HIbpn5wRSadE6H9a9+3oQ==
X-IronPort-AV: E=Sophos;i="6.23,158,1770595200"; 
   d="scan'208";a="16311994"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 19:36:18 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:3519]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.240:2525] with esmtp (Farcaster)
 id 96d4a6f2-3ad3-4cad-8eeb-a12490913bd4; Fri, 3 Apr 2026 19:36:17 +0000 (UTC)
X-Farcaster-Flow-ID: 96d4a6f2-3ad3-4cad-8eeb-a12490913bd4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 3 Apr 2026 19:36:13 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 3 Apr 2026
 19:36:13 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>
CC: <dipiets@amazon.it>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<abuehaze@amazon.de>, <dipietro.salvatore@gmail.com>, <willy@infradead.org>,
	<stable@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Fri, 3 Apr 2026 19:35:34 +0000
Message-ID: <20260403193535.9970-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260403193535.9970-1-dipiets@amazon.it>
References: <20260403193535.9970-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D039UWA004.ant.amazon.com (10.13.139.68) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the buffered write
path. When memory is fragmented, each failed allocation triggers
compaction and drain_all_pages() via __alloc_pages_slowpath(),
causing a 0.75x throughput drop on pgbench (simple-update) with 
1024 clients on a 96-vCPU arm64 system.

Strip __GFP_DIRECT_RECLAIM from folio allocations in
iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
making them purely opportunistic.

Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 fs/iomap/buffered-io.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 92a831cf4bf1..cb843d54b4d9 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -715,6 +715,7 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
 struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 {
 	fgf_t fgp = FGP_WRITEBEGIN | FGP_NOFS;
+	gfp_t gfp;
 
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
@@ -722,8 +723,20 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 		fgp |= FGP_DONTCACHE;
 	fgp |= fgf_set_order(len);
 
+	gfp = mapping_gfp_mask(iter->inode->i_mapping);
+
+	/*
+	 * If the folio order hint exceeds PAGE_ALLOC_COSTLY_ORDER,
+	 * strip __GFP_DIRECT_RECLAIM to make the allocation purely
+	 * opportunistic.  This avoids compaction + drain_all_pages()
+	 * in __alloc_pages_slowpath() that devastate throughput
+	 * on large systems during buffered writes.
+	 */
+	if (FGF_GET_ORDER(fgp) > PAGE_ALLOC_COSTLY_ORDER)
+		gfp &= ~__GFP_DIRECT_RECLAIM;
+
 	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
-			fgp, mapping_gfp_mask(iter->inode->i_mapping));
+			fgp, gfp);
 }
 EXPORT_SYMBOL_GPL(iomap_get_folio);
 
-- 
2.50.1 (Apple Git-155)




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



