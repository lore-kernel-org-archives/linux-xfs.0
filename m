Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 02:20:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l929K1om026148
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 02:20:06 -0700
Date: Tue, 2 Oct 2007 19:19:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: xfs_reno
Message-ID: <20071002091951.GE995458@sgi.com>
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com> <20071002090216.GA22721@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002090216.GA22721@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Oct 02, 2007 at 10:02:16AM +0100, Christoph Hellwig wrote:
> On Tue, Oct 02, 2007 at 05:08:59PM +1000, Barry Naujok wrote:
> > 
> > The attached tool allows an inode64 filesystem to be converted to inode32.
> > For this to work, the filesystem has to be mounted inode32 before it's run.
> > 
> > I'm not sure if there is any packaging changes required.
> 
> Together with the stop allocating from specific AGs patch this should be
> 90% towards an xfs_shrinkfs, right?

Well, this just moves the inodes - it's one piece of the puzzle.  We
still need to collide xfs_fsr with xfs_reno to move the data.

After that, we need to work out how to move the orphan metadata
blocks out of the AGs that are to be truncated off. That's not
simple....

After that, we need the transaction to shrink the fs.

At that point, we'll got a "working" shrink that will allow
shrinking to only 50% of the original size because the log will
get in the way. To fix that, we'll need to implement transactions
to move the log...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
