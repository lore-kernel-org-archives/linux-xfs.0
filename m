Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7TEP56D019848 for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 09:25:05 -0500
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DB11AC003
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 07:25:55 -0700 (PDT)
Message-Id: <20120829134628.835024558@sgi.com>
Date: Wed, 29 Aug 2012 08:46:25 -0500
From: tinguely@sgi.com
Subject: [PATCH] xfs: flush workers before stopping log
References: <20120829134624.316257238@sgi.com>
Content-Disposition: inline;
	filename=xfs-flush_workers_before_stopping_log.patch
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
To: xfs@oss.sgi.com

The unmount race continues with our test boxes.

The below trace gave the clue that there is a write of the superblock
after the log UNMOUNT record and xfs_logprint confirmed this write.

A couple different experiments points to the sync worker. The simplest
solution is to moved the final flush of the workers before the final
superblock write so there is no other filesystem activity after the
UNMOUNT record is written to the log.

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


        ---- xfs_logprint ----


cycle: 10       version: 2              lsn: 10,4858    tail_lsn: 10,4856
length of Log Record: 512       prev offset: 4856               num ops: 5
uuid: aa1f1bfe-c226-42ae-a3db-ae0d4fc62938   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 2ce1d11b  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (1): tid: 2ce1d11b  len: 16  clientid: TRANS  flags: none
TRAN:    type: CHECKPOINT       tid: 2ce1d11b       num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: 2ce1d11b  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x0
Oper (3): tid: 2ce1d11b  len: 128  clientid: TRANS  flags: none
SUPER BLOCK Buffer:
icount: 85952  ifree: 150  fdblks: 344729  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: 2ce1d11b  len: 0  clientid: TRANS  flags: COMMIT

============================================================================
cycle: 10       version: 2              lsn: 10,4860    tail_lsn: 10,4858
length of Log Record: 512       prev offset: 4858               num ops: 1
uuid: aa1f1bfe-c226-42ae-a3db-ae0d4fc62938   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 9328d157  len: 8  clientid: LOG  flags: UNMOUNT
Unmount filesystem

============================================================================
cycle: 10       version: 2              lsn: 10,4862    tail_lsn: 10,4860
length of Log Record: 512       prev offset: 4860               num ops: 5
uuid: aa1f1bfe-c226-42ae-a3db-ae0d4fc62938   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: b6b71c0c  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (1): tid: b6b71c0c  len: 16  clientid: TRANS  flags: none
TRAN:    type: CHECKPOINT       tid: b6b71c0c       num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: b6b71c0c  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x0
Oper (3): tid: b6b71c0c  len: 128  clientid: TRANS  flags: none
SUPER BLOCK Buffer:
icount: 6360863066640355328  ifree: 524288  fdblks: 0  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: b6b71c0c  len: 0  clientid: TRANS  flags: COMMIT

============================================================================
xfs_logprint: logical end of log
============================================================================ 

There should be no more I/O after the UNMOUNT record is written to the log.

Flush the workers before the final sync of the superblock, write of the
UNMOUNT log record and tearing down the log.

This earlier flush prevents a late write of the superblock that raced with
the fiesystem shutdown.

---
 fs/xfs/xfs_log.c   |    1 -
 fs/xfs/xfs_mount.c |    5 +++++
 fs/xfs/xfs_super.c |    1 -
 3 files changed, 5 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -858,7 +858,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
-	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1490,6 +1490,11 @@ xfs_unmountfs(
 
 	xfs_qm_unmount(mp);
 
+	/* flush the worker queues while the log still exists and
+	 * before the final sync and unmount record.
+	 */
+	xfs_syncd_stop(mp);
+
 	/*
 	 * Flush out the log synchronously so that we know for sure
 	 * that nothing is pinned.  This is important because bflush()
Index: b/fs/xfs/xfs_super.c
===================================================================
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -920,7 +920,6 @@ xfs_fs_put_super(
 
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-	xfs_syncd_stop(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
