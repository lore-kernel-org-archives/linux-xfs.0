Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Jan 2007 15:33:05 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0BNWxqw031505
	for <xfs@oss.sgi.com>; Thu, 11 Jan 2007 15:33:00 -0800
Date: Thu, 11 Jan 2007 18:32:06 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Tweaking/Optimizing MD RAID: 195MB/s write, 181MB/s read (so
 far)
In-Reply-To: <20070111231724.GH44411608@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0701111831570.3673@p34.internal.lan>
References: <Pine.LNX.4.64.0701111804310.3847@p34.internal.lan>
 <20070111231724.GH44411608@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

Have not tried DM stripe btw.

On Fri, 12 Jan 2007, David Chinner wrote:

> On Thu, Jan 11, 2007 at 06:05:36PM -0500, Justin Piszcz wrote:
> > With 4 Raptor 150s & XFS (default XFS options):
> 
> I need more context for this to be meaningful in any way.
> 
> What type of md config are you using here?  RAID0, 1, 5.....?
> 
> What's the raw device throughput (i.e. read and write to /dev/md3)?
> 
> output of 'growfs_xfs -n <mntpt>'? (i.e. is XFS doing aligned
> or unaligned allocation/IO)?
> 
> If it's raid0, how does it compare with a dm stripe?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
