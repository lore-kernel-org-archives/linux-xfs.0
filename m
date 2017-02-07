Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754642AbdBGNNz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 08:13:55 -0500
Date: Tue, 7 Feb 2017 08:13:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
 low-level allocator
Message-ID: <20170207131354.GA7512@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-3-git-send-email-hch@lst.de>
 <20170203162243.GF45388@bfoster.bfoster>
 <20170204095606.GC18472@lst.de>
 <20170206164750.GG57865@bfoster.bfoster>
 <20170207094332.GD15267@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207094332.GD15267@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 07, 2017 at 10:43:32AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 06, 2017 at 11:47:50AM -0500, Brian Foster wrote:
> > That said, that limitation should be noted somewhere. Can we add a
> > comment in xfs_extent_busy_clear() right above the hunk where we do the
> > SKIP_DISCARD wake? E.g., something that points out the gen number for
> > any particular extent could be bumped in such a situation.. (or
> > something along those lines)?
> 
> I could add a comment, but given that the tree tracks busy extents
> and is not in any way specific to discard I think it's more confusing
> than not having it.

The tree is generic to busy extents, sure. The behavior of the
generation number definitely changes depending on whether discards are
enabled or not.

If discard is not enabled, the behavior is straightforward in that a
busy_gen returned for a particular extent is triggered when that extent
is made unbusy. A retry call to xfs_extent_busy_[trim|flush]() is never
necessary. If discard is enabled, the pagb_gen returned for a particular
extent is triggered when one of the busy extents in the list is made
unbusy. It might be the extent I passed to xfs_extent_busy_trim(), it
might not. I have to retry the call to know for sure.

I think it's pretty straightforward how easy that may be to misuse in
the future. My concern is that somebody down the road adds code to trim
a particular extent, waits on the pagb_gen, doesn't retry and thus
introduces a very subtle bug into the code.

I can pretty much guarantee after a month or so I'm going to forget all
about this constraint, never mind longer than that. Hence, I'm asking
for a brief comment to clarify how pagb_gen actually works. The more I
think about it, I think above xfs_busy_extent_trim() is the right place
since that is where we introduce/return the gen, we have a comment
update there already, and it apparently already mistakenly refers to
online discard. How about we update it to something like the following?

/*
 * ...
 *
 * Return the current busy generation for the AG if the extent is busy. This
 * value can be used to wait for at least one of the currently busy extents to
 * be cleared. Note that the busy list is not guaranteed to be empty after the
 * gen is woken. The state of a specific extent must always be confirmed with
 * another call to xfs_extent_busy_trim() before it can be used.
 */

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
