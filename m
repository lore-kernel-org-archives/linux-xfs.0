Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 03:36:48 -0700 (PDT)
Received: from bay0-omc1-s35.bay0.hotmail.com (bay0-omc1-s35.bay0.hotmail.com [65.54.246.107])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5JAaido023816
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 03:36:45 -0700
Message-ID: <BAY103-DAV1537BCD1BAF12085769E33B2120@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl> <20070320064632.GO32602149@melbourne.sgi.com> <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl> <20070607130505.GE85884050@sgi.com> <BAY103-DAV141D991980E54836534A00B2250@phx.gbl> <20070612061440.GQ86004887@sgi.com> <BAY103-DAV164930BAD25A9841FEF442B2190@phx.gbl>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Tue, 19 Jun 2007 12:36:25 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Marco Berizzi <pupilla@hotmail.com>

Marco Berizzi wrote:

> David Chinner wrote:
>
> > On Fri, Jun 08, 2007 at 03:59:39PM +0200, Marco Berizzi wrote:
> > > David Chinner wrote:
> > > > Where we saw signs of on disk directory corruption. Have you run
> > > > xfs_repair successfully on the filesystem since you reported
> > > > this?
> > >
> > > yes.
> > >
> > > > If you did clean up the error, does xfs_repair report the same
> sort
> > > > of error again?
> > >
> > > I have run xfs_repair this morning.
> > > Here is the report:
> >
> > <reports no on disk errors>
> >
> > > > Have you run a 2.6.16-rcX or 2.6.17.[0-6] kernel since you last
> > > > reported this problem?
> > >
> > > No. I have run only 2.6.19.x and 2.6.21.x
> > >
> > > After the xfs_repair I have remounted the file system.
> > > After few hours linux has crashed with this message:
> > > BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
> > > I have also the monitor bitmap.
> >
> > This is sounding like memory corruption is no corruption is being
> > found on disk by xfs_repair.  Have you run memtest86 on that box to
> > see if it's got bad memory?
>
> Yes. I have run memtest for one week:
> no errors.
> I have also changed the mother board,
> scsi controller and ram. Only the cpu
> and the 2 hot swap scsi disks were
> not replaced. IMHO this isn't an
> hardware problem, because the kernel
> with debugging options enabled didn't
> crash for a long time (>1 month). Just
> for record, at this moment this box is
> running 2.6.22-rc4 with no debug
> options enabled. I will keep you
> informed.
> Thanks everybody for the support.

Hi David,
on another system which is doing the
same task (openswan + squid), this
morning I have found the following
errors (2.6.21.5 after 4 days uptime).
The tricky thing is that always the
squid file cache filesystem is
corrupted. The same box with 2.6.20.x
and 2.6.21.x with 'Debug slab memory
allocations' enabled, never show any
errors for 1 month.

