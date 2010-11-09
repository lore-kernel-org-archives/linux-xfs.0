Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9Ab6uN149336 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 04:37:06 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DADF1665B2
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 02:38:32 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id gtnLPEuu6M1lA2Xp
	for <xfs@oss.sgi.com>; Tue, 09 Nov 2010 02:38:32 -0800 (PST)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1PFlaw-0005XN-K7
	for xfs@oss.sgi.com; Tue, 09 Nov 2010 11:38:30 +0100
Message-ID: <4CD924A6.6040200@dermichi.com>
Date: Tue, 09 Nov 2010 11:38:30 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: vmap allocation for size 1048576 failed
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

Dear List!

On one of my machines i started getting errors like this after upgrading
from Kernel 2.6.35 to 2.6.36.
--- --- snip --- ---
Nov  9 11:25:57 xxxxx kernel: [591880.880679] vmap allocation for size
1048576 failed: use vmalloc=<size> to increase size.
... (repeats a few times, with differing sizes)
Nov  9 11:25:57 xxxxx kernel: [591880.881651] xfs_buf_get: failed to map
pages
... (repeats a few times)
Nov  9 11:25:57 xxxxx kernel: [591881.111625] Filesystem "loop0": XFS
internal error xfs_trans_cancel at line 1796 of file fs/xfs/xfs_trans.c.
 Caller 0xc0270288
Nov  9 11:25:57 xxxxx kernel: [591881.111629]
Nov  9 11:25:57 xxxxx kernel: [591881.111636] Pid: 24899, comm: rsync
Not tainted 2.6.36 #1
Nov  9 11:25:57 xxxxx kernel: [591881.111640] Call Trace:
Nov  9 11:25:57 xxxxx kernel: [591881.111653]  [<c0254756>]
xfs_error_report+0x2c/0x2e
Nov  9 11:25:57 xxxxx kernel: [591881.111663]  [<c026c691>]
xfs_trans_cancel+0x4b/0xc9
Nov  9 11:25:57 xxxxx kernel: [591881.111674]  [<c0270288>] ?
xfs_create+0x473/0x4ef
Nov  9 11:25:57 xxxxx kernel: [591881.111683]  [<c0270288>]
xfs_create+0x473/0x4ef
Nov  9 11:25:57 xxxxx kernel: [591881.111693]  [<c02791c7>]
xfs_vn_mknod+0xca/0x156
Nov  9 11:25:57 xxxxx kernel: [591881.111700]  [<c027926c>]
xfs_vn_create+0xa/0xc
Nov  9 11:25:57 xxxxx kernel: [591881.111709]  [<c01bcedd>]
vfs_create+0x85/0xcf
Nov  9 11:25:57 xxxxx kernel: [591881.111716]  [<c01bd56e>]
do_last+0x277/0x4f8
Nov  9 11:25:57 xxxxx kernel: [591881.111725]  [<c01bed11>]
do_filp_open+0x197/0x458
Nov  9 11:25:57 xxxxx kernel: [591881.111733]  [<c01bd0fb>] ?
getname+0x1b/0xb9
Nov  9 11:25:57 xxxxx kernel: [591881.111741]  [<c01b3766>]
do_sys_open+0x48/0xc9
Nov  9 11:25:57 xxxxx kernel: [591881.111746]  [<c01b3829>]
sys_open+0x1e/0x26
Nov  9 11:25:57 xxxxx kernel: [591881.111752]  [<c0102798>]
sysenter_do_call+0x12/0x28
Nov  9 11:25:57 xxxxx kernel: [591881.111759]
xfs_force_shutdown(loop0,0x8) called from line 1797 of file
fs/xfs/xfs_trans.c.  Return address = 0xc026c6a7
Nov  9 11:25:57 xxxxx kernel: [591881.214442] Filesystem "loop0":
Corruption of in-memory data detected.  Shutting down filesystem: loop0
Nov  9 11:25:57 xxxxx kernel: [591881.214449] Please umount the
filesystem, and rectify the problem(s)
Nov  9 11:26:11 xxxxx kernel: [591894.827022] Filesystem "loop0":
xfs_log_force: error 5 returned.
Nov  9 11:26:41 xxxxx kernel: [591924.827024] Filesystem "loop0":
xfs_log_force: error 5 returned.
Nov  9 11:27:11 xxxxx kernel: [591954.827023] Filesystem "loop0":
xfs_log_force: error 5 returned.
Nov  9 11:27:18 xxxxx kernel: [591961.412716]
xfs_force_shutdown(loop0,0x1) called from line 994 of file
fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc0275738
Nov  9 11:27:18 xxxxx kernel: [591961.660660] Filesystem "loop0":
xfs_log_force: error 5 returned.
--- --- snip --- ---

A few thoughts:
 * It always happens when i run "rsync" on the machine.
 * I've already tried setting vmalloc=256M and vmalloc=512M which both
delayed the problem but didn't cure it.
 * It's a 32-bit machine and the problem only occurs on a loop'ed XFS,
never on the root XFS.
 * I've used the experimental "delaylog" mount option, which may be
important.
 * I'm not sure if the problem is 100% related to the kernel upgrade
because i didn't use a loop XFS on this machine before the kernel upgrade.

Any ideas how to narrow down the problem?

tia,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
