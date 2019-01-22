Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51450 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728601AbfAVPgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 10:36:05 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0CEA728515
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 15:36:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 15:36:04 +0000
Message-ID: <bug-202127-201763-FamnOFtBs7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #26 from daimh@umich.edu ---
mount -o noalign or mount -o sunit=,swidth doesn't work. Here is the commands.

########old kernel
[root@watsons-s1 ~]# uname -a
Linux watsons-s1.mbni.org 4.17.14-arch1-1-ARCH #1 SMP PREEMPT Thu Aug 9
11:56:50 UTC 2018 x86_64 GNU/Linux
[root@watsons-s1 ~]# mkfs.xfs -V
mkfs.xfs version 4.17.0
[root@watsons-s1 ~]# mkfs.xfs -f /dev/sda
meta-data=/dev/sda               isize=512    agcount=557, agsize=268434944
blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=149409103872, imaxpct=1
         =                       sunit=256    swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


############new kernel
[root@watsons-s1 ~]# uname -a
Linux watsons-s1.mbni.org 4.20.3-arch1-1-ARCH #1 SMP PREEMPT Wed Jan 16
22:38:58 UTC 2019 x86_64 GNU/Linux
[root@watsons-s1 ~]# mkfs.xfs -V
mkfs.xfs version 4.19.0
[root@watsons-s1 ~]# mount -t xfs -o noalign /dev/sda
/treehouse/watsons_lab/s1/
mount: /treehouse/watsons_lab/s1: mount(2) system call failed: Structure needs
cleaning.
[root@watsons-s1 ~]# dmesg
[  289.750470] XFS (sda): SB stripe unit sanity check failed
[  289.750564] XFS (sda): Metadata corruption detected at
xfs_sb_read_verify+0x106/0x180 [xfs], xfs_sb block 0xffffffffffffffff
[  289.752487] XFS (sda): Unmount and run xfs_repair
[  289.753980] XFS (sda): First 128 bytes of corrupted metadata buffer:
[  289.755393] 00000000: 58 46 53 42 00 00 10 00 00 00 00 22 c9 7a 00 00 
XFSB.......".z..
[  289.756787] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[  289.758168] 00000020: 85 3d da cd 25 7c 48 e3 a7 56 b2 4c 8c d2 d5 35 
.=..%|H..V.L...5
[  289.759551] 00000030: 00 00 00 11 60 00 00 08 00 00 00 00 00 00 08 00 
....`...........
[  289.760939] 00000040: 00 00 00 00 00 00 08 01 00 00 00 00 00 00 08 02 
................
[  289.762308] 00000050: 00 00 00 01 0f ff fe 00 00 00 02 2d 00 00 00 00 
...........-....
[  289.763670] 00000060: 00 07 f6 00 bd a5 10 00 02 00 00 08 00 00 00 00 
................
[  289.765016] 00000070: 00 00 00 00 00 00 00 00 0c 0c 09 03 1c 00 00 01 
................
[  289.766432] XFS (sda): SB validate failed with error -117.
[root@watsons-s1 ~]# mount -t xfs -o sunit=256,swidth=64 /dev/sda
/treehouse/watsons_lab/s1/
mount: /treehouse/watsons_lab/s1: wrong fs type, bad option, bad superblock on
/dev/sda, missing codepage or helper program, or other error.
[root@watsons-s1 ~]# dmesg
[  316.159473] XFS (sda): stripe width (64) must be a multiple of the stripe
unit (256)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
