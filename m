Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25825 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdC0RSS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 13:18:18 -0400
Date: Mon, 27 Mar 2017 10:17:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [4.11-rc3 BUG] xfs/348 crashes debug kernel
Message-ID: <20170327171734.GH5738@birch.djwong.org>
References: <20170320142251.GP14226@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170320142251.GP14226@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 20, 2017 at 10:22:51PM +0800, Eryu Guan wrote:
> Hi,
> 
> I noticed xfs/348 could crash xfs debug build starting from 4.11-rc3,
> and test failed on non-debug build xfs, and the only xfs patch in -rc3
> is 630a04e79, reverting it "fixed" the crash for me.
> 
> commit 630a04e79dd41ff746b545d4fc052e0abb836120
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Wed Mar 15 00:24:25 2017 -0700
> 
>     xfs: verify inline directory data forks
> 
> I appended the console log of the crash and test failure diff at the end
> of email. If you need more information please let me knwo.

I sent a new patch to the ML to fix the problems with this patch.
All the assert failures should be gone now.

--D

> 
> Thanks,
> Eryu
> 
> P.S. 1: console log of the crash
> [  288.117462] XFS (sdc2): Invalid inode number 0x74312f74657374
> [  288.123269] XFS (sdc2): Internal error xfs_dir_ino_validate at line 225 of file fs/xfs/libxfs/xfs_dir2.c.  Caller xfs_dir2_sf_verify+0x75/0x3b0 [xfs]
> [  288.136649] CPU: 0 PID: 22059 Comm: stat Tainted: G           OE   4.11.0-rc3 #81
> [  288.144124] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
> [  288.153852] Call Trace:
> [  288.156304]  dump_stack+0x63/0x87
> [  288.159651]  xfs_error_report+0x3b/0x40 [xfs]
> [  288.164033]  ? xfs_dir2_sf_verify+0x75/0x3b0 [xfs]
> [  288.168849]  xfs_dir_ino_validate+0x89/0x110 [xfs]
> [  288.173666]  xfs_dir2_sf_verify+0x75/0x3b0 [xfs]
> [  288.178283]  ? crc32c_pcl_intel_update+0x2d/0x70 [crc32c_intel]
> [  288.184229]  xfs_iformat_local+0x19c/0x1d0 [xfs]
> [  288.188875]  xfs_iformat_fork+0x2c0/0x630 [xfs]
> [  288.193433]  ? xfs_inode_from_disk+0x35/0x230 [xfs]
> [  288.198339]  xfs_iread+0x37a/0x430 [xfs]
> [  288.202294]  xfs_iget+0x331/0x8b0 [xfs]
> [  288.206155]  ? xfs_dir_lookup+0x14d/0x1c0 [xfs]
> [  288.210716]  xfs_lookup+0xc6/0xe0 [xfs]
> [  288.214583]  xfs_vn_lookup+0x52/0x90 [xfs]
> [  288.218681]  lookup_slow+0x8f/0x130
> [  288.222169]  walk_component+0x19a/0x210
> [  288.226004]  ? path_init+0x1f6/0x340
> [  288.229580]  path_lookupat+0x4e/0x100
> [  288.233240]  filename_lookup+0x9c/0x150
> [  288.237077]  ? filemap_map_pages+0x32e/0x380
> [  288.241347]  ? kmem_cache_alloc+0x137/0x190
> [  288.245527]  ? getname_flags+0x4f/0x1f0
> [  288.249362]  user_path_at_empty+0x36/0x40
> [  288.253369]  vfs_statx+0x68/0xc0
> [  288.256597]  SYSC_newlstat+0x2b/0x50
> [  288.260174]  ? __audit_syscall_entry+0xaf/0x100
> [  288.264703]  ? syscall_trace_enter+0x1b7/0x290
> [  288.269147]  ? vtime_delta+0x23/0x30
> [  288.272723]  SyS_newlstat+0xe/0x10
> [  288.276125]  do_syscall_64+0x67/0x180
> [  288.279786]  entry_SYSCALL64_slow_path+0x25/0x25
> [  288.284403] RIP: 0033:0x7f5669380615
> [  288.287979] RSP: 002b:00007ffed137e3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
> [  288.295542] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f5669380615
> [  288.302669] RDX: 00007ffed137e430 RSI: 00007ffed137e430 RDI: 00007ffed1380874
> [  288.309798] RBP: 00007ffed1380871 R08: 0000000000000000 R09: 00007ffed1380874
> [  288.316925] R10: 00007ffed137e180 R11: 0000000000000246 R12: 0000000000000000
> [  288.324052] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000002
> [  288.331207] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_dir2_sf.c, line: 664
> [  288.339449] ------------[ cut here ]------------
> [  288.344066] kernel BUG at fs/xfs/xfs_message.c:113!
> [  288.348939] invalid opcode: 0000 [#1] SMP
> [  288.352946] Modules linked in: xfs(OE) binfmt_misc ip6t_rpfilter ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack libcrc32c ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_mangle ip6table_security ip6table_raw iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter btrfs intel_powerclamp coretemp xor kvm_intel kvm raid6_pq irqbypass crc32_pclmul ghash_clmulni_intel pcbc aesni_intel iTCO_wdt crypto_simd iTCO_vendor_support glue_helper cdc_ether ipmi_si usbnet cryptd lpc_ich pcspkr mii ipmi_devintf mfd_core i2c_i801 sg i7core_edac ipmi_msghandler ioatdma shpchp edac_core acpi_cpufreq dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc
> [  288.423302]  ip_tables ext4 jbd2 mbcache sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ata_generic pata_acpi drm ata_piix libata crc32c_intel megaraid_sas i2c_core bnx2 dm_mirror dm_region_hash dm_log dm_mod [last unloaded: xfs]
> [  288.448736] CPU: 0 PID: 22059 Comm: stat Tainted: G           OE   4.11.0-rc3 #81
> [  288.456212] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
> [  288.465940] task: ffff880274e6a440 task.stack: ffffc90008628000
> [  288.471889] RIP: 0010:assfail+0x22/0x30 [xfs]
> [  288.476241] RSP: 0018:ffffc9000862b9c0 EFLAGS: 00010282
> [  288.481463] RAX: 00000000ffffffea RBX: 00000000ffffffff RCX: 0000000000000021
> [  288.488589] RDX: ffffc9000862b8e8 RSI: 000000000000000a RDI: ffffffffa0909fb2
> [  288.495715] RBP: ffffc9000862b9c0 R08: 0000000000000000 R09: 0000000000000000
> [  288.502842] R10: 000000000000000a R11: f000000000000000 R12: ffffffffa09039c0
> [  288.509969] R13: ffff880274aadcb0 R14: 0000000000000000 R15: 0000000000000200
> [  288.517098] FS:  00007f5669a90800(0000) GS:ffff88017ba00000(0000) knlGS:0000000000000000
> [  288.525180] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  288.530920] CR2: 00007f56693741a0 CR3: 00000001747c0000 CR4: 00000000000006f0
> [  288.538047] Call Trace:
> [  288.540523]  xfs_dir2_sf_verify+0x329/0x3b0 [xfs]
> [  288.545226]  ? crc32c_pcl_intel_update+0x2d/0x70 [crc32c_intel]
> [  288.551170]  xfs_iformat_local+0x19c/0x1d0 [xfs]
> [  288.555816]  xfs_iformat_fork+0x2c0/0x630 [xfs]
> [  288.560375]  ? xfs_inode_from_disk+0x35/0x230 [xfs]
> [  288.565278]  xfs_iread+0x37a/0x430 [xfs]
> [  288.569235]  xfs_iget+0x331/0x8b0 [xfs]
> [  288.573096]  ? xfs_dir_lookup+0x14d/0x1c0 [xfs]
> [  288.577656]  xfs_lookup+0xc6/0xe0 [xfs]
> [  288.581523]  xfs_vn_lookup+0x52/0x90 [xfs]
> [  288.585620]  lookup_slow+0x8f/0x130
> [  288.589108]  walk_component+0x19a/0x210
> [  288.592942]  ? path_init+0x1f6/0x340
> [  288.596519]  path_lookupat+0x4e/0x100
> [  288.600179]  filename_lookup+0x9c/0x150
> [  288.604013]  ? filemap_map_pages+0x32e/0x380
> [  288.608282]  ? kmem_cache_alloc+0x137/0x190
> [  288.612463]  ? getname_flags+0x4f/0x1f0
> [  288.616297]  user_path_at_empty+0x36/0x40
> [  288.620303]  vfs_statx+0x68/0xc0
> [  288.623533]  SYSC_newlstat+0x2b/0x50
> [  288.627109]  ? __audit_syscall_entry+0xaf/0x100
> [  288.631637]  ? syscall_trace_enter+0x1b7/0x290
> [  288.636079]  ? vtime_delta+0x23/0x30
> [  288.639654]  SyS_newlstat+0xe/0x10
> [  288.643057]  do_syscall_64+0x67/0x180
> [  288.646718]  entry_SYSCALL64_slow_path+0x25/0x25
> [  288.651333] RIP: 0033:0x7f5669380615
> [  288.654907] RSP: 002b:00007ffed137e3f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
> [  288.662470] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f5669380615
> [  288.669598] RDX: 00007ffed137e430 RSI: 00007ffed137e430 RDI: 00007ffed1380874
> [  288.676728] RBP: 00007ffed1380871 R08: 0000000000000000 R09: 00007ffed1380874
> [  288.683855] R10: 00007ffed137e180 R11: 0000000000000246 R12: 0000000000000000
> [  288.690982] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000002
> [  288.698110] Code: 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 98 64 91 a0 48 89 fa 31 c0 48 89 e5 31 ff e8 ce f9 ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48
> [  288.716996] RIP: assfail+0x22/0x30 [xfs] RSP: ffffc9000862b9c0
> [  288.722899] ---[ end trace 5b34e0235aa3bdf2 ]---
> 
> P.S. 2: diff output of test failure on non-debug build xfs
> --- /dev/fd/63	2017-03-20 09:14:03.306152055 -0400
> +++ results/xfs/348.out.bad	2017-03-20 09:14:02.754158081 -0400
> @@ -110,7 +110,7 @@
>  stat: 'SCRATCH_MNT/test/DIR' is a directory
>  stat: 'SCRATCH_MNT/test/DATA' is a directory
>  stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
> -stat: 'SCRATCH_MNT/test/SYMLINK' is a directory
> +stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
>  stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
>  stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
>  stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
