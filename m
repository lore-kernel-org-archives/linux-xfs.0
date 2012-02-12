Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1CMZF91212227 for <xfs@oss.sgi.com>; Sun, 12 Feb 2012 16:35:15 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QwKjVHAfJXkn19bD for <xfs@oss.sgi.com>;
	Sun, 12 Feb 2012 14:35:13 -0800 (PST)
Date: Mon, 13 Feb 2012 09:35:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Disk spin down
Message-ID: <20120212223511.GK12836@dastard>
References: <4F3803B1.1090205@ashurst.eu.org> <20120212200647.GI12836@dastard>
	<4F382BDF.3070901@ashurst.eu.org> <4F382F00.9040100@ashurst.eu.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F382F00.9040100@ashurst.eu.org>
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
To: Andy Bennett <andyjpb@ashurst.eu.org>
Cc: xfs@oss.sgi.com

On Sun, Feb 12, 2012 at 09:28:32PM +0000, Andy Bennett wrote:
> Hi,
> 
> >> Seems to me that something is still dirtying an inode regularly.
> >>
> >> Perhaps you need to look at the XFS and writeback event traces to
> >> find out what process is dirtying the inode. trace-cmd is your
> >> friend...
> > 
> > Something like this?
> > 
> > -----
> > echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
> > 
> > echo 0 > /sys/kernel/debug/tracing/events/xfs/enable
> > 
> > more /sys/kernel/debug/tracing/trace
> > -----
> > 
> > 
> > I tried recreating the situation of the last 2 days (clean boot, stopped
> > services) and it's currently quiescing nicely. :-(
> > 
> > I'll keep an eye on it and try to catch it in the act but every time I
> > turn the tracing on the HDD light stays firmly off. :-(
> 
> There is more interesting news already.
> 
> I had used 'hdparm -S 120' to set the spindown_timeout to 10 minutes. It
> appears that that was sticking through a cold boot. Setting that back to
> its previous value of 1 (5 seconds) makes the disk constantly spin up
> and down when I suspect it is idle.

Well, that's kind of important to know.

It takes XFS a minimum of 90s to idle a filesystem properly after
any modification. Setting a spindown time shorter than this will
cause the disk to spin up and down all the time until the filesystem
idles itself.

What else have you tuned on your system?

> I've caught a trace over the course of a few spinup/downs and attached
> it (gzipped as it's 208K unpacked).

Which you've taken about 90s after boot, so while there is probably
still dirty inodes due to the boot process. Indeed:

       flush-8:0-1225  [002]    91.103273: xfs_ilock: dev 8:6 ino 0x80a124 flags ILOCK_EXCL caller xfs_iomap_write_allocate
       flush-8:0-1225  [002]    91.103287: xfs_perag_get: dev 8:6 agno 2 refcount 28 caller xfs_bmap_btalloc_nullfb
       flush-8:0-1225  [002]    91.103290: xfs_perag_put: dev 8:6 agno 2 refcount 27 caller xfs_bmap_btalloc_nullfb
       flush-8:0-1225  [002]    91.103292: xfs_perag_get: dev 8:6 agno 3 refcount 32 caller xfs_bmap_btalloc_nullfb
       flush-8:0-1225  [002]    91.103293: xfs_perag_put: dev 8:6 agno 3 refcount 31 caller xfs_bmap_btalloc_nullfb
       flush-8:0-1225  [002]    91.103295: xfs_perag_get: dev 8:6 agno 2 refcount 28 caller xfs_alloc_vextent

That's data writeback happening, so filesystem idling is still at
least 90s away from this.  So, it's no surprise your disk is
spinning up and down here because there is IO being done every 5-10
seconds which is in the same order of frequency as the IO the system
is issuing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
