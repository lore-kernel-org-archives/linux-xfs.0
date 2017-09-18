Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:29493 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750822AbdIRVbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 17:31:47 -0400
Date: Tue, 19 Sep 2017 07:31:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
 fs/iomap.c:993
Message-ID: <20170918213143.GJ10621@dastard>
References: <1505746565.6990.18.camel@abdul.in.ibm.com>
 <20170918152706.GA11482@lst.de>
 <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On Mon, Sep 18, 2017 at 09:28:55AM -0600, Jens Axboe wrote:
> On 09/18/2017 09:27 AM, Christoph Hellwig wrote:
> > On Mon, Sep 18, 2017 at 08:26:05PM +0530, Abdul Haleem wrote:
> >> Hi,
> >>
> >> A warning is triggered from:
> >>
> >> file fs/iomap.c in function iomap_dio_rw
> >>
> >>     if (ret)
> >>         goto out_free_dio;
> >>
> >>     ret = invalidate_inode_pages2_range(mapping,
> >>             start >> PAGE_SHIFT, end >> PAGE_SHIFT);
> >>>>  WARN_ON_ONCE(ret);
> >>     ret = 0;
> >>
> >>     inode_dio_begin(inode);
> > 
> > This is expected and an indication of a problematic workload - which
> > may be triggered by a fuzzer.
> 
> If it's expected, why don't we kill the WARN_ON_ONCE()? I get it all
> the time running xfstests as well.

Because when a user reports a data corruption, the only evidence we
have that they are running an app that does something stupid is this
warning in their syslogs.  Tracepoints are not useful for replacing
warnings about data corruption vectors being triggered.

It needs to be on by default, bu tI'm sure we can wrap it with
something like an xfs_alert_tag() type of construct so the tag can
be set in /proc/fs/xfs/panic_mask to suppress it if testers so
desire.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
