Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58610 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752894AbcK0XQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 18:16:53 -0500
Date: Mon, 28 Nov 2016 10:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: an iomap-based direct I/O implementation V3
Message-ID: <20161127231639.GW28177@dastard>
References: <1479064054-10474-1-git-send-email-hch@lst.de>
 <20161122225243.GN31101@dastard>
 <fe3fa405-7295-1a86-0e78-85be65d9edba@kernel.dk>
 <20161123000204.GO31101@dastard>
 <d0a96b3e-9fb1-9c93-2c0e-6a1d7ec1e98d@kernel.dk>
 <20161123083657.GA16966@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161123083657.GA16966@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Nov 23, 2016 at 09:36:57AM +0100, Christoph Hellwig wrote:
> On Tue, Nov 22, 2016 at 05:40:30PM -0700, Jens Axboe wrote:
> > That's going to be somewhat harder... The REQ_IDLE used to be
> > REQ_NOIDLE. bio_iov_iter_get_pages() is a single commit, so that's easy
> > enough. The poll bits are 3-4 patches, so not too bad either.
> 
> I think we'll simply need a tree that has latest master merged into
> the block tree as a base. 

I'd prefer not to pull and entire tree into the xfs for-next branch
if I can avoid it.

> The only other option would be to cherry-pick
> bio_iov_iter_get_pages from the block tree into the XFS tree, and I'll
> resend the series so that it doesn't require the other block changes,
> those are fairly mechanical merges that could be carried in linux-next.

I think this is probably a better way of proceeding. Can you resend
the series and in the description indicate what commit I need to
cherrypick from the the block tree?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
