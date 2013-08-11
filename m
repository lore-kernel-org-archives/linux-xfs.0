Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 866CA7F51
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 02:11:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46987304051
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 00:11:30 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id e2TRBaAB0FIcZCVF for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 00:11:26 -0700 (PDT)
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.7/8.13.8) with ESMTP id r7B7B0bQ007762
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 09:11:00 +0200
Message-ID: <52073905.8010608@allmail.net>
Date: Sun, 11 Aug 2013 09:11:01 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Failure growing xfs with linux 3.10.5
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello!

I think I'm facing the same problem as already described here:
http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428

I tried to grow an existing xfs file system on a backup device and got
the following error:


kernel: [ 3702.275590] ffff88004f308c00: 58 46 53 42 00 00 10 00 00 00 00 00 13 10 00 00  XFSB............
kernel: [ 3702.275597] ffff88004f308c10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
kernel: [ 3702.275601] ffff88004f308c20: 46 91 c6 80 a9 a9 4d 8c 8f e2 18 fd e8 7f 66 e1  F.....M.......f.
kernel: [ 3702.275604] ffff88004f308c30: 00 00 00 00 04 00 00 04 00 00 00 00 00 00 00 80  ................
kernel: [ 3702.275610] XFS (dm-33): Internal error xfs_sb_read_verify at line 730 of file /tmp/rpm/BUILD/kernel-desktop-3.10.5/linux-3.10/fs/xfs/xfs_mount.c.  Caller
0xffffffffa08bd2fd
kernel: [ 3702.275610]
kernel: [ 3702.275617] CPU: 1 PID: 368 Comm: kworker/1:1H Tainted: P           O 3.10.5-1.1.g4e0ffc2-desktop #1
kernel: [ 3702.275620] Hardware name: Gigabyte Technology Co., Ltd. GA-990XA-UD3/GA-990XA-UD3, BIOS F13 10/26/2012
kernel: [ 3702.275667] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
kernel: [ 3702.275671]  ffffffff815205a5 ffff88022ec52ec0 ffffffffa08bfb82 ffffffffa08bd2fd
kernel: [ 3702.275678]  ffff8801000002da 0000000000000000 ffff8801ed868b00 ffff880221fa5000
kernel: [ 3702.275684]  0000000000000075 ffff88004f308c00 ffffffffa0916d77 ffffffffa08bd2fd
kernel: [ 3702.275690] Call Trace:
kernel: [ 3702.275707]  [<ffffffff81005957>] dump_trace+0x87/0x380
kernel: [ 3702.275716]  [<ffffffff81005d2d>] show_stack_log_lvl+0xdd/0x1e0
kernel: [ 3702.275723]  [<ffffffff8100728c>] show_stack+0x1c/0x50
kernel: [ 3702.275753]  [<ffffffffa08bfb82>] xfs_corruption_error+0x62/0x90 [xfs]
kernel: [ 3702.275838]  [<ffffffffa0916d77>] xfs_sb_read_verify+0x117/0x130 [xfs]
kernel: [ 3702.276020]  [<ffffffffa08bd2fd>] xfs_buf_iodone_work+0x8d/0xb0 [xfs]
kernel: [ 3702.276059]  [<ffffffff8105c673>] process_one_work+0x153/0x460
kernel: [ 3702.276068]  [<ffffffff8105d729>] worker_thread+0x119/0x340
kernel: [ 3702.276076]  [<ffffffff810640c6>] kthread+0xc6/0xd0
kernel: [ 3702.276086]  [<ffffffff8152b42c>] ret_from_fork+0x7c/0xb0
kernel: [ 3702.276093] XFS (dm-33): Corruption detected. Unmount and run xfs_repair
kernel: [ 3702.276168] XFS (dm-33): metadata I/O error: block 0x3ac00000 ("xfs_trans_read_buf_map") error 117 numblks 1
kernel: [ 3702.276177] XFS (dm-33): error 117 reading secondary superblock for ag 16


I tried to repair (xfsprogs-3.1.11) the FS as suggested, but this didn't help.

The FS relies on LVM, which itself relies on a LUKS partition.
It has been grown a few times before with different kernels < 3.10.
Growing it with 3.9.8 afterwards worked as expected.

Is there meanwhile a solution for this problem?


Some more information about the filesystem after growing
it with 3.9.8 but now running again 3.10.5:

Version of LVM: lvm2-2.02.96


gdisk -l /dev/sdh
GPT fdisk (gdisk) version 0.8.7

