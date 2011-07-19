Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J9Kp5h163303 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 04:20:51 -0500
Received: from sour.ops.eusc.inter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5F61150C7E1
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 02:20:49 -0700 (PDT)
Received: from sour.ops.eusc.inter.net (sour.ops.eusc.inter.net
	[84.23.254.154]) by cuda.sgi.com with ESMTP id n4oYW3OkRhJ6OsWC
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 02:20:49 -0700 (PDT)
Received: from sour.ops.eusc.inter.net ([10.154.10.22] helo=localhost)
	by sour.ops.eusc.inter.net with esmtpsa (Exim 4.72)
	id 1Qj6Tv-0006GR-Ak
	for xfs@oss.sgi.com; Tue, 19 Jul 2011 11:20:47 +0200
Message-ID: <4E254C6E.4090408@koeln.de>
Date: Tue, 19 Jul 2011 11:20:46 +0200
From: Markus Uckelmann <markus.uckelmann@koeln.de>
MIME-Version: 1.0
Subject: Corruption of in-memory data detected. Shutting down filesystem
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

Hi all,

Occasionally I get the above error on one of our backup volumes. The
volume is a LVM-volume which resides inside a crypted partition. We have
three backup volumes, but only one has the problem. On this volume we
backup tons of Subversion working copies, so that mostly very small
files are on this volume. The error only appears when our backup via
rdiff-backup is running.

I currently work around this problem by unmounting the volume and
mounting it again. I would appreciate your help. Let me know, if you
need any further information.

Some details

kern.log
> Jul 13 02:24:29 backupserver kernel: [679408.490589] Filesystem "dm-4": XFS internal error xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c. Caller 0xffffffffa0212709
> Jul 13 02:24:29 backupserver kernel: [679408.564416] Pid: 18658, comm: rdiff-backup Not tainted 2.6.26-2-amd64 0000001
> Jul 13 02:24:29 backupserver kernel: [679408.605393]
> Jul 13 02:24:29 backupserver kernel: [679408.605394] Call Trace:
> Jul 13 02:24:29 backupserver kernel: [679408.639377] [<ffffffffa0212709>] :xfs:xfs_create+0x3ea/0x477
> Jul 13 02:24:29 backupserver kernel: [679408.674393] [<ffffffffa020ca4e>] :xfs:xfs_trans_cancel+0x55/0xed
> Jul 13 02:24:29 backupserver kernel: [679408.711940] [<ffffffffa0212709>] :xfs:xfs_create+0x3ea/0x477
> Jul 13 02:24:29 backupserver kernel: [679408.758863] [<ffffffffa01d60ca>] :xfs:xfs_attr_get+0x8d/0x9e
> Jul 13 02:24:29 backupserver kernel: [679408.794026] [<ffffffffa021b7b7>] :xfs:xfs_vn_mknod+0x159/0x247
> Jul 13 02:24:29 backupserver kernel: [679408.830013] [<ffffffff802a2cbd>] vfs_create+0xcf/0x140
> Jul 13 02:24:29 backupserver kernel: [679408.862025] [<ffffffff802a587a>] do_filp_open+0x1e3/0x7c4
> Jul 13 02:24:29 backupserver kernel: [679408.895520] [<ffffffff802999a2>] do_sys_open+0x46/0xc3
> Jul 13 02:24:29 backupserver kernel: [679408.928542] [<ffffffff8020beda>] system_call_after_swapgs+0x8a/0x8f
> Jul 13 02:24:29 backupserver kernel: [679408.967513]
> Jul 13 02:24:29 backupserver kernel: [679408.978394] xfs_force_shutdown(dm-4,0x8) called from line 1164 of file fs/xfs/xfs_trans.c. Return address = 0xffffffffa020ca67
> Jul 13 02:24:30 backupserver kernel: [679409.051147] Filesystem "dm-4": Corruption of in-memory data detected. Shutting down filesystem: dm-4
> Jul 13 02:24:30 backupserver kernel: [679409.106937] Please umount the filesystem, and rectify the problem(s)
> Jul 13 02:24:33 backupserver kernel: [679412.440595] Filesystem "dm-4": xfs_log_force: error 5 returned.
> Jul 13 02:24:54 backupserver kernel: [679433.470623] Filesystem "dm-4": xfs_log_force: error 5 returned.
> [...]
> Jul 13 09:53:48 backupserver kernel: [707379.613578] Filesystem "dm-4": xfs_log_force: error 5 returned.
> Jul 13 09:53:48 backupserver kernel: [707379.673603] xfs_force_shutdown(dm-4,0x1) called from line 420 of file fs/xfs/xfs_rw.c. Return address = 0xffffffffa0214e2a
> Jul 13 09:54:10 backupserver kernel: [707401.740318] Filesystem "dm-4": xfs_log_force: error 5 returned.
> [...]
> Jul 13 10:03:19 backupserver kernel: [707957.520753] Filesystem "dm-4": xfs_log_force: error 5 returned.
> Jul 13 10:03:36 backupserver kernel: [707974.761993] Filesystem "dm-4": Disabling barriers, not supported by the underlying device
> Jul 13 10:03:36 backupserver kernel: [707974.857711] XFS mounting filesystem dm-4
> Jul 13 10:03:36 backupserver kernel: [707975.126237] Starting XFS recovery on filesystem: dm-4 (logdev: internal)
> Jul 13 10:03:50 backupserver kernel: [707991.756505] Ending XFS recovery on filesystem: dm-4 (logdev: internal)


Kernel-version is 2.6.26-2-amd64 and the OS is a Debian Lenny. The
system is up to date and I made sure that the hardware is running fine.


Thanks and regards,

	Markus Uckelmann

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
