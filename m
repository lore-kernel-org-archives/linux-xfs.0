Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35556 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751103AbdANGWa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jan 2017 01:22:30 -0500
Date: Fri, 13 Jan 2017 22:22:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH, RFC] xfs: use per-AG reservations for the finobt
Message-ID: <20170114062210.GF14038@birch.djwong.org>
References: <1483107598-6779-1-git-send-email-hch@lst.de>
 <20170103192426.GA14031@birch.djwong.org>
 <20170113174300.GA6418@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113174300.GA6418@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Fri, Jan 13, 2017 at 06:43:00PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 03, 2017 at 11:24:26AM -0800, Darrick J. Wong wrote:
> > ...and so here we calculate the number of blocks needed to store the
> > maximum number of finobt records possible for an AG.  IIRC, each *inobt
> > record refers to a single chunk of 64 inodes (or at least a theoretical
> > chunk in the spinodes=1 case), so I think we can reduce the reservation
> > to...
> > 
> > nr = m_sb.sb_agblocks * m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
> > return xfs_inobt_calc_size(mp, nr);
> > 
> > ...right?
> 
> Yes, that should reduce the reservation quite a bit.
> 
> > This requires us to traverse all the blocks in the finobt at mount time,
> > which isn't necessarily quick.  For refcount/rmap we cache the number of
> > tree blocks in the AGF to speed this up... but it was easy to sneak that
> > into the disk format. :)
> 
> But for finobt it's too late to do that without another incompatible
> feature flag.

Agree.

> > For finobt I wonder if one could defer the block counting work to a
> > separate thread if the AG has enough free blocks to cover, say, 10x the
> > maximum reservation?  Though that could be racy and maybe finobts are
> > small enough that the impact on mount time is low anyway?
> 
> Usually they are small.  And if they aren't - well that's life.
> 
> I don't think anync counting for a reservation is a good idea.  If we
> see a problem with the time needed to count in practice we'll have to
> keep a count an introduce a feature flag.

Yeah, that seems less tricky to get right.

> > There's also the unsolved problem of what happens if we mount and find
> > agf_freeblks < (sum(ask) - sum(used)) -- right now we eat that state and
> > hope that we don't later ENOSPC and crash.
> 
> Yes.  Which is exactly the situation we would have without this
> patch anyway..
> 
> > But as for retroactively adding AG reservations for an existing tree, I
> > guess we'll have to come up with a strategy for dealing with
> > insufficient free blocks.  I suppose one could try to use xfs_fsr to
> > move large contiguous extents to a less full AG, if there are any...
> 
> Eww.  We could just fall back to the old code before this patch,
> which would then eventually shut down..

For now I'm tempted just to xfs_info a warning that some AG is low on
space and this could potentially cause the fs to go down.  It's not like
we currently have the ability to silently move data out of an AG to
spread the load more evenly.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
