Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 06:26:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4VDQKWt028920
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 06:26:22 -0700
Date: Thu, 31 May 2007 23:26:15 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Message-ID: <20070531132615.GO85884050@sgi.com>
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz> <20070531023031.GH85884050@sgi.com> <649C7FF68B1450E03D544BD9@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <649C7FF68B1450E03D544BD9@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Michal Marek <mmarek@suse.cz>, xfs@oss.sgi.com

On Thu, May 31, 2007 at 05:22:58PM +1000, Timothy Shimmin wrote:
> 
> 
> --On 31 May 2007 12:30:31 PM +1000 David Chinner <dgc@sgi.com> wrote:
> 
> >On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:
> >>i386 struct xfs_fsop_geom_v1 has no padding after the last member, so
> >>the size is different.
> >
> >That's a pain - it's kind of clunky having to redefine the entire
> >structure just pack it differently. Oh well, not much that
> >we can do about it...
> >
> 
> Could we get rid of it?
> Do we really need to support XFS_IOC_FSGEOMETRY_V1 anymore?
> IRIX has 4 versions, and Linux has the latter 2 versions
> (though xfs_fs_geometry() still has a bit of code for 'em all).
> And the current version would have come in June 2002 with v2 logs
> on Linux.
> Who would want to use XFS_IOC_FSGEOMETRY_V1?
> 
> Okay it turns out a whole bunch of our xfs-cmds :-)
> (Such as xfsdump as Michal mentioned)
> On Sep/2002, Nathan changed a bunch of them to use v1.
>  xfsprogs-2.3.0 (03 September 2002)
>        - Several changes to geometry ioctl callers which will make
>          the tools useable on older kernel versions too.
> So he did this so that new tools would work on the older kernels which
> didn't support the new geom version.
> So I guess we are stuck with v1 now.

Not necessarily - we could change the tools to use v4, and if that
didn't exist, then try v1. That way we don't need to support v1 in
linux, and the tools still run on old kernels.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
