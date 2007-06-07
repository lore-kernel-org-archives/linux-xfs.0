Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 00:57:25 -0700 (PDT)
Received: from bay0-omc2-s6.bay0.hotmail.com (bay0-omc2-s6.bay0.hotmail.com [65.54.246.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l577vKWt018537
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 00:57:21 -0700
Message-ID: <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl> <20070320064632.GO32602149@melbourne.sgi.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Thu, 7 Jun 2007 09:44:51 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Marco Berizzi <pupilla@hotmail.com>

Hi David.
Three months ago I wrote the message below.
I had built various 2.6.20.x and 2.6.21.x
vanilla kernel with all the debug options
enabled and linux had never crashed.
On june 4, I have builded linux 2.6.21.3 without
any debugging options and after 2 days linux
has starting print these errors:

Jun  6 09:47:09 Pleiadi kernel:  =======================
Jun  6 09:47:09 Pleiadi kernel: 0x0: 28 f1 45 d4 22 53 35 11 09 80 37 5a
47 8a 22 ee
Jun  6 09:47:09 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2086 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b2301
Jun  6 09:47:09 Pleiadi kernel:  [<c01b21f7>] xfs_da_do_buf+0x70c/0x7b1
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
Jun  6 09:47:09 Pleiadi kernel:  [<c01eb13d>]
_xfs_buf_lookup_pages+0x1e8/0x2ea
Jun  6 09:47:09 Pleiadi kernel:  [<c01eade2>]
_xfs_buf_initialize+0xc8/0xf6
Jun  6 09:47:09 Pleiadi kernel:  [<c01dc307>]
xfs_trans_unreserve_and_mod_sb+0x241/0x264
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
Jun  6 09:47:09 Pleiadi kernel:  [<c01b7af3>]
xfs_dir2_leaf_lookup_int+0x5c/0x2b6
Jun  6 09:47:09 Pleiadi kernel:  [<c01b7af3>]
xfs_dir2_leaf_lookup_int+0x5c/0x2b6
Jun  6 09:47:09 Pleiadi kernel:  [<c020ab2c>] __next_cpu+0x12/0x1f
Jun  6 09:47:09 Pleiadi kernel:  [<c01b79e0>]
xfs_dir2_leaf_lookup+0x2b/0xe2
Jun  6 09:47:09 Pleiadi kernel:  [<c01b36fb>] xfs_dir2_isleaf+0x1a/0x4f
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2dbc>] xfs_dir_lookup+0xc1/0x11d
Jun  6 09:47:09 Pleiadi kernel:  [<c01de55e>]
xfs_dir_lookup_int+0x34/0x10e
Jun  6 09:47:09 Pleiadi kernel:  [<c01dc4f1>]
_xfs_trans_commit+0x1c7/0x3a2
Jun  6 09:47:09 Pleiadi kernel:  [<c01e3f16>] xfs_lookup+0x5a/0x90
Jun  6 09:47:09 Pleiadi kernel:  [<c01ef939>] xfs_vn_lookup+0x52/0x93
Jun  6 09:47:09 Pleiadi kernel:  [<c01600f4>] real_lookup+0xbb/0x116
Jun  6 09:47:09 Pleiadi kernel:  [<c016036a>] do_lookup+0x90/0xc2
Jun  6 09:47:09 Pleiadi kernel:  [<c01ef8e7>] xfs_vn_lookup+0x0/0x93
Jun  6 09:47:09 Pleiadi kernel:  [<c01604a8>]
__link_path_walk+0x10c/0xcf1
Jun  6 09:47:09 Pleiadi kernel:  [<c015ee4c>] pipe_read+0x23b/0x2bf
Jun  6 09:47:09 Pleiadi kernel:  [<c01610cb>] link_path_walk+0x3e/0xac
Jun  6 09:47:09 Pleiadi kernel:  [<c0159906>] vfs_read+0xee/0x141
Jun  6 09:47:09 Pleiadi kernel:  [<c0159bf4>] sys_read+0x41/0x6a
Jun  6 09:47:09 Pleiadi kernel:  [<c0161407>] do_path_lookup+0x11a/0x1ba
Jun  6 09:47:09 Pleiadi kernel:  [<c0162a00>] do_unlinkat+0x41/0x114
Jun  6 09:47:09 Pleiadi kernel:  [<c0159906>] vfs_read+0xee/0x141
Jun  6 09:47:09 Pleiadi kernel:  [<c0159bf4>] sys_read+0x41/0x6a
Jun  6 09:47:09 Pleiadi kernel:  [<c01028c8>] syscall_call+0x7/0xb
Jun  6 09:47:09 Pleiadi kernel:  =======================

PS: I haven't rebooted the system. It is printing
this message every few seconds on the console:
Filesystem "sda8": XFS internal error xfs_da_do_buf(2) at line 2086 of
file fs/xfs/xfs_da_btree.c.  Caller 0xc01b2301

Here is dmesg output:

Jun  4 20:53:05 Pleiadi kernel: sanitize start
Jun  4 20:53:05 Pleiadi kernel: sanitize end
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 0000000000000000
size: 000000000009ac00 end: 000000000009ac00 type: 1
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000000009ac00
size: 0000000000005400 end: 00000000000a0000 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000000ce000
size: 0000000000002000 end: 00000000000d0000 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000000e0000
size: 0000000000020000 end: 0000000000100000 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 0000000000100000
size: 000000003fdf0000 end: 000000003fef0000 type: 1
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003fef0000
size: 000000000000b000 end: 000000003fefb000 type: 3
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003fefb000
size: 0000000000005000 end: 000000003ff00000 type: 4
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003ff00000
size: 0000000000080000 end: 000000003ff80000 type: 1
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003ff80000
size: 0000000000080000 end: 0000000040000000 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000e0000000
size: 0000000010000000 end: 00000000f0000000 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000fec00000
size: 0000000000100400 end: 00000000fed00400 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000fee00000
size: 0000000000100000 end: 00000000fef00000 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000ffb00000
size: 0000000000100000 end: 00000000ffc00000 type: 2
Jun  4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000fff00000
size: 0000000000100000 end: 0000000100000000 type: 2
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 0000000000000000 -
000000000009ac00 (usable)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 000000000009ac00 -
00000000000a0000 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 00000000000ce000 -
00000000000d0000 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 00000000000e0000 -
0000000000100000 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 0000000000100000 -
000000003fef0000 (usable)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 000000003fef0000 -
000000003fefb000 (ACPI data)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 000000003fefb000 -
000000003ff00000 (ACPI NVS)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 000000003ff00000 -
000000003ff80000 (usable)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 000000003ff80000 -
0000000040000000 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 00000000e0000000 -
00000000f0000000 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 00000000fec00000 -
00000000fed00400 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 00000000fee00000 -
00000000fef00000 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 00000000ffb00000 -
00000000ffc00000 (reserved)
Jun  4 20:53:05 Pleiadi kernel:  BIOS-e820: 00000000fff00000 -
0000000100000000 (reserved)
Jun  4 20:53:05 Pleiadi kernel: Zone PFN ranges:
Jun  4 20:53:05 Pleiadi kernel:   DMA             0 ->     4096
Jun  4 20:53:05 Pleiadi kernel:   Normal       4096 ->   229376
Jun  4 20:53:05 Pleiadi kernel:   HighMem    229376 ->   262016
Jun  4 20:53:05 Pleiadi kernel: early_node_map[1] active PFN ranges
Jun  4 20:53:05 Pleiadi kernel:     0:        0 ->   262016
Jun  4 20:53:05 Pleiadi kernel: ACPI: RSDP 000F6BA0, 0024 (r2 PTLTD )
Jun  4 20:53:05 Pleiadi kernel: ACPI: XSDT 3FEF5381, 004C (r1 PTLTD  ^I
XSDT    6040001  LTP        0)
Jun  4 20:53:05 Pleiadi kernel: ACPI: FACP 3FEF5441, 00F4 (r3 FSC
6040001         F4240)
Jun  4 20:53:05 Pleiadi kernel: ACPI: DSDT 3FEF5535, 597B (r1 FSC
D1649     6040001 MSFT  2000002)
Jun  4 20:53:05 Pleiadi kernel: ACPI: FACS 3FEFBFC0, 0040
Jun  4 20:53:05 Pleiadi kernel: ACPI: SPCR 3FEFAEB0, 0050 (r1 PTLTD
$UCRTBL$  6040001 PTL         1)
Jun  4 20:53:05 Pleiadi kernel: ACPI: MCFG 3FEFAF00, 0040 (r1 PTLTD
MCFG    6040001  LTP        0)
Jun  4 20:53:05 Pleiadi kernel: ACPI: APIC 3FEFAF40, 0098 (r1 PTLTD  ^I
APIC    6040001  LTP        0)
Jun  4 20:53:05 Pleiadi kernel: ACPI: BOOT 3FEFAFD8, 0028 (r1 PTLTD
$SBFTBL$  6040001  LTP        1)
Jun  4 20:53:05 Pleiadi kernel: Processor #0 15:4 APIC version 20
Jun  4 20:53:05 Pleiadi kernel: Processor #1 15:4 APIC version 20
Jun  4 20:53:05 Pleiadi kernel: IOAPIC[0]: apic_id 2, version 32,
address 0xfec00000, GSI 0-23
Jun  4 20:53:05 Pleiadi kernel: IOAPIC[1]: apic_id 3, version 32,
address 0xfec80000, GSI 24-47
Jun  4 20:53:05 Pleiadi kernel: IOAPIC[2]: apic_id 4, version 32,
address 0xfec80800, GSI 48-71
Jun  4 20:53:05 Pleiadi kernel: IOAPIC[3]: apic_id 5, version 32,
address 0xfec84000, GSI 72-95
Jun  4 20:53:05 Pleiadi kernel: IOAPIC[4]: apic_id 6, version 32,
address 0xfec84800, GSI 96-119
Jun  4 20:53:05 Pleiadi kernel: Enabling APIC mode:  Flat.  Using 5 I/O
APICs
Jun  4 20:53:05 Pleiadi kernel: Allocating PCI resources starting at
50000000 (gap: 40000000:a0000000)
Jun  4 20:53:05 Pleiadi kernel: Built 1 zonelists.  Total pages: 259969
Jun  4 20:53:05 Pleiadi kernel: PID hash table entries: 4096 (order: 12,
16384 bytes)
Jun  4 20:53:05 Pleiadi kernel: Detected 3200.428 MHz processor.
Jun  4 20:53:05 Pleiadi kernel: Console: colour VGA+ 80x25
Jun  4 20:53:05 Pleiadi kernel: Dentry cache hash table entries: 131072
(order: 7, 524288 bytes)
Jun  4 20:53:05 Pleiadi kernel: Inode-cache hash table entries: 65536
(order: 6, 262144 bytes)
Jun  4 20:53:05 Pleiadi kernel: virtual kernel memory layout:
Jun  4 20:53:05 Pleiadi kernel:     fixmap  : 0xfff9d000 - 0xfffff000
( 392 kB)
Jun  4 20:53:05 Pleiadi kernel:     pkmap   : 0xff800000 - 0xffc00000
(4096 kB)
Jun  4 20:53:05 Pleiadi kernel:     vmalloc : 0xf8800000 - 0xff7fe000
( 111 MB)
Jun  4 20:53:05 Pleiadi kernel:     lowmem  : 0xc0000000 - 0xf8000000
( 896 MB)
Jun  4 20:53:05 Pleiadi kernel:       .init : 0xc039f000 - 0xc03ce000
( 188 kB)
Jun  4 20:53:05 Pleiadi kernel:       .data : 0xc02fd400 - 0xc0398114
( 619 kB)
Jun  4 20:53:05 Pleiadi kernel:       .text : 0xc0100000 - 0xc02fd400
(2037 kB)
Jun  4 20:53:05 Pleiadi kernel: Checking if this processor honours the
WP bit even in supervisor mode... Ok.
Jun  4 20:53:05 Pleiadi kernel: Calibrating delay using timer specific
routine.. 6403.78 BogoMIPS (lpj=32018905)
Jun  4 20:53:05 Pleiadi kernel: Mount-cache hash table entries: 512
Jun  4 20:53:05 Pleiadi kernel: monitor/mwait feature present.
Jun  4 20:53:05 Pleiadi kernel: using mwait in idle threads.
Jun  4 20:53:05 Pleiadi kernel: CPU0: Intel(R) Xeon(TM) CPU 3.20GHz
stepping 0a
Jun  4 20:53:05 Pleiadi kernel: Booting processor 1/1 eip 2000
Jun  4 20:53:05 Pleiadi kernel: Calibrating delay using timer specific
routine.. 6400.45 BogoMIPS (lpj=32002267)
Jun  4 20:53:05 Pleiadi kernel: monitor/mwait feature present.
Jun  4 20:53:05 Pleiadi kernel: CPU1: Intel(R) Xeon(TM) CPU 3.20GHz
stepping 0a
Jun  4 20:53:05 Pleiadi kernel: ENABLING IO-APIC IRQs
Jun  4 20:53:05 Pleiadi kernel: migration_cost=142
Jun  4 20:53:05 Pleiadi kernel: Setting up standard PCI resources
Jun  4 20:53:05 Pleiadi kernel: ACPI: Device [PS2M] status [00000008]:
functional but not present; setting present
Jun  4 20:53:05 Pleiadi kernel: ACPI: Device [ECP] status [00000008]:
functional but not present; setting present
Jun  4 20:53:05 Pleiadi kernel: ACPI: Device [COM1] status [00000008]:
functional but not present; setting present
Jun  4 20:53:05 Pleiadi kernel: PCI quirk: region f000-f07f claimed by
ICH4 ACPI/GPIO/TCO
Jun  4 20:53:05 Pleiadi kernel: PCI quirk: region f180-f1bf claimed by
ICH4 GPIO
Jun  4 20:53:05 Pleiadi kernel: PCI: PXH quirk detected, disabling MSI
for SHPC device
Jun  4 20:53:05 Pleiadi kernel: PCI: PXH quirk detected, disabling MSI
for SHPC device
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3
4 5 6 7 9 10 *11 12 14 15)
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3
4 5 6 7 *9 10 11 12 14 15)
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3
4 *5 6 7 9 10 11 12 14 15)
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3
4 5 6 7 9 *10 11 12 14 15)
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Jun  4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3
*4 5 6 7 9 10 11 12 14 15)
Jun  4 20:53:05 Pleiadi kernel: IP route cache hash table entries: 32768
(order: 5, 131072 bytes)
Jun  4 20:53:05 Pleiadi kernel: TCP established hash table entries:
131072 (order: 8, 1572864 bytes)
Jun  4 20:53:05 Pleiadi kernel: TCP bind hash table entries: 65536
(order: 7, 524288 bytes)
Jun  4 20:53:05 Pleiadi kernel: highmem bounce pool size: 64 pages
Jun  4 20:53:05 Pleiadi kernel: PNP: PS/2 controller doesn't have AUX
irq; using default 12
Jun  4 20:53:05 Pleiadi kernel: nf_conntrack version 0.5.0 (8188
buckets, 65504 max)
Jun  4 20:53:05 Pleiadi kernel: ip_tables: (C) 2000-2006 Netfilter Core
Team
Jun  4 20:53:05 Pleiadi kernel: Using IPI Shortcut mode
Jun  4 20:53:05 Pleiadi kernel: VFS: Mounted root (xfs filesystem)
readonly.
Jun  6 09:47:09 Pleiadi kernel: 0x0: 28 f1 45 d4 22 53 35 11 09 80 37 5a
47 8a 22 ee
Jun  6 09:47:09 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2086 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b2301
Jun  6 09:47:09 Pleiadi kernel:  [<c01b21f7>] xfs_da_do_buf+0x70c/0x7b1
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
Jun  6 09:47:09 Pleiadi last message repeated 2 times
Jun  6 09:47:09 Pleiadi kernel:  [<c01b7af3>]
xfs_dir2_leaf_lookup_int+0x5c/0x2b6
Jun  6 09:47:09 Pleiadi kernel:  [<c01b7af3>]
xfs_dir2_leaf_lookup_int+0x5c/0x2b6
Jun  6 09:47:09 Pleiadi kernel:  [<c01b79e0>]
xfs_dir2_leaf_lookup+0x2b/0xe2
Jun  6 09:47:09 Pleiadi kernel:  [<c01b36fb>] xfs_dir2_isleaf+0x1a/0x4f
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2dbc>] xfs_dir_lookup+0xc1/0x11d
Jun  6 09:47:09 Pleiadi kernel:  [<c0178a8b>]
__block_commit_write+0x7d/0xb0
Jun  6 09:47:09 Pleiadi kernel:  [<c013f337>]
generic_file_buffered_write+0x2d1/0x682
Jun  6 09:47:09 Pleiadi kernel:  [<c01de55e>]
xfs_dir_lookup_int+0x34/0x10e
Jun  6 09:47:09 Pleiadi kernel:  [<c01e3f16>] xfs_lookup+0x5a/0x90
Jun  6 09:47:09 Pleiadi kernel:  [<c01ef939>] xfs_vn_lookup+0x52/0x93
Jun  6 09:47:09 Pleiadi kernel:  [<c01600f4>] real_lookup+0xbb/0x116
Jun  6 09:47:09 Pleiadi kernel:  [<c016036a>] do_lookup+0x90/0xc2
Jun  6 09:47:09 Pleiadi kernel:  [<c01ef8e7>] xfs_vn_lookup+0x0/0x93
Jun  6 09:47:09 Pleiadi kernel:  [<c01604a8>]
__link_path_walk+0x10c/0xcf1
Jun  6 09:47:09 Pleiadi kernel:  [<c01610cb>] link_path_walk+0x3e/0xac
Jun  6 09:47:09 Pleiadi kernel:  [<c0158e0b>] get_unused_fd+0x2e/0xb6
Jun  6 09:47:09 Pleiadi kernel:  [<c0161407>] do_path_lookup+0x11a/0x1ba
Jun  6 09:47:09 Pleiadi kernel:  [<c016150f>]
__path_lookup_intent_open+0x50/0x90
Jun  6 09:47:09 Pleiadi kernel:  [<c016156f>] path_lookup_open+0x20/0x25
Jun  6 09:47:09 Pleiadi kernel:  [<c0161d4b>] open_namei+0x7a/0x550
Jun  6 09:47:09 Pleiadi kernel:  [<c014a03f>] do_wp_page+0x20e/0x3ec
Jun  6 09:47:09 Pleiadi kernel:  [<c0158c86>] do_filp_open+0x2e/0x5b
Jun  6 09:47:09 Pleiadi kernel:  [<c0158e0b>] get_unused_fd+0x2e/0xb6
Jun  6 09:47:09 Pleiadi kernel:  [<c0158f79>] do_sys_open+0x4e/0xdb
Jun  6 09:47:09 Pleiadi kernel:  [<c0159022>] sys_open+0x1c/0x20
Jun  6 09:47:09 Pleiadi kernel:  [<c01028c8>] syscall_call+0x7/0xb
Jun  6 09:47:09 Pleiadi kernel:  =======================
Jun  6 09:47:09 Pleiadi kernel: 0x0: 28 f1 45 d4 22 53 35 11 09 80 37 5a
47 8a 22 ee
Jun  6 09:47:09 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2086 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b2301
Jun  6 09:47:09 Pleiadi kernel:  [<c01b21f7>] xfs_da_do_buf+0x70c/0x7b1
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
Jun  6 09:47:09 Pleiadi kernel:  [<c01eb13d>]
_xfs_buf_lookup_pages+0x1e8/0x2ea
Jun  6 09:47:09 Pleiadi kernel:  [<c01eade2>]
_xfs_buf_initialize+0xc8/0xf6
Jun  6 09:47:09 Pleiadi kernel:  [<c01dc307>]
xfs_trans_unreserve_and_mod_sb+0x241/0x264
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>] xfs_da_read_buf+0x30/0x35
Jun  6 09:47:09 Pleiadi kernel:  [<c01b7af3>]
xfs_dir2_leaf_lookup_int+0x5c/0x2b6
Jun  6 09:47:09 Pleiadi kernel:  [<c01b7af3>]
xfs_dir2_leaf_lookup_int+0x5c/0x2b6
Jun  6 09:47:09 Pleiadi kernel:  [<c020ab2c>] __next_cpu+0x12/0x1f
Jun  6 09:47:09 Pleiadi kernel:  [<c01b79e0>]
xfs_dir2_leaf_lookup+0x2b/0xe2
Jun  6 09:47:09 Pleiadi kernel:  [<c01b36fb>] xfs_dir2_isleaf+0x1a/0x4f
Jun  6 09:47:09 Pleiadi kernel:  [<c01b2dbc>] xfs_dir_lookup+0xc1/0x11d
Jun  6 09:47:09 Pleiadi kernel:  [<c01de55e>]
xfs_dir_lookup_int+0x34/0x10e
Jun  6 09:47:09 Pleiadi kernel:  [<c01dc4f1>]
_xfs_trans_commit+0x1c7/0x3a2
Jun  6 09:47:09 Pleiadi kernel:  [<c01e3f16>] xfs_lookup+0x5a/0x90
Jun  6 09:47:09 Pleiadi kernel:  [<c01ef939>] xfs_vn_lookup+0x52/0x93
Jun  6 09:47:09 Pleiadi kernel:  [<c01600f4>] real_lookup+0xbb/0x116
Jun  6 09:47:09 Pleiadi kernel:  [<c016036a>] do_lookup+0x90/0xc2
Jun  6 09:47:09 Pleiadi kernel:  [<c01ef8e7>] xfs_vn_lookup+0x0/0x93
Jun  6 09:47:09 Pleiadi kernel:  [<c01604a8>]
__link_path_walk+0x10c/0xcf1
Jun  6 09:47:09 Pleiadi kernel:  [<c015ee4c>] pipe_read+0x23b/0x2bf
Jun  6 09:47:09 Pleiadi kernel:  [<c01610cb>] link_path_walk+0x3e/0xac
Jun  6 09:47:09 Pleiadi kernel:  [<c0159906>] vfs_read+0xee/0x141
Jun  6 09:47:09 Pleiadi kernel:  [<c0159bf4>] sys_read+0x41/0x6a
Jun  6 09:47:09 Pleiadi kernel:  [<c0161407>] do_path_lookup+0x11a/0x1ba
Jun  6 09:47:09 Pleiadi kernel:  [<c0162a00>] do_unlinkat+0x41/0x114
Jun  6 09:47:09 Pleiadi kernel:  [<c0159906>] vfs_read+0xee/0x141
Jun  6 09:47:09 Pleiadi kernel:  [<c0159bf4>] sys_read+0x41/0x6a
Jun  6 09:47:09 Pleiadi kernel:  [<c01028c8>] syscall_call+0x7/0xb
Jun  6 09:47:09 Pleiadi kernel:  =======================
..

