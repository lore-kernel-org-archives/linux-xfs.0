Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Sep 2007 06:35:34 -0700 (PDT)
Received: from bay0-omc1-s22.bay0.hotmail.com (bay0-omc1-s22.bay0.hotmail.com [65.54.246.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l85DZQ4p001433
	for <xfs@oss.sgi.com>; Wed, 5 Sep 2007 06:35:28 -0700
Message-ID: <BAY103-DAV6EA244D6F5F1EE04E50CBB2CB0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl> <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com> <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl> <Pine.LNX.4.64.0709040952570.5768@schroedinger.engr.sgi.com> <BAY103-DAV12D93B7C4F6214C867EE70B2CB0@phx.gbl> <Pine.LNX.4.64.0709050331340.8127@schroedinger.engr.sgi.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>] xfs_bmap_search_multi_extents+0x6f/0xe0)
Date: Wed, 5 Sep 2007 15:34:02 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, mel@skynet.ie, Marco Berizzi <pupilla@hotmail.com>

Christoph Lameter wrote:

> On Wed, 5 Sep 2007, Marco Berizzi wrote:
>
> > > tcp_collapse? This is due to a network configuration that required
an
> > > order 2 kmalloc block. Jumbo frames?
> >
> > I don't use jumbo frames. Hardware is
> > very old (celeron with 3com 3c905).
>
> Something must be doing allocations that requires between 8k and 16k
that
> SLUB cannot satisfy from order 0 or order 1 allocations.

Me again.
Another report from another machine.

Linux version 2.6.22.5 (root@Gemini) (gcc version 3.3.6) #1 Mon Aug 27
17:20:33 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000a000000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
160MB LOWMEM available.
Entering add_active_range(0, 0, 40960) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 -    4096
  Normal       4096 -   40960
