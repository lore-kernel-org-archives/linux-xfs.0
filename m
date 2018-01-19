Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751548AbeASIHz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jan 2018 03:07:55 -0500
Date: Fri, 19 Jan 2018 16:07:53 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v4 2/3] xfs/realtime: Default rtinherit=1, add
 _require_no_rtinherit function
Message-ID: <20180119080753.GY3102@eguan.usersys.redhat.com>
References: <20180112041619.540900-1-rwareing@fb.com>
 <20180112041619.540900-3-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180112041619.540900-3-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: fstests@vger.kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 08:16:18PM -0800, Richard Wareing wrote:
> To better exercise the data path code of realtime subvolumes, we will
> set rtinherit=1 during mkfs calls.  For tests which this is not desired
> we introduce a _require_no_rtinherit function to opt out of this
> behavior.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>

BTW, generic/256 triggered xfs shutdown with rtdev enabled and
MKFS_OPTIONS="-d rtinherit".

Thanks,
Eryu

[59132.903870] XFS (vda6): _xfs_buf_find: Block out of range: block 0xc00000003fff0, EOFS 0x300000
[59132.904675] WARNING: CPU: 3 PID: 1199 at fs/xfs/xfs_buf.c:590 _xfs_buf_find+0x3e8/0x520 [xfs]
[59132.905352] Modules linked in: xfs dm_delay dm_thin_pool dm_persistent_data dm_bio_prison sd_mod sg dm_snapshot dm_bufio dm_flakey loop dm_mod ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter sunrpc btrfs xor zstd_decompress zstd_compress xxhash raid6_pq i2c_piix4 i2c_core virtio_balloon joydev pcspkr ip_tables ext4 mbcache jbd2 ata_generic pata_acpi virtio_net virtio_blk ata_piix libata virtio_pci virtio_ring virtio
[59132.905607]  serio_raw floppy [last unloaded: scsi_debug]
[59132.905607] CPU: 3 PID: 1199 Comm: xfs_io Tainted: G        W        4.15.0-rc6 #28
[59132.905607] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[59132.905607] RIP: 0010:_xfs_buf_find+0x3e8/0x520 [xfs]
[59132.905607] RSP: 0018:ffff9eb8c1d83718 EFLAGS: 00010246
[59132.905607] RAX: 0000000000000000 RBX: ffff9eb8c1d83878 RCX: 0000000000000000
[59132.905607] RDX: ffff9eb8c1d83638 RSI: 000000000000000a RDI: ffffffffc0758ebb
[59132.905607] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000021
[59132.905607] R10: 0000000000000000 R11: 000000000000000a R12: ffff93846fb19b40
[59132.905607] R13: ffff93846fb19b40 R14: 0000000000000001 R15: ffff9eb8c1d83878
[59132.905607] FS:  00007f8cb01ea740(0000) GS:ffff93849fd80000(0000) knlGS:0000000000000000
[59132.905607] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[59132.905607] CR2: 00007f8caf9eefb8 CR3: 0000000215749000 CR4: 00000000000006e0
[59132.905607] Call Trace:
[59132.905607]  ? _cond_resched+0x15/0x30
[59132.905607]  xfs_buf_get_map+0x23/0x260 [xfs]
[59132.905607]  xfs_buf_read_map+0x29/0x180 [xfs]
[59132.905607]  xfs_trans_read_buf_map+0xec/0x300 [xfs]
[59132.905607]  xfs_rtbuf_get+0xf5/0x130 [xfs]
[59132.905607]  xfs_rtcheck_range+0x10a/0x300 [xfs]
[59132.905607]  xfs_rtallocate_extent_block+0x137/0x240 [xfs]
[59132.905607]  xfs_rtallocate_extent_near+0x287/0x390 [xfs]
[59132.905607]  ? up+0x12/0x46
[59132.905607]  ? xfs_buf_rele+0x5b/0x390 [xfs]
[59132.905607]  xfs_rtallocate_extent+0x121/0x1b0 [xfs]
[59132.905607]  xfs_bmap_rtalloc+0x180/0x2b0 [xfs]
[59132.905607]  xfs_bmapi_write+0x5dc/0xce0 [xfs]
[59132.905607]  ? lookup_fast+0xcb/0x2b0
[59132.905607]  xfs_alloc_file_space+0x15a/0x3a0 [xfs]
[59132.905607]  ? account_entity_enqueue+0xc5/0xf0
[59132.905607]  xfs_file_fallocate+0x1e2/0x330 [xfs]
[59132.905607]  ? check_preempt_curr+0x74/0xa0
[59132.905607]  ? wake_up_new_task+0x1c4/0x280
[59132.905607]  vfs_fallocate+0x151/0x270
[59132.905607]  SyS_fallocate+0x3f/0x60
[59132.905607]  do_syscall_64+0x61/0x1a0
[59132.905607]  entry_SYSCALL64_slow_path+0x25/0x25
[59132.905607] RIP: 0033:0x7f8cafae47e0
[59132.905607] RSP: 002b:00007ffd3ad5eb50 EFLAGS: 00000293 ORIG_RAX: 000000000000011d
[59132.905607] RAX: ffffffffffffffda RBX: 000000000000011d RCX: 00007f8cafae47e0
[59132.905607] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
[59132.905607] RBP: 0000000001111130 R08: 0000000000000000 R09: 00000000011123e2
[59132.905607] R10: 0000000010000000 R11: 0000000000000293 R12: 0000000000000000
[59132.905607] R13: 00000000011127c0 R14: 0000000000000001 R15: 0000000000000000
[59132.905607] Code: 48 89 de ff d0 49 8b 45 00 48 85 c0 75 e5 e9 57 ff ff ff 48 89 c1 48 c7 c2 c0 56 75 c0 48 c7 c6 80 c7 75 c0 31 c0 e8 68 89 01 00 <0f> ff 31 c0 e9 74 ff ff ff 39 ca 0f 82 56 fe ff ff 48 8b 4c 24
[59132.905607] ---[ end trace 2525be156b26eb0c ]---
