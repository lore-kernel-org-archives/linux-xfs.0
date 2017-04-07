Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752887AbdDGHUb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 03:20:31 -0400
Date: Fri, 7 Apr 2017 15:20:29 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: actually report xattr extents via iomap
Message-ID: <20170407072029.GR22845@eguan.usersys.redhat.com>
References: <20170406160356.GY4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170406160356.GY4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Thu, Apr 06, 2017 at 09:03:56AM -0700, Darrick J. Wong wrote:
> Apparently FIEMAP for xattrs has been broken since we switched to
> the iomap backend because of an incorrect check for xattr presence.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 288ee5b..4f118a1 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1173,7 +1173,7 @@ xfs_xattr_iomap_begin(
>  	lockmode = xfs_ilock_data_map_shared(ip);
>  
>  	/* if there are no attribute fork or extents, return ENOENT */
> -	if (XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
> +	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
>  		error = -ENOENT;
>  		goto out_unlock;
>  	}

Surprisingly, after applying this patch on top of 4.11-rc4 kernel, your
test case crashed debug built XFS when testing with 512b block fs, XFS
with other block sizes passed the test.

The three new patches from tags/xfs-4.11-fixes-3 won't help either.

Thanks,
Eryu

[  188.954656] run fstests generic/425 at 2017-04-07 14:51:54
[  189.311170] XFS (sdc2): Unmounting Filesystem
[  189.488020] XFS (sdc2): Mounting V4 Filesystem
[  189.533595] XFS (sdc2): Ending clean mount
[  189.669876] XFS (sdc2): Unmounting Filesystem
[  189.689625] XFS (sdc2): Mounting V4 Filesystem
[  189.768990] XFS (sdc2): Ending clean mount
[  189.780954] XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_inode_fork.c, line: 501
[  189.791575] ------------[ cut here ]------------
[  189.796191] kernel BUG at fs/xfs/xfs_message.c:113!
[  189.801067] invalid opcode: 0000 [#1] SMP
[  189.805074] Modules linked in: xfs(OE) binfmt_misc ip6t_rpfilter ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack libcrc32c ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_mangle ip6table_security ip6table_raw iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter btrfs intel_powerclamp coretemp kvm_intel xor kvm raid6_pq irqbypass crc32_pclmul ghash_clmulni_intel iTCO_wdt pcbc iTCO_vendor_support aesni_intel cdc_ether crypto_simd lpc_ich usbnet glue_helper cryptd mii pcspkr mfd_core i7core_edac i2c_i801 nfsd ipmi_si sg ipmi_devintf shpchp edac_core ioatdma ipmi_msghandler dca acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc
[  189.875423]  ip_tables ext4 jbd2 mbcache sr_mod cdrom sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect ata_generic sysimgblt pata_acpi fb_sys_fops ttm drm ata_piix libata crc32c_intel megaraid_sas i2c_core bnx2 dm_mirror dm_region_hash dm_log dm_mod [last unloaded: xfs]
[  189.900855] CPU: 1 PID: 12226 Comm: xfs_io Tainted: G           OE   4.11.0-rc4 #82
[  189.908500] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[  189.918226] task: ffff880279460000 task.stack: ffffc90002340000
[  189.924198] RIP: 0010:assfail+0x22/0x30 [xfs]
[  189.928553] RSP: 0018:ffffc90002343c00 EFLAGS: 00010282
[  189.933775] RAX: 00000000ffffffea RBX: ffff88016fe4ad00 RCX: 0000000000000021
[  189.940901] RDX: ffffc90002343b28 RSI: 000000000000000a RDI: ffffffffa0a73fb2
[  189.948028] RBP: ffffc90002343c00 R08: 0000000000000000 R09: 0000000000000000
[  189.955154] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000005
[  189.962281] R13: 0000000000000001 R14: ffff8802767cc000 R15: 0000000000000000
[  189.969408] FS:  00007f1cbd156740(0000) GS:ffff88017ba40000(0000) knlGS:0000000000000000
[  189.977489] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  189.983228] CR2: 00007f1cbd162000 CR3: 0000000179ce1000 CR4: 00000000000006e0
[  189.990354] Call Trace:
[  189.992836]  xfs_iread_extents+0x164/0x170 [xfs]
[  189.997477]  xfs_bmapi_read+0x187/0x3b0 [xfs]
[  190.001867]  ? xfs_ilock+0xf1/0x1f0 [xfs]
[  190.005911]  xfs_xattr_iomap_begin+0xbe/0x170 [xfs]
[  190.010790]  ? __alloc_pages_nodemask+0x11d/0x250
[  190.015494]  iomap_apply+0x58/0x100
[  190.018983]  iomap_fiemap+0xa7/0xf0
[  190.022473]  ? iomap_write_actor+0x170/0x170
[  190.026776]  xfs_vn_fiemap+0x5c/0x80 [xfs]
[  190.030873]  do_vfs_ioctl+0x409/0x5b0
[  190.034534]  SyS_ioctl+0x79/0x90
[  190.037767]  do_syscall_64+0x67/0x180
[  190.041431]  entry_SYSCALL64_slow_path+0x25/0x25
[  190.046044] RIP: 0033:0x7f1cbca56507
[  190.049618] RSP: 002b:00007ffd2ef2a358 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  190.057178] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f1cbca56507
[  190.064308] RDX: 0000000002020600 RSI: 00000000c020660b RDI: 0000000000000003
[  190.071434] RBP: 0000000000000005 R08: 00007f1cbc9b0938 R09: 0000000000000017
[  190.078560] R10: 00007ffd2ef2a0e0 R11: 0000000000000246 R12: 0000000000000000
[  190.085685] R13: 000000000201f8b0 R14: cccccccccccccccd R15: 0000000002020600
[  190.092813] Code: 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 98 04 a8 a0 48 89 fa 31 c0 48 89 e5 31 ff e8 ce f9 ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48
[  190.111699] RIP: assfail+0x22/0x30 [xfs] RSP: ffffc90002343c00
[  190.117558] ---[ end trace e3b5a0987ffe392b ]---
