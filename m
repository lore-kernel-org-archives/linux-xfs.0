Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6B7C3A589
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 00:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2431221852
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 00:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfHSAJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 20:09:44 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40727 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbfHSAJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Aug 2019 20:09:44 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 16C9E43C575;
        Mon, 19 Aug 2019 10:09:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzVDr-0000eT-LQ; Mon, 19 Aug 2019 10:08:31 +1000
Date:   Mon, 19 Aug 2019 10:08:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "hch@lst.de" <hch@lst.de>
Cc:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190819000831.GX6129@dread.disaster.area>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
 <20190818071128.GA17286@lst.de>
 <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818173426.GA32311@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=zyJJqv7RHsUVqA3mHbAA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 18, 2019 at 07:34:26PM +0200, hch@lst.de wrote:
> On Sun, Aug 18, 2019 at 09:41:40AM +0200, hch@lst.de wrote:
> > On Sun, Aug 18, 2019 at 09:11:28AM +0200, hch@lst.de wrote:
> > > > The kernel log shows the following when the mount fails:
> > > 
> > > Is it always that same message?  I'll see if I can reproduce it,
> > > but I won't have that much memory to spare to create fake pmem,
> > > hope this also works with a single device and/or less memory..
> > 
> > I've reproduced a similar ASSERT with a small pmem device, so I hope
> > I can debug the issue locally now.
> 
> So I can also reproduce the same issue with the ramdisk driver, but not
> with any other 4k sector size device (nvmet, scsi target, scsi_debug,
> loop).

How did you reproduce it? I tried with indentical pmem config to
what Vishal was using and couldn't hit it...

> Which made me wonder if there is some issue about the memory
> passed in, and indeed just switching to plain vmalloc vs the XFS
> kmem_alloc_large wrapper that either uses kmalloc or vmalloc fixes
> the issue for me.  I don't really understand why yet, maybe I need to
> dig out alignment testing patches.
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 13d1d3e95b88..918ad3b884a7 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -125,7 +125,7 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
> +	return vmalloc(BBTOB(nbblks));
>  }

So it fails with contiguous memory being added to the bio (kmalloc
returns contiguous memory), but not with indiivdual, non-contiugous
pages (what vmalloc returns)?

Ok, so here's the trace of all the kmem_alloc_large() calls when
mounting the filesystem directly after mkfs:

https://lore.kernel.org/linux-xfs/20190722233452.31183-1-david@fromorbit.com/

 mount-1818  [001]   691.648570: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648570: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.648575: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648575: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.648578: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648578: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.648581: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648581: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.648583: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648583: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.648586: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648586: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.648588: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648589: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.648591: kmem_alloc_large:     size 262144 flags 0x8 caller xlog_alloc_log
 mount-1818  [001]   691.648592: kmem_alloc:           size 262144 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.649456: kmem_alloc_large:     size 4096 flags 0x8 caller xlog_find_zeroed
 mount-1818  [001]   691.649456: kmem_alloc:           size 4096 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.649496: kmem_alloc_large:     size 12288 flags 0x8 caller xlog_find_verify_cycle
 mount-1818  [001]   691.649496: kmem_alloc:           size 12288 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.649502: kmem_alloc_large:     size 8192 flags 0x8 caller xlog_find_verify_log_record
 mount-1818  [001]   691.649502: kmem_alloc:           size 8192 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.649506: kmem_alloc_large:     size 4096 flags 0x8 caller xlog_find_tail
 mount-1818  [001]   691.649506: kmem_alloc:           size 4096 flags 0x8 caller kmem_alloc_large
 mount-1818  [001]   691.649516: kmem_alloc_large:     size 4198400 flags 0x8 caller xlog_write_log_records
 mount-1818  [001]   691.649517: kmem_alloc:           size 4198400 flags 0x8 caller kmem_alloc_large
                                                       ^^^^^^^^^^^^
 mount-1818  [001]   691.652152: kmem_alloc_large:     size 0 flags 0x11 caller xfs_alloc_rsum_cache
 mount-1818  [001]   691.652152: kmem_alloc:           size 0 flags 0x11 caller kmem_alloc_large
umount-1826  [000]   691.670308: kmem_alloc_large:     size 512 flags 0x5 caller xfs_log_commit_cil
umount-1826  [000]   691.670309: kmem_alloc:           size 512 flags 0x5 caller kmem_alloc_large

Ok, there's a >4MB allocation from:

xlog_find_tail
  xlog_clear_stale_blocks
    xlog_write_log_records
      xlog_alloc_buffer
	kmem_alloc_large()

If this memory allocation fails, we make the allocation smaller
in xlog_write_log_records() and try again. over and over again until
it succeeds of the size isn't large enough to hold a single buffer.
The above trace shows the allocation succeeding as a single
contiguous buffer (no retries), and the IOs succeed and all is good.

But Vishal wasn't even getting that far - the "totally zeroed_log"
comes from xlog_find_head after xlog_find_zeroed() fails.

xlog_find_zeroed() does a single sector allocation (4kB) and uses
that over and over again for the binary search. Then it calls
xlog_find_verify_cycle() which is passed a search range for
based on the last block it found that was zero and the size of
the log write window (2MB). If the last block found is less than
the log write window, it trims it back to the last block. We see
this in the trace above - a mkfs'd filesytem should have an unmount
record in it an nothing else, so at most 2 sectors should be
written. We see a 12kB - 3 sector - allocation in the trace above,
but it could be up to 2MB in size.

Finally, there's a 2 sector allocation by
xlog_find_verify_log_record(), which it does to check whether it
needs to back up the head to an earlier block in the log write
window because the log writes hit the disk out of order. That's
another "up to 2MB" allocation, but in the trace above it's only
8kB.

The issue, I think, is that only the big allocation in
xlog_clear_stale_blocks() has somewhat robust ENOMEM error handling.
All of these other allocations will return failure is the buffer
allocation fails, and KM_MAYFAIL doesn't try very hard to ensure the
allocation will succeed.

This change:

> -     return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
> +     return vmalloc(BBTOB(nbblks));

demonstrates the difference - it changes the code from an allocation
that is allowed to fail to an allocation that will never fail. i.e
KM_MAYFAIL context is also passed to the __vmalloc() call inside
kmem_alloc_large() hence it can fail easily, too, where as vmalloc()
tries much, much harder and so is, in comparison, a NOFAIL context
(GFP_KERNEL).

I'd suggest that the fix is to pass the allocation context into
xlog_alloc_buffer(), using KM_MAYFAIL for only the allocations that
have ENOMEM fallback handling...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
