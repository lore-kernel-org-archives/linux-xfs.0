Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF1915AADA;
	Fri,  2 Oct 2026 01:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790904585; cv=none; b=Q6oWgAp5f+gDZt2/r/faT2dv2Lnma+9Dhqb/zH1VBmWt5994CuEBU8J7wSP/PwWedV3XetiTyILoWgD+CIUSOp4wDF7fmY2ZOxJPlcgYQecRQDbPKuBnx2vfYlpIa5DCEDVDM1YvuuVFBf+CJFVLwaffdBzzbGLLMWG58iiuJiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790904585; c=relaxed/simple;
	bh=lHURfXoURknJ3N/9r/GCs8wcSNR9cgG4kpoNPpPBb5g=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KSo4GGcLitlkdYjhO0iG7+mAsxXLNMw7LTy/TYiyEb/Lsd7+oOn0SAiXu+E3ce5cSxecGGVm5rxO7YKe8l/PcXxSIwCALson1qKQPgNsVcwyQ9jD1k1kXD6GOXjweEPskR94PmqTfboHyCfJ8T0C+ETCRySW3hXEZtoDNU/oPiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=di0yheFH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="di0yheFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173371F000FF;
	Fri,  2 Oct 2026 01:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790904583;
	bh=8FIg5FXy4zOZML/f78uAixbt9TN0WD896MWP9AFfIGc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=di0yheFHYCqpLXGt5+MvEWADBIG93td4CBzLsqMSvgr5rKyaRQygTLOsJxj0YDw/9
	 fc6OapNZKx3bK/51wWy42aHgWwQV0KcN44VcKOKjepA58eiVbSWIow+ef0Xh8UrTtz
	 XAbMvWOS71tJlBtZeYV9WzCduDvr8jU1YNO8ufoM=
Date: Thu, 1 Oct 2026 18:29:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
 <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
 <djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>,
 "David Hildenbrand" <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
 "Dmitry Ilvokhin" <d@ilvokhin.com>, Brendan Jackman
 <brendan.jackman@linux.dev>
Subject: Re: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction
 for costly __GFP_NORETRY allocations
Message-Id: <20261001182942.ce99faa753fb9d9bd2efec1e@linux-foundation.org>
In-Reply-To: <20261001082152.2879289-1-dipiets@amazon.it>
References: <20261001082152.2879289-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Oct 2026 08:21:51 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct reclaim, direct
> compaction and drain_all_pages(), causing a 0.38x throughput drop on
> PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
> system.
> 
> The root issue is that direct reclaim and direct compaction are too
> expensive for hot allocation paths that have fallbacks to smaller
> allocations.  __filemap_get_folio_mpol() already marks higher-order
> allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
> caller can handle failure.  However, the page allocator still enters the
> full blocking slowpath for costly orders with __GFP_NORETRY, which is
> unnecessarily aggressive when the caller will simply retry at a lower
> order.
> 

Thanks, I'll update mm-hotfixes to this version.

Here's what changed:

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4930,8 +4930,11 @@ retry:
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

