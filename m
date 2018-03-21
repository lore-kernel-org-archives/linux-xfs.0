Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751680AbeCUOmr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 10:42:47 -0400
Date: Wed, 21 Mar 2018 10:42:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: 4.15.7 xfs: xfs_inactive_ifree transaction log reservation
 overrun
Message-ID: <20180321144245.GF11127@bfoster.bfoster>
References: <CAGgND49YGL_d4hYqdBU8N8UuVRhdGBFKdcL=tNKqVoc9jE2KtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGgND49YGL_d4hYqdBU8N8UuVRhdGBFKdcL=tNKqVoc9jE2KtQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Henning Lohse <henning@quobyte.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 03:05:29PM +0100, Henning Lohse wrote:
> Hello,
> 
> I ran into the bug below twice using kernel 4.15.7.
> 
> Unfortunately, I'm unable to reproduce it via a simple script, but a
> certain workload on our application sometimes triggers the bug after a
> few hours.
> 
> I noticed in [1] that the bug might be considered rare. Please let me
> know if you need more info.
> 

It's difficult to reproduce directly because it may require just the
right allocation state for a subsequent operation to end up performing
too many allocation operations within a single inactive transaction.

I'm not sure what 4.15.7-1.el7.elrepo.x86_64 is, but I believe you want
commits 2c8f626539 ("xfs: print transaction log reservation on overrun")
through c017cb5ddf ("xfs: eliminate duplicate icreate tx reservation
functions") to fix up the reservation problems.

Brian

> [1] https://www.spinics.net/lists/linux-xfs/msg13308.html
> 
> Mar  7 13:48:47 henning kernel: WARNING: CPU: 44 PID: 5197 at
> fs/xfs/xfs_log_cil.c:466 xfs_log_commit_cil+0x5eb/0x660 [xfs]
> Mar  7 13:48:47 henning kernel: Modules linked in: xfs libcrc32c fuse
> bonding sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp
> kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_helper mgag200
> cryptd i2c_algo_bit ttm drm_kms_helper intel_cstate drm iTCO_wdt
> intel_rapl_perf syscopyarea iTCO_vendor_support ipmi_si sysfillrect
> mei_me ipmi_devintf lpc_ich sysimgblt dcdbas mxm_wmi fb_sys_fops
> pcspkr sg mei mfd_core ipmi_msghandler wmi tpm_crb acpi_power_meter
> shpchp tcp_westwood nfsd auth_rpcgss nfs_acl lockd grace ip_tables
> mlx4_en ext4 mbcache jbd2 ixgbe raid1 ahci dca sd_mod ptp
> scsi_transport_iscsi libahci pps_core mdio crc32c_intel libata
> mlx4_core megaraid_sas sunrpc dm_mirror dm_region_hash dm_log dm_mod
> dax
> Mar  7 13:48:47 henning kernel: CPU: 44 PID: 5197 Comm:
> device-11-stora Tainted: G        W        4.15.7-1.el7.elrepo.x86_64
> #1
> Mar  7 13:48:47 henning kernel: Hardware name: Dell Inc. PowerEdge
> C6320/082F9M, BIOS 2.4.2 01/09/2017
> Mar  7 13:48:47 henning kernel: RIP: 0010:xfs_log_commit_cil+0x5eb/0x660 [xfs]
> Mar  7 13:48:47 henning kernel: RSP: 0018:ffffc9002598fc78 EFLAGS: 00010282
> Mar  7 13:48:47 henning kernel: RAX: ffff8814adb672b0 RBX:
> ffff880f98c0fd60 RCX: 00000000fffff2dc
> Mar  7 13:48:47 henning kernel: RDX: 000000000001729c RSI:
> 000000000003f000 RDI: 0000000000000000
> Mar  7 13:48:47 henning kernel: RBP: ffffc9002598fd00 R08:
> ffffc9002598fccc R09: 0000000000001000
> Mar  7 13:48:47 henning kernel: R10: 0000000000000000 R11:
> 00000000000002ac R12: ffff880f98c0fcb0
> Mar  7 13:48:47 henning kernel: R13: ffff8810a2b0cb40 R14:
> 0000000000000000 R15: 0000000000004034
> Mar  7 13:48:47 henning kernel: FS:  00007fdf477f7700(0000)
> GS:ffff881fffd80000(0000) knlGS:0000000000000000
> Mar  7 13:48:47 henning kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> Mar  7 13:48:47 henning kernel: CR2: 0000556893570018 CR3:
> 0000001ff37b0001 CR4: 00000000003606e0
> Mar  7 13:48:47 henning kernel: DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Mar  7 13:48:47 henning kernel: DR3: 0000000000000000 DR6:
> 00000000fffe0ff0 DR7: 0000000000000400
> Mar  7 13:48:47 henning kernel: Call Trace:
> Mar  7 13:48:47 henning kernel: __xfs_trans_commit+0x128/0x230 [xfs]
> Mar  7 13:48:47 henning kernel: xfs_trans_commit+0x10/0x20 [xfs]
> Mar  7 13:48:47 henning kernel: xfs_inactive_ifree+0x187/0x230 [xfs]
> Mar  7 13:48:47 henning kernel: xfs_inactive+0x87/0x110 [xfs]
> Mar  7 13:48:47 henning kernel: xfs_fs_destroy_inode+0xa4/0x210 [xfs]
> Mar  7 13:48:47 henning kernel: destroy_inode+0x3b/0x60
> Mar  7 13:48:47 henning kernel: evict+0x142/0x1a0
> Mar  7 13:48:47 henning kernel: iput+0x17d/0x1d0
> Mar  7 13:48:47 henning kernel: do_unlinkat+0x187/0x2b0
> Mar  7 13:48:47 henning kernel: SyS_unlink+0x1f/0x30
> Mar  7 13:48:47 henning kernel: do_syscall_64+0x73/0x1b0
> Mar  7 13:48:47 henning kernel: entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Mar  7 13:48:47 henning kernel: RIP: 0033:0x7fe5a6333f77
> Mar  7 13:48:47 henning kernel: RSP: 002b:00007fdf477f66f8 EFLAGS:
> 00000206 ORIG_RAX: 0000000000000057
> Mar  7 13:48:47 henning kernel: RAX: ffffffffffffffda RBX:
> 00007fe0280ab6f8 RCX: 00007fe5a6333f77
> Mar  7 13:48:47 henning kernel: RDX: 00007fdf300013a0 RSI:
> 00007fdf477f6750 RDI: 00007fdf300013a0
> Mar  7 13:48:47 henning kernel: RBP: 00007fdf477f6710 R08:
> 00000000b991c89e R09: 00000000b991c891
> Mar  7 13:48:47 henning kernel: R10: 00007fe3d670b520 R11:
> 0000000000000206 R12: 0000000000000000
> Mar  7 13:48:47 henning kernel: R13: 00000000b991c8a6 R14:
> 00007fdf477f6750 R15: 00007fe0280ab4a0
> Mar  7 13:48:47 henning kernel: Code: 00 48 8b 45 b0 48 8d 93 c0 00 00
> 00 bf 00 20 00 00 48 8b 00 48 8b b0 80 09 00 00 e8 90 89 72 e0 eb a7
> e8 b9 f6 70 e0 44 89 5d c0 <0f> 0b 4c 8b 6d b0 31 c0 48 c7 c6 30 81 99
> a0 49 8b 7d 00 e8 5d
> Mar  7 13:48:47 henning kernel: ---[ end trace 150155e012a3b70e ]---
> Mar  7 13:48:47 henning kernel: XFS (sde): Transaction log reservation overrun:
> Mar  7 13:48:47 henning kernel: XFS (sde):   log items: 94876 bytes
> (iov hdrs: 684 bytes)
> Mar  7 13:48:47 henning kernel: XFS (sde):   split region headers: 0 bytes
> Mar  7 13:48:47 henning kernel: XFS (sde):   ctx ticket: 16436 bytes
> Mar  7 13:48:47 henning kernel: XFS (sde): transaction summary:
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x5
> Mar  7 13:48:47 henning kernel: XFS (sde): ticket reservation summary:
> Mar  7 13:48:47 henning kernel: XFS (sde):   unit res    = 107948 bytes
> Mar  7 13:48:47 henning kernel: XFS (sde):   current res = -3364 bytes
> Mar  7 13:48:47 henning kernel: XFS (sde):   total reg   = 0 bytes
> (o/flow = 0 bytes)
> Mar  7 13:48:47 henning kernel: XFS (sde):   ophdrs      = 0 (ophdr
> space = 0 bytes)
> Mar  7 13:48:47 henning kernel: XFS (sde):   ophdr + reg = 0 bytes
> Mar  7 13:48:47 henning kernel: XFS (sde):   num regions = 0
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x1237
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x0
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 1
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 112
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 32
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 32
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x4
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 32
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 00000000b62d2633: 37 12 01 00 01 00 00
> 00 80 2d 7a a4 0e 88 ff ff  7........-z.....
> Mar  7 13:48:47 henning kernel: 0000000052c1988b: 4c 56 e9 00 00 00 00
> 00 08 00 00 00 00 00 00 00  LV..............
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 256
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 152
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 152
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 0000000072a0edb9: 3c 12 02 00 00 28 08
> 00 08 00 00 00 00 00 00 00  <....(..........
> Mar  7 13:48:47 henning kernel: 000000000a921ee3: 01 00 00 00 01 00 00
> 00                          ........
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 128
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:47 henning kernel: 00000000a962719e: 58 41 47 46 00 00 00
> 01 00 00 00 00 01 bf 21 b6  XAGF..........!.
> Mar  7 13:48:47 henning kernel: 0000000091c5d9ff: 00 00 00 0a 00 00 00
> 08 00 00 00 00 00 00 00 02  ................
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 0000000038b5958a: 3c 12 02 00 00 20 08
> 00 10 f3 38 00 00 00 00 00  <.... ....8.....
> Mar  7 13:48:47 henning kernel: 00000000e03c8c8a: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:47 henning kernel: 0000000039ceecdc: 41 42 33 42 00 00 01
> 34 00 00 7a 4c 00 02 d3 41  AB3B...4..zL...A
> Mar  7 13:48:47 henning kernel: 0000000039e0bf7d: 00 00 00 00 00 38 f3
> 10 00 00 01 bd 00 02 a8 a0  .....8..........
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 000000005b23d4cc: 3c 12 02 00 00 20 08
> 00 40 00 00 00 00 00 00 00  <.... ..@.......
> Mar  7 13:48:47 henning kernel: 000000004dcc215d: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:47 henning kernel: 00000000679ecd2a: 41 42 33 43 00 01 01
> 43 ff ff ff ff ff ff ff ff  AB3C...C........
> Mar  7 13:48:47 henning kernel: 0000000038ecc3e5: 00 00 00 00 00 00 00
> 40 00 00 01 b3 00 00 9a 38  .......@.......8
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 2560
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 2456
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 2456
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 0000000062420aeb: 3c 12 02 00 00 20 08
> 00 90 0a 2e 00 00 00 00 00  <.... ..........
> Mar  7 13:48:47 henning kernel: 000000006edbe076: 01 00 00 00 ff ff 07
> 00                          ........
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 2432
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:47 henning kernel: 00000000b8bb5ce3: 41 42 33 43 00 00 00
> fc 00 07 27 ba 00 15 d7 24  AB3C......'....$
> Mar  7 13:48:47 henning kernel: 00000000ca012763: 00 00 00 00 00 2e 0a
> 90 00 00 01 bf 00 02 80 78  ...............x
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 000000006e49926d: 3c 12 02 00 00 20 08
> 00 80 0f 00 00 00 00 00 00  <.... ..........
> Mar  7 13:48:47 henning kernel: 00000000ac71b1ff: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:47 henning kernel: 00000000e00fbac1: 41 42 33 43 00 00 00
> fc 00 03 cd e3 00 00 13 73  AB3C...........s
> Mar  7 13:48:47 henning kernel: 00000000d40a6348: 00 00 00 00 00 00 0f
> 80 00 00 01 b3 00 00 9a 38  ...............8
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 00000000c09b39f8: 3c 12 02 00 00 20 08
> 00 98 9b 00 00 00 00 00 00  <.... ..........
> Mar  7 13:48:47 henning kernel: 0000000052e5dbc5: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:47 henning kernel: 000000002c2046ba: 41 42 33 43 00 00 01
> 2f 00 00 01 f0 00 06 cc df  AB3C.../........
> Mar  7 13:48:47 henning kernel: 0000000045e88793: 00 00 00 00 00 00 9b
> 98 00 00 01 bf 00 02 80 78  ...............x
> Mar  7 13:48:47 henning kernel: XFS (sde): log item:
> Mar  7 13:48:47 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:47 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:47 henning kernel: XFS (sde):   size#011= 3072
> Mar  7 13:48:47 henning kernel: XFS (sde):   bytes#011= 2968
> Mar  7 13:48:47 henning kernel: XFS (sde):   buf len#011= 2968
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:47 henning kernel: 00000000d9d96daa: 3c 12 02 00 00 20 08
> 00 c0 5e 49 00 00 00 00 00  <.... ...^I.....
> Mar  7 13:48:47 henning kernel: 00000000a18e93a5: 01 00 00 00 ff ff 7f
> 00                          ........
> Mar  7 13:48:47 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:47 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:47 henning kernel: XFS (sde):     len#011= 2944
> Mar  7 13:48:47 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 000000002dec2ba1: 41 42 33 43 00 00 01
> 14 00 05 da 90 00 02 29 d6  AB3C..........).
> Mar  7 13:48:48 henning kernel: 000000004f1d70e8: 00 00 00 00 00 49 5e
> c0 00 00 01 bd 00 02 c3 90  .....I^.........
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x0
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 1
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 104
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 00000000bcf5fc91: 3c 12 01 00 02 00 08
> 00 18 20 98 00 00 00 00 00  <........ ......
> Mar  7 13:48:48 henning kernel: 000000001fa60fef: 01 00 00 00 00 00 00
> 00                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 000000008344cea3: 3c 12 02 00 00 20 08
> 00 20 00 00 00 00 00 00 00  <.... .. .......
> Mar  7 13:48:48 henning kernel: 0000000016dd696d: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 00000000141a49bf: 41 42 33 42 00 00 01
> 2e ff ff ff ff 00 00 14 58  AB3B...........X
> Mar  7 13:48:48 henning kernel: 000000003d3f67d3: 00 00 00 00 00 00 00
> 20 00 00 01 bd 00 01 34 28  ....... ......4(
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 00000000cfe9f366: 3c 12 02 00 00 20 08
> 00 28 00 00 00 00 00 00 00  <.... ..(.......
> Mar  7 13:48:48 henning kernel: 00000000309e1848: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 00000000ac367f5a: 41 42 33 43 00 00 00
> fc ff ff ff ff 00 01 26 15  AB3C..........&.
> Mar  7 13:48:48 henning kernel: 000000002f6223e4: 00 00 00 00 00 00 00
> 28 00 00 01 bf 00 02 4f 78  .......(......Ox
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 000000009ed862e4: 3c 12 02 00 00 20 08
> 00 a8 30 09 00 00 00 00 00  <.... ...0......
> Mar  7 13:48:48 henning kernel: 00000000a3dbe920: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 00000000ef85f911: 41 42 33 43 00 00 01
> 04 00 00 00 05 00 04 9b da  AB3C............
> Mar  7 13:48:48 henning kernel: 00000000100ac1f5: 00 00 00 00 00 09 30
> a8 00 00 01 bf 00 02 80 78  ......0........x
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 2304
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 2200
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 2200
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 0000000030ba30ef: 3c 12 02 00 00 20 08
> 00 90 e4 07 00 00 00 00 00  <.... ..........
> Mar  7 13:48:48 henning kernel: 000000007d72f882: 01 00 00 00 ff ff 01
> 00                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 2176
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 00000000d6269b39: 41 42 33 43 00 00 00
> fc 00 00 7b b5 00 02 07 6d  AB3C......{....m
> Mar  7 13:48:48 henning kernel: 0000000038ed7490: 00 00 00 00 00 07 e4
> 90 00 00 01 bf 00 02 80 78  ...............x
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 0000000046c750e4: 3c 12 02 00 00 20 08
> 00 a8 dd 03 00 00 00 00 00  <.... ..........
> Mar  7 13:48:48 henning kernel: 00000000014558f1: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 0000000096f225dc: 41 42 33 43 00 00 01
> d8 00 03 2c 95 00 00 fc 92  AB3C......,.....
> Mar  7 13:48:48 henning kernel: 00000000cefb7d93: 00 00 00 00 00 03 dd
> a8 00 00 01 bd 00 01 34 28  ..............4(
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 2432
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 2328
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 2328
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 000000001d685d08: 3c 12 02 00 00 20 08
> 00 d8 c6 05 00 00 00 00 00  <.... ..........
> Mar  7 13:48:48 henning kernel: 00000000697d971d: 01 00 00 00 ff ff 03
> 00                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 2304
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 00000000e80f8d6c: 41 42 33 43 00 00 01
> 00 00 09 67 28 00 03 07 ff  AB3C......g(....
> Mar  7 13:48:48 henning kernel: 00000000b7b641c1: 00 00 00 00 00 05 c6
> d8 00 00 01 bf 00 02 80 78  ...............x
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x0
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 1
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 104
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 0000000047d742c9: 3c 12 01 00 02 00 08
> 00 e8 0f 00 00 00 00 00 00  <...............
> Mar  7 13:48:48 henning kernel: 0000000070290bf5: 01 00 00 00 00 00 00
> 00                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde): log item:
> Mar  7 13:48:48 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:48 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:48 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:48 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:48 henning kernel: 000000007cdb0ddf: 3c 12 02 00 00 20 08
> 00 f8 91 0f 00 00 00 00 00  <.... ..........
> Mar  7 13:48:48 henning kernel: 000000007c23326b: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:48 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:48 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:48 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:48 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:48 henning kernel: 000000008e386ae8: 41 42 33 42 00 00 01
> 46 00 02 34 eb 00 04 2c 4d  AB3B...F..4...,M
> Mar  7 13:48:48 henning kernel: 00000000da43d444: 00 00 00 00 00 0f 91
> f8 00 00 01 bf 00 02 a3 20  ...............
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 000000009fcd9bdf: 3c 12 02 00 00 20 08
> 00 60 5d bb 00 00 00 00 00  <.... ..`]......
> Mar  7 13:48:49 henning kernel: 000000009e31fb7e: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:49 henning kernel: 00000000d3ba13f5: 41 42 33 43 00 00 01
> e5 00 02 b4 42 00 01 b2 8b  AB3C.......B....
> Mar  7 13:48:49 henning kernel: 0000000001cf1a5c: 00 00 00 00 00 bb 5d
> 60 00 00 00 00 00 00 00 00  ......]`........
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 000000000c99c33e: 3c 12 02 00 00 20 08
> 00 f8 ba 24 00 00 00 00 00  <.... ....$.....
> Mar  7 13:48:49 henning kernel: 00000000f8d8bdd9: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:49 henning kernel: 0000000093849858: 41 42 33 43 00 00 01
> 5f 00 12 98 99 00 00 02 7c  AB3C..._.......|
> Mar  7 13:48:49 henning kernel: 000000004ccf3bbb: 00 00 00 00 00 24 ba
> f8 00 00 01 b3 00 00 9a 38  .....$.........8
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 00000000379e79b0: 3c 12 02 00 00 20 08
> 00 50 dc 2b 00 00 00 00 00  <.... ..P.+.....
> Mar  7 13:48:49 henning kernel: 00000000227fdbcb: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:49 henning kernel: 000000003cc57245: 41 42 33 43 00 00 01
> 43 00 11 2b dc 00 00 03 8f  AB3C...C..+.....
> Mar  7 13:48:49 henning kernel: 0000000084fb9729: 00 00 00 00 00 2b dc
> 50 00 00 00 00 00 00 00 00  .....+.P........
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x0
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 1
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 104
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 000000007cb2b268: 3c 12 01 00 02 00 08
> 00 38 8d 25 00 00 00 00 00  <.......8.%.....
> Mar  7 13:48:49 henning kernel: 000000002c9b4931: 01 00 00 00 00 00 00
> 00                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 00000000ba5b102c: 3c 12 02 00 00 20 08
> 00 50 00 00 00 00 00 00 00  <.... ..P.......
> Mar  7 13:48:49 henning kernel: 000000001638bd5c: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:49 henning kernel: 000000001ef34681: 41 42 33 42 00 01 01
> 4f ff ff ff ff ff ff ff ff  AB3B...O........
> Mar  7 13:48:49 henning kernel: 000000000d779f83: 00 00 00 00 00 00 00
> 50 00 00 01 b3 00 00 7b 70  .......P......{p
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 2304
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 2200
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 2200
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 00000000bfae73db: 3c 12 02 00 00 20 08
> 00 b8 a5 42 00 00 00 00 00  <.... ....B.....
> Mar  7 13:48:49 henning kernel: 00000000ae7163fd: 01 00 00 00 ff ff 01
> 00                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 2176
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:49 henning kernel: 00000000d4097590: 41 42 33 42 00 00 00
> fc 00 05 3b e4 00 0a 48 1c  AB3B......;...H.
> Mar  7 13:48:49 henning kernel: 000000002a5b5ce2: 00 00 00 00 00 42 a5
> b8 00 00 01 bf 00 02 80 78  .....B.........x
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 0000000004568c19: 3c 12 02 00 00 20 08
> 00 c0 ab 15 00 00 00 00 00  <.... ..........
> Mar  7 13:48:49 henning kernel: 000000007b8bddab: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:49 henning kernel: 00000000de25df52: 41 42 33 43 00 00 01
> 87 00 00 14 d8 00 00 14 b8  AB3C............
> Mar  7 13:48:49 henning kernel: 000000005fd0b81b: 00 00 00 00 00 15 ab
> c0 00 00 01 bf 00 02 80 78  ...............x
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 0000000082a4a945: 3c 12 02 00 00 20 08
> 00 c0 98 00 00 00 00 00 00  <.... ..........
> Mar  7 13:48:49 henning kernel: 000000007364c2e2: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:49 henning kernel: 00000000ac1f2423: 41 42 33 43 00 00 01
> d8 00 04 4e 89 00 00 69 e3  AB3C......N...i.
> Mar  7 13:48:49 henning kernel: 00000000889ea3c1: 00 00 00 00 00 00 98
> c0 00 00 00 00 00 00 00 00  ................
> Mar  7 13:48:49 henning kernel: XFS (sde): log item:
> Mar  7 13:48:49 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:49 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:49 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:49 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:49 henning kernel: 00000000bf080b85: 3c 12 02 00 00 20 08
> 00 20 df 29 00 00 00 00 00  <.... .. .).....
> Mar  7 13:48:49 henning kernel: 00000000e48e3933: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:49 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:49 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:49 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:49 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:50 henning kernel: 00000000eeb901a9: 41 42 33 42 00 00 00
> fc 00 00 14 58 00 08 54 b7  AB3B.......X..T.
> Mar  7 13:48:50 henning kernel: 000000000bbb4b58: 00 00 00 00 00 29 df
> 20 00 00 01 bf 00 02 80 78  .....). .......x
> Mar  7 13:48:50 henning kernel: XFS (sde): log item:
> Mar  7 13:48:50 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:50 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:50 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:50 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:50 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:50 henning kernel: 0000000066ef0fc5: 3c 12 02 00 00 20 08
> 00 00 b4 3a 00 00 00 00 00  <.... ....:.....
> Mar  7 13:48:50 henning kernel: 000000005e86df7c: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:50 henning kernel: 00000000af8c769b: 41 42 33 43 00 00 01
> dc 00 08 70 fa 00 02 a1 42  AB3C......p....B
> Mar  7 13:48:50 henning kernel: 00000000874441f5: 00 00 00 00 00 3a b4
> 00 00 00 00 00 00 00 00 00  .....:..........
> Mar  7 13:48:50 henning kernel: XFS (sde): log item:
> Mar  7 13:48:50 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:50 henning kernel: XFS (sde):   flags#011= 0x0
> Mar  7 13:48:50 henning kernel: XFS (sde):   niovecs#011= 1
> Mar  7 13:48:50 henning kernel: XFS (sde):   size#011= 104
> Mar  7 13:48:50 henning kernel: XFS (sde):   bytes#011= 24
> Mar  7 13:48:50 henning kernel: XFS (sde):   buf len#011= 24
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:50 henning kernel: 00000000e82e8e43: 3c 12 01 00 02 00 08
> 00 00 2c 0c 00 00 00 00 00  <........,......
> Mar  7 13:48:50 henning kernel: 0000000040bc3df0: 01 00 00 00 00 00 00
> 00                          ........
> Mar  7 13:48:50 henning kernel: XFS (sde): log item:
> Mar  7 13:48:50 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:50 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:50 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:50 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:50 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:50 henning kernel: 00000000b15a9748: 3c 12 02 00 00 20 08
> 00 f8 fc 2e 00 00 00 00 00  <.... ..........
> Mar  7 13:48:50 henning kernel: 00000000b3bbb38e: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:50 henning kernel: 00000000a56d19d1: 41 42 33 42 00 00 01
> f6 00 04 4a be 00 17 74 1f  AB3B......J...t.
> Mar  7 13:48:50 henning kernel: 00000000fab0bc09: 00 00 00 00 00 2e fc
> f8 00 00 01 bf 00 02 80 78  ...............x
> Mar  7 13:48:50 henning kernel: XFS (sde): log item:
> Mar  7 13:48:50 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:50 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:50 henning kernel: XFS (sde):   size#011= 3584
> Mar  7 13:48:50 henning kernel: XFS (sde):   bytes#011= 3480
> Mar  7 13:48:50 henning kernel: XFS (sde):   buf len#011= 3480
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:50 henning kernel: 000000001d1bf9be: 3c 12 02 00 00 20 08
> 00 a0 1f 0a 00 00 00 00 00  <.... ..........
> Mar  7 13:48:50 henning kernel: 00000000e63ae874: 01 00 00 00 ff ff ff
> 07                          ........
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 3456
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:50 henning kernel: 00000000183312d8: 41 42 33 43 00 00 01
> 63 00 00 7e 7a 00 03 19 b9  AB3C...c..~z....
> Mar  7 13:48:50 henning kernel: 00000000c9c6d52b: 00 00 00 00 00 0a 1f
> a0 00 00 01 bf 00 02 80 78  ...............x
> Mar  7 13:48:50 henning kernel: XFS (sde): log item:
> Mar  7 13:48:50 henning kernel: XFS (sde):   type#011= 0x123c
> Mar  7 13:48:50 henning kernel: XFS (sde):   flags#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):   niovecs#011= 2
> Mar  7 13:48:50 henning kernel: XFS (sde):   size#011= 4224
> Mar  7 13:48:50 henning kernel: XFS (sde):   bytes#011= 4120
> Mar  7 13:48:50 henning kernel: XFS (sde):   buf len#011= 4120
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[0]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x1
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 24
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 24 bytes of iovec[0]:
> Mar  7 13:48:50 henning kernel: 0000000041ea6fc1: 3c 12 02 00 00 20 08
> 00 90 64 24 00 00 00 00 00  <.... ...d$.....
> Mar  7 13:48:50 henning kernel: 00000000cc60723d: 01 00 00 00 ff ff ff
> ff                          ........
> Mar  7 13:48:50 henning kernel: XFS (sde):   iovec[1]
> Mar  7 13:48:50 henning kernel: XFS (sde):     type#011= 0x2
> Mar  7 13:48:50 henning kernel: XFS (sde):     len#011= 4096
> Mar  7 13:48:50 henning kernel: XFS (sde):     first 32 bytes of iovec[1]:
> Mar  7 13:48:50 henning kernel: 00000000dad2bdc0: 41 42 33 43 00 00 01
> f9 00 00 b8 8f 00 04 b2 6e  AB3C...........n
> Mar  7 13:48:50 henning kernel: 00000000a1a2d00c: 00 00 00 00 00 24 64
> 90 00 00 01 bf 00 02 80 78  .....$d........x
> Mar  7 13:48:50 henning kernel: XFS (sde): xfs_do_force_shutdown(0x2)
> called from line 501 of file fs/xfs/xfs_log_cil.c.  Return address =
> 0x00000000ff5562c6
> Mar  7 13:48:50 henning kernel: XFS (sde): Log I/O Error Detected.
> Shutting down filesystem
> Mar  7 13:48:50 henning kernel: XFS (sde): Please umount the
> filesystem and rectify the problem(s)
> 
> --
> Quobyte GmbH, Berlin, AG Charlottenburg HRB 149012 B, Jan Stender,
> Felix Hupfeld, Bjoern Kolbeck
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
