Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 15:21:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6GMLjbm015641
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 15:21:47 -0700
Date: Tue, 17 Jul 2007 08:21:24 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 3ware 9650 tips
Message-ID: <20070716222124.GF31489@sgi.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan> <4697CA4D.6020304@etelos.com> <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan> <20070716024115.GJ12413810@sgi.com> <20070716122225.GB31489@sgi.com> <469B93CA.30801@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469B93CA.30801@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jul 16, 2007 at 10:50:34AM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> > On Mon, Jul 16, 2007 at 12:41:15PM +1000, David Chinner wrote:
> >> On Fri, Jul 13, 2007 at 03:36:46PM -0400, Justin Piszcz wrote:
> ...
> >> If you've got any sort of serious disk array, ext3 is not the filesystem
> >> to use....
> > 
> > To show what the difference is, I used blktrace and Chris Mason's
> > seekwatcher script on a simple, single threaded dd command on
> > a 12 disk dm RAID0 stripe:
> > 
> > # dd if=/dev/zero of=/mnt/scratch/fred bs=1024k count=10k; sync
> > 
> > http://oss.sgi.com/~dgc/writes/ext3_write.png
> > http://oss.sgi.com/~dgc/writes/xfs_write.png
> 
> Were those all with default mkfs & mount options?  ext3 in writeback
> mode might be an interesting comparison too.

Defaults. i.e.

# mkfs.ext3 /dev/mapper/dm0

# mkfs.xfs /dev/mapper/dm0

The mkfs.xfs picked up sunit/swidth correctly from the dm volume.

Last time I checked, writeback made little difference to ext3 throughput;
maybe 5-10% at most. I'll run it again later today...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
