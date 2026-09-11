Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E7B4756D5;
	Fri, 11 Sep 2026 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144338; cv=none; b=A3yP21OqTtZVeYoMCxUNa3/PcRoc41nLPCy85Qd5/5W0jnPsFg0LzAUlGCzUEzp+q9wToy3FHrHuIVo9xaTTX/Rjz+o63M917FRKKLaLTUugI2ZvNfQg6PfXCCMlbz3hymtJkgKy0ypPtDFEP9+kMvCYjJmlJOGw5+wIpA2DqLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144338; c=relaxed/simple;
	bh=qJkCbqia+PyvtsUo7qKbKv2ZL6lFALKHQ+NVremMqJY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MqSuvDvbaN9DzhelTi6TZUE++iKQS5/Ft6AStUsBKJ3P/4lIPo+67k5pmKaR8A9EDBwIn+zoQSajPyh4NTBaeE3TOi5ifHzKBDuCKaK3N1zKpxBDEDj/kgfbMimW5tBenWBxIS19llSzdS9APCtbcy8CNMdIFzPErATVKBz6XhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gy1m7qOG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gy1m7qOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C3D1F00893;
	Fri, 11 Sep 2026 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789144330;
	bh=j9rqeVVJkLJL7hyeN+ZhuUze7JPnMyhzvchT9akDlcM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gy1m7qOGyWRZPMTSfQJX9GQn8OMxswkKp0FjsuSudkheza3eMi6XvIr048H2mPW3M
	 PL8rI73VtGnov+Hua7Sm836ztsrYcARh0SXYdWOwul2HOk/YsGB76Z9LE6hNVa3jgU
	 bkeKe0wZLVavneFVz57sps8mALXwElCoNhR6bGFA=
Date: Fri, 11 Sep 2026 09:32:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
 <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
 <djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>, Vlastimil
 Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Christoph
 Hellwig <hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly 
 __GFP_NORETRY allocations
Message-Id: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
In-Reply-To: <20260911142102.2294202-1-dipiets@amazon.it>
References: <20260911142102.2294202-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Sep 2026 14:21:02 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
> for the whole slowpath by computing can_direct_reclaim (and hence
> can_compact) as false.  The !can_direct_reclaim check near the top of
> the slowpath then short-circuits to nopage: no direct reclaim, no direct
> compaction and no drain_all_pages() IPI across every CPU.  kswapd (and
> in turn kcompactd) is still woken further down for background
> defragmentation, so compaction keeps working for long-term system health
> while being removed from the latency-critical direct allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
> must-not-fail allocation is never made to fail.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
>   Config                                       Avg TPS   % vs baseline
>   AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
>   v7.3-rc1 baseline (no patch)                  59,408             -
>   v7.3-rc1 + this patch                        161,994       +172.7%
> 
> The patch fully recovers the pre-5d8edfb900d5 performance, bringing
> throughput back above the pre-regression level and well clear of the
> ~59k baseline.  The AL2023 6.1 row runs a kernel that predates commit
> 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
> directly comparable, but it shows the pre-regression level and confirms
> that the ~59k baseline is the anomaly and not the norm.

Thanks, I'll update mm.git's mm-hotfixes-unstable branch with this.


> v5: Derive the decision into a local flag instead of mutating gfp_mask

The acks from vbabka, hannes and hch were dropped.  Fair enough -
that's always a hard call.

Sashiko is worried:
	https://sashiko.dev/#/patchset/20260911142102.2294202-1-dipiets@amazon.it

That's different from Sashiko's v4 complaints:

	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it

does any of this look real?
