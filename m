Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Jan 2007 15:18:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0BNIXqw028723
	for <xfs@oss.sgi.com>; Thu, 11 Jan 2007 15:18:36 -0800
Date: Fri, 12 Jan 2007 10:17:24 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Tweaking/Optimizing MD RAID: 195MB/s write, 181MB/s read (so far)
Message-ID: <20070111231724.GH44411608@melbourne.sgi.com>
References: <Pine.LNX.4.64.0701111804310.3847@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701111804310.3847@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kerne.org, xfs@oss.sgi.com

On Thu, Jan 11, 2007 at 06:05:36PM -0500, Justin Piszcz wrote:
> With 4 Raptor 150s & XFS (default XFS options):

I need more context for this to be meaningful in any way.

What type of md config are you using here?  RAID0, 1, 5.....?

What's the raw device throughput (i.e. read and write to /dev/md3)?

output of 'growfs_xfs -n <mntpt>'? (i.e. is XFS doing aligned
or unaligned allocation/IO)?

If it's raid0, how does it compare with a dm stripe?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
