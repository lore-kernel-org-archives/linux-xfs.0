Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12117-gd892d58
Message-Id: <20130722195444.DDE177F3F@oss.sgi.com>
Date: Mon, 22 Jul 2013 14:54:44 -0500 (CDT)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, for-next has been updated
  d892d58 xfs: Start using pquotaino from the superblock.
  0102629 xfs: Initialize all quota inodes to be NULLFSINO
  297aa63 xfs: Fix a deadlock in xfs_log_commit_cil() code path
  58e5985 xfs: fix assertion failure in xfs_vm_write_failed()
      from  ad81f0545ef01ea651886dddac4bef6cec930092 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit d892d5864f020c44cfa4e23e9165112d8df91093
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Fri Jul 19 17:36:02 2013 -0500

    xfs: Start using pquotaino from the superblock.
    
    Start using pquotino and define a macro to check if the
    superblock has pquotino.
    
    Keep backward compatibilty by alowing mount of older superblock
    with no separate pquota inode.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0102629776a2f5c3bd9c5dc0ef77956c60255074
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Fri Jul 19 17:32:55 2013 -0500

    xfs: Initialize all quota inodes to be NULLFSINO
    
    mkfs doesn't initialize the quota inodes to NULLFSINO as it does for the
    other internal inodes. This leads to two in-core values (0 and NULLFSINO)
    to be checked against, to make sure if a quota inode is valid.
    
    Solve that problem by initializing the in-core values of all quotaino
    values to NULLFSINO if they are 0 in the disk.
    
    Note that these values are not written back to on-disk superblock unless
    some quota is enabled on the filesystem. Even in that case sb_pquotino is
    written to disk only if the on-disk superblock supports pquotino
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 297aa63769e6ae06b7db97eb76c9211beeb32c69
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Fri Jul 19 17:31:38 2013 -0500

    xfs: Fix a deadlock in xfs_log_commit_cil() code path
    
    While testing and rearranging pquota/gquota code, I stumbled
    on a xfs_shutdown() during a mount. But the mount just hung.
    
    Debugged and found that there is a deadlock involving
    &log->l_cilp->xc_ctx_lock.
    
    It is in a code path where &log->l_cilp->xc_ctx_lock is first
    acquired in read mode and some levels down the same semaphore
    is being acquired in write mode causing a deadlock.
    
    This is the stack:
    xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
      xlog_print_tic_res
        xfs_force_shutdown
          xfs_log_force_umount
            xlog_cil_force
              xlog_cil_force_lsn
                xlog_cil_push_foreground
                  xlog_cil_push - tries to acquire same semaphore in write mode
    
    This patch fixes the deadlock by changing the reason code for
    xfs_force_shutdown in xlog_print_tic_res() to SHUTDOWN_LOG_IO_ERROR.
    
    SHUTDOWN_LOG_IO_ERROR is the right reason code to be set since
    we are in the log path.
    
    Thanks to Dave for suggesting this solution.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 58e59854a3dfa9ab1fa1bcfc6324646cd77046a7
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Jul 16 13:11:16 2013 +0800

    xfs: fix assertion failure in xfs_vm_write_failed()
    
    In xfs_vm_write_failed(), we evaluate the block_offset of pos with
    PAGE_MASK which is an unsigned long.  That is fine on 64-bit platforms
    regardless of whether the request pos is 32-bit or 64-bit.  However, on
    32-bit platforms the value is 0xfffff000 and so the high 32 bits in it
    will be masked off with (pos & PAGE_MASK) for a 64-bit pos.
    
    As a result, the evaluated block_offset is incorrect which will cause
    this failure ASSERT(block_offset + from == pos); and potentially pass
    the wrong block to xfs_vm_kill_delalloc_range().
    
    In this case, we can get a kernel panic if CONFIG_XFS_DEBUG is enabled:
    
    XFS: Assertion failed: block_offset + from == pos, file: fs/xfs/xfs_aops.c, line: 1504
    
    ------------[ cut here ]------------
     kernel BUG at fs/xfs/xfs_message.c:100!
     invalid opcode: 0000 [#1] SMP
     ........
     Pid: 4057, comm: mkfs.xfs Tainted: G           O 3.9.0-rc2 #1
     EIP: 0060:[<f94a7e8b>] EFLAGS: 00010282 CPU: 0
     EIP is at assfail+0x2b/0x30 [xfs]
     EAX: 00000056 EBX: f6ef28a0 ECX: 00000007 EDX: f57d22a4
     ESI: 1c2fb000 EDI: 00000000 EBP: ea6b5d30 ESP: ea6b5d1c
     DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
     CR0: 8005003b CR2: 094f3ff4 CR3: 2bcb4000 CR4: 000006f0
     DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
     DR6: ffff0ff0 DR7: 00000400
     Process mkfs.xfs (pid: 4057, ti=ea6b4000 task=ea5799e0 task.ti=ea6b4000)
     Stack:
     00000000 f9525c48 f951fa80 f951f96b 000005e4 ea6b5d7c f9494b34 c19b0ea2
     00000066 f3d6c620 c19b0ea2 00000000 e9a91458 00001000 00000000 00000000
     00000000 c15c7e89 00000000 1c2fb000 00000000 00000000 1c2fb000 00000080
     Call Trace:
     [<f9494b34>] xfs_vm_write_failed+0x74/0x1b0 [xfs]
     [<c15c7e89>] ? printk+0x4d/0x4f
     [<f9494d7d>] xfs_vm_write_begin+0x10d/0x170 [xfs]
     [<c110a34c>] generic_file_buffered_write+0xdc/0x210
     [<f949b669>] xfs_file_buffered_aio_write+0xf9/0x190 [xfs]
     [<f949b7f3>] xfs_file_aio_write+0xf3/0x160 [xfs]
     [<c115e504>] do_sync_write+0x94/0xd0
     [<c115ed1f>] vfs_write+0x8f/0x160
     [<c115e470>] ? wait_on_retry_sync_kiocb+0x50/0x50
     [<c115f017>] sys_write+0x47/0x80
     [<c15d860d>] sysenter_do_call+0x12/0x28
     .............
     EIP: [<f94a7e8b>] assfail+0x2b/0x30 [xfs] SS:ESP 0068:ea6b5d1c
     ---[ end trace cdd9af4f4ecab42f ]---
     Kernel panic - not syncing: Fatal exception
    
    In order to avoid this, we can evaluate the block_offset of the start
    of the page by using shifts rather than masks the mismatch problem.
    
    Thanks Dave Chinner for help finding and fixing this bug.
    
    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Reviewed-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c        | 15 ++++++++-
 fs/xfs/xfs_log.c         |  2 +-
 fs/xfs/xfs_mount.c       | 80 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_qm.c          | 72 ++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_qm_syscalls.c | 35 ++++++++++++++++++---
 fs/xfs/xfs_sb.h          | 13 ++++++--
 fs/xfs/xfs_super.c       | 19 ++++++------
 7 files changed, 191 insertions(+), 45 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
