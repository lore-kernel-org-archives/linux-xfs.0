Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BLbgKB141509 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 16:37:42 -0500
Received: from xsnews-ex.xsnews.local (exchange.xsnews.nl [78.152.36.69]) by
	cuda.sgi.com with ESMTP id HbhJYcIBC5ULzZGY (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 14:37:32 -0700 (PDT)
Message-ID: <4FD66513.2000108@xsnews.nl>
Date: Mon, 11 Jun 2012 23:37:23 +0200
From: Matthew Whittaker-Williams <matthew@xsnews.nl>
MIME-Version: 1.0
Subject: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Content-Type: multipart/mixed; boundary="------------080501000505030604090909"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--------------080501000505030604090909
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Dear Developers,

We are running into some problems with xfs and the LSI 9265-8i Controller.

http://www.lsi.com/products/storagecomponents/Pages/MegaRAIDSAS9265-8i.aspx

When running high i/o on raid 6 array with this controller xfs freezes 
up and we get the following errors:

Linux sd69 3.4.1-custom #4 SMP Mon Jun 11 09:35:31 CEST 2012 x86_64 
GNU/Linux

[   62.911481] XFS (sda): Mounting Filesystem
[   63.212456] XFS (sda): Starting recovery (logdev: internal)
[   64.016420] XFS (sda): Ending recovery (logdev: internal)
[   64.020549] XFS (sdb): Mounting Filesystem
[   64.371207] XFS (sdb): Starting recovery (logdev: internal)
[   65.265051] XFS (sdb): Ending recovery (logdev: internal)
[ 6110.298886] INFO: task kworker/0:0:11244 blocked for more than 120 
seconds.
[ 6110.298942] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6110.299000] kworker/0:0     D ffff8805ecf52880     0 11244      2 
0x00000000
[ 6110.299044]  ffff8805ecf52880 0000000000000046 0000000000000000 
ffffffff81613020
[ 6110.299107]  00000000000132c0 ffff880582d65fd8 00000000000132c0 
ffff880582d65fd8
[ 6110.299170]  00000000000132c0 ffff8805ecf52880 00000000000132c0 
ffff880582d64010
[ 6110.299233] Call Trace:
[ 6110.299266]  [<ffffffff8134d55a>] ? schedule_timeout+0x2d/0xd7
[ 6110.299305]  [<ffffffff810f62f5>] ? kmem_cache_alloc+0x2a/0xee
[ 6110.299358]  [<ffffffffa02cbff4>] ? kmem_zone_alloc+0x58/0x9e [xfs]
[ 6110.299395]  [<ffffffff8134de6b>] ? __down_common+0x93/0xe4
[ 6110.299443]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
[ 6110.299480]  [<ffffffff81057994>] ? down+0x27/0x37
[ 6110.299520]  [<ffffffffa02b81e7>] ? xfs_buf_lock+0x65/0xb2 [xfs]
[ 6110.299568]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
[ 6110.299613]  [<ffffffffa0312e3b>] ? xfs_trans_getsb+0xa5/0xf5 [xfs]
[ 6110.299663]  [<ffffffffa0306c9a>] ? xfs_mod_sb+0x43/0x10f [xfs]
[ 6110.299710]  [<ffffffffa02c70f6>] ? xfs_flush_inodes+0x23/0x23 [xfs]
[ 6110.299755]  [<ffffffffa02bcd06>] ? xfs_fs_log_dummy+0x61/0x75 [xfs]
[ 6110.299802]  [<ffffffffa0311978>] ? xfs_ail_min_lsn+0xd/0x2e [xfs]
[ 6110.299849]  [<ffffffffa02c7133>] ? xfs_sync_worker+0x3d/0x60 [xfs]
[ 6110.299888]  [<ffffffff812703b6>] ? powersave_bias_target+0x14b/0x14b
[ 6110.299924]  [<ffffffff8104fa39>] ? process_one_work+0x1cd/0x2eb
[ 6110.299960]  [<ffffffff8104fc85>] ? worker_thread+0x12e/0x249
[ 6110.299993]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
[ 6110.300029]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
[ 6110.300064]  [<ffffffff8105356e>] ? kthread+0x81/0x89
[ 6110.300098]  [<ffffffff813569a4>] ? kernel_thread_helper+0x4/0x10
[ 6110.300133]  [<ffffffff810534ed>] ? 
kthread_freezable_should_stop+0x53/0x53
[ 6110.300171]  [<ffffffff813569a0>] ? gs_change+0x13/0x13
[ 7547.340316] INFO: task kworker/0:0:11244 blocked for more than 120 
seconds.
[ 7547.340359] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 7547.340414] kworker/0:0     D ffff8805ecf52880     0 11244      2 
0x00000000
[ 7547.340458]  ffff8805ecf52880 0000000000000046 0000000000000000 
ffffffff81613020
[ 7547.340522]  00000000000132c0 ffff880582d65fd8 00000000000132c0 
ffff880582d65fd8
[ 7547.340585]  00000000000132c0 ffff8805ecf52880 00000000000132c0 
ffff880582d64010
[ 7547.340648] Call Trace:
[ 7547.340680]  [<ffffffff8134d55a>] ? schedule_timeout+0x2d/0xd7
[ 7547.340719]  [<ffffffff810f62f5>] ? kmem_cache_alloc+0x2a/0xee
[ 7547.340772]  [<ffffffffa02cbff4>] ? kmem_zone_alloc+0x58/0x9e [xfs]
[ 7547.340809]  [<ffffffff8134de6b>] ? __down_common+0x93/0xe4
[ 7547.340858]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
[ 7547.340895]  [<ffffffff81057994>] ? down+0x27/0x37
[ 7547.340934]  [<ffffffffa02b81e7>] ? xfs_buf_lock+0x65/0xb2 [xfs]
[ 7547.340983]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
[ 7547.341028]  [<ffffffffa0312e3b>] ? xfs_trans_getsb+0xa5/0xf5 [xfs]
[ 7547.341078]  [<ffffffffa0306c9a>] ? xfs_mod_sb+0x43/0x10f [xfs]
[ 7547.341126]  [<ffffffffa02c70f6>] ? xfs_flush_inodes+0x23/0x23 [xfs]
[ 7547.341170]  [<ffffffffa02bcd06>] ? xfs_fs_log_dummy+0x61/0x75 [xfs]
[ 7547.341217]  [<ffffffffa0311978>] ? xfs_ail_min_lsn+0xd/0x2e [xfs]
[ 7547.346755]  [<ffffffffa02c7133>] ? xfs_sync_worker+0x3d/0x60 [xfs]
[ 7547.346794]  [<ffffffff812703b6>] ? powersave_bias_target+0x14b/0x14b
[ 7547.346832]  [<ffffffff8104fa39>] ? process_one_work+0x1cd/0x2eb
[ 7547.346870]  [<ffffffff8104fc85>] ? worker_thread+0x12e/0x249
[ 7547.346905]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
[ 7547.346940]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
[ 7547.346976]  [<ffffffff8105356e>] ? kthread+0x81/0x89
[ 7547.347012]  [<ffffffff813569a4>] ? kernel_thread_helper+0x4/0x10
[ 7547.347048]  [<ffffffff810534ed>] ? 
kthread_freezable_should_stop+0x53/0x53
[ 7547.347085]  [<ffffffff813569a0>] ? gs_change+0x13/0x13
[ 9463.398196] INFO: task kworker/0:0:11244 blocked for more than 120 
seconds.
[ 9463.398270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9463.398325] kworker/0:0     D ffff8805ecf52880     0 11244      2 
0x00000000
[ 9463.398369]  ffff8805ecf52880 0000000000000046 0000000000000000 
ffffffff81613020
[ 9463.398433]  00000000000132c0 ffff880582d65fd8 00000000000132c0 
ffff880582d65fd8
[ 9463.398496]  00000000000132c0 ffff8805ecf52880 00000000000132c0 
ffff880582d64010
[ 9463.398559] Call Trace:
[ 9463.398592]  [<ffffffff8134d55a>] ? schedule_timeout+0x2d/0xd7
[ 9463.398630]  [<ffffffff810f62f5>] ? kmem_cache_alloc+0x2a/0xee
[ 9463.398683]  [<ffffffffa02cbff4>] ? kmem_zone_alloc+0x58/0x9e [xfs]
[ 9463.398720]  [<ffffffff8134de6b>] ? __down_common+0x93/0xe4
[ 9463.398768]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
[ 9463.398804]  [<ffffffff81057994>] ? down+0x27/0x37
[ 9463.398843]  [<ffffffffa02b81e7>] ? xfs_buf_lock+0x65/0xb2 [xfs]
[ 9463.398892]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
[ 9463.398937]  [<ffffffffa0312e3b>] ? xfs_trans_getsb+0xa5/0xf5 [xfs]
[ 9463.398987]  [<ffffffffa0306c9a>] ? xfs_mod_sb+0x43/0x10f [xfs]
[ 9463.399034]  [<ffffffffa02c70f6>] ? xfs_flush_inodes+0x23/0x23 [xfs]
[ 9463.399079]  [<ffffffffa02bcd06>] ? xfs_fs_log_dummy+0x61/0x75 [xfs]
[ 9463.399126]  [<ffffffffa0311978>] ? xfs_ail_min_lsn+0xd/0x2e [xfs]
[ 9463.399174]  [<ffffffffa02c7133>] ? xfs_sync_worker+0x3d/0x60 [xfs]
[ 9463.399211]  [<ffffffff8104fa39>] ? process_one_work+0x1cd/0x2eb
[ 9463.399246]  [<ffffffff8104fc85>] ? worker_thread+0x12e/0x249
[ 9463.399281]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
[ 9463.399316]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
[ 9463.399351]  [<ffffffff8105356e>] ? kthread+0x81/0x89
[ 9463.399385]  [<ffffffff813569a4>] ? kernel_thread_helper+0x4/0x10
[ 9463.399422]  [<ffffffff810534ed>] ? 
kthread_freezable_should_stop+0x53/0x53
[ 9463.399459]  [<ffffffff813569a0>] ? gs_change+0x13/0x13


We tried the following linux kernels but same errors occurs.

3.0.33
3.2.14
3.2.18
3.3.7
3.4.1

We also tried the 2.6.35-13 kernel but this kernel is unable to load see 
the disk even when modules are loaded.

See attachments for system information.

Note we tried several of the same controller but errors persist.

Could you have a look into this issue?

If you need any more information I am happy to provide it.

Thanks

Kind regards,

Matthew Whittaker-Williams





