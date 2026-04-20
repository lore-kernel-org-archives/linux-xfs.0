Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC8E2BD11;
	Mon, 20 Apr 2026 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701669; cv=none; b=ZUs3iLCcEb+ReQeXNUkcfgGLntAOdaR2Mm/5K2IrYXhzSbNiWSUS71t5XMCnj1MX9W96cHfAi8icib+YhQWU4mMTzT6M26F2jNXpaRxX8oFqzEv3ZSa3TqaBocAGKW49GI0osfF8xqXHQ3fITxmAF7E2j6BOshuAi7Y94gR1+sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701669; c=relaxed/simple;
	bh=IxT1LCOphsr/axVCQFZQgJDOzZ5ZGnLfGZfIgVmWzYo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TWRTllb0GXI+C3RmkiecbrhtJfw3dbRtQmuSzX/JAFdDK3rdqN6ARe3zjerFSeb642MCS6o6D6gkSythwkJxG/8/JIoL4V/Ua8tHnsa4NuHZ8gkRee9gcRs57qTFYzPgOyIWvQGdJIQequbQJt4wyYDpybUvAMjD0F6E22U9u7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=Fvx9EM4L; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="Fvx9EM4L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1776701667; x=1808237667;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4O++pW9Xbgus6i0sqISNyUGab6AsMHTSYNj1rQkW9es=;
  b=Fvx9EM4LCKhnJKyORTFEvof8XQbqS66CJYl9BN6ec9LemJNBQLpWUa5d
   yGSn30o13Byp6813v7AeYsqS36N8OH3zJ9Y2nX+fpE6kJ2gDhNC+Wa93r
   xiqHDDGWh05RR6bA13QbmBf3bXP1iZD1w7c6RlODyMY7IDlE6eOmjT6b4
   MgDTq0rkCpnRx1f2OyncTNOeVNwtL8sHuI7KuML0qrkTd14XhbOx48Hni
   HYH7QjgeKtcBRqLs30z8SSGO4WsF7BZUEx2Y8ud/CVyDvPgPp0MYZuo2d
   mY/9aRF/SOj2aNiv98CG+pvxp3XUM5lxd6Gzj1M/mG3xgZcPJ3b4EkgEE
   w==;
X-CSE-ConnectionGUID: fItFHySZTnKCgGaNsgSP0w==
X-CSE-MsgGUID: M5YpE+EUQMKeBZiFi0AZ1Q==
X-IronPort-AV: E=Sophos;i="6.23,190,1770595200"; 
   d="scan'208";a="17744120"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 16:14:24 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:15252]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.92:2525] with esmtp (Farcaster)
 id 0fb7fa6e-3822-49ea-b8c0-62c3590e6f16; Mon, 20 Apr 2026 16:14:24 +0000 (UTC)
X-Farcaster-Flow-ID: 0fb7fa6e-3822-49ea-b8c0-62c3590e6f16
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 16:14:24 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 20 Apr 2026
 16:14:23 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>
CC: <ritesh.list@gmail.com>, <abuehaze@amazon.com>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dipietro.salvatore@gmail.com>,
	<dipiets@amazon.it>, <djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, Andrew Morton
	<akpm@linux-foundation.org>
Subject: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio allocations
Date: Mon, 20 Apr 2026 16:14:03 +0000
Message-ID: <20260420161404.642-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the buffered write path.
When memory is fragmented, each failed allocation above
PAGE_ALLOC_COSTLY_ORDER triggers compaction and drain_all_pages() via
__alloc_pages_slowpath(), causing a 0.75x throughput drop on pgbench
(simple-update) with  1024 clients on a 96-vCPU arm64 system.

In __filemap_get_folio(), for orders above min_order, split the
allocation behavior by cost:

 - For orders above PAGE_ALLOC_COSTLY_ORDER: strip
   __GFP_DIRECT_RECLAIM, making them purely opportunistic. The
   allocator tries the freelists only and returns NULL immediately if
   pages are not available.

 - For non-costly orders (between min_order and
   PAGE_ALLOC_COSTLY_ORDER): use __GFP_NORETRY to allow lightweight
   direct reclaim without expensive compaction retries.

With this patch, pgbench throughput recovers to 148k TPS (+67% vs
regressed baseline), stable across all iterations.

v2: 
- strip __GFP_DIRECT_RECLAIM to avoid costly reclaim for high-order
  folio allocations
- Moved fix from iomap to mm/filemap layer

Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/filemap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..f2343c26dd63 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order > min_order) {
+				alloc_gfp |= __GFP_NOWARN;
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
+				else
+					alloc_gfp |= __GFP_NORETRY;
+			}
 			folio = filemap_alloc_folio(alloc_gfp, order, policy);
 			if (!folio)
 				continue;

base-commit: c7275b05bc428c7373d97aa2da02d3a7fa6b9f66
-- 
2.47.3




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



