Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36013 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbfEUBnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 21:43:41 -0400
Date: Tue, 21 May 2019 11:43:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Message-ID: <20190521014336.GG29573@dread.disaster.area>
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513140943.GC61135@bfoster>
 <683a9b7b-ad5c-5e91-893e-daaa68a853c9@sandeen.net>
 <CAHgs-5Vybp+diCoecfEWbHLRScNnsHKW7-4rwhXH3H+hfcfoLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHgs-5Vybp+diCoecfEWbHLRScNnsHKW7-4rwhXH3H+hfcfoLg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tim Smith <tim.smith@vaultcloud.com.au>
Cc: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 09:39:02AM +1000, Tim Smith wrote:
> On Tue, May 14, 2019 at 1:06 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> > I'm kind of interested in what xfs_repair finds in this case.
> 
> $ sudo xfs_repair -m 4096 -v /dev/sdad
> Phase 1 - find and verify superblock...
>         - block cache size set to 342176 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 159752 tail block 159752
>         - scan filesystem freespace and inode maps...
> sb_fdblocks 4725279343, counted 430312047

$ printf %x 4725279343
119a60a6f
$ printf %x 430312047
 19a60a6f

You definitely have uncorrected single bit errors occuring 
on your systems.

If the filesystem was writing this bad fdblock count to disk, then
xfs_validate_sb_write() would be firing this warning:

	xfs_warn(mp, "SB summary counter sanity check failed");

when the superblock is written back on unmount. That write would
then fail, and that would leave the log dirty. Then after log
recovery we'd rebuild the counters from the AGFs because it wasn't a
clean unmount, and the problem would go away. If the log was clean,
then we'd see that the fdblocks count was invalid, and we'd rebuild
the counters from the AGFs and the problem would go away.

But you are saying that unmount/mount doesn't fix it, which means
you must be running a sufficiently old kernel that it doesn't detect
these conditions, issue warnings and automatically repair itself.
Yup:

8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
2e9e6481e2a7 ("xfs: detect and fix bad summary counts at mount")

were both merged in 4.19. Well, that would explain why you aren't
seeing warnings or having it fixed automatically on detection.

IOWs, whatever the cause of your single bit error is, I don't know,
but it would seem that recent kernels will detect the condition and
automatically fix themselves at mount time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
