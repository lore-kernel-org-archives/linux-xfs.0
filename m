Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42402 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbcJMHQU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Oct 2016 03:16:20 -0400
Date: Thu, 13 Oct 2016 09:06:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/9] xfs: optimize xfs_reflink_end_cow
Message-ID: <20161013070639.GE10579@lst.de>
References: <1476106685-29048-1-git-send-email-hch@lst.de> <1476106685-29048-9-git-send-email-hch@lst.de> <20161012141536.GD56019@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161012141536.GD56019@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Oct 12, 2016 at 10:15:37AM -0400, Brian Foster wrote:
> > +	xfs_bmap_search_extents(ip, end_fsb - 1, XFS_COW_FORK, &eof, &idx,
> > +			&got, &prev);
> > +	if (eof) {
> > +		ASSERT(idx > 0);
> > +		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, --idx), &got);
> > +	}
> 
> Hmm, should this happen? Do we really want to proceed with the previous
> extent?

Yes.  This is the same pattern as xfs_bunmapi and it is needed.  For
an explanation we need to recall the semantics of xfs_bmap_search_extents,
which gives us the extent at bno IFF there is one, else if gives us the
extent beyond bno.

So we search for the last extent in the to be deleted range here,
but if there is no extent at the end of the range we'll get a return
outside the range, in which case we need to back one up (which
bunmapi does and we catch somewhat confusingly with the trim_extent
and goto next_extent, I should clean that up..), but as a special
case we can get the eof case where there is no extent beyong bno.

> I suppose the extent trim below would catch if we've dropped outside the
> range of the I/O, but note that if trim extent sets blockcount = 0, it
> doesn't necessarily reset the start offset for the (del.br_startoff ==
> offset_fsb) check at next_extent. Perhaps that should break once the del
> end offset precedes offset_fsb..?
> 
> Either way, it would be nice to have a comment here if there's some
> reason we shouldn't just bail out or flag a problem...

Yes, both this code and bumapi could use some cleanup..

> Maybe it's just me, but I find this whole loop kind of confusing. I
> realize it is tricky because we have to handle several different cases
> with regard to index (no more extents to the left, bmap_del_extent_cow()
> pushing index forward or back).

I found it rather confusing as well.
> 
> In staring at it a bit, I'm wondering if something like the following
> would work:
> 
> 	/* walk backwards until we're out of the I/O range... */
> 	while (got.br_startoff + got.br_blockcount > offset_fsb) {
> 		del = got;
> 		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
> 		/* extent delete may have bumped idx forward */
> 		if (!del.br_blockcount) {
> 			idx--;
> 			goto next_extent;
> 		}
> 
> 		...
> 
> next_extent:
> 		if (idx < 0)
> 			break;
> 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
> 	}
> 
> Thoughts?

That looks reasonable, I'll see if it passes xfstests.. :)
