Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793103758;
	b=qxVBtDbcp8e8Lp/5CSCCzjjry+iuq+Of7OGxl6ySMwsy1Q5FDCaKzW/G0uj2tXiIQ7hn
	 /cjiNchSsz0NrZgyrt7mOV+QiwwChZUxL0HfK2V2rRPEuLwJjd6h9Bxm9cjMHBejp4ZZm
	 lleHv2hOTh+mF7AshtglVaE7Rw259CLgQSTsqVJl2WU9Kq8Asmur+xEtl8UybK7F4icCk
	 aubrzyzuHX6DjJCMsr37WkebDaDwgYcjZzJd0sFOkAkfEnxsaKojcr7OAbZxSYJ1WNPKo
	 RS7laL2WEnKpcGuUQYeP692FhHQTCslhwbyya+qIIGMTaVLK5WGQ6JDXEXDWp4p0BzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793103758;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=31aiTvnWZc7MSGUa9bL+A7FtcCzalOqoYWv9RWdLupI=;
	b=yOqnuxjOs/CFo8Kxq0RAgnLutzwmme6XMu+JY93q/SlUbVItMTLPxcZtwgkUiAIMPi8j
	 gLAnzuAgigj27k3y+7WYGUAaSGP+CtX1Mo/4Z/yrQmOjhfrJKfj2QiKcYORKunw1qM2x6
	 /RgmgkhWt5NNNuucourG8U7WWYckvcv1RG9IwhGzSYvHW1zova7+YsP86OC64ED5n8XWk
	 aeFQjkIAsTQ/7kkIY5F3prM/n4NtOfyK76yfSXQyDzKcJNLfM1+6duSrXcqwPSC+2atwH
	 xjnYqiRxoilxFCIuev6iKX/Cohf1PRJ0btIBWUfRmZIHXR/d7qeM4LLbtteb5ImpqKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzVr0tO7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04C5606A31F;
	Tue, 27 Oct 2026 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzVr0tO7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584DE1F01825;
	Tue, 27 Oct 2026 12:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103757;
	bh=31aiTvnWZc7MSGUa9bL+A7FtcCzalOqoYWv9RWdLupI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lzVr0tO7Sg1LVQSf6cViyxlF87nH0y/4lTuZQIB1K8gP41N8K+twipT1TjQDGFCoc
	 MbzUgwPKSuR39pOr6/xN+BpriOw5Hn6UwnLP1ZuwtE3ZmIcPx5XKjGWMZvxMhVYX4w
	 F2+ZEUETgv7iD9Z1JhxknFGxakzdyXcF6YoIwZO0uSBtRgVowrqujqdoXnnplhpheR
	 tjeXUnVvat9yP8EZRQK5w+njSp4oqb77p6nsaHMoJj1KfJyc+BdfwOQ+UPd7js4rU5
	 UjzEAAZ5D+7Ha5TLzJUTfLYKq+GMHm/JSqf5EFpZljdtKZ7LAzREpIpAJHinsYBC8Q
	 5PLbLxkQ+bTpQ==
Message-ID: <668c53f7-20b4-4400-b442-71749db88d03@kernel.org>
Date: Tue, 27 Oct 2026 13:22:22 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
To: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, dipietro.salvatore@gmail.com, rvvandan@amazon.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
 miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org,
 hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, cem@kernel.org,
 dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org,
 willy@infradead.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, exfat@lists.linux.dev,
 fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, linux-xfs@vger.kernel.org,
 ntfs@lists.linux.dev, ntfs3@lists.linux.dev
References: <20261027112702.3747009-1-dipiets@amazon.it>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/26 12:27, Salvatore Dipietro wrote:
> Since iomap gained per-block dirty tracking, a large folio can be
> partially dirty: struct iomap_folio_state records exactly which
> blocks are dirty, and writeback only writes those ranges.  The mm
> dirty accounting, however, still charges the whole folio even if a
> single block is dirty (up to 512x over-accounting for a 2 MB folio
> over 4 KB blocks).
> 
> balance_dirty_pages() then throttles writers against a number that
> is unrelated to how much data actually needs writing back.  On
> workloads that repeatedly dirty small ranges of large folios --
> e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
> is crossed and writers are throttled long before the real dirty data
> justifies it.  On the benchmark below, run on v7.3-rc7, the
> unpatched kernel charges ~159 TB of dirtied pages while writing
> ~6 TB to the array, a factor of 27; with this series the dirtied
> pages charged match the data actually written.
> 
> This series makes iomap charge and discharge the mm dirty counters
> per dirty page for folios that carry per-block dirty state, so a
> partially dirty large folio is accounted for the dirty part only:
> 
>   - Patch 1 adds the mm infrastructure: an AS_DIRTY_PER_BLOCK
>     mapping flag, an @accounted argument to __folio_mark_dirty()
>     and __filemap_dirty_folio() to skip the generic per-folio
>     charge, and an address_space_operations::accounted_dirty_pages()
>     callback used by the discharge and migration paths instead of
>     folio_nr_pages().  No filesystem opts in, so it is a no-op on
>     its own.
> 
>   - Patch 2 makes iomap charge per dirty page from the per-block
>     dirty bitmap and wires iomap_accounted_dirty_pages() into every
>     iomap-based filesystem.
> 
> This was benchmarked with PostgreSQL using the pgbench simple-update
> workload on v7.3-rc7.  Average throughput rises 46.8% (139.8k ->
> 205.2k tps) and run-to-run variability drops from a 23.60% to a
> 3.98% coefficient of variation: the worst iteration improves from
> 97.9k to 191.5k tps, while the best gains 8%, 199.4k -> 215.9k.
> 
> Ten iterations per kernel, same database and workload (tps):
> 
>   Kernel                     Avg     Min     Max      CV   iters   iters
>                                                              1-5    6-10
>   ______________________  ______  ______  ______  ______  ______  ______
>   v7.3-rc7                139.8k   97.9k  199.4k  23.60%  164.4k  115.2k
>   v7.3-rc7 + this series  205.2k  191.5k  215.9k   3.98%  200.1k  210.2k
> 
> On unpatched v7.3-rc7 the worst iteration lands ~51% below the best,
> and throughput decays as the run progresses: iterations 6-10 average
> 30% below iterations 1-5.  With this series the decay is gone -- the
> second half is similar to the first -- and the coefficient of
> variation stays at 3.98%.
> 
> The over-accounting has existed since commit 4ce02c679722 ("iomap: Add
> per-block dirty state tracking to improve performance"), merged in
> v6.6, where the ifs bitmap started recording partial dirty state while
> the mm counters kept charging whole folios.
> 
> The throughput collapse bisects to the v6.17 readahead series, first
> bad commit c4602f9fa77f ("mm/readahead: store folio order in struct
> file_ra_state"), which lets readahead stay at the largest folio order
> once it has ramped up, so a single dirty block charges far more than
> is written.  Patch 2 therefore carries:


How does this relate to

[RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap writes

https://lore.kernel.org/all/20260903182943.662461-1-kirill@shutemov.name/

?

I assume they try to solve different problems, but would more fine-grained folio
dirtying also make your solution benefit?

-- 
Cheers,

David
