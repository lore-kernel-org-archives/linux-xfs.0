Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38638 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732668AbeGKRhS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 13:37:18 -0400
Date: Wed, 11 Jul 2018 10:31:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
 the fork didn't change
Message-ID: <20180711173152.GF32415@magnolia>
References: <20180710060528.4071-1-hch@lst.de>
 <20180710060528.4071-7-hch@lst.de>
 <20180711171551.GE32415@magnolia>
 <20180711172032.GA3738@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180711172032.GA3738@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 11, 2018 at 07:20:32PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 11, 2018 at 10:15:51AM -0700, Darrick J. Wong wrote:
> > Hmm, this troubles me slightly -- a short time ago you removed the "trim
> > this data fork mapping to the first overlap with a cow fork mapping"
> > (i.e. xfs_reflink_trim_irec_to_next_cow) behavior on the grounds that
> > _writepage_map calls _map_blocks for every block in the page and so it
> > was unnecessary.  But this seems to put that back.  Why is that?
> 
> Because back then map_blocks did a lookup in the COW fork everytime
> (unless we are already on a COW mapping), and this patch wants to
> only look it up when the COW fork actually changed, so the trim is
> required now.

Ah, ok.   Mind if I change the comment to:

/*
 * Truncate to the next COW extent if there is one.  This is the only
 * opportunity to do this because we can skip COW fork lookups for the
 * subsequent blocks in the mapping; however, the requirement to treat
 * the COW range separately remains.
 */

I also wonder why we don't need to do the same for holes, but I think
the answer is that any dirty page with a cow fork mapping must also have
a data fork mapping (even if it's merely a delalloc reservation) and so
a hole will never overlap with a cow fork mapping.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