--------------080501000505030604090909
Content-Type: text/plain; name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.1-custom (root@squeeze) (gcc version 4.4.5 (Debian 4.4.5-8) ) #4 SMP Mon Jun 11 09:35:31 CEST 2012
[    0.000000] Command line: vga=normal initrd=debian/squeeze/diskless/initrd.img-3.4.1-custom boot=live live-config noeject noswap noprompt nolocales edd=on nomodeset nosplash quickreboot scandelay=5 panic=60 debug=1 fetch=http://10.0.0.59/debian/squeeze/filesystem-3.4.1.squashfs BOOT_IMAGE=debian/squeeze/diskless/vmlinuz-3.4.1-custom auto
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
[    0.000000]  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df780000 (usable)
[    0.000000]  BIOS-e820: 00000000df78e000 - 00000000df790000 type 9
[    0.000000]  BIOS-e820: 00000000df790000 - 00000000df79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df79e000 - 00000000df7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df7d0000 - 00000000df7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000df7ec000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000620000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro X8ST3/X8ST3, BIOS 2.0        07/29/10  
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x620000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FE00000000 write-back
[    0.000000]   2 base 0600000000 mask FFE0000000 write-back
[    0.000000]   3 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   4 base 00DF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf780 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000df780000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df780000 page 4k
[    0.000000] kernel direct mapping tables up to df780000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000620000000
[    0.000000]  0100000000 - 0620000000 page 2M
[    0.000000] kernel direct mapping tables up to 620000000 @ df766000-df780000
[    0.000000] RAMDISK: 79808000 - 80000000
[    0.000000] ACPI: RSDP 00000000000faa70 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000df790100 00074 (v01 SMCI            20100729 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000df790290 000F4 (v03 072910 FACP2001 20100729 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000df790630 06761 (v01  1F580 1F580000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df79e000 00040
[    0.000000] ACPI: APIC 00000000df790390 000D2 (v01 072910 APIC2001 20100729 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000df790470 0003C (v01 072910 OEMMCFG  20100729 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000df79e040 0007B (v01 072910 OEMB2001 20100729 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df79a630 00038 (v01 072910 OEMHPET  20100729 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000df79ee90 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: EINJ 00000000df79a670 00130 (v01  AMIER AMI_EINJ 20100729 MSFT 00000097)
[    0.000000] ACPI: BERT 00000000df79a800 00030 (v01  AMIER AMI_BERT 20100729 MSFT 00000097)
[    0.000000] ACPI: ERST 00000000df79a830 001B0 (v01  AMIER AMI_ERST 20100729 MSFT 00000097)
[    0.000000] ACPI: HEST 00000000df79a9e0 000A8 (v01  AMIER ABC_HEST 20100729 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000620000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000620000000
[    0.000000]   NODE_DATA [000000061fffc000 - 000000061fffffff]
[    0.000000]  [ffffea0000000000-ffffea00187fffff] PMD -> [ffff880607600000-ffff88061f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00620000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000df780
[    0.000000]     0: 0x00100000 -> 0x00620000
[    0.000000] On node 0 totalpages: 6289161
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3908 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 894912 pages, LIFO batch:31
[    0.000000]   Normal zone: 83968 pages used for memmap
[    0.000000]   Normal zone: 5289984 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 12 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 000000000009a000
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df780000 - 00000000df78e000
[    0.000000] PM: Registered nosave memory: 00000000df78e000 - 00000000df790000
[    0.000000] PM: Registered nosave memory: 00000000df790000 - 00000000df79e000
[    0.000000] PM: Registered nosave memory: 00000000df79e000 - 00000000df7d0000
[    0.000000] PM: Registered nosave memory: 00000000df7d0000 - 00000000df7e0000
[    0.000000] PM: Registered nosave memory: 00000000df7e0000 - 00000000df7ec000
[    0.000000] PM: Registered nosave memory: 00000000df7ec000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f0000000 (gap: f0000000:ee00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88061fc00000 s81600 r8192 d20800 u131072
[    0.000000] pcpu-alloc: s81600 r8192 d20800 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 6188804
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: vga=normal initrd=debian/squeeze/diskless/initrd.img-3.4.1-custom boot=live live-config noeject noswap noprompt nolocales edd=on nomodeset nosplash quickreboot scandelay=5 panic=60 debug=1 fetch=http://10.0.0.59/debian/squeeze/filesystem-3.4.1.squashfs BOOT_IMAGE=debian/squeeze/diskless/vmlinuz-3.4.1-custom auto
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 24580644k/25690112k available (3428k kernel code, 533468k absent, 576000k reserved, 3203k data, 576k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2133.449 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4266.89 BogoMIPS (lpj=8533796)
[    0.000132] pid_max: default: 32768 minimum: 301
[    0.000224] Security Framework initialized
[    0.000287] SELinux:  Disabled at boot.
[    0.002227] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.009748] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.012932] Mount-cache hash table entries: 256
[    0.013212] Initializing cgroup subsys cpuacct
[    0.013276] Initializing cgroup subsys devices
[    0.013338] Initializing cgroup subsys freezer
[    0.013400] Initializing cgroup subsys net_cls
[    0.013484] CPU: Physical Processor ID: 0
[    0.013545] CPU: Processor Core ID: 0
[    0.013609] mce: CPU supports 9 MCE banks
[    0.013680] CPU0: Thermal monitoring enabled (TM1)
[    0.013748] using mwait in idle threads.
[    0.014660] ACPI: Core revision 20120320
[    0.039679] Switched APIC routing to physical flat.
[    0.040138] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.079806] CPU0: Intel(R) Xeon(R) CPU           E5506  @ 2.13GHz stepping 05
[    0.184018] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.184252] CPU erratum AAJ80 worked around
[    0.184314] CPUID marked event: 'bus cycles' unavailable
[    0.184379] ... version:                3
[    0.184440] ... bit width:              48
[    0.184501] ... generic registers:      4
[    0.184562] ... value mask:             0000ffffffffffff
[    0.184626] ... max period:             000000007fffffff
[    0.184690] ... fixed-purpose events:   3
[    0.184750] ... event mask:             000000070000000f
[    0.184981] Booting Node   0, Processors  #1 #2 #3
[    0.224498] Brought up 4 CPUs
[    0.224612] Total of 4 processors activated (17067.59 BogoMIPS).
[    0.227001] devtmpfs: initialized
[    0.233189] PM: Registering ACPI NVS region [mem 0xdf79e000-0xdf7cffff] (204800 bytes)
[    0.233360] dummy: 
[    0.233465] NET: Registered protocol family 16
[    0.233744] ACPI: bus type pci registered
[    0.233864] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.233954] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.256570] PCI: Using configuration type 1 for base access
[    0.257486] bio: create slab <bio-0> at 0
[    0.257614] ACPI: Added _OSI(Module Device)
[    0.257677] ACPI: Added _OSI(Processor Device)
[    0.257739] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.257803] ACPI: Added _OSI(Processor Aggregator Device)
[    0.258717] ACPI: EC: Look up EC in DSDT
[    0.259154] \_SB_:_OSC evaluation returned wrong type
[    0.259218] _OSC request data:1 7 
[    0.260127] ACPI: Executed 1 blocks of module-level executable AML code
[    0.263750] ACPI: SSDT 00000000df79e0c0 008F0 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.264166] ACPI: Dynamic OEM Table Load:
[    0.264301] ACPI: SSDT           (null) 008F0 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.264550] ACPI: SSDT 00000000df79e9b0 004D5 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.264909] ACPI: Dynamic OEM Table Load:
[    0.265043] ACPI: SSDT           (null) 004D5 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.265572] ACPI: Interpreter enabled
[    0.265635] ACPI: (supports S0 S1 S4 S5)
[    0.265858] ACPI: Using IOAPIC for interrupt routing
[    0.272421] ACPI: No dock devices found.
[    0.272485] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.272659] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.272866] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.272934] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.273002] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.273087] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.273172] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    0.273283] PCI host bridge to bus 0000:00
[    0.273346] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.273413] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.273479] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.273547] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.273615] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[    0.273695] pci 0000:00:00.0: [8086:3405] type 00 class 0x060000
[    0.273819] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.273909] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.274035] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.274126] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.274252] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.274342] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    0.274468] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.274557] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.274683] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.274773] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    0.274898] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.274991] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.275127] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.275265] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.275398] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.275526] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.275603] pci 0000:00:16.0: reg 10: [mem 0xfbef8000-0xfbefbfff 64bit]
[    0.275745] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.275826] pci 0000:00:16.1: reg 10: [mem 0xfbef4000-0xfbef7fff 64bit]
[    0.275969] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.276046] pci 0000:00:16.2: reg 10: [mem 0xfbef0000-0xfbef3fff 64bit]
[    0.276187] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.276265] pci 0000:00:16.3: reg 10: [mem 0xfbeec000-0xfbeeffff 64bit]
[    0.276406] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.276484] pci 0000:00:16.4: reg 10: [mem 0xfbee8000-0xfbeebfff 64bit]
[    0.276625] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.276702] pci 0000:00:16.5: reg 10: [mem 0xfbee4000-0xfbee7fff 64bit]
[    0.276845] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.276922] pci 0000:00:16.6: reg 10: [mem 0xfbee0000-0xfbee3fff 64bit]
[    0.277064] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.277141] pci 0000:00:16.7: reg 10: [mem 0xfbedc000-0xfbedffff 64bit]
[    0.277285] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.277393] pci 0000:00:1a.0: reg 20: [io  0xac00-0xac1f]
[    0.277509] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.277618] pci 0000:00:1a.1: reg 20: [io  0xa880-0xa89f]
[    0.277734] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.277842] pci 0000:00:1a.2: reg 20: [io  0xa800-0xa81f]
[    0.277968] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.278054] pci 0000:00:1a.7: reg 10: [mem 0xfbeda000-0xfbeda3ff]
[    0.278211] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.278300] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.278438] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.278527] pci 0000:00:1c.1: [8086:3a42] type 01 class 0x060400
[    0.278665] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.278761] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.278870] pci 0000:00:1d.0: reg 20: [io  0xa480-0xa49f]
[    0.278986] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.279095] pci 0000:00:1d.1: reg 20: [io  0xa400-0xa41f]
[    0.279212] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.279320] pci 0000:00:1d.2: reg 20: [io  0xa080-0xa09f]
[    0.279447] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.279532] pci 0000:00:1d.7: reg 10: [mem 0xfbed8000-0xfbed83ff]
[    0.279690] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.279777] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.279910] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.280058] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 4700 (mask 0097)
[    0.280144] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 03e8 (mask 000f)
[    0.280230] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1640 (mask 000f)
[    0.280316] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    0.280448] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.280532] pci 0000:00:1f.2: reg 10: [io  0x9480-0x9487]
[    0.280603] pci 0000:00:1f.2: reg 14: [io  0xa000-0xa003]
[    0.280673] pci 0000:00:1f.2: reg 18: [io  0x9c00-0x9c07]
[    0.280744] pci 0000:00:1f.2: reg 1c: [io  0x9880-0x9883]
[    0.280815] pci 0000:00:1f.2: reg 20: [io  0x9800-0x981f]
[    0.280886] pci 0000:00:1f.2: reg 24: [mem 0xfbed6000-0xfbed67ff]
[    0.280999] pci 0000:00:1f.2: PME# supported from D3hot
[    0.281080] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.281160] pci 0000:00:1f.3: reg 10: [mem 0xfbed4000-0xfbed40ff 64bit]
[    0.281247] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.281375] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.281482] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.281589] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.281707] pci 0000:04:00.0: [1000:005b] type 00 class 0x010400
[    0.281782] pci 0000:04:00.0: reg 10: [io  0xb000-0xb0ff]
[    0.281857] pci 0000:04:00.0: reg 14: [mem 0xfb87c000-0xfb87ffff 64bit]
[    0.287396] pci 0000:04:00.0: reg 1c: [mem 0xfb8c0000-0xfb8fffff 64bit]
[    0.287475] pci 0000:04:00.0: reg 30: [mem 0xfb880000-0xfb8bffff pref]
[    0.287583] pci 0000:04:00.0: supports D1 D2
[    0.291803] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.291876] pci 0000:00:07.0:   bridge window [io  0xb000-0xbfff]
[    0.291944] pci 0000:00:07.0:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.292063] pci 0000:05:00.0: [1000:0058] type 00 class 0x010000
[    0.292139] pci 0000:05:00.0: reg 10: [io  0xc000-0xc0ff]
[    0.292214] pci 0000:05:00.0: reg 14: [mem 0xfb9ec000-0xfb9effff 64bit]
[    0.292291] pci 0000:05:00.0: reg 1c: [mem 0xfb9f0000-0xfb9fffff 64bit]
[    0.292372] pci 0000:05:00.0: reg 30: [mem 0xfba00000-0xfbbfffff pref]
[    0.292479] pci 0000:05:00.0: supports D1 D2
[    0.292553] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.292649] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    0.292715] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.292783] pci 0000:00:09.0:   bridge window [mem 0xfb900000-0xfbbfffff]
[    0.292921] pci 0000:06:00.0: [8086:10d3] type 00 class 0x020000
[    0.293009] pci 0000:06:00.0: reg 10: [mem 0xfbce0000-0xfbcfffff]
[    0.293107] pci 0000:06:00.0: reg 18: [io  0xdc00-0xdc1f]
[    0.293188] pci 0000:06:00.0: reg 1c: [mem 0xfbcdc000-0xfbcdffff]
[    0.293395] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.299794] pci 0000:00:1c.0: PCI bridge to [bus 06-06]
[    0.299867] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.299936] pci 0000:00:1c.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.300075] pci 0000:07:00.0: [8086:10d3] type 00 class 0x020000
[    0.300163] pci 0000:07:00.0: reg 10: [mem 0xfbde0000-0xfbdfffff]
[    0.300261] pci 0000:07:00.0: reg 18: [io  0xec00-0xec1f]
[    0.300342] pci 0000:07:00.0: reg 1c: [mem 0xfbddc000-0xfbddffff]
[    0.300549] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    0.307781] pci 0000:00:1c.1: PCI bridge to [bus 07-07]
[    0.307854] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.307923] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.308030] pci 0000:08:04.0: [102b:0532] type 00 class 0x030000
[    0.308111] pci 0000:08:04.0: reg 10: [mem 0xf9000000-0xf9ffffff pref]
[    0.308187] pci 0000:08:04.0: reg 14: [mem 0xfaffc000-0xfaffffff]
[    0.308261] pci 0000:08:04.0: reg 18: [mem 0xfb000000-0xfb7fffff]
[    0.308425] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.308497] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    0.308569] pci 0000:00:1e.0:   bridge window [mem 0xf9000000-0xf9ffffff 64bit pref]
[    0.308654] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.308740] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.308827] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.308914] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.309001] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    0.309119] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.309447] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.309603] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.309698] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.309801] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.309897] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.309994] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
[    0.310090] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.310186] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    0.310284]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.310351]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.310437] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.326052] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.326561] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.327067] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.327573] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.328084] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.328679] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.329185] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.329782] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *6 7 10 11 12 14 15)
[    0.330333] vgaarb: device added: PCI:0000:08:04.0,decodes=io+mem,owns=io+mem,locks=none
[    0.330419] vgaarb: loaded
[    0.330477] vgaarb: bridge control possible 0000:08:04.0
[    0.330578] wmi: Mapper loaded
[    0.330637] PCI: Using ACPI for IRQ routing
[    0.337238] PCI: Discovered peer bus ff
[    0.337300] PCI: root bus ff: using default resources
[    0.337384] PCI host bridge to bus 0000:ff
[    0.337447] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.337514] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    0.337586] pci 0000:ff:00.0: [8086:2c40] type 00 class 0x060000
[    0.337671] pci 0000:ff:00.1: [8086:2c01] type 00 class 0x060000
[    0.337757] pci 0000:ff:02.0: [8086:2c10] type 00 class 0x060000
[    0.337841] pci 0000:ff:02.1: [8086:2c11] type 00 class 0x060000
[    0.337925] pci 0000:ff:02.4: [8086:2c14] type 00 class 0x060000
[    0.338007] pci 0000:ff:02.5: [8086:2c15] type 00 class 0x060000
[    0.338091] pci 0000:ff:03.0: [8086:2c18] type 00 class 0x060000
[    0.338173] pci 0000:ff:03.1: [8086:2c19] type 00 class 0x060000
[    0.338256] pci 0000:ff:03.2: [8086:2c1a] type 00 class 0x060000
[    0.338339] pci 0000:ff:03.4: [8086:2c1c] type 00 class 0x060000
[    0.338422] pci 0000:ff:04.0: [8086:2c20] type 00 class 0x060000
[    0.338506] pci 0000:ff:04.1: [8086:2c21] type 00 class 0x060000
[    0.338589] pci 0000:ff:04.2: [8086:2c22] type 00 class 0x060000
[    0.338672] pci 0000:ff:04.3: [8086:2c23] type 00 class 0x060000
[    0.338756] pci 0000:ff:05.0: [8086:2c28] type 00 class 0x060000
[    0.338839] pci 0000:ff:05.1: [8086:2c29] type 00 class 0x060000
[    0.338921] pci 0000:ff:05.2: [8086:2c2a] type 00 class 0x060000
[    0.339004] pci 0000:ff:05.3: [8086:2c2b] type 00 class 0x060000
[    0.339089] pci 0000:ff:06.0: [8086:2c30] type 00 class 0x060000
[    0.339173] pci 0000:ff:06.1: [8086:2c31] type 00 class 0x060000
[    0.339255] pci 0000:ff:06.2: [8086:2c32] type 00 class 0x060000
[    0.339338] pci 0000:ff:06.3: [8086:2c33] type 00 class 0x060000
[    0.339826] PCI: pci_cache_line_size set to 64 bytes
[    0.340027] reserve RAM buffer: 0000000000099800 - 000000000009ffff 
[    0.340079] reserve RAM buffer: 00000000df780000 - 00000000dfffffff 
[    0.340344] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.340468] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.340715] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.348299] Switching to clocksource hpet
[    0.349851] pnp: PnP ACPI init
[    0.349921] ACPI: bus type pnp registered
[    0.350076] pnp 00:00: [bus 00-ff]
[    0.350137] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.350199] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.350262] pnp 00:00: [io  0x0d00-0xffff window]
[    0.350326] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.350390] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.350456] pnp 00:00: [mem 0xe0000000-0xdfffffff window disabled]
[    0.350522] pnp 00:00: [mem 0xf0000000-0xfed8ffff window]
[    0.350626] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.350719] pnp 00:01: [mem 0xfbf00000-0xfbffffff]
[    0.350782] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    0.350846] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    0.350909] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    0.350972] pnp 00:01: [mem 0xfec8a000-0xfec8afff]
[    0.351036] pnp 00:01: [mem 0xfed10000-0xfed10fff]
[    0.351150] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.351219] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.351287] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.351355] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.351423] system 00:01: [mem 0xfec8a000-0xfec8afff] has been reserved
[    0.351491] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.351559] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.351655] pnp 00:02: [dma 4]
[    0.351724] pnp 00:02: [io  0x0000-0x000f]
[    0.351786] pnp 00:02: [io  0x0081-0x0083]
[    0.351848] pnp 00:02: [io  0x0087]
[    0.351908] pnp 00:02: [io  0x0089-0x008b]
[    0.351969] pnp 00:02: [io  0x008f]
[    0.352029] pnp 00:02: [io  0x00c0-0x00df]
[    0.352113] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.352189] pnp 00:03: [io  0x0070-0x0071]
[    0.352258] pnp 00:03: [irq 8]
[    0.352336] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.352416] pnp 00:04: [io  0x0061]
[    0.352495] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.352569] pnp 00:05: [io  0x00f0-0x00ff]
[    0.352636] pnp 00:05: [irq 13]
[    0.352716] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.353025] pnp 00:06: [io  0x03f8-0x03ff]
[    0.353091] pnp 00:06: [irq 4]
[    0.353150] pnp 00:06: [dma 0 disabled]
[    0.353273] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.353574] pnp 00:07: [io  0x02f8-0x02ff]
[    0.353640] pnp 00:07: [irq 3]
[    0.353699] pnp 00:07: [dma 0 disabled]
[    0.353846] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.354321] pnp 00:08: [io  0x03e8-0x03ef]
[    0.354387] pnp 00:08: [irq 5]
[    0.354447] pnp 00:08: [dma 0 disabled]
[    0.354570] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.354689] pnp 00:09: [io  0x164e-0x164f]
[    0.354751] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.354869] system 00:09: [io  0x164e-0x164f] has been reserved
[    0.354937] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355121] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.355187] pnp 00:0a: [io  0x0a00-0x0a0f]
[    0.355249] pnp 00:0a: [io  0x0ca0-0x0caf]
[    0.355360] system 00:0a: [io  0x0a00-0x0a0f] has been reserved
[    0.355427] system 00:0a: [io  0x0ca0-0x0caf] has been reserved
[    0.355494] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355673] pnp 00:0b: [io  0x0010-0x001f]
[    0.355735] pnp 00:0b: [io  0x0022-0x003f]
[    0.355797] pnp 00:0b: [io  0x0044-0x005f]
[    0.361321] pnp 00:0b: [io  0x0062-0x0063]
[    0.361382] pnp 00:0b: [io  0x0065-0x006f]
[    0.361444] pnp 00:0b: [io  0x0072-0x007f]
[    0.361506] pnp 00:0b: [io  0x0080]
[    0.361566] pnp 00:0b: [io  0x0084-0x0086]
[    0.361628] pnp 00:0b: [io  0x0088]
[    0.361689] pnp 00:0b: [io  0x008c-0x008e]
[    0.361751] pnp 00:0b: [io  0x0090-0x009f]
[    0.361812] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.361874] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.361936] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.361997] pnp 00:0b: [io  0x0800-0x087f]
[    0.362059] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.362125] pnp 00:0b: [io  0x0500-0x057f]
[    0.362186] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.362250] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.362313] pnp 00:0b: [mem 0xfed40000-0xfed8ffff]
[    0.362448] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.362515] system 00:0b: [io  0x0800-0x087f] has been reserved
[    0.362581] system 00:0b: [io  0x0500-0x057f] has been reserved
[    0.362648] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.362716] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.362785] system 00:0b: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.362853] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.362975] pnp 00:0c: [mem 0xfed00000-0xfed003ff]
[    0.363064] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.363204] pnp 00:0d: [io  0x0060]
[    0.363265] pnp 00:0d: [io  0x0064]
[    0.363326] pnp 00:0d: [mem 0xfec00000-0xfec00fff]
[    0.363389] pnp 00:0d: [mem 0xfee00000-0xfee00fff]
[    0.363503] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.363572] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.363641] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.363755] pnp 00:0e: [mem 0xe0000000-0xefffffff]
[    0.363871] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    0.363939] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.364172] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.364236] pnp 00:0f: [mem 0x000c0000-0x000cffff]
[    0.364302] pnp 00:0f: [mem 0x000e0000-0x000fffff]
[    0.364373] pnp 00:0f: [mem 0x00100000-0xdfffffff]
[    0.364436] pnp 00:0f: [mem 0xfed90000-0xffffffff]
[    0.364562] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.364631] system 00:0f: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.364700] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.364769] system 00:0f: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.364838] system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.364908] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.365099] pnp: PnP ACPI: found 16 devices
[    0.365160] ACPI: ACPI bus type pnp unregistered
[    0.371331] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06-06] add_size 200000
[    0.371429] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 07-07] add_size 200000
[    0.371535] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.371626] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.371717] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.371804] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.371891] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.371962] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.372033] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.372104] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.372169] pci 0000:00:07.0:   bridge window [io  0xb000-0xbfff]
[    0.372238] pci 0000:00:07.0:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.372316] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    0.372381] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.372450] pci 0000:00:09.0:   bridge window [mem 0xfb900000-0xfbbfffff]
[    0.372522] pci 0000:00:1c.0: PCI bridge to [bus 06-06]
[    0.372587] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.372656] pci 0000:00:1c.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.372726] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.372815] pci 0000:00:1c.1: PCI bridge to [bus 07-07]
[    0.372880] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.372949] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.373018] pci 0000:00:1c.1:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.373107] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    0.373174] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    0.373243] pci 0000:00:1e.0:   bridge window [mem 0xf9000000-0xf9ffffff 64bit pref]
[    0.373373] pci 0000:00:1e.0: setting latency timer to 64
[    0.373440] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.373505] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.373570] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.373637] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.373703] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfed8ffff]
[    0.373770] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.373836] pci_bus 0000:04: resource 1 [mem 0xfb800000-0xfb8fffff]
[    0.373902] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.373967] pci_bus 0000:05: resource 1 [mem 0xfb900000-0xfbbfffff]
[    0.374034] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.374099] pci_bus 0000:06: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    0.374166] pci_bus 0000:06: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.374250] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    0.374315] pci_bus 0000:07: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.374381] pci_bus 0000:07: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.374465] pci_bus 0000:08: resource 1 [mem 0xfaf00000-0xfb7fffff]
[    0.374532] pci_bus 0000:08: resource 2 [mem 0xf9000000-0xf9ffffff 64bit pref]
[    0.374616] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.374681] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.374746] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.374812] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000dffff]
[    0.374879] pci_bus 0000:08: resource 8 [mem 0xf0000000-0xfed8ffff]
[    0.374946] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.375011] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    0.375121] NET: Registered protocol family 2
[    0.375474] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.376721] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.378341] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.378588] TCP: Hash tables configured (established 524288 bind 65536)
[    0.378656] TCP: reno registered
[    0.378750] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.378951] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.379209] NET: Registered protocol family 1
[    0.379539] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.379611] pci 0000:08:04.0: Boot video device
[    0.379740] Unpacking initramfs...
[    2.839202] Freeing initrd memory: 106464k freed
[    2.858263] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.858335] Placing 64MB software IO TLB between ffff8800db766000 - ffff8800df766000
[    2.858420] software IO TLB at phys 0xdb766000 - 0xdf766000
[    2.858996] audit: initializing netlink socket (disabled)
[    2.859070] type=2000 audit(1339436723.740:1): initialized
[    2.873774] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.875309] VFS: Disk quotas dquot_6.5.2
[    2.875415] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.875569] msgmni has been set to 32768
[    2.875789] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.875874] io scheduler noop registered
[    2.875935] io scheduler deadline registered
[    2.876047] io scheduler cfq registered (default)
[    2.876426] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.876584] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.876811] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.897222] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.917642] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.938071] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[    2.958615] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.979064] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.999513] 00:08: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
[    2.999843] Non-volatile memory driver v1.3
[    2.999906] Linux agpgart interface v0.103
[    3.000104] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.002606] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.002673] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.002825] mousedev: PS/2 mouse device common for all mice
[    3.002928] rtc_cmos 00:03: RTC can wake from S4
[    3.003078] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.003169] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.003244] cpuidle: using governor ladder
[    3.003306] cpuidle: using governor menu
[    3.003480] fujitsu_laptop: driver 0.6.0 successfully loaded
[    3.003633] TCP: cubic registered
[    3.003788] NET: Registered protocol family 10
[    3.004070] Mobile IPv6
[    3.004129] NET: Registered protocol family 17
[    3.004193] Registering the dns_resolver key type
[    3.004404] PM: Hibernation image not present or could not be loaded.
[    3.004483] registered taskstats version 1
[    3.005111] rtc_cmos 00:03: setting system clock to 2012-06-11 17:45:24 UTC (1339436724)
[    3.005234] Initializing network drop monitor service
[    3.119920] Freeing unused kernel memory: 576k freed
[    3.120086] Write protecting the kernel read-only data: 6144k
[    3.122503] Freeing unused kernel memory: 648k freed
[    3.125522] Freeing unused kernel memory: 808k freed
[    3.147921] udev[54]: starting version 164
[    3.169654] SCSI subsystem initialized
[    3.170326] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    3.170394] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    3.194191] megasas: 00.00.06.14-rc1 Fri. Jan. 6 17:00:00 PDT 2012
[    3.194278] megasas: 0x1000:0x005b:0x1000:0x9265: bus 4:slot 0:func 0
[    3.194812] e1000e 0000:06:00.0: Disabling ASPM L0s 
[    3.194976] libata version 3.00 loaded.
[    3.195052] e1000e 0000:06:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.195237] e1000e 0000:06:00.0: irq 42 for MSI/MSI-X
[    3.195308] e1000e 0000:06:00.0: irq 43 for MSI/MSI-X
[    3.195377] e1000e 0000:06:00.0: irq 44 for MSI/MSI-X
[    3.195598] megasas: FW now in Ready state
[    3.195716] megaraid_sas 0000:04:00.0: irq 45 for MSI/MSI-X
[    3.195787] megaraid_sas 0000:04:00.0: irq 46 for MSI/MSI-X
[    3.195859] megaraid_sas 0000:04:00.0: irq 47 for MSI/MSI-X
[    3.195889] usbcore: registered new interface driver usbfs
[    3.195909] usbcore: registered new interface driver hub
[    3.195933] usbcore: registered new device driver usb
[    3.196111] ahci 0000:00:1f.2: version 3.0
[    3.196181] megaraid_sas 0000:04:00.0: irq 48 for MSI/MSI-X
[    3.196205] ahci 0000:00:1f.2: irq 49 for MSI/MSI-X
[    3.196243] ahci: SSS flag set, parallel bus scan disabled
[    3.196287] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    3.196290] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    3.196294] ahci 0000:00:1f.2: setting latency timer to 64
[    3.196787] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.204138] Fusion MPT base driver 3.04.20
[    3.204204] Copyright (c) 1999-2008 LSI Corporation
[    3.205441] Fusion MPT SAS Host driver 3.04.20
[    3.205699] mptbase: ioc0: Initiating bringup
[    3.218406] megasas:IOC Init cmd success
[    3.234781] scsi1 : ahci
[    3.234907] scsi2 : ahci
[    3.235013] scsi3 : ahci
[    3.235120] scsi4 : ahci
[    3.235228] scsi5 : ahci
[    3.235334] scsi6 : ahci
[    3.235526] ata1: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6100 irq 49
[    3.235612] ata2: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6180 irq 49
[    3.235698] ata3: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6200 irq 49
[    3.235783] ata4: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6280 irq 49
[    3.235868] ata5: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6300 irq 49
[    3.235953] ata6: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6380 irq 49
[    3.236081] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.236150] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.236235] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    3.236345] ehci_hcd 0000:00:1a.7: debug port 1
[    3.240289] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    3.240369] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbeda000
[    3.242351] megasas: INIT adapter done
[    3.250318] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.250408] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.250476] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.250560] usb usb1: Product: EHCI Host Controller
[    3.250623] usb usb1: Manufacturer: Linux 3.4.1-custom ehci_hcd
[    3.250689] usb usb1: SerialNumber: 0000:00:1a.7
[    3.250843] hub 1-0:1.0: USB hub found
[    3.250906] hub 1-0:1.0: 6 ports detected
[    3.251069] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.251137] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.251206] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    3.251312] ehci_hcd 0000:00:1d.7: debug port 1
[    3.255242] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.255321] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbed8000
[    3.266288] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.266371] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.266439] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.266524] usb usb2: Product: EHCI Host Controller
[    3.266587] usb usb2: Manufacturer: Linux 3.4.1-custom ehci_hcd
[    3.266653] usb usb2: SerialNumber: 0000:00:1d.7
[    3.266804] hub 2-0:1.0: USB hub found
[    3.266868] hub 2-0:1.0: 6 ports detected
[    3.279394] uhci_hcd: USB Universal Host Controller Interface driver
[    3.279484] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.279552] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.279622] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.279737] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ac00
[    3.279829] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.279898] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.279982] usb usb3: Product: UHCI Host Controller
[    3.280045] usb usb3: Manufacturer: Linux 3.4.1-custom uhci_hcd
[    3.280111] usb usb3: SerialNumber: 0000:00:1a.0
[    3.280253] hub 3-0:1.0: USB hub found
[    3.280316] hub 3-0:1.0: 2 ports detected
[    3.280448] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.280515] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.280585] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.280698] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
[    3.280791] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.280859] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.280943] usb usb4: Product: UHCI Host Controller
[    3.281006] usb usb4: Manufacturer: Linux 3.4.1-custom uhci_hcd
[    3.281072] usb usb4: SerialNumber: 0000:00:1a.1
[    3.281209] hub 4-0:1.0: USB hub found
[    3.281272] hub 4-0:1.0: 2 ports detected
[    3.281401] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.281468] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.281543] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.281657] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000a800
[    3.281747] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.281816] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.281900] usb usb5: Product: UHCI Host Controller
[    3.281963] usb usb5: Manufacturer: Linux 3.4.1-custom uhci_hcd
[    3.282029] usb usb5: SerialNumber: 0000:00:1a.2
[    3.282166] hub 5-0:1.0: USB hub found
[    3.282229] hub 5-0:1.0: 2 ports detected
[    3.282366] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.282433] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.282502] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.282608] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a480
[    3.282698] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.282766] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.282849] usb usb6: Product: UHCI Host Controller
[    3.282913] usb usb6: Manufacturer: Linux 3.4.1-custom uhci_hcd
[    3.282978] usb usb6: SerialNumber: 0000:00:1d.0
[    3.283115] hub 6-0:1.0: USB hub found
[    3.283178] hub 6-0:1.0: 2 ports detected
[    3.283309] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.283376] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.283445] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.283551] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
[    3.283642] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.283711] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.283794] usb usb7: Product: UHCI Host Controller
[    3.283857] usb usb7: Manufacturer: Linux 3.4.1-custom uhci_hcd
[    3.283923] usb usb7: SerialNumber: 0000:00:1d.1
[    3.284061] hub 7-0:1.0: USB hub found
[    3.284124] hub 7-0:1.0: 2 ports detected
[    3.284252] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.284319] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.284388] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.284494] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a080
[    3.284586] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.284654] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.284742] usb usb8: Product: UHCI Host Controller
[    3.284805] usb usb8: Manufacturer: Linux 3.4.1-custom uhci_hcd
[    3.284871] usb usb8: SerialNumber: 0000:00:1d.2
[    3.285009] hub 8-0:1.0: USB hub found
[    3.285072] hub 8-0:1.0: 2 ports detected
[    3.301389] e1000e 0000:06:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:25:90:22:b5:de
[    3.301477] e1000e 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.301630] e1000e 0000:06:00.0: eth0: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    3.301709] e1000e 0000:07:00.0: Disabling ASPM L0s 
[    3.301901] e1000e 0000:07:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.302080] e1000e 0000:07:00.0: irq 50 for MSI/MSI-X
[    3.302149] e1000e 0000:07:00.0: irq 51 for MSI/MSI-X
[    3.302224] e1000e 0000:07:00.0: irq 52 for MSI/MSI-X
[    3.314226] scsi0 : LSI SAS based MegaRAID driver
[    3.314488] scsi 0:0:0:0: Direct-Access     LSI      MR9265-8i        3.13 PQ: 0 ANSI: 5
[    3.314678] scsi 0:0:1:0: Direct-Access     LSI      MR9265-8i        3.13 PQ: 0 ANSI: 5
[    3.325627] scsi 0:2:0:0: Direct-Access     LSI      MR9265-8i        3.13 PQ: 0 ANSI: 5
[    3.325819] scsi 0:2:1:0: Direct-Access     LSI      MR9265-8i        3.13 PQ: 0 ANSI: 5
[    3.418877] e1000e 0000:07:00.0: eth1: (PCI Express:2.5GT/s:Width x1) 00:25:90:22:b5:df
[    3.418966] e1000e 0000:07:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    3.419118] e1000e 0000:07:00.0: eth1: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    3.557679] ata1: SATA link down (SStatus 0 SControl 300)
[    3.765237] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    3.853071] Refined TSC clocksource calibration: 2133.333 MHz.
[    3.853146] Switching to clocksource tsc
[    3.877005] ata2: SATA link down (SStatus 0 SControl 300)
[    3.972800] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[    4.147943] usb 5-2: New USB device found, idVendor=046b, idProduct=ff10
[    4.148019] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.148087] usb 5-2: Product: Virtual Keyboard and Mouse
[    4.148152] usb 5-2: Manufacturer: American Megatrends Inc.
[    4.148217] usb 5-2: SerialNumber: serial
[    4.196342] ata3: SATA link down (SStatus 0 SControl 300)
[    4.515674] ata4: SATA link down (SStatus 0 SControl 300)
[    4.835005] ata5: SATA link down (SStatus 0 SControl 300)
[    5.154339] ata6: SATA link down (SStatus 0 SControl 300)
[    5.157352] sd 0:2:0:0: [sda] 85930803200 512-byte logical blocks: (43.9 TB/40.0 TiB)
[    5.157451] sd 0:2:1:0: [sdb] 85930803200 512-byte logical blocks: (43.9 TB/40.0 TiB)
[    5.157505] sd 0:2:0:0: [sda] Write Protect is off
[    5.157508] sd 0:2:0:0: [sda] Mode Sense: 1f 00 00 08
[    5.157540] sd 0:2:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.157800] sd 0:2:1:0: [sdb] Write Protect is off
[    5.157866] sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08
[    5.157979] sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.158200]  sda: unknown partition table
[    5.158440] sd 0:2:0:0: [sda] Attached SCSI disk
[    5.158651]  sdb: unknown partition table
[    5.158876] sd 0:2:1:0: [sdb] Attached SCSI disk
[    5.165993] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input0
[    5.166135] generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-2/input0
[    5.180920] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input1
[    5.181070] generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-2/input1
[    5.181197] usbcore: registered new interface driver usbhid
[    5.181260] usbhid: USB HID core driver
[   16.975522] scsi7 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=478, IRQ=16
[   17.215072] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.294840] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   19.924507] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   19.926104] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.301021] Uniform Multi-Platform E-IDE driver
[   20.301521] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   20.301618] Probing IDE interface ide0...
[   20.861594] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   20.861721] Probing IDE interface ide1...
[   21.420416] ide1 at 0x170-0x177,0x376 on irq 15
[   30.437650] eth0: no IPv6 routers present
[   56.451263] aufs 3.4-20120521
[   56.461766] loop: module loaded
[   56.470713] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   57.358821] udev[994]: starting version 164
[   57.393390] ACPI: Requesting acpi_cpufreq
[   57.394174] Monitor-Mwait will be used to enter C-1 state
[   57.394336] Monitor-Mwait will be used to enter C-2 state
[   57.394618] Monitor-Mwait will be used to enter C-3 state
[   57.394699] ACPI: acpi_idle registered with cpuidle
[   57.396406] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[   57.396498] ACPI: Power Button [PWRB]
[   57.400539] dca service started, version 1.12.1
[   57.400888] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   57.400977] ACPI: Power Button [PWRF]
[   57.422907] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   57.423126] ioatdma 0000:00:16.0: irq 53 for MSI/MSI-X
[   57.423520] ioatdma 0000:00:16.1: irq 54 for MSI/MSI-X
[   57.423969] ioatdma 0000:00:16.2: irq 55 for MSI/MSI-X
[   57.424329] ioatdma 0000:00:16.3: irq 56 for MSI/MSI-X
[   57.424740] ioatdma 0000:00:16.4: irq 57 for MSI/MSI-X
[   57.425153] ioatdma 0000:00:16.5: irq 58 for MSI/MSI-X
[   57.425688] ioatdma 0000:00:16.6: irq 59 for MSI/MSI-X
[   57.426030] ioatdma 0000:00:16.7: irq 60 for MSI/MSI-X
[   57.471440] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[   57.521149] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[   57.524137] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[   57.527186] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[   57.530154] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   58.757806] 8021q: 802.1Q VLAN Support v1.8
[   58.757886] 8021q: adding VLAN 0 to HW filter on device eth0
[   58.757966] 8021q: adding VLAN 0 to HW filter on device eth1
[   58.776430] myri10ge: Version 1.5.3-1.534
[   59.369974] fuse init (API version 7.18)

