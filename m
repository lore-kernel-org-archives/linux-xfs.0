Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:52312 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932446AbdBVLm0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 06:42:26 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Wed, 22 Feb 2017 12:42:21 +0100
Message-ID: <3412655.IXdA3WXzce@libor-nb>
In-Reply-To: <3965431.22NzgsWbJj@libor-nb>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net> <3965431.22NzgsWbJj@libor-nb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hi,
it happened again on one machine vps3 from last mail, which had clean xfs_repair run
It's running kernel 4.9.0-0.bpo.1-amd64 (so it's 4.9.2) since 6. Feb. It was upgraded from 4.8.15.

Error was
Feb 22 11:04:21 vps3 kernel: [1316281.466922] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf block 0xa000718
Feb 22 11:04:21 vps3 kernel: [1316281.468665] XFS (dm-2): Unmount and run xfs_repair
Feb 22 11:04:21 vps3 kernel: [1316281.469440] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Feb 22 11:04:21 vps3 kernel: [1316281.470212] ffffa06e686ac000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Feb 22 11:04:21 vps3 kernel: [1316281.470964] ffffa06e686ac010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Feb 22 11:04:21 vps3 kernel: [1316281.471691] ffffa06e686ac020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 22 11:04:21 vps3 kernel: [1316281.472431] ffffa06e686ac030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 22 11:04:21 vps3 kernel: [1316281.473129] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1322 of file /home/zumbi/linux-4.9.2/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc05e0dc4
Feb 22 11:04:21 vps3 kernel: [1316281.473685] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
Feb 22 11:04:21 vps3 kernel: [1316281.474402] XFS (dm-2): Please umount the filesystem and rectify the problem(s)

After reboot, there was once this:
Feb 22 11:46:41 vps3 kernel: [ 2440.571092] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0xa000718
Feb 22 11:46:41 vps3 kernel: [ 2440.571160] XFS (dm-2): Unmount and run xfs_repair
Feb 22 11:46:41 vps3 kernel: [ 2440.571177] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Feb 22 11:46:41 vps3 kernel: [ 2440.571198] ffff8c46fdbe5000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Feb 22 11:46:41 vps3 kernel: [ 2440.571225] ffff8c46fdbe5010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Feb 22 11:46:41 vps3 kernel: [ 2440.571252] ffff8c46fdbe5020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 22 11:46:41 vps3 kernel: [ 2440.571278] ffff8c46fdbe5030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 22 11:46:41 vps3 kernel: [ 2440.571313] XFS (dm-2): metadata I/O error: block 0xa000718 ("xfs_trans_read_buf_map") error 117 numblks 8

We will run repair tomorrow. Is it worth upgrading xfsprogs from 4.9.0 to 4.10.0-rc1 before repair?

Thanks,
Libor




On středa 1. února 2017 13:48:57 CET Libor Klepáč wrote:
> [This sender failed our fraud detection checks and may not be who they appear to be. Learn about spoofing at http://aka.ms/LearnAboutSpoofing]
> 
> Hello,
> we tried also on vps1 reported here in bottom of email
> https://www.spinics.net/lists/linux-xfs/msg01728.html
> and vps3 from this email
> https://www.spinics.net/lists/linux-xfs/msg02672.html
> 
> Both came clean. Does it mean, that corruption was really only in memory
> and did not made it to disks?
> Both machines are on 4.8.15 and xfsprogs 4.9.0
> 
> #root@vps3 # xfs_repair /dev/mapper/vg2Disk2-lvData
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> Note - quota info will be regenerated on next quota mount.
> done
> 
> ---------------------------------
> #root@vps1:~# xfs_repair /dev/mapper/vgVPS1Disk2-lvData
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> -------------------------
> 
> Thanks,
> Libor
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------
[1] mailto:libor.klepac@bcom.cz
[2] tel:+420377457676
[3] http://www.bcom.cz

