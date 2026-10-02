Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94254519B6;
	Fri,  2 Oct 2026 22:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980108; cv=none; b=YJMlUm5VA7zOugGKmt6zyYIwbBX7nbOyWgrvHc0fLdzgeRNxgQU95oWvME8/ytmVsZxnlJ5qWpQyyY6JjxcsAYCmu7+7isHnvZJXZ6R9GnN2GUrFv95PvFBsp0ljxNC+PWibeB6vjQMmTZ9btTLcKseSDZPChyaucEatObBhmu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980108; c=relaxed/simple;
	bh=mK/wL9VTOYn60ZlxlFAyFB6jS+QR37sbGwvk0yYbo+w=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pZDZD2rhoBXxFRzqzYRIq2qS3SfKUDRpJlMl4xEP0ykzgTeCsbR4UZaIIlSUty7m+arlcGCi2Q5b75P5CTgm3Gbi6AyPU31J18n0sFHuxBR1Ycwv2vartCqJVNJJWyfc0pkgSzb5Xl5lZ3IYuiieu3sjVDMirTnNkqc86CxBoWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O1lDm6z9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1lDm6z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6541F000FF;
	Fri,  2 Oct 2026 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790980106;
	bh=nL/ZJzb+eWbYYnb+iW2qc4P7Usj9ljnxOgkJ0BBDdVg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O1lDm6z9hrvgFknTcEbmBpb4kZzRIzRb8Cr+61QGKNVqw/CHTSV63wzhcCKewo2J1
	 DiHXB9/F2ZR9jNGkNtvHjB5UkDVW9WMXLab0F4UifDDpVbMz0X4MhStvSslG0kkdgf
	 ALLCyTzr3PNj0nWSdJMaPhu+3bFzASE5W/F01Zkg=
Date: Fri, 2 Oct 2026 15:28:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
 hch@infradead.org, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hannes@cmpxchg.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com, David Hildenbrand <david@redhat.com>,
 Christoph Hellwig <hch@lst.de>, Dmitry Ilvokhin <d@ilvokhin.com>, Brendan
 Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction
 for costly __GFP_NORETRY allocations
Message-Id: <20261002152824.75ee2a39f5b705a85123ea74@linux-foundation.org>
In-Reply-To: <42d1a163-3502-49b8-9a27-7df9d06eee64@kernel.org>
References: <20261001082152.2879289-1-dipiets@amazon.it>
	<20261001182942.ce99faa753fb9d9bd2efec1e@linux-foundation.org>
	<42d1a163-3502-49b8-9a27-7df9d06eee64@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Oct 2026 10:23:47 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 10/2/26 03:29, Andrew Morton wrote:
> > On Thu, 1 Oct 2026 08:21:51 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:
> > 
> >> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> >> introduced high-order folio allocations in the iomap buffered write
> >> path.  When memory is fragmented, each failed costly-order allocation
> >> enters __alloc_pages_slowpath() which runs direct reclaim, direct
> >> compaction and drain_all_pages(), causing a 0.38x throughput drop on
> >> PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
> >> system.
> >> 
> >> The root issue is that direct reclaim and direct compaction are too
> >> expensive for hot allocation paths that have fallbacks to smaller
> >> allocations.  __filemap_get_folio_mpol() already marks higher-order
> >> allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
> >> caller can handle failure.  However, the page allocator still enters the
> >> full blocking slowpath for costly orders with __GFP_NORETRY, which is
> >> unnecessarily aggressive when the caller will simply retry at a lower
> >> order.
> >> 
> 
> Since it expands the impact of a pre-existing bug of nonblocking allocation
> eating reserves [1] it shouldn't proceed to mainline without a fix for that
> (Johannes posted it there but the review discussion got stalled).
> 
> > Thanks, I'll update mm-hotfixes to this version.
> 
> I've also argued for not handling it as a hotfix [2]
> 
> [1] https://lore.kernel.org/all/9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org/
> 
> [2] https://lore.kernel.org/all/c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org/
> 

Thanks.  I moved this to tail of mm-unstable, removed its cc:stable and
added a note indicating that changes are expected.
