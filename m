Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34406 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbeHMFJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 01:09:15 -0400
Date: Mon, 13 Aug 2018 12:29:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel crashes in xfs_alloc_get_freelist() when writing to a
 corrupted xfs image
Message-ID: <20180813022906.GA31495@dastard>
References: <B0532161-669E-482B-90F9-5D67EF0569A0@gatech.edu>
 <20180811000914.GA11750@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180811000914.GA11750@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Xu, Wen" <wen.xu@gatech.edu>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Fri, Aug 10, 2018 at 05:09:14PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 18, 2018 at 08:06:37PM +0000, Xu, Wen wrote:
> > Hi,
> > 
> > Here is an issue triggered in xfs_alloc_get_freelist() when writing a corrupted v5 image.
> 
> Just out of curiosity, can you still reproduce this?  I tried just now
> on 4.19 for-next and couldn't get the kernel to crash.

This was the "discard delalloc extent and try to do an extent
conversion with a transaction in xfs_bunmapi()" problem that was
fixed in the middle of the bufferhead removal patch series.

> > [  930.655513] BUG: KASAN: null-ptr-deref in xfs_alloc_get_freelist+0x115/0x350
> > [  930.658644]  dump_stack+0x7b/0xb5
> > [  930.658653]  kasan_report+0x10c/0x390
> > [  930.658663]  __asan_load8+0x54/0x90
> > [  930.658668]  xfs_alloc_get_freelist+0x115/0x350
> > [  930.658689]  xfs_alloc_fix_freelist+0x35b/0x830
> > [  930.658740]  xfs_alloc_vextent+0x215/0x990
> > [  930.658746]  xfs_bmap_extents_to_btree+0x30d/0x940
> > [  930.658775]  __xfs_bunmapi+0x11d5/0x1430
> > [  930.658837]  xfs_bunmapi+0x2c/0x60
> > [  930.658844]  xfs_bmap_punch_delalloc_range+0x170/0x240
> > [  930.658876]  xfs_aops_discard_page+0x178/0x1d0
> > [  930.658881]  xfs_do_writepage+0x90c/0x9d0
> > [  930.658916]  write_cache_pages+0x3cd/0x770

i.e. this error path no longer calls xfs_bunmapi().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
