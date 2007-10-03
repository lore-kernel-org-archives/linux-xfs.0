Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 21:58:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l934wFht008537
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 21:58:18 -0700
Date: Wed, 3 Oct 2007 14:58:04 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: xfs_reno
Message-ID: <20071003045804.GO23367404@sgi.com>
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com> <20071002090216.GA22721@infradead.org> <20071002091951.GE995458@sgi.com> <op.tzljyrfc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tzljyrfc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Oct 03, 2007 at 11:05:05AM +1000, Barry Naujok wrote:
> On Tue, 02 Oct 2007 19:19:51 +1000, David Chinner <dgc@sgi.com> wrote:
> 
> >On Tue, Oct 02, 2007 at 10:02:16AM +0100, Christoph Hellwig wrote:
> >>On Tue, Oct 02, 2007 at 05:08:59PM +1000, Barry Naujok wrote:
> >>>
> >>> The attached tool allows an inode64 filesystem to be converted to  
> >>inode32.
> >>> For this to work, the filesystem has to be mounted inode32 before  
> >>it's run.
> >>>
> >>> I'm not sure if there is any packaging changes required.
> >>
> >>Together with the stop allocating from specific AGs patch this should be
> >>90% towards an xfs_shrinkfs, right?
> >
> >Well, this just moves the inodes - it's one piece of the puzzle.  We
> >still need to collide xfs_fsr with xfs_reno to move the data.
> >
> >After that, we need to work out how to move the orphan metadata
> >blocks out of the AGs that are to be truncated off. That's not
> >simple....
> 
> I believe xfs_bmap on all inodes can reveal extended attributes and
> directory data in extra AGs. Copying those like xfs_reno does with
> "blocked" AGs should perform the desired metadata moving.

Sure. But I'm thinking of metadata like the blocks in an extent
btree that indexes the data or attribute fork of an inode. I don't
think xfs_bmap can tell us where those blocks are, and they could
be anywhere on the filesystem...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
