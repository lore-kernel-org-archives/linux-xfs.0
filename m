Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NehEp067715 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144311.307692292@sgi.com>
Date: Mon, 03 Dec 2012 17:42:35 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 27/36] xfs: protect xfs_sync_worker with s_umount
	semaphore
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=088
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Ben Myers <bpm@sgi.com>

Upstream commit: 1307bbd2af67283131728637e9489002adb26f10

xfs_sync_worker checks the MS_ACTIVE flag in s_flags to avoid doing
work during mount and unmount.  This flag can be cleared by unmount
after the xfs_sync_worker checks it but before the work is completed.
The has caused crashes in the completion handler for the dummy
transaction commited by xfs_sync_worker:

PID: 27544  TASK: ffff88013544e040  CPU: 3   COMMAND: "kworker/3:0"
 #0 [ffff88016fdff930] machine_kexec at ffffffff810244e9
 #1 [ffff88016fdff9a0] crash_kexec at ffffffff8108d053
 #2 [ffff88016fdffa70] oops_end at ffffffff813ad1b8
 #3 [ffff88016fdffaa0] no_context at ffffffff8102bd48
 #4 [ffff88016fdffaf0] __bad_area_nosemaphore at ffffffff8102c04d
 #5 [ffff88016fdffb40] bad_area_nosemaphore at ffffffff8102c12e
 #6 [ffff88016fdffb50] do_page_fault at ffffffff813afaee
 #7 [ffff88016fdffc60] page_fault at ffffffff813ac635
    [exception RIP: xlog_get_lowest_lsn+0x30]
    RIP: ffffffffa04a9910  RSP: ffff88016fdffd10  RFLAGS: 00010246
    RAX: ffffc90014e48000  RBX: ffff88014d879980  RCX: ffff88014d879980
    RDX: ffff8802214ee4c0  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff88016fdffd10   R8: ffff88014d879a80   R9: 0000000000000000
    R10: 0000000000000001  R11: 0000000000000000  R12: ffff8802214ee400
    R13: ffff88014d879980  R14: 0000000000000000  R15: ffff88022fd96605
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffff88016fdffd18] xlog_state_do_callback at ffffffffa04aa186 [xfs]
 #9 [ffff88016fdffd98] xlog_state_done_syncing at ffffffffa04aa568 [xfs]

Protect xfs_sync_worker by using the s_umount semaphore at the read
level to provide exclusion with unmount while work is progressing.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -506,21 +506,24 @@ xfs_sync_worker(
 	 * We shouldn't write/force the log if we are in the mount/unmount
 	 * process or on a read only filesystem. The workqueue still needs to be
 	 * active in both cases, however, because it is used for inode reclaim
-	 * during these times. hence use the MS_ACTIVE flag to avoid doing
-	 * anything in these periods.
+	 * during these times.  Use the s_umount semaphore to provide exclusion
+	 * with unmount.
 	 */
-	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		/* dgc: errors ignored here */
-		if (mp->m_super->s_frozen == SB_UNFROZEN &&
-		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp);
-		else
-			xfs_log_force(mp, 0);
-		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
+	if (down_read_trylock(&mp->m_super->s_umount)) {
+		if (!(mp->m_super->s_flags & MS_ACTIVE) &&
+		    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+			/* dgc: errors ignored here */
+			if (mp->m_super->s_frozen == SB_UNFROZEN &&
+			    xfs_log_need_covered(mp))
+				error = xfs_fs_log_dummy(mp);
+			else
+				xfs_log_force(mp, 0);
+			error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 
-		/* start pushing all the metadata that is currently dirty */
-		xfs_ail_push_all(mp->m_ail);
+			/* start pushing all the metadata that is currently dirty */
+			xfs_ail_push_all(mp->m_ail);
+		}
+		up_read(&mp->m_super->s_umount);
 	}
 
 	/* queue us up again */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
