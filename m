Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:39769 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbeKTUTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 15:19:00 -0500
Date: Tue, 20 Nov 2018 20:50:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: don't ENOSPC on writeback when punching holes
Message-ID: <20181120095042.GO19305@dastard>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-7-david@fromorbit.com>
 <20181120082040.GF30481@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120082040.GF30481@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 12:20:40AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 20, 2018 at 08:04:58AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Just tried to punch a 40T sparse file when enospc was triggered due
> > to extent size hints consuming more space than expected. It failed
> > with:
> > 
> > # sudo xfs_io -c "fpunch 0 40t" /mnt/fast/xfs-arekm.img
> > fallocate: No space left on device
> > #
> > 
> > because the writeback error of ENOSPC was being reported. We're
> > going to free that space, so we don't care if there was a ENOSPC
> > writeback error. So ignore ENOSPC errors and punch anyway.
> 
> How do even get -ENOSPC back from writeback?  It seems like we have
> a much worse root cause lingering here.

It hammered ENOSPC pretty hard - I think it had consumed the entire
reserve pool and that can causes allocation transaction reservations
in xfs_iomap_write_allocate() to return ENOSPC even if we've got a
reservation for the data extents being allocated.

This doesn't happen very often in the real world, but if it does we
need operations like punch to work to be able to free space and
get us out of that hole...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
