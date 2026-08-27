Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766EE12F585;
	Thu, 27 Aug 2026 09:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787822492; cv=none; b=kHiwzDbXtV40kQAhAq3nMPTp/zkc4HlLDoZJOLkYpRT6HWvM4yDqf5cLhcMrZpxtOmkDQ++h1JN6bavtZBWNiiJdiT5A30rM3EycJNJmtS9PRioqnIn1J9N+GuhICv9BwCeLXLZIqZT35/ym/W050B68DfZxS/soidmESVS7Ga0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787822492; c=relaxed/simple;
	bh=4IzhJh3lBWAOHfE4wJbpsM9iGrvkz87YVBb3Imb3jJM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lh+hDmD+TsidZ2uDP6VFSuODTkee2CzB0nYi2iNAIwelXDaKk7l3QveOdrSkXegFMoBUrryRejGIx1GvMrWy/bzrPyo7zdn7SHXpn9HHYDoWvDgyp167K7+RB5lhz9dy4L1x25s1r69rcpRhcg+cPUtZR2l3pjMwft6KTs84T0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=dPRMr4HX; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="dPRMr4HX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1787822490; x=1819358490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x7TNb3PzZ5LF/z0aOAcLHf9VQM7UzSXd9dJnzyzxr1A=;
  b=dPRMr4HX8uEBgzbwATOM8D755h7xcAGuGer1Z80qt+JWXoCvDZb1q/da
   e2ExPLrLGjutSQyNMXGGMJPVahdXT+LjoCDrl83eYn8GyBBZNRTRLMBrD
   LxfbpH357Ez6KueLWxSaLHUeFSAVc9/Fj3TCZ1RhVj1zOSxQWffxbjD39
   GdVaOrPnIBbC2u0pTmpAs3IklouK69/8g5t2WVujyzgD9JcnxWJeBaDk0
   EN+82sqJEhzZwfYTFuflFwFckTVtJcHefBXZw7+BWdtvdEdzF0zKtQczA
   If8BaTRJ9GYKXxNZPAc+cBgPqbimbHy212DRj37pZB1xEiBebLRzAFK1d
   A==;
X-CSE-ConnectionGUID: TIVzVIwxQRGxNhHQ7zupIg==
X-CSE-MsgGUID: HUlh8tT+SpuI9Eceq6oHvA==
X-IronPort-AV: E=Sophos;i="6.25,246,1779148800"; 
   d="scan'208";a="26899945"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 09:21:28 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:31814]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.244:2525] with esmtp (Farcaster)
 id 3d6197ce-b226-432b-8cc0-0137c0d8e6d7; Thu, 27 Aug 2026 09:21:27 +0000 (UTC)
X-Farcaster-Flow-ID: 3d6197ce-b226-432b-8cc0-0137c0d8e6d7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 27 Aug 2026 09:21:27 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Thu, 27 Aug 2026
 09:21:24 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <vbabka@kernel.org>, <hannes@cmpxchg.org>, <willy@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <rvvandan@amazon.com>, <brauner@kernel.org>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hch@infradead.org>, <jackmanb@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Thu, 27 Aug 2026 09:21:00 +0000
Message-ID: <20260827092100.3988386-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
References: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Wed, Jul 22, 2026 at 02:35:00PM +0200, Vlastimil Babka (SUSE) wrote:
> AFAICS both your v3 and the implemented Johannes' suggestion effectively
> make all the compact_first logic dead code - at least for the intended THP
> use case based on costly_order. It will only continue to do something for
> the non-movable order>0  case. So that's a significant change which will not
> show up in your results, but might affect other workloads (I'd expect mainly
> by having fewer THPs).

Right - the change above modifies THP allocation requests as well. So instead
of applying it to every costly __GFP_NORETRY allocation, I restrict it to
callers that do not ask for __GFP_THISNODE. That leaves the local-node THP
attempt untouched: the same bit pair is already tested further down the function 
to bail out of the compact_first block (page_alloc.c:4899), and alloc_pages_mpol()
sets both flags on the local-node-first attempt (mempolicy.c:2476-2478).

I tested this with my PostgreSQL workload on kernel v7.2-rc7 and results look good:

Baseline:       70,735 tps
This version:  144,670 tps  (145,280 / 144,037 / 144,694)  +104.5%


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..1e4b0c1e7296 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4725,10 +4725,10 @@ static inline struct page *
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
@@ -4743,6 +4743,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;

+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



