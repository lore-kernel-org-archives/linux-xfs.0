Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:2877 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753723AbeFPAKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 20:10:39 -0400
Date: Sat, 16 Jun 2018 10:10:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: symlinks can be zero length during log recovery
Message-ID: <20180616001034.GR10363@dastard>
References: <20180615014314.27574-1-david@fromorbit.com>
 <20180615113126.GA2857@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615113126.GA2857@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 07:31:26AM -0400, Brian Foster wrote:
> On Fri, Jun 15, 2018 at 11:43:14AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > A log recovery failure has been reproduced where a symlink inode has
> > a zero length in extent form. It was caused by a shutdown during a
> > combined fstress+fsmark workload.
> > 
> > To fix it, we have to allow zero length symlink inodes through
> > xfs_dinode_verify() during log recovery. We already specifically
> > check and allow this case in the shortform symlink fork verifier,
> > but in this case we don't get that far, and the inode is not in
> > shortform format.
> > 
> > Update the dinode verifier to handle this case, and change the
> > symlink fork verifier to only allow this case to exist during log
> > recovery.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Seems Ok to me, but before we restrict some of the existing checks to
> log recovery I am curious about one thing. xfs_inactive_symlink() has
> this:
> 
>         /*
>          * Zero length symlinks _can_ exist.
>          */
>         pathlen = (int)ip->i_d.di_size;
>         if (!pathlen) {
>                 xfs_iunlock(ip, XFS_ILOCK_EXCL);
>                 return 0;
>         }
> 
> I'm not quite sure what case that covers, but it seems slightly
> inconsistent with the fork verifer change (simply because that path is
> not exclusive to the read from disk case), at least. Any idea?

Yeah, that's what I'm trying to chase down right now. I had the
verifier fire on inode writeback during generic/269. I don't know
yet where these zero length symlinks are coming from, and none of
the comments (there's a couple that say the above)
actually give any hint to their source.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
