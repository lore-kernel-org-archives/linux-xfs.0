Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8K04nWK192463 for <xfs@oss.sgi.com>; Sun, 19 Sep 2010 19:04:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1508E181D462
	for <xfs@oss.sgi.com>; Sun, 19 Sep 2010 17:05:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	cbZxR2ePD8VjwXFx for <xfs@oss.sgi.com>;
	Sun, 19 Sep 2010 17:05:39 -0700 (PDT)
Date: Mon, 20 Sep 2010 10:05:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Latencies writing to memory mapped files
Message-ID: <20100920000535.GM24409@dastard>
References: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
	<20100916001837.GF24409@dastard>
	<20100917154523.GA2739@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100917154523.GA2739@BohrerMBP.rgmadvisors.com>
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
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 17, 2010 at 10:45:23AM -0500, Shawn Bohrer wrote:
> Hi Dave,
> 
> Thanks again for your replies.
> 
> On Thu, Sep 16, 2010 at 10:18:37AM +1000, Dave Chinner wrote:
> > On Wed, Sep 15, 2010 at 10:26:33AM -0500, Shawn Bohrer wrote:
> > > Hello,
> > > 
> > > A little while ago I asked about ways to solve the occasional spikes in
> > > latency that I see when writing to a shared memory mapped file.
> > > 
> > > http://oss.sgi.com/pipermail/xfs/2010-July/046311.html
> > > 
> > > With Dave's suggestions I enabled lazy-count=1 which did help a little:
> > > 
> > > # xfs_info /home/
> > > meta-data=/dev/sda5              isize=256    agcount=32, agsize=8472969 blks
> > >          =                       sectsz=512   attr=1
> > > data     =                       bsize=4096   blocks=271135008, imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0
> > > log      =internal               bsize=4096   blocks=32768, version=1
> > >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > 
> > > I'm also mounting the partition with "noatime,nobarrier,logbufs=8".
> > 
> > You really should add logbsize=262144 there - it won't prevent the
> > latencies, but with less log writes the incidence should decrease
> > significantly.
> 
> I initially tested with logbsize=256k but did not notice any
> difference.  I then later realized that I had been doing a:
> 
> mount -o remount,logbsize=256k /home
> 
> You may also notice from above that I had version 1 logs and the max
> logbsize for version 1 logs is 32k.  Apparently the "mount -o remount"
> silently ignores the option.  If I instead unmount and remount it
> complains and refuses to mount.
> 
> Yesterday I converted to version 2 logs and ran tests for an hour with
> both logbsize=32k and logbsize=256k and I still don't see any
> noticeable difference.  This of course assumes I tested correctly this
> time.

You may not notice any difference if the log is not the latency you
are tripping over. However, doing up to 8x less log IO is definitely
good for reducing overall IO latency...

> > > The other change I made which helped the most was to use fallocate()
> > > to grow the file instead of lseek() and a write().
> > 
> > Ok, so now you are doing unwritten extent conversion at IO
> > completion, which is where this new latency issue has come from.
> 
> I'm a complete newbie when it comes to filesystems.  For my education
> would you mind elaborating a little more here, or pointing to
> something I could read?
> 
> An extent describes a contiguous section of data on disk correct?

yes.

> So when the page fault occurs and modifies the block the extent is
> modified in memory to record the change?

Not exactly.

> What does "conversion" mean
> in this context?  And as silly as it sounds what exactly does IO
> completion refer to?  Is this when the data is written to disk?

When you preallocate a range, the blocks are allocated on disk, but
nothing is written to them. Hence there has to be some mechanism
recorded with the extent to prevent reads from the extent returning
whatever is on disk (security issue). IOWs we want a read into
preallocated space to be functionally equivalent of reading from a
hole - i.e. like no space was allocated at all.

This means that the extent has state on disk to record the fact it
is an "unwritten extent" - it's allocated but contains nothing but
zeros. When we then write data to that extent, the extent state must
change to remove the "unwritten" flag so that reads will then
reflect the correct data that has been written to disk. The changing
of the extent state from unwritten to written is what I referred to
as "conversion" above.

As to the "conversion at IO completion", if we convert the extent to
written state before the data IO is issued, then there is a window
where a system crash/power-fail/etc could occur between the extent
conversion and the real data being written to disk. IOWs, we could
convert the extent and then never write data to the range we
converted. This would then expose stale data from disk next time the
extent is read.

To avoid this problem, we wait for the data IO to complete (i.e. we
get the interrupt back from the hardware saying "write done") before
we convert the extent from unwritten to written. This means that
even if we crash after the conversion, we will never expose stale
data from the (un)written extent because we've already written the
correct data to it before starting the conversion.

> > Ok, the transaction was blocked on a buffer that had it's IO
> > completion queued to the xfslogd. But this happened some
> > 320ms after the above page fault occurred, and 340ms after the
> > xfsconvertd got stuck waiting for it. In other words, it looks
> > like it it took at least 340ms for the buffer IO to complete after
> > it was issued.
> 
> OK, so xfslogd is writing the log, which frees up log buffers.
> Meanwhile xfsconvertd is waiting on a free buffer so it can write more
> to the log correct? 

No. The xfslogd runs both metadata buffer and log buffer IO
completion processing - it does not write to the log. In this case,
xfsconvertd is waiting for a metadata buffer IO completion
processing to unlock the buffer (metadata buffers are locked over IO
so they are not modified during writeback) because it needs to use
that metadata buffer in the transaction.

Log buffers and metadata buffers are very different in behaviour and
lifecycle.

> I get why you suggest increasing logbsize but I'm curious why I don't
> see any difference.  Could it be because I always end up running out
> of log buffers during writeback even at 256k so some of the I/O gets
> stalled anyway?  Maybe increasing the logbsize increases the threshold
> of the amount of data I can writeback before I see a spike?

The cause of this latency event is not at all related to the log
buffer size, which is why changing the size of the buffer will not
prevent it.

> 
> > And so the delay you app saw was ~320ms. Basically, it blocked
> > waiting for an IO to complete. I don't think there is anything we ca
> > really do from a filesystem point of view to avoid that - we cannot
> > avoid metadata buffer writeback indefinitely.
> 
> One more bit of information which may be relevant here is that since I
> see these latencies during writeback I've increased
> vm.dirty_writeback_centisecs from the default 500 to 30000.

Sure - you see the latency during writeback, so it's no surprise it
happens less often when you increase the writeback period.

> I'm OK
> with loosing 5 minutes of data in the event of a crash, and at our
> data rates we still stay well below the vm.dirty_background_ratio.
> This does improve the spikes (I only see them every 5 min) but
> intuitively this seems like might actually make the magnitude of the
> delays larger since there is more to write back.  Strangely from my
> point of view it doesn't seem to increase the magnitude of the spikes,

Because you're still only being held up by waiting for a single
metadata buffer completion?

FWIW, if you can work out the magic necessary (perhaps systemtap) it
woul dbe really interesting to know whether it is the same buffer
that is causing the latency every time (i.e. get the bp->b_bn field
from the metadata buffer). With the block number, we can use xfs_db
to dig out what the buffer actually is....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
