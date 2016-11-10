Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50707 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751203AbcKJF3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2016 00:29:47 -0500
Date: Thu, 10 Nov 2016 16:29:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Message-ID: <20161110052915.GG28922@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb>
 <20161031120226.GT14023@dastard>
 <1655526.YOeIAmCiZd@libor-nb>
 <2639114.hBi4OJ80y2@libor-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2639114.hBi4OJ80y2@libor-nb>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Nov 08, 2016 at 12:28:54PM +0100, Libor Klepáč wrote:
> Adding more output from dmesg
> 
>  XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x12f63f40
>  XFS (dm-2): Unmount and run xfs_repair
>  XFS (dm-2): First 64 bytes of corrupted metadata buffer:
>  ffff88018fe02000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
>  ffff88018fe02010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
>  ffff88018fe02020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  ffff88018fe02030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  XFS (dm-2): metadata I/O error: block 0x12f63f40 ("xfs_trans_read_buf_map") error 117 numblks 8

So, again, it is empty attribute blocks that are being tripped over
at blkno 0x12f63f40 and 0x12645ef8

Which:

> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> >         - agno = 1
> > Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
> > Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000

These two blocks. It looks like repair didn't clean them up?

Hmmmm - looking at the code I'm not sure that repair detects and
removes empty attr leaf blocks, which would explain why the error
showed up again.. Can you provide a metadump of the filesystem so we
can did into the exact neature of the problem you are seeing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
