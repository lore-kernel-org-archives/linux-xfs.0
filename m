Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36814 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfAQOra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:47:30 -0500
Date: Thu, 17 Jan 2019 06:47:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: validate writeback mapping using data fork seq
 counter
Message-ID: <20190117144728.GA28225@infradead.org>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111123032.31538-4-bfoster@redhat.com>
 <20190113214905.GB4205@dastard>
 <20190114153422.GA3148@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190114153422.GA3148@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Jan 14, 2019 at 10:34:23AM -0500, Brian Foster wrote:
> static bool
> xfs_imap_valid()
> {
> 	if (offset_fsb < wpc->imap.br_startoff)
> 		return false;
> 	if (offset_fsb >= wpc->imap.br_startoff + wpc->imap.br_blockcount)
> 		return false;
> 	/* a valid range is sufficient for COW mappings */
> 	if (wpc->io_type == XFS_IO_COW)
> 		return true;
> 
> 	/*
> 	 * Not a COW mapping. Revalidate across changes in either the
> 	 * data or COW fork ...
> 	 */
> 	if (wpc->data_seq != READ_ONCE(ip->i_df.if_seq)
> 		return false;
> 	if (xfs_inode_has_cow_data(ip) &&
> 	    wpc->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)
> 		return false;
> 
> 	return true;
> }
> 
> I think that technically we could skip the == XFS_IO_COW check and we'd
> just be more conservative by essentially applying the same fork change
> logic we are for the data fork, but that's not really the intent of this
> patch.

That above logic looks pretty sensible to me.  And I don't think there
is any need for being more conservative.

> > One of the things that limits xfs_iomap_write_allocate() efficiency
> > is the mitigations for races against truncate. i.e. the huge comment that
> > starts:
> > 
> > 	       /*
> > 		* it is possible that the extents have changed since
> > 		* we did the read call as we dropped the ilock for a
> > 		* while. We have to be careful about truncates or hole
> > 		* punchs here - we are not allowed to allocate
> > 		* non-delalloc blocks here.
> > ....
> > 
> 
> Hmm, Ok... so this fix goes a ways back to commit e4143a1cf5 ("[XFS] Fix
> transaction overrun during writeback."). It sounds like the issue was an
> instance of the "attempt to convert delalloc blocks ends up doing
> physical allocation" problem (which results in a transaction overrun).

FYI, that area is touched by my always COW series, it would be great
if I could get another review for that.  And yes, I need to dust it off
and resende based on the comments from Darrick.  I just need to find
out how to best combine it with your current series.

> > Now that we can detect that the extents have changed in the data
> > fork, we can go back to allocating multiple extents per
> > xfs_bmapi_write() call by doing a sequence number check after we
> > lock the inode. If the sequence number does not match what was
> > passed in or returned from the previous loop, we return -EAGAIN.
> > 
> 
> I'm not familiar with this particular instance of this problem (we've
> certainly had other instances of the same thing), but the surrounding
> context of this code has changed quite a bit. Most notably is
> XFS_BMAPI_DELALLOC, which was intended to mitigate this problem by
> disallowing real allocation in such calls.

I'm also not sure what doing multiple allocations in one calls is
supposed to really buys us.  We basically have to roll transactions
and redo all checks anyway.

> > Hmmm, looking at the existing -EAGAIN case, I suspect this isn't
> > handled correctly by xfs_map_blocks() anymore. i.e. it just returns
> > the error which can lead to discarding the page rather than checking
> > to see if the there was a valid map allocated. I think there's some
> > followup work here (another patch series). :/
> > 
> 
> Ok. At the moment, that error looks like it should only happen if we're
> past EOF..? Either way, the XFS_BMAPI_DELALLOC thing still can result in
> an error so it probably makes sense to tie a seqno check to -EAGAIN and
> handle it properly in the caller.

For that whole -EAGAIN handling please look at my always cow series
again, I got bitten by it a few times and also think the current code
works only by chance and in the right phase of the moon.  I hope the
series documents what we had it for very nicely.
