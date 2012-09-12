Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8CIWjJr033237 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 13:32:45 -0500
Date: Wed, 12 Sep 2012 13:33:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: xfs: stop the sync worker before xfs_unmountfs
Message-ID: <20120912183347.GO3274@sgi.com>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com> <20120830223504.GE15292@dastard>
	<5040FF25.1010501@sgi.com> <20120901230824.GB6896@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120901230824.GB6896@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

See what you think of this.  Not heavily tested yet, and not pretty... but it
is fairly minimal. 

Pull startup and shutdown of the sync worker out of xfs_syncd_init and
xfs_syncd_stop into their callers.  In the case of unmount, move shutdown of
the xfs_sync_worker before teardown of the log in xfs_unmountfs.  This prevents
occasional crashes on unmount like so:

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

Signed-off-by: Ben Myers <bpm@sgi.com>

Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c
+++ xfs/fs/xfs/xfs_super.c
@@ -919,6 +919,7 @@ xfs_fs_put_super(
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_filestream_unmount(mp);
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_unmountfs(mp);
 	xfs_syncd_stop(mp);
 	xfs_freesb(mp);
@@ -1210,6 +1211,9 @@ xfs_finish_flags(
 	return 0;
 }
 
+extern void xfs_sync_worker(struct work_struct *);
+extern void xfs_syncd_queue_sync(struct xfs_mount *);
+
 STATIC int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1291,6 +1295,8 @@ xfs_fs_fill_super(
 	set_posix_acl_flag(sb);
 
 	error = xfs_syncd_init(mp);
+	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
+	xfs_syncd_queue_sync(mp);
 	if (error)
 		goto out_filestream_unmount;
 
@@ -1315,6 +1321,7 @@ xfs_fs_fill_super(
 
 	return 0;
  out_syncd_stop:
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_syncd_stop(mp);
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
@@ -1335,6 +1342,7 @@ out_destroy_workqueues:
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_syncd_stop(mp);
 	goto out_free_sb;
 }
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c
+++ xfs/fs/xfs/xfs_sync.c
@@ -370,7 +370,7 @@ xfs_quiesce_attr(
 	xfs_buf_unlock(mp->m_sb_bp);
 }
 
-static void
+void
 xfs_syncd_queue_sync(
 	struct xfs_mount        *mp)
 {
@@ -383,7 +383,7 @@ xfs_syncd_queue_sync(
  * disk quotas.  We might need to cover the log to indicate that the
  * filesystem is idle and not frozen.
  */
-STATIC void
+void
 xfs_sync_worker(
 	struct work_struct *work)
 {
@@ -494,11 +494,8 @@ xfs_syncd_init(
 	struct xfs_mount	*mp)
 {
 	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
-	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
-	xfs_syncd_queue_sync(mp);
-
 	return 0;
 }
 
@@ -506,7 +503,6 @@ void
 xfs_syncd_stop(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_sync_work);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	cancel_work_sync(&mp->m_flush_work);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
