Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932305AbcKOSL1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 13:11:27 -0500
Date: Tue, 15 Nov 2016 13:11:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 3/4] xfs: reuse xfs_file_iomap_begin_delay() for cow
 fork delalloc
Message-ID: <20161115181125.GE65218@bfoster.bfoster>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <1478636856-7590-4-git-send-email-bfoster@redhat.com>
 <20161115142826.GC18630@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115142826.GC18630@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 06:28:26AM -0800, Christoph Hellwig wrote:
> > +	/*
> > +	 * Search for a preexisting extent. COW fork allocation may still be
> > +	 * required for reflink inodes if the data extent is shared.
> > +	 */
> >  	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
> >  			&got, &prev);
> >  	imap = got;
> 
> Maybe we should look up directly into imap and now duplicate that
> information for imap and got?
> 

Didn't you recently change this code from doing that? I'm not following
how changing it back helps us...

> >  		if (xfs_is_reflink_inode(ip)) {
> > +			bool		shared, trimmed;
> >  
> > +			/*
> > +			 * Assume the data extent is shared if an extent exists
> > +			 * in the cow fork.
> > +			 */
> > +			xfs_trim_extent(&imap, offset_fsb,
> > +					end_fsb - offset_fsb);
> > +			xfs_bmap_search_extents(ip, imap.br_startoff,
> > +					XFS_COW_FORK, &eof, &idx, &got, &prev);
> > +			if (!eof && got.br_startoff <= imap.br_startoff) {
> > +				trace_xfs_reflink_cow_found(ip, &got);
> > +				xfs_trim_extent(&imap, got.br_startoff,
> > +						got.br_blockcount);
> > +				goto done;
> > +			}
> > +
> > +			/*
> > +			 * No existing cow fork extent. Now we have to actually
> > +			 * check if the data extent is shared and trim the
> > +			 * mapping to the next (un)shared boundary.
> > +			 */
> > +			error = xfs_reflink_trim_around_shared(ip, &imap,
> > +						       &shared, &trimmed);
> >  			if (error)
> >  				goto out_unlock;
> > +			if (!shared)
> > +				goto done;
> > +
> > +			end_fsb = imap.br_startoff + imap.br_blockcount;
> 
> I think the code for looking at the COW fork should go into a little
> helper, even if it means passing a few arguments to it.
> 

Ok.

> > +			fork = XFS_COW_FORK;
> > +		} else {
> > +			trace_xfs_iomap_found(ip, offset, count, 0, &imap);
> > +			goto done;
> >  		}
> 
> And while we're at it - try to always handle the a that ends with a
> goto first, that helps to reduce the indentation level.
> 

Indeed, that looks like a nice cleanup.

Brian
