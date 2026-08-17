Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB4A248F64
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787004953; cv=none; b=TyMfanioO1E+DkqPvYCJl9K5+1AjqsnvolNMBQG6Tm7TqSBGu7yVNLoz00GTh8ps5yCcsl8sjhOVqNO/V4+U8zpsuyALfUiaBDuT5yHNqElzH31oQUh3hfo91WbhzGyJowEKgc3YSBy2/mVrMVP6Bp+RWtKBuMHvTHgEqa7pj6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787004953; c=relaxed/simple;
	bh=7/35re8in7wT1/x3HTa8YhJCocvu4AJNr+YKJudNtZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPKHXPh7pwDpzzRqZd3p9DrowvsfnK+QRUSDAucHsupduV6Vvi7M5paxO81ORN6Er+v9DaweTnhRTBGr5JoGKO97+Edupp+cHVi0QsOVUd80k/83K1+Su3Ilpofy8Buu1Axkben3n0Cz3K/R2pvILAxlbReBjFalzNU2tQlSYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sr3KJOYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sr3KJOYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE95A1F000E9;
	Mon, 17 Aug 2026 22:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787004951;
	bh=b8PHYNwnPwjD4P97/aLgG+IksMysTOlP/5dyI7THzj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sr3KJOYtA2N9Ih00IL2TrShVL95fPeug79m6BzsdBenS9EW8b/GYJt6IlS4XqDdU1
	 VpEJ+V63urYa7sVFZRT7NlHGGmLMljPQsbSpJL75plPkdo3WzgVgRID3ZMV2yH2SCO
	 vD6Y8Yz5PGQsPBixTO30keh07tcDVuMIhWRK+Q+Ot++nGdijdQ/R7aDviaaoQ6+M4P
	 vf9BBfxXXnzvJnj28Jl+DwgU62BSFXRUaLAYkYMbpgYAuIVOcHjA3Cgg82jSLDXRsv
	 8EKKsN6e11vKzhiWEKKcniQR37+0WysYviGimti8r37wehgI7p0GsUy4U1MDlYET62
	 jKFzGvMmtazlA==
Date: Tue, 18 Aug 2026 08:15:43 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: xfs: properly account xfs_buf items as reclaimable
Message-ID: <aoOID47x9csJo_W9@dread>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <an7D_9YRVDG-0Qjq@dread>
 <11c14c65-8609-4482-b3d1-23d4d36afd66@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11c14c65-8609-4482-b3d1-23d4d36afd66@sandeen.net>

On Fri, Aug 14, 2026 at 11:07:45AM -0500, Eric Sandeen wrote:
> On 8/14/26 2:30 AM, Dave Chinner wrote:
> > On Thu, Aug 13, 2026 at 03:40:51PM -0500, Eric Sandeen wrote:
> > We don't use the size of that memory for reclaim
> > purposes, hence we haven't ever tracked it. It is, however, fed back
> > into shrinker based memory reclaim via mm_account_reclaimed_pages()
> > in xfs_buf_free() and hence memory reclaim correctly tracks how much
> > memory was released by the xfs_buf shrinker scan, even if the user
> > visible stats don't show it.
> 
> I guess that's the crux of the question: should those stats show it?

Filesystem metadata is often cached on the block device address
space (e.g. anything that uses sb_getblk() like extN and various
other filesystems do) and that shows up as "Buffers" in meminfo.
i.e. cached file data shows up a page cache (i.e. NR_FILE...),
cached metadata shows up as "buffers". 

The XFS buffer cache is caching metadata buffers, but it's not in
the block dev address space like bufferhead based filesystems do so
the nr_blockdev_pages() does not automatically account for it.
Unfortunately, this isn't accounted by a vmstat counter, but by
iterating the list of block device inodes and counting the number of
pages attached to each bdev mapping....

> >> I was not sure how to handle xfs_buf_alloc_vmalloc but I think
> >> that's a relatively rare path, and the above two will capture
> >> the majority of xfs_buf allocations.
> > 
> > I think both folio and vmalloc should be accounted in the same
> > manner - as a number of pages based on the size of the buffer (i.e.
> > same as mm_account_reclaimed_pages() does already). It doesn't
> > matter if it is vmalloc or a high order folio, the amount of memory
> > is the same.  If it gets accounted to the node of the first folio,
> > then it will at least always be consistently accounted, if not
> > always 100% accurate for the vmalloc case.
> 
> OK fair.
> 
> >> I've cc:d linux-mm just because i think this is the first
> >> user of NR_KERNEL_MISC_RECLAIMABLE in the tree?
> > 
> > These are fs buffers - shouldn't they be accounted as something that
> > reports as "cached" or "buffers" in /proc/meminfo? I mean, if you're
> > going to do this to make meminfo/vmstat report the memory usage,
> > shouldn't we make the effort to classify the memory usage correctly
> > for the user?
> 
> I'm not sure. NR_KERNEL_MISC_RECLAIMABLE says it's for
> "reclaimable non-slab kernel pages" and that seemed appropriate for
> this case; they really aren't the same as page cache?

Bufferram is "double accounted" in meminfo output. The folios are
accounted to the bdev page cache, but also to the "buffer" output.
the meinfo code then calculates "cached" as (page cache - swap -
buffers) - i.e. cached file data - so that buffers + cache totals
all the cached filesystem data + metadata....

Yes, XFS buffers don't fit into that, either, because we don't use
the page cache for the bdev buffer cache, but my point is that most
filesystems report cached metadata as "buffers" and users have long
expected "cached" to be the total of cached file data, and buffers
to be the total of cached metadata...

IMO, if we are going to report how much metadata we are caching in
the XFS buffer cache, we should try to make it match all the other
filesystem accounting...

> The commit (b29940c1abd7) that created NR_KERNEL_MISC_RECLAIMABLE
> renamed it from NR_INDIRECTLY_RECLAIMABLE_BYTES, and said it was
> "still useful for accounting direct page allocations (i.e. not slab)
> with a shrinker" so it seemed appropriate but clearly I'm a bit out
> of my depth here.

It would be appropriate if there wasn't already stats that are
supposed to report cached filesystem metadata. I could use the
example of shrinker reclaimed DRM memory pools as an example of a
valid use of NR_KERNEL_MISC_RECLAIMABLE because there is no other
equivalent functionality. However, a few months back they made the
DRM accounting a first class citizen via commit 2232ba9c7931 (mm:
add gpu active/reclaim per-node stat counters (v2)).

And that's kinda my point: if we need to expose the memory usage to
userspace, we should be presenting it the right way - consistent
with other filesystems - rather doing that requires minimal code but
requires all sorts of mental gymnastics for the user to determine
that some of their weird "MISC" memory usage is actually XFS
metadata.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