Partition table scan:
  MBR: hybrid
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with hybrid MBR; using GPT.
Disk /dev/sdh: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): ....
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2925 sectors (1.4 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      5860532223   2.7 TiB     8E00  primary


lvdisplay --units k /dev/mapper/backupMy-daten3
  --- Logical volume ---
  LV Path                /dev/backupMy/daten3
  LV Name                daten3
  VG Name                backupMy
  LV UUID                uuid
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                1384120320.00 KiB
  Current LE             337920
  Segments               5
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:33


xfs_info /mnt
meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=45, agsize=7700480 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=346030080, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=60160, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


df -h /mnt
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/backupMy-daten3
                      1.3T  1.2T   93G  94% /mnt




Now, I tried a xfs_repair (on linux 3.10.5) and got the following:

xfs_repair /dev/mapper/backupMy-daten3
Phase 1 - find and verify superblock...
writing modified primary superblock
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
primary/secondary superblock 11 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 11
primary/secondary superblock 12 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 12
primary/secondary superblock 14 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 14
primary/secondary superblock 10 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 10
primary/secondary superblock 8 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 8

primary/secondary superblock 9 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 9

primary/secondary superblock 5 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 5

primary/secondary superblock 1 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 1

primary/secondary superblock 2 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 2

primary/secondary superblock 3 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 3

primary/secondary superblock 4 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 4

primary/secondary superblock 15 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 15

primary/secondary superblock 13 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 13

primary/secondary superblock 6 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 6

primary/secondary superblock 7 conflict - AG superblock geometry info conflicts with filesystem geometry

reset bad sb for ag 7

invalid start block 4471539 in record 1 of bno btree block 41/1

invalid start block 5139463 in record 2 of bno btree block 41/1

invalid start block 6389489 in record 3 of bno btree block 41/1

invalid start block 5139463 in record 1 of cnt btree block 41/2

invalid start block 4471539 in record 2 of cnt btree block 41/2

invalid start block 6389489 in record 3 of cnt btree block 41/2

agf_freeblks 1464854, counted 1 in ag 41

agf_longest 1310991, counted 1 in ag 41

sb_icount 0, counted 6528

sb_ifree 0, counted 665

sb_fdblocks 0, counted 80515

        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
inode 1963848080 - bad extent starting block number 348028928, offset 0
correcting nextents for inode 1963848080
bad data fork in inode 1963848080
cleared inode 1963848080
inode 1963848084 - bad extent starting block number 348553216, offset 0
correcting nextents for inode 1963848084
bad data fork in inode 1963848084
cleared inode 1963848084
inode 1963848085 - bad extent starting block number 349077504, offset 0
correcting nextents for inode 1963848085
bad data fork in inode 1963848085
cleared inode 1963848085
inode 1963848087 - bad extent starting block number 349932241, offset 0
correcting nextents for inode 1963848087
bad data fork in inode 1963848087
cleared inode 1963848087
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 10
        - agno = 8
        - agno = 9
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 41
        - agno = 40
        - agno = 36
        - agno = 21
entry "file1" at block 3 offset 1936 in directory inode 1486526508 references free inode 1963848080
        clearing inode number in entry at offset 1936...
entry "file2" at block 3 offset 2128 in directory inode 1486526508 references free inode 1963848084
        clearing inode number in entry at offset 2128...
entry "file3" at block 3 offset 2168 in directory inode 1486526508 references free inode 1963848085
        clearing inode number in entry at offset 2168...
entry "file4" at block 3 offset 2240 in directory inode 1486526508 references free inode 1963848087
        clearing inode number in entry at offset 2240...
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 1486526508 (no data entry): rebuilding
rebuilding directory inode 1486526508
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


result:
All my data copied after the growing under 3.9.8 is lost
and the FS has the original size again before growing it:

df -h /mnt
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/backupMy-daten3
                      1.2T  1.2T  282M 100% /mnt



Doing xfs_repair again gives:

xfs_repair /dev/mapper/backupMy-daten3
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
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 19
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 20
        - agno = 5
        - agno = 18
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


xfs_info /mnt
meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=42, agsize=7700480 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=319815680, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=60160, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0






Doing xfs_growfs again gives:

xfs_growfs /mnt
meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=42, agsize=7700480 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=319815680, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=60160, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
data blocks changed from 319815680 to 346030080


xfs_info /mnt
meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=45, agsize=7700480 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=346030080, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=60160, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


df -k /mnt
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/backupMy-daten3
                     1383879680 1278733572 105146108  93% /mnt

-> The growing of the FS seems to be done anyway :-).


Doing xfs_repair again gives:

xfs_repair /dev/mapper/backupMy-daten3
Phase 1 - find and verify superblock...
writing modified primary superblock
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
primary/secondary superblock 10 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 10
primary/secondary superblock 9 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 9
primary/secondary superblock 11 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 11
primary/secondary superblock 5 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 5
primary/secondary superblock 6 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 6
primary/secondary superblock 14 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 14
primary/secondary superblock 13 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 13
primary/secondary superblock 7 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 7
primary/secondary superblock 8 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 8
primary/secondary superblock 15 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 15
primary/secondary superblock 2 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 2
primary/secondary superblock 4 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 4
primary/secondary superblock 12 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 12
primary/secondary superblock 1 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 1
primary/secondary superblock 3 conflict - AG superblock geometry info conflicts with filesystem geometry
reset bad sb for ag 3
invalid start block 4096000 in record 1 of bno btree block 41/1
invalid start block 4096000 in record 1 of cnt btree block 41/2
agf_freeblks 3604481, counted 1 in ag 41
agf_longest 3604480, counted 1 in ag 41
sb_icount 0, counted 6528
sb_ifree 0, counted 669
sb_fdblocks 0, counted 80515
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 12
        - agno = 6
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 11
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

-> xfs_growfs has been reverted again :-( because
"AG superblock geometry info conflicts with filesystem geometry"


df -k /mnt
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/backupMy-daten3
                     1279022080 1278733476    288604 100% /mnt


What should I do now? Waht's wrong?



Thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