early_node_map[1] active PFN ranges
    0:        0 -   40960
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
Detected 267.302 MHz processor.
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
      .data : 0xc02edc46 - 0xc038afa0   ( 628 kB)
      .text : 0xc0100000 - 0xc02edc46   (1975 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 535.24 BogoMIPS
(lpj=1070484)
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
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:07.2
PCI: Sharing IRQ 11 with 0000:00:0b.0
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
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: QUANTUM FIREBALL EX3.2A, ATA DISK drive
hda: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
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
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda1
Starting XFS recovery on filesystem: hda1 (logdev: internal)
Ending XFS recovery on filesystem: hda1 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 160k freed
Adding 209624k swap on /dev/hda9.  Priority:-1 extents:1 across:209624k
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
PCI: setting IRQ 9 as level-triggered
PCI: Found IRQ 9 for device 0000:00:09.0
3c59x: Donald Becker and others.
0000:00:09.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001de00.
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:0a.0
0000:00:0a.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001dc00.
PCI: Found IRQ 11 for device 0000:00:0b.0
PCI: Sharing IRQ 11 with 0000:00:07.2
0000:00:0b.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001da00.
Filesystem "hda5": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda5
Starting XFS recovery on filesystem: hda5 (logdev: internal)
Ending XFS recovery on filesystem: hda5 (logdev: internal)
Filesystem "hda6": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda6
Starting XFS recovery on filesystem: hda6 (logdev: internal)
Ending XFS recovery on filesystem: hda6 (logdev: internal)
Filesystem "hda7": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda7
Ending clean XFS mount for filesystem: hda7
Filesystem "hda8": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda8
Starting XFS recovery on filesystem: hda8 (logdev: internal)
Ending XFS recovery on filesystem: hda8 (logdev: internal)
eth0:  setting full-duplex.
eth1:  setting full-duplex.
eth2:  setting full-duplex.
input: AT Raw Set 2 keyboard as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1


Aug 31 12:32:04 Gemini kernel: swapper: page allocation failure.
order:2, mode:0x4020
Aug 31 12:32:04 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:04 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:04 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:04 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:04 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:04 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:04 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:04 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:04 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:04 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:04 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:04 Gemini kernel:  [<c02afae9>] tcp_data_queue+0x2b9/0x710
Aug 31 12:32:04 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:04 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:04 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:04 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:04 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:04 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:04 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:04 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:04 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:04 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:04 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:04 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:04 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:04 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:04 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:04 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:04 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:04 Gemini kernel:  [<c0100a00>] default_idle+0x0/0x40
Aug 31 12:32:04 Gemini kernel:  [<c0100a27>] default_idle+0x27/0x40
Aug 31 12:32:04 Gemini kernel:  [<c0100aac>] cpu_idle+0x5c/0x70
Aug 31 12:32:04 Gemini kernel:  [<c038e91c>] start_kernel+0x17c/0x1c0
Aug 31 12:32:04 Gemini kernel:  [<c038e3e0>]
unknown_bootoption+0x0/0x1a0
Aug 31 12:32:04 Gemini kernel:  =======================
Aug 31 12:32:04 Gemini kernel: DMA per-cpu:
Aug 31 12:32:04 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:04 Gemini kernel: Normal per-cpu:
Aug 31 12:32:04 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
41   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:04 Gemini kernel: Active:26797 inactive:4519 dirty:0
writeback:0 unstable:0
Aug 31 12:32:04 Gemini kernel:  free:1544 slab:6392 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:04 Gemini kernel: DMA free:1388kB min:160kB low:200kB
high:240kB active:7740kB inactive:1068kB present:16256kB pages_scanned:0
all_unreclaimable? no
Aug 31 12:32:04 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:04 Gemini kernel: Normal free:4788kB min:1448kB low:1808kB
high:2172kB active:99448kB inactive:17008kB present:146304kB
pages_scanned:34 all_unreclaimable? no
Aug 31 12:32:04 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:04 Gemini kernel: DMA: 315*4kB 14*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1388kB
Aug 31 12:32:04 Gemini kernel: Normal: 995*4kB 83*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4788kB
Aug 31 12:32:04 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: swapper: page allocation failure.
order:2, mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afae9>] tcp_data_queue+0x2b9/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c0100a00>] default_idle+0x0/0x40
Aug 31 12:32:05 Gemini kernel:  [<c0100a27>] default_idle+0x27/0x40
Aug 31 12:32:05 Gemini kernel:  [<c0100aac>] cpu_idle+0x5c/0x70
Aug 31 12:32:05 Gemini kernel:  [<c038e91c>] start_kernel+0x17c/0x1c0
Aug 31 12:32:05 Gemini kernel:  [<c038e3e0>]
unknown_bootoption+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
35   Cold: hi:   14, btch:   3 usd:  13
Aug 31 12:32:05 Gemini kernel: Active:26727 inactive:4495 dirty:3
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1690 slab:6345 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7740kB inactive:940kB present:16256kB pages_scanned:0
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:5208kB min:1448kB low:1808kB
high:2172kB active:99168kB inactive:17040kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1090*4kB 88*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5208kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: swapper: page allocation failure.
order:2, mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afae9>] tcp_data_queue+0x2b9/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c0100a00>] default_idle+0x0/0x40
Aug 31 12:32:05 Gemini kernel:  [<c0100a27>] default_idle+0x27/0x40
Aug 31 12:32:05 Gemini kernel:  [<c0100aac>] cpu_idle+0x5c/0x70
Aug 31 12:32:05 Gemini kernel:  [<c038e91c>] start_kernel+0x17c/0x1c0
Aug 31 12:32:05 Gemini kernel:  [<c038e3e0>]
unknown_bootoption+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
36   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:05 Gemini kernel: Active:26569 inactive:4526 dirty:4
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1910 slab:6252 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7720kB inactive:960kB present:16256kB pages_scanned:34
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:6088kB min:1448kB low:1808kB
high:2172kB active:98556kB inactive:17144kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1298*4kB 94*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6088kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: swapper: page allocation failure.
order:2, mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afddb>] tcp_data_queue+0x5ab/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c0100a00>] default_idle+0x0/0x40
Aug 31 12:32:05 Gemini kernel:  [<c0100a27>] default_id
Aug 31 12:32:05 Gemini kernel: klogd: page allocation failure. order:2,
mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afddb>] tcp_data_queue+0x5ab/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0126050>]
autoremove_wake_function+0x0/0x50
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c02ebb8d>]
__sched_text_start+0x30d/0x5c0
Aug 31 12:32:05 Gemini kernel:  [<c01028e6>] work_resched+0x5/0x16
Aug 31 12:32:05 Gemini kernel:  [<c02e0000>] build_expire+0x100/0x140
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
36   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:05 Gemini kernel: Active:26569 inactive:4526 dirty:4
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1910 slab:6252 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7720kB inactive:960kB present:16256kB pages_scanned:34
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:6088kB min:1448kB low:1808kB
high:2172kB active:98556kB inactive:17144kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1298*4kB 94*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6088kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: klogd: page allocation failure. order:2,
mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afddb>] tcp_data_queue+0x5ab/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0126050>]
autoremove_wake_function+0x0/0x50
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c02ebb8d>]
__sched_text_start+0x30d/0x5c0
Aug 31 12:32:05 Gemini kernel:  [<c01028e6>] work_resched+0x5/0x16
Aug 31 12:32:05 Gemini kernel:  [<c02e0000>] build_expire+0x100/0x140
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
36   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:05 Gemini kernel: Active:26569 inactive:4526 dirty:4
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1910 slab:6252 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7720kB inactive:960kB present:16256kB pages_scanned:34
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:6088kB min:1448kB low:1808kB
high:2172kB active:98556kB inactive:17144kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1298*4kB 94*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6088kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: klogd: page allocation failure. order:2,
mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afddb>] tcp_data_queue+0x5ab/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0126050>]
autoremove_wake_function+0x0/0x50
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c02ebb8d>]
__sched_text_start+0x30d/0x5c0
Aug 31 12:32:05 Gemini kernel:  [<c01028e6>] work_resched+0x5/0x16
Aug 31 12:32:05 Gemini kernel:  [<c02e0000>] build_expire+0x100/0x140
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
36   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:05 Gemini kernel: Active:26569 inactive:4526 dirty:4
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1910 slab:6252 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7720kB inactive:960kB present:16256kB pages_scanned:34
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:6088kB min:1448kB low:1808kB
high:2172kB active:98556kB inactive:17144kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1298*4kB 94*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6088kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: klogd: page allocation failure. order:2,
mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afddb>] tcp_data_queue+0x5ab/0x710
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0126050>]
autoremove_wake_function+0x0/0x50
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c02ebb8d>]
__sched_text_start+0x30d/0x5c0
Aug 31 12:32:05 Gemini kernel:  [<c01028e6>] work_resched+0x5/0x16
Aug 31 12:32:05 Gemini kernel:  [<c02e0000>] build_expire+0x100/0x140
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
36   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:05 Gemini kernel: Active:26569 inactive:4526 dirty:4
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1910 slab:6252 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7720kB inactive:960kB present:16256kB pages_scanned:34
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:6088kB min:1448kB low:1808kB
high:2172kB active:98556kB inactive:17144kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1298*4kB 94*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6088kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: klogd: page allocation failure. order:2,
mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afddb>] tcp_data_queue+0x5ab/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0126050>]
autoremove_wake_function+0x0/0x50
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c02ebb8d>]
__sched_text_start+0x30d/0x5c0
Aug 31 12:32:05 Gemini kernel:  [<c01028e6>] work_resched+0x5/0x16
Aug 31 12:32:05 Gemini kernel:  [<c02e0000>] build_expire+0x100/0x140
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
36   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:05 Gemini kernel: Active:26569 inactive:4526 dirty:4
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1910 slab:6252 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7720kB inactive:960kB present:16256kB pages_scanned:34
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:6088kB min:1448kB low:1808kB
high:2172kB active:98556kB inactive:17144kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1298*4kB 94*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6088kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:05 Gemini kernel: klogd: page allocation failure. order:2,
mode:0x4020
Aug 31 12:32:05 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:05 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:05 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:05 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:05 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:05 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:05 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:05 Gemini kernel:  [<c02afddb>] tcp_data_queue+0x5ab/0x710
Aug 31 12:32:05 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:05 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:05 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:05 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:05 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:05 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:05 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:05 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:05 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:05 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:05 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:05 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:05 Gemini kernel:  [<c0126050>]
autoremove_wake_function+0x0/0x50
Aug 31 12:32:05 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:05 Gemini kernel:  [<c02ebb8d>]
__sched_text_start+0x30d/0x5c0
Aug 31 12:32:05 Gemini kernel:  [<c01028e6>] work_resched+0x5/0x16
Aug 31 12:32:05 Gemini kernel:  [<c02e0000>] build_expire+0x100/0x140
Aug 31 12:32:05 Gemini kernel:  =======================
Aug 31 12:32:05 Gemini kernel: DMA per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:05 Gemini kernel: Normal per-cpu:
Aug 31 12:32:05 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
36   Cold: hi:   14, btch:   3 usd:  12
Aug 31 12:32:05 Gemini kernel: Active:26569 inactive:4526 dirty:4
writeback:0 unstable:0
Aug 31 12:32:05 Gemini kernel:  free:1910 slab:6252 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:05 Gemini kernel: DMA free:1552kB min:160kB low:200kB
high:240kB active:7720kB inactive:960kB present:16256kB pages_scanned:34
all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:05 Gemini kernel: Normal free:6088kB min:1448kB low:1808kB
high:2172kB active:98556kB inactive:17144kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:05 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:05 Gemini kernel: DMA: 364*4kB 10*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1552kB
Aug 31 12:32:05 Gemini kernel: Normal: 1298*4kB 94*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6088kB
Aug 31 12:32:05 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:05 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:05 Gemini kernel: Total swap = 209624kB
Aug 31 12:32:10 Gemini kernel: printk: 30 messages suppressed.
Aug 31 12:32:10 Gemini kernel: swapper: page allocation failure.
order:2, mode:0x4020
Aug 31 12:32:10 Gemini kernel:  [<c013b1fd>] __alloc_pages+0x1ed/0x2e0
Aug 31 12:32:10 Gemini kernel:  [<c014edbb>] allocate_slab+0x4b/0x90
Aug 31 12:32:10 Gemini kernel:  [<c014ee72>] new_slab+0x32/0x150
Aug 31 12:32:10 Gemini kernel:  [<c014f3fb>] __slab_alloc+0xcb/0x120
Aug 31 12:32:10 Gemini kernel:  [<c014f3a9>] __slab_alloc+0x79/0x120
Aug 31 12:32:10 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:10 Gemini kernel:  [<c0150665>]
__kmalloc_track_caller+0x75/0x80
Aug 31 12:32:10 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:10 Gemini kernel:  [<c0274dae>] __alloc_skb+0x4e/0x100
Aug 31 12:32:10 Gemini kernel:  [<c02b0053>] tcp_collapse+0x113/0x3b0
Aug 31 12:32:10 Gemini kernel:  [<c02b03fd>] tcp_prune_queue+0x7d/0x180
Aug 31 12:32:10 Gemini kernel:  [<c02afae9>] tcp_data_queue+0x2b9/0x710
Aug 31 12:32:10 Gemini kernel:  [<c02d10a1>] ipt_do_table+0x271/0x360
Aug 31 12:32:10 Gemini kernel:  [<c02b0b8b>]
tcp_rcv_established+0x1cb/0x630
Aug 31 12:32:10 Gemini kernel:  [<c02b83f3>] tcp_v4_do_rcv+0xe3/0xf0
Aug 31 12:32:10 Gemini kernel:  [<c02b8a7f>] tcp_v4_rcv+0x67f/0x800
Aug 31 12:32:10 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:10 Gemini kernel:  [<c02914a6>] nf_hook_slow+0x66/0xe0
Aug 31 12:32:10 Gemini kernel:  [<c029dabc>]
ip_local_deliver+0x11c/0x230
Aug 31 12:32:10 Gemini kernel:  [<c029e0a0>]
ip_local_deliver_finish+0x0/0x1a0
Aug 31 12:32:10 Gemini kernel:  [<c029de02>] ip_rcv+0x232/0x4d0
Aug 31 12:32:10 Gemini kernel:  [<c029e240>] ip_rcv_finish+0x0/0x2a0
Aug 31 12:32:10 Gemini kernel:  [<c027b787>]
netif_receive_skb+0x207/0x290
Aug 31 12:32:10 Gemini kernel:  [<c027b887>] process_backlog+0x77/0xf0
Aug 31 12:32:10 Gemini kernel:  [<c027b96c>] net_rx_action+0x6c/0xf0
Aug 31 12:32:10 Gemini kernel:  [<c0119944>] __do_softirq+0x74/0x90
Aug 31 12:32:10 Gemini kernel:  [<c0119986>] do_softirq+0x26/0x30
Aug 31 12:32:10 Gemini kernel:  [<c0104c2e>] do_IRQ+0x3e/0x80
Aug 31 12:32:10 Gemini kernel:  [<c0103217>] common_interrupt+0x23/0x28
Aug 31 12:32:10 Gemini kernel:  [<c0100a00>] default_idle+0x0/0x40
Aug 31 12:32:10 Gemini kernel:  [<c0100a27>] default_idle+0x27/0x40
Aug 31 12:32:10 Gemini kernel:  [<c0100aac>] cpu_idle+0x5c/0x70
Aug 31 12:32:10 Gemini kernel:  [<c038e91c>] start_kernel+0x17c/0x1c0
Aug 31 12:32:10 Gemini kernel:  [<c038e3e0>]
unknown_bootoption+0x0/0x1a0
Aug 31 12:32:10 Gemini kernel:  =======================
Aug 31 12:32:10 Gemini kernel: DMA per-cpu:
Aug 31 12:32:10 Gemini kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
0   Cold: hi:    0, btch:   1 usd:   0
Aug 31 12:32:10 Gemini kernel: Normal per-cpu:
Aug 31 12:32:10 Gemini kernel: CPU    0: Hot: hi:   42, btch:   7 usd:
39   Cold: hi:   14, btch:   3 usd:  11
Aug 31 12:32:10 Gemini kernel: Active:22747 inactive:5150 dirty:12
writeback:0 unstable:0
Aug 31 12:32:10 Gemini kernel:  free:6426 slab:4932 mapped:937
pagetables:124 bounce:0
Aug 31 12:32:10 Gemini kernel: DMA free:3268kB min:160kB low:200kB
high:240kB active:6424kB inactive:1104kB present:16256kB pages_scanned:0
all_unreclaimable? no
Aug 31 12:32:10 Gemini kernel: lowmem_reserve[]: 0 142
Aug 31 12:32:10 Gemini kernel: Normal free:22436kB min:1448kB low:1808kB
high:2172kB active:84564kB inactive:19496kB present:146304kB
pages_scanned:0 all_unreclaimable? no
Aug 31 12:32:10 Gemini kernel: lowmem_reserve[]: 0 0
Aug 31 12:32:10 Gemini kernel: DMA: 609*4kB 102*8kB 1*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3268kB
Aug 31 12:32:10 Gemini kernel: Normal: 4487*4kB 543*8kB 1*16kB 0*32kB
0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 22436kB
Aug 31 12:32:10 Gemini kernel: Swap cache: add 0, delete 0, find 0/0,
race 0+0
Aug 31 12:32:10 Gemini kernel: Free swap  = 209624kB
Aug 31 12:32:10 Gemini kernel: Total swap = 209624kB
