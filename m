Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA2FC3524A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 03:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF482080D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 03:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBDDox convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 22:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgBDDox (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Feb 2020 22:44:53 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206397] New: [xfstests generic/475] XFS: Assertion failed:
 iclog->ic_state == XLOG_STATE_ACTIVE, file: fs/xfs/xfs_log.c, line: 572
Date:   Tue, 04 Feb 2020 03:44:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206397-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206397

            Bug ID: 206397
           Summary: [xfstests generic/475] XFS: Assertion failed:
                    iclog->ic_state == XLOG_STATE_ACTIVE, file:
                    fs/xfs/xfs_log.c, line: 572
           Product: File System
           Version: 2.5
    Kernel Version: linux 5.5+ with xfs-linux xfs-5.6-merge-7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

XFS hit below assertion, when ran generic/475 on XFS:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9b-37 5.5.0+ #1 SMP Wed Jan 29 06:02:24 EST
2020
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda5
/mnt/xfstests/mnt2

generic/475 279s ... 


# dmesg
[22437.735364] XFS (dm-0): Unmounting Filesystem 
[22438.165496] XFS (dm-0): Mounting V5 Filesystem 
[22438.344531] XFS (dm-0): Starting recovery (logdev: internal) 
[22439.524024] XFS (dm-0): Ending recovery (logdev: internal) 
[22439.554451] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff) 
[22441.618632] iomap_finish_ioend: 12 callbacks suppressed 
[22441.618634] dm-0: writeback error on inode 89598, offset 20430848, sector
78472 
[22441.618641] dm-0: writeback error on inode 89598, offset 28454912, sector
323640 
[22441.618700] dm-0: writeback error on inode 89598, offset 33587200, sector
324712 
[22441.618718] dm-0: writeback error on inode 89598, offset 47378432, sector
322808 
[22441.618770] dm-0: writeback error on inode 8430874, offset 1048576, sector
8115320 
[22441.618830] dm-0: writeback error on inode 25183579, offset 16080896, sector
23830120 
[22441.618863] dm-0: writeback error on inode 25227916, offset 53960704, sector
23864864 
[22441.618902] dm-0: writeback error on inode 25227916, offset 70787072, sector
23830224 
[22441.618948] dm-0: writeback error on inode 25257187, offset 9568256, sector
23913872 
[22441.618971] XFS (dm-0): log I/O error -5 
[22441.618991] dm-0: writeback error on inode 25183496, offset 32112640, sector
23950744 
[22441.619022] XFS (dm-0): log I/O error -5 
[22441.619027] XFS: Assertion failed: iclog->ic_state == XLOG_STATE_ACTIVE,
file: fs/xfs/xfs_log.c, line: 572 
[22441.619198] ------------[ cut here ]------------ 
[22441.619220] kernel BUG at fs/xfs/xfs_message.c:110! 
[22441.619253] Oops: Exception in kernel mode, sig: 5 [#1] 
[22441.619284] LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV 
[22441.619317] Modules linked in: dm_mod rfkill i2c_dev sunrpc ses at24
enclosure ipmi_powernv scsi_transport_sas ofpart ipmi_devintf powernv_flash
uio_pdrv_genirq ipmi_msghandler xts uio mtd opal_prd vmx_crypto ibmpowernv
ip_tables xfs libcrc32c sd_mod ast t10_pi i2c_algo_bit drm_vram_helper
drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
drm i40e sg aacraid drm_panel_orientation_quirks 
[22441.619461] CPU: 104 PID: 20682 Comm: kworker/u322:6 Tainted: G        W    
    5.5.0+ #1 
[22441.619580] Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs] 
[22441.619603] NIP:  c00800000da00ed0 LR: c00800000da00e80 CTR:
c000000000898970 
[22441.619636] REGS: c000201baaadf7b0 TRAP: 0700   Tainted: G        W         
(5.5.0+) 
[22441.619670] MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 48002482 
XER: 00000000 
[22441.619708] CFAR: c00800000da00eb4 IRQMASK: 0  
[22441.619708] GPR00: c00800000da00e80 c000201baaadfa40 c00800000db3d300
ffffffffffffffea  
[22441.619708] GPR04: 000000000000000a c000201baaadf940 c00800000dabbaa0
0000000000000000  
[22441.619708] GPR08: ffffffffffffffc0 0000000000000001 0000000000000000
0000000000000000  
[22441.619708] GPR12: c000000000898970 c000201fff682800 c0000000001c1468
c000201bbfea3cc0  
[22441.619708] GPR16: 0000000000000000 0000000000000000 0000000000000000
0000000000000000  
[22441.619708] GPR20: 0000000000000000 c000201b76e18808 c000201b76e18880
c000201b76e1e148  
[22441.619708] GPR24: 0000000200003bd2 c000201c074f5800 c000201b76e18980
c000201cb2f95bc8  
[22441.619708] GPR28: c000201cb2f95b80 c000201c074f5800 0000000000000000
0000000000000001  
[22441.619955] NIP [c00800000da00ed0] assfail+0x88/0xb0 [xfs] 
[22441.620018] LR [c00800000da00e80] assfail+0x38/0xb0 [xfs] 
[22441.620037] Call Trace: 
[22441.620086] [c000201baaadfa40] [c00800000da00e80] assfail+0x38/0xb0 [xfs]
(unreliable) 
[22441.620154] [c000201baaadfab0] [c00800000da1fce4]
__xlog_state_release_iclog+0x14c/0x170 [xfs] 
[22441.620223] [c000201baaadfaf0] [c00800000da20610]
xfs_log_release_iclog+0x88/0x100 [xfs] 
[22441.620289] [c000201baaadfb30] [c00800000da261f8] xlog_cil_push+0x430/0x5e0
[xfs] 
[22441.620324] [c000201baaadfc20] [c0000000001b394c]
process_one_work+0x32c/0x920 
[22441.620358] [c000201baaadfd20] [c0000000001b4190] worker_thread+0x250/0x530 
[22441.620393] [c000201baaadfdb0] [c0000000001c1614] kthread+0x1b4/0x1c0 
[22441.620430] [c000201baaadfe20] [c00000000000b848]
ret_from_kernel_thread+0x5c/0x74 
[22441.620464] Instruction dump: 
[22441.620483] 38630010 4808f60d e8410018 60000000 73e90001 4082001c 0fe00000
38210070  
[22441.620521] e8010010 ebe1fff8 7c0803a6 4e800020 <0fe00000> 3c620000 e863db30
38630028  
[22441.620562] ---[ end trace e3618eb7d076a593 ]--- 
[22441.834060]  
[22441.834079] BUG: sleeping function called from invalid context at
include/linux/percpu-rwsem.h:38 
[22441.834104] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 20682,
name: kworker/u322:6 
[22441.834119] INFO: lockdep is turned off. 
[22441.834126] irq event stamp: 0 
[22441.834149] hardirqs last  enabled at (0): [<0000000000000000>] 0x0 
[22441.834175] hardirqs last disabled at (0): [<c000000000175260>]
copy_process+0x7d0/0x1c70 
[22441.834198] softirqs last  enabled at (0): [<c000000000175260>]
copy_process+0x7d0/0x1c70 
[22441.834233] softirqs last disabled at (0): [<0000000000000000>] 0x0 


The assertion failure on this line:

static bool
__xlog_state_release_iclog(
        struct xlog             *log,
        struct xlog_in_core     *iclog)
{
        lockdep_assert_held(&log->l_icloglock);

        if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
                /* update tail before writing to iclog */
                xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);

                iclog->ic_state = XLOG_STATE_SYNCING;
                iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
                xlog_verify_tail_lsn(log, iclog, tail_lsn);
                /* cycle incremented when incrementing curr_block */
                return true;
        }

--->    ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
        return false;
}

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
