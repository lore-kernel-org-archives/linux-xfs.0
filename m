Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeFSFf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 01:35:58 -0400
Date: Mon, 18 Jun 2018 22:35:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/24] xfs: remove xfs_map_cow
Message-ID: <20180619053537.GT8128@magnolia>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-12-hch@lst.de>
 <20180618173837.GA40796@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618173837.GA40796@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jun 18, 2018 at 01:38:38PM -0400, Brian Foster wrote:
> On Fri, Jun 15, 2018 at 03:01:56PM +0200, Christoph Hellwig wrote:
> > We can handle the existing cow mapping case as a special case directly
> > in xfs_writepage_map, and share code for allocating delalloc blocks
> > with regular I/O in xfs_map_blocks.  This means we need to always
> > call xfs_map_blocks for reflink inodes, but we can still skip most of
> > the work if it turns out that there is no COW mapping overlapping the
> > current block.
> > 
> > As a subtle detail we need to start caching holes in the wpc to deal
> > with the case of COW reservations between EOF.  But we'll need that
> > infrastructure later anyway, so this is no big deal.
> > 
> > Based on a patch from Dave Chinner.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_aops.c | 186 ++++++++++++++++++++++------------------------
> >  fs/xfs/xfs_aops.h |   4 +-
> >  2 files changed, 92 insertions(+), 98 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index c8fc6786b06c..ff27bdcc49a1 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> ...
> > @@ -887,22 +877,24 @@ xfs_writepage_map(
> >  		if (wpc->imap_valid)
> >  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> >  							 offset);
> > -		if (!wpc->imap_valid) {
> > -			error = xfs_map_blocks(inode, offset, &wpc->imap,
> > -					     wpc->io_type);
> 
> A comment would be nice here just so the purpose of the logic is clear
> at a glance. E.g:
> 
>                 /*
>                  * COW fork blocks can overlap data fork blocks even if the
>                  * blocks aren't shared. COW I/O always takes precedent, so we
>                  * must always check for overlap on reflink inodes unless the
>                  * mapping is already COW.
>                  */
> 
> With something like that, this now looks pretty good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

I concur, it would help to have a comment to remind everyone that we
sometimes upgrade to a cow write even when it's not strictly required.
:)

With that comment added in,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Note: I see that this code ends up shifted into xfs_map_blocks(). If
> it's easier to add the comment in whatever patch touches that last,
> that's fine too.
> 
> Brian
> 
> > +		if (!wpc->imap_valid ||
> > +		    (xfs_is_reflink_inode(XFS_I(inode)) &&
> > +		     wpc->io_type != XFS_IO_COW)) {
> > +			error = xfs_map_blocks(wpc, inode, offset);
> >  			if (error)
> >  				goto out;
> >  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> >  							 offset);
> >  		}
> > -		if (wpc->imap_valid) {
> > -			lock_buffer(bh);
> > -			if (wpc->io_type != XFS_IO_OVERWRITE)
> > -				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
> > -			xfs_add_to_ioend(inode, bh, offset, wpc, wbc, &submit_list);
> > -			count++;
> > -		}
> >  
> > +		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE)
> > +			continue;
> > +
> > +		lock_buffer(bh);
> > +		if (wpc->io_type != XFS_IO_OVERWRITE)
> > +			xfs_map_at_offset(inode, bh, &wpc->imap, offset);
> > +		xfs_add_to_ioend(inode, bh, offset, wpc, wbc, &submit_list);
> > +		count++;
> >  	} while (offset += len, ((bh = bh->b_this_page) != head));
> >  
> >  	ASSERT(wpc->ioend || list_empty(&submit_list));
> > diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> > index 694c85b03813..466d22e5bc36 100644
> > --- a/fs/xfs/xfs_aops.h
> > +++ b/fs/xfs/xfs_aops.h
> > @@ -29,6 +29,7 @@ enum {
> >  	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
> >  	XFS_IO_OVERWRITE,	/* covers already allocated extent */
> >  	XFS_IO_COW,		/* covers copy-on-write extent */
> > +	XFS_IO_HOLE,		/* covers region without any block allocation */
> >  };
> >  
> >  #define XFS_IO_TYPES \
> > @@ -36,7 +37,8 @@ enum {
> >  	{ XFS_IO_DELALLOC,		"delalloc" }, \
> >  	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
> >  	{ XFS_IO_OVERWRITE,		"overwrite" }, \
> > -	{ XFS_IO_COW,			"CoW" }
> > +	{ XFS_IO_COW,			"CoW" }, \
> > +	{ XFS_IO_HOLE,			"hole" }
> >  
> >  /*
> >   * Structure for buffered I/O completions.
> > -- 
> > 2.17.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
