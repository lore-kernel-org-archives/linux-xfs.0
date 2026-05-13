Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6652A3A3835
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675216; cv=none; b=LUzlqcUeBXs6kbXSv+viw6XdXt5ODR0H0uyBjjes4R/Cg6K09SFuhoXUmQwyh9m3H0xp7ym8s3+Jn5op84K81NVt8IMJNAbtLcW4NiYzEO64MmcabFqr0MoSqvcUrfwK1hm/1frZbbam3scQ824I+Gf/LfuKhuHSu24XM6OlQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675216; c=relaxed/simple;
	bh=zUPM2wlKRUnO7vM79OiFhK6Hfsy0t6CxW3dotTnNUTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kRd0LN3gYTGuPxq2m+toGPGs5aiHeYfW5HMAazKBvoASsZJxveyvmUTq3lDqN9llYByi+R4CXu4KgQA+08NwXWM1BUZ2x+38kfT9TJVwjz7KFxIqQytjsmptRIt/3q34/c9i9iKDlc2mlsmJY0ncGj9cjQLKKOeTVGWQN8YEjqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uw3KOjGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uw3KOjGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F5EC2BCB7;
	Wed, 13 May 2026 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778675216;
	bh=zUPM2wlKRUnO7vM79OiFhK6Hfsy0t6CxW3dotTnNUTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uw3KOjGCMp7hWp3qcuprRz/5B9O3ahGmLT4O4fa1uUddeI14xnXFWoI0BwU9RliVd
	 q33CdWLB9IjxBuaYK6T4tEFEv1KzasS51XzMWzaKQebRFINfcT4Oz7eq1I/WlonCIR
	 NiDME3bhlPz0c5bvnrYx6oUhwz93G0CQ+iM0BpolqqXPLj6h7QFVZ7lb1n3TkD7HUi
	 PK3VnzMlrdD4hdTc1DJEEZfR6FMSCkW8eWid8lP35KsXg2XF02W88ZgnXIhuRchO+E
	 vGXNVTeysvTYQpyJqxDuvyoRcw9lFGOkIjXOMqE/787pzy6FZxirYSWu+bmqSuJ5bD
	 X7yQNvnNFHT/A==
Date: Wed, 13 May 2026 22:26:47 +1000
From: Dave Chinner <dgc@kernel.org>
To: yebin <yebin@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de
Subject: Re: [bug report] kernel BUG at fs/xfs/xfs_message.c:102!
Message-ID: <agRuByZS15BgUrGX@dread>
References: <6A031038.9030708@huaweicloud.com>
 <agOvHBfTbfQI-PTj@dread>
 <6A044578.8040807@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A044578.8040807@huaweicloud.com>

