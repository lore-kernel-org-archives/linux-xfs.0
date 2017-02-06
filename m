Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbdBFQrv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 11:47:51 -0500
Date: Mon, 6 Feb 2017 11:47:50 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
 low-level allocator
Message-ID: <20170206164750.GG57865@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-3-git-send-email-hch@lst.de>
 <20170203162243.GF45388@bfoster.bfoster>
 <20170204095606.GC18472@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170204095606.GC18472@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 04, 2017 at 10:56:06AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 03, 2017 at 11:22:43AM -0500, Brian Foster wrote:
> > I didn't catch this until looking through everything after the next
> > patch, but I think there's a problem with the wakeup here as well. If we
> > have a busy extent with XFS_EXTENT_BUSY_SKIP_DISCARD set, we immediately
> > issue a wake from the first xfs_extent_busy_clear() in the cil committed
> > handler, regardless of whether !SKIP_DISCARD extents exist as well
> > under the current gen value. I think that means we'd get a premature
> > wake any time a busy_list has at least one of each type..?
> 
> We'll need to wake as soon as a previously busy extent in the AG
> becomes available, and that includes  XFS_EXTENT_BUSY_SKIP_DISCARD
> ones.  Otherwise e.g. a transaction only containing
> XFS_EXTENT_BUSY_SKIP_DISCARD will never wake at all.
> 

Hmm, Ok. I suppose that isn't a problem so long as we don't ever wait
for a particular extent based on a particular generation number. The
current code is just retrying allocations and whatnot, so is probably
safe.

That said, that limitation should be noted somewhere. Can we add a
comment in xfs_extent_busy_clear() right above the hunk where we do the
SKIP_DISCARD wake? E.g., something that points out the gen number for
any particular extent could be bumped in such a situation.. (or
something along those lines)?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
