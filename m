Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 May 2007 20:28:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4T3SEWt026582
	for <xfs@oss.sgi.com>; Mon, 28 May 2007 20:28:16 -0700
Date: Tue, 29 May 2007 13:28:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Message-ID: <20070529032803.GM85884050@sgi.com>
References: <200705241318.30711.dap@mail.index.hu> <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan> <20070525000547.GH85884050@sgi.com> <1180056948.6183.10.camel@daptopfc.localdomain> <20070525045500.GF86004887@sgi.com> <1180071831.21028.125.camel@w100> <20070525083650.GO85884050@sgi.com> <1180392327.21028.140.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180392327.21028.140.camel@w100>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alberto Alonso <alberto@ggsys.net>
Cc: David Chinner <dgc@sgi.com>, Pallai Roland <dap@mail.index.hu>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Mon, May 28, 2007 at 05:45:27PM -0500, Alberto Alonso wrote:
> On Fri, 2007-05-25 at 18:36 +1000, David Chinner wrote:
> > On Fri, May 25, 2007 at 12:43:51AM -0500, Alberto Alonso wrote:
> > > I think his point was that going into a read only mode causes a
> > > less catastrophic situation (ie. a web server can still serve
> > > pages).
> > 
> > Sure - but once you've detected one corruption or had metadata
> > I/O errors, can you trust the rest of the filesystem?
> > 
> > > I think that is a valid point, rather than shutting down
> > > the file system completely, an automatic switch to where the least
> > > disruption of service can occur is always desired.
> > 
> > I consider the possibility of serving out bad data (i.e after
> > a remount to readonly) to be the worst possible disruption of
> > service that can happen ;)
> 
> I guess it does depend on the nature of the failure. A write failure
> on block 2000 does not imply corruption of the other 2TB of data.

The rest might not be corrupted, but if block 2000 is a index of
some sort (i.e. metadata), you could reference any of that 2TB
incorrectly and get the wrong data, write to the wrong spot on disk,
etc.

> > > I personally have found the XFS file system to be great for
> > > my needs (except issues with NFS interaction, where the bug report
> > > never got answered), but that doesn't mean it can not be improved.
> > 
> > Got a pointer?
> 
> I can't seem to find it. I'm pretty sure I used bugzilla to report
> it. I did find the kernel dump file though, so here it is:
> 
> Oct  3 15:34:07 localhost kernel: xfs_iget_core: ambiguous vns:
> vp/0xd1e69c80, invp/0xc989e380

Oh, I haven't seen any of those problems for quite some time.

> = /proc/kmsg started.
> Oct  3 15:51:23 localhost kernel:
> Inspecting /boot/System.map-2.6.8-2-686-smp

Oh, well, yes, kernels that old did have that problem. It got fixed
some time around 2.6.12 or 2.6.13 IIRC....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