# dmesg
Linux version 2.6.21.5 (root@Gemini) (gcc version 3.3.6) #1 Thu Jun 14
13:18:08 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f800 end:
000000000009f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f800 size: 0000000000000800 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 0000000009f00000 end:
000000000a000000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end:
0000000100000000 type: 2
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
Kernel command line: auto BOOT_IMAGE=Linux ro root=301
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01141000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 267.302 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 159020k/163840k available (1945k kernel code, 4392k reserved,
609k data, 156k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xca800000 - 0xfffb5000   ( 855 MB)
    lowmem  : 0xc0000000 - 0xca000000   ( 160 MB)
      .init : 0xc0382000 - 0xc03a9000   ( 156 kB)
      .data : 0xc02e667c - 0xc037eb94   ( 609 kB)
      .text : 0xc0100000 - 0xc02e667c   (1945 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay using timer specific routine.. 535.23 BogoMIPS
(lpj=1070464)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000
00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: After all inits, caps: 0183f9ff 00000000 00000000 00000040 00000000
00000000 00000000
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
Boot video device is 0000:01:00.0
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
Ending clean XFS mount for filesystem: hda1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 156k freed
input: AT Translated Set 2 keyboard as /class/input/input0
Adding 209624k swap on /dev/hda9.  Priority:-1 extents:1 across:209624k
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
Filesystem "hda1": Disabling barriers, not supported by the underlying
device
PCI: setting IRQ 9 as level-triggered
PCI: Found IRQ 9 for device 0000:00:09.0
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
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
0x0: 59 fe cf 04 98 58 bc e2 42 3a 05 ee b2 12 b7 25
Filesystem "hda8": XFS internal error xfs_da_do_buf(2) at line 2086 of
file fs/xfs/xfs_da_btree.c.  Caller 0xc01a7aa8
 [<c01a75bb>] xfs_da_do_buf+0x37b/0x7c0
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c011649e>] profile_tick+0x3e/0x70
 [<c012bf4f>] tick_handle_periodic+0xf/0x60
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad07b>] xfs_dir2_leaf_lookup+0x2b/0xd0
 [<c01a8e30>] xfs_dir2_isleaf+0x20/0x70
 [<c01a8561>] xfs_dir_lookup+0xf1/0x110
 [<c0296712>] ip_route_output_flow+0x22/0x90
 [<c02a06a5>] inet_csk_route_req+0xa5/0x140
 [<c01d1f64>] xfs_dir_lookup_int+0x34/0x100
 [<c026e5db>] sk_alloc+0x2b/0xd0
 [<c01d758e>] xfs_lookup+0x4e/0x80
 [<c01e2ac2>] xfs_vn_lookup+0x52/0x90
 [<c0157337>] real_lookup+0xc7/0xf0
 [<c01575b0>] do_lookup+0x90/0xc0
 [<c0157b8b>] __link_path_walk+0x5ab/0xa70
 [<c026f2a7>] sk_stop_timer+0x17/0x20
 [<c0158095>] link_path_walk+0x45/0xd0
 [<c0276407>] process_backlog+0x77/0xf0
 [<c0150334>] get_unused_fd+0x54/0xa0
 [<c015836d>] do_path_lookup+0xdd/0x1a0
 [<c01584a0>] __path_lookup_intent_open+0x50/0x90
 [<c0158501>] path_lookup_open+0x21/0x30
 [<c0158ce8>] open_namei+0x68/0x580
 [<c0297cb2>] ip_rcv+0x212/0x460
 [<c0298090>] ip_rcv_finish+0x0/0x240
 [<c015017e>] do_filp_open+0x2e/0x50
 [<c0276407>] process_backlog+0x77/0xf0
 [<c0150334>] get_unused_fd+0x54/0xa0
 [<c0150442>] do_sys_open+0x42/0xd0
 [<c01504ec>] sys_open+0x1c/0x20
 [<c01028fc>] syscall_call+0x7/0xb
 [<c02e0000>] pfkey_xfrm_state2msg+0x4e0/0xb70
 =======================
0x0: 59 fe cf 04 98 58 bc e2 42 3a 05 ee b2 12 b7 25
Filesystem "hda8": XFS internal error xfs_da_do_buf(2) at line 2086 of
file fs/xfs/xfs_da_btree.c.  Caller 0xc01a7aa8
 [<c01a75bb>] xfs_da_do_buf+0x37b/0x7c0
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01cfdea>] xfs_trans_unreserve_and_mod_sb+0x20a/0x210
 [<c01c36dc>] xlog_assign_tail_lsn+0xc/0x20
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad07b>] xfs_dir2_leaf_lookup+0x2b/0xd0
 [<c01a8e30>] xfs_dir2_isleaf+0x20/0x70
 [<c01a8561>] xfs_dir_lookup+0xf1/0x110
 [<c015608a>] pipe_read+0x20a/0x2c0
 [<c01d1f64>] xfs_dir_lookup_int+0x34/0x100
 [<c01580b9>] link_path_walk+0x69/0xd0
 [<c01d758e>] xfs_lookup+0x4e/0x80
 [<c01e2ac2>] xfs_vn_lookup+0x52/0x90
 [<c0158619>] __lookup_hash+0x89/0xb0
 [<c0159a21>] do_unlinkat+0x61/0x110
 [<c0150d48>] vfs_read+0xe8/0x110
 [<c0150fc7>] sys_read+0x47/0x80
 [<c01028fc>] syscall_call+0x7/0xb
 =======================
