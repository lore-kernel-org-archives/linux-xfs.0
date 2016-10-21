Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:48117 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754385AbcJUROU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Oct 2016 13:14:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.webx.cz (Postfix) with ESMTP id 85383426F6
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 19:09:08 +0200 (CEST)
Received: from mail.webx.cz ([127.0.0.1])
        by localhost (mail1.webx.cz [127.0.0.1]) (amavisd-new, port 10042)
        with LMTP id puKAnfipFV3Y for <linux-xfs@vger.kernel.org>;
        Fri, 21 Oct 2016 19:09:08 +0200 (CEST)
Received: from libor-nb.localnet (remote.bcom.cz [88.208.120.34])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.webx.cz (Postfix) with ESMTPSA id 21BF1426E7
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 19:09:08 +0200 (CEST)
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Fri, 21 Oct 2016 19:09:06 +0200
Message-ID: <5244720.RPRsZ88NJ0@libor-nb>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,
sorry for last incomplete email (if it arrives), i hit some send button by accident.

Last week we have started to have problems with one virtual machine running debian jessie, with kernel 3.16.7-ckt20-1+deb8u4.
virtualization is done on vmware 5.5 on dell r610, disks are on perc h700.

XFS is on data disk (/dev/mapper/vgDisk2-lvData) running cyrus, mysql, apache+php.
It resides on single disk LVM, without partitions.
#pvs
  PV         VG      Fmt  Attr PSize   PFree
  /dev/sda2  vgDisk1 lvm2 a--   15.76g    0 
  /dev/sdb   vgDisk2 lvm2 a--  410.00g    0

#lvs
  LV       VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvSwap   vgDisk1 -wi-ao----   1.86g                                                    
  lvSystem vgDisk1 -wi-ao----  13.90g                                                    
  lvData   vgDisk2 -wi-ao---- 410.00g

#grep xfs /etc/fstab 
/dev/mapper/vgDisk2-lvData      /mountpoint       xfs     noatime,logbufs=8       0       1

It was created in Debian Squeeze on kernel 2.6.32 OR Wheezy on 3.2.0.


There are some logs, this one repeats but doesn't cause shutdown

Oct 14 07:02:58 vps2 kernel: [18855093.206725] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x46/0xd0 [xfs], block 0x24c17ba8
Oct 14 07:02:58 vps2 kernel: [18855093.210393] XFS (dm-2): Unmount and run xfs_repair
Oct 14 07:02:58 vps2 kernel: [18855093.211224] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Oct 14 07:02:58 vps2 kernel: [18855093.212092] ffff8801853da000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Oct 14 07:02:58 vps2 kernel: [18855093.213932] ffff8801853da010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Oct 14 07:02:58 vps2 kernel: [18855093.215915] ffff8801853da020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 07:02:58 vps2 kernel: [18855093.218054] ffff8801853da030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 07:02:58 vps2 kernel: [18855093.220317] XFS (dm-2): metadata I/O error: block 0x24c17ba8 ("xfs_trans_read_buf_map") error 117 numblks 8

Then shutdown occured on different block 0x12f63f40
Oct 14 12:00:24 vps2 kernel: [18872956.205316] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs], block 0x12f63f40
Oct 14 12:00:24 vps2 kernel: [18872956.208382] XFS (dm-2): Unmount and run xfs_repair
Oct 14 12:00:24 vps2 kernel: [18872956.209385] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Oct 14 12:00:24 vps2 kernel: [18872956.210187] ffff88011dadd000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Oct 14 12:00:24 vps2 kernel: [18872956.211816] ffff88011dadd010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Oct 14 12:00:24 vps2 kernel: [18872956.213390] ffff88011dadd020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 12:00:24 vps2 kernel: [18872956.214983] ffff88011dadd030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 12:00:24 vps2 kernel: [18872956.216598] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1330 of file /build/linux-U7H2aZ/linux-3.16.7-ckt20/fs/xfs/xfs_buf.c.  Return address = 0xffffffffa03ef820
Oct 14 12:00:24 vps2 kernel: [18872956.217448] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
Oct 14 12:00:24 vps2 kernel: [18872956.218338] XFS (dm-2): Please umount the filesystem and rectify the problem(s)

