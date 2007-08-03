Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Aug 2007 07:37:15 -0700 (PDT)
Received: from bay0-omc2-s29.bay0.hotmail.com (bay0-omc2-s29.bay0.hotmail.com [65.54.246.165])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l73Eb8bm029136
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2007 07:37:09 -0700
Message-ID: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>] xfs_bmap_search_multi_extents+0x6f/0xe0)
Date: Fri, 3 Aug 2007 16:36:25 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Marco Berizzi <pupilla@hotmail.com>

Marco Berizzi wrote:

> Marco Berizzi wrote:
>
> > Hello everybody.
> > I'm running linux 2.6.22 on Slackware.
> > This box is running openswan 2.4.9
> > and squid 2.6S13
> > I get tons of these messages:
> >
> > Jul 20 01:17:09 Gemini kernel: msnt_auth     S 00000000     0  8356
> 819
> > (NOTLB)
> > Jul 20 01:17:09 Gemini kernel:        c2bd5d54 00000086 00000001
> > 00000000 00000000 00000001 00000000 c11df050
> > Jul 20 01:17:09 Gemini kernel:        00000014 c2bd5e24 c2bd5e78
> > c2bd5e78 c11df050 c1255b7c c019c63f 00006559
> > Jul 20 01:17:09 Gemini kernel:        7601a27a 0002faa4 7fffffff
> > 7fffffff c8af2d00 c2bd5db0 c02e9fc6 c2bd5e50
> > Jul 20 01:17:09 Gemini kernel: Call Trace:
> > Jul 20 01:17:09 Gemini kernel:  [<c019c63f>]
> > xfs_bmap_search_multi_extents+0x6f/0xe0
> > Jul 20 01:17:09 Gemini kernel:  [<c02e9fc6>]
> schedule_timeout+0x96/0xa0
> > Jul 20 01:17:09 Gemini kernel:  [<c02e0d09>]
> > unix_stream_data_wait+0xa9/0xd0
> > Jul 20 01:17:09 Gemini kernel:  [<c0125f60>]
> > autoremove_wake_function+0x0/0x50
> > Jul 20 01:17:09 Gemini kernel:  [<c0125f60>]
> > autoremove_wake_function+0x0/0x50
> > Jul 20 01:17:09 Gemini kernel:  [<c02e10ac>]
> > unix_stream_recvmsg+0x37c/0x3e0
> > Jul 20 01:17:09 Gemini kernel:  [<c026e46d>] do_sock_read+0x9d/0xb0
> > Jul 20 01:17:09 Gemini kernel:  [<c026e4f8>] sock_aio_read+0x78/0x80
> > Jul 20 01:17:09 Gemini kernel:  [<c01517a0>] do_sync_read+0xc0/0x100
> > Jul 20 01:17:09 Gemini kernel:  [<c0125f60>]
> > autoremove_wake_function+0x0/0x50
> > Jul 20 01:17:09 Gemini kernel:  [<c0145313>]
do_mmap_pgoff+0x3f3/0x730
> > Jul 20 01:17:09 Gemini kernel:  [<c01518e0>] vfs_read+0x100/0x110
> > Jul 20 01:17:09 Gemini kernel:  [<c0151b47>] sys_read+0x47/0x80
> > Jul 20 01:17:09 Gemini kernel:  [<c010286e>] syscall_call+0x7/0xb
> > Jul 20 01:17:09 Gemini kernel:  =======================
> > Jul 20 09:01:35 Gemini kernel: atkbd.c: Spurious NAK on
> isa0060/serio0.
> > Some program might be trying access hardware directly.
> > Jul 20 09:02:05 Gemini kernel: atkbd.c: Spurious NAK on
> isa0060/serio0.
> > Some program might be trying access hardware directly.
> > Jul 20 09:05:39 Gemini kernel: atkbd.c: Spurious ACK on
> isa0060/serio0.
> > Some program might be trying access hardware directly.

