Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Sep 2007 05:23:33 -0700 (PDT)
Received: from bay0-omc2-s5.bay0.hotmail.com (bay0-omc2-s5.bay0.hotmail.com [65.54.246.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l84CNU4p020724
	for <xfs@oss.sgi.com>; Tue, 4 Sep 2007 05:23:31 -0700
Message-ID: <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl> <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>] xfs_bmap_search_multi_extents+0x6f/0xe0)
Date: Tue, 4 Sep 2007 14:22:04 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Marco Berizzi <pupilla@hotmail.com>

Christoph Lameter wrote:

> Could you try this with the SLUB allocator and then boot with
> "slub_debug"?

Hi Christoph,

I have upgraded to 2.6.22.5 and I have selected
the SLUB. I have also added append=slub_debug to
lilo.conf
After a week uptime I got this error. I hope it
will be useful for you.

Linux version 2.6.22.5 (root@Mimosa) (gcc version 3.3.5) #1 Mon Aug 27
16:57:18 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000a000000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
160MB LOWMEM available.
Entering add_active_range(0, 0, 40960) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    40960
early_node_map[1] active PFN ranges
    0:        0 ->    40960
On node 0 totalpages: 40960
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 288 pages used for memmap
  Normal zone: 36576 pages, LIFO batch:7
DMI 2.1 present.
Allocating PCI resources starting at 10000000 (gap: 0a000000:f5ff0000)
Built 1 zonelists.  Total pages: 40640
Kernel command line: auto BOOT_IMAGE=Linux ro root=301 slub_debug
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01141000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 267.281 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 158956k/163840k available (1975k kernel code, 4452k reserved,
628k data, 160k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xca800000 - 0xfffb5000   ( 855 MB)
    lowmem  : 0xc0000000 - 0xca000000   ( 160 MB)
      .init : 0xc038e000 - 0xc03b6000   ( 160 kB)
      .data : 0xc02edd86 - 0xc038afa0   ( 628 kB)
      .text : 0xc0100000 - 0xc02edd86   (1975 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 535.19 BogoMIPS
(lpj=1070387)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000
00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: After all inits, caps: 0183f9ff 00000000 00000000 00000040 00000000
00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel Celeron (Covington) stepping 00
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI Exception (tbxface-0618): AE_NO_ACPI_TABLES, While loading
namespace from ACPI tables [20070126]
ACPI: Unable to load the System Description Tables
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfda61, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
PCI quirk: region 6100-613f claimed by PIIX4 ACPI
PCI quirk: region 5f00-5f0f claimed by PIIX4 SMB
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:07.0
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: b000-bfff
  MEM window: efe00000-efefffff
  PREFETCH window: e5c00000-e7cfffff
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler deadline registered (default)
Limiting direct PCI/PCI transfers.
Boot video device is 0000:01:00.0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: QUANTUM FIREBALL EX3.2A, ATA DISK drive
hda: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: CRD-8160B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 6306048 sectors (3228 MB) w/418KiB Cache, CHS=6256/16/63, UDMA(33)
hda: cache flushes not supported
 hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 >
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
nf_conntrack version 0.5.0 (1280 buckets, 10240 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input0
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda1
Ending clean XFS mount for filesystem: hda1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 160k freed
Adding 330584k swap on /dev/hda9.  Priority:-1 extents:1 across:330584k
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:09.0
3c59x: Donald Becker and others.
0000:00:09.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001dc00.
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:0a.0
0000:00:0a.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001da00.
PCI: setting IRQ 9 as level-triggered
PCI: Found IRQ 9 for device 0000:00:0b.0
PCI: Sharing IRQ 9 with 0000:00:07.2
0000:00:0b.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001d800.
Filesystem "hda5": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda5
Ending clean XFS mount for filesystem: hda5
Filesystem "hda6": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda6
Ending clean XFS mount for filesystem: hda6
Filesystem "hda7": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda7
Ending clean XFS mount for filesystem: hda7
Filesystem "hda8": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda8
Ending clean XFS mount for filesystem: hda8
eth0:  setting full-duplex.
eth1:  setting full-duplex.
eth2:  setting full-duplex.
swapper: page allocation failure. order:2, mode:0x4020
 [<c013b21d>] __alloc_pages+0x1ed/0x2e0
 [<c014ee3b>] allocate_slab+0x4b/0x90
 [<c014eef2>] new_slab+0x32/0x150
 [<c014f47b>] __slab_alloc+0xcb/0x120
 [<c014f429>] __slab_alloc+0x79/0x120
 [<c02b0183>] tcp_collapse+0x113/0x3b0
 [<c01506e5>] __kmalloc_track_caller+0x75/0x80
 [<c02b0183>] tcp_collapse+0x113/0x3b0
 [<c0274eae>] __alloc_skb+0x4e/0x100
 [<c02b0183>] tcp_collapse+0x113/0x3b0
 [<c02b052d>] tcp_prune_queue+0x7d/0x180
 [<c02afc19>] tcp_data_queue+0x2b9/0x710
 [<c02d11d1>] ipt_do_table+0x271/0x360
 [<c02b0cbb>] tcp_rcv_established+0x1cb/0x630
 [<c02b8523>] tcp_v4_do_rcv+0xe3/0xf0
 [<c02b8baf>] tcp_v4_rcv+0x67f/0x800
 [<c029e1d0>] ip_local_deliver_finish+0x0/0x1a0
 [<c02915d6>] nf_hook_slow+0x66/0xe0
 [<c029dbec>] ip_local_deliver+0x11c/0x230
 [<c029e1d0>] ip_local_deliver_finish+0x0/0x1a0
 [<c029df32>] ip_rcv+0x232/0x4d0
 [<c029e370>] ip_rcv_finish+0x0/0x2a0
 [<c0104c2e>] do_IRQ+0x3e/0x80
 [<c027b887>] netif_receive_skb+0x207/0x290
 [<c027b987>] process_backlog+0x77/0xf0
 [<c027ba6c>] net_rx_action+0x6c/0xf0
 [<c0119944>] __do_softirq+0x74/0x90
 [<c0119986>] do_softirq+0x26/0x30
 [<c0104c2e>] do_IRQ+0x3e/0x80
 [<c0103217>] common_interrupt+0x23/0x28
 [<c0100a00>] default_idle+0x0/0x40
 [<c0100a27>] default_idle+0x27/0x40
 [<c0100aac>] cpu_idle+0x5c/0x70
 [<c038e91c>] start_kernel+0x17c/0x1c0
 [<c038e3e0>] unknown_bootoption+0x0/0x1a0
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:   4   Cold: hi:   14, btch:   3
usd:  11
Active:29564 inactive:4492 dirty:418 writeback:0 unstable:0
 free:845 slab:4194 mapped:901 pagetables:210 bounce:0
DMA free:632kB min:160kB low:200kB high:240kB active:9136kB
inactive:1888kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 142
Normal free:2748kB min:1448kB low:1808kB high:2172kB active:109120kB
inactive:16080kB present:146304kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
DMA: 48*4kB 3*8kB 0*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB
0*2048kB 0*4096kB = 632kB
Normal: 571*4kB 40*8kB 1*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 2748kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 330584kB
Total swap = 330584kB
Free swap:       330584kB
40960 pages of RAM
0 pages of HIGHMEM
1170 reserved pages
18768 pages shared
0 pages swap cached
418 pages dirty
0 pages writeback
901 pages mapped
4194 pages slab
210 pages pagetables
