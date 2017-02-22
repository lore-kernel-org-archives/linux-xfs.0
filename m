Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59146 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932120AbdBVNpk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 08:45:40 -0500
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
 <3965431.22NzgsWbJj@libor-nb> <3412655.IXdA3WXzce@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <30c5d3eb-5f62-5488-aff7-6b1544f1c29a@sandeen.net>
Date: Wed, 22 Feb 2017 07:45:38 -0600
MIME-Version: 1.0
In-Reply-To: <3412655.IXdA3WXzce@libor-nb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 2/22/17 5:42 AM, Libor Klepáč wrote:
> Hi,
> it happened again on one machine vps3 from last mail, which had clean xfs_repair run
> It's running kernel 4.9.0-0.bpo.1-amd64 (so it's 4.9.2) since 6. Feb. It was upgraded from 4.8.15.
> 
> Error was
> Feb 22 11:04:21 vps3 kernel: [1316281.466922] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf block 0xa000718
> Feb 22 11:04:21 vps3 kernel: [1316281.468665] XFS (dm-2): Unmount and run xfs_repair
> Feb 22 11:04:21 vps3 kernel: [1316281.469440] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> Feb 22 11:04:21 vps3 kernel: [1316281.470212] ffffa06e686ac000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> Feb 22 11:04:21 vps3 kernel: [1316281.470964] ffffa06e686ac010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Feb 22 11:04:21 vps3 kernel: [1316281.471691] ffffa06e686ac020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Feb 22 11:04:21 vps3 kernel: [1316281.472431] ffffa06e686ac030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Feb 22 11:04:21 vps3 kernel: [1316281.473129] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1322 of file /home/zumbi/linux-4.9.2/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc05e0dc4
> Feb 22 11:04:21 vps3 kernel: [1316281.473685] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
> Feb 22 11:04:21 vps3 kernel: [1316281.474402] XFS (dm-2): Please umount the filesystem and rectify the problem(s)

Ok, and what happened to this machine in the meantime?
I don't understand why this has been showing up for you; it'd be
nice to know if anything "interesting" happened prior to this -
any other shutdown and log replay, for example?  Or what
is the workload that's leading to this, if you can tell?

If you run repair and it tells you which inode it is, go find
that inode and see if there is anything "interesting" about its
lifetime or attribute use, perhaps?

> After reboot, there was once this:
> Feb 22 11:46:41 vps3 kernel: [ 2440.571092] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0xa000718
> Feb 22 11:46:41 vps3 kernel: [ 2440.571160] XFS (dm-2): Unmount and run xfs_repair
> Feb 22 11:46:41 vps3 kernel: [ 2440.571177] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> Feb 22 11:46:41 vps3 kernel: [ 2440.571198] ffff8c46fdbe5000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> Feb 22 11:46:41 vps3 kernel: [ 2440.571225] ffff8c46fdbe5010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Feb 22 11:46:41 vps3 kernel: [ 2440.571252] ffff8c46fdbe5020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Feb 22 11:46:41 vps3 kernel: [ 2440.571278] ffff8c46fdbe5030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Feb 22 11:46:41 vps3 kernel: [ 2440.571313] XFS (dm-2): metadata I/O error: block 0xa000718 ("xfs_trans_read_buf_map") error 117 numblks 8
> 
> We will run repair tomorrow. Is it worth upgrading xfsprogs from 4.9.0 to 4.10.0-rc1 before repair?

Should be no need, though always happy to have testing.  :)

> Thanks,
> Libor
> 
> 
> 
> 
> On středa 1. února 2017 13:48:57 CET Libor Klepáč wrote:
>> [This sender failed our fraud detection checks and may not be who they appear to be. Learn about spoofing at http://aka.ms/LearnAboutSpoofing]
>>
>> Hello,
>> we tried also on vps1 reported here in bottom of email
>> https://www.spinics.net/lists/linux-xfs/msg01728.html
>> and vps3 from this email
>> https://www.spinics.net/lists/linux-xfs/msg02672.html
>>
>> Both came clean. Does it mean, that corruption was really only in memory
>> and did not made it to disks?
>> Both machines are on 4.8.15 and xfsprogs 4.9.0
>>
>> #root@vps3 # xfs_repair /dev/mapper/vg2Disk2-lvData
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
>>         - agno = 2
>>         - agno = 3
>>         - agno = 4
>>         - agno = 5
>>         - agno = 6
>>         - agno = 7
>>         - agno = 8
>>         - agno = 9
>>         - agno = 10
>>         - agno = 11
>>         - agno = 12
>>         - agno = 13
>>         - agno = 14
>>         - agno = 15
>>         - agno = 16
>>         - agno = 17
>>         - agno = 18
>>         - agno = 19
>>         - agno = 20
>>         - agno = 21
>>         - agno = 22
>>         - agno = 23
>>         - agno = 24
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>>         - agno = 4
>>         - agno = 5
>>         - agno = 6
>>         - agno = 7
>>         - agno = 8
>>         - agno = 9
>>         - agno = 10
>>         - agno = 11
>>         - agno = 12
>>         - agno = 13
>>         - agno = 14
>>         - agno = 15
>>         - agno = 16
>>         - agno = 17
>>         - agno = 18
>>         - agno = 19
>>         - agno = 20
>>         - agno = 21
>>         - agno = 22
>>         - agno = 23
>>         - agno = 24
>> Phase 5 - rebuild AG headers and trees...
>>         - reset superblock...
>> Phase 6 - check inode connectivity...
>>         - resetting contents of realtime bitmap and summary inodes
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> Phase 7 - verify and correct link counts...
>> Note - quota info will be regenerated on next quota mount.
>> done
>>
>> ---------------------------------
>> #root@vps1:~# xfs_repair /dev/mapper/vgVPS1Disk2-lvData
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
>>         - agno = 2
>>         - agno = 3
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
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
>> Thanks,
>> Libor
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> --------
> [1] mailto:libor.klepac@bcom.cz
> [2] tel:+420377457676
> [3] http://www.bcom.cz
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
