Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALI6MNi013677 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 12:06:22 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7B441D23D5C
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 10:06:21 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	sI2iHQinLwYOj9ej for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 10:06:21 -0800 (PST)
Received: by iaen33 with SMTP id n33so8919931iae.26
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 10:06:21 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 10:06:20 -0800
Message-ID: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
Subject: EFSCORRUPTED on mount?
From: Gregory Farnum <gregory.farnum@dreamhost.com>
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

While working with a Ceph node running XFS we somehow managed to
corrupt our filesystem. I don't think there were any hard powercycles
on this node, but while starting up after a kernel upgrade (it's
running 3.1) the daemon was performing its usual startup sequence (a
lot of file truncates, mostly) when it got an error out of the
filesystem:

2011-11-17 16:00:37.294876 7f83f3eef720 filestore(/mnt/osd.17)
truncate meta/pginfo_12.7c8/0 size 0
2011-11-17 16:00:37.483407 7f83f3eef720 filestore(/mnt/osd.17)
truncate meta/pginfo_12.7c8/0 size 0 = -117
2011-11-17 16:00:37.483476 7f83f3eef720 filestore(/mnt/osd.17)  error
error 117: Structure needs cleaning not handled

When I tried to look at the filesystem, it failed with EIO. When I
tried to mount the filesystem after a remount, it gave me an internal
error:

root@cephstore6358:~# mount /dev/sdg1 /mnt/osd.17
2011 Nov 18 14:52:47 cephstore6358 [82374.729383] XFS: Internal error
XFS_WANT_CORRUPTED_GOTO at line 1664 of file fs/xfs/xfs_alloc.c.
Caller 0xffffffff811d6b71
2011 Nov 18 14:52:47 cephstore6358 [82374.729386]
2011 Nov 18 14:52:47 cephstore6358 [82374.758262] XFS (sdg1): Internal
error xfs_trans_cancel at line 1928 of file fs/xfs/xfs_trans.c.
Caller 0xffffffff811fa463
2011 Nov 18 14:52:47 cephstore6358 [82374.758265]
2011 Nov 18 14:52:47 cephstore6358 [82374.758352] XFS (sdg1):
Corruption of in-memory data detected.  Shutting down filesystem
2011 Nov 18 14:52:47 cephstore6358 [82374.758356] XFS (sdg1): Please
umount the filesystem and rectify the problem(s)
2011 Nov 18 14:52:47 cephstore6358 [82374.758364] XFS (sdg1): Failed
to recover EFIs
mount: Structure needs cleaning

dmesg had a little more output:

dmesg says:
[82373.779312] XFS (sdg1): Mounting Filesystem
[82373.930531] XFS (sdg1): Starting recovery (logdev: internal)
[82374.729383] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line
1664 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff811d6b71
[82374.729386]
[82374.741959] Pid: 30648, comm: mount Not tainted
3.1.0-dho-00004-g1ffcb5c-dirty #1
[82374.749543] Call Trace:
[82374.751994]  [<ffffffff811d606e>] ? xfs_free_ag_extent+0x4e3/0x698
[82374.758157]  [<ffffffff811ce1f8>] ? xfs_setup_devices+0x84/0x84
[82374.758163]  [<ffffffff811ce1f8>] ? xfs_setup_devices+0x84/0x84
[82374.758167]  [<ffffffff811d6b71>] ? xfs_free_extent+0xb6/0xf9
[82374.758171]  [<ffffffff811d3034>] ? kmem_zone_alloc+0x58/0x9e
[82374.758179]  [<ffffffff812095f9>] ? xfs_trans_get_efd+0x21/0x2a
[82374.758185]  [<ffffffff811fa413>] ? xlog_recover_process_efi+0x113/0x172
[82374.758190]  [<ffffffff811fa54b>] ? xlog_recover_process_efis+0x4e/0x8e
[82374.758194]  [<ffffffff811faa53>] ? xlog_recover_finish+0x14/0x88
[82374.758199]  [<ffffffff8120088e>] ? xfs_mountfs+0x46c/0x56a
[82374.758204]  [<ffffffff811ce365>] ? xfs_fs_fill_super+0x16d/0x244
[82374.758213]  [<ffffffff810d5dcf>] ? mount_bdev+0x13d/0x198
[82374.758218]  [<ffffffff810d4a42>] ? mount_fs+0xc/0xa6
[82374.758225]  [<ffffffff810eb274>] ? vfs_kern_mount+0x61/0x97
[82374.758230]  [<ffffffff810eb316>] ? do_kern_mount+0x49/0xd6
[82374.758234]  [<ffffffff810eba99>] ? do_mount+0x6f6/0x75d
[82374.758241]  [<ffffffff810b4429>] ? memdup_user+0x3a/0x56
[82374.758246]  [<ffffffff810ebb88>] ? sys_mount+0x88/0xc4
[82374.758254]  [<ffffffff8166c07b>] ? system_call_fastpath+0x16/0x1b
[82374.758262] XFS (sdg1): Internal error xfs_trans_cancel at line
1928 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811fa463

[82374.758265]
[82374.758268] Pid: 30648, comm: mount Not tainted
3.1.0-dho-00004-g1ffcb5c-dirty #1
[82374.758270] Call Trace:
[82374.758275]  [<ffffffff81201ecd>] ? xfs_trans_cancel+0x56/0xcf
[82374.758279]  [<ffffffff811fa463>] ? xlog_recover_process_efi+0x163/0x172
[82374.758284]  [<ffffffff811fa54b>] ? xlog_recover_process_efis+0x4e/0x8e
[82374.758288]  [<ffffffff811faa53>] ? xlog_recover_finish+0x14/0x88
[82374.758293]  [<ffffffff8120088e>] ? xfs_mountfs+0x46c/0x56a
[82374.758298]  [<ffffffff811ce365>] ? xfs_fs_fill_super+0x16d/0x244
[82374.758303]  [<ffffffff810d5dcf>] ? mount_bdev+0x13d/0x198
[82374.758307]  [<ffffffff810d4a42>] ? mount_fs+0xc/0xa6
[82374.758312]  [<ffffffff810eb274>] ? vfs_kern_mount+0x61/0x97
[82374.758317]  [<ffffffff810eb316>] ? do_kern_mount+0x49/0xd6
[82374.758321]  [<ffffffff810eba99>] ? do_mount+0x6f6/0x75d
[82374.758325]  [<ffffffff810b4429>] ? memdup_user+0x3a/0x56
[82374.758330]  [<ffffffff810ebb88>] ? sys_mount+0x88/0xc4
[82374.758335]  [<ffffffff8166c07b>] ? system_call_fastpath+0x16/0x1b
[82374.758341] XFS (sdg1): xfs_do_force_shutdown(0x8) called from line
1929 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff81201ee6
[82374.758352] XFS (sdg1): Corruption of in-memory data detected.
Shutting down filesystem
[82374.758356] XFS (sdg1): Please umount the filesystem and rectify
the problem(s)
[82374.758364] XFS (sdg1): Failed to recover EFIs
[82374.758367] XFS (sdg1): log mount finish failed

xfs_check doesn't give me much either, since I assume the errors above
are involved in log replay:
root@cephstore6358:~# xfs_check -v /dev/sdg1
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

Is there something useful I can do about this? Data I can provide to
help track down what broke?
-Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
