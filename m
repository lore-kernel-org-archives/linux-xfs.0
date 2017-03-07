Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:32917 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbdCGVgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 16:36:04 -0500
Received: by mail-qk0-f170.google.com with SMTP id y76so27579378qkb.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Mar 2017 13:36:03 -0800 (PST)
Message-ID: <1488922559.3877.6.camel@redhat.com>
Subject: WARNING: CPU: 2 PID: 20539 at fs/iomap.c:954
 iomap_dio_rw+0x39a/0x3b0
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 07 Mar 2017 16:35:59 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

I was doing an xfstests run on xfs with v4.11.0-rc1, and these two
warnings popped. Looks like invalidate_inode_pages2_range failed? A
small patch to print the error there showed that it was returning
-EBUSY.

Pretty easy to reproduce by running xfstests generic/095 on a KVM guest
running v4.11.0-rc1.

[  591.302422] run fstests generic/095 at 2017-03-07 15:38:32
[  591.452226] XFS (vda6): Unmounting Filesystem
[  591.825895] XFS (vda6): Mounting V5 Filesystem
[  591.841560] XFS (vda6): Ending clean mount
[  592.127155] ------------[ cut here ]------------
[  592.133775] WARNING: CPU: 2 PID: 20539 at fs/iomap.c:954 iomap_dio_rw+0x39a/0x3b0
[  592.145553] Modules linked in: loop dm_flakey binfmt_misc ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_broute bridge stp llc ebtable_nat ip6table_raw ip6table_security ip6table_mangle ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 iptable_raw iptable_security iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables crct10dif_pclmul crc32_pclmul ghash_clmulni_intel nfsd ppdev auth_rpcgss nfs_acl lockd joydev parport_pc pcspkr acpi_cpufreq virtio_balloon parport tpm_tis tpm_tis_core i2c_piix4 tpm grace sunrpc qemu_fw_cfg xfs libcrc32c qxl drm_kms_helper ttm virtio_net virtio_console virtio_blk drm floppy crc32c_intel virtio_pci serio_raw virtio_ring virtio ata_generic pata_acpi
[  592.158597] CPU: 2 PID: 20539 Comm: fio Not tainted 4.11.0-rc1 #17
[  592.159584] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
[  592.159584] Call Trace:
[  592.159584]  dump_stack+0x63/0x86
[  592.162726]  __warn+0xcb/0xf0
[  592.162726]  warn_slowpath_null+0x1d/0x20
[  592.162726]  iomap_dio_rw+0x39a/0x3b0
[  592.165653]  ? iomap_dio_zero+0x130/0x130
[  592.165653]  xfs_file_dio_aio_write+0xd0/0x240 [xfs]
[  592.165653]  xfs_file_write_iter+0x94/0x140 [xfs]
[  592.165653]  __vfs_write+0xe5/0x160
[  592.169128]  vfs_write+0xb5/0x1a0
[  592.169653]  SyS_pwrite64+0x95/0xb0
[  592.169653]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[  592.169653] RIP: 0033:0x7fe3e565e233
[  592.169653] RSP: 002b:00007fe3f9d06ea0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
[  592.175968] RAX: ffffffffffffffda RBX: 00007fe3f9d09a80 RCX: 00007fe3e565e233
[  592.179383] RDX: 0000000000000400 RSI: 0000000001804400 RDI: 0000000000000003
[  592.181797] RBP: 00007fffbfeba050 R08: 0000000000000000 R09: 00007fe3f9d09a80
[  592.181797] R10: 000000000001f800 R11: 0000000000000293 R12: 0000000000000000
[  592.181797] R13: 00007fffbfeb9f9f R14: 00007fe3f9d09d40 R15: 00007fe3f9d09a80
[  592.189085] ---[ end trace 2935e8d6d0b7a83e ]---
[  592.201657] ------------[ cut here ]------------
[  592.202828] WARNING: CPU: 0 PID: 20540 at fs/iomap.c:896 iomap_dio_rw+0x1b1/0x3b0
[  592.204118] Modules linked in: loop dm_flakey binfmt_misc ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_broute bridge stp llc ebtable_nat ip6table_raw ip6table_security ip6table_mangle ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 iptable_raw iptable_security iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables crct10dif_pclmul crc32_pclmul ghash_clmulni_intel nfsd ppdev auth_rpcgss nfs_acl lockd joydev parport_pc pcspkr acpi_cpufreq virtio_balloon parport tpm_tis tpm_tis_core i2c_piix4 tpm grace sunrpc qemu_fw_cfg xfs libcrc32c qxl drm_kms_helper ttm virtio_net virtio_console virtio_blk drm floppy crc32c_intel virtio_pci serio_raw virtio_ring virtio ata_generic pata_acpi
[  592.225076] CPU: 0 PID: 20540 Comm: fio Tainted: G        W       4.11.0-rc1 #17
[  592.226084] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
[  592.226084] Call Trace:
[  592.229035]  dump_stack+0x63/0x86
[  592.229035]  __warn+0xcb/0xf0
[  592.229035]  warn_slowpath_null+0x1d/0x20
[  592.229035]  iomap_dio_rw+0x1b1/0x3b0
[  592.233233]  ? inode_dio_wait+0xee/0x100
[  592.233233]  xfs_file_dio_aio_write+0xd0/0x240 [xfs]
[  592.233233]  xfs_file_write_iter+0x94/0x140 [xfs]
[  592.236035]  __vfs_write+0xe5/0x160
[  592.237032]  vfs_write+0xb5/0x1a0
[  592.237032]  SyS_pwrite64+0x95/0xb0
[  592.237032]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[  592.237032] RIP: 0033:0x7fe3e565e233
[  592.241138] RSP: 002b:00007fe3f9d08ea0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
[  592.241138] RAX: ffffffffffffffda RBX: 00007fe3f9d0ba80 RCX: 00007fe3e565e233
[  592.241138] RDX: 0000000000000400 RSI: 0000000001806c00 RDI: 0000000000000003
[  592.241138] RBP: 00007fffbfeba050 R08: 00007fe3f9d0ba80 R09: 00007fe3f9d0ba80
[  592.245393] R10: 000000000000a800 R11: 0000000000000293 R12: 0000000000000000
[  592.246611] R13: 00007fffbfeb9f9f R14: 00007fe3f9d0bd40 R15: 00007fe3f9d0ba80
[  592.249249] ---[ end trace 2935e8d6d0b7a83f ]---


-- 
Jeff Layton <jlayton@redhat.com>