0x0: 59 fe cf 04 98 58 bc e2 42 3a 05 ee b2 12 b7 25
Filesystem "hda8": XFS internal error xfs_da_do_buf(2) at line 2086 of
file fs/xfs/xfs_da_btree.c.  Caller 0xc01a7aa8
 [<c01a75bb>] xfs_da_do_buf+0x37b/0x7c0
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<ca835137>] issue_and_wait+0x27/0xb0 [3c59x]
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad07b>] xfs_dir2_leaf_lookup+0x2b/0xd0
 [<c01a8e30>] xfs_dir2_isleaf+0x20/0x70
 [<c01a8561>] xfs_dir_lookup+0xf1/0x110
 [<c0275dd5>] dev_queue_xmit+0x165/0x220
 [<c029ad18>] ip_output+0x158/0x270
 [<c01d1f64>] xfs_dir_lookup_int+0x34/0x100
 [<c01d758e>] xfs_lookup+0x4e/0x80
 [<c01e2ac2>] xfs_vn_lookup+0x52/0x90
 [<c0157337>] real_lookup+0xc7/0xf0
 [<c01575b0>] do_lookup+0x90/0xc0
 [<c0157b8b>] __link_path_walk+0x5ab/0xa70
 [<c0158095>] link_path_walk+0x45/0xd0
 [<c0150334>] get_unused_fd+0x54/0xa0
 [<c015836d>] do_path_lookup+0xdd/0x1a0
 [<c01344c7>] handle_IRQ_event+0x27/0x60
 [<c01584a0>] __path_lookup_intent_open+0x50/0x90
 [<c0158501>] path_lookup_open+0x21/0x30
 [<c0158ce8>] open_namei+0x68/0x580
 [<c0141f47>] do_wp_page+0x2a7/0x3a0
 [<c015017e>] do_filp_open+0x2e/0x50
 [<c0150334>] get_unused_fd+0x54/0xa0
 [<c0150442>] do_sys_open+0x42/0xd0
 [<c01504ec>] sys_open+0x1c/0x20
 [<c01028fc>] syscall_call+0x7/0xb
 =======================
0x0: 59 fe cf 04 98 58 bc e2 42 3a 05 ee b2 12 b7 25
Filesystem "hda8": XFS internal error xfs_da_do_buf(2) at line 2086 of
file fs/xfs/xfs_da_btree.c.  Caller 0xc01a7aa8
 [<c01a75bb>] xfs_da_do_buf+0x37b/0x7c0
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01cfdea>] xfs_trans_unreserve_and_mod_sb+0x20a/0x210
 [<c01c36dc>] xlog_assign_tail_lsn+0xc/0x20
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad28d>] xfs_dir2_leaf_lookup_int+0x16d/0x2b0
 [<c01ad07b>] xfs_dir2_leaf_lookup+0x2b/0xd0
 [<c01a8e30>] xfs_dir2_isleaf+0x20/0x70
 [<c01a8561>] xfs_dir_lookup+0xf1/0x110
 [<c015608a>] pipe_read+0x20a/0x2c0
 [<c01d1f64>] xfs_dir_lookup_int+0x34/0x100
 [<c01580b9>] link_path_walk+0x69/0xd0
 [<c01d758e>] xfs_lookup+0x4e/0x80
 [<c01e2ac2>] xfs_vn_lookup+0x52/0x90
 [<c0158619>] __lookup_hash+0x89/0xb0
 [<c0159a21>] do_unlinkat+0x61/0x110
 [<c0150d48>] vfs_read+0xe8/0x110
 [<c0150fc7>] sys_read+0x47/0x80
 [<c01028fc>] syscall_call+0x7/0xb
 =======================
0x0: 59 fe cf 04 98 58 bc e2 42 3a 05 ee b2 12 b7 25
Filesystem "hda8": XFS internal error xfs_da_do_buf(2) at line 2086 of
file fs/xfs/xfs_da_btree.c.  Caller 0xc01a7aa8
 [<c01a75bb>] xfs_da_do_buf+0x37b/0x7c0
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01a7aa8>] xfs_da_read_buf+0x48/0x60
 [<c01ac6cf>] xfs_dir2_leaf_getdents+0x35f/0xb40
 [<c01ac6cf>] xfs_dir2_leaf_getdents+0x35f/0xb40
 [<c013a740>] get_page_from_freelist+0x80/0xc0
 [<c01a8742>] xfs_dir_getdents+0xd2/0x120
 [<c01a8e80>] xfs_dir2_put_dirent64_direct+0x0/0x90
 [<c01a8e80>] xfs_dir2_put_dirent64_direct+0x0/0x90
 [<c01d9228>] xfs_readdir+0x48/0x70
 [<c01e0690>] xfs_file_readdir+0x100/0x220
 [<c015b9f0>] filldir+0x0/0x100
 [<c015402b>] sys_fstat64+0x2b/0x30
 [<c015b9f0>] filldir+0x0/0x100
 [<c015b891>] vfs_readdir+0x81/0xa0
 [<c015bb4e>] sys_getdents+0x5e/0xa0
 [<c01028fc>] syscall_call+0x7/0xb
 =======================
Filesystem "hda8": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem hda8
Ending clean XFS mount for filesystem: hda8

xfr_repair output:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
