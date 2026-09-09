Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9373B2FF6;
	Wed,  9 Sep 2026 08:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943884; cv=none; b=JFk2xatdyi3HfZae3YXZreeSailNt6PgTCPa8aGtKWr/gDm7hwTE+tiUCcHFVo29xhHtfO/p5zspnjt7ox/cXP0W+DKk590sBjso2E3eGzAfba9GJcIU8kByirpAMHUXlLigcCw8zuC7IQ9BSUYc63kxftul0U0orNdqHvC98o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943884; c=relaxed/simple;
	bh=aaqMu1tmZtXJlOXunQmITNDvsgsQ2oHZDw4CFPBismk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T9zOMDhViohJbAlQvbyD+sAaqXpnP6ls1J94TRa2gC96gcJNM/7G/1lCnUkT+Q37B3MeZk7pqtmLLlt3CCWcLph0eZWcBW68eOniZGpa66WK2oGBXcivmsF1T5dOUeXt/MZ73xBNEmBNZMz+Xp2ScuxlFvg7mVP+WvFavbXahFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTmQVz9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTmQVz9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30301F00A3A;
	Wed,  9 Sep 2026 08:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788943882;
	bh=mnk0hPT4sffETdV0mh4vAIasNMlh24tjM8SmeuoAs+8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mTmQVz9Z9Hv34x6rP0CcXhb0TeSpmKy5g/ZD1EeY+4l3Q2I/Z2n9wrk8EhABbHu25
	 DIjn0hPfgQ6fXerAzAziLllB4L2j7CuRZ7waS6Y+JmtS1fraWkUlgyUOAIEiQGC+o+
	 DsE4HpXV1D6BrQC4tLTSIhXSAD1+m8q+sO1cu6pF9qhfw5uJbamI5TpSE1tRKFhhn8
	 /oK5u3T1fN5dyaDBh+U86KZLdIOMGU+wKGki3jIztCT7F6R36GQn4Q4pF1HDxc5Y34
	 7OsdIZThb2D5EZhyRQqLbRZxbBdSoaLhy34DijqwwZwFYe3Xe+ZFzUbvjRD10zb+aA
	 ombHMJdHimuhg==
Message-ID: <dff624e7-0c64-4c90-ba50-fec3e6337c1b@kernel.org>
Date: Wed, 9 Sep 2026 10:51:16 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Salvatore Dipietro <dipiets@amazon.it>,
 linux-kernel@vger.kernel.org, hch@infradead.org
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hannes@cmpxchg.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, David Hildenbrand <david@redhat.com>,
 Christoph Hellwig <hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
References: <20260904115629.3993331-1-dipiets@amazon.it>
 <8cc503d9-04a1-4d90-874c-ada6c0ac5147@kernel.org>
 <DL6MKKOOL5DX.1R3Q77UTXBFYT@nvidia.com>
 <be13228a-f35e-4868-9b56-6452c34abc60@kernel.org>
 <DLAFND3OZSN5.2QM9WPRWMQSZ0@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DLAFND3OZSN5.2QM9WPRWMQSZ0@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/26 04:33, Zi Yan wrote:
> On Mon Sep 7, 2026 at 3:30 AM EDT, Vlastimil Babka (SUSE) wrote:
>> On 9/4/26 17:08, Zi Yan wrote:
>>> On Fri Sep 4, 2026 at 10:11 AM EDT, Vlastimil Babka (SUSE) wrote:
>>>> On 9/4/26 13:56, Salvatore Dipietro wrote:
>>>>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>>>> introduced high-order folio allocations in the iomap buffered write
>>>>> path.  When memory is fragmented, each failed costly-order allocation
>>>>> enters __alloc_pages_slowpath() which runs direct compaction and
>>>>> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
>>>>> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
>>>>> 
>>>>> The root issue is that direct compaction is too expensive for hot
>>>>> allocation paths that have fallbacks to smaller allocations.
>>>>> __filemap_get_folio_mpol() already marks higher-order allocations with
>>>>> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
>>>>> failure.  However, the page allocator still attempts full direct
>>>>> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
>>>>> aggressive when the caller will simply retry at a lower order.
>>>>> 
>>>>> For costly-order allocations with __GFP_NORETRY, clear
>>>>> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
>>>>> can_direct_reclaim, can_compact and the nofail checks are evaluated.
>>>>> This makes the entire slowpath treat the request as non-blocking: no
>>>>> direct reclaim, no direct compaction and no drain_all_pages() IPI
>>>>> across every CPU. kswapd (and in turn kcompactd) is still woken further
>>>>> down for background defragmentation, so compaction keeps working for
>>>>> long-term system health while being removed from the latency-critical
>>>>> direct allocation path.
>>>>> 
>>>>> Allocations that also request __GFP_THISNODE are exempted.  That flag
>>>>> pairing identifies the local-node-first THP attempt issued by
>>>>> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
>>>>> form transparent huge pages.
>>>>> 
>>>>> Test environment:
>>>>>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>>>>>              12x 1TB IO2 32000 IOPS RAID0 XFS
>>>>>   OS:        AL2023
>>>>>   Kernel:    v7.3-rc1
>>>>>   Database:  PostgreSQL 18.4
>>>>>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
>>>>> 
>>>>> Results (average of 3 runs, TPS):
>>>>> 
>>>>>   Config                   Avg TPS      % vs Baseline
>>>>>   baseline (no patch)       59,408       -
>>>>>   With this patch          155,409      +161.6%
>>>>> 
>>>>> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
>>>>> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
>>>>> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
>>>>> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>>>> Cc: stable@vger.kernel.org
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Michal Hocko <mhocko@suse.com>
>>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>>> Cc: Dave Chinner <dgc@kernel.org>
>>>>> Cc: Ritesh Harjani <ritesh.list@gmail.com>
>>>>> Cc: linux-mm@kvack.org
>>>>> Cc: linux-fsdevel@vger.kernel.org
>>>>> Cc: linux-xfs@vger.kernel.org
>>>>> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
>>>>
>>>> I guess this will have to do until unlikely(we figure out a better API)...
>>> 
>>> We could add a "new_gfp = gfp_policy(gfp)" to adjust input gfp based on
>>> various policies we currently have.
>>
>> Maybe with the help of alloc_flags to avoid the limitated count of gfp flags.
> 
> But alloc_flags are not exposed outside of MM, so alloc_page*() users
> are still limited by the existing GFP_* flags. Are you suggesting
> alloc_flags could be an addtional input for alloc_page*()?
> 
>>
>>> Even better if callers can do that
>>> instead.
>>
>> Not sure about burdening the callers (e.g. "every filesystem should do X"
>> etc), unless they are some intermediate wrappers within mm itself.
> 
> Not all callers. I assume gfp_policy() will only be used by advance
> users who want specific page allocation behavior without knowing the
> details of the page allocator or changing how the page allocator behave.

"without knowing the details"

>> For example, THP (but only anonymous?) is now handled in such a special way,
>> it could be a candidate. But I also have a vague feeling this was already
>> done in the past. Worth investigating perhaps.
>>
> 
> The number of wrappers can grow if different users have different needs.
> Some might not want direct reclaim, some might not want direct
> compaction, some might not want kswapd, and so on. I am not sure we want
> to add wrappers for each.

Yet all these are the details?

> For this patch, the caller can use gfp_policy() to strip out
> __GFP_DIRECT_RECLAIM based on the conditions and pass the adjusted gfp
> to the page allocator.

I guess I'd need to see a concrete example to grasp this fully.


