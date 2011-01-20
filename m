Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KB3o3F072723 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 05:03:50 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AE091EA3B89
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 03:06:08 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7o0JwwJcBJ0OBZ0f for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 03:06:08 -0800 (PST)
Date: Thu, 20 Jan 2011 22:06:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110120110605.GU16267@dastard>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110120100143.GA2007@peter.simplex.ro>
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
To: Petre Rodan <petre.rodan@simplex.ro>
Cc: xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 12:01:43PM +0200, Petre Rodan wrote:
> On Fri, Dec 31, 2010 at 11:13:23AM +1100, Dave Chinner wrote:
> > On Mon, Dec 27, 2010 at 07:19:39PM +0200, Petre Rodan wrote:
> > > 
> > > Hello Dave,
> > > 
> > > On Tue, Dec 28, 2010 at 01:07:50AM +1100, Dave Chinner wrote:
> > > > Turn on the XFS tracing so we can see what is being written every
> > > > 36s.  When the problem shows up:
> > > > 
> > > > # echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
> > > > # sleep 100
> > > > # cat /sys/kernel/debug/tracing/trace > trace.out
> > > > # echo 0 > /sys/kernel/debug/tracing/events/xfs/enable
> > > > 
> > > > And post the trace.out file for us to look at.
> > > 
> > > attached.
> > > 
> > > you can disregard all the lvm partitions ('dev 254:.*') since they are on a different drive, probably only 8:17 is of interest.
> > 
> > Ok, I can see the problem. The original patch I tested:
> > 
> > http://oss.sgi.com/archives/xfs/2010-08/msg00026.html
> > 
> > Made the log covering dummy transaction a synchronous transaction so
> > that the log was written and the superblock unpinned immediately to
> > allow the xfsbufd to write back the superblock and empty the AIL
> > before the next log covering check.
> > 
> > On review, the log covering dummy transaction got changed to an
> > async transaction, so the superblock buffer is not unpinned
> > immediately. This was the patch committed:
> > 
> > http://oss.sgi.com/archives/xfs/2010-08/msg00197.html
> > 
> > As a result, the success of log covering and idling is then
> > dependent on whether the log gets written to disk to unpin the
> > superblock buffer before the next xfssyncd run. It seems that there
> > is a large chance that this log write does not happen, so the
> > filesystem never idles correctly. I've reproduced it here, and only
> > in one test out of ten did the filesystem enter an idle state
> > correctly. I guess I was unlucky enough to hit that 1-in-10 case
> > when I tested the modified patch.
> > 
> > I'll cook up a patch to make the log covering behave like the
> > original patch I sent...
> 
> I presume that the new fix should be provided by "xfs: ensure log
> covering transactions are synchronous", so I tested 2.6.37 patched
> with it and then 2.6.38_rc1 that has it included..
> 
> instead of having xfssyncd write to the drive every 36s, we now have this:
....
> in other words xfsyncd and xfsbufd now alternate at 18s intervals
> keeping the drive busy with nothing constructive hours after the
> last write to the drive.
> 
> to add to the misfortune, 'mount -o remount ' is no longer able to
> bring the drive to a quiet state since 2.6.37, so now the only way
> to achieve an idle drive is to fully umount and then remount the
> partition.
> 
> just for the record, this is a different drive then at the
> beginning of the thread, and it has these parameters:
> 
> meta-data=/dev/sdc1              isize=256    agcount=4, agsize=61047552 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=244190208, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=119233, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
                                                              ^^^^^^^^^^^^
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> attached you'll find the trace (with accesses to other drives filtered out).

It's something to do with lazy-count=0. I'm look into it when I get
the chance - I almost never test w/ lazy-count=0 because =1 is
the default value.

I'd recommend that you convert the fs to lazy-count=1 when you get a
chance, anyway, because of the fact it reduces the latency of
transactions significantly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