--------------080501000505030604090909
Content-Type: text/plain; name="lsmod.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="lsmod.txt"

Module                  Size  Used by
xfs                   734716  2 
cpufreq_userspace       1920  0 
cpufreq_stats           2698  0 
cpufreq_powersave        926  0 
cpufreq_conservative     4507  0 
fuse                   55799  1 
myri10ge               34069  0 
inet_lro                4016  1 myri10ge
8021q                  15141  0 
garp                    4910  1 8021q
stp                     1448  1 garp
llc                     3295  2 garp,stp
coretemp                5185  0 
crc32c_intel            1752  0 
tpm_tis                 7917  0 
joydev                  9026  0 
microcode              21193  0 
evdev                   8600  0 
tpm                    11395  1 tpm_tis
tpm_bios                4447  1 tpm
serio_raw               4025  0 
i2c_i801                7430  0 
i2c_core               16654  1 i2c_i801
ioatdma                33323  24 
acpi_cpufreq            5165  1 
mperf                   1139  1 acpi_cpufreq
dca                     4392  2 myri10ge,ioatdma
button                  4207  0 
processor              25994  5 acpi_cpufreq
thermal_sys            12408  1 processor
squashfs               20995  1 
loop                   14297  2 
aufs                  141050  47 
exportfs                2983  2 xfs,aufs
ide_generic             1129  0 [permanent]
ide_core               73401  1 ide_generic
usbhid                 30465  0 
hid                    71737  1 usbhid
sd_mod                 30496  2 
crc_t10dif              1284  1 sd_mod
uhci_hcd               18857  0 
mptsas                 41169  0 
mptscsih               24130  1 mptsas
mptbase                71228  2 mptsas,mptscsih
scsi_transport_sas     20692  1 mptsas
ehci_hcd               32682  0 
ahci                   19429  0 
libahci                16642  1 ahci
megaraid_sas           59485  2 
libata                136413  2 ahci,libahci
usbcore               122255  4 usbhid,uhci_hcd,ehci_hcd
e1000e                121715  0 
scsi_mod              161423  6 sd_mod,mptsas,mptscsih,scsi_transport_sas,megaraid_sas,libata
usb_common               890  1 usbcore

