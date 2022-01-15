Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EAEC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Jan 2022 22:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbiAOWkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Jan 2022 17:40:35 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34657 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233859AbiAOWkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Jan 2022 17:40:35 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 60C4A10C198A;
        Sun, 16 Jan 2022 09:40:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n8rio-000GdE-I0; Sun, 16 Jan 2022 09:40:30 +1100
Date:   Sun, 16 Jan 2022 09:40:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220115224030.GA59729@dread.disaster.area>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113223810.GG3290465@dread.disaster.area>
 <20220114173535.GA90423@magnolia>
 <YeHSxg3HrZipaLJg@bfoster>
 <20220114213043.GB90423@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114213043.GB90423@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61e34d61
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=IOMxa7LGenFM2lOX8bsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 14, 2022 at 01:30:43PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 14, 2022 at 02:45:10PM -0500, Brian Foster wrote:
> > On Fri, Jan 14, 2022 at 09:35:35AM -0800, Darrick J. Wong wrote:
> > > On Fri, Jan 14, 2022 at 09:38:10AM +1100, Dave Chinner wrote:
> > > > On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> > > > >  STATIC void
> > > > >  xfs_fs_destroy_inode(
> > > > > @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
> > > > >  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> > > > >  	 */
> > > > >  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > > > > +		struct xfs_icwalk	icw = {0};
> > > > > +
> > > > > +		/*
> > > > > +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> > > > > +		 * doesn't leave them sitting in the inactivation queue where
> > > > > +		 * they cannot be processed.
> > > > > +		 */
> > > > > +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > > > > +		xfs_blockgc_free_space(mp, &icw);
> > > > 
> > > > Is a SYNC walk safe to run here? I know we run
> > > > xfs_blockgc_free_space() from XFS_IOC_FREE_EOFBLOCKS under
> > > > SB_FREEZE_WRITE protection, but here we have both frozen writes and
> > > > page faults we're running in a much more constrained freeze context
> > > > here.
> > > > 
> > > > i.e. the SYNC walk will keep busy looping if it can't get the
> > > > IOLOCK_EXCL on an inode that is in cache, so if we end up with an
> > > > inode locked and blocked on SB_FREEZE_WRITE or SB_FREEZE_PAGEFAULT
> > > > for whatever reason this will never return....
> > > 
> > > Are you referring to the case where one could be read()ing from a file
> > > into a buffer that's really a mmap'd page from another file while the
> > > underlying fs is being frozen?
> > > 
> > 
> > I thought this was generally safe as freeze protection sits outside of
> > the locks, but I'm not terribly sure about the read to a mapped buffer
> > case. If that allows an iolock holder to block on a pagefault due to
> > freeze, then SB_FREEZE_PAGEFAULT might be too late for a synchronous
> > scan (i.e. assuming nothing blocks this earlier or prefaults/pins the
> > target buffer)..?
> 
> I think so.  xfs_file_buffered_read takes IOLOCK_SHARED and calls
> filemap_read, which calls copy_page_to_iter.  I /think/ the messy iovec
> code calls copyout, which can then hit a write page fault, which takes
> us to __xfs_filemap_fault.  That takes SB_PAGEFAULT, which is the
> opposite order of what now goes on during a freeze.

Yeah, so this was the sort of thing I was concerned about. I
couldn't put my finger on an actual case, but the general locking
situation felt wrong which is why I asked the question.

That is, normal case for a -write- operation is:

	Prevent write freeze (shared lock!)
	take IO lock (shared or exclusive)
	<page fault>
	Prevent fault freeze (shared)
	take MMAP lock
	do allocation
	Prevent internal freeze (shared)
	run transaction

Which means the stack cannot happen unless a freeze is completely
locked out at the first level and it has to wait for the write
operation to complete before proceeding. So for modification
operations, doing:

	lock out write freeze (excl lock)
	lock out fault freeze (excl lock)
	take IOLOCK excl

would be safe.

However, in the case of a read operation, we don't have that inital
FREEZE_WRITE protection, so the first level an operation might hit
is the page fault freeze protection. Hence we now get inversion
on the write freeze/IOLOCK/fault freeze because we have IOLOCK/fault
freeze without any write freeze protection so this can happen:

task 1				freeze
				freeze write
				.....
				freeze page fault
read()
IOLOCK_SHARED
<page fault>
sb_start_pagefault()
<blocks on fault freeze>
				xfs_blockgc_free_space(SYNC)
				try IOLOCK_EXCL
				<busy loops on failed IOLOCK_EXCL>

So the sync walk here doesn't seem safe. A non-blocking, best-effort
walk would be fine, but busy-looping on inodes we can't lock looks
to be a deadlock vector.

ISTR that we recently wne through a similar readdir vs page fault
locking discussion, so it's not just read() file IO that could
trigger page fault freeze first with an unprotected IOLOCK already
held.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
