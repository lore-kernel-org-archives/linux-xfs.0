Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8HFijcc076100 for <xfs@oss.sgi.com>; Fri, 17 Sep 2010 10:44:45 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05AB880187
	for <xfs@oss.sgi.com>; Fri, 17 Sep 2010 08:45:35 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id J7i24ECXcyBEbr3Y
	for <xfs@oss.sgi.com>; Fri, 17 Sep 2010 08:45:35 -0700 (PDT)
Received: by vws15 with SMTP id 15so1702670vws.26
	for <xfs@oss.sgi.com>; Fri, 17 Sep 2010 08:45:35 -0700 (PDT)
Date: Fri, 17 Sep 2010 10:45:23 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: Latencies writing to memory mapped files
Message-ID: <20100917154523.GA2739@BohrerMBP.rgmadvisors.com>
References: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
	<20100916001837.GF24409@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100916001837.GF24409@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Thanks again for your replies.

On Thu, Sep 16, 2010 at 10:18:37AM +1000, Dave Chinner wrote:
> On Wed, Sep 15, 2010 at 10:26:33AM -0500, Shawn Bohrer wrote:
> > Hello,
> > 
> > A little while ago I asked about ways to solve the occasional spikes in
> > latency that I see when writing to a shared memory mapped file.
> > 
> > http://oss.sgi.com/pipermail/xfs/2010-July/046311.html
> > 
> > With Dave's suggestions I enabled lazy-count=1 which did help a little:
> > 
> > # xfs_info /home/
> > meta-data=/dev/sda5              isize=256    agcount=32, agsize=8472969 blks
> >          =                       sectsz=512   attr=1
> > data     =                       bsize=4096   blocks=271135008, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=32768, version=1
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > I'm also mounting the partition with "noatime,nobarrier,logbufs=8".
> 
> You really should add logbsize=262144 there - it won't prevent the
> latencies, but with less log writes the incidence should decrease
> significantly.

I initially tested with logbsize=256k but did not notice any
difference.  I then later realized that I had been doing a:

mount -o remount,logbsize=256k /home

You may also notice from above that I had version 1 logs and the max
logbsize for version 1 logs is 32k.  Apparently the "mount -o remount"
silently ignores the option.  If I instead unmount and remount it
complains and refuses to mount.

Yesterday I converted to version 2 logs and ran tests for an hour with
both logbsize=32k and logbsize=256k and I still don't see any
noticeable difference.  This of course assumes I tested correctly this
time.

> > The other change I made which helped the most was to use fallocate()
> > to grow the file instead of lseek() and a write().
> 
> Ok, so now you are doing unwritten extent conversion at IO
> completion, which is where this new latency issue has come from.

I'm a complete newbie when it comes to filesystems.  For my education
would you mind elaborating a little more here, or pointing to
something I could read?

An extent describes a contiguous section of data on disk correct?
So when the page fault occurs and modifies the block the extent is
modified in memory to record the change?  What does "conversion" mean
in this context?  And as silly as it sounds what exactly does IO
completion refer to?  Is this when the data is written to disk?

> Ok, the transaction was blocked on a buffer that had it's IO
> completion queued to the xfslogd. But this happened some
> 320ms after the above page fault occurred, and 340ms after the
> xfsconvertd got stuck waiting for it. In other words, it looks
> like it it took at least 340ms for the buffer IO to complete after
> it was issued.

OK, so xfslogd is writing the log, which frees up log buffers.
Meanwhile xfsconvertd is waiting on a free buffer so it can write more
to the log correct?  So setting logbufs=8 gives me 8 log buffers and
logbsize controls how big each of those buffers are correct?  When are
these buffers filled and freed?  Are they filled when the process
actually performs the write in memory, or at writeback time?  Likewise
it seems that they are freed at writeback time correct?  Also do the
buffers only get freed when fill they completely or are they also
flushed when partially full?

I get why you suggest increasing logbsize but I'm curious why I don't
see any difference.  Could it be because I always end up running out
of log buffers during writeback even at 256k so some of the I/O gets
stalled anyway?  Maybe increasing the logbsize increases the threshold
of the amount of data I can writeback before I see a spike?

> And so the delay you app saw was ~320ms. Basically, it blocked
> waiting for an IO to complete. I don't think there is anything we ca
> really do from a filesystem point of view to avoid that - we cannot
> avoid metadata buffer writeback indefinitely.

One more bit of information which may be relevant here is that since I
see these latencies during writeback I've increased
vm.dirty_writeback_centisecs from the default 500 to 30000.  I'm OK
with loosing 5 minutes of data in the event of a crash, and at our
data rates we still stay well below the vm.dirty_background_ratio.
This does improve the spikes (I only see them every 5 min) but
intuitively this seems like might actually make the magnitude of the
delays larger since there is more to write back.  Strangely from my
point of view it doesn't seem to increase the magnitude of the spikes,
so I'm not entirely sure how it really fits into the big picture.  Of
course with higher data rates it does take longer to write out the
data so the duration where the spikes can occur does increase.

> Fundamentally you are seeing the reason why filesystems cannot
> easily guarantee maximum bound latencies - if we have to wait for IO
> for anything, then the latency is effectively uncontrollable. XFS
> does as much as possible to avoid such latencies for data IO, but
> even then it's not always possible. Even using the RT device in XFS
> won't avoid these latencies - it's caused by latencies in metadata
> modification, not data....
> 
> Effectively, the only way you can minimise this is to design your
> storage layout for minimal IO latency under writes (e.g. use mirrors
> instead of RAID5, etc) or use faster drives. Also using the deadline
> scheduler (if you aren't already) might help....

I have tested with the deadline and noop schedulers and they actually
make the spikes noticeably worse than cfq.  I'm not sure why that would
be but, one thought is that I am writing lots of small sequential
chunks but from a whole disk perspective it would create a lot of
random IO.  Perhaps cfq is just better at merging these requests.

Thanks,
Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
