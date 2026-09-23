Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59AA446074;
	Wed, 23 Sep 2026 09:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790155583; cv=none; b=K7+G/Chv6HVydMY8lTiw1AFrKZVBpaXxgAT06r48Se2gpZwSZQoIimw0A9werFC4xF0I8JtxGmBC+nqDVJ0aLSgRiZjrt3khSdBc0uHirM7KF5WmPcjSxO9uT+uIBv3dtqzgU7SXA9c8P61x5B97aS08ngC11EMKyciSW8Tir1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790155583; c=relaxed/simple;
	bh=YZHzbEixna3Eo+/4Y7t3C4H7+hX+/vEpExN0RBbdF8g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KC47bTo4KIWRgnfiEXfU+IfJXof81EhLjOItHIUaD5tgDu1DRhl5XlU9AtQRcI+K/Gbc8GfRNSvVjOe1JA+9fFQChaNMf5aI+5SRV5/aVV+3gAZV8OdP+PHyseInHAwn1XnkxnHOcq/AKaKKPWmxaDoZdSl1AlaVTquqdb37X14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=tHRCIe6z; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="tHRCIe6z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1790155581; x=1821691581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cN5MLZiwNeqRdcxWX8m8G6mrJrXWNABdWnBEab4FCPQ=;
  b=tHRCIe6zHPBgtJBX5x9OZu4OqU8lwtIDi3Ef/Ipa/dQLZ6IHSuyVkeP+
   IobN4wDQTXEoYH22k0XRuLPU7BS64VoeWBwtuRQBKwNq4n03Oqr0XMVgz
   zxVPCM8RJK394dd5s2nyINU04TMvjq0UPySJtGLPwa2DshA5eZiv9Uz6r
   t/C1eOaJghKyzC+Pyr4ftCueHvaUpQCXdjyC1LwhzACoea2s50SCFHXsn
   BqejQSz14Cbi95zuiyVj6A4RfNFpbcAL9h1qSYkZguxFAERfsdSkrtWQS
   eLj40drnLD+hjA+PnWlQQFpqra267cBfK7RzwSg2rKjoPGBoMITU31dgI
   A==;
X-CSE-ConnectionGUID: Swfc1b/cRayzY0r31UWeqw==
X-CSE-MsgGUID: rikSOqHrQaeO+po9b2UnIw==
X-IronPort-AV: E=Sophos;i="6.27,118,1787011200"; 
   d="scan'208";a="29214507"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 09:25:29 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:5405]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.59.1:2525] with esmtp (Farcaster)
 id cd567582-b90f-43f2-a34a-5f02aae20a7f; Wed, 23 Sep 2026 09:25:29 +0000 (UTC)
X-Farcaster-Flow-ID: cd567582-b90f-43f2-a34a-5f02aae20a7f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 23 Sep 2026 09:25:29 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Wed, 23 Sep 2026
 09:25:25 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <willy@infradead.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <rvvandan@amazon.com>, <stable@vger.kernel.org>,
	<surenb@google.com>, <ziy@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Wed, 23 Sep 2026 09:25:12 +0000
Message-ID: <20260923092512.101833-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <6c94405a-48e4-4842-a096-e2fbbbaa862f@kernel.org>
References: <6c94405a-48e4-4842-a096-e2fbbbaa862f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On 9/19/26 06:13, Matthew Wilcox wrote:
> This patch is still piling hack on hack.  We haven't made a serious
> effort to understand what's going on, we're just adjusting flags until
> things stop sucking.

I have tested two new kernel patches on v7.3-rc1, each isolating one behaviour
(diffs at the bottom), and ran the same pgbench simple-update workload
(1024 clients / 96 threads / 1200s, 3 iterations each).  Baseline is the
unpatched regressed kernel; target is ~135k, the pre-5d8edfb900d5 number.

  Config                                          Avg TPS   % vs baseline
  v7.3-rc1 baseline (no patch)                      59,408            -
  (a) post-reclaim drain step skipped               70,615       +18.9%
  (b) compaction disabled only                     107,210       +80.5%
  (c) v4 (full non-blocking, reference)            154,835      +160.6%


We can notice that:

1. The drain_all_pages() IPI is not the driver.  (a) skips the whole
   post-reclaim drain step for costly __GFP_NORETRY -- that is
   unreserve_highatomic_pageblock(), drain_all_pages() and the retry
   together -- and the entire step is worth only ~11k of the ~96k gap.
   Whatever the split between the three, the cross-CPU drain cannot
   account for the bulk of it.

2. Turning compaction off is not enough.  Your gfp_compaction_allowed()
   one-liner (b) gets about half the gap, and it declines across
   iterations (135k -> 98k -> 89k).  It drops compaction for
   __GFP_NORETRY at every order that can use it, __GFP_THISNODE
   excepted, not only at the costly order v4 gates on; the decline is
   consistent with the zone no longer being repaired.  (c) only makes
   the costly attempt non-blocking and leaves kswapd/kcompactd working,
   and it does not show the decline.

3. We have collected metrics to understand how often the
   allocator stalls and normalised to a million page writebacks (nr_written),
   over the same 3 x 1200s iterations as above:

                                        compact_  allocstall_   pgscan_
                                           stall      movable    direct
     v7.3-rc1 baseline                       513          277    90,230
     (a) post-reclaim drain skipped          912          472   129,249
     (b) compaction disabled                   0          778    44,737
     (c) v4 (full non-blocking)                5           39     4,407

   The baseline enters stall compaction ~100x more often per page written
   than (c) does.  (a) makes all three metrics worse.  (b) removes direct
   compaction entirely (0 stalls) but does not remove the work: it enters
   direct reclaim 2.8x more often than the baseline (778 vs 277
   allocstall_movable), and still does half the baseline's direct scanning
   (44,737 vs 90,230 pgscan_direct).  (c) cuts both instead -- reclaim
   stalls 7x lower and direct scanning 20x lower (39 and 4,407).
   That is why (b) recovers only half the gap -- the stall moves from
   compaction into reclaim instead of going away.

If you agree this is the right direction, I am happy to send a v6 with
(c)'s behaviour plus the defrag_mode fix discussed in the v5 thread.


Thanks,
Salvatore


---
For reproducibility, here is the exact diff behind each measured row
above (all against v7.3-rc1).

(a) post-reclaim drain step skipped -- 70,615 tps:

  diff --git a/mm/page_alloc.c b/mm/page_alloc.c
  --- a/mm/page_alloc.c
  +++ b/mm/page_alloc.c
  @@ -4487,7 +4487,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
   	 * pages are pinned on the per-cpu lists or in high alloc reserves.
   	 * Shrink them and try again
   	 */
  -	if (!page && !drained) {
  +	if (!page && !drained &&
  +	    !(order > PAGE_ALLOC_COSTLY_ORDER && (gfp_mask & __GFP_NORETRY))) {
   		unreserve_highatomic_pageblock(ac, false);
   		drain_all_pages(NULL);
   		drained = true;

(b) compaction disabled only -- 107,210 tps:

  diff --git a/include/linux/gfp.h b/include/linux/gfp.h
  --- a/include/linux/gfp.h
  +++ b/include/linux/gfp.h
  @@ -380,7 +380,8 @@ static inline bool gfp_has_io_fs(gfp_t gfp)
    */
   static inline bool gfp_compaction_allowed(gfp_t gfp_mask)
   {
  -	return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO);
  +	return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO) &&
  +		(!(gfp_mask & __GFP_NORETRY) || (gfp_mask & __GFP_THISNODE));
   }



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