David Chinner wrote:

> On Mon, Mar 19, 2007 at 11:32:27AM +0100, Marco Berizzi wrote:
> > Marco Berizzi wrote:
> > > David Chinner wrote:
> > >
> > >> Ok, so an ipsec change. And I see from the history below it
> > >> really has nothing to do with this problem. it seems the problem
> > >> has something to do with changes between 2.6.19.1 and 2.6.19.2.
> > >
> > > indeed. Yesterday at 13:00 I have switched from 2.6.19.1 to
2.6.19.2
> > > (without the ipsec fix) and at about 17:30 linux has crashed
again.
> > > I have recompiled 2.6.19.2 with all kernel debugging options
enabled
> > > and rebooted. Now I'm waiting for the crash...
> >
> > Linux has not been crashed. However here is dmesg output
> > with all debugging option enabled: (search for 'INFO:
> > possible recursive locking detected'). Is that normal?
>
> .....
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.19.2 #1
> > ---------------------------------------------
> > rm/470 is trying to acquire lock:
> >  (&(&ip->i_lock)->mr_lock){----}, at: [<c01cd64a>]
xfs_ilock+0x5b/0xa1
> >
> > but task is already holding lock:
> >  (&(&ip->i_lock)->mr_lock){----}, at: [<c01cd64a>]
xfs_ilock+0x5b/0xa1
> >
> > other info that might help us debug this:
> > 3 locks held by rm/470:
> >  #0:  (&inode->i_mutex/1){--..}, at: [<c016e5a7>]
do_unlinkat+0x70/0x115
> >  #1:  (&inode->i_mutex){--..}, at: [<c030be35>] mutex_lock+0x1c/0x1f
> >  #2:  (&(&ip->i_lock)->mr_lock){----}, at: [<c01cd64a>]
> > xfs_ilock+0x5b/0xa1
> >
> > stack backtrace:
> >  [<c0103bc0>] dump_trace+0x215/0x21a
> >  [<c0103c68>] show_trace_log_lvl+0x1a/0x30
> >  [<c0103c90>] show_trace+0x12/0x14
> >  [<c0103d8d>] dump_stack+0x19/0x1b
> >  [<c01357e7>] print_deadlock_bug+0xc0/0xcf
> >  [<c0135860>] check_deadlock+0x6a/0x79
> >  [<c01372e1>] __lock_acquire+0x350/0x970
> >  [<c0137fd1>] lock_acquire+0x75/0x97
> >  [<c01331ab>] down_write+0x3a/0x54
> >  [<c01cd64a>] xfs_ilock+0x5b/0xa1
> >  [<c01eda0e>] xfs_lock_dir_and_entry+0x105/0x11b
> >  [<c01edcc5>] xfs_remove+0x180/0x47f
> >  [<c01f8a9e>] xfs_vn_unlink+0x22/0x4f
> >  [<c016e533>] vfs_unlink+0x9e/0xa2
> >  [<c016e5df>] do_unlinkat+0xa8/0x115
> >  [<c016e68b>] sys_unlink+0x10/0x12
> >  [<c0102cdb>] syscall_call+0x7/0xb
> >  [<b7efaa7d>] 0xb7efaa7d
> >  =======================
>
> That's no problem - lockdep just doesn't know that we can nest i_lock
> (we've got to get the annotations for this sorted out).
>
> > Here is the relevant results:
> >
> > Phase 2 - found root inode chunk
> > Phase 3 - ...
> >             agno = 0
> >             ...
> >             agno = 12
> > LEAFN node level is 1 inode 1610612918 bno = 8388608
>
> Hmmm - single bit error in the bno - that reminds of this:
>
> http://oss.sgi.com/projects/xfs/faq.html#dir2
>
> So I'd definitely make sure that is repaired....
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
