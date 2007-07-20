Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 20:21:26 -0700 (PDT)
Received: from mta14.adelphia.net (mta14.mail.adelphia.net [68.168.78.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K3LKbm016351
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 20:21:23 -0700
Received: from [192.168.1.5] (really [75.81.191.152]) by mta10.adelphia.net
          (InterMail vM.6.01.05.02 201-2131-123-102-20050715) with ESMTP
          id <20070720030000.BXMF22229.mta10.adelphia.net@[192.168.1.5]>
          for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 03:00:00 +0000
Message-ID: <46A02551.8040409@adelphia.net>
Date: Thu, 19 Jul 2007 20:00:33 -0700
From: Michael Morrison <mliam@adelphia.net>
MIME-Version: 1.0
Subject: XFS internal error when making hard link on full fs.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Got the following when I tried to make a hard link on a full filesystem:
I'm running Linux kernel 2.6.18.  I'm  unable to try a newer kernel at
the present time.
The application was properly given ENOSPC in errno when the link call
failed.

The filesystem is built on a linux software raid0 with 8 drives using
the following command lines:

/sbin/mdadm --create /dev/md0 --level=0 \
    --chunk=64   \
    --raid-devices=8  \
    /dev/sda /dev/sde \
    /dev/sdb /dev/sdf \
    /dev/sdc /dev/sdg \
    /dev/sdd /dev/sdh

/sbin/mkfs -t xfs -f -d unwritten=0 -l version=2,sunit=128,internal 
/dev/md0
/bin/mount -t xfs /dev/md0 /mnt/dmag -o noatime,nodiratime,logbufs=4

Filesystem "md0": XFS internal error xfs_trans_cancel at line 1138 of
file fs/xfs/xfs_trans.c.  Caller 0xc02d53a5
 [<c02cb987>] xfs_trans_cancel+0x108/0x14f
 [<c02d53a5>] xfs_link+0x40f/0x585
 [<c02d53a5>] xfs_link+0x40f/0x585
 [<c04937ab>] _spin_unlock+0xd/0x21
 [<c02e19d5>] xfs_vn_link+0x64/0xd3
 [<c0181b66>] mntput_no_expire+0x1c/0x75
 [<c017de95>] __d_lookup+0x8f/0x13b
 [<c016e2b2>] vfs_stat+0x1f/0x23
 [<c0172788>] cached_lookup+0x23/0x85
 [<c01725de>] permission+0x85/0xaa
 [<c0175e24>] vfs_link+0xc7/0x183
 [<c0176008>] sys_linkat+0x128/0x14a
 [<c0176059>] sys_link+0x2f/0x33
 [<c0102ecd>] sysenter_past_esp+0x56/0x79
xfs_force_shutdown(md0,0x8) called from line 1139 of file
fs/xfs/xfs_trans.c.  Return address = 0xc02cb9ad
Filesystem "md0": Corruption of in-memory data detected.  Shutting down
filesystem: md0
Please umount the filesystem, and rectify the problem(s)


Unmounting the fs and running xfs_check did not produce any output.  The
filesystem seems happy after mounting it again.
