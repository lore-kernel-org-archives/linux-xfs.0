Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p433FOXY257361 for <xfs@oss.sgi.com>; Mon, 2 May 2011 22:15:25 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68FE911C6459
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 20:18:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	kWwIz1X7x2fNH8nI for <xfs@oss.sgi.com>;
	Mon, 02 May 2011 20:18:59 -0700 (PDT)
Date: Tue, 3 May 2011 13:18:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS/Linux Sanity check
Message-ID: <20110503031856.GA9114@dastard>
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: xfs@oss.sgi.com

On Mon, May 02, 2011 at 11:47:48AM -0400, Paul Anderson wrote:
> Our genetic sequencing research group is growing our file storage from
> 1PB to 2PB.
.....
> We are deploying five Dell 810s, 192GiB RAM, 12 core, each with three
> LSI 9200-8E SAS controllers, and three SuperMicro 847 45 drive bay
> cabinets with enterprise grade 2TB drives.

So roughly 250TB raw capacity per box.

> We're running Ubuntu 10.04 LTS, and have tried either the stock kernel
> (2.6.32-30) or 2.6.35 from linux.org.

(OT: why do people install a desktop OS on their servers?)

> We organize the storage as one
> software (MD) RAID 0 composed of 7 software RAID (MD) 6s, each with 18
> drives, giving 204 TiB usable (9 drives of the 135 are unused).

That's adventurous. I would serious consider rethinking this -
hardware RAID-6 with controllers that have ia significant amount of
BBWC is much more appropriate for this scale of storage. You get an
unclean shutdown (e.g. power loss) and MD is going to take _weeks_
to resync those RAID6 arrays. Background scrubbing is likely to
never cease, either....

Also, knowing how you spread out the disks in each RAID-6 group
between controllers, trays, etc as that has important performance
and failure implications.

e.g. I'm guessing that you are taking 6 drives from each enclosure
for each 18-drive raid-6 group, which would split the RAID-6 group
across all three SAS controllers and enclosures. That means if you
lose a SAS controller or enclosure you lose all RAID-6 groups at
once which is effectively catastrophic from a recovery point of view.
It also means that one slow controller slows down everything so load
balancing is difficult.

Large stripes might look like a good idea, buti when you get to this
scale concatenation of high throughput LUNs provides better
throughput because of less contention through the storage
controllers and enclosures.

> XFS
> is set up properly (as far as I know) with respect to stripe and chunk
> sizes.

Any details? You might be wrong ;)

> Allocation groups are 1TiB in size, which seems sane for the
> size of files we expect to work with.

Any filesystem over 16TB will use 1TB AGs.

> In isolated testing, I see around 5GiBytes/second raw (135 parallel dd
> reads), and with a benchmark test of 10 simultaneous 64GiByte dd
> commands, I can see just shy of 2 GiBytes/second reading, and around
> 1.4GiBytes/second writing through XFS.   The benchmark is crude, but
> fairly representative of our expected use.

If you want insightful comments, then you'll need to provide
intimate details of the tests your ran and the results (e.g. command
lines, raw results, etc).

> md apparently does not support barriers, so we are badly exposed in
> that manner, I know.  As a test, I disabled write cache on all drives,
> performance dropped by 30% or so, but since md is apparently the
> problem, barriers still didn't work.

Doesn't matter if you have BBWC on your hardware RAID
controllers. Seriously, if you want to sustain high throughput, you
want a large amount of BBWC in front your disks....

> Nonetheless, what we need, but don't have, is stability.
> 
> With 2.6.32-30, we get reliable kernel panics after 2 days of
> sustained rsync to the machine (around 150-250MiBytes/second for the
> entire time - the source machines are slow),

Stack traces from the crash?

> and with 2.6.35, we get a
> bad resource contention problem fairly quickly - much less than 24
> hours (in this instance, we start getting XFS kernel thread timeouts
> similar to what I've seen posted here recently, but it isn't clear
> whether it is only XFS or also ext3 boot drives that are starved for
> I/O - suspending or killing all I/O load doesn't solve the problem -
> only a reboot does).

Details of the timeout messages?

> Ideally, I'd firstly be able to find informed opinions about how I can
> improve this arrangement - we are mildly flexible on RAID controllers,
> very flexible on versions of Linux, etc, and can try other OS's as a
> last resort (but the leading contender here would be "something"
> running ZFS, and though I love ZFS, it really didn't seem to work well
> for our needs).
> 
> Secondly, I welcome suggestions about which version of the linux
> kernel you'd prefer to hear bug reports about, as well as what kinds
> of output is most useful (we're getting all chassis set up with serial
> console so we can do kgdb and also full kernel panic output results).

If you want to stay on mainline kernels with best-effort community
support, I'd suggest 2.6.38 or more recent kernels are the only ones
we're going to debug. If you want fixes, then running the curent -rc
kernels is probably a good idea. It's unlikely you'll get anyone
backporting fixes for you to older kernels.

Alternatively, you can switch to something like RHEL (or SLES) where
XFS is fully supported (and in the RHEL case, pays my bills :). The
advantage of this is that once the bug is fixed in mainline, it will
get backported to the supported kernel you are running.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