--------------080501000505030604090909
Content-Type: text/plain; name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device f580
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #4, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device f580
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #6, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:05.0 PCI bridge: Intel Corporation 5520/X58 I/O Hub PCI Express Root Port 5 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device f580
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #5, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fb800000-fb8fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device f580
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #3, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd+
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:09.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 9 (rev 22) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fb900000-fbbfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Super Micro Computer Inc Device f580
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #57, PowerLimit 25.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 22) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fbef8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fbef4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbef0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fbeec000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fbee8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fbee4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbee0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fbedc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ioatdma

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at ac00 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at a880 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at a800 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbeda000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee00000  Data: 4069
	Capabilities: [90] Subsystem: Super Micro Computer Inc Device f580
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000f0200000-00000000f03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee00000  Data: 4071
	Capabilities: [90] Subsystem: Super Micro Computer Inc Device f580
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at a480 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at a400 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3 (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at a080 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbed8000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: faf00000-fb7fffff
	Prefetchable memory behind bridge: 00000000f9000000-00000000f9ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Super Micro Computer Inc Device f580

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 49
	Region 0: I/O ports at 9480 [size=8]
	Region 1: I/O ports at a000 [size=4]
	Region 2: I/O ports at 9c00 [size=8]
	Region 3: I/O ports at 9880 [size=4]
	Region 4: I/O ports at 9800 [size=32]
	Region 5: Memory at fbed6000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee00000  Data: 40b1
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbed4000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus

04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS TB (rev 01)
	Subsystem: LSI Logic / Symbios Logic Device 9265
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at b000 [size=256]
	Region 1: Memory at fb87c000 (64-bit, non-prefetchable) [size=16K]
	Region 3: Memory at fb8c0000 (64-bit, non-prefetchable) [size=256K]
	Expansion ROM at fb880000 [disabled] [size=256K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [c0] MSI-X: Enable+ Count=16 Masked-
		Vector table: BAR=1 offset=00002000
		PBA: BAR=1 offset=00003000
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [1e0 v1] #19
	Capabilities: [1c0 v1] Power Budgeting <?>
	Capabilities: [190 v1] #16
	Capabilities: [148 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Kernel driver in use: megaraid_sas

05:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS (rev 08)
	Subsystem: Super Micro Computer Inc Device 0005
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at c000 [size=256]
	Region 1: Memory at fb9ec000 (64-bit, non-prefetchable) [size=16K]
	Region 3: Memory at fb9f0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at fba00000 [disabled] [size=2M]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [98] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [b0] MSI-X: Enable- Count=1 Masked-
		Vector table: BAR=1 offset=00002000
		PBA: BAR=1 offset=00003000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: mptsas

06:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
	Subsystem: Super Micro Computer Inc Device 10d3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fbce0000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at dc00 [size=32]
	Region 3: Memory at fbcdc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Kernel driver in use: e1000e

07:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
	Subsystem: Super Micro Computer Inc Device 10d3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fbde0000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at ec00 [size=32]
	Region 3: Memory at fbddc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Kernel driver in use: e1000e

08:04.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200eW WPCM450 (rev 0a) (prog-if 00 [VGA controller])
	Subsystem: Super Micro Computer Inc Device f580
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (4000ns min, 8000ns max), Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 15
	Region 0: Memory at f9000000 (32-bit, prefetchable) [size=16M]
	Region 1: Memory at faffc000 (32-bit, non-prefetchable) [size=16K]
	Region 2: Memory at fb000000 (32-bit, non-prefetchable) [size=8M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

ff:00.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Architecture Generic Non-Core Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Architecture System Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.4 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 1 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.5 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 1 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Target Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller RAS Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:03.4 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Test Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:04.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:05.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:06.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0


--------------080501000505030604090909
Content-Type: text/plain; name="mount.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="mount.txt"

aufs on / type aufs (rw)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
ram on /live/image type ramfs (rw,relatime)
tmpfs on /live/cow type tmpfs (rw,noatime,mode=755)
tmpfs on /live type tmpfs (rw,relatime)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
/dev/sda on /news/spool/news/P.01 type xfs (rw,noatime,nodiratime,nobarrier,inode64,logbufs=8,logbsize=256k)
/dev/sdb on /news/spool/news/P.02 type xfs (rw,noatime,nodiratime,nobarrier,inode64,logbufs=8,logbsize=256k)
ramfs on /news/history type ramfs (rw,noatime)

--------------080501000505030604090909
Content-Type: text/plain; name="sysctl.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="sysctl.txt"

abi.vsyscall32 = 1
debug.exception-trace = 1
debug.kprobes-optimization = 1
dev.hpet.max-user-freq = 64
dev.scsi.logging_level = 0
fs.aio-max-nr = 65536
fs.aio-nr = 0
fs.dentry-state = 14649	7194	45	0	0	0
fs.dir-notify-enable = 1
fs.epoll.max_user_watches = 5034106
fs.file-max = 2458026
fs.file-nr = 736	0	2458026
fs.inode-nr = 16836	4187
fs.inode-state = 16836	4187	0	0	0	0	0
fs.inotify.max_queued_events = 16384
fs.inotify.max_user_instances = 128
fs.inotify.max_user_watches = 8192
fs.lease-break-time = 45
fs.leases-enable = 1
fs.mqueue.msg_max = 10
fs.mqueue.msgsize_max = 8192
fs.mqueue.queues_max = 256
fs.nr_open = 1048576
fs.overflowgid = 65534
fs.overflowuid = 65534
fs.pipe-max-size = 1048576
fs.quota.allocated_dquots = 0
fs.quota.cache_hits = 0
fs.quota.drops = 0
fs.quota.free_dquots = 0
fs.quota.lookups = 0
fs.quota.reads = 0
fs.quota.syncs = 0
fs.quota.warnings = 1
fs.quota.writes = 0
fs.suid_dumpable = 0
fs.xfs.age_buffer_centisecs = 1500
fs.xfs.error_level = 3
fs.xfs.filestream_centisecs = 3000
fs.xfs.inherit_noatime = 1
fs.xfs.inherit_nodefrag = 1
fs.xfs.inherit_nodump = 1
fs.xfs.inherit_nosymlinks = 0
fs.xfs.inherit_sync = 1
fs.xfs.irix_sgid_inherit = 0
fs.xfs.irix_symlink_mode = 0
fs.xfs.panic_mask = 0
fs.xfs.rotorstep = 1
fs.xfs.stats_clear = 0
fs.xfs.xfsbufd_centisecs = 100
fs.xfs.xfssyncd_centisecs = 3000
kernel.acct = 4	2	30
kernel.acpi_video_flags = 0
kernel.auto_msgmni = 1
kernel.blk_iopoll = 1
kernel.bootloader_type = 50
kernel.bootloader_version = 2
kernel.cad_pid = 1
kernel.cap_last_cap = 35
kernel.compat-log = 1
kernel.core_pattern = core
kernel.core_pipe_limit = 0
kernel.core_uses_pid = 0
kernel.ctrl-alt-del = 0
kernel.dmesg_restrict = 0
kernel.domainname = (none)
kernel.ftrace_dump_on_oops = 0
kernel.hostname = sd69
kernel.hotplug = 
kernel.hung_task_check_count = 4194304
kernel.hung_task_panic = 0
kernel.hung_task_timeout_secs = 120
kernel.hung_task_warnings = 0
kernel.io_delay_type = 0
kernel.keys.gc_delay = 300
kernel.keys.maxbytes = 20000
kernel.keys.maxkeys = 200
kernel.keys.root_maxbytes = 20000
kernel.keys.root_maxkeys = 200
kernel.kptr_restrict = 0
kernel.kstack_depth_to_print = 12
kernel.max_lock_depth = 1024
kernel.modprobe = /sbin/modprobe
kernel.modules_disabled = 0
kernel.msgmax = 8192
kernel.msgmnb = 16384
kernel.msgmni = 32768
kernel.ngroups_max = 65536
kernel.ns_last_pid = 12222
kernel.osrelease = 3.4.1-custom
kernel.ostype = Linux
kernel.overflowgid = 65534
kernel.overflowuid = 65534
kernel.panic = 60
kernel.panic_on_io_nmi = 0
kernel.panic_on_oops = 0
kernel.panic_on_unrecovered_nmi = 0
kernel.perf_event_max_sample_rate = 100000
kernel.perf_event_mlock_kb = 516
kernel.perf_event_paranoid = 1
kernel.pid_max = 32768
kernel.poweroff_cmd = /sbin/poweroff
kernel.print-fatal-signals = 0
kernel.printk = 10	4	1	7
kernel.printk_delay = 0
kernel.printk_ratelimit = 5
kernel.printk_ratelimit_burst = 10
kernel.pty.max = 4096
kernel.pty.nr = 3
kernel.pty.reserve = 1024
kernel.random.boot_id = 193fa337-530b-4b7b-9f8f-152179da4b06
kernel.random.entropy_avail = 2852
kernel.random.poolsize = 4096
kernel.random.read_wakeup_threshold = 64
kernel.random.uuid = dc1547f7-77bc-491a-9b08-f9cdbd67d200
kernel.random.write_wakeup_threshold = 128
kernel.randomize_va_space = 2
kernel.real-root-dev = 0
kernel.sched_child_runs_first = 0
kernel.sched_domain.cpu0.domain0.busy_factor = 64
kernel.sched_domain.cpu0.domain0.busy_idx = 2
kernel.sched_domain.cpu0.domain0.cache_nice_tries = 1
kernel.sched_domain.cpu0.domain0.flags = 4655
kernel.sched_domain.cpu0.domain0.forkexec_idx = 0
kernel.sched_domain.cpu0.domain0.idle_idx = 0
kernel.sched_domain.cpu0.domain0.imbalance_pct = 125
kernel.sched_domain.cpu0.domain0.max_interval = 4
kernel.sched_domain.cpu0.domain0.min_interval = 1
kernel.sched_domain.cpu0.domain0.name = MC
kernel.sched_domain.cpu0.domain0.newidle_idx = 0
kernel.sched_domain.cpu0.domain0.wake_idx = 0
kernel.sched_domain.cpu1.domain0.busy_factor = 64
kernel.sched_domain.cpu1.domain0.busy_idx = 2
kernel.sched_domain.cpu1.domain0.cache_nice_tries = 1
kernel.sched_domain.cpu1.domain0.flags = 4655
kernel.sched_domain.cpu1.domain0.forkexec_idx = 0
kernel.sched_domain.cpu1.domain0.idle_idx = 0
kernel.sched_domain.cpu1.domain0.imbalance_pct = 125
kernel.sched_domain.cpu1.domain0.max_interval = 4
kernel.sched_domain.cpu1.domain0.min_interval = 1
kernel.sched_domain.cpu1.domain0.name = MC
kernel.sched_domain.cpu1.domain0.newidle_idx = 0
kernel.sched_domain.cpu1.domain0.wake_idx = 0
kernel.sched_domain.cpu2.domain0.busy_factor = 64
kernel.sched_domain.cpu2.domain0.busy_idx = 2
kernel.sched_domain.cpu2.domain0.cache_nice_tries = 1
kernel.sched_domain.cpu2.domain0.flags = 4655
kernel.sched_domain.cpu2.domain0.forkexec_idx = 0
kernel.sched_domain.cpu2.domain0.idle_idx = 0
kernel.sched_domain.cpu2.domain0.imbalance_pct = 125
kernel.sched_domain.cpu2.domain0.max_interval = 4
kernel.sched_domain.cpu2.domain0.min_interval = 1
kernel.sched_domain.cpu2.domain0.name = MC
kernel.sched_domain.cpu2.domain0.newidle_idx = 0
kernel.sched_domain.cpu2.domain0.wake_idx = 0
kernel.sched_domain.cpu3.domain0.busy_factor = 64
kernel.sched_domain.cpu3.domain0.busy_idx = 2
kernel.sched_domain.cpu3.domain0.cache_nice_tries = 1
kernel.sched_domain.cpu3.domain0.flags = 4655
kernel.sched_domain.cpu3.domain0.forkexec_idx = 0
kernel.sched_domain.cpu3.domain0.idle_idx = 0
kernel.sched_domain.cpu3.domain0.imbalance_pct = 125
kernel.sched_domain.cpu3.domain0.max_interval = 4
kernel.sched_domain.cpu3.domain0.min_interval = 1
kernel.sched_domain.cpu3.domain0.name = MC
kernel.sched_domain.cpu3.domain0.newidle_idx = 0
kernel.sched_domain.cpu3.domain0.wake_idx = 0
kernel.sched_latency_ns = 18000000
kernel.sched_migration_cost = 500000
kernel.sched_min_granularity_ns = 2250000
kernel.sched_nr_migrate = 32
kernel.sched_rt_period_us = 1000000
kernel.sched_rt_runtime_us = 950000
kernel.sched_shares_window = 10000000
kernel.sched_time_avg = 1000
kernel.sched_tunable_scaling = 1
kernel.sched_wakeup_granularity_ns = 3000000
kernel.sem = 250	32000	32	128
kernel.shm_rmid_forced = 0
kernel.shmall = 2097152
kernel.shmmax = 33554432
kernel.shmmni = 4096
kernel.sysrq = 1
kernel.tainted = 0
kernel.threads-max = 384072
kernel.timer_migration = 1
kernel.unknown_nmi_panic = 0
kernel.usermodehelper.bset = 4294967295	4294967295
kernel.usermodehelper.inheritable = 4294967295	4294967295
kernel.version = #4 SMP Mon Jun 11 09:35:31 CEST 2012
net.core.dev_weight = 64
net.core.message_burst = 10
net.core.message_cost = 5
net.core.netdev_budget = 300
net.core.netdev_max_backlog = 1000
net.core.netdev_tstamp_prequeue = 1
net.core.optmem_max = 20480
net.core.rmem_default = 212992
net.core.rmem_max = 131071
net.core.rps_sock_flow_entries = 0
net.core.somaxconn = 128
net.core.warnings = 1
net.core.wmem_default = 212992
net.core.wmem_max = 131071
net.core.xfrm_acq_expires = 30
net.core.xfrm_aevent_etime = 10
net.core.xfrm_aevent_rseqth = 2
net.core.xfrm_larval_drop = 1
net.ipv4.conf.all.accept_local = 0
net.ipv4.conf.all.accept_redirects = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.arp_accept = 0
net.ipv4.conf.all.arp_announce = 0
net.ipv4.conf.all.arp_filter = 0
net.ipv4.conf.all.arp_ignore = 0
net.ipv4.conf.all.arp_notify = 0
net.ipv4.conf.all.bootp_relay = 0
net.ipv4.conf.all.disable_policy = 0
net.ipv4.conf.all.disable_xfrm = 0
net.ipv4.conf.all.force_igmp_version = 0
net.ipv4.conf.all.forwarding = 0
net.ipv4.conf.all.log_martians = 0
net.ipv4.conf.all.mc_forwarding = 0
net.ipv4.conf.all.medium_id = 0
net.ipv4.conf.all.promote_secondaries = 0
net.ipv4.conf.all.proxy_arp = 0
net.ipv4.conf.all.proxy_arp_pvlan = 0
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.all.secure_redirects = 1
net.ipv4.conf.all.send_redirects = 1
net.ipv4.conf.all.shared_media = 1
net.ipv4.conf.all.src_valid_mark = 0
net.ipv4.conf.all.tag = 0
net.ipv4.conf.default.accept_local = 0
net.ipv4.conf.default.accept_redirects = 1
net.ipv4.conf.default.accept_source_route = 1
net.ipv4.conf.default.arp_accept = 0
net.ipv4.conf.default.arp_announce = 0
net.ipv4.conf.default.arp_filter = 0
net.ipv4.conf.default.arp_ignore = 0
net.ipv4.conf.default.arp_notify = 0
net.ipv4.conf.default.bootp_relay = 0
net.ipv4.conf.default.disable_policy = 0
net.ipv4.conf.default.disable_xfrm = 0
net.ipv4.conf.default.force_igmp_version = 0
net.ipv4.conf.default.forwarding = 0
net.ipv4.conf.default.log_martians = 0
net.ipv4.conf.default.mc_forwarding = 0
net.ipv4.conf.default.medium_id = 0
net.ipv4.conf.default.promote_secondaries = 0
net.ipv4.conf.default.proxy_arp = 0
net.ipv4.conf.default.proxy_arp_pvlan = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.secure_redirects = 1
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.default.shared_media = 1
net.ipv4.conf.default.src_valid_mark = 0
net.ipv4.conf.default.tag = 0
net.ipv4.conf.eth0.accept_local = 0
net.ipv4.conf.eth0.accept_redirects = 1
net.ipv4.conf.eth0.accept_source_route = 1
net.ipv4.conf.eth0.arp_accept = 0
net.ipv4.conf.eth0.arp_announce = 0
net.ipv4.conf.eth0.arp_filter = 0
net.ipv4.conf.eth0.arp_ignore = 0
net.ipv4.conf.eth0.arp_notify = 0
net.ipv4.conf.eth0.bootp_relay = 0
net.ipv4.conf.eth0.disable_policy = 0
net.ipv4.conf.eth0.disable_xfrm = 0
net.ipv4.conf.eth0.force_igmp_version = 0
net.ipv4.conf.eth0.forwarding = 0
net.ipv4.conf.eth0.log_martians = 0
net.ipv4.conf.eth0.mc_forwarding = 0
net.ipv4.conf.eth0.medium_id = 0
net.ipv4.conf.eth0.promote_secondaries = 0
net.ipv4.conf.eth0.proxy_arp = 0
net.ipv4.conf.eth0.proxy_arp_pvlan = 0
net.ipv4.conf.eth0.rp_filter = 0
net.ipv4.conf.eth0.secure_redirects = 1
net.ipv4.conf.eth0.send_redirects = 1
net.ipv4.conf.eth0.shared_media = 1
net.ipv4.conf.eth0.src_valid_mark = 0
net.ipv4.conf.eth0.tag = 0
net.ipv4.conf.eth1.accept_local = 0
net.ipv4.conf.eth1.accept_redirects = 1
net.ipv4.conf.eth1.accept_source_route = 1
net.ipv4.conf.eth1.arp_accept = 0
net.ipv4.conf.eth1.arp_announce = 0
net.ipv4.conf.eth1.arp_filter = 0
net.ipv4.conf.eth1.arp_ignore = 0
net.ipv4.conf.eth1.arp_notify = 0
net.ipv4.conf.eth1.bootp_relay = 0
net.ipv4.conf.eth1.disable_policy = 0
net.ipv4.conf.eth1.disable_xfrm = 0
net.ipv4.conf.eth1.force_igmp_version = 0
net.ipv4.conf.eth1.forwarding = 0
net.ipv4.conf.eth1.log_martians = 0
net.ipv4.conf.eth1.mc_forwarding = 0
net.ipv4.conf.eth1.medium_id = 0
net.ipv4.conf.eth1.promote_secondaries = 0
net.ipv4.conf.eth1.proxy_arp = 0
net.ipv4.conf.eth1.proxy_arp_pvlan = 0
net.ipv4.conf.eth1.rp_filter = 0
net.ipv4.conf.eth1.secure_redirects = 1
net.ipv4.conf.eth1.send_redirects = 1
net.ipv4.conf.eth1.shared_media = 1
net.ipv4.conf.eth1.src_valid_mark = 0
net.ipv4.conf.eth1.tag = 0
net.ipv4.conf.lo.accept_local = 0
net.ipv4.conf.lo.accept_redirects = 1
net.ipv4.conf.lo.accept_source_route = 1
net.ipv4.conf.lo.arp_accept = 0
net.ipv4.conf.lo.arp_announce = 0
net.ipv4.conf.lo.arp_filter = 0
net.ipv4.conf.lo.arp_ignore = 0
net.ipv4.conf.lo.arp_notify = 0
net.ipv4.conf.lo.bootp_relay = 0
net.ipv4.conf.lo.disable_policy = 1
net.ipv4.conf.lo.disable_xfrm = 1
net.ipv4.conf.lo.force_igmp_version = 0
net.ipv4.conf.lo.forwarding = 0
net.ipv4.conf.lo.log_martians = 0
net.ipv4.conf.lo.mc_forwarding = 0
net.ipv4.conf.lo.medium_id = 0
net.ipv4.conf.lo.promote_secondaries = 0
net.ipv4.conf.lo.proxy_arp = 0
net.ipv4.conf.lo.proxy_arp_pvlan = 0
net.ipv4.conf.lo.rp_filter = 0
net.ipv4.conf.lo.secure_redirects = 1
net.ipv4.conf.lo.send_redirects = 1
net.ipv4.conf.lo.shared_media = 1
net.ipv4.conf.lo.src_valid_mark = 0
net.ipv4.conf.lo.tag = 0
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_errors_use_inbound_ifaddr = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_ratelimit = 1000
net.ipv4.icmp_ratemask = 6168
net.ipv4.igmp_max_memberships = 20
net.ipv4.igmp_max_msf = 10
net.ipv4.inet_peer_maxttl = 600
net.ipv4.inet_peer_minttl = 120
net.ipv4.inet_peer_threshold = 65664
net.ipv4.ip_default_ttl = 64
net.ipv4.ip_dynaddr = 0
net.ipv4.ip_forward = 0
net.ipv4.ip_local_port_range = 32768	61000
net.ipv4.ip_local_reserved_ports = 
net.ipv4.ip_no_pmtu_disc = 0
net.ipv4.ip_nonlocal_bind = 0
net.ipv4.ipfrag_high_thresh = 262144
net.ipv4.ipfrag_low_thresh = 196608
net.ipv4.ipfrag_max_dist = 64
net.ipv4.ipfrag_secret_interval = 600
net.ipv4.ipfrag_time = 30
net.ipv4.neigh.default.anycast_delay = 100
net.ipv4.neigh.default.app_solicit = 0
net.ipv4.neigh.default.base_reachable_time = 30
net.ipv4.neigh.default.base_reachable_time_ms = 30000
net.ipv4.neigh.default.delay_first_probe_time = 5
net.ipv4.neigh.default.gc_interval = 30
net.ipv4.neigh.default.gc_stale_time = 60
net.ipv4.neigh.default.gc_thresh1 = 128
net.ipv4.neigh.default.gc_thresh2 = 512
net.ipv4.neigh.default.gc_thresh3 = 1024
net.ipv4.neigh.default.locktime = 100
net.ipv4.neigh.default.mcast_solicit = 3
net.ipv4.neigh.default.proxy_delay = 80
net.ipv4.neigh.default.proxy_qlen = 64
net.ipv4.neigh.default.retrans_time = 100
net.ipv4.neigh.default.retrans_time_ms = 1000
net.ipv4.neigh.default.ucast_solicit = 3
net.ipv4.neigh.default.unres_qlen = 32
net.ipv4.neigh.default.unres_qlen_bytes = 65536
net.ipv4.neigh.eth0.anycast_delay = 100
net.ipv4.neigh.eth0.app_solicit = 0
net.ipv4.neigh.eth0.base_reachable_time = 30
net.ipv4.neigh.eth0.base_reachable_time_ms = 30000
net.ipv4.neigh.eth0.delay_first_probe_time = 5
net.ipv4.neigh.eth0.gc_stale_time = 60
net.ipv4.neigh.eth0.locktime = 100
net.ipv4.neigh.eth0.mcast_solicit = 3
net.ipv4.neigh.eth0.proxy_delay = 80
net.ipv4.neigh.eth0.proxy_qlen = 64
net.ipv4.neigh.eth0.retrans_time = 100
net.ipv4.neigh.eth0.retrans_time_ms = 1000
net.ipv4.neigh.eth0.ucast_solicit = 3
net.ipv4.neigh.eth0.unres_qlen = 32
net.ipv4.neigh.eth0.unres_qlen_bytes = 65536
net.ipv4.neigh.eth1.anycast_delay = 100
net.ipv4.neigh.eth1.app_solicit = 0
net.ipv4.neigh.eth1.base_reachable_time = 30
net.ipv4.neigh.eth1.base_reachable_time_ms = 30000
net.ipv4.neigh.eth1.delay_first_probe_time = 5
net.ipv4.neigh.eth1.gc_stale_time = 60
net.ipv4.neigh.eth1.locktime = 100
net.ipv4.neigh.eth1.mcast_solicit = 3
net.ipv4.neigh.eth1.proxy_delay = 80
net.ipv4.neigh.eth1.proxy_qlen = 64
net.ipv4.neigh.eth1.retrans_time = 100
net.ipv4.neigh.eth1.retrans_time_ms = 1000
net.ipv4.neigh.eth1.ucast_solicit = 3
net.ipv4.neigh.eth1.unres_qlen = 32
net.ipv4.neigh.eth1.unres_qlen_bytes = 65536
net.ipv4.neigh.lo.anycast_delay = 100
net.ipv4.neigh.lo.app_solicit = 0
net.ipv4.neigh.lo.base_reachable_time = 30
net.ipv4.neigh.lo.base_reachable_time_ms = 30000
net.ipv4.neigh.lo.delay_first_probe_time = 5
net.ipv4.neigh.lo.gc_stale_time = 60
net.ipv4.neigh.lo.locktime = 100
net.ipv4.neigh.lo.mcast_solicit = 3
net.ipv4.neigh.lo.proxy_delay = 80
net.ipv4.neigh.lo.proxy_qlen = 64
net.ipv4.neigh.lo.retrans_time = 100
net.ipv4.neigh.lo.retrans_time_ms = 1000
net.ipv4.neigh.lo.ucast_solicit = 3
net.ipv4.neigh.lo.unres_qlen = 32
net.ipv4.neigh.lo.unres_qlen_bytes = 65536
net.ipv4.ping_group_range = 1	0
net.ipv4.route.error_burst = 1250
net.ipv4.route.error_cost = 250
net.ipv4.route.gc_elasticity = 8
net.ipv4.route.gc_interval = 60
net.ipv4.route.gc_min_interval = 0
net.ipv4.route.gc_min_interval_ms = 500
net.ipv4.route.gc_thresh = 524288
net.ipv4.route.gc_timeout = 300
net.ipv4.route.max_size = 8388608
net.ipv4.route.min_adv_mss = 256
net.ipv4.route.min_pmtu = 552
net.ipv4.route.mtu_expires = 600
net.ipv4.route.redirect_load = 5
net.ipv4.route.redirect_number = 9
net.ipv4.route.redirect_silence = 5120
net.ipv4.rt_cache_rebuild_count = 4
net.ipv4.tcp_abc = 0
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_adv_win_scale = 1
net.ipv4.tcp_allowed_congestion_control = cubic reno
net.ipv4.tcp_app_win = 31
net.ipv4.tcp_available_congestion_control = cubic reno
net.ipv4.tcp_base_mss = 512
net.ipv4.tcp_congestion_control = cubic
net.ipv4.tcp_cookie_size = 0
net.ipv4.tcp_dma_copybreak = 262144
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_fack = 1
net.ipv4.tcp_fin_timeout = 60
net.ipv4.tcp_frto = 2
net.ipv4.tcp_frto_response = 0
net.ipv4.tcp_keepalive_intvl = 75
net.ipv4.tcp_keepalive_probes = 9
net.ipv4.tcp_keepalive_time = 7200
net.ipv4.tcp_low_latency = 0
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_ssthresh = 0
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_max_tw_buckets = 262144
net.ipv4.tcp_mem = 579501	772668	1159002
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_mtu_probing = 0
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_orphan_retries = 0
net.ipv4.tcp_reordering = 3
net.ipv4.tcp_retrans_collapse = 1
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 15
net.ipv4.tcp_rfc1337 = 0
net.ipv4.tcp_rmem = 4096	87380	6291456
net.ipv4.tcp_sack = 1
net.ipv4.tcp_slow_start_after_idle = 1
net.ipv4.tcp_stdurg = 0
net.ipv4.tcp_syn_retries = 5
net.ipv4.tcp_synack_retries = 5
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_thin_dupack = 0
net.ipv4.tcp_thin_linear_timeouts = 0
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tso_win_divisor = 3
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 4096	16384	4194304
net.ipv4.tcp_workaround_signed_windows = 0
net.ipv4.udp_mem = 580200	773600	1160400
net.ipv4.udp_rmem_min = 4096
net.ipv4.udp_wmem_min = 4096
net.ipv4.xfrm4_gc_thresh = 4194304
net.ipv6.bindv6only = 0
net.ipv6.conf.all.accept_dad = 1
net.ipv6.conf.all.accept_ra = 1
net.ipv6.conf.all.accept_ra_defrtr = 1
net.ipv6.conf.all.accept_ra_pinfo = 1
net.ipv6.conf.all.accept_ra_rt_info_max_plen = 0
net.ipv6.conf.all.accept_ra_rtr_pref = 1
net.ipv6.conf.all.accept_redirects = 1
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.all.autoconf = 1
net.ipv6.conf.all.dad_transmits = 1
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.all.force_mld_version = 0
net.ipv6.conf.all.force_tllao = 0
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.all.hop_limit = 64
net.ipv6.conf.all.max_addresses = 16
net.ipv6.conf.all.max_desync_factor = 600
net.ipv6.conf.all.mc_forwarding = 0
net.ipv6.conf.all.mtu = 1280
net.ipv6.conf.all.optimistic_dad = 0
net.ipv6.conf.all.proxy_ndp = 0
net.ipv6.conf.all.regen_max_retry = 3
net.ipv6.conf.all.router_probe_interval = 60
net.ipv6.conf.all.router_solicitation_delay = 1
net.ipv6.conf.all.router_solicitation_interval = 4
net.ipv6.conf.all.router_solicitations = 3
net.ipv6.conf.all.temp_prefered_lft = 86400
net.ipv6.conf.all.temp_valid_lft = 604800
net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.accept_dad = 1
net.ipv6.conf.default.accept_ra = 1
net.ipv6.conf.default.accept_ra_defrtr = 1
net.ipv6.conf.default.accept_ra_pinfo = 1
net.ipv6.conf.default.accept_ra_rt_info_max_plen = 0
net.ipv6.conf.default.accept_ra_rtr_pref = 1
net.ipv6.conf.default.accept_redirects = 1
net.ipv6.conf.default.accept_source_route = 0
net.ipv6.conf.default.autoconf = 1
net.ipv6.conf.default.dad_transmits = 1
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.default.force_mld_version = 0
net.ipv6.conf.default.force_tllao = 0
net.ipv6.conf.default.forwarding = 0
net.ipv6.conf.default.hop_limit = 64
net.ipv6.conf.default.max_addresses = 16
net.ipv6.conf.default.max_desync_factor = 600
net.ipv6.conf.default.mc_forwarding = 0
net.ipv6.conf.default.mtu = 1280
net.ipv6.conf.default.optimistic_dad = 0
net.ipv6.conf.default.proxy_ndp = 0
net.ipv6.conf.default.regen_max_retry = 3
net.ipv6.conf.default.router_probe_interval = 60
net.ipv6.conf.default.router_solicitation_delay = 1
net.ipv6.conf.default.router_solicitation_interval = 4
net.ipv6.conf.default.router_solicitations = 3
net.ipv6.conf.default.temp_prefered_lft = 86400
net.ipv6.conf.default.temp_valid_lft = 604800
net.ipv6.conf.default.use_tempaddr = 0
net.ipv6.conf.eth0.accept_dad = 1
net.ipv6.conf.eth0.accept_ra = 1
net.ipv6.conf.eth0.accept_ra_defrtr = 1
net.ipv6.conf.eth0.accept_ra_pinfo = 1
net.ipv6.conf.eth0.accept_ra_rt_info_max_plen = 0
net.ipv6.conf.eth0.accept_ra_rtr_pref = 1
net.ipv6.conf.eth0.accept_redirects = 1
net.ipv6.conf.eth0.accept_source_route = 0
net.ipv6.conf.eth0.autoconf = 1
net.ipv6.conf.eth0.dad_transmits = 1
net.ipv6.conf.eth0.disable_ipv6 = 0
net.ipv6.conf.eth0.force_mld_version = 0
net.ipv6.conf.eth0.force_tllao = 0
net.ipv6.conf.eth0.forwarding = 0
net.ipv6.conf.eth0.hop_limit = 64
net.ipv6.conf.eth0.max_addresses = 16
net.ipv6.conf.eth0.max_desync_factor = 600
net.ipv6.conf.eth0.mc_forwarding = 0
net.ipv6.conf.eth0.mtu = 1500
net.ipv6.conf.eth0.optimistic_dad = 0
net.ipv6.conf.eth0.proxy_ndp = 0
net.ipv6.conf.eth0.regen_max_retry = 3
net.ipv6.conf.eth0.router_probe_interval = 60
net.ipv6.conf.eth0.router_solicitation_delay = 1
net.ipv6.conf.eth0.router_solicitation_interval = 4
net.ipv6.conf.eth0.router_solicitations = 3
net.ipv6.conf.eth0.temp_prefered_lft = 86400
net.ipv6.conf.eth0.temp_valid_lft = 604800
net.ipv6.conf.eth0.use_tempaddr = 0
net.ipv6.conf.eth1.accept_dad = 1
net.ipv6.conf.eth1.accept_ra = 1
net.ipv6.conf.eth1.accept_ra_defrtr = 1
net.ipv6.conf.eth1.accept_ra_pinfo = 1
net.ipv6.conf.eth1.accept_ra_rt_info_max_plen = 0
net.ipv6.conf.eth1.accept_ra_rtr_pref = 1
net.ipv6.conf.eth1.accept_redirects = 1
net.ipv6.conf.eth1.accept_source_route = 0
net.ipv6.conf.eth1.autoconf = 1
net.ipv6.conf.eth1.dad_transmits = 1
net.ipv6.conf.eth1.disable_ipv6 = 0
net.ipv6.conf.eth1.force_mld_version = 0
net.ipv6.conf.eth1.force_tllao = 0
net.ipv6.conf.eth1.forwarding = 0
net.ipv6.conf.eth1.hop_limit = 64
net.ipv6.conf.eth1.max_addresses = 16
net.ipv6.conf.eth1.max_desync_factor = 600
net.ipv6.conf.eth1.mc_forwarding = 0
net.ipv6.conf.eth1.mtu = 1500
net.ipv6.conf.eth1.optimistic_dad = 0
net.ipv6.conf.eth1.proxy_ndp = 0
net.ipv6.conf.eth1.regen_max_retry = 3
net.ipv6.conf.eth1.router_probe_interval = 60
net.ipv6.conf.eth1.router_solicitation_delay = 1
net.ipv6.conf.eth1.router_solicitation_interval = 4
net.ipv6.conf.eth1.router_solicitations = 3
net.ipv6.conf.eth1.temp_prefered_lft = 86400
net.ipv6.conf.eth1.temp_valid_lft = 604800
net.ipv6.conf.eth1.use_tempaddr = 0
net.ipv6.conf.lo.accept_dad = -1
net.ipv6.conf.lo.accept_ra = 1
net.ipv6.conf.lo.accept_ra_defrtr = 1
net.ipv6.conf.lo.accept_ra_pinfo = 1
net.ipv6.conf.lo.accept_ra_rt_info_max_plen = 0
net.ipv6.conf.lo.accept_ra_rtr_pref = 1
net.ipv6.conf.lo.accept_redirects = 1
net.ipv6.conf.lo.accept_source_route = 0
net.ipv6.conf.lo.autoconf = 1
net.ipv6.conf.lo.dad_transmits = 1
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.lo.force_mld_version = 0
net.ipv6.conf.lo.force_tllao = 0
net.ipv6.conf.lo.forwarding = 0
net.ipv6.conf.lo.hop_limit = 64
net.ipv6.conf.lo.max_addresses = 16
net.ipv6.conf.lo.max_desync_factor = 600
net.ipv6.conf.lo.mc_forwarding = 0
net.ipv6.conf.lo.mtu = 16436
net.ipv6.conf.lo.optimistic_dad = 0
net.ipv6.conf.lo.proxy_ndp = 0
net.ipv6.conf.lo.regen_max_retry = 3
net.ipv6.conf.lo.router_probe_interval = 60
net.ipv6.conf.lo.router_solicitation_delay = 1
net.ipv6.conf.lo.router_solicitation_interval = 4
net.ipv6.conf.lo.router_solicitations = 3
net.ipv6.conf.lo.temp_prefered_lft = 86400
net.ipv6.conf.lo.temp_valid_lft = 604800
net.ipv6.conf.lo.use_tempaddr = -1
net.ipv6.icmp.ratelimit = 1000
net.ipv6.ip6frag_high_thresh = 262144
net.ipv6.ip6frag_low_thresh = 196608
net.ipv6.ip6frag_secret_interval = 600
net.ipv6.ip6frag_time = 60
net.ipv6.mld_max_msf = 64
net.ipv6.neigh.default.anycast_delay = 100
net.ipv6.neigh.default.app_solicit = 0
net.ipv6.neigh.default.base_reachable_time = 30
net.ipv6.neigh.default.base_reachable_time_ms = 30000
net.ipv6.neigh.default.delay_first_probe_time = 5
net.ipv6.neigh.default.gc_interval = 30
net.ipv6.neigh.default.gc_stale_time = 60
net.ipv6.neigh.default.gc_thresh1 = 128
net.ipv6.neigh.default.gc_thresh2 = 512
net.ipv6.neigh.default.gc_thresh3 = 1024
net.ipv6.neigh.default.locktime = 0
net.ipv6.neigh.default.mcast_solicit = 3
net.ipv6.neigh.default.proxy_delay = 80
net.ipv6.neigh.default.proxy_qlen = 64
net.ipv6.neigh.default.retrans_time = 250
net.ipv6.neigh.default.retrans_time_ms = 1000
net.ipv6.neigh.default.ucast_solicit = 3
net.ipv6.neigh.default.unres_qlen = 32
net.ipv6.neigh.default.unres_qlen_bytes = 65536
net.ipv6.neigh.eth0.anycast_delay = 100
net.ipv6.neigh.eth0.app_solicit = 0
net.ipv6.neigh.eth0.base_reachable_time = 30
net.ipv6.neigh.eth0.base_reachable_time_ms = 30000
net.ipv6.neigh.eth0.delay_first_probe_time = 5
net.ipv6.neigh.eth0.gc_stale_time = 60
net.ipv6.neigh.eth0.locktime = 0
net.ipv6.neigh.eth0.mcast_solicit = 3
net.ipv6.neigh.eth0.proxy_delay = 80
net.ipv6.neigh.eth0.proxy_qlen = 64
net.ipv6.neigh.eth0.retrans_time = 250
net.ipv6.neigh.eth0.retrans_time_ms = 1000
net.ipv6.neigh.eth0.ucast_solicit = 3
net.ipv6.neigh.eth0.unres_qlen = 32
net.ipv6.neigh.eth0.unres_qlen_bytes = 65536
net.ipv6.neigh.eth1.anycast_delay = 100
net.ipv6.neigh.eth1.app_solicit = 0
net.ipv6.neigh.eth1.base_reachable_time = 30
net.ipv6.neigh.eth1.base_reachable_time_ms = 30000
net.ipv6.neigh.eth1.delay_first_probe_time = 5
net.ipv6.neigh.eth1.gc_stale_time = 60
net.ipv6.neigh.eth1.locktime = 0
net.ipv6.neigh.eth1.mcast_solicit = 3
net.ipv6.neigh.eth1.proxy_delay = 80
net.ipv6.neigh.eth1.proxy_qlen = 64
net.ipv6.neigh.eth1.retrans_time = 250
net.ipv6.neigh.eth1.retrans_time_ms = 1000
net.ipv6.neigh.eth1.ucast_solicit = 3
net.ipv6.neigh.eth1.unres_qlen = 32
net.ipv6.neigh.eth1.unres_qlen_bytes = 65536
net.ipv6.neigh.lo.anycast_delay = 100
net.ipv6.neigh.lo.app_solicit = 0
net.ipv6.neigh.lo.base_reachable_time = 30
net.ipv6.neigh.lo.base_reachable_time_ms = 30000
net.ipv6.neigh.lo.delay_first_probe_time = 5
net.ipv6.neigh.lo.gc_stale_time = 60
net.ipv6.neigh.lo.locktime = 0
net.ipv6.neigh.lo.mcast_solicit = 3
net.ipv6.neigh.lo.proxy_delay = 80
net.ipv6.neigh.lo.proxy_qlen = 64
net.ipv6.neigh.lo.retrans_time = 250
net.ipv6.neigh.lo.retrans_time_ms = 1000
net.ipv6.neigh.lo.ucast_solicit = 3
net.ipv6.neigh.lo.unres_qlen = 32
net.ipv6.neigh.lo.unres_qlen_bytes = 65536
net.ipv6.route.gc_elasticity = 9
net.ipv6.route.gc_interval = 30
net.ipv6.route.gc_min_interval = 0
net.ipv6.route.gc_min_interval_ms = 500
net.ipv6.route.gc_thresh = 1024
net.ipv6.route.gc_timeout = 60
net.ipv6.route.max_size = 4096
net.ipv6.route.min_adv_mss = 1220
net.ipv6.route.mtu_expires = 600
net.ipv6.xfrm6_gc_thresh = 2048
net.netfilter.nf_log.0 = NONE
net.netfilter.nf_log.1 = NONE
net.netfilter.nf_log.10 = NONE
net.netfilter.nf_log.11 = NONE
net.netfilter.nf_log.12 = NONE
net.netfilter.nf_log.2 = NONE
net.netfilter.nf_log.3 = NONE
net.netfilter.nf_log.4 = NONE
net.netfilter.nf_log.5 = NONE
net.netfilter.nf_log.6 = NONE
net.netfilter.nf_log.7 = NONE
net.netfilter.nf_log.8 = NONE
net.netfilter.nf_log.9 = NONE
net.unix.max_dgram_qlen = 10
vm.block_dump = 0
vm.dirty_background_bytes = 0
vm.dirty_background_ratio = 10
vm.dirty_bytes = 0
vm.dirty_expire_centisecs = 3000
vm.dirty_ratio = 20
vm.dirty_writeback_centisecs = 500
vm.drop_caches = 0
vm.hugepages_treat_as_movable = 0
vm.hugetlb_shm_group = 0
vm.laptop_mode = 0
vm.legacy_va_layout = 0
vm.lowmem_reserve_ratio = 256	256	32
vm.max_map_count = 65530
vm.memory_failure_early_kill = 0
vm.memory_failure_recovery = 1
vm.min_free_kbytes = 19901
vm.min_slab_ratio = 5
vm.min_unmapped_ratio = 1
vm.mmap_min_addr = 65536
vm.nr_hugepages = 0
vm.nr_hugepages_mempolicy = 0
vm.nr_overcommit_hugepages = 0
vm.nr_pdflush_threads = 0
vm.numa_zonelist_order = default
vm.oom_dump_tasks = 1
vm.oom_kill_allocating_task = 0
vm.overcommit_memory = 0
vm.overcommit_ratio = 50
vm.page-cluster = 3
vm.panic_on_oom = 0
vm.percpu_pagelist_fraction = 0
vm.scan_unevictable_pages = 0
vm.stat_interval = 1
vm.swappiness = 60
vm.vfs_cache_pressure = 100
vm.zone_reclaim_mode = 0

--------------080501000505030604090909
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------080501000505030604090909--
