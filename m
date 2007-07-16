Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 05:22:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6GCMabm016195
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 05:22:38 -0700
Date: Mon, 16 Jul 2007 22:22:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 3ware 9650 tips
Message-ID: <20070716122225.GB31489@sgi.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan> <4697CA4D.6020304@etelos.com> <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan> <20070716024115.GJ12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716024115.GJ12413810@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jul 16, 2007 at 12:41:15PM +1000, David Chinner wrote:
> On Fri, Jul 13, 2007 at 03:36:46PM -0400, Justin Piszcz wrote:
> > On Fri, 13 Jul 2007, Jon Collette wrote:
> > 
> > >Wouldn't Raid 6 be slower than Raid 5 because of the extra fault tolerance?
> > >  http://www.enterprisenetworksandservers.com/monthly/art.php?1754 - 20% 
> > >drop according to this article
> > >
> > >His 500GB WD drives are 7200RPM compared to the Raptors 10K.  So his 
> > >numbers will be slower. 
> > >Justin what file system do you have running on the Raptors?  I think thats 
> > >an interesting point made by Joshua.
> > 
> > I use XFS:
> 
> When it comes to bandwidth, there is good reason for that.
> 
> > >>>Trying to stick with a supported config as much as possible, I need to 
> > >>>run ext3.  As per usual, though, initial ext3 numbers are less than 
> > >>>impressive. Using bonnie++ to get a baseline, I get (after doing 
> > >>>'blockdev --setra 65536' on the device):
> > >>>Write: 136MB/s
> > >>>Read:  384MB/s
> > >>>
> > >>>Proving it's not the hardware, with XFS the numbers look like:
> > >>>Write: 333MB/s
> > >>>Read:  465MB/s
> > >>>
> 
> Those are pretty typical numbers. In my experience, ext3 is limited to about
> 250MB/s buffered write speed. It's not disk limited, it's design limited. e.g.
> on a disk subsystem where XFS was getting 4-5GB/s buffered write, ext3 was doing
> 250MB/s.
> 
> http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf
> 
> If you've got any sort of serious disk array, ext3 is not the filesystem
> to use....

To show what the difference is, I used blktrace and Chris Mason's
seekwatcher script on a simple, single threaded dd command on
a 12 disk dm RAID0 stripe:

# dd if=/dev/zero of=/mnt/scratch/fred bs=1024k count=10k; sync

http://oss.sgi.com/~dgc/writes/ext3_write.png
http://oss.sgi.com/~dgc/writes/xfs_write.png

You can see from the ext3 graph that it comes to a screeching halt
every 5s (probably when pdflush runs) and at all other times the
seek rate is >10,000 seeks/s. That's pretty bad for a brand new,
empty filesystem and the only way it is sustained is the fact that
the disks have their write caches turned on. ext4 will probably show
better results, but I haven't got any of the tools installed to be
able to test it....

The XFS pattern shows consistently an order of magnitude less seeks
and consistent throughput above 600MB/s. To put the number of seeks
in context, XFS is doing 512k I/Os at about 1200-1300 per second. The
number of seeks? A bit above 10^3 per second or roughly 1 seek per
I/O which is pretty much optimal.

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
