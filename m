Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56358 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbfF3OCr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 10:02:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2EF1B286AD
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 14:02:45 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204031] New: [xfstests generic/475]: general protection fault:
 0000 [#1] RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs]
Date: Sun, 30 Jun 2019 14:02:43 +0000
Message-ID: <bug-204031-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204031

            Bug ID: 204031
           Summary: [xfstests generic/475]: general protection fault: 0000
                    [#1] RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs]
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.3-merge-3
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

Created attachment 283489
  --> https://bugzilla.kernel.org/attachment.cgi?id=283489&action=edit
console log

Refer to: https://bugzilla.kernel.org/show_bug.cgi?id=203947 comment 4 ~ 10

I hit panic by xfstests generic/475, and Darrick has given it a research.
Details as below:

[23759.890740] XFS (dm-0): Unmounting Filesystem 
[23760.224109] XFS (dm-0): Mounting V5 File ystem 
[23760.468142] XFS (dm-0): Starting recovery (logdev: internal) 
[23764.766209] XFS (dm-0): Ending recovery (logdev: internal) 
[23760.241613] restraintd[1378]: *** Current Time: Fri Jun 28 12:57:05 2019
Localwatchdog at: Sun Jun 30 06:28:04 2019 
[23765.948214] XFS (dm-0): writeback error on sector 5942384 
[23765.951464] XFS (dm-0): writeback error on sector 3955064 
[23765.952027] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at
daddr 0x1dfff0 len 8 error 5 
[23765.957388] kasan: CONFIG_KASAN_INLINE enabled 
[23765.957391] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[23765.957400] general protection fault: 0000 [#1] SMP KASAN PTI 
[23765.957408] CPU: 5 PID: 29727 Comm: fsstress Tainted: G    B   W        
5.2.0-rc4+ #1 
[23765.957411] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015 
[23765.957512] RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs] 
[23765.957519] Code: 45 85 ff 0f 85 8b 02 00 00 48 8d 45 48 48 89 04 24 48 8b
04 24 48 8d 78 12 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04
02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 a9 07 00 00 
[23765.957522] RSP: 0018:ffff888047f9ed68 EFLAGS: 00010202 
[23765.957528] RAX: dffffc0000000000 RBX: ffff888047f9f038 RCX:
1ffffffff5f99f51 
[23765.957532] RDX: 0000000000000002 RSI: 0000000000000008 RDI:
0000000000000012 
[23765.957535] RBP: ffff888002a41f00 R08: ffffed10005483f0 R09:
ffffed10005483ef 
[23765.957539] R10: ffffed10005483ef R11: ffff888002a41f7f R12:
0000000000000004 
[23765.957542] R13: ffffe8fff53b5768 R14: 0000000000000005 R15:
0000000000000001 
[23765.957546] FS:  00007f11d44b5b80(0000) GS:ffff888114200000(0000)
knlGS:0000000000000000 
[23765.957550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[23765.957553] CR2: 0000000000ef6000 CR3: 000000002e176003 CR4:
00000000001606e0 
[23765.957556] Call Trace: 
[23765.957646]  ? xfs_bmapi_convert_delalloc+0xcf0/0xcf0 [xfs] 
[23765.957662]  ? save_stack+0x4d/0x80 
[23765.957666]  ? save_stack+0x19/0x80 
[23765.957672]  ? __kasan_kmalloc.constprop.6+0xc1/0xd0 
[23765.957676]  ? kmem_cache_alloc+0xf4/0x320 
[23765.957770]  ? kmem_zone_alloc+0x6c/0x120 [xfs] 
[23765.957869]  ? xlog_ticket_alloc+0x33/0x3d0 [xfs] 
[23765.957876] XFS (dm-0): writeback error on sector 2064384 
[23765.957968]  ? xfs_trans_reserve+0x6d0/0xd80 [xfs] 
[23765.958060]  ? xfs_trans_alloc+0x299/0x630 [xfs] 
[23765.958149]  ? xfs_attr_inactive+0x1f3/0x5e0 [xfs] 
[23765.958242]  ? xfs_inactive+0x4c8/0x5b0 [xfs] 
[23765.958335]  ? xfs_fs_destroy_inode+0x31b/0x8e0 [xfs] 
[23765.958342]  ? destroy_inode+0xbc/0x190 
[23765.958434]  ? xfs_bulkstat_one_int+0xa8c/0x1200 [xfs] 
[23765.958526]  ? xfs_bulkstat+0x6fa/0xf20 [xfs] 
[23765.958617]  ? xfs_ioc_bulkstat+0x182/0x2b0 [xfs] 
[23765.958709]  ? xfs_file_ioctl+0xee0/0x12a0 [xfs] 
[23765.958716]  ? do_vfs_ioctl+0x193/0x1000 
[23765.958721]  ? ksys_ioctl+0x60/0x90 
[23765.958726]  ? __x64_sys_ioctl+0x6f/0xb0 
[23765.958734]  ? do_syscall_64+0x9f/0x4d0 
[23765.958741]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[23765.958756]  ? stack_depot_save+0x260/0x430 
[23765.958843]  xfs_dabuf_map.constprop.18+0x696/0xe50 [xfs] 
[23765.958942]  ? xfs_fs_destroy_inode+0x31b/0x8e0 [xfs] 
[23765.958948]  ? destroy_inode+0xbc/0x190 
[23765.959040]  ? xfs_bulkstat_one_int+0xa8c/0x1200 [xfs] 
[23765.959136]  ? xfs_bulkstat_one+0x16/0x20 [xfs] 
[23765.959222]  ? xfs_da3_node_order.isra.10+0x3a0/0x3a0 [xfs] 
[23765.959320]  ? xlog_space_left+0x52/0x250 [xfs] 
[23765.959415]  ? xlog_grant_head_check+0x187/0x430 [xfs] 
[23765.959512]  ? xlog_grant_head_wait+0xaa0/0xaa0 [xfs] 
[23765.959599]  xfs_da_read_buf+0xf5/0x2c0 [xfs] 
[23765.959684]  ? xfs_da3_root_split.isra.13+0xf40/0xf40 [xfs] 
[23765.959782]  ? xlog_ticket_alloc+0x3d0/0x3d0 [xfs] 
[23765.959795]  ? lock_acquire+0x142/0x380 
[23765.959803]  ? lock_contended+0xd50/0xd50 
[23765.959949]  xfs_da3_node_read+0x1d/0x230 [xfs] 
[23765.960043]  xfs_attr_inactive+0x3cc/0x5e0 [xfs] 
[23765.960133]  ? xfs_attr3_node_inactive+0x760/0x760 [xfs] 
[23765.960143]  ? lock_downgrade+0x620/0x620 
[23765.960148]  ? lock_contended+0xd50/0xd50 
[23765.960158]  ? fsnotify_destroy_marks+0x62/0x1c0 
[23765.960256]  xfs_inactive+0x4c8/0x5b0 [xfs] 
[23765.960355]  xfs_fs_destroy_inode+0x31b/0x8e0 [xfs] 
[23765.960365]  destroy_inode+0xbc/0x190 
[23765.960459]  xfs_bulkstat_one_int+0xa8c/0x1200 [xfs] 
[23765.960552]  ? xfs_irele+0x270/0x270 [xfs] 
[23765.960647]  ? xfs_bulkstat_ichunk_ra.isra.1+0x340/0x340 [xfs] 
[23765.960746]  xfs_bulkstat_one+0x16/0x20 [xfs] 
[23765.960837]  xfs_bulkstat+0x6fa/0xf20 [xfs] 
[23765.960934]  ? xfs_bulkstat_one_int+0x1200/0x1200 [xfs] 
[23765.961033]  ? xfs_bulkstat_one+0x20/0x20 [xfs] 
[23765.961047]  ? cred_has_capability+0x125/0x240 
[23765.961054]  ? selinux_sb_eat_lsm_opts+0x550/0x550 
[23765.961144]  ? xfs_buf_find+0x1068/0x20d0 [xfs] 
[23765.961155]  ? lock_acquire+0x142/0x380 
[23765.961161]  ? lock_downgrade+0x620/0x620 
[23765.961263]  xfs_ioc_bulkstat+0x182/0x2b0 [xfs] 
[23765.961356]  ? copy_overflow+0x20/0x20 [xfs] 
[23765.961368]  ? do_raw_spin_unlock+0x54/0x220 
[23765.961375]  ? _raw_spin_unlock+0x24/0x30 
[23765.961463]  ? xfs_buf_rele+0x5a2/0xc70 [xfs] 
[23765.961551]  ? xfs_buf_read_map+0x471/0x5f0 [xfs] 
[23765.961647]  ? xfs_buf_unlock+0x1ea/0x2c0 [xfs] 
[23765.961745]  xfs_file_ioctl+0xee0/0x12a0 [xfs] 
[23765.961839]  ? xfs_ioc_swapext+0x4c0/0x4c0 [xfs] 
[23765.961854]  ? unwind_next_frame+0xff8/0x1c00 
[23765.961859]  ? arch_stack_walk+0x5f/0xe0 
[23765.961867]  ? deref_stack_reg+0xb0/0xf0 
[23765.961875]  ? __read_once_size_nocheck.constprop.8+0x10/0x10 
[23765.961883]  ? deref_stack_reg+0xf0/0xf0 
[23765.961894]  ? lock_downgrade+0x620/0x620 
[23765.961901]  ? is_bpf_text_address+0x5/0xf0 
[23765.961911]  ? lock_downgrade+0x620/0x620 
[23765.961918]  ? avc_has_extended_perms+0xd6/0x11a0 
[23765.961927]  ? kernel_text_address+0x125/0x140 
[23765.961937]  ? avc_has_extended_perms+0x4e4/0x11a0 
[23765.961950]  ? avc_ss_reset+0x140/0x140 
[23765.961962]  ? stack_trace_consume_entry+0x160/0x160 
[23765.961973]  ? save_stack+0x4d/0x80 
[23765.961977]  ? save_stack+0x19/0x80 
[23765.961982]  ? __kasan_slab_free+0x125/0x170 
[23765.961986]  ? kmem_cache_free+0xc3/0x310 
[23765.961992]  ? do_sys_open+0x169/0x360 
[23765.961998]  ? do_syscall_64+0x9f/0x4d0 
[23765.962003]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[23765.962015]  ? trace_hardirqs_on_thunk+0x1a/0x1c 
[23765.962029]  do_vfs_ioctl+0x193/0x1000 
[23765.962040]  ? ioctl_preallocate+0x1b0/0x1b0 
[23765.962045]  ? selinux_file_ioctl+0x3c9/0x550 
[23765.962054]  ? selinux_file_mprotect+0x5b0/0x5b0 
[23765.962067]  ? syscall_trace_enter+0x5b2/0xe30 
[23765.962073]  ? __kasan_slab_free+0x13a/0x170 
[23765.962080]  ? do_sys_open+0x169/0x360 
[23765.962094]  ksys_ioctl+0x60/0x90 
[23765.962103]  __x64_sys_ioctl+0x6f/0xb0 
[23765.962110]  do_syscall_64+0x9f/0x4d0 
[23765.962117]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[23765.962123] RIP: 0033:0x7f11d39a3e5b 
[23765.962128] Code: 0f 1e fa 48 8b 05 2d a0 2c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d fd 9f 2c 00 f7 d8 64 89 01 48 
[23765.962131] RSP: 002b:00007fff16fb7a68 EFLAGS: 00000246 ORIG_RAX:
0000000000000010 
[23765.962137] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f11d39a3e5b 
[23765.962141] RDX: 00007fff16fb7a80 RSI: ffffffffc0205865 RDI:
0000000000000003 
[23765.962143] RBP: 0000000000000003 R08: 0000000000000000 R09:
0000000000000003 
[23765.962147] R10: 0000000000000000 R11: 0000000000000246 R12:
ffffffffc0205865 
[23765.962150] R13: 0000000000000351 R14: 0000000000ed9220 R15:
000000000000006b 
[23765.962165] Modules linked in: dm_mod iTCO_wdt iTCO_vendor_support
intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate
intel_uncore intel_rapl_perf pcspkr sunrpc dax_pmem_compat device_dax
dax_pmem_core nd_pmem i2c_i801 lpc_ich ipmi_ssif ipmi_si hpilo ext4
ipmi_devintf sg hpwdt ipmi_msghandler ioatdma acpi_tad acpi_power_meter dca
mbcache jbd2 xfs libcrc32c mgag200 i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops sd_mod ttm drm uas crc32c_intel usb_storage
serio_raw tg3 hpsa scsi_transport_sas wmi 
[23765.962274] ---[ end trace 51bdc5e7fcb8f571 ]--- 
[23765.970394] XFS (dm-0): writeback error on sector 2064888 
[23765.974614] XFS (dm-0): writeback error on sector 6544 
[23765.974700] XFS (dm-0): writeback error on sector 67648 
[23765.987115] RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs] 
[23765.991942] Buffer I/O error on dev dm-0, logical block 31457152, async page
read 
[23765.992006] Buffer I/O error on dev dm-0, logical block 31457153, async page
read 


--------------------------------------------------------------------------

Comment 9 Darrick J. Wong 2019-06-29 17:31:56 UTC
Ok, so I reproduced it locally and tracked the crash to this part of
xfs_bmapi_read() where we dereference *ifp:

        if (!(ifp->if_flags & XFS_IFEXTENTS)) {                                 
                error = xfs_iread_extents(NULL, ip, whichfork);                 
                if (error)                                                      
                        return error;                                           
        }                                                                       

Looking at xfs_iformat_fork(), it seems that if there's any kind of error
formatting the attr fork it'll free ip->i_afp and set it to NULL, so I think
the fix is to add an "if (!afp) return -EIO;" somewhere.

Not sure how we actually get to this place, though.  fsstress is running
bulkstat, which is inactivating an inode with i_nlink == 0 and a corrupt attr
fork that won't load.  Maybe we hit an inode that had previously gone through
unlinked processing after log recovery but was lurking on the mru waiting to be
inactivated, but then bulkstat showed up (with its IGET_DONTCACHE) which forced
immediate inactivation?

------------------------------------------------------------------------------

Comment 9 Darrick J. Wong 2019-06-29 17:35:14 UTC
Zorro,

If you get a chance, can you try this debugging patch, please?

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index baf0b72c0a37..1bf408255349 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3846,6 +3846,12 @@ xfs_bmapi_read(
                return 0;
        }

+       if (!ifp) {
+               xfs_err(mp, "NULL FORK, inode x%llx fork %d??",
+                               ip->i_ino, whichfork);
+               return -EFSCORRUPTED;
+       }
+
        if (!(ifp->if_flags & XFS_IFEXTENTS)) {
                error = xfs_iread_extents(NULL, ip, whichfork);
                if (error)

-----------------------------------------------------------------------------

Comment 10 Zorro Lang 2019-06-30 13:52:43 UTC
(In reply to Darrick J. Wong from comment #9)
> Zorro,
> 
> If you get a chance, can you try this debugging patch, please?


Sure, I'll give it a try. With this bug together ... they both triggered by
g/475. You really write a nice case :)

Both these two bugs are too hard to reproduce, so I only can try my best to
test it, but I can't 100% verify they're fixed even if all test pass, I'll try
to approach 99% :-P

BTW, if this's a separate bug, I'd like to report a new bug to track it, to
avoid confusion.

Thanks,
Zorro


> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index baf0b72c0a37..1bf408255349 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3846,6 +3846,12 @@ xfs_bmapi_read(
>                 return 0;
>         }
>  
> +       if (!ifp) {
> +               xfs_err(mp, "NULL FORK, inode x%llx fork %d??",
> +                               ip->i_ino, whichfork);
> +               return -EFSCORRUPTED;
> +       }
> +
>         if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>                 error = xfs_iread_extents(NULL, ip, whichfork);
>                 if (error)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
