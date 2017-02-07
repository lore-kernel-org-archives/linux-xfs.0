Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41288 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754697AbdBGPpi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 10:45:38 -0500
Date: Tue, 7 Feb 2017 16:45:32 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
        low-level allocator
Message-ID: <20170207154532.GA22426@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-3-git-send-email-hch@lst.de> <20170203162243.GF45388@bfoster.bfoster> <20170204095606.GC18472@lst.de> <20170206164750.GG57865@bfoster.bfoster> <20170207094332.GD15267@lst.de> <20170207131354.GA7512@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207131354.GA7512@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Feb 07, 2017 at 08:13:54AM -0500, Brian Foster wrote:
> If discard is not enabled, the behavior is straightforward in that a
> busy_gen returned for a particular extent is triggered when that extent
> is made unbusy. A retry call to xfs_extent_busy_[trim|flush]() is never
> necessary. If discard is enabled, the pagb_gen returned for a particular
> extent is triggered when one of the busy extents in the list is made
> unbusy. It might be the extent I passed to xfs_extent_busy_trim(), it
> might not. I have to retry the call to know for sure.

pagb_gen is always incremented when _a_ busy extent is freed.
Without online discard this does indeed only happen once per
log commit / AG.  With discards it could happen twice, but this
difference in semantics shouldn't really matter.

> I think it's pretty straightforward how easy that may be to misuse in
> the future. My concern is that somebody down the road adds code to trim
> a particular extent, waits on the pagb_gen, doesn't retry and thus
> introduces a very subtle bug into the code.
> 
> I can pretty much guarantee after a month or so I'm going to forget all
> about this constraint, never mind longer than that. Hence, I'm asking
> for a brief comment to clarify how pagb_gen actually works. The more I
> think about it, I think above xfs_busy_extent_trim() is the right place

>
> since that is where we introduce/return the gen, we have a comment
> update there already, and it apparently already mistakenly refers to
> online discard. How about we update it to something like the following?

Sure, I'll add it.