after killing all relevant processes and unmounting some bind-mount points and remounting

Oct 14 12:09:21 vps2 kernel: [18873494.193987] XFS (dm-2): xfs_log_force: error 5 returned.
Oct 14 12:09:28 vps2 kernel: [18873501.622426] XFS (dm-2): Mounting V4 Filesystem
Oct 14 12:09:29 vps2 kernel: [18873501.700781] XFS (dm-2): Starting recovery (logdev: internal)
Oct 14 12:09:29 vps2 kernel: [18873501.998101] XFS (dm-2): Ending recovery (logdev: internal)

filesystem mounts ok, but after while it logs again on block 0x24c17ba8, without shutdown

Oct 14 12:20:31 vps2 kernel: [18874164.759507] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x46/0xd0 [xfs], block 0x24c17ba8
Oct 14 12:20:31 vps2 kernel: [18874164.764684] XFS (dm-2): Unmount and run xfs_repair
Oct 14 12:20:31 vps2 kernel: [18874164.766246] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Oct 14 12:20:31 vps2 kernel: [18874164.767802] ffff880115a49000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Oct 14 12:20:31 vps2 kernel: [18874164.770820] ffff880115a49010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Oct 14 12:20:31 vps2 kernel: [18874164.773848] ffff880115a49020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 12:20:31 vps2 kernel: [18874164.776839] ffff880115a49030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 12:20:31 vps2 kernel: [18874164.779904] XFS (dm-2): metadata I/O error: block 0x24c17ba8 ("xfs_trans_read_buf_map") error 117 numblks 8

FS shutdown happened on Oct 13, but i don't have logs ...

Over night i upgraded kernel to debian kernel 3.16.36-1+deb8u1 , rebooted a ran xfs_repair. It repaired some metadata (sorry, don't have logs either :(

It seems it logged this problem over week, i didn't check, busy on different tasks ...
Oct 16 07:05:09 vps2 kernel: [103607.064314] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x46/0xd0 [xfs], block 0x12f63f40
Oct 16 07:05:09 vps2 kernel: [103607.067200] XFS (dm-2): Unmount and run xfs_repair
Oct 16 07:05:09 vps2 kernel: [103607.068510] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Oct 16 07:05:09 vps2 kernel: [103607.069554] ffff8801262e9000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Oct 16 07:05:09 vps2 kernel: [103607.070712] ffff8801262e9010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Oct 16 07:05:09 vps2 kernel: [103607.071971] ffff8801262e9020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 16 07:05:09 vps2 kernel: [103607.072990] ffff8801262e9030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 16 07:05:09 vps2 kernel: [103607.074329] XFS (dm-2): metadata I/O error: block 0x12f63f40 ("xfs_trans_read_buf_map") error 117 numblks 8

This night, FS shutdown occured again, with slightly different log
Oct 21 01:00:06 vps2 kernel: [514098.568389] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs], block 0x12f4ca30
Oct 21 01:00:06 vps2 kernel: [514098.570073] XFS (dm-2): Unmount and run xfs_repair
Oct 21 01:00:06 vps2 kernel: [514098.571014] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Oct 21 01:00:06 vps2 kernel: [514098.571800] ffff88020e8b0000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Oct 21 01:00:06 vps2 kernel: [514098.572408] ffff88020e8b0010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Oct 21 01:00:06 vps2 kernel: [514098.573167] ffff88020e8b0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 21 01:00:06 vps2 kernel: [514098.573779] ffff88020e8b0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 21 01:00:06 vps2 kernel: [514098.574347] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1337 of file /build/linux-EZT6bx/linux-3.16.36/fs/xfs/xfs_buf.c.  Return address = 0xffffffffa03eac00
Oct 21 01:00:06 vps2 kernel: [514098.574447] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
Oct 21 01:00:06 vps2 kernel: [514098.575000] XFS (dm-2): Please umount the filesystem and rectify the problem(s)
Oct 21 01:00:06 vps2 kernel: [514098.627574] XFS (dm-2): xfs_log_force: error 5 returned.
Oct 21 01:00:06 vps2 kernel: [514098.680405] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x46/0xd0 [xfs], block 0x12f4ca30
Oct 21 01:00:06 vps2 kernel: [514098.681555] XFS (dm-2): Unmount and run xfs_repair
Oct 21 01:00:06 vps2 kernel: [514098.682143] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Oct 21 01:00:06 vps2 kernel: [514098.682726] ffff88020e8b0000: 3c 3f 70 68 70 20 2f 2a 25 25 53 6d 61 72 74 79  <?php /*%%Smarty
Oct 21 01:00:06 vps2 kernel: [514098.683315] ffff88020e8b0010: 48 65 61 64 65 72 43 6f 64 65 3a 31 30 30 37 36  HeaderCode:10076
Oct 21 01:00:06 vps2 kernel: [514098.683930] ffff88020e8b0020: 34 36 39 39 35 35 38 30 39 33 30 37 65 30 36 33  469955809307e063
Oct 21 01:00:06 vps2 kernel: [514098.684501] ffff88020e8b0030: 37 63 30 2d 33 32 38 39 34 32 38 31 25 25 2a 2f  7c0-32894281%%*/
Oct 21 01:00:06 vps2 kernel: [514098.685064] XFS (dm-2): metadata I/O error: block 0x12f4ca30 ("xfs_trans_read_buf_map") error 117 numblks 8
Oct 21 01:00:06 vps2 kernel: [514098.745473] XFS (dm-2): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.

