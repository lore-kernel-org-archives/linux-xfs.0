Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C950185C4A
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773784828; cv=none; b=oA1W7iBZ60fukiWum9JVH7kMOkdOwbJufgT3VHnE9cnQSXtqTCthjy7RrMRVPBnZWndHvk2fzzp7O0uX0aTK1BPfgoxP8HcNjQxFvBZsQq6+kRiwEIfxUddlHChre0QdBLdsuF9FO57nIpyE5lg+tWLdKBVr6mDevndAzkBhXwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773784828; c=relaxed/simple;
	bh=hBXo+YjG5FmUXMyV0/wGKaOHoDKEOJiX2wpreZ4uUm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTEAK3cwaQmUW0JpRqv6D9L4eBdMf0m8oWlOx2dG0jf6e8ze3RauDTBpJ862kHHbHh30Ig+nCOAnGb29EBQ34DJteglbucSjz0n4GHuN0FlqSD3SpERbqqq/kjcc/Zc3ihMwOnriL1GDWg/HLGoE9XIK71DwN4qEoGHv6Wup0G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AI/LBjfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AI/LBjfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A613EC4CEF7;
	Tue, 17 Mar 2026 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773784828;
	bh=hBXo+YjG5FmUXMyV0/wGKaOHoDKEOJiX2wpreZ4uUm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AI/LBjfwfkAOMLSfyr/GLkesZy/0P+ECB/dJcq6O0bspUFPHj6pkRmlxa/CXd1R4W
	 sbjl3QcJe3M6wZ/hu16217tjan3JZ2w3bpEHvIBDKKLI3KBYB7DUJF9nDV9et0kjnx
	 EFavSw15otg1taLfxCMscNx8kFCZqV7yuoo2IGtHuQP+T0yOKUjRa1cicH7hKNsa8t
	 SxRmIQLjbx972rNBj4AJyN97M9v5kF3FPbiEQyqXcYQDPsl6WJC8KAt5Q9to3Zl/RR
	 8FtJakF6u3KlvXtJNslGPbKRYVLmNwicZ71aGkNGLR9SNfNbM4/QXzdAAIo+WlP5Fe
	 UtbNHnyx4VgMA==
Date: Wed, 18 Mar 2026 09:00:18 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 3/4] xfs: switch (back) to a per-buftarg buffer hash
Message-ID: <abnO8hP-EKBltkri@dread>
References: <20260317134110.1691097-1-hch@lst.de>
 <20260317134110.1691097-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317134110.1691097-4-hch@lst.de>

On Tue, Mar 17, 2026 at 02:40:54PM +0100, Christoph Hellwig wrote:
> The per-AG buffer hashes were added when all buffer lookups took a
> per-hash look.  Since then we've made lookups entirely lockless and
> removed the need for a hash-wide lock for inserts and removals as
> well.  With this there is no need to sharding the hash, so reduce the
> used resources by using a per-buftarg hash for all buftargs.
> 
> Long after writing this initially, syzbot found a problem in the buffer
> cache teardown order, which this happens to fix as well by doing the
> entire buffer cache teardown in one places instead of splitting it
> between destroying the buftarg and the perag structures.
> 
> Link: https://lore.kernel.org/linux-xfs/aLeUdemAZ5wmtZel@dread.disaster.area/
> Reported-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Tested-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 13 ++---------
>  fs/xfs/libxfs/xfs_ag.h |  2 --
>  fs/xfs/xfs_buf.c       | 51 +++++++++++-------------------------------
>  fs/xfs/xfs_buf.h       | 10 +--------
>  fs/xfs/xfs_buf_mem.c   | 11 ++-------
>  5 files changed, 18 insertions(+), 69 deletions(-)

Looks fine from a logic POV - the LRU life cycle now sits inside the
hash table life cycle.

I'd also suggest that the minimum size of the rhashtable should be
increased - it will always have a higher minimum population as a
global table as a set of per-ag tables. We should try to avoid
thrashing on resizing when the filesystem is mostly idle and/or
under memory pressure, so I think a larger min size should be
specified along with this globalisation change...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
