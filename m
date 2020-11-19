Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6904EC388F9
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 20:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AD5122261
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 20:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgKSUuP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 15:50:15 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34912 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgKSUuP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Nov 2020 15:50:15 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9A1663C2653;
        Fri, 20 Nov 2020 07:50:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kfqsc-00Cv7W-Jv; Fri, 20 Nov 2020 07:50:10 +1100
Date:   Fri, 20 Nov 2020 07:50:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] xfs: don't allow NOWAIT DIO across extent boundaries
Message-ID: <20201119205010.GA2842436@dread.disaster.area>
References: <20201119042315.535693-1-david@fromorbit.com>
 <20201119175526.GF9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119175526.GF9695@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=7RMx4JeAD36_FNQqzu0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 19, 2020 at 09:55:26AM -0800, Darrick J. Wong wrote:
> On Thu, Nov 19, 2020 at 03:23:15PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Jens has reported a situation where partial direct IOs can be issued
> > and completed yet still return -EAGAIN. We don't want this to report
> > a short IO as we want XFS to complete user DIO entirely or not at
> > all.
> > 
> > This partial IO situation can occur on a write IO that is split
> > across an allocated extent and a hole, and the second mapping is
> > returning EAGAIN because allocation would be required.
> > 
> > The trivial reproducer:
> > 
> > $ sudo xfs_io -fdt -c "pwrite 0 4k" -c "pwrite -V 1 -b 8k -N 0 8k" /mnt/scr/foo
> > wrote 4096/4096 bytes at offset 0
> > 4 KiB, 1 ops; 0.0001 sec (27.509 MiB/sec and 7042.2535 ops/sec)
> > pwrite: Resource temporarily unavailable
> > $
> > 
> > The pwritev2(0, 8kB, RWF_NOWAIT) call returns EAGAIN having done
> > the first 4kB write:
> > 
> >  xfs_file_direct_write: dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 0x2000
> >  iomap_apply:          dev 259:1 ino 0x83 pos 0 length 8192 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
> >  xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
> >  xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
> >  xfs_iomap_found:      dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 8192 fork data startoff 0x0 startblock 24 blockcount 0x1
> >  iomap_apply_dstmap:   dev 259:1 ino 0x83 bdev 259:1 addr 102400 offset 0 length 4096 type MAPPED flags DIRTY
> > 
> > Here the first iomap loop has mapped the first 4kB of the file and
> > issued the IO, and we enter the second iomap_apply loop:
> > 
> >  iomap_apply: dev 259:1 ino 0x83 pos 4096 length 4096 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
> >  xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
> >  xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
> > 
> > And we exit with -EAGAIN out because we hit the allocate case trying
> > to make the second 4kB block.
> > 
> > Then IO completes on the first 4kB and the original IO context
> > completes and unlocks the inode, returning -EAGAIN to userspace:
> > 
> >  xfs_end_io_direct_write: dev 259:1 ino 0x83 isize 0x1000 disize 0x1000 offset 0x0 count 4096
> >  xfs_iunlock:          dev 259:1 ino 0x83 flags IOLOCK_SHARED caller xfs_file_dio_aio_write
> > 
> > There are other vectors to the same problem when we re-enter the
> > mapping code if we have to make multiple mappinfs under NOWAIT
> > conditions. e.g. failing trylocks, COW extents being found,
> > allocation being required, and so on.
> > 
> > Avoid all these potential problems by only allowing IOMAP_NOWAIT IO
> > to go ahead if the mapping we retrieve for the IO spans an entire
> > allocated extent. This avoids the possibility of subsequent mappings
> > to complete the IO from triggering NOWAIT semantics by any means as
> > NOWAIT IO will now only enter the mapping code once per NOWAIT IO.
> > 
> > Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Hmm so I guess the whole point of this is speculative writing?

Non-blocking async writes, not speculative writes.

> As in, thread X either wants us to write impatiently, or to fail the
> whole IO so that it can hand the slow-mode write to some other thread or
> something?

Yes, that's exactly the sort of thing RWF_NOWAIT was originally
intended to support (e.g. the SeaStar IO framework).

> The manpage says something about short reads, but it doesn't
> say much about writes, but silently writing some but not all seems
> broken. :)

Well, that depends on how you look at it.

In the end, the current behaviour has a transient data state that is
finalised when the write gets re-run by the
application. The only issue here is efficiency, and we don't really
even care if there's a crash between the these two IOs that would
result in the silent write being exposed.

I say this because the write is always going to be done as two
separate IOs so there's always a failure window where the non-atomic
writes can result in only one of them hitting stable storage.

Hence this change doesn't actually affect anything from the data
integrity perspective - it just closes the window down slightly and
prevents unnecessary repeated IO and/or blocking a task we shouldn't
be blocking.

> If so then I guess this is fine, and to the (limited) extent that I grok
> the whole usecase,
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
