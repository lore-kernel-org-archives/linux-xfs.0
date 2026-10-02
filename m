Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FB144A3E8;
	Fri,  2 Oct 2026 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929436; cv=none; b=VS40usVFMXOpYwp3tPgVpaSgzAvR51qwsLru0v3m49f1P8TCdjYVg85bdowVawFsZNB/DoyX+p/+lWS55DiydBTOer9Ua/ZvFhzvuZbzGOCYZEpCbMFDCWkMjas/AYUi+pFFU4pqUV67TWmRyytX5w8CdlfuTV1677eqHc2WNJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929436; c=relaxed/simple;
	bh=Uem7JOMRycuTBxtKaZIShzS/ClMiUI+0+yS3WdnGVLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uij1N6KgrFWLeyg9vm1zG1pwYCJeaBH1c6Y/hhulyG/iP1IHB2XpWBbJy96Fk4onEJFgEQmhTbETu6KTXJsv5024wFGQNnp9Y4KkhrHwWl/LK/GzY8CiRyfoR0sHtUDDiiks5OEphJz/IYuYemGyKErPgQ1YIB7P5Dx80bvfC9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m39OTSXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m39OTSXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588551F000FF;
	Fri,  2 Oct 2026 08:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790929434;
	bh=EscagxTaRgsbT7pEbj1a/c/B7oDWZ/qp9i/g3XXY2T8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m39OTSXGNZNIqCEztgvYpbKdbg8exALPQw7LXuaZ+cFC4pTdZYLSKC2Zdjd81Vyer
	 eZpFzbESNoK57ZUzT63Kbqvgt1CMyurYUx2euQpsisN/d4NC/346wAtZsoptWrU4Bx
	 uRX4gEsirlSzXf+lc+Rns6jlQ7EWFJcNt9l7zBzO/7jjfAGfLlses1qCqZ2PnXXuYW
	 HsohxPZh4YLf6b2zK1D0YtNlqhIZJHYa8PyNjgE2x5N+oRAcrUXbuEmqvxa4E75PVC
	 dpN563eX06NOCoyUTkrJGWoANofJdSgpOtzf+lUCyE0JhqCyCjG6ZGZGK36cUa9/jQ
	 Dnw4JlCRv97UQ==
Message-ID: <42d1a163-3502-49b8-9a27-7df9d06eee64@kernel.org>
Date: Fri, 2 Oct 2026 10:23:47 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction for
 costly __GFP_NORETRY allocations
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
 alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com, David Hildenbrand <david@redhat.com>,
 Christoph Hellwig <hch@lst.de>, Dmitry Ilvokhin <d@ilvokhin.com>,
 Brendan Jackman <brendan.jackman@linux.dev>
References: <20261001082152.2879289-1-dipiets@amazon.it>
 <20261001182942.ce99faa753fb9d9bd2efec1e@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261001182942.ce99faa753fb9d9bd2efec1e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/2/26 03:29, Andrew Morton wrote:
> On Thu, 1 Oct 2026 08:21:51 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:
> 
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the iomap buffered write
>> path.  When memory is fragmented, each failed costly-order allocation
>> enters __alloc_pages_slowpath() which runs direct reclaim, direct
>> compaction and drain_all_pages(), causing a 0.38x throughput drop on
>> PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
>> system.
>> 
>> The root issue is that direct reclaim and direct compaction are too
>> expensive for hot allocation paths that have fallbacks to smaller
>> allocations.  __filemap_get_folio_mpol() already marks higher-order
>> allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
>> caller can handle failure.  However, the page allocator still enters the
>> full blocking slowpath for costly orders with __GFP_NORETRY, which is
>> unnecessarily aggressive when the caller will simply retry at a lower
>> order.
>> 

Since it expands the impact of a pre-existing bug of nonblocking allocation
eating reserves [1] it shouldn't proceed to mainline without a fix for that
(Johannes posted it there but the review discussion got stalled).

> Thanks, I'll update mm-hotfixes to this version.

I've also argued for not handling it as a hotfix [2]

[1] https://lore.kernel.org/all/9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org/

[2] https://lore.kernel.org/all/c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org/

> Here's what changed:
> 
> --- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations
> +++ a/mm/page_alloc.c
> @@ -4930,8 +4930,11 @@ retry:
>  		 * Reclaim/compaction cannot run, so defrag_mode's strategy
>  		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
>  		 * fallbacks rather than failing the allocation outright.
> +		 * Not for __GFP_NORETRY: those have a cheap lower order
> +		 * fallback, so failing beats fragmenting.
>  		 */
>  		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
> +		    !(gfp_mask & __GFP_NORETRY) &&
>  		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
>  			alloc_flags &= ~ALLOC_NOFRAGMENT;
>  			goto retry;
> _
> 

