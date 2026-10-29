Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253319;
	b=iAI6nyjyTt3Pr8RVd/TwVaJFkC4saRByRwgPezgGPDC8te9d6z5equSRsjzvctdFwNji
	 uhEeQVj6TBreD3PltQg6I+rtCDz6aApXgtSDioP6wXPybm60eZ0sunkt4d8da2TPF+VDI
	 fPZU8y1Um+nVSWFse6Y+W4p9NrBWt5mpktg8EwNsbkcjMDHYAjMlg0sk+sTnDW98cmDQC
	 6vVMsfXDcO0A3LsuSjXpWsY4JGk+OA+v55TQnETYxTAJ7vfTJ+kNpuXKj2oCM/Vd4VI7h
	 pVFP3fBr+/MkrSViozq1/WaGhjz/5cdErO+BT6qlE69sFSUOUcuwH9jcLwk4jYWaI8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253319;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hddx7cW1nUVz3kkMDf5xox3K0/URdftdZ51g0o1y9xk=;
	b=cyHumlj2SLQlNBQxkS7jhQkE/q9L81bG3o53wddanZ7XjhTaVFvbY3iCgs9WZWb0TCen
	 YWmmUWX0L/BYx6t+so8f4LqVxXKqPAtizbF0I+V15zYrtQSFF9ArwFvu/6wrhpK3SJHe4
	 q3Mjgp4TKjmz/zFc2Z8Z3iX4vJpVnpqXN2QNucTbxaRn5BKzQfBO9Ua81r2pQItj/c0em
	 CincXWwwC2dxYTwz0+m0KAhXTL0aqu0CBCNI5HCuIdV1jc4oUQqGVgfZwfMhFkwnUHscu
	 0RykMOMcNwB45RKRmla9ncjzMe63/nX+R8jbC70fXHmikwLxOstJ6a3/Od5+j5+ym4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CzzFQDyd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1D6606A31A;
	Thu, 29 Oct 2026 05:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CzzFQDyd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BC21F01825;
	Thu, 29 Oct 2026 05:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793253319;
	bh=hddx7cW1nUVz3kkMDf5xox3K0/URdftdZ51g0o1y9xk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CzzFQDydrJtAi2nM2ke5/ieg4gB6r0aQxtJggHBc49Wvn3D68/5DrhEf5hGSC7tK7
	 aNRgjcj/Sgj0ZwCermfUWR69bU+QqkajLJL75XVXc6kklaiII0Sir8NYw9rH8LLYlD
	 7x5kovjRCSppfOyZkbk27wxx43tUAitJVCv8iEyQ=
Date: Wed, 28 Oct 2026 22:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Salvatore Dipietro <dipiets@amazon.it>, hannes@cmpxchg.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, matt@readmodwrite.com,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
 willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-Id: <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
In-Reply-To: <20261028144148.GA14023@lst.de>
References: <arFBr22V60BMmVpl@cmpxchg.org>
	<20261027150002.318916-1-dipiets@amazon.it>
	<20261028144148.GA14023@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Oct 2026 15:41:48 +0100 Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> > 
> > Hi Johannes,
> > 
> > Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> > before these two patches land, so Andrew parked v6 at the tail of
> > mm-unstable and dropped its Cc: stable until then.
> > 
> > Are you still planning to work on 1/2 and 2/2, and if so, do you have
> > a rough ETA? Or would you rather post them as a separate series as
> > they are? If anything is needed on my side to move them forward, I'm
> > happy to help.
> > 
> > For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> > no performance difference on my benchmark with or without them.
> 
> It would be really important to get some fix for this into 7.3.
> We can still perfect it later.

What is "this"?  You're referring to the performance regression which
Salvatore's "mm/page_alloc: avoid direct reclaim and compaction for
costly __GFP_NORETRY allocations" addresses?

In
https://lore.kernel.org/all/9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org/
vbabka indicated that Fixes: 281dd25c1a01 is needed on that patch.  The
patch I'm sitting on (below) has Fixes: 5d8edfb900d5.  Please clarify.

In
https://lore.kernel.org/all/c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org/
vbabka argued that Salvatore's "mm/page_alloc: avoid direct reclaim and
compaction for costly __GFP_NORETRY allocations" should be a 7.4 thing.

So it's all clear as mud.  Can people please clarify?

I have hannes's series "mm: page_alloc: fix reserve access for
non-blocking requests, v2" in mm-hotfixes, planned for 7.4-rcX.

Should I move Salvatore's "mm/page_alloc: avoid direct reclaim and
compaction for costly __GFP_NORETRY allocations, v6" into mm-hotfixes
also, and restore its cc:stable?

My vote: "yes" - that's a pretty obnoxious perf regression.


From: Salvatore Dipietro <dipiets@amazon.it>
Subject: mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Thu, 1 Oct 2026 08:21:51 +0000

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path. 
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct reclaim, direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the caller
can handle failure.  However, the page allocator still enters the full
blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  Reclaim and compaction move to the background instead: kswapd is
still woken for reclaim, and it wakes kcompactd for defragmentation.  The
system keeps its long-term health while the latency-critical direct
allocation path no longer stalls.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
!can_direct_reclaim bailout, which since commit 4c0ed883e051
("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on. 
With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
by fragmenting another migratetype's pageblock.  That is the wrong trade
for a caller that has already communicated it can handle failure and has a
cheap lower-order fallback, so exclude __GFP_NORETRY from the relaxation. 
The exclusion is not restricted to costly orders: any __GFP_NORETRY caller
has said it can cope with failure, so failing is preferable to fragmenting
for all of them.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                                       Avg TPS   % vs baseline
  v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
  v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
  v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
  v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: Geoff Blake <blakgeof@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <dipietro.salvatore@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <rvvandan@amazon.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Garg, Shivank" <shivankg@amd.com>
---

 mm/page_alloc.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4773,10 +4773,10 @@ static inline struct page *
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
@@ -4791,6 +4791,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
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
 		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
@@ -4907,8 +4919,11 @@ retry:
 		 * Reclaim/compaction cannot run, so defrag_mode's strategy
 		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
 		 * fallbacks rather than failing the allocation outright.
+		 * Not for __GFP_NORETRY: those have a cheap lower order
+		 * fallback, so failing beats fragmenting.
 		 */
 		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
+		    !(gfp_mask & __GFP_NORETRY) &&
 		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
 			alloc_flags &= ~ALLOC_NOFRAGMENT;
 			goto retry;
_

