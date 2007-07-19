Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 19:34:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6J2YPbm024530
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 19:34:27 -0700
Date: Thu, 19 Jul 2007 12:34:19 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS repair on / in a hosted environment
Message-ID: <20070719023419.GC12413810@sgi.com>
References: <469E690B.5070600@rupa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E690B.5070600@rupa.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rupa Schomaker <rupa@rupa.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 18, 2007 at 12:24:59PM -0700, Rupa Schomaker wrote:
> I have a virtual server hosted in a XEN environment.  Kernel is
> 2.6.16.13-XenU and I can't change it. :( Host provider is not responsive
> to getting us a newer kernel.
> 
> Anyway, during my nightly rsync backup, I started seeing the following:
.....
> 
> On boot, mount shows:
> 
> /dev/sda1 on / type xfs (rw)
> 
> # mount -o remount,ro /
> 
> after the remount, mount still shows / as rw
> 
> # mount
> /dev/sda1 on / type xfs (rw)
> 

what does /proc/mounts tell you (rather than /etc/mtab)?

If /proc/mounts says ro, then try upgrading your xfsprogs package.
and then retrying the repair....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
