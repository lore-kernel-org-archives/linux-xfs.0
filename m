Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 17:07:33 -0700 (PDT)
Date: Mon, 28 Aug 2006 10:06:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
Message-ID: <20060828000606.GF807830@melbourne.sgi.com>
References: <20060827072810.GA4098@apartia.fr> <20060827204222.GB12065@tuatara.stupidest.org> <20060827205119.GA10325@apartia.fr> <20060827072810.GA4098@apartia.fr> <20060827204222.GB12065@tuatara.stupidest.org> <20060827072810.GA4098@apartia.fr> <17649.33701.520393.118416@base.ty.sabi.co.UK> <20060827072810.GA4098@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060827205119.GA10325@apartia.fr> <20060827204222.GB12065@tuatara.stupidest.org> <17649.33701.520393.118416@base.ty.sabi.co.UK> <20060827072810.GA4098@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Cc: xfs@oss.sgi.com, Linux XFS <linux-xfs@oss.sgi.com>

On Sun, Aug 27, 2006 at 09:28:10AM +0200, Louis-David Mitterrand wrote:
> Package: xfsprogs
> Version: 2.8.11-1
> Followup-For: Bug #382935
> 
> Hello,
> 
> Using xfs_repair on a 2TB partition I get:
.....
> 	xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
> 
> 
> 
> -- System Information:
> Debian Release: testing/unstable
>   APT prefers unstable
>   APT policy: (500, 'unstable'), (500, 'testing'), (499, 'experimental')
> Architecture: i386 (i686)

ia32, multi-terabyte filesystem, so as Peter pointed out:

On Sun, Aug 27, 2006 at 12:36:05PM +0100, Peter Grandi wrote:
> Most probably this is not a bug. The system probably does not
> have enough memory. "Cannot allocate memory" is probably what
> is happening. This has been discussed many times previously...
> 
>    http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

This will be the problem.

On Sun, Aug 27, 2006 at 10:51:19PM +0200, Louis-David Mitterrand wrote:
> On Sun, Aug 27, 2006 at 01:42:22PM -0700, Chris Wedgwood wrote:
> > On Sun, Aug 27, 2006 at 09:28:10AM +0200, Louis-David Mitterrand wrote:
> > 
> > > 	xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
> > 
> > Not enough memory, try adding swap space if that's possible?  (BTW,
> > how much memory do you have in this case?)
> 
> I had 2GB RAM and a 300GB swap partition and was monitoring memory 
> consumption with "top": it never went over 3BG before failing.

It' won't matter how much swap you add - ia32 has a per-process memory
limit of 1-4GB RAM depending on kernel build options.

> With the 2.7.x version of xfs_repair found on a live CD distro, memory 
> consumption never exceeds 1GB on the same filesystem. Why has the 2.8.11 
> version become so greedy?

xfs_repair is undergoing a lot of change at the moment and so memory usage
may have blown out under some circumstances. Do you have figures on how much
more memory xfs_repair is using?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
