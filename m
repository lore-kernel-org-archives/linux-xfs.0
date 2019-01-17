Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbfAQQfU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jan 2019 11:35:20 -0500
Date: Thu, 17 Jan 2019 11:35:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: validate writeback mapping using data fork seq
 counter
Message-ID: <20190117163516.GD37591@bfoster>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111123032.31538-4-bfoster@redhat.com>
 <20190113214905.GB4205@dastard>
 <20190114153422.GA3148@bfoster>
 <20190117144728.GA28225@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117144728.GA28225@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 06:47:28AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 14, 2019 at 10:34:23AM -0500, Brian Foster wrote:
> > static bool
> > xfs_imap_valid()
> > {
> > 	if (offset_fsb < wpc->imap.br_startoff)
> > 		return false;
> > 	if (offset_fsb >= wpc->imap.br_startoff + wpc->imap.br_blockcount)
> > 		return false;
> > 	/* a valid range is sufficient for COW mappings */
> > 	if (wpc->io_type == XFS_IO_COW)
> > 		return true;
> > 
> > 	/*
> > 	 * Not a COW mapping. Revalidate across changes in either the
> > 	 * data or COW fork ...
> > 	 */
> > 	if (wpc->data_seq != READ_ONCE(ip->i_df.if_seq)
> > 		return false;
> > 	if (xfs_inode_has_cow_data(ip) &&
> > 	    wpc->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)
> > 		return false;
> > 
> > 	return true;
> > }
> > 
> > I think that technically we could skip the == XFS_IO_COW check and we'd
> > just be more conservative by essentially applying the same fork change
> > logic we are for the data fork, but that's not really the intent of this
> > patch.
> 
> That above logic looks pretty sensible to me.  And I don't think there
> is any need for being more conservative.
> 

Agreed.

> > > One of the things that limits xfs_iomap_write_allocate() efficiency
> > > is the mitigations for races against truncate. i.e. the huge comment that
> > > starts:
> > > 
> > > 	       /*
> > > 		* it is possible that the extents have changed since
> > > 		* we did the read call as we dropped the ilock for a
> > > 		* while. We have to be careful about truncates or hole
> > > 		* punchs here - we are not allowed to allocate
> > > 		* non-delalloc blocks here.
> > > ....
> > > 
> > 
> > Hmm, Ok... so this fix goes a ways back to commit e4143a1cf5 ("[XFS] Fix
> > transaction overrun during writeback."). It sounds like the issue was an
> > instance of the "attempt to convert delalloc blocks ends up doing
> > physical allocation" problem (which results in a transaction overrun).
> 
> FYI, that area is touched by my always COW series, it would be great
> if I could get another review for that.  And yes, I need to dust it off
> and resende based on the comments from Darrick.  I just need to find
> out how to best combine it with your current series.
> 
> > > Now that we can detect that the extents have changed in the data
> > > fork, we can go back to allocating multiple extents per
> > > xfs_bmapi_write() call by doing a sequence number check after we
> > > lock the inode. If the sequence number does not match what was
> > > passed in or returned from the previous loop, we return -EAGAIN.
> > > 
> > 
> > I'm not familiar with this particular instance of this problem (we've
> > certainly had other instances of the same thing), but the surrounding
> > context of this code has changed quite a bit. Most notably is
> > XFS_BMAPI_DELALLOC, which was intended to mitigate this problem by
> > disallowing real allocation in such calls.
> 
> I'm also not sure what doing multiple allocations in one calls is
> supposed to really buys us.  We basically have to roll transactions
> and redo all checks anyway.
> 
> > > Hmmm, looking at the existing -EAGAIN case, I suspect this isn't
> > > handled correctly by xfs_map_blocks() anymore. i.e. it just returns
> > > the error which can lead to discarding the page rather than checking
> > > to see if the there was a valid map allocated. I think there's some
> > > followup work here (another patch series). :/
> > > 
> > 
> > Ok. At the moment, that error looks like it should only happen if we're
> > past EOF..? Either way, the XFS_BMAPI_DELALLOC thing still can result in
> > an error so it probably makes sense to tie a seqno check to -EAGAIN and
> > handle it properly in the caller.
> 
> For that whole -EAGAIN handling please look at my always cow series
> again, I got bitten by it a few times and also think the current code
> works only by chance and in the right phase of the moon.  I hope the
> series documents what we had it for very nicely.

Hmm, it would be nice if these fixes were separate from the whole
always_cow thing. Some initial thoughts on a quick look through the
first few patches on the v3 post:

1. It's probably best to drop your xfs_trim_extent_eof() changes as I
have a stable patch to add a couple more calls and then I subsequently
remove the whole thing going forward. Refactoring it is just churn at
this point.

2. The whole explicit race with truncate detection looks rather involved
to me at first glance. I'm trying to avoid relying on i_size at all for
this because it doesn't seem like a reliable approach. E.g., Dave
described a hole punch vector for the same fundamental problem this
series is trying to address:

  https://marc.info/?l=linux-xfs&m=154692641021480&w=2

I don't think looking at i_size really helps us with that, but I could
be missing other changes in the cow series.

In general I'm looking at putting something like this in
xfs_iomap_write_allocate() once the data fork sequence number tracking
is enabled:

                        /*
                         * Now that we have ILOCK we must account for the fact
                         * that the fork (and thus our mapping) could have
                         * changed while the inode was unlocked. If the fork
                         * has changed, trim the caller's mapping to the
                         * current extent in the fork.
                         *
                         * If the external change did not modify the current
                         * mapping (or just grew it) this will have no effect.
                         * If the current mapping shrunk, we expect to at
                         * minimum still have blocks backing the current page as
                         * the page has remained locked since writeback first
                         * located delalloc block(s) at the page offset. A
                         * racing truncate, hole punch or even reflink must wait
                         * on page writeback before it can modify our page and
                         * underlying block(s).
                         *
                         * We'll update *seq before we drop ilock for the next
                         * iteration.
                         */
                        if (*seq != READ_ONCE(ifp->if_seq)) {
                                if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb,
                                                            &icur, &timap) ||
                                    timap.br_startoff > offset_fsb) {
                                        ASSERT(0);
                                        error = -EFSCORRUPTED;
                                        goto trans_cancel;
                                }
                                xfs_trim_extent(imap, timap.br_startoff,
                                                timap.br_blockcount);
                                count_fsb = imap->br_blockcount;
                                map_start_fsb = imap->br_startoff;
                        }

... and getting rid of the existing i_size cruft. I think this handles
the same problem in a different way, primary difference being that
truncate or hole punch is more likely to have to wait on writeback
rather than writeback trying so hard to get out of the way. Also note
that we still have the i_size checks on the page in xfs_do_writepage()
that will cause writeback to back off in the truncate case once we spin
around to the next page. Thoughts?

I'm still testing this but I can try to get something posted to the list
a bit sooner than I was anticipating for the purpose of trying to order
these series and/or sanity checking the approach..

Brian
