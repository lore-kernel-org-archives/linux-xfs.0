Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:64119 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbeLNC5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 21:57:24 -0500
Date: Fri, 14 Dec 2018 13:57:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] iomap: don't search past page end in
 iomap_is_partially_uptodate
Message-ID: <20181214025720.GJ6311@dastard>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-3-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544739929-21651-3-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph@sandeen.net, Hellwig@sandeen.net, hch@lst.de

On Thu, Dec 13, 2018 at 04:25:28PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> iomap_is_partially_uptodate() is intended to check wither blocks within
> the selected range of a not-uptodate page are uptodate; if the range we
> care about is up to date, it's an optimization.
> 
> However, the iomap implementation continues to check all blocks up to
> from+count, which is beyond the page, and can even be well beyond the
> iop->uptodate bitmap.

The issue is that the caller does not limit the range to the page it
is checking to see if it is up to date. Hence we have to clamp it.

> I think the worst that will happen is that we may eventually find a zero
> bit and return "not partially uptodate" when it would have otherwise
> returned true, and skip the optimization.  Still, it's clearly an invalid
> memory access that must be fixed.

It depends on how far beyond the page the count extends. :P

> So: fix this by limiting the search to within the page as is done in the
> non-iomap variant, block_is_partially_uptodate().
> 
> Zorro noticed thiswhen KASAN went off for 512 byte blocks on a 64k
> page system:
> 
>  BUG: KASAN: slab-out-of-bounds in iomap_is_partially_uptodate+0x1a0/0x1e0
>  Read of size 8 at addr ffff800120c3a318 by task fsstress/22337
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

SOB issue. :)

But hte code is the same as the patch I wrote yesterday for this and
tested overnight, so

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
