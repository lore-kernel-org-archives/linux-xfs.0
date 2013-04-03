Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A9FB7F9D
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 23:08:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04707AC003
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 21:08:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2C8bJmBemaT0XrK1 for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 21:08:47 -0700 (PDT)
Date: Wed, 3 Apr 2013 15:08:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] xfs: add version 3 inode format with CRCs
Message-ID: <20130403040845.GU17758@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-10-git-send-email-david@fromorbit.com>
	<20130314160321.GV22182@sgi.com> <20130315011104.GD21651@dastard>
	<20130326225600.GL6369@dastard> <20130327005307.GK30652@sgi.com>
	<20130327014828.GN6369@dastard> <20130402224433.GZ22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130402224433.GZ22182@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 02, 2013 at 05:44:33PM -0500, Ben Myers wrote:
> On Wed, Mar 27, 2013 at 12:48:28PM +1100, Dave Chinner wrote:
> > On Tue, Mar 26, 2013 at 07:53:07PM -0500, Ben Myers wrote:
> > > On Wed, Mar 27, 2013 at 09:56:00AM +1100, Dave Chinner wrote:
> > > > On Fri, Mar 15, 2013 at 12:11:04PM +1100, Dave Chinner wrote:
> > > > Ben, FYI: I've taken the easy way out for this - log the entire
> > > > inode buffer rather than just the inode core. The CRC means we are
> > > > dependent on having all the inode logged so that seems to be the
> > > > simplest way to deal with this problem overall, even though it
> > > > increases the amount of metadata logged for inode creates
> > > > substantially.
> > > > 
> > > > I'll address this potential performance issue in future with new
> > > > inode create and unlink transactions that allow us to avoid logging
> > > > buffers for all inode modifications. There are other good reasons
> > > > for doing this as well (e.g. avoid the subtly broken special
> > > > handling of physical inode buffer logging vs logical inode logging
> > > > in log recovery), so I think this is best to just take the simple
> > > > option here....
> > > 
> > > It seems like this is a more general problem with fresh on-disk
> > > structures.  When we calculate crc and log only part of a buffer we are
> > > prone to the crc being incorrect after log replay because the unlogged
> > > portions of the buffer are still undefined.  They aren't the 0s we
> > > calculated crcs with.
> > 
> > But it doesn't matter for all other metadata as we don't log CRC
> > fields except in the inode/dquot at allocation. It is the exception
> > rather than the rule.
.....
> > > 2) Create a new transaction to write a known pattern over the
> > > entire buffer, then initialize the buffer with that pattern,
> > > calculate the crc, and still log only the parts of the buffer
> > > which were modified.  In the non-crash case we still need to
> > > arrange for the buffer to be patterned after the log wraps, but it
> > > has the advantage of not having to log large structures just to
> > > zero them.
> > 
> > We need to ensure we log the entire object if we are logging the CRC
> > of the object.
> 
> We don't need to log the entire object if we can arrange for the contents of
> the buffer to be a known pattern after recovery and then calculate the CRC
> against that.  It's just the initialization that is problematic.  The rest of
> the time the contents are already cached anyway.  

Right, but...

> > In this case, the initialisation and calculation of
> > the CRC needs to be atomic, so it needs to be a single transactions.
> 
> I agree that the initialisation of the block and the calculation of the crc
> must be in the same transaction.  It would need to be a new log item type that
> specifies a pattern (normally zero) and a length to be written to the buffer.
> I used the wrong terminology, as usual.
> 
> > That's what logging the entire buffer does.
> 
> Yep.  I'm just pointing out that if logging the entire structure becomes an
> issue we have some other options.

.... to do that we need a new transaction type, new flags/fields in
the xfs_buf_log_item, new handling of unlogged buffer contents that
still are tracked in the AIL, new reservations, new transaction
nesting as there's now 3 transactions needed for inode allocation,
etc. It's pretty messy, and it doesn't replace the fact we then
immediately have to relog the buffer with the initialised inode
cores. It doesn't simplify log recovery, either, and that already
has issues with buffer based inode allocation vs logical inode
logging....

But, as I mentioned, I already have a patchset that basically does
all this for inode allocation. It doesn't initialised buffers to a
byte pattern - it initialises a contiguous extent to contain inodes,
and introduces a "ordered buffer" that is not logged but is still
tracked in the AIL to ensure that the correct behaviour occurs. That
patchset has been around for a while - the original series I wrote:

$ ls -l src/kern/patches/icreate
total 64
-rw------- 1 dave dave 10423 Dec  3  2009 xfs-icreate-factor-inode-stamping
-rw------- 1 dave dave 12304 Dec  3  2009 xfs-icreate-item
-rw------- 1 dave dave  6347 Dec  3  2009 xfs-icreate-ordered-buf-item
-rw------- 1 dave dave  2679 Dec  3  2009 xfs-icreate-remove-log-di
-rw------- 1 dave dave  4713 Dec  3  2009 xfs-icreate-use-xact
-rw------- 1 dave dave  7924 Dec  3  2009 xfs-icreate-xact-recovery
-rw------- 1 dave dave  6159 Dec  3  2009 xfs-icreate-xact-resv

That will solve the perf problem of inode initialisation and CRCs,
as well as a bunch of other problems limiting inode create
performance. It will also avoid having to log buffers for inode
creation and hence remove all the recovery coherency problems that
causes...

> This could be useful for other reasons too,
> e.g. to prevent stale data exposure after a crash.

That can't actually happen as they are metadata buffers and hence
the unreferenced contents of the buffers cannot escape to
userspace....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
