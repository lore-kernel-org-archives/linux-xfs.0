Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6MFQqTI251824 for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 10:26:54 -0500
Received: from mail.reagi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1CFA10AC220
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 08:35:47 -0700 (PDT)
Received: from mail.reagi.com (mail.reagi.com [195.60.188.80]) by cuda.sgi.com
	with ESMTP id 9Hj7CuwAvnCq9pHu for <xfs@oss.sgi.com>;
	Wed, 22 Jul 2009 08:35:47 -0700 (PDT)
From: "Gabriel Barazer" <gabriel@oxeva.fr>
Subject: XFS filesystem shutting down on linux 2.6.28.9 (xfs_rename)
Date: Wed, 22 Jul 2009 17:27:21 +0200
Message-ID: <000c01ca0ae0$e85420a0$b8fc61e0$@fr>
MIME-Version: 1.0
Content-Language: en-us
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
To: xfs@oss.sgi.com

Hi,

I recently put a NFS file server into production, with mostly XFS volumes on LVM. The server was quite low on traffic until this morning and one of the filesystems crashed twice since this morning with the following backtrace:

Filesystem "dm-24": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811b09a7
Pid: 2053, comm: nfsd Not tainted 2.6.28.9-filer #1
Call Trace:
 [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
 [<ffffffff811b1806>] xfs_trans_cancel+0x56/0xed
 [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
 [<ffffffff811bfad1>] xfs_vn_rename+0x5e/0x65
 [<ffffffff8108a1de>] vfs_rename+0x1fb/0x2fb
 [<ffffffff8113acc2>] nfsd_rename+0x299/0x349
 [<ffffffff813e4eb1>] sunrpc_cache_lookup+0x4a/0x109
 [<ffffffff811416a9>] nfsd3_proc_rename+0xdb/0xea
 [<ffffffff811436ab>] decode_filename+0x16/0x45
 [<ffffffff81136eb9>] nfsd_dispatch+0xdf/0x1b5
 [<ffffffff813dd6f0>] svc_process+0x3f7/0x610
 [<ffffffff81137444>] nfsd+0x12e/0x185
 [<ffffffff81137316>] nfsd+0x0/0x185
 [<ffffffff810442e7>] kthread+0x47/0x71
 [<ffffffff8102e622>] schedule_tail+0x24/0x5c
 [<ffffffff8100cdb9>] child_rip+0xa/0x11
 [<ffffffff81011e0c>] read_tsc+0x0/0x19
 [<ffffffff810442a0>] kthread+0x0/0x71	
 [<ffffffff8100cdaf>] child_rip+0x0/0x11
xfs_force_shutdown(dm-24,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff811b181f
Filesystem "dm-24": Corruption of in-memory data detected.  Shutting down filesystem: dm-24

The two crashed are related to the same function: xfs_rename.

I _really_ cannot upgrade to 2.6.29 or later because of the "reconnect_path: npd != pd" bug and the maybe related radix-tree bug ( http://bugzilla.kernel.org/show_bug.cgi?id=13375 ) affecting all kernel version afeter 2.6.28.

Unmounting then remounting the filesystem allow to access the mountpoint again without any error message or apparent file corruption.
This filesystem is used by ~30 NFS clients and contains about 5M files (100GB).

Before using the volume over NFS, there was only local activity (rsync syncing) and we didn't get any error.

I expect to see this crash again in a few hours except if the volume is really corrupted. Does a full filesystem copy to a newly created volume would have a chance to solve the problem?

Thanks,

Gabriel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
