Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 05:00:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m31C072n001075
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 05:00:09 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 589EC126E470
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2008 05:00:42 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id 2UuA7V0r8wBjabRR for <xfs@oss.sgi.com>; Tue, 01 Apr 2008 05:00:42 -0700 (PDT)
Date: Tue, 1 Apr 2008 14:00:35 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Serious XFS crash
Message-ID: <20080401140035.46470306@galadriel.home>
In-Reply-To: <20080325233611.GW103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home>
	<20080325233611.GW103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Le Wed, 26 Mar 2008 10:36:11 +1100 vous écriviez:

> What sector size is being used for the XFS filesystem? If it's
> not the same as teh filesystem block size, then XFS can't have done
> this itself because the offset that this garbage starts at would
> not be block aligned.....

I've gone thru the logs. This machine had a serious XFS crash on march
6 due to bad blocks (failed drive in the RAID-5). Is it possible that
the March 19 XFS crash is related to this, i. e. after running
xfs_repair on march 6 it remained some on-disk garbage that provoked a
new crash a couple of weeks later?

Here is the march 6 crash :

Mar  6 10:42:46 system3 kernel:  [xfs_alloc_read_agf+244/432]
xfs_alloc_read_agf+0xf4/0x1b0 Mar  6 10:42:46 system3 kernel:
[xfs_alloc_fix_freelist+1000/1120] xfs_alloc_fix_freelist+0x3e8/0x460
Mar  6 10:42:46 system3 last message repeated 2 times Mar  6 10:42:46
system3 kernel:  [_xfs_trans_commit+489/928]
_xfs_trans_commit+0x1e9/0x3a0 Mar  6 10:42:46 system3 kernel:
[xfs_free_extent+152/224] xfs_free_extent+0x98/0xe0 Mar  6 10:42:46
system3 kernel:  [xfs_bmap_finish+263/400] xfs_bmap_finish+0x107/0x190
Mar  6 10:42:46 system3 kernel:  [xfs_itruncate_finish+544/976]
xfs_itruncate_finish+0x220/0x3d0 Mar  6 10:42:46 system3 kernel:
[xfs_trans_ijoin+43/128] xfs_trans_ijoin+0x2b/0x80 Mar  6 10:42:46
system3 kernel:  [xfs_inactive+1195/1296] xfs_inactive+0x4ab/0x510 Mar
6 10:42:46 system3 kernel:  [xfs_fs_clear_inode+156/192]
xfs_fs_clear_inode+0x9c/0xc0 Mar  6 10:42:46 system3 kernel:
[invalidate_inode_buffers+21/112] invalidate_inode_buffers+0x15/0x70
Mar  6 10:42:46 system3 kernel:  [clear_inode+212/320]
clear_inode+0xd4/0x140 Mar  6 10:42:46 system3 kernel:
[truncate_inode_pages+23/32] truncate_inode_pages+0x17/0x20 Mar  6
10:42:46 system3 kernel:  [generic_delete_inode+264/272]
generic_delete_inode+0x108/0x110 Mar  6 10:42:46 system3 kernel:
[iput+83/112] iput+0x53/0x70 Mar  6 10:42:46 system3 kernel:
[do_unlinkat+186/272] do_unlinkat+0xba/0x110 Mar  6 10:42:46 system3
kernel:  [sys_fcntl64+89/144] sys_fcntl64+0x59/0x90 Mar  6 10:42:46
system3 kernel:  [syscall_call+7/11] syscall_call+0x7/0xb Mar  6
10:42:46 system3 kernel: xfs_force_shutdown(md0,0x8) called from line
4267 of file fs/xfs/xfs_bmap.c.  Return address = 0xc0256b29 Mar  6
10:51:19 system3 kernel: 3w-9xxx: scsi0: AEN: WARNING (0x04:0x0023):
Sector repair completed:port=6, LBA=0xE6E00. Mar  6 10:51:20 system3
kernel: 3w-9xxx: scsi0: AEN: WARNING (0x04:0x0023): Sector repair
completed:port=6, LBA=0xE6DCA.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
