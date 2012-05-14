Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4EKUVOT122799 for <xfs@oss.sgi.com>; Mon, 14 May 2012 15:30:31 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE691AC001
	for <xfs@oss.sgi.com>; Mon, 14 May 2012 13:30:27 -0700 (PDT)
Date: Mon, 14 May 2012 15:34:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] xfs: use s_umount sema in xfs_sync_worker
Message-ID: <20120514203449.GE16099@sgi.com>
References: <20120323174327.GU7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120323174327.GU7762@sgi.com>
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

I'm still hitting this on a regular basis.  Here is some analysis from a recent
crash dump which you may want to skip.  The fix is at the end.

PID: 3862   TASK: ffff88022175c640  CPU: 0   COMMAND: "262"

Hrm.  Looks like test 262 was running this time.

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
#10 [ffff88016fdffdc8] xlog_iodone at ffffffffa04aad6e [xfs]
#11 [ffff88016fdffdf8] xfs_buf_iodone_work at ffffffffa044a541 [xfs]
#12 [ffff88016fdffe18] process_one_work at ffffffff8104c53b
#13 [ffff88016fdffe68] worker_thread at ffffffff8104f0e3
#14 [ffff88016fdffee8] kthread at ffffffff8105395e
#15 [ffff88016fdfff48] kernel_thread_helper at ffffffff813b3ae4

Here's the guy who crashed the system.  Lets find the superblock:

Ok, walked from the xlog_in_core_t in rcx to ic_log (struct log) to l_mp
(xfs_mount 0xffff88013f8f9800) to get m_super (struct super_block), which is at
0xffff88021d1c2c00. 

