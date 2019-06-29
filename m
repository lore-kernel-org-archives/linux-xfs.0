Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49330 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726707AbfF2Das (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 23:30:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1534028721
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 03:30:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Sat, 29 Jun 2019 03:30:43 +0000
Message-ID: <bug-203947-201763-fuTv6Uks7f@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
By merging "[PATCH] xfs: allow merging ioends over append boundaries" into
xfs-linux xfs-5.3-merge-3, then loop run g/475 again, I just hit another panic
as below[1].

More Assertion and Internal error output before this panic is [2].
Due to the test job panic as this, for verify this bug, I have to do the test
again.

[1]
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

[2]
[ 3666.774066] XFS (dm-0): log I/O error -5 
[ 3666.781644] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1235 of
file fs/xfs/xfs_log.c. Return address = 0000000056321ec9 
[ 3666.781649] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
[ 3666.781653] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s) 
[ 3670.161316] XFS (dm-0): Unmounting Filesystem 
[ 3670.493415] XFS (dm-0): Mounting V5 Filesystem 
[ 3671.532800] XFS (dm-0): Starting recovery (logdev: internal) 
[ 3673.605082] XFS (dm-0): Ending recovery (logdev: internal) 
[ 3673.785156] XFS: Assertion failed: fs_is_ok, file:
fs/xfs/libxfs/xfs_ialloc.c, line: 1529 
[ 3673.826539] WARNING: CPU: 8 PID: 19166 at fs/xfs/xfs_message.c:94
asswarn+0x1c/0x1f [xfs] 
[ 3673.867150] Modules linked in: dm_mod iTCO_wdt iTCO_vendor_support
intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate
intel_uncore intel_rapl_perf pcspkr sunrpc dax_pmem_compat device_dax
dax_pmem_core nd_pmem i2c_i801 lpc_ich ipmi_ssif ipmi_si hpilo ext4
ipmi_devintf sg hpwdt ipmi_msghandler ioatdma acpi_tad acpi_power_meter dca
mbcache jbd2 xfs libcrc32c mgag200 i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops sd_mod ttm drm uas crc32c_intel usb_storage
serio_raw tg3 hpsa scsi_transport_sas wmi 
[ 3674.127363] CPU: 8 PID: 19166 Comm: fsstress Tainted: G    B   W        
5.2.0-rc4+ #1 
[ 3674.164732] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015 
[ 3674.195470] RIP: 0010:asswarn+0x1c/0x1f [xfs] 
[ 3674.215962] Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00
48 89 f1 41 89 d0 48 c7 c6 40 24 b2 c0 48 89 fa 31 ff e8 06 fa ff ff <0f> 0b c3
0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 40 24 b2 c0 48 
[ 3674.304237] RSP: 0018:ffff8881158c7030 EFLAGS: 00010282 
[ 3674.329633] RAX: 0000000000000000 RBX: ffff888046e15440 RCX:
0000000000000000 
[ 3674.364835] RDX: dffffc0000000000 RSI: 000000000000000a RDI:
ffffed1022b18df8 
[ 3674.399965] RBP: 1ffff11022b18e09 R08: ffffed10229fdfb1 R09:
ffffed10229fdfb0 
[ 3674.434264] R10: ffffed10229fdfb0 R11: ffff888114fefd87 R12:
fe00000000000000 
[ 3674.467992] R13: ffff8881158c71f0 R14: ffff8881158c70a8 R15:
ffff888046e15448 
[ 3674.501551] FS:  00007fab884d2b80(0000) GS:ffff888114e00000(0000)
knlGS:0000000000000000 
[ 3674.539731] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 3674.566832] CR2: 00007fa94b16a8c0 CR3: 000000011519a003 CR4:
00000000001606e0 
[ 3674.600370] Call Trace: 
[ 3674.611931]  xfs_dialloc_ag_update_inobt+0x2a3/0x500 [xfs] 
[ 3674.637835]  ? xfs_dialloc_ag_finobt_newino.isra.12+0x560/0x560 [xfs] 
[ 3674.668283]  ? kmem_zone_alloc+0x6c/0x120 [xfs] 
[ 3674.689685]  ? xfs_inobt_init_cursor+0x7e/0x520 [xfs] 
[ 3674.713562]  xfs_dialloc_ag+0x3ff/0x6a0 [xfs] 
[ 3674.734055]  ? xfs_dialloc_ag_inobt+0x1420/0x1420 [xfs] 
[ 3674.758645]  ? xfs_perag_put+0x26e/0x390 [xfs] 
[ 3674.779206]  ? xfs_ialloc_read_agi+0x1fb/0x560 [xfs] 
[ 3674.802651]  ? xfs_perag_put+0x26e/0x390 [xfs] 
[ 3674.823621]  xfs_dialloc+0xf4/0x6a0 [xfs] 
[ 3674.843583]  ? xfs_ialloc_ag_select+0x4a0/0x4a0 [xfs] 
[ 3674.869046]  ? save_stack+0x4d/0x80 
[ 3674.886821]  ? save_stack+0x19/0x80 
[ 3674.903911]  ? __kasan_kmalloc.constprop.6+0xc1/0xd0 
[ 3674.928691]  ? kmem_cache_alloc+0xf4/0x320 
[ 3674.948118]  ? kmem_zone_alloc+0x6c/0x120 [xfs] 
[ 3674.969312]  ? xfs_trans_alloc+0x44/0x630 [xfs] 
[ 3674.990319]  ? xfs_generic_create+0x38e/0x4b0 [xfs] 
[ 3675.013030]  ? lookup_open+0xed9/0x1990 
[ 3675.030904]  ? path_openat+0xb33/0x2a60 
[ 3675.048478]  ? do_filp_open+0x17c/0x250 
[ 3675.066205]  ? do_sys_open+0x1d9/0x360 
[ 3675.083526]  xfs_ialloc+0xfa/0x1c10 [xfs] 
[ 3675.102396]  ? xfs_iunlink_free_item+0x60/0x60 [xfs] 
[ 3675.125858]  ? xlog_grant_head_check+0x187/0x430 [xfs] 
[ 3675.150110]  ? xlog_grant_head_wait+0xaa0/0xaa0 [xfs] 
[ 3675.173980]  ? xlog_grant_add_space.isra.14+0x85/0x100 [xfs] 
[ 3675.200628]  xfs_dir_ialloc+0x135/0x630 [xfs] 
[ 3675.221134]  ? __percpu_counter_compare+0x86/0xe0 
[ 3675.243349]  ? xfs_lookup+0x490/0x490 [xfs] 
[ 3675.263055]  ? lock_acquire+0x142/0x380 
[ 3675.281175]  ? lock_contended+0xd50/0xd50 
[ 3675.300078]  xfs_create+0x5bc/0x1320 [xfs] 
[ 3675.319636]  ? xfs_dir_ialloc+0x630/0x630 [xfs] 
[ 3675.340956]  ? get_cached_acl+0x23a/0x390 
[ 3675.360223]  ? set_posix_acl+0x250/0x250 
[ 3675.379875]  ? get_acl+0x18/0x1f0 
[ 3675.396228]  xfs_generic_create+0x38e/0x4b0 [xfs] 
[ 3675.419343]  ? lock_downgrade+0x620/0x620 
[ 3675.438996]  ? lock_contended+0xd50/0xd50 
[ 3675.458080]  ? xfs_setup_iops+0x420/0x420 [xfs] 
[ 3675.479498]  ? do_raw_spin_unlock+0x54/0x220 
[ 3675.499493]  ? _raw_spin_unlock+0x24/0x30 
[ 3675.518304]  ? d_splice_alias+0x417/0xb50 
[ 3675.537345]  ? xfs_vn_lookup+0x156/0x190 [xfs] 
[ 3675.558262]  ? selinux_capable+0x20/0x20 
[ 3675.576337]  ? from_kgid+0x83/0xc0 
[ 3675.592075]  lookup_open+0xed9/0x1990 
[ 3675.609036]  ? path_init+0x10f0/0x10f0 
[ 3675.626336]  ? lock_downgrade+0x620/0x620 
[ 3675.644483]  path_openat+0xb33/0x2a60 
[ 3675.661432]  ? getname_flags+0xba/0x510 
[ 3675.679087]  ? path_mountpoint+0xab0/0xab0 
[ 3675.697892]  ? kasan_init_slab_obj+0x20/0x30 
[ 3675.717904]  ? new_slab+0x326/0x630 
[ 3675.734621]  ? ___slab_alloc+0x3e3/0x5e0 
[ 3675.753045]  do_filp_open+0x17c/0x250 
[ 3675.770273]  ? may_open_dev+0xc0/0xc0 
[ 3675.787452]  ? __check_object_size+0x25f/0x346 
[ 3675.808348]  ? do_raw_spin_unlock+0x54/0x220 
[ 3675.828459]  ? _raw_spin_unlock+0x24/0x30 
[ 3675.847272]  do_sys_open+0x1d9/0x360 
[ 3675.864040]  ? filp_open+0x50/0x50 
[ 3675.880894]  do_syscall_64+0x9f/0x4d0 
[ 3675.899047]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[ 3675.924132] RIP: 0033:0x7fab879bb5e8 
[ 3675.941751] Code: 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3
0f 1e fa 48 8d 05 35 51 2d 00 8b 00 85 c0 75 17 b8 55 00 00 00 0f 05 <48> 3d 00
f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 55 89 f5 53 48 89 
[ 3676.030090] RSP: 002b:00007ffe5e603e98 EFLAGS: 00000246 ORIG_RAX:
0000000000000055 
[ 3676.065926] RAX: ffffffffffffffda RBX: 00007ffe5e607298 RCX:
00007fab879bb5e8 
[ 3676.099605] RDX: 000000000040ce46 RSI: 00000000000001b6 RDI:
00007ffe5e603eb6 
[ 3676.133161] RBP: 0000000000000007 R08: 0000000000000000 R09:
00007ffe5e603c44 
[ 3676.168328] R10: fffffffffffffe05 R11: 0000000000000246 R12:
0000000000000001 
[ 3676.201669] R13: 00007ffe5e608608 R14: 0000000000000000 R15:
0000000000000000 
[ 3676.235285] irq event stamp: 0 
[ 3676.249630] hardirqs last  enabled at (0): [<0000000000000000>] 0x0 
[ 3676.279149] hardirqs last disabled at (0): [<ffffffffad5b045b>]
copy_process.part.33+0x187b/0x5e40 
[ 3676.321474] softirqs last  enabled at (0): [<ffffffffad5b04f7>]
copy_process.part.33+0x1917/0x5e40 
[ 3676.363493] softirqs last disabled at (0): [<0000000000000000>] 0x0 
[ 3676.393505] ---[ end trace 51bdc5e7fcb8f553 ]--- 
[ 3676.416166] XFS (dm-0): Internal error XFS_WANT_CORRUPTED_RETURN at line
1529 of file fs/xfs/libxfs/xfs_ialloc.c.  Caller xfs_dialloc_ag+0x3ff/0x6a0
[xfs] 
[ 3676.484269] CPU: 8 PID: 19166 Comm: fsstress Tainted: G    B   W        
5.2.0-rc4+ #1 
[ 3676.521635] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015 
[ 3676.552486] Call Trace: 
[ 3676.563989]  dump_stack+0x7c/0xc0 
[ 3676.579620]  xfs_dialloc_ag_update_inobt+0x2e8/0x500 [xfs] 
[ 3676.605548]  ? xfs_dialloc_ag_finobt_newino.isra.12+0x560/0x560 [xfs] 
[ 3676.635924]  ? kmem_zone_alloc+0x6c/0x120 [xfs] 
[ 3676.657042]  ? xfs_inobt_init_cursor+0x7e/0x520 [xfs] 
[ 3676.680967]  xfs_dialloc_ag+0x3ff/0x6a0 [xfs] 
[ 3676.701420]  ? xfs_dialloc_ag_inobt+0x1420/0x1420 [xfs] 
[ 3676.725958]  ? xfs_perag_put+0x26e/0x390 [xfs] 
[ 3676.746890]  ? xfs_ialloc_read_agi+0x1fb/0x560 [xfs] 
[ 3676.770395]  ? xfs_perag_put+0x26e/0x390 [xfs] 
[ 3676.791359]  xfs_dialloc+0xf4/0x6a0 [xfs] 
[ 3676.810064]  ? xfs_ialloc_ag_select+0x4a0/0x4a0 [xfs] 
[ 3676.833401]  ? save_stack+0x4d/0x80 
[ 3676.849513]  ? save_stack+0x19/0x80 
[ 3676.865512]  ? __kasan_kmalloc.constprop.6+0xc1/0xd0 
[ 3676.888939]  ? kmem_cache_alloc+0xf4/0x320 
[ 3676.909702]  ? kmem_zone_alloc+0x6c/0x120 [xfs] 
[ 3676.934091]  ? xfs_trans_alloc+0x44/0x630 [xfs] 
[ 3676.956527]  ? xfs_generic_create+0x38e/0x4b0 [xfs] 
[ 3676.980830]  ? lookup_open+0xed9/0x1990 
[ 3676.998959]  ? path_openat+0xb33/0x2a60 
[ 3677.017132]  ? do_filp_open+0x17c/0x250 
[ 3677.035327]  ? do_sys_open+0x1d9/0x360 
[ 3677.053125]  xfs_ialloc+0xfa/0x1c10 [xfs] 
[ 3677.072140]  ? xfs_iunlink_free_item+0x60/0x60 [xfs] 
[ 3677.096825]  ? xlog_grant_head_check+0x187/0x430 [xfs] 
[ 3677.120704]  ? xlog_grant_head_wait+0xaa0/0xaa0 [xfs] 
[ 3677.144190]  ? xlog_grant_add_space.isra.14+0x85/0x100 [xfs] 
[ 3677.170450]  xfs_dir_ialloc+0x135/0x630 [xfs] 
[ 3677.192303]  ? __percpu_counter_compare+0x86/0xe0 
[ 3677.214719]  ? xfs_lookup+0x490/0x490 [xfs] 
[ 3677.234578]  ? lock_acquire+0x142/0x380 
[ 3677.252628]  ? lock_contended+0xd50/0xd50 
[ 3677.271669]  xfs_create+0x5bc/0x1320 [xfs] 
[ 3677.291990]  ? xfs_dir_ialloc+0x630/0x630 [xfs] 
[ 3677.313421]  ? get_cached_acl+0x23a/0x390 
[ 3677.332536]  ? set_posix_acl+0x250/0x250 
[ 3677.351094]  ? get_acl+0x18/0x1f0 
[ 3677.366715]  xfs_generic_create+0x38e/0x4b0 [xfs] 
[ 3677.388901]  ? lock_downgrade+0x620/0x620 
[ 3677.407885]  ? lock_contended+0xd50/0xd50 
[ 3677.427663]  ? xfs_setup_iops+0x420/0x420 [xfs] 
[ 3677.450633]  ? do_raw_spin_unlock+0x54/0x220 
[ 3677.471607]  ? _raw_spin_unlock+0x24/0x30 
[ 3677.491544]  ? d_splice_alias+0x417/0xb50 
[ 3677.511952]  ? xfs_vn_lookup+0x156/0x190 [xfs] 
[ 3677.532896]  ? selinux_capable+0x20/0x20 
[ 3677.551382]  ? from_kgid+0x83/0xc0 
[ 3677.567407]  lookup_open+0xed9/0x1990 
[ 3677.584749]  ? path_init+0x10f0/0x10f0 
[ 3677.602514]  ? lock_downgrade+0x620/0x620 
[ 3677.621511]  path_openat+0xb33/0x2a60 
[ 3677.638854]  ? getname_flags+0xba/0x510 
[ 3677.657089]  ? path_mountpoint+0xab0/0xab0 
[ 3677.676373]  ? kasan_init_slab_obj+0x20/0x30 
[ 3677.696714]  ? new_slab+0x326/0x630 
[ 3677.713198]  ? ___slab_alloc+0x3e3/0x5e0 
[ 3677.731229]  do_filp_open+0x17c/0x250 
[ 3677.747756]  ? may_open_dev+0xc0/0xc0 
[ 3677.765138]  ? __check_object_size+0x25f/0x346 
[ 3677.785750]  ? do_raw_spin_unlock+0x54/0x220 
[ 3677.805102]  ? _raw_spin_unlock+0x24/0x30 
[ 3677.823094]  do_sys_open+0x1d9/0x360 
[ 3677.839645]  ? filp_open+0x50/0x50 
[ 3677.855954]  do_syscall_64+0x9f/0x4d0 
[ 3677.873228]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[ 3677.897383] RIP: 0033:0x7fab879bb5e8 
[ 3677.914515] Code: 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3
0f 1e fa 48 8d 05 35 51 2d 00 8b 00 85 c0 75 17 b8 55 00 00 00 0f 05 <48> 3d 00
f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 55 89 f5 53 48 89 
[ 3678.005389] RSP: 002b:00007ffe5e603e98 EFLAGS: 00000246 ORIG_RAX:
0000000000000055 
[ 3678.041628] RAX: ffffffffffffffda RBX: 00007ffe5e607298 RCX:
00007fab879bb5e8 
[ 3678.075514] RDX: 000000000040ce46 RSI: 00000000000001b6 RDI:
00007ffe5e603eb6 
[ 3678.109193] RBP: 0000000000000007 R08: 0000000000000000 R09:
00007ffe5e603c44 
[ 3678.142727] R10: fffffffffffffe05 R11: 0000000000000246 R12:
0000000000000001 
[ 3678.176442] R13: 00007ffe5e608608 R14: 0000000000000000 R15:
0000000000000000 
[ 3678.210096] XFS (dm-0): Internal error xfs_trans_cancel at line 1051 of file
fs/xfs/xfs_trans.c.  Caller xfs_create+0x5db/0x1320 [xfs] 
[ 3678.267017] CPU: 8 PID: 19166 Comm: fsstress Tainted: G    B   W        
5.2.0-rc4+ #1 
[ 3678.304486] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015 
[ 3678.335484] Call Trace: 
[ 3678.347211]  dump_stack+0x7c/0xc0 
[ 3678.362941]  xfs_trans_cancel+0x404/0x540 [xfs] 
[ 3678.384517]  ? xfs_create+0x5db/0x1320 [xfs] 
[ 3678.404810]  xfs_create+0x5db/0x1320 [xfs] 
[ 3678.424039]  ? xfs_dir_ialloc+0x630/0x630 [xfs] 
[ 3678.445491]  ? get_cached_acl+0x23a/0x390 
[ 3678.465373]  ? set_posix_acl+0x250/0x250 
[ 3678.484604]  ? get_acl+0x18/0x1f0 
[ 3678.501131]  xfs_generic_create+0x38e/0x4b0 [xfs] 
[ 3678.524394]  ? lock_downgrade+0x620/0x620 
[ 3678.544411]  ? lock_contended+0xd50/0xd50 
[ 3678.563513]  ? xfs_setup_iops+0x420/0x420 [xfs] 
[ 3678.585377]  ? do_raw_spin_unlock+0x54/0x220 
[ 3678.605561]  ? _raw_spin_unlock+0x24/0x30 
[ 3678.624534]  ? d_splice_alias+0x417/0xb50 
[ 3678.643473]  ? xfs_vn_lookup+0x156/0x190 [xfs] 
[ 3678.664364]  ? selinux_capable+0x20/0x20 
[ 3678.683024]  ? from_kgid+0x83/0xc0 
[ 3678.699042]  lookup_open+0xed9/0x1990 
[ 3678.716242]  ? path_init+0x10f0/0x10f0 
[ 3678.733905]  ? lock_downgrade+0x620/0x620 
[ 3678.752998]  path_openat+0xb33/0x2a60 
[ 3678.770354]  ? getname_flags+0xba/0x510 
[ 3678.788441]  ? path_mountpoint+0xab0/0xab0 
[ 3678.807602]  ? kasan_init_slab_obj+0x20/0x30 
[ 3678.827795]  ? new_slab+0x326/0x630 
[ 3678.844374]  ? ___slab_alloc+0x3e3/0x5e0 
[ 3678.862756]  do_filp_open+0x17c/0x250 
[ 3678.880089]  ? may_open_dev+0xc0/0xc0 
[ 3678.897937]  ? __check_object_size+0x25f/0x346 
[ 3678.918993]  ? do_raw_spin_unlock+0x54/0x220 
[ 3678.939234]  ? _raw_spin_unlock+0x24/0x30 
[ 3678.958169]  do_sys_open+0x1d9/0x360 
[ 3678.974662]  ? filp_open+0x50/0x50 
[ 3678.991695]  do_syscall_64+0x9f/0x4d0 
[ 3679.009953]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[ 3679.035227] RIP: 0033:0x7fab879bb5e8 
[ 3679.053006] Code: 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3
0f 1e fa 48 8d 05 35 51 2d 00 8b 00 85 c0 75 17 b8 55 00 00 00 0f 05 <48> 3d 00
f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 55 89 f5 53 48 89 
[ 3679.142262] RSP: 002b:00007ffe5e603e98 EFLAGS: 00000246 ORIG_RAX:
0000000000000055 
[ 3679.178078] RAX: ffffffffffffffda RBX: 00007ffe5e607298 RCX:
00007fab879bb5e8 
[ 3679.212063] RDX: 000000000040ce46 RSI: 00000000000001b6 RDI:
00007ffe5e603eb6 
[ 3679.245500] RBP: 0000000000000007 R08: 0000000000000000 R09:
00007ffe5e603c44 
[ 3679.278839] R10: fffffffffffffe05 R11: 0000000000000246 R12:
0000000000000001 
[ 3679.312393] R13: 00007ffe5e608608 R14: 0000000000000000 R15:
0000000000000000 
[ 3679.346558] XFS (dm-0): log I/O error -5 
[ 3679.366619] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1235 of
file fs/xfs/xfs_log.c. Return address = 0000000056321ec9 
[ 3679.378219] Buffer I/O error on dev dm-0, logical block 31457152, async page
read 
[ 3679.422619] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
[ 3679.457704] Buffer I/O error on dev dm-0, logical block 31457153, async page
read 
[ 3679.489606] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s) 
[ 3679.563351] Buffer I/O error on dev dm-0, logical block 31457154, async page
read 
[ 3679.600812] Buffer I/O error on dev dm-0, logical block 31457155, async page
read 
[ 3679.636355] Buffer I/O error on dev dm-0, logical block 31457156, async page
read 
[ 3679.671882] Buffer I/O error on dev dm-0, logical block 31457157, async page
read 
[ 3679.707456] Buffer I/O error on dev dm-0, logical block 31457158, async page
read 
[ 3679.743268] Buffer I/O error on dev dm-0, logical block 31457159, async page
read 
[ 3679.957782] XFS (dm-0): Unmounting Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
