Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1823C37A83B;
	Tue, 14 Jul 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030577; cv=none; b=uIoyUo+QweLPMMFEr8Npjs7IU2Q7NSSbQYA1rNBOWdmXUDrteHnlYer8VYLjs2VvmitPlWNTByKdq3Gd7w6EfhZnsm12n34U8vIdIpYAj5KKfRdoO+LNiD4GdddUkcJIoppepcJlxphqBIo/k0ttu/ByEiPQOkb3/RdRZQSOYas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030577; c=relaxed/simple;
	bh=ROrMdPdO6onErXT9M+OlhhdYLJOoqWpGS0WOQwDjFBs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HazZakktlupnyaL94v49bmcspKzk5/wOp3k4N04v35mIOee+RMxVFvxzKxiqS65coTYe1SWimPhEiafe5nla+bNbHMGKahd4J9rEyw+F9V2CHWnUZh6wU+nbK/sVQIEn5Ip7YPiC37HZliwqs70oYnouRw/uB00MRDsiNcQMkxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=S25TugjO; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="S25TugjO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1784030576; x=1815566576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xg7sx8Fcwnz35cM6X5s89ftjr56njrrKRxrcpCwNiT8=;
  b=S25TugjOgABs8xxtDueQjYFK8MMWr7GZ8FNGFf1Ljhg9JBNvAeXxPprV
   O4Bsu8ggFsGfsBIJrewQrNqS07g45zegrvVlYZJjVncR5dp7xjv+V3ylN
   E9M1xAcL1ANTV7qpJomsUXRbO8sbK1nxkupgYk4bpGgtKEuPrJUjdaYU7
   ty01/vGZZ+oOMuuiAwDF5Ob4R2DrHZgZEu5VGmvqWgw4Cf8Y+uegOowaX
   285DDdkQXArAlVPzPvr5sEYJWu+D5tX/Y+6L3WTs8z0/sGlM7PMlQtfYS
   8SbnwhKnQop+rZoxmjXXC4buSQh7zrQZj5pfgy6jKb4xylppws3AQ9Q4C
   w==;
X-CSE-ConnectionGUID: BBEVK6/MRkyicl38cs1lxQ==
X-CSE-MsgGUID: 4tRkKufeQB+DvyJnPm7R1g==
X-IronPort-AV: E=Sophos;i="6.25,163,1779148800"; 
   d="scan'208";a="23659306"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 12:02:52 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:17218]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.175:2525] with esmtp (Farcaster)
 id ac228d5a-c9a9-439a-935a-e5fef6abf6b4; Tue, 14 Jul 2026 12:02:52 +0000 (UTC)
X-Farcaster-Flow-ID: ac228d5a-c9a9-439a-935a-e5fef6abf6b4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 14 Jul 2026 12:02:52 +0000
Received: from cdd-al23.dub2.corp.amazon.com (10.253.66.177) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 14 Jul 2026 12:02:48 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hannes@cmpxchg.org>, <willy@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dgc@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<hch@infradead.org>, <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<stable@vger.kernel.org>, <surenb@google.com>, <vbabka@kernel.org>,
	<vbabka@suse.cz>, <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Tue, 14 Jul 2026 12:02:04 +0000
Message-ID: <20260714120204.542300-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
References: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hi Johannes, Matthew,

Thank you both for the alternative proposals. I've tested both
approaches on the same test environment used for v3.

Results (4 runs each):

  Config                   Avg TPS      % vs Baseline
  --------------------------------------------------------
  baseline (no patch)       70,735       -
  Johannes' approach       156,908      +121.8%
  Matthew's approach        70,145       -0.8% (within noise)


Johannes' approach (clearing __GFP_DIRECT_RECLAIM early in the
slowpath for costly __GFP_NORETRY) delivers the same ~2.2x speedup
as v3, as expected - it prevents the entire direct reclaim and
compaction machinery from running for these opportunistic allocations.

Matthew's filemap.c approach does not help in this workload.  The
reason is that the first allocation attempt at max order still carries
__GFP_DIRECT_RECLAIM and enters the slowpath with direct compaction
enabled.  The __GFP_DIRECT_RECLAIM clearing only takes effect for 
subsequent lower-order attempts in the fallback loop, but the costly 
compaction has already executed on the first try.

Let me know if you have any other variant you want me to test, 
or if I should prepare a v4 based on Johannes' suggestion.

This is what I tested for Johannes' approach:


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659..6e960c969e67 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4733,10 +4733,10 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 					struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
-	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	bool can_direct_reclaim;
+	bool can_compact;
+	bool nofail;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -4751,6 +4751,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;
 
+	/*
+	 * Costly __GFP_NORETRY allocations are opportunistic: the caller
+	 * can fall back to smaller orders.  Don't stall on direct reclaim
+	 * or compaction; clearing __GFP_DIRECT_RECLAIM makes the entire
+	 * slowpath treat this as a non-blocking request.  kswapd will wake
+	 * kcompactd as needed for background defragmentation.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,


Thanks,
Salvatore





AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



