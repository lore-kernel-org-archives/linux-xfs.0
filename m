Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5I6u2LB259289
	for <linux-xfs@oss.sgi.com>; Thu, 18 Jun 2009 01:56:03 -0500
Received: from mail.laber.fasel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 644DE1BD0C74
	for <linux-xfs@oss.sgi.com>; Wed, 17 Jun 2009 23:56:25 -0700 (PDT)
Received: from mail.laber.fasel.org (mail.laber.fasel.org [212.7.178.68]) by
	cuda.sgi.com with ESMTP id 4YnCKHupeqfVc1I8 for
	<linux-xfs@oss.sgi.com>; Wed, 17 Jun 2009 23:56:25 -0700 (PDT)
Date: Thu, 18 Jun 2009 08:56:21 +0200
From: Wolfram Schlich <lists@wolfram.schlich.org>
Subject: xfs_trans_read_buf error / xfs_force_shutdown with LVM snapshot
	and Xen kernel 2.6.18
Message-ID: <20090618065621.GD16867@bla.fasel.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi!

I'm currently using LVM snapshots to create full system backups
of a bunch of Xen-based virtual machines (so-called domUs).
Those domUs all run Xen kernel 2.6.18 from the Xen 3.2.0 release
(32bit domU on 32bit dom0, I can post the .config if needed).
All domUs are using XFS on their LVM logical volumes.
The backup of all mounted snapshot volumes is made using
rsnapshot/rsync. This has been running smoothly for some
weeks now on 5 domUs.

Yesterday this happened during the backup on 1 domU:
--8<--
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x604d68       ("xfs_trans_read_buf") error 5 buf count 4096
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x66c5a0       ("xfs_trans_read_buf") error 5 buf count 4096
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x202f70       ("xfs_trans_read_buf") error 5 buf count 4096
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x2701f8       ("xfs_trans_read_buf") error 5 buf count 4096
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x6a78       ("xfs_trans_read_buf") error 5 buf count 4096
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x600500       ("xfs_trans_read_buf") error 5 buf count 8192
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x600520       ("xfs_trans_read_buf") error 5 buf count 8192
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x600520       ("xfs_trans_read_buf") error 5 buf count 8192
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0xdd0       ("xfs_trans_read_buf") error 5 buf count 8192
kernel: I/O error in filesystem ("dm-21") meta-data dev dm-21 block 0x4055d0       ("xfs_trans_read_buf") error 5 buf count 8192
[...many more of such messages...]
kernel: xfs_force_shutdown(dm-21,0x1) called from line 424 of file fs/xfs/xfs_rw.c.  Return address = 0xc02b1cbb
kernel: Filesystem "dm-21": I/O Error Detected.  Shutting down filesystem: dm-21
kernel: Please umount the filesystem, and rectify the problem(s)
kernel: xfs_force_shutdown(dm-21,0x1) called from line 424 of file fs/xfs/xfs_rw.c.  Return address = 0xc02b1cbb
--8<--
The rsync process was then terminated with SIGBUS (exit code 135 -> 128+7).

The device dm-21 was the snapshot of the /var filesystem and
was mounted using nouuid,norecovery.

Is it possible that the LVM snapshot (that should be using
xfs_freeze/xfs_unfreeze) has created an inconsistent/damaged
snapshot that was kept from being repaired through norecovery?
Any other ideas?
-- 
Regards,
Wolfram Schlich <wschlich@gentoo.org>
Gentoo Linux * http://dev.gentoo.org/~wschlich/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
