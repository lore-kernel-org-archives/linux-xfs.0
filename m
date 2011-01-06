Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p069Fpbi043527 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 03:15:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09CD7BD914B
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 01:17:58 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	4jwQML9Da8YSiNxm for <xfs@oss.sgi.com>;
	Thu, 06 Jan 2011 01:17:58 -0800 (PST)
Date: Thu, 6 Jan 2011 20:17:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: add FITRIM support
Message-ID: <20110106091707.GH8322@dastard>
References: <20101125112304.GA4195@infradead.org> <201101052307.38379@zmi.at>
	<20110105225039.GD8322@dastard> <201101060910.34534@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201101060910.34534@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Thu, Jan 06, 2011 at 09:10:29AM +0100, Michael Monnerie wrote:
> On Mittwoch, 5. Januar 2011 Dave Chinner wrote:
> > No state or additional on-disk
> > structures are needed for xfs_fsr to do it's work....
> 
> That's not exactly the same - once you defraged a file, you know it's 
> done, and can skip it next time.

Sure, but the way xfs_fsr skips it is by physically checking the
inode on the next filesystem pass. It does that efficiently because
the necessary information is cheap to read (via bulkstat), not
because we track what needs defrag in the filesystem on every
operation.

> But you dont know if the (free) space 
> between block 0 and 20 on disk has been rewritten since the last trim 
> run or not used at all, so you'd have to do it all again.

Sure, but the block device should, and therefore a TRIM to an area
with nothing to trim should be fast. The current generation drives
still have problems with this, but once device implementations are
better optimised there should be little penalty for trying to trim a
region that currently holds no data on the device.

basically we need to design for the future, not for the limitations
the current generation of devices have....

> > The background trim is intended to enable even the slowest of
> > devices to be trimmed over time, while introducing as little runtime
> > overhead and complexity as possible. Hence adding complexity and
> > runtime overhead to optimise background trimming tends to defeat the
> > primary design goal....
> 
> It would be interesting to have real world numbers to see what's "best". 
> I'd imagine a normal file or web server to store tons of files that are 
> mostly read-only, while 5% of it a used a lot, as well as lots of temp 
> files. For this, knowing what's been used would be great.

A filesystem does not necessarily reuse the same blocks for
temporary data. That "5%" of data that is written and erase all the
time could end up spanning 50% of the filesystem free space over the
period of a week....

> Also, I'm thinking of a NetApp storage, that has been setup to run 
> deduplication on Sunday. It's best to run trim on Saturday and it should 
> be finished before Sunday. For big storages that might be not easy to 
> finish, if all disk space has to be freed explicitly.
> 
> And wouldn't it still be cheaper to keep a "written bmap" than to run 
> over the full space of a (big) disk? I'd say depends on the workload.

So, lets keep a "used free space" tree in the filesystem for this
purpose. I'll spell out what it means in terms of runtime overhead
for you.

Firstly, every extent that is freed now needs to be inserted into
the new used free space tree.  That means transactions reservations
all increase in size by 30%, log traffic increases by 30%, cpu
overhead increases by ~30%, buffer cache footprint increases by 30%
and we've got 30% more metadata to write to disk. (30% because there
are already 2 free space btrees that are updated on every extent
free.)

Secondly, when we allocate an extent, we now have to check whether the
extent is in the used free space btree and remove it from there if
it is. That adds another btree lookup and modification to the
allocation code, which adds roughly 30% overhead there as well.

That's a lot of additional runtime overhead.

And then we have to consider the userspace utilities - we need to
add code to mkfs, xfs_repair, xfs_db, etc to enable checking and
repairing of the new btree, cross checking that every extent in used
free space tree is in the free space tree, etc. That's a lot of work
on top of just the kernel allocation code changes to keep the new
tree up to date.

IMO, tracking used free space to optimise background trim is
premature optimisation - it might be needed for a year or two, but
it will take at least that long to get such an optimisation stable
enough to consider for enterprise distros. And at which point, it
probably isn't going to be needed anymore.  Realistically, we have
to design for how we expect devices to behave in 2-3 years time, not
waste time trying to optimise for fundamentally broken devices that
nobody will be using in 2-3 years time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