On Wed, May 13, 2026 at 05:33:44PM +0800, yebin wrote:
> 
> 
> On 2026/5/13 6:52, Dave Chinner wrote:
> > On Tue, May 12, 2026 at 07:34:16PM +0800, yebin wrote:
> > > Hello Darrick and all,
> > > 
> > > Recently, I encountered a problem where a BUG was triggered in the write-back process.
> > > The detailed problem information is as follows:
> > > ```
> > > XFS (sde): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0xaa6/0xc60 (fs/xfs/xfs_trans.c:351).  Shutting.
> > > XFS (sde): Please unmount the filesystem and rectify the problem(s)
> > > XFS: Assertion failed: tp->t_blk_res || tp->t_fdblocks_delta >= 0, file: fs/xfs/xfs_trans.c, line: 610
> > > ------------[ cut here ]------------
> > > kernel BUG at fs/xfs/xfs_message.c:102!
> > > Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> > > RIP: 0010:assfail+0x9f/0xb0
> > 
> > What kernel? You've stripped that line out of the stack dump.
> 
> The initial issue appeared on the v5.10 kernel and occurred multiple times.
> The current stack is a reproduction I made on linux-next based on the
> cc13002a9f98 tag: next-20260402.

So why strip it out of the debug output? It doesn't encourage people
to look at the problem when things like this have been obvious
stripped from the output.

....

> > So your test code is creating a number of fragmented extents to get
> > to the edge of btree format conversion, then doing a delalloc
> > write() to create a long delalloc extent range, then is alternating
> > along the range of the delalloc extent doing:
> > 
> > loop:
> > 	sync_file_range(offset, 4096, SYNC_FILE_RANGE_WRITE)
> > 	fallocate(PUNCH_HOLE, offset, 4096)
> > 	offset += 4096;
> > 
> > And so it is converting a single block at the left edge of the
> > delalloc extent to a written extent which triggers a extent -> btree
> > conversion, and then you punch out the newly created written extent
> > triggering a btree -> extent conversion.
> > 
> > And each time you do this it removes a reserved block from the
> > delalloc extent for the btree root block, yes?
> > 
> 
> Yes, this is just a process I designed to facilitate the construction
> of this problem. In another case, during the delay extent conversion,
> B-tree splitting continuously consumes reserved blocks.

The worst_indlen calculation should be taking blocks needed for
BMBT tree splits into account.

It expects to consume (extent len / BMBT records per block) leaf
blocks for the delalloc extent. It then walks back up the bmbt tree,
calculating how many node blocks will be needed to index all those
leaf blocks.  IOWs, it reserves all the node blocks it will need for
splits to index the growing number of leaf blocks.

i.e. by calculating the number of BMBT blocks required to index the
delalloc extent being converted into individual single block
extents, it should have taken into account all the blocks needed for
all the BMBT splits needed to index the range.

> Essentially,
> this is because the delay extent conversion process is broken down,
> which may cause the reserved blocks to be exhausted.

As per above, fragmentation by itself shouldn't cause the indlen
reservation to be exhausted.

> I think that the scenario of conversion between extents and B-trees
> may be that the unwritten extents are converted to written extents
> after the writeback is complete and then the extents are combined,
> causing the B-tree to be converted to an extent.

Yes, I can see how that could occur - it would need contiguous
physical extent allocation to keep the number of extents in the file
at the threshold where:

writeback submission
-> delalloc
  -> left contiguous unwritten allocation
    -> nextents++
      -> extent_to_btree

IO completion
-> unwritten conversion
  -> left merge with written extent
     -> nextents--
        -> btree_to_extents

But here's the thing: the extent_to_btree conversion does not
account blocks allocated to indlen blocks stored in the delalloc
extent. Yes, it uses blocks that were accounting to the superblock
as reserved delalloc blocks but the btree root block allocation only
gets accounted to the superblock and not to the new indlen in the
remaining delalloc extent.

Hence the data fork can bounce back and forth between extents and
btree forms across allocation and conversion without having any
impact on the indlen held in the delalloc extent that is slowly
being allocated and written.

The problem you are seeing is that indlen is being exhausted
by something, and that results in passing wasdel = false to the
extents_to_btree() conversion without a block reservation. We don't
yet have a plausible explanation of why indlen is being exausted in
the first place - it's not foramt conversion, and it's not "btree
splits", so how are we getting to indlen = 0 and triggering this
issue?

e.g. How much of the delalloc extent remains unallocated when da_old
reaches zero? Is this an off-by-one corner case of having allocated
the entire delalloc range and so having consumed all the indlen at
the same time the last allocation needs to convert the data for to
btree format?

> This scenario may
> be triggered by normal service operations. In any case, file system
> fragmentation is the cause of this problem.

I've not seen any evidence that supports this conclusion yet.

> > How realistic is this scenario in an application/production
> > environment? I mean, nobody walks through a file syncing data to
> > disk one fragmented extent at a time only to immediately remove it
> > before writing the next block.
> > 
> > We've known that this is possible for a very long time. I've
> > personally known it can happen in carefully constructed test code
> > for over 20 years, but I can count on one hand the number of times
> > I've actually seen this exhaustion occur in a production system.
> > 
> > The reservation we use here is essentially unchanged since if was
> > first introduced in 1994, so time in use tells us that the
> > reservation is largely sufficient for production systems. Can you
> > describe the situation where you production systems are hitting
> > this? What is the application actually doing to trigger this
> > problem?
> > 
> 
> The extent reduction is not only triggered in the punch hole scenario.
> In all scenarios where extent merging is triggered, the conversion
> from B-tree to extent may be performed.

Yes, I know. But in writeback scenarios, only unwritten extent
conversion can cause merges, and that only happens when we have
contiguous allocations over the delalloc range.

IOWs, it can't happen when the filesystem is fragmented, as it
requires repeated contiguous allocation to enable left merging.
Hence large, uncontested free spaces are required to trigger the
fork format conversion cycling behaviour, but this is irrelevant
because I don't think the format cycling is the cause of indlen
exhaustion....

> > Which begs the question: we fixed some issues with this code back in
> > 2024, so does this problem still occur on TOT kernels? e.g. commit
> > d69bee6a35d3 ("xfs: fix xfs_bmap_add_extent_delay_real for partial
> > conversions") should help address indlen block consumption for
> > repeated partial conversions.
> > 
> 
> This patch can solve the issue where the required extra space may not
> be reserved in time, leading to a writeback failure. However, it cannot
> address the problem caused by the continuous consumption of the reserved
> space.

OK, but therein lies the issue: what is the mechanism that causes
the excessive consumption of the indlen blocks? Is the calculation
wrong, does it leak blocks when we split the delalloc extent, or
something else?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
