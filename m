Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 12:32:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lACKVqKU028467
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 12:31:56 -0800
Date: Tue, 13 Nov 2007 07:31:47 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [[PATCH, RESEND]] less AGs for single disks configs.
Message-ID: <20071112203147.GA995458@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com> <1194839329-22003-1-git-send-email-xaiki@sgi.com> <1194839329-22003-2-git-send-email-xaiki@sgi.com> <1194839329-22003-3-git-send-email-xaiki@sgi.com> <1194839329-22003-4-git-send-email-xaiki@sgi.com> <1194839329-22003-5-git-send-email-xaiki@sgi.com> <1194839329-22003-6-git-send-email-xaiki@sgi.com> <20071112090147.GD66820511@sgi.com> <Pine.LNX.4.64.0711120956340.2701@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711120956340.2701@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xaiki@sgi.com, xfs@oss.sgi.com

On Mon, Nov 12, 2007 at 09:57:21AM -0500, Justin Piszcz wrote:
> On Mon, 12 Nov 2007, David Chinner wrote:
> >A single spindle, regardless of it's size, will have similar
> >seek characteristics so scaling the number of AGs with size
> >is the wrong thing to do - you don't get better parallelism
> >out of a single spindle, just more seeks and lower performance.
> >hence keeping the number of AGs fixed up to the point where
> >the AG size tops out (i.e. 4TB) seems like a better scaling
> >factor to me. i.e. something like:
> >
> >
> >	if (!multidisk) {
> >		if (dblocks >= TERABYTES(4, blocklog)) {
> >			blocks = XFS_AG_MAX_BLOCKS(blocklog);
> >			goto done;
> >		}
> >		agcount = 4;
> >		/* work out ag size here */
> >		goto done;
> >	}
> >
> >I'd also like to see some test results showing the mkfs output
> >for the different configurations to confirm it works correctly
> >(i.e. that the corner cases work correctly).
> 
> Dave, when this is put into place do you recommend people re-format their 
> XFS partitions for those with a 750GiB drive -or- with a < 2TB RAID5 
> array,

No. If you are having performance problems, then changing the way the
filesystem is laid out *may* improve performance but if everything
is working fine then don't change it.

> would one see any increase in speed?

On a single disk, yes. On RAID5 - who knows. There are so many other
variables to raid5 performance (esp software raid) that such single disk
optimisations could degrade performance. On other RAID hardware, it
might improve - it really depends on the RAID implementation....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