Is there some way to stop this? Maybe upgrading to kernel 4.7 from backports?
Is there a way to map those "block 0x12f4ca30" , "block 0x24c17ba8" to a specific file?


We have another virtual running in almost same configuration, but on different HW (dell r710) in same VM cluster.
It have had similar problems with in memory data corruption several times a year, but without logging any problems in between.
It had several 3.16 kernel versions (i always update to latest package when this happens)
Log is similar
Oct 11 14:18:01 vps1 kernel: [6376491.318342] XFS (dm-3): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs], block 0x4b060
Oct 11 14:18:01 vps1 kernel: [6376491.320972] XFS (dm-3): Unmount and run xfs_repair
Oct 11 14:18:01 vps1 kernel: [6376491.321165] XFS (dm-3): First 64 bytes of corrupted metadata buffer:
Oct 11 14:18:01 vps1 kernel: [6376491.321437] ffff88000e97a000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Oct 11 14:18:01 vps1 kernel: [6376491.321726] ffff88000e97a010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Oct 11 14:18:01 vps1 kernel: [6376491.322023] ffff88000e97a020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 11 14:18:01 vps1 kernel: [6376491.322314] ffff88000e97a030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 11 14:18:01 vps1 kernel: [6376491.322630] XFS (dm-3): xfs_do_force_shutdown(0x8) called from line 1337 of file /build/linux-7z1rSb/linux-3.16.7-ckt25/fs/xfs/xfs_buf.c.  Return address = 0xffffffffa03a3820
Oct 11 14:18:01 vps1 kernel: [6376491.323832] XFS (dm-3): Corruption of in-memory data detected.  Shutting down filesystem
Oct 11 14:18:01 vps1 kernel: [6376491.324157] XFS (dm-3): Please umount the filesystem and rectify the problem(s)
Oct 11 14:18:16 vps1 kernel: [6376506.023406] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:18:46 vps1 kernel: [6376536.132491] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:19:16 vps1 kernel: [6376566.241488] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:19:46 vps1 kernel: [6376596.350546] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:20:16 vps1 kernel: [6376626.459602] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:20:47 vps1 kernel: [6376656.568708] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:21:17 vps1 kernel: [6376686.677853] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:21:20 vps1 kernel: [6376689.870237] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:21:22 vps1 kernel: [6376692.358466] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:21:25 vps1 kernel: [6376694.871370] XFS (dm-3): xfs_log_force: error 5 returned.
Oct 11 14:21:31 vps1 kernel: [6376700.985227] XFS (dm-3): Mounting V4 Filesystem
Oct 11 14:21:31 vps1 kernel: [6376701.052522] XFS (dm-3): Starting recovery (logdev: internal)
Oct 11 14:21:31 vps1 kernel: [6376701.091589] XFS (dm-3): Ending recovery (logdev: internal)


Any clues what might be wrong? HW problem? but it doesn't affect other hosts, we use XFS on all of them for data.

With regards,

Libor
