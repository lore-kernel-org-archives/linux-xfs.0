Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44202 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbeJEICb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 04:02:31 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0634428537
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 01:06:16 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Fri, 05 Oct 2018 01:06:15 +0000
Message-ID: <bug-201331-201763-IvlP5wp6YW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201331-201763@https.bugzilla.kernel.org/>
References: <bug-201331-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201331

--- Comment #5 from Dave Chinner (david@fromorbit.com) ---
On Thu, Oct 04, 2018 at 11:25:49PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=201331

> 
> --- Comment #4 from edo (edo.rus@gmail.com) ---
> I tested with 4.17 and 4.18 prebuilt Debian kernels, behavior is the same:
> Sep 30 16:01:23 storage10x10n1 kernel: [23683.218388] INFO: task
> kworker/u24:0:21848 blocked for more than 120 seconds.

I think we need to rename XFS to "The Messenger: Please don't shoot
me"... :)

>From the xfs_info:

sunit=4096   swidth=32768 blks

Ok, that looks wrong - why do you have a MD raid device with
16MB stripe unit and a 128MB stripe width?

Yup:

md3 : active raid6 sda4[0] sdj4[9] sdg4[6] sdd4[3] sdi4[8] sdf4[5] sde4[4]
sdh4[7] sdb4[2] sdc4[1]
      77555695616 blocks super 1.2 level 6, 16384k chunk, algorithm 2 [10/10]
[UUUUUUUUUU]
            bitmap: 9/73 pages [36KB], 65536KB chunk

You've configured your RAID6 device with a 16MB chunk size, which
gives the XFS su/sw noted above.

Basically, your RMW'd your RAID device to death because every write
is a sub-stripe write.

>  Workqueue: writeback wb_workfn (flush-9:3)
>  Call Trace:
>   schedule+0x32/0x80
>  bitmap_startwrite+0x161/0x1e0 [md_mod]

MD blocks here when it has too many inflight bitmap updates and so
waits for IO to complete before starting another. This isn't XFS
filesystem IO - this in internal MD RAID consistency information
that it needs to write for crash recovery purposes.

This will be a direct result of the raid device configuration....

>  add_stripe_bio+0x441/0x7d0 [raid456]
>  raid5_make_request+0x1ae/0xb10 [raid456]
>  md_handle_request+0x116/0x190 [md_mod]
>  md_make_request+0x65/0x160 [md_mod]
>  generic_make_request+0x1e7/0x410
>   submit_bio+0x6c/0x140
>  xfs_add_to_ioend+0x14c/0x280 [xfs]
>  xfs_do_writepage+0x2bb/0x680 [xfs]
>  write_cache_pages+0x1ed/0x430
>  xfs_vm_writepages+0x64/0xa0 [xfs]
>   do_writepages+0x1a/0x60
>  __writeback_single_inode+0x3d/0x320
>  writeback_sb_inodes+0x221/0x4b0
>  __writeback_inodes_wb+0x87/0xb0
>   wb_writeback+0x288/0x320
>   wb_workfn+0x37c/0x450

... and this is just the writeback path - your problem has nothing
do with XFS...

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
