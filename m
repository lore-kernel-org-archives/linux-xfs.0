Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44396 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdCMOOz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Mar 2017 10:14:55 -0400
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
 <2761160.nkKuazU1Dh@libor-nb> <5223151.9ZZzaImiEQ@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2c8d1ee3-c795-aefa-4797-8b7970ea8266@sandeen.net>
Date: Mon, 13 Mar 2017 09:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <5223151.9ZZzaImiEQ@libor-nb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 3/13/17 8:48 AM, Libor Klepáč wrote:
> Hello,
> problem with this host again, after running uninterrupted from last email/repair on kernel 4.8.15. (so since 31. January)
> 
> Today, metadata corruption occured again.
> Mar 13 11:16:31 vps2 kernel: [3563991.623260] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf block 0x24e70268
> Mar 13 11:16:31 vps2 kernel: [3563991.624321] XFS (dm-2): Unmount and run xfs_repair

Ok, interesting that you hit this when writing an attr.

Can you turn the logging level way up:
# echo 11 > /proc/sys/fs/xfs/error_level

and then things like the force shutdown and the metadata will give you a backtrace, which might be useful (noisy, but useful)...

-Eric

> Mar 13 11:16:31 vps2 kernel: [3563991.624696] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> Mar 13 11:16:31 vps2 kernel: [3563991.625085] ffff994543410000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> Mar 13 11:16:31 vps2 kernel: [3563991.625511] ffff994543410010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Mar 13 11:16:31 vps2 kernel: [3563991.625983] ffff994543410020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar 13 11:16:31 vps2 kernel: [3563991.626398] ffff994543410030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar 13 11:16:31 vps2 kernel: [3563991.626829] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1322 of file /build/linux-aPrr8L/linux-4.8.15/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc08295c4
> Mar 13 11:16:31 vps2 kernel: [3563991.627210] XFS (dm-2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> Mar 13 11:16:31 vps2 kernel: [3563991.627212] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
> Mar 13 11:16:31 vps2 kernel: [3563991.627215] XFS (dm-2): Please umount the filesystem and rectify the problem(s)
> Mar 13 11:16:31 vps2 kernel: [3563991.628752] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 3420 of file /build/linux-aPrr8L/linux-4.8.15/fs/xfs/xfs_inode.c.  Return address = 0xffffffffc083fc1e
> Mar 13 11:16:48 vps2 kernel: [3564008.557340] XFS (dm-2): xfs_log_force: error -5 returned.
> 
> After reboot, sometimes it logs
> Mar 13 12:51:10 vps2 kernel: [ 5283.025665] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x24e70268
> Mar 13 12:51:10 vps2 kernel: [ 5283.026879] XFS (dm-2): Unmount and run xfs_repair
> Mar 13 12:51:10 vps2 kernel: [ 5283.027471] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> Mar 13 12:51:10 vps2 kernel: [ 5283.028074] ffff933f16f8c000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> Mar 13 12:51:10 vps2 kernel: [ 5283.028669] ffff933f16f8c010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Mar 13 12:51:10 vps2 kernel: [ 5283.029240] ffff933f16f8c020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar 13 12:51:10 vps2 kernel: [ 5283.029814] ffff933f16f8c030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar 13 12:51:10 vps2 kernel: [ 5283.030428] XFS (dm-2): metadata I/O error: block 0x24e70268 ("xfs_trans_read_buf_map") error 117 numblks 8
> Mar 13 12:51:10 vps2 kernel: [ 5283.036222] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x24e70268
> Mar 13 12:51:10 vps2 kernel: [ 5283.037443] XFS (dm-2): Unmount and run xfs_repair
> Mar 13 12:51:10 vps2 kernel: [ 5283.038049] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> Mar 13 12:51:10 vps2 kernel: [ 5283.038644] ffff933f16f8c000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> Mar 13 12:51:10 vps2 kernel: [ 5283.039257] ffff933f16f8c010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Mar 13 12:51:10 vps2 kernel: [ 5283.039838] ffff933f16f8c020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar 13 12:51:10 vps2 kernel: [ 5283.040397] ffff933f16f8c030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Mar 13 12:51:10 vps2 kernel: [ 5283.041482] XFS (dm-2): metadata I/O error: block 0x24e70268 ("xfs_trans_read_buf_map") error 117 numblks 8
> 
> I have installed kernel 4.9.13 from backports and installed tools 4.10.0.
> Collegue will reboot yesterday and do the repair.
> 
> It seems to be the same pattern again. Do you have any clue where it comes from? How can we prevent it from happening?
> 
> Thanks,
> Libor
> 
> On úterý 31. ledna 2017 9:03:02 CET Libor Klepáč wrote:
>>
>> Hello,
>> sorry for late reply. It didn't crash since than and i forgot and moved on to another tasks.
>>
>> Yesterday it crashed on one of machines (running 4.8.11)
>> -------------------------
>> Jan 30 07:18:13 vps2 kernel: [5881831.379547] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x12f63f40
>> Jan 30 07:18:13 vps2 kernel: [5881831.381721] XFS (dm-2): Unmount and run xfs_repair
>> Jan 30 07:18:13 vps2 kernel: [5881831.382750] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
>> Jan 30 07:18:13 vps2 kernel: [5881831.387810] XFS (dm-2): metadata I/O error: block 0x12f63f40 ("xfs_trans_read_buf_map") error 117 numblks 8
>> Jan 30 07:26:02 vps2 kernel: [5882300.524528] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x12645ef8
>> Jan 30 07:26:02 vps2 kernel: [5882300.525993] XFS (dm-2): Unmount and run xfs_repair
>> Jan 30 07:26:02 vps2 kernel: [5882300.526539] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
>> Jan 30 07:26:02 vps2 kernel: [5882300.529224] XFS (dm-2): metadata I/O error: block 0x12645ef8 ("xfs_trans_read_buf_map") error 117 numblks 8
>> Jan 30 10:00:27 vps2 kernel: [5891564.682483] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf block 0x127b5578
>> Jan 30 10:00:27 vps2 kernel: [5891564.683962] XFS (dm-2): Unmount and run xfs_repair
>> Jan 30 10:00:27 vps2 kernel: [5891564.684536] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
>> Jan 30 10:00:27 vps2 kernel: [5891564.687223] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1250 of file /build/linux-lVEVrl/linux-4.7.8/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc06747f2
>> Jan 30 10:00:27 vps2 kernel: [5891564.687230] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
>> Jan 30 10:00:27 vps2 kernel: [5891564.687778] XFS (dm-2): Please umount the filesystem and rectify the problem(s)
>>
>> and later
>> Jan 30 21:10:31 vps2 kernel: [39747.917831] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x24c17ba8
>> Jan 30 21:10:31 vps2 kernel: [39747.918130] XFS (dm-2): metadata I/O error: block 0x24c17ba8 ("xfs_trans_read_buf_map") error 117 numblks 8
>> -------------------------
>>
>> I have scheduled repair on today, all these blocks were repaired using xfsprogs 4.9.0
>> Kernel is now 4.8.15
>>
>> -------------------------
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan and clear agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>>         - agno = 1
>> Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
>> bad attribute count 0 in attr block 0, inode 1074268922
>> problem with attribute contents in inode 1074268922
>> clearing inode 1074268922 attributes
>> correcting nblocks for inode 1074268922, was 1 - counted 0
>> Metadata corruption detected at xfs_attr3_leaf block 0x127b5578/0x1000
>> bad attribute count 0 in attr block 0, inode 1077334032
>> problem with attribute contents in inode 1077334032
>> clearing inode 1077334032 attributes
>> correcting nblocks for inode 1077334032, was 1 - counted 0
>> Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000
>> bad attribute count 0 in attr block 0, inode 1093437859
>> problem with attribute contents in inode 1093437859
>> clearing inode 1093437859 attributes
>> correcting nblocks for inode 1093437859, was 1 - counted 0
>>         - agno = 2
>> Metadata corruption detected at xfs_attr3_leaf block 0x24c17ba8/0x1000
>> bad attribute count 0 in attr block 0, inode 2147673775
>> problem with attribute contents in inode 2147673775
>> clearing inode 2147673775 attributes
>> correcting nblocks for inode 2147673775, was 1 - counted 0
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 1
>> bad attribute format 1 in inode 1074268922, resetting value
>> bad attribute format 1 in inode 1077334032, resetting value
>> bad attribute format 1 in inode 1093437859, resetting value
>>         - agno = 2
>> bad attribute format 1 in inode 2147673775, resetting value
>> Phase 5 - rebuild AG headers and trees...
>>         - reset superblock...
>> Phase 6 - check inode connectivity...
>>         - resetting contents of realtime bitmap and summary inodes
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> Phase 7 - verify and correct link counts...
>> done
>> -------------------------
>>
>> Thank you very much for patch, it has done it's work
>>
>> Libor
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
