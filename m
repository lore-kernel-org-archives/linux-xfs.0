Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34903 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752550AbeADVxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 16:53:14 -0500
Date: Fri, 5 Jan 2018 08:52:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: speed up directory bestfree block scanning
Message-ID: <20180104215256.GD32627@dastard>
References: <20180103062748.16400-1-david@fromorbit.com>
 <20180103115910.GL5858@dastard>
 <20180103134137.GB17932@bfoster.bfoster>
 <20180103210015.GN5858@dastard>
 <20180104140452.GA23499@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180104140452.GA23499@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 04, 2018 at 09:04:53AM -0500, Brian Foster wrote:
> On Thu, Jan 04, 2018 at 08:00:15AM +1100, Dave Chinner wrote:
> > On Wed, Jan 03, 2018 at 08:41:37AM -0500, Brian Foster wrote:
> > > On Wed, Jan 03, 2018 at 10:59:10PM +1100, Dave Chinner wrote:
> > > > In writing this, I think I can see a quick and simple change that
> > > > will fix this case and improve most other directory grow workloads
> > > > without affecting normal random directory insert/remove performance.
> > > > That is, do a reverse order search starting at the last block rather
> > > > than increasing order search starting at the first block.....
> > > > 
> > > > Ok, now were are talking - performance and scalability improvements!
> > > > 
> > > > 		create time(sec) / rate (files/s)
> > > >  File count     vanilla		    loop-fix		+reverse
> > > >    10k	      0.54 / 18.5k	   0.53 / 18.9k	       0.52 / 19.3k
> > > >    20k	      1.10 / 18.1k	   1.05 / 19.0k	       1.00 / 20.0k
> > > >   100k	      4.21 / 23.8k	   3.91 / 25.6k	       3.58 / 27.9k
> > > >   200k	      9.66 / 20,7k	   7.37 / 27.1k	       7.08 / 28.3k
> > > >     1M	     86.61 / 11.5k	  48.26 / 20.7k	      38.33 / 26.1k
> > > >     2M	    206.13 /  9.7k	 129.71 / 15.4k	      82.20 / 24.3k
> > > >    10M	   2843.57 /  3.5k	1817.39 /  5.5k      591.78 / 16.9k
> > > > 
> > > > Theres still some non-linearity as we approach the 10M number, but
> > > > it's still 5x faster to 10M inodes than the existing code....
> > > > 
> > > 
> > > Nice improvement.. I still need to look at the code, but a quick first
> > > thought is that I wonder if there's somewhere we could stash a 'most
> > > recent freeblock' once we have to grow the directory, even if just as an
> > > in-core hint. Then we could jump straight to the latest block regardless
> > > of the workload.

.....

> > After sleeping on it, I suspect that there's a simple on-disk mod to
> > the dir3 header that will improve the search function for all
> > workloads. The dir3 free block header:
> > 
> > struct xfs_dir3_free_hdr {
> >         struct xfs_dir3_blk_hdr hdr;
> >         __be32                  firstdb;        /* db of first entry */
> >         __be32                  nvalid;         /* count of valid entries */
> >         __be32                  nused;          /* count of used entries */
> >         __be32                  pad;            /* 64 bit alignment */
> > };
> > 
> > has 32 bits of padding in it, and the most entries a free block can
> > have is just under 2^15. Hence we can turn that into a "bestfree"
> > entry that tracks the largest freespace indexed by the block.
> > 
> > Then the free block scan can start by checking the required length
> > against the largest freespace in the bestfree entry and skip the
> > block search altogether if there isn't an indexed block with enough
> > free space inside the freespace index block we are searching.
> 
> So with this we'd still need to walk the range of free blocks, right?
> I.e., we'd just be able to shortcut individual free block processing
> (bests[] iteration) for those that obviously don't satisfy the request.

Right. In the case of the 5M entry directory I was looking at, there
were a total of 33 free index blocks. All the overhead was in
scanning the 2016 entries in each block, not in iterating over the
blocks. So if we can skip the entry scanning in a given block, then
we have a general search improvement.  i.e. it makes the free block
index structure more like a skip list than a linear array.

Also, if we keep the index into the free index block of the largest
free space we have in the header, we can jump straight to it without
needing to scan. Then when we modify the free index during the
insert, we can do the "best free" scan at that point, similar to how
we keep other bestfree indexes up to date.

> Assuming I follow that correctly, that sounds reasonable from the
> perspective that it certainly eliminates work. I suppose how worthwhile
> it is probably depends on how much of an effect it has on the higher
> level directory workload. IOW, is performance measurably improved by
> skipping individual free block processing or is that cost mostly
> amortized by having to read/walk all free blocks in the first place?

According to the profile, the CPU cost of the read/walk of the free
index blocks was within the noise floor. It didn't stand out as a
major contributor, but I'd need to re-measure the overhead on a
random insert/delete workload. However, my gut feel is that if we
combined reverse order searching (for sequential insert) with block
skipping (for random insert) we'll get get substantial improvements
across all insert operations on large directories...

> It may very well be a worthwhile optimization. I think the larger point
> is that more isolated testing is probably required to confirm. The
> improvement from this patch alone doesn't necessarily translate to an
> answer one way or another because this patch creates conditions that
> allow us to skip most of the scan altogether (by jumping right to the
> most recently added block).

Yeah, lots of validation work, but given the overhead for a
non-trivial search distance I was measuring (>40% of CPU time @10M
inodes) I think it's worth persuing.

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
