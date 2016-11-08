Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:53540 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932939AbcKHLKk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Nov 2016 06:10:40 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Tue, 08 Nov 2016 12:09:51 +0100
Message-ID: <1655526.YOeIAmCiZd@libor-nb>
In-Reply-To: <20161031120226.GT14023@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb> <3301912.kAxTXXYXM8@libor-nb> <20161031120226.GT14023@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Hello,
status update on vps2.
Booted to kernel 4.7.8-1~bpo8+1, xfsprogs 4.8.0.

First check it:
vps2:~# xfs_repair -n /dev/mapper/vgDisk2-lvData
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000
        - agno = 2
Metadata corruption detected at xfs_attr3_leaf block 0x24c17ba8/0x1000
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
 
then repair it
vps2:~# xfs_repair /dev/mapper/vgDisk2-lvData
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000
        - agno = 2
Metadata corruption detected at xfs_attr3_leaf block 0x24c17ba8/0x1000
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
Done

But after approx two hours:
Nov  8 07:14:12 vps2 kernel: [ 6215.369387] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x12f63f40
Nov  8 07:14:12 vps2 kernel: [ 6215.369468] XFS (dm-2): Unmount and run xfs_repair
Nov  8 07:14:12 vps2 kernel: [ 6215.369498] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Nov  8 07:14:12 vps2 kernel: [ 6215.369750] XFS (dm-2): metadata I/O error: block 0x12f63f40 ("xfs_trans_read_buf_map") error 117 numblks 8
Nov  8 07:21:16 vps2 kernel: [ 6639.384423] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x12645ef8
Nov  8 07:21:16 vps2 kernel: [ 6639.384501] XFS (dm-2): Unmount and run xfs_repair
Nov  8 07:21:16 vps2 kernel: [ 6639.384530] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Nov  8 07:21:16 vps2 kernel: [ 6639.384792] XFS (dm-2): metadata I/O error: block 0x12645ef8 ("xfs_trans_read_buf_map") error 117 numblks 8

No problem since then, for now.

What should be done next?

Thanks,
Libor


On pondělí 31. října 2016 23:02:26 CET Dave Chinner wrote:
> On Mon, Oct 31, 2016 at 09:54:00AM +0100, Libor Klep�? wrote:
> > Hello,
> > i have upgrade VM called vps1 in original email (the one on bottom of
> > email) to debian kernel 4.7.8-1~bpo8+1 and compiled xfsprogs 4.8.0.
> > 
> > Here is output of xfs_repair -n and xfs_repair. Is it supposed to write
> > if/
> > what is being repaired, when i forgot -v option?
> 
> repair will always tell you if there are errors. The logs you have
> posted indicate a clean filesystem with no errors.
> 
> Cheers,
> 
> Dave.


