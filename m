Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4365C7F3F
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 11:37:33 -0600 (CST)
Date: Fri, 6 Dec 2013 11:37:29 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/7] extent list locking fixes V2
Message-ID: <20131206173729.GR1935@sgi.com>
References: <20131206164819.371654241@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206164819.371654241@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey Christoph,

On Fri, Dec 06, 2013 at 08:48:19AM -0800, Christoph Hellwig wrote:
> Fixed the review feedback, and includes Bens original patch for completeness.

I ran your initial series overnight with xfstests... oddly I hit this:

[16304.656687] XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: /root/xfs/fs/xfs/xfs_inode_fork.c, line: 434
[16304.668925] ------------[ cut here ]------------
[16304.674098] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:107!
[16304.674102] invalid opcode: 0000 [#1] SMP
[16304.674151] Modules linked in: xfs(OF) ext2(F) dm_flakey(F) crc32c(F) libcrc32c(F) autofs4(F) cpufreq_conservative(F) cpufreq_userspace(F) cpufreq_powersave(F) microcode(F) fuse(F) loop(F) dm_mod(F) joydev(F) hid_generic(F) usbhid(F) hid(F) ehci_pci(F) ehci_hcd(F) iTCO_wdt(F) sg(F) igb(F) iTCO_vendor_support(F) isci(F) ipv6(F) ptp(F) usbcore(F) ioatdma(F) libsas(F) lpc_ich(F) pcspkr(F) i2c_i801(F) sr_mod(F) mptctl(F) pps_core(F) usb_common(F) mfd_core(F) dca(F) cdrom(F) wmi(F) rtc_cmos(F) acpi_cpufreq(F) button(F) mgag200(F) ttm(F) drm_kms_helper(F) drm(F) i2c_algo_bit(F) sysimgblt(F) sysfillrect(F) i2c_core(F) syscopyarea(F) sd_mod(F) crc_t10dif(F) crct10dif_common(F) mpt2sas(F)
raid_class(F) scsi_dh_emc(F) scsi_dh_rdac(F) scsi_dh_alua(F) scsi_dh_hp_sw(F) scsi_dh(F) thermal(F) sata_nv(F) processor(F) piix(F) mptsas(F) mptscsih(F) scsi_transport_sas(F) mptbase(F) megaraid_sas(F) ide_generic(F) ide_core(F) fan(F) thermal_sys(F) hwmon(F) ext3(F) jbd(F) mbcache(F) edd(F) ata_piix(F) ahci(F) libahci(F) libata(F) scsi_mod(F) [last unloaded: scsi_debug]
[16304.674172] CPU: 13 PID: 12264 Comm: fsstress Tainted: GF         IO 3.13.0-rc2-0.9-default #28
[16304.674175] Hardware name: SGI.COM SUMMIT/S2600GZ, BIOS SE5C600.86B.01.06.0002.110120121539 11/01/2012
[16304.674183] task: ffff8807fd76c190 ti: ffff88082d02e000 task.ti: ffff88082d02e000
[16304.674231] RIP: 0010:[<ffffffffa072e2ed>]  [<ffffffffa072e2ed>] assfail+0x1d/0x30 [xfs]
[16304.674233] RSP: 0018:ffff88082d02f9d8  EFLAGS: 00010296
[16304.674235] RAX: 000000000000006c RBX: 0000000000000001 RCX: 0000000000000000
[16304.674236] RDX: ffff88043faeed68 RSI: ffff88043faed248 RDI: ffff88043faed248
[16304.674238] RBP: ffff88082d02f9d8 R08: 0000000000001a0c R09: 000000000000000d
[16304.674239] R10: 0000000000001a0c R11: 0000000000000006 R12: ffff88042a7eb800
[16304.674240] R13: 0000000000000001 R14: ffff88082d02fb54 R15: 0000000000000000
[16304.674243] FS:  00007fda2ff4d700(0000) GS:ffff88043fae0000(0000) knlGS:0000000000000000
[16304.674245] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16304.674246] CR2: 00007fda2f4a4b80 CR3: 000000082bf5e000 CR4: 00000000000407e0
[16304.674247] Stack:
[16304.674254]  ffff88082d02fa18 ffffffffa077c4fe ffff88043ffd9d80 0000000000000001
[16304.674258]  ffff88042a7eb800 ffff88042cd694f0 ffff88082d02fb54 0000000000000004
[16304.674263]  ffff88082d02fad8 ffffffffa07471f4 0000000000000000 000000012d6ca940
[16304.674263] Call Trace:
[16304.674308]  [<ffffffffa077c4fe>] xfs_iread_extents+0x4e/0x190 [xfs]
[16304.674346]  [<ffffffffa07471f4>] xfs_bmapi_read+0x264/0x3f0 [xfs]
[16304.674383]  [<ffffffffa075e601>] xfs_dabuf_map+0x281/0x300 [xfs]
[16304.674418]  [<ffffffffa075e789>] xfs_da_read_buf+0x59/0x2d0 [xfs]
[16304.674427]  [<ffffffff81160a55>] ? kmem_getpages+0xc5/0x170
[16304.674431]  [<ffffffff81161cf1>] ? cache_grow+0x171/0x240
[16304.674462]  [<ffffffffa075ea27>] xfs_da3_node_read+0x27/0xd0 [xfs]
[16304.674494]  [<ffffffffa075fed6>] xfs_da3_node_lookup_int+0x86/0x420 [xfs]
[16304.674498]  [<ffffffff81162bdb>] ? kmem_cache_alloc+0xbb/0x1f0
[16304.674532]  [<ffffffffa0736dae>] ? kmem_zone_alloc+0x7e/0xf0 [xfs]
[16304.674565]  [<ffffffffa073d1c8>] xfs_attr_node_get+0x78/0x170 [xfs]
[16304.674596]  [<ffffffffa073ee34>] xfs_attr_get_int+0xb4/0x110 [xfs]
[16304.674626]  [<ffffffffa073f108>] xfs_attr_get+0xa8/0xc0 [xfs]
[16304.674661]  [<ffffffffa07a1577>] xfs_get_acl+0x137/0x1a0 [xfs]
[16304.674667]  [<ffffffff8117d9c5>] check_acl+0x85/0x160
[16304.674671]  [<ffffffff8117db25>] generic_permission+0x85/0x130
[16304.674676]  [<ffffffff8117dc9c>] __inode_permission+0xcc/0xf0
[16304.674680]  [<ffffffff8117dcfd>] inode_permission+0x3d/0x60
[16304.674684]  [<ffffffff81170633>] SyS_chdir+0x43/0x100
[16304.674691]  [<ffffffff814c4ce2>] system_call_fastpath+0x16/0x1b
[16304.674718] Code: 00 00 00 48 89 45 c8 e8 42 fc ff ff c9 c3 55 41 89 d0 48 89 f1 48 89 fa 48 c7 c6 f0 5c 7b a0 31 ff 48 89 e5 31 c0 e8 93 ff ff ff <0f> 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b
[16304.674748] RIP  [<ffffffffa072e2ed>] assfail+0x1d/0x30 [xfs]
[16304.674749]  RSP <ffff88082d02f9d8>
[16304.724644] ---[ end trace eddfa0fb40bb8e11 ]---

...which shouldn't have been possible given the additional locking added
to xfs_attr_get.  Maybe some PEBKAC or something.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