> Me again.
> Just few minutes ago linux has been definitely
> crashed. This is the dmesg:
>
> Aug  2 15:24:36 Gemini kernel: BUG: unable to handle kernel paging
> request at virtual address cbb93164
> Aug  2 15:24:36 Gemini kernel:  printing eip:
> Aug  2 15:24:36 Gemini kernel: c014e83f
> Aug  2 15:24:36 Gemini kernel: *pde = 00000000
> Aug  2 15:24:36 Gemini kernel: Oops: 0002 [#1]
> Aug  2 15:24:36 Gemini kernel: Modules linked in: nf_nat_pptp
> nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp
> nf_conntrack_ftp 3c59x mii
> Aug  2 15:24:36 Gemini kernel: CPU:    0
> Aug  2 15:24:36 Gemini kernel: EIP:    0060:[<c014e83f>]    Not
tainted
> VLI
> Aug  2 15:24:36 Gemini kernel: EFLAGS: 00010807   (2.6.22 #1)
> Aug  2 15:24:36 Gemini kernel: EIP is at slab_put_obj+0x1f/0x40
> Aug  2 15:24:36 Gemini kernel: eax: ffffffff   ebx: c925a000   ecx:
> 5a2cdcd1   edx: 00a4e452
> Aug  2 15:24:36 Gemini kernel: esi: c11ff1e0   edi: c925a000   ebp:
> 0000000b   esp: c9fe9ed0
> Aug  2 15:24:36 Gemini kernel: ds: 007b   es: 007b   fs: 0000  gs:
0000
> ss: 0068
> Aug  2 15:24:37 Gemini kernel: Process xfssyncd (pid: 223, ti=c9fe8000
> task=c11b2a90 task.ti=c9fe8000)
> Aug  2 15:24:37 Gemini kernel: Stack: c925a000 c11c06a0 c11ff1e0
> c014ec16 00000000 0000003c c11b9010 c11b9010
> Aug  2 15:24:37 Gemini kernel:        c11ff1e0 c11ff1e0 00000000
> c014ecdf 00000000 0000003c c11b9000 c11b9000
> Aug  2 15:24:37 Gemini kernel:        00000246 c11ff1e0 c9a3aaf0
> c014f069 c9dce3e0 c9dce3e0 00000001 00000002
> Aug  2 15:24:37 Gemini kernel: Call Trace:
> Aug  2 15:24:37 Gemini kernel:  [<c014ec16>] free_block+0x86/0x100
> Aug  2 15:24:37 Gemini kernel:  [<c014ecdf>]
cache_flusharray+0x4f/0xc0
> Aug  2 15:24:37 Gemini kernel:  [<c014f069>] kmem_cache_free+0x69/0x90
> Aug  2 15:24:37 Gemini kernel:  [<c01be630>] xfs_idestroy+0x40/0x90
> Aug  2 15:24:37 Gemini kernel:  [<c01dc683>]
> xfs_finish_reclaim+0xb3/0x120
> Aug  2 15:24:37 Gemini kernel:  [<c01dc7b9>]
> xfs_finish_reclaim_all+0xc9/0xf0
> Aug  2 15:24:37 Gemini kernel:  [<c01d6503>] xfs_syncsub+0x63/0x290
> Aug  2 15:24:37 Gemini kernel:  [<c02e9f85>]
schedule_timeout+0x55/0xa0
> Aug  2 15:24:37 Gemini kernel:  [<c01e8572>] vfs_sync+0x22/0x30
> Aug  2 15:24:37 Gemini kernel:  [<c01e7bf1>] vfs_sync_worker+0x41/0x50
> Aug  2 15:24:37 Gemini kernel:  [<c01e7d09>] xfssyncd+0x109/0x180
> Aug  2 15:24:37 Gemini kernel:  [<c01e7c00>] xfssyncd+0x0/0x180
> Aug  2 15:24:37 Gemini kernel:  [<c0125b7a>] kthread+0x6a/0x70
> Aug  2 15:24:37 Gemini kernel:  [<c0125b10>] kthread+0x0/0x70
> Aug  2 15:24:37 Gemini kernel:  [<c0103387>]
> kernel_thread_helper+0x7/0x10
> Aug  2 15:24:37 Gemini kernel:  =======================
> Aug  2 15:24:37 Gemini kernel: Code: 4a 14 c3 89 f6 8d bc 27 00 00 00
00
> 83 ec 0c 89 74 24 04 89 c6 89 7c 24 08 89 d7 89 1c 24 8b 42 0c 29 c1
89
> c8 f7 66 14 8b 47 14 <89> 44 97 1c 8b 1c 24 89 57 14 8b 74 24 04 ff 4f
> 10 8b 7c 24 08
> Aug  2 15:24:37 Gemini kernel: EIP: [<c014e83f>]
slab_put_obj+0x1f/0x40
> SS:ESP 0068:c9fe9ed0
> Aug  2 15:24:40 Gemini kernel: BUG: unable to handle kernel paging
> request at virtual address 00100104
> Aug  2 15:24:40 Gemini kernel:  printing eip:
> Aug  2 15:24:40 Gemini kernel: c014ebf4
> Aug  2 15:24:40 Gemini kernel: *pde = 00000000
> Aug  2 15:24:40 Gemini kernel: Oops: 0002 [#2]
> Aug  2 15:24:40 Gemini kernel: Modules linked in: nf_nat_pptp
> nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp
> nf_conntrack_ftp 3c59x mii
> Aug  2 15:24:40 Gemini kernel: CPU:    0
> Aug  2 15:24:40 Gemini kernel: EIP:    0060:[<c014ebf4>]    Not
tainted
> VLI
> Aug  2 15:24:40 Gemini kernel: EFLAGS: 00010082   (2.6.22 #1)
> Aug  2 15:24:40 Gemini kernel: EIP is at free_block+0x64/0x100
> Aug  2 15:24:40 Gemini kernel: eax: 00100100   ebx: c925a000   ecx:
> c925a4ec   edx: 00200200
> Aug  2 15:24:40 Gemini kernel: esi: c11c06a0   edi: c11ff1e0   ebp:
> 0000000b   esp: c11a3f14
> Aug  2 15:24:40 Gemini kernel: ds: 007b   es: 007b   fs: 0000  gs:
0000
> ss: 0068
> Aug  2 15:24:40 Gemini kernel: Process events/0 (pid: 4, ti=c11a2000
> task=c1195a50 task.ti=c11a2000)
> Aug  2 15:24:40 Gemini kernel: Stack: 00000000 00000018 c11b9010
> c11b9010 c11b9000 00000018 c11ff1e0 c014f4e1
> Aug  2 15:24:40 Gemini kernel:        00000000 c11c06a0 c11ff1e0
> c03cdc20 00000000 c014f55b 00000000 00000000
> Aug  2 15:24:40 Gemini kernel:        00038e6b c03cdc20 c117e8a0
> c014f500 c01228ea 00005ead 7180abb4 00073f12
> Aug  2 15:24:40 Gemini kernel: Call Trace:
> Aug  2 15:24:40 Gemini kernel:  [<c014f4e1>] drain_array+0x91/0xb0
> Aug  2 15:24:40 Gemini kernel:  [<c014f55b>] cache_reap+0x5b/0x100
> Aug  2 15:24:40 Gemini kernel:  [<c014f500>] cache_reap+0x0/0x100
> Aug  2 15:24:40 Gemini kernel:  [<c01228ea>] run_workqueue+0x4a/0x100
> Aug  2 15:24:40 Gemini kernel:  [<c0122a6b>] worker_thread+0xcb/0x100
> Aug  2 15:24:40 Gemini kernel:  [<c0125f60>]
> autoremove_wake_function+0x0/0x50
> Aug  2 15:24:40 Gemini kernel:  [<c0112387>]
__wake_up_common+0x37/0x70
> Aug  2 15:24:40 Gemini kernel:  [<c0125f60>]
> autoremove_wake_function+0x0/0x50
> Aug  2 15:24:40 Gemini kernel:  [<c01229a0>] worker_thread+0x0/0x100
> Aug  2 15:24:40 Gemini kernel:  [<c0125b7a>] kthread+0x6a/0x70
> Aug  2 15:24:40 Gemini kernel:  [<c0125b10>] kthread+0x0/0x70
> Aug  2 15:24:40 Gemini kernel:  [<c0103387>]
> kernel_thread_helper+0x7/0x10
> Aug  2 15:24:40 Gemini kernel:  =======================
> Aug  2 15:24:40 Gemini kernel: Code: da 25 00 40 02 00 3d 00 40 02 00
0f
> 84 a8 00 00 00 8b 02 a8 80 0f 84 8b 00 00 00 8b 5a 1c 8b 44 24 20 8b
53
> 04 8b 74 87 4c 8b 03 <89> 50 04 89 02 89 da c7 03 00 01 10 00 c7 43 04
> 00 02 20 00 8b
> Aug  2 15:24:40 Gemini kernel: EIP: [<c014ebf4>] free_block+0x64/0x100
> SS:ESP 0068:c11a3f14
> Aug  2 15:29:03 Gemini kernel: ------------[ cut here ]------------
> Aug  2 15:29:03 Gemini kernel: kernel BUG at mm/slab.c:2980!
> Aug  2 15:29:03 Gemini kernel: invalid opcode: 0000 [#3]
> Aug  2 15:29:03 Gemini kernel: Modules linked in: nf_nat_pptp
> nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp
> nf_conntrack_ftp 3c59x mii
> Aug  2 15:29:03 Gemini kernel: CPU:    0
> Aug  2 15:29:03 Gemini kernel: EIP:    0060:[<c014eb3d>]    Not
tainted
> VLI
> Aug  2 15:29:03 Gemini kernel: EFLAGS: 00010046   (2.6.22 #1)
> Aug  2 15:29:03 Gemini kernel: EIP is at
cache_alloc_refill+0x16d/0x1c0
> Aug  2 15:29:03 Gemini kernel: eax: 0000001c   ebx: 00000005   ecx:
> 00000036   edx: c11ff1e0
> Aug  2 15:29:03 Gemini kernel: esi: c8a40000   edi: c11c06a0   ebp:
> c11b9000   esp: c8da7dc8
> Aug  2 15:29:03 Gemini kernel: ds: 007b   es: 007b   fs: 0000  gs:
0033
> ss: 0068
> Aug  2 15:29:03 Gemini kernel: Process unlinkd (pid: 2476, ti=c8da6000
> task=c11b3ab0 task.ti=c8da6000)
> Aug  2 15:29:03 Gemini kernel: Stack: c9fb1400 c11c06a8 00000036
> 00000250 c11ff1e0 00000286 c11ff1e0 00000250
> Aug  2 15:29:03 Gemini kernel:        c11ff1e0 c014ed8f 00000000
> 00000001 c01de776 c9fb1400 00025638 c01c5554
> Aug  2 15:29:03 Gemini kernel:        c6355800 c9fb1400 c11ff1e0
> c64340d4 c01de805 c6355800 c9fb1400 00000004
> Aug  2 15:29:03 Gemini kernel: Call Trace:
> Aug  2 15:29:03 Gemini kernel:  [<c014ed8f>]
kmem_cache_alloc+0x3f/0x50
> Aug  2 15:29:03 Gemini kernel:  [<c01de776>] kmem_zone_alloc+0x46/0xc0
> Aug  2 15:29:03 Gemini kernel:  [<c01c5554>] xfs_log_reserve+0xa4/0xb0
> Aug  2 15:29:03 Gemini kernel:  [<c01de805>]
kmem_zone_zalloc+0x15/0x50
> Aug  2 15:29:03 Gemini kernel:  [<c01c108d>]
> xfs_inode_item_init+0x1d/0x80
> Aug  2 15:29:03 Gemini kernel:  [<c01d3c1f>] xfs_trans_ijoin+0x6f/0x80
> Aug  2 15:29:03 Gemini kernel:  [<c01da4b3>] xfs_remove+0x1c3/0x460
> Aug  2 15:29:03 Gemini kernel:  [<c01e51b3>] xfs_vn_unlink+0x23/0x60
> Aug  2 15:29:03 Gemini kernel:  [<c01d447b>]
> xfs_dir_lookup_int+0x9b/0x100
> Aug  2 15:29:03 Gemini kernel:  [<c01d2c78>]
> xfs_trans_unlocked_item+0x38/0x60
> Aug  2 15:29:03 Gemini kernel:  [<c01d9a4a>] xfs_lookup+0x6a/0x80
> Aug  2 15:29:03 Gemini kernel:  [<c01619f0>] d_instantiate+0x30/0x50
> Aug  2 15:29:03 Gemini kernel:  [<c0161ccd>] d_splice_alias+0x2d/0xa0
> Aug  2 15:29:03 Gemini kernel:  [<c0157c99>] permission+0x89/0xd0
> Aug  2 15:29:03 Gemini kernel:  [<c015a7a8>] vfs_unlink+0x88/0x90
> Aug  2 15:29:03 Gemini kernel:  [<c015a844>] do_unlinkat+0x94/0x110
> Aug  2 15:29:03 Gemini kernel:  [<c01518c8>] vfs_read+0xe8/0x110
> Aug  2 15:29:03 Gemini kernel:  [<c0151b47>] sys_read+0x47/0x80
> Aug  2 15:29:03 Gemini kernel:  [<c010286e>] syscall_call+0x7/0xb
> Aug  2 15:29:03 Gemini kernel:  =======================
> Aug  2 15:29:03 Gemini kernel: Code: d2 0f 84 cb fe ff ff eb ba 8b 55
00
> 31 c0 85 d2 75 b1 eb c0 8b 47 08 89 70 04 89 06 8b 44 24 04 89 77 08
89
> 46 04 e9 7a ff ff ff <0f> 0b 90 eb fe c7 47 30 01 00 00 00 8b 77 10 8d
> 47 10 39 c6 0f
> Aug  2 15:29:03 Gemini kernel: EIP: [<c014eb3d>]
> cache_alloc_refill+0x16d/0x1c0 SS:ESP 0068:c8da7dc8

Me again.
This morning a system with a similar .config
(only different hardware) has been crashed.
Only a monitor bitmap at http://80.204.235.230/foto3.jpg
is available. No error was written under
/var/log/kernel
Here is dmesg and .config

Linux version 2.6.22 (root@Pleiadi) (gcc version 3.4.6) #1 SMP Mon Jul 9
16:20:51 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
 BIOS-e820: 000000003fef0000 - 000000003fefb000 (ACPI data)
 BIOS-e820: 000000003fefb000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 000000003ff80000 (usable)
 BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6c10
Entering add_active_range(0, 0, 262016) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262016
early_node_map[1] active PFN ranges
    0:        0 ->   262016
On node 0 totalpages: 262016
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 255 pages used for memmap
  HighMem zone: 32385 pages, LIFO batch:7
DMI present.
ACPI: RSDP 000F6BA0, 0024 (r2 PTLTD )
ACPI: XSDT 3FEF5381, 004C (r1 PTLTD    XSDT    6040001  LTP        0)
ACPI: FACP 3FEF5441, 00F4 (r3 FSC              6040001         F4240)
ACPI: DSDT 3FEF5535, 597B (r1 FSC    D1649     6040001 MSFT  2000002)
ACPI: FACS 3FEFBFC0, 0040
ACPI: SPCR 3FEFAEB0, 0050 (r1 PTLTD  $UCRTBL$  6040001 PTL         1)
ACPI: MCFG 3FEFAF00, 0040 (r1 PTLTD    MCFG    6040001  LTP        0)
ACPI: APIC 3FEFAF40, 0098 (r1 PTLTD    APIC    6040001  LTP        0)
ACPI: BOOT 3FEFAFD8, 0028 (r1 PTLTD  $SBFTBL$  6040001  LTP        1)
ACPI: PM-Timer IO Port: 0xf008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x04] address[0xfec80800] gsi_base[48])
IOAPIC[2]: apic_id 4, version 32, address 0xfec80800, GSI 48-71
ACPI: IOAPIC (id[0x05] address[0xfec84000] gsi_base[72])
IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
ACPI: IOAPIC (id[0x06] address[0xfec84800] gsi_base[96])
IOAPIC[4]: apic_id 6, version 32, address 0xfec84800, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 5 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Built 1 zonelists.  Total pages: 259969
Kernel command line: BOOT_IMAGE=Linux ro root=801
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec80800)
mapped IOAPIC to ffff9000 (fec84000)
mapped IOAPIC to ffff8000 (fec84800)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3200.438 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1035204k/1048064k available (2069k kernel code, 12224k reserved,
626k data, 204k init, 130496k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03a7000 - 0xc03da000   ( 204 kB)
      .data : 0xc03055e4 - 0xc03a2000   ( 626 kB)
      .text : 0xc0100000 - 0xc03055e4   (2069 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay using timer specific routine.. 6403.73 BogoMIPS
(lpj=32018667)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000641d 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 0000b180 0000641d
00000000 00000001
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 10k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Xeon(TM) CPU 3.20GHz stepping 0a
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.45 BogoMIPS
(lpj=32002272)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000641d 00000000 00000001
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 0000b180 0000641d
00000000 00000001
CPU1: Intel(R) Xeon(TM) CPU 3.20GHz stepping 0a
Total of 2 processors activated (12804.18 BogoMIPS).
ENABLING IO-APIC IRQs
.TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=62
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG
support.
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: Device [PS2M] status [00000008]: functional but not present;
setting present
ACPI: Device [ECP] status [00000008]: functional but not present;
setting present
ACPI: Device [COM1] status [00000008]: functional but not present;
setting present
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region f000-f07f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region f180-f1bf claimed by ICH4 GPIO
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEA0.DOB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEA0.DOB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEC0.PXH0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEC0.PXH2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
Time: tsc clocksource has been installed.
pnp: 00:02: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:02: iomem range 0xfec00000-0xfecfffff could not be reserved
PCI: Bridge: 0000:01:00.0
  IO window: 3000-3fff
  MEM window: de100000-de3fffff
  PREFETCH window: 50000000-501fffff
PCI: Bridge: 0000:01:00.2
  IO window: 4000-4fff
  MEM window: de400000-de4fffff
  PREFETCH window: 50200000-502fffff
PCI: Bridge: 0000:00:02.0
  IO window: 3000-4fff
  MEM window: de100000-de4fffff
  PREFETCH window: 50000000-502fffff
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: de500000-de5fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: de600000-de6fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:06:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:06:00.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: de700000-de7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 5000-5fff
  MEM window: de800000-dfffffff
  PREFETCH window: 50300000-503fffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.0 to 64
PCI: Setting latency timer of device 0000:01:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:06:00.0 to 64
ACPI: PCI Interrupt 0000:06:00.2[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:06:00.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x5c set to 0x80
highmem bounce pool size: 64 pages
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler deadline registered (default)
Boot video device is 0000:09:05.0
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 24 (level, low) -> IRQ 18
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=01033000h, Ports=1, MaxQ=222, IRQ=18
scsi 0:0:0:0: Direct-Access     LSILOGIC 1030          IM 1000 PQ: 0
ANSI: 2
sd 0:0:0:0: [sda] 585728000 512-byte hardware sectors (299893 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 03 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 585728000 512-byte hardware sectors (299893 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 03 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:8:0: Processor         SDR      GEM318P          1    PQ: 0
ANSI: 2
 target0:0:8: Beginning Domain Validation
 target0:0:8: Ending Domain Validation
 target0:0:8: asynchronous
scsi 0:1:0:0: Direct-Access     HITACHI  HUS103030FL3800  SK02 PQ: 0
ANSI: 3
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
 target0:1:0: Beginning Domain Validation
 target0:1:0: Ending Domain Validation
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online
 target0:1:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP
(6.25 ns, offset 80)
scsi 0:1:1:0: Direct-Access     HITACHI  HUS103030FL3800  SK02 PQ: 0
ANSI: 3
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
 target0:1:1: Beginning Domain Validation
 target0:1:1: Ending Domain Validation
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online
 target0:1:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP
(6.25 ns, offset 80)
ACPI: PCI Interrupt 0000:02:08.1[B] -> GSI 25 (level, low) -> IRQ 19
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator}
scsi1 : ioc1: LSI53C1030, FwRev=01033000h, Ports=1, MaxQ=222, IRQ=19
PNP: PS/2 Controller [PNP0303:KEYB] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
nf_conntrack version 0.5.0 (8188 buckets, 65504 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input0
XFS mounting filesystem sda1
Starting XFS recovery on filesystem: sda1 (logdev: internal)
Ending XFS recovery on filesystem: sda1 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 204k freed
Adding 875500k swap on /dev/sda9.  Priority:-1 extents:1 across:875500k
tg3.c:v3.77 (May 31, 2007)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express)
10/100/1000Base-T Ethernet 00:30:05:cb:27:c1
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:05:00.0 to 64
eth1: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express)
10/100/1000Base-T Ethernet 00:30:05:c2:56:0e
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 52 (level, low) -> IRQ 20
e1000: 0000:03:04.0: e1000_probe: (PCI-X:100MHz:64-bit)
00:04:23:d0:0f:02
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
XFS mounting filesystem sda5
Starting XFS recovery on filesystem: sda5 (logdev: internal)
Ending XFS recovery on filesystem: sda5 (logdev: internal)
XFS mounting filesystem sda6
Starting XFS recovery on filesystem: sda6 (logdev: internal)
Ending XFS recovery on filesystem: sda6 (logdev: internal)
XFS mounting filesystem sda7
Starting XFS recovery on filesystem: sda7 (logdev: internal)
Ending XFS recovery on filesystem: sda7 (logdev: internal)
XFS mounting filesystem sda8
Starting XFS recovery on filesystem: sda8 (logdev: internal)
Ending XFS recovery on filesystem: sda8 (logdev: internal)
e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow
Control: RX
tg3: eth1: Link is up at 100 Mbps, full duplex.
tg3: eth1: Flow control is off for TX and off for RX.
tg3: eth0: Link is up at 10 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.


#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22
# Mon Jul  9 16:14:56 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=15
# CONFIG_CPUSETS is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set
CONFIG_STOP_MACHINE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_MODEL=4
# CONFIG_HPET_TIMER is not set
CONFIG_NR_CPUS=2
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_QUICK=1
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_EFI is not set
CONFIG_IRQBALANCE=y
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_NET_KEY=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_MULTIPATH_CACHED is not set
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CT_PROTO_GRE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_PPTP=m
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
# CONFIG_IP_NF_MATCH_RECENT is not set
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=m
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_SAME=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_FTP=m
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_PPTP=m
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set

#
# QoS and/or fair queueing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_FIFO=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_ESTIMATOR=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
# CONFIG_FW_LOADER is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=m
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
# CONFIG_BLK_DEV_IDEDISK is not set
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
CONFIG_IDEDMA_ONLYDISK=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_ATA is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set

#
# IEEE 1394 (FireWire) support
#

#
# An alternative FireWire stack is available with EXPERIMENTAL=y
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
CONFIG_IFB=m
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=m
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set
# CONFIG_HWMON is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set

#
# HID Devices
#
# CONFIG_HID is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
# CONFIG_USB is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#

#
# Real Time Clock
#

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# Virtualization
#

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_SECURITY is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y

#
# Miscellaneous filesystems
#
# CONFIG_HFSPLUS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_AES is not set
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set

#
# Library routines
#
CONFIG_BITREVERSE=m
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
