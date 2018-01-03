Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:54327 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750945AbeACVAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 16:00:20 -0500
Date: Thu, 4 Jan 2018 08:00:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: speed up directory bestfree block scanning
Message-ID: <20180103210015.GN5858@dastard>
References: <20180103062748.16400-1-david@fromorbit.com>
 <20180103115910.GL5858@dastard>
 <20180103134137.GB17932@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180103134137.GB17932@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 08:41:37AM -0500, Brian Foster wrote:
> On Wed, Jan 03, 2018 at 10:59:10PM +1100, Dave Chinner wrote:
> > In writing this, I think I can see a quick and simple change that
> > will fix this case and improve most other directory grow workloads
> > without affecting normal random directory insert/remove performance.
> > That is, do a reverse order search starting at the last block rather
> > than increasing order search starting at the first block.....
> > 
> > Ok, now were are talking - performance and scalability improvements!
> > 
> > 		create time(sec) / rate (files/s)
> >  File count     vanilla		    loop-fix		+reverse
> >    10k	      0.54 / 18.5k	   0.53 / 18.9k	       0.52 / 19.3k
> >    20k	      1.10 / 18.1k	   1.05 / 19.0k	       1.00 / 20.0k
> >   100k	      4.21 / 23.8k	   3.91 / 25.6k	       3.58 / 27.9k
> >   200k	      9.66 / 20,7k	   7.37 / 27.1k	       7.08 / 28.3k
> >     1M	     86.61 / 11.5k	  48.26 / 20.7k	      38.33 / 26.1k
> >     2M	    206.13 /  9.7k	 129.71 / 15.4k	      82.20 / 24.3k
> >    10M	   2843.57 /  3.5k	1817.39 /  5.5k      591.78 / 16.9k
> > 
> > Theres still some non-linearity as we approach the 10M number, but
> > it's still 5x faster to 10M inodes than the existing code....
> > 
> 
> Nice improvement.. I still need to look at the code, but a quick first
> thought is that I wonder if there's somewhere we could stash a 'most
> recent freeblock' once we have to grow the directory, even if just as an
> in-core hint. Then we could jump straight to the latest block regardless
> of the workload.

I thought about that, and then wondered where to stash it, then
wondered whether it would miss smaller, better fitting blocks, and
then finally realised we didn't need to have cross-operation state
to solve the common case of growing directories.

> Hmm, thinking a little more about it, that may not be worth the
> complication since part of the concept of "search failure" in this case
> is tied to the size of the entry we want to add. Then again, I suppose
> such is the case when searching forward/backward as well (i.e., one
> large insert fails, grows inode, subsequent small insert may very well
> have succeeded with the first freeblock, though now we'd always start at
> the recently allocated block at the end).

Right. random hole filling in the directory shouldn't be greatly
affected by forward or reverse search order - the eventual search
distances are all the same. It does, OTOH, matter greatly for
sequntial inserts...

After sleeping on it, I suspect that there's a simple on-disk mod to
the dir3 header that will improve the search function for all
workloads. The dir3 free block header:

struct xfs_dir3_free_hdr {
        struct xfs_dir3_blk_hdr hdr;
        __be32                  firstdb;        /* db of first entry */
        __be32                  nvalid;         /* count of valid entries */
        __be32                  nused;          /* count of used entries */
        __be32                  pad;            /* 64 bit alignment */
};

has 32 bits of padding in it, and the most entries a free block can
have is just under 2^15. Hence we can turn that into a "bestfree"
entry that tracks the largest freespace indexed by the block.

Then the free block scan can start by checking the required length
against the largest freespace in the bestfree entry and skip the
block search altogether if there isn't an indexed block with enough
free space inside the freespace index block we are searching.

That's a lot more work than just reversing the search order, but I
think it's a mod we should (eventually) make because it is an
improvement for all insert workloads, not just growing.

The other (far more complex) option is to turn the freespace index
into a btree, like we do with the hash indexes. Not sure we need to
spend that much effort on this right now, though.

> Anyways, just thinking out loud (and recovering from several weeks
> vacation). :P

Welcome back :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
