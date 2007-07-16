Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 19:41:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G2fQbm009313
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:41:28 -0700
Date: Mon, 16 Jul 2007 12:41:15 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 3ware 9650 tips
Message-ID: <20070716024115.GJ12413810@sgi.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan> <4697CA4D.6020304@etelos.com> <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707131535270.2064@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jon Collette <jon@etelos.com>, Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 13, 2007 at 03:36:46PM -0400, Justin Piszcz wrote:
> On Fri, 13 Jul 2007, Jon Collette wrote:
> 
> >Wouldn't Raid 6 be slower than Raid 5 because of the extra fault tolerance?
> >  http://www.enterprisenetworksandservers.com/monthly/art.php?1754 - 20% 
> >drop according to this article
> >
> >His 500GB WD drives are 7200RPM compared to the Raptors 10K.  So his 
> >numbers will be slower. 
> >Justin what file system do you have running on the Raptors?  I think thats 
> >an interesting point made by Joshua.
> 
> I use XFS:

When it comes to bandwidth, there is good reason for that.

> >>>Trying to stick with a supported config as much as possible, I need to 
> >>>run ext3.  As per usual, though, initial ext3 numbers are less than 
> >>>impressive. Using bonnie++ to get a baseline, I get (after doing 
> >>>'blockdev --setra 65536' on the device):
> >>>Write: 136MB/s
> >>>Read:  384MB/s
> >>>
> >>>Proving it's not the hardware, with XFS the numbers look like:
> >>>Write: 333MB/s
> >>>Read:  465MB/s
> >>>

Those are pretty typical numbers. In my experience, ext3 is limited to about
250MB/s buffered write speed. It's not disk limited, it's design limited. e.g.
on a disk subsystem where XFS was getting 4-5GB/s buffered write, ext3 was doing
250MB/s.

http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf

If you've got any sort of serious disk array, ext3 is not the filesystem
to use....

> >>>How many folks are using these?  Any tuning tips?

Make sure you tell XFS the correct sunit/swidth. For hardware
raid5/6, sunit = per-disk chunksize, swidth = number of *data* disks in
array.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
