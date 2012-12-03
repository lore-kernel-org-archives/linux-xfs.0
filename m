Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NeimO067742 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:44 -0600
Message-Id: <20121203144311.937872980@sgi.com>
Date: Mon, 03 Dec 2012 17:42:42 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 34/36] xfs: stop the sync worker before
	xfs_unmountfs
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=xfs-stop-sync-worker-before-umount.patch
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

Upstream commit: 0ba6e5368c302819da7aff537e0d7eff2616c6a6

    xfs: stop the sync worker before xfs_unmountfs

    
    Cancel work of the xfs_sync_worker before teardown of the log in
    xfs_unmountfs.  This prevents occasional crashes on unmount like so:
    
    PID: 21602  TASK: ee9df060  CPU: 0   COMMAND: "kworker/0:3"
     #0 [c5377d28] crash_kexec at c0292c94
     #1 [c5377d80] oops_end at c07090c2
     #2 [c5377d98] no_context at c06f614e
     #3 [c5377dbc] __bad_area_nosemaphore at c06f6281
     #4 [c5377df4] bad_area_nosemaphore at c06f629b
     #5 [c5377e00] do_page_fault at c070b0cb
     #6 [c5377e7c] error_code (via page_fault) at c070892c
        EAX: f300c6a8  EBX: f300c6a8  ECX: 000000c0  EDX: 000000c0  EBP: c5377ed0
        DS:  007b      ESI: 00000000  ES:  007b      EDI: 00000001  GS:  ffffad20
        CS:  0060      EIP: c0481ad0  ERR: ffffffff  EFLAGS: 00010246
     #7 [c5377eb0] atomic64_read_cx8 at c0481ad0
     #8 [c5377ebc] xlog_assign_tail_lsn_locked at f7cc7c6e [xfs]
     #9 [c5377ed4] xfs_trans_ail_delete_bulk at f7ccd520 [xfs]
    #10 [c5377f0c] xfs_buf_iodone at f7ccb602 [xfs]
    #11 [c5377f24] xfs_buf_do_callbacks at f7cca524 [xfs]
    #12 [c5377f30] xfs_buf_iodone_callbacks at f7cca5da [xfs]
    #13 [c5377f4c] xfs_buf_iodone_work at f7c718d0 [xfs]
    #14 [c5377f58] process_one_work at c024ee4c
    #15 [c5377f98] worker_thread at c024f43d
    #16 [c5377fbc] kthread at c025326b
    #17 [c5377fe8] kernel_thread_helper at c070e834
    
    PID: 26653  TASK: e79143b0  CPU: 3   COMMAND: "umount"
     #0 [cde0fda0] __schedule at c0706595
     #1 [cde0fe28] schedule at c0706b89
     #2 [cde0fe30] schedule_timeout at c0705600
     #3 [cde0fe94] __down_common at c0706098
     #4 [cde0fec8] __down at c0706122
     #5 [cde0fed0] down at c025936f
     #6 [cde0fee0] xfs_buf_lock at f7c7131d [xfs]
     #7 [cde0ff00] xfs_freesb at f7cc2236 [xfs]
     #8 [cde0ff10] xfs_fs_put_super at f7c80f21 [xfs]
     #9 [cde0ff1c] generic_shutdown_super at c0333d7a
    #10 [cde0ff38] kill_block_super at c0333e0f
    #11 [cde0ff48] deactivate_locked_super at c0334218
    #12 [cde0ff58] deactivate_super at c033495d
    #13 [cde0ff68] mntput_no_expire at c034bc13
    #14 [cde0ff7c] sys_umount at c034cc69
    #15 [cde0ffa0] sys_oldumount at c034ccd4
    #16 [cde0ffb0] system_call at c0707e66
    
    commit 11159a05 added this to xfs_log_unmount and needs to be cleaned up
    at a later date.
    
    Signed-off-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/linux-2.6/xfs_super.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1004,6 +1004,7 @@ xfs_fs_put_super(
 
 	XFS_bflush(mp->m_ddev_targp);
 
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_unmountfs(mp);
 	xfs_syncd_stop(mp);
 	xfs_freesb(mp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
