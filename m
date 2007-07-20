Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 17:37:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6K0b8bm012284
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 17:37:11 -0700
Date: Fri, 20 Jul 2007 10:36:58 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS repair on / in a hosted environment
Message-ID: <20070720003658.GZ31489@sgi.com>
References: <469E690B.5070600@rupa.com> <20070719023419.GC12413810@sgi.com> <469F6296.9090902@rupa.com> <469F906A.6030509@rupa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F906A.6030509@rupa.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rupa Schomaker <rupa@rupa.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, Jul 19, 2007 at 09:25:14AM -0700, Rupa Schomaker wrote:
> On 7/19/2007 6:09 AM, Rupa Schomaker wrote:
> > 
> > On 7/18/2007 7:34 PM, David Chinner wrote:
> >> On Wed, Jul 18, 2007 at 12:24:59PM -0700, Rupa Schomaker wrote:
> >>> I have a virtual server hosted in a XEN environment.  Kernel is
> >>> 2.6.16.13-XenU and I can't change it. :( Host provider is not responsive
> >>> to getting us a newer kernel.
> >>>
> >>> Anyway, during my nightly rsync backup, I started seeing the following:
> >> .....
> >>
> >> what does /proc/mounts tell you (rather than /etc/mtab)?
> >>
> >> If /proc/mounts says ro, then try upgrading your xfsprogs package.
> >> and then retrying the repair....
> > 
> > /proc/mounts shows ro.
> 
> I built the latest xfsprogs from cvs.  Still no go.  This is perhaps
> something strange with the Xen environment?

The above /etc/mtab vs /proc/mounts problem was the reason I mentioned
you should get a recent xfsprogs - we changed it to look at /proc/mounts
rather than /etc/mtab for this reason....

> mount and /proc/mounts don't agree.  Thre is no /dev/root.  I tried the
> mount -o remount,ro on both / and /dev/sda1.  No good, only /dev/root is
> being changed to ro.
> 
> <boggle>
> 
> Ok, created a /dev/root.

That sounds like an init script or initrd setup problem....

> xfs_repair works as expected.  Now to figure
> out what got dumped into lost+found.

Oh, good to know you made it past the first (high) hurdle.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
