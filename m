Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfFLQyD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 12:54:03 -0400
Date: Wed, 12 Jun 2019 09:53:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] xfs: create simplified inode walk function
Message-ID: <20190612165346.GK1688126@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968497450.1657646.15305138327955918345.stgit@magnolia>
 <20190610135816.GA6473@bfoster>
 <20190610165909.GI1871505@magnolia>
 <20190610175509.GF6473@bfoster>
 <20190610231134.GM1871505@magnolia>
 <20190611223341.GD14363@dread.disaster.area>
 <20190611230514.GU1871505@magnolia>
 <20190612121310.GD12395@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612121310.GD12395@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 08:13:10AM -0400, Brian Foster wrote:
> On Tue, Jun 11, 2019 at 04:05:14PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 12, 2019 at 08:33:41AM +1000, Dave Chinner wrote:
> > > On Mon, Jun 10, 2019 at 04:11:34PM -0700, Darrick J. Wong wrote:
> > > > On Mon, Jun 10, 2019 at 01:55:10PM -0400, Brian Foster wrote:
> > > > > > I could extend the comment to explain why we don't use PAGE_SIZE...
> > > > > > 
> > > > > 
> > > > > Sounds good, though what I think would be better is to define a
> > > > > IWALK_DEFAULT_RECS or some such somewhere and put the calculation
> > > > > details with that.
> > > > > 
> > > > > Though now that you point out the readahead thing, aren't we at risk of
> > > > > a similar problem for users who happen to pass a really large userspace
> > > > > buffer? Should we cap the kernel allocation/readahead window in all
> > > > > cases and not just the default case?
> > > > 
> > > > Hmm, that's right, we don't want to let userspace arbitrarily determine
> > > > the size of the buffer, and I think the current implementation caps it
> > > > the readahaead at ... oh, PAGE_SIZE / sizeof(xfs_inogrp_t).
> > > > 
> > > > Oh, right, and in the V1 patchset Dave said that we should constrain
> > > > readahead even further.
> > > 
> > > Right, I should explain a bit further why, too - it's about
> > > performance.  I've found that a user buffer size of ~1024 inodes is
> > > generally enough to max out performance of bulkstat. i.e. somewhere
> > > around 1000 inodes per syscall is enough to mostly amortise all of
> > > the cost of syscall, setup, readahead, etc vs the CPU overhead of
> > > copying all the inodes into the user buffer.
> > > 
> > > Once the user buffer goes over a few thousand inodes, performance
> > > then starts to tail back off - we don't get any gains from trying to
> > > bulkstat tens of thousands of inodes at a time, especially under
> > > memory pressure because that can push us into readahead and buffer
> > > cache thrashing.
> > 
> > <nod> I don't mind setting the max inobt record cache buffer size to a
> > smaller value (1024 bytes == 4096 inodes readahead?) so we can get a
> > little farther into future hardware scalability (or decreases in syscall
> > performance :P).
> > 
> 
> The 1k baseline presumably applies to the current code. Taking a closer
> look at the current code, we unconditionally allocate a 4 page record
> buffer and start to fill it. For every record we grab, we issue
> readahead on the underlying clusters.
> 
> Hmm, that seems like generally what this patchset is doing aside from
> the more variable record buffer allocation. I'm fine with changing
> things like record buffer allocation, readahead semantics, etc. given
> Dave's practical analysis above, but TBH I don't think that should all
> be part of the same patch. IMO, this rework patch should maintain as
> close as possible to current behavior and a subsequent patches in the
> series can tweak record buffer size and whatnot to improve readahead
> logic. That makes this all easier to review, discuss and maintain in the
> event of regression.

This also got me thinking that I should look up what INUMBERS does,
which is that it uses the icount to determine the cache size, up to a
maximum of PAGE_SIZE.  Since INUMBERS doesn't issue readahead I think
it's fine to preserve that behavior too... and probably with a separate
xfs_inobt_walk_set_prefetch function.

> > I guess the question here is how to relate the number of inodes the user
> > asked for to how many inobt records we have to read to find that many
> > allocated inodes?  Or in other words, what's the average ir_freecount
> > across all the inobt records?
> > 
> 
> The current code basically looks like it allocates an oversized buffer
> and hopes for the best with regard to readahead. If we took a similar
> approach in terms of overestimating the buffer size (assuming not all
> inode records are fully allocated), I suppose we could also track the
> number of cluster readaheads issued and govern the collect/drain
> sequences of the record buffer based on that..? But again, I think we
> should have this as a separate "xfs: make iwalk readahead smarter ..."
> patch that documents Dave's analysis above, perhaps includes some
> numbers, etc..

Ok.

--D

> > Note that this is technically a decrease since the old code would
> > reserve 16K for this purpose...
> > 
> 
> Indeed.
> 
> Brian
> 
> > > > > > /*
> > > > > >  * Note: We hardcode 4096 here (instead of, say, PAGE_SIZE) because we want to
> > > > > >  * constrain the amount of inode readahead to 16k inodes regardless of CPU:
> > > > > >  *
> > > > > >  * 4096 bytes / 16 bytes per inobt record = 256 inobt records
> > > > > >  * 256 inobt records * 64 inodes per record = 16384 inodes
> > > > > >  * 16384 inodes * 512 bytes per inode(?) = 8MB of inode readahead
> > > > > >  */
> > > 
> > > Hence I suspect that even this is overkill - it makes no sense to
> > > have a huge readahead window when there has been no measurable
> > > performance benefit to doing large inode count bulkstat syscalls.
> > > 
> > > And, FWIW, readahead probably should also be capped at what the user
> > > buffer can hold - no point in reading 16k inodes when the output
> > > buffer can only fit 1000 inodes...
> > 
> > It already is -- the icount parameter from userspace is (eventually) fed
> > to xfs_iwalk-set_prefetch.
> > 
> > --D
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
