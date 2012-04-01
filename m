Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q314vpPW069370 for <xfs@oss.sgi.com>; Sat, 31 Mar 2012 23:57:51 -0500
Message-ID: <4F77DFDB.1040802@oracle.com>
Date: Sun, 01 Apr 2012 12:55:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't fill statvfs with project quota for a directory
	if it was not enabled.
Reply-To: jeff.liu@oracle.com
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
Cc: Ben Myers <bpm@sgi.com>

Hello,

I can trigger a BUG() at fs/xfs/xfs_dquot.c on vanilla kernel 3.3.0 by the following steps:

1. mount a XFS partition without 'pquota' option.
   /dev/sda7 on /xfs type xfs (rw)

2. setup project1 on it.
   $ cat /etc/projects 
   1:/xfs
   $ cat /etc/projid
   project1:1
   $ sudo xfs_quota -x -c 'project -s project1' /xfs

3. du -sh /xfs

[  170.024496] XFS: Assertion failed: XFS_IS_QUOTA_RUNNING(mp), file: fs/xfs/xfs_dquot.c, line: 680
[  170.024534] ------------[ cut here ]------------
[  170.024630] kernel BUG at fs/xfs/xfs_message.c:101!
[  170.024718] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  170.024836] Modules linked in: xfs cryptd aes_i586 aes_generic ....
[  170.026787] Pid: 2082, comm: du Not tainted 3.3.0-dirty #48 LENOVO 7661D43/7661D43
[  170.026950] EIP: 0060:[<f94892c4>] EFLAGS: 00010246 CPU: 1
[  170.027126] EIP is at assfail+0x47/0x57 [xfs]
[  170.027207] EAX: 0000006a EBX: e2031f58 ECX: 00000000 EDX: 00000007
[  170.027319] ESI: 00000000 EDI: e364f000 EBP: e2031e88 ESP: e2031e74
[  170.027432]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  170.027530] Process du (pid: 2082, ti=e2030000 task=e3096a80 task.ti=e2030000)
[  170.027659] Stack:
[  170.027702]  00000000 f9543fbb f95523d2 f955210c 000002a8 e2031ec0 f9521d2c 3432302e
[  170.027912]  5d303834 00000020 e364f0dc 00000001 c13abe66 00000246 e2031eb4 00000246
[  170.028015]  e2031f58 e2031f58 e2b01880 e2031edc f9527edc 00000002 00000000 e2031ed4
[  170.028015] Call Trace:
[  170.028015]  [<f9521d2c>] xfs_qm_dqget+0x4e/0x90d [xfs]
[  170.028015]  [<c13abe66>] ? do_raw_spin_lock+0xdc/0x1fd
[  170.028015]  [<f9527edc>] xfs_qm_statvfs+0x4e/0xa5 [xfs]
[  170.028015]  [<f948a666>] xfs_fs_statfs+0x2b0/0x2c8 [xfs]
[  170.028015]  [<c1263c8b>] statfs_by_dentry+0x82/0xc1
[  170.028015]  [<c1263cee>] vfs_statfs+0x24/0x12a
[  170.028015]  [<c1263ed8>] fd_statfs+0x55/0x81
[  170.028015]  [<c126407b>] sys_fstatfs64+0x3f/0x7a
[  170.028015]  [<c183071c>] syscall_call+0x7/0xb
[  170.028015] Code: 10 89 54 24 0c 89 44 24 08 c7 44 24 04 bb 3f 54 f9 c7 04 24 00 ...
[  170.028015] EIP: [<f94892c4>] assfail+0x47/0x57 [xfs] SS:ESP 0068:e2031e74
[  170.083305] ---[ end trace 76dc24be29466355 ]---

IMHO, we can check if the project quota is running or not before performing xfs_qm_statvfs(), just return if not.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_super.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee5b695..dfc3666 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1059,10 +1059,15 @@ xfs_fs_statfs(
 
 	spin_unlock(&mp->m_sb_lock);
 
-	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
-	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
-			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
-		xfs_qm_statvfs(ip, statp);
+	/* don't try to fill statvfs with project quota if it's not running */
+	if (XFS_IS_PQUOTA_RUNNING(mp)) {
+		if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
+		    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
+		     (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD)) {
+			xfs_qm_statvfs(ip, statp);
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