struct xfs_mount {
	m_super = 0xffff88021d1c2c00,
	m_tid = 0x0,
	m_ail = 0xffff880149ea58c0,
	m_sb = {
	sb_magicnum = 0x58465342,	<--- yep, correct xfs super magic.

His s_id is /dev/sdb4 which is not currently mounted.  Looks like this is my
scratch filesystem, as /dev/sdb3 is mounted at /mnt/test.

PID: 4025   TASK: ffff880220870300  CPU: 1   COMMAND: "umount"
 #0 [ffff88022167ba58] __schedule at ffffffff813aacac
 #1 [ffff88022167bba0] schedule at ffffffff813ab0c4
 #2 [ffff88022167bbb0] schedule_timeout at ffffffff813a92d5
 #3 [ffff88022167bc50] wait_for_common at ffffffff813aa527
 #4 [ffff88022167bce0] wait_for_completion at ffffffff813aa6a8
 #5 [ffff88022167bcf0] wait_on_work at ffffffff8104d8b5
 #6 [ffff88022167bd90] __cancel_work_timer at ffffffff8104da2a
 #7 [ffff88022167bdd0] cancel_delayed_work_sync at ffffffff8104db2d
 #8 [ffff88022167bde0] xfs_syncd_stop at ffffffffa045aa78 [xfs]
 #9 [ffff88022167be00] xfs_fs_put_super at ffffffffa0459228 [xfs]
#10 [ffff88022167be20] generic_shutdown_super at ffffffff81110bdc
#11 [ffff88022167be50] kill_block_super at ffffffff81110c8c
#12 [ffff88022167be70] deactivate_locked_super at ffffffff811111f5
#13 [ffff88022167be90] deactivate_super at ffffffff81111f41
#14 [ffff88022167beb0] mntput_no_expire at ffffffff8112be1d
#15 [ffff88022167bef0] sys_umount at ffffffff8112c546
#16 [ffff88022167bf80] system_call_fastpath at ffffffff813b27f9
    RIP: 00007f789d7eb8e7  RSP: 00007fff1a744f60  RFLAGS: 00010246
    RAX: 00000000000000a6  RBX: ffffffff813b27f9  RCX: 00007fff1a7456c8
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000610940
    RBP: 0000000000610940   R8: 0000000000610960   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fff1a7461ce
    R13: 0000000000610920  R14: 0000000000610060  R15: 00000000006109a0
    ORIG_RAX: 00000000000000a6  CS: 0033  SS: 002b

We have an unmount running.  Is it the same filesytem as the log crash?

crash> bt -f ffff880220870300
...
 #8 [ffff88022167bde0] xfs_syncd_stop at ffffffffa045aa78 [xfs]
    ffff88022167bde8: 0000000000000000 ffff88013f8f9800 <-------- xfs_mount
    ffff88022167bdf8: ffff88022167be18 ffffffffa0459228 

0xffffffffa045aa60 <xfs_syncd_stop>:	push   %rbp			*
0xffffffffa045aa61 <xfs_syncd_stop+0x1>:	mov    %rsp,%rbp
0xffffffffa045aa64 <xfs_syncd_stop+0x4>:	push   %rbx		*
0xffffffffa045aa65 <xfs_syncd_stop+0x5>:	mov    %rdi,%rbx
0xffffffffa045aa68 <xfs_syncd_stop+0x8>:	lea    0x370(%rdi),%rdi
0xffffffffa045aa6f <xfs_syncd_stop+0xf>:	sub    $0x8,%rsp

xfs_syncd_stop pushes rbp and rbx on to the stack...

 #9 [ffff88022167be00] xfs_fs_put_super at ffffffffa0459228 [xfs]
    ffff88022167be08: ffff880221a6e0a0 ffff88021d1c2c00 
    ffff88022167be18: ffff88022167be48 ffffffff81110bdc 

crash> dis xfs_fs_put_super
0xffffffffa0459200 <xfs_fs_put_super>:  push   %rbp
0xffffffffa0459201 <xfs_fs_put_super+0x1>:      mov    %rsp,%rbp
0xffffffffa0459204 <xfs_fs_put_super+0x4>:      push   %rbx
0xffffffffa0459205 <xfs_fs_put_super+0x5>:      sub    $0x8,%rsp
0xffffffffa0459209 <xfs_fs_put_super+0x9>:      mov    0x2f0(%rdi),%rbx		*

The superblock is in rdi,
      [0x2f0] void *s_fs_info;  

We stuff the xfs_mount in s_fs_info, so then the xfs_mount should be in rbx
when xfs_syncd_stop pushes rbx onto the stack.

So the xfs_mount should be at ffff88013f8f9800, the same filesystem as the task
that crashed the system.

PID: 28181  TASK: ffff880001764200  CPU: 3   COMMAND: "kworker/3:10"
 #0 [ffff880001767b40] __schedule at ffffffff813aacac
 #1 [ffff880001767c88] schedule at ffffffff813ab0c4
 #2 [ffff880001767c98] xlog_wait at ffffffffa04a9f0a [xfs]
 #3 [ffff880001767cf8] _xfs_log_force_lsn at ffffffffa04ac95e [xfs]
 #4 [ffff880001767d88] xfs_trans_commit at ffffffffa04a9083 [xfs]
 #5 [ffff880001767dd8] xfs_fs_log_dummy at ffffffffa044f15b [xfs]
 #6 [ffff880001767df8] xfs_sync_worker at ffffffffa045ac4c [xfs]
 #7 [ffff880001767e18] process_one_work at ffffffff8104c53b
 #8 [ffff880001767e68] worker_thread at ffffffff8104f0e3
 #9 [ffff880001767ee8] kthread at ffffffff8105395e
#10 [ffff880001767f48] kernel_thread_helper at ffffffff813b3ae4

Is this xlog_wait the same filesytem?

 #2 [ffff880001767c98] xlog_wait at ffffffffa04a9f0a [xfs]
    ffff880001767ca0: 0000000000000001 ffff880001764200
    ffff880001767cb0: ffffffff81061940 ffff88014d879988
    ffff880001767cc0: ffff88014d879988 ffffffffa04ac2db
    ffff880001767cd0: ffff88014d879980 000000010000003f
    ffff880001767ce0: ffff8802214ee400 ffff8802214ee4a8
    ffff880001767cf0: ffff880001767d80 ffffffffa04ac95e
 #3 [ffff880001767cf8] _xfs_log_force_lsn at ffffffffa04ac95e [xfs]
    ffff880001767d00: ffff880001764200 0000000000011da0
    ffff880001767d10: 0000000000000000 0000000100000001
    ffff880001767d20: 0000000000000001 ffff880001764200
    ffff880001767d30: ffffffff81061940 dead000000100100
    ffff880001767d40: dead000000200200 0000000000000000
    ffff880001767d50: ffff88013f8f9800 ffff880206a80ea8
    ffff880001767d60: 0000000000000000 0000000000000000
    ffff880001767d70: ffff88013f8f9800 0000000000000008
    ffff880001767d80: ffff880001767dd0 ffffffffa04a9083
 #4 [ffff880001767d88] xfs_trans_commit at ffffffffa04a9083 [xfs]
    ffff880001767d90: ffff880149d2d800 ffff88022fd96305
    ffff880001767da0: 0000000000000004 0000000000000000
    ffff880001767db0: ffff880206a80ea8 0000000000000000
			^^^^^ xfs_trans_t
    ffff880001767dc0: ffff88022fd8d400 ffff88022fd96305
    ffff880001767dd0: ffff880001767df0 ffffffffa044f15b
 #5 [ffff880001767dd8] xfs_fs_log_dummy at ffffffffa044f15b [xfs]
    ffff880001767de0: ffff88013f8f9b70 ffff88013f8f9800
    ffff880001767df0: ffff880001767e10 ffffffffa045ac4c

crash> dis xfs_fs_log_dummy
0xffffffffa044f100 <xfs_fs_log_dummy>:  push   %rbp
0xffffffffa044f101 <xfs_fs_log_dummy+0x1>:      mov    $0x1,%edx
0xffffffffa044f106 <xfs_fs_log_dummy+0x6>:      mov    $0x1b,%esi
0xffffffffa044f10b <xfs_fs_log_dummy+0xb>:      mov    %rsp,%rbp
0xffffffffa044f10e <xfs_fs_log_dummy+0xe>:      push   %r12
0xffffffffa044f110 <xfs_fs_log_dummy+0x10>:     push   %rbx
0xffffffffa044f111 <xfs_fs_log_dummy+0x11>:     mov    %rdi,%rbx
0xffffffffa044f114 <xfs_fs_log_dummy+0x14>:     callq  0xffffffffa04a7ba0 <_xfs_trans_alloc>	* (trans will be in rax)
0xffffffffa044f119 <xfs_fs_log_dummy+0x19>:     movzwl 0x7e(%rbx),%edx
0xffffffffa044f11d <xfs_fs_log_dummy+0x1d>:     xor    %r8d,%r8d
0xffffffffa044f120 <xfs_fs_log_dummy+0x20>:     xor    %ecx,%ecx
0xffffffffa044f122 <xfs_fs_log_dummy+0x22>:     xor    %esi,%esi
0xffffffffa044f124 <xfs_fs_log_dummy+0x24>:     mov    $0x1,%r9d
0xffffffffa044f12a <xfs_fs_log_dummy+0x2a>:     mov    %rax,%rdi
0xffffffffa044f12d <xfs_fs_log_dummy+0x2d>:     mov    %rax,%r12		*
0xffffffffa044f130 <xfs_fs_log_dummy+0x30>:     sub    $0xffffff80,%edx
0xffffffffa044f133 <xfs_fs_log_dummy+0x33>:     callq  0xffffffffa04a8050 <xfs_trans_reserve>
0xffffffffa044f138 <xfs_fs_log_dummy+0x38>:     test   %eax,%eax
0xffffffffa044f13a <xfs_fs_log_dummy+0x3a>:     mov    %eax,%ebx
0xffffffffa044f13c <xfs_fs_log_dummy+0x3c>:     jne    0xffffffffa044f168 <xfs_fs_log_dummy+0x68>
0xffffffffa044f13e <xfs_fs_log_dummy+0x3e>:     mov    %r12,%rdi		*
0xffffffffa044f141 <xfs_fs_log_dummy+0x41>:     mov    $0x20,%esi
0xffffffffa044f146 <xfs_fs_log_dummy+0x46>:     callq  0xffffffffa04a45b0 <xfs_mod_sb>
0xffffffffa044f14b <xfs_fs_log_dummy+0x4b>:     orl    $0x8,0x68(%r12)
0xffffffffa044f151 <xfs_fs_log_dummy+0x51>:     mov    %r12,%rdi
0xffffffffa044f154 <xfs_fs_log_dummy+0x54>:     xor    %esi,%esi
0xffffffffa044f156 <xfs_fs_log_dummy+0x56>:     callq  0xffffffffa04a8df0 <xfs_trans_commit>

Looks like the xfs_trans_t should be in r12.

crash> dis xfs_trans_commit
0xffffffffa04a8df0 <xfs_trans_commit>:  push   %rbp
0xffffffffa04a8df1 <xfs_trans_commit+0x1>:      mov    %rsp,%rbp		*
0xffffffffa04a8df4 <xfs_trans_commit+0x4>:      sub    $0x40,%rsp
0xffffffffa04a8df8 <xfs_trans_commit+0x8>:      mov    %rbx,-0x28(%rbp)
0xffffffffa04a8dfc <xfs_trans_commit+0xc>:      mov    %r12,-0x20(%rbp)		*

Which is put on the stack at -0x20 by xfs_trans_commit.
So that's ffff880206a80ea8.

crash> xfs_trans_t ffff880206a80ea8
struct xfs_trans_t {
  t_magic = 0x5452414e,
  t_logcb = {
    cb_next = 0x0,
    cb_func = 0,
    cb_arg = 0x0
  },
  t_type = 0x1b,
  t_log_res = 0x280,
  t_log_count = 0x1,
  t_blk_res = 0x0,
  t_blk_res_used = 0x0,
  t_rtx_res = 0x0,
  t_rtx_res_used = 0x0,
  t_ticket = 0xffff88020f721b50,
  t_lsn = 0x0,
  t_commit_lsn = 0x4,
  t_mountp = 0xffff88013f8f9800,		* xfs_mount_t

 #6 [ffff880001767df8] xfs_sync_worker at ffffffffa045ac4c [xfs]
    ffff880001767e00: ffff88013f8f9b70 ffff880221498ec0
    ffff880001767e10: ffff880001767e60 ffffffff8104c53b
 #7 [ffff880001767e18] process_one_work at ffffffff8104c53b

So that's the same xfs_mount as the one involved in the crash.  Looks like the
problem is that the sync worker is still running after the log has been torn
down, and it calls xfs_fs_log_dummy which generates log traffic.

/*
 * Every sync period we need to unpin all items, reclaim inodes and sync
 * disk quotas.  We might need to cover the log to indicate that the
 * filesystem is idle and not frozen.
 */
STATIC void
xfs_sync_worker(
        struct work_struct *work)
{
        struct xfs_mount *mp = container_of(to_delayed_work(work),
                                        struct xfs_mount, m_sync_work);
        int             error;

        /*
         * We shouldn't write/force the log if we are in the mount/unmount
         * process or on a read only filesystem. The workqueue still needs to be
         * active in both cases, however, because it is used for inode reclaim
         * during these times. hence use the MS_ACTIVE flag to avoid doing
         * anything in these periods.
         */
        if (!(mp->m_super->s_flags & MS_ACTIVE) &&		* 
            !(mp->m_flags & XFS_MOUNT_RDONLY)) {
                /* dgc: errors ignored here */
                if (mp->m_super->s_frozen == SB_UNFROZEN &&
                    xfs_log_need_covered(mp))
                        error = xfs_fs_log_dummy(mp);
                else
                        xfs_log_force(mp, 0);

                /* start pushing all the metadata that is currently dirty */
                xfs_ail_push_all(mp->m_ail);
        }

        /* queue us up again */
        xfs_syncd_queue_sync(mp);
}

Looks like checking for MS_ACTIVE is not adequate for preventing a race with
unmount.

Here is the fix.  I'll sign off on it once my testing is completed. -Ben

===================================================================

xfs: use s_umount sema in xfs_sync_worker

xfs_sync_worker checks the MS_ACTIVE flag in sb->s_flags to avoid doing work
during mount and unmount.  This flag can be cleared by unmount after the
xfs_sync_worker checks it but before the work is completed.  The has caused
crashes in the completion handler for the dummy transaction commited by
xfs_sync_worker:

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
#10 [ffff88016fdffdc8] xlog_iodone at ffffffffa04aad6e [xfs]
#11 [ffff88016fdffdf8] xfs_buf_iodone_work at ffffffffa044a541 [xfs]
#12 [ffff88016fdffe18] process_one_work at ffffffff8104c53b
#13 [ffff88016fdffe68] worker_thread at ffffffff8104f0e3
#14 [ffff88016fdffee8] kthread at ffffffff8105395e
#15 [ffff88016fdfff48] kernel_thread_helper at ffffffff813b3ae4

Protect xfs_sync_worker by using the s_umount semaphore at the read level to
provide exclusion with unmount while work is progressing.

Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c
+++ xfs/fs/xfs/xfs_sync.c
@@ -386,20 +386,23 @@ xfs_sync_worker(
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
+	if (down_read_trylock(&mp->m_super->s_umount)) {
+		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+			/* dgc: errors ignored here */
+			if (mp->m_super->s_frozen == SB_UNFROZEN &&
+			    xfs_log_need_covered(mp))
+				error = xfs_fs_log_dummy(mp);
+			else
+				xfs_log_force(mp, 0);
 
-		/* start pushing all the metadata that is currently dirty */
-		xfs_ail_push_all(mp->m_ail);
+			/* start pushing all the metadata that is currently
+			 * dirty */
+			xfs_ail_push_all(mp->m_ail);
+		}
+		up_read(&mp->m_super->s_umount);
 	}
 
 	/* queue us up again */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
