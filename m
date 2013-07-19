Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45F097F53
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 15:28:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3523A304075
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 13:28:42 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id XdZYz3k6GAyYyiKn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 13:28:39 -0700 (PDT)
Date: Fri, 19 Jul 2013 22:28:37 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
Message-ID: <20130719202837.GC360@x4>
References: <20130712070721.GA359@x4> <20130715022841.GH5228@dastard>
	<20130715064734.GA361@x4> <20130719122235.GA360@x4>
	<CAAxjCExBi-4Qgf6-=MBzdkzBmMtu=GTURu46DoD2CzpnF2dinw@mail.gmail.com>
	<20130719125149.GB360@x4> <51E9630A.3070201@sandeen.net>
	<20130719163220.GA363@x4> <20130719191331.GG3572@sgi.com>
	<20130719195628.GB360@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130719195628.GB360@x4>
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
To: Ben Myers <bpm@sgi.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux fs XFS <xfs@oss.sgi.com>

On 2013.07.19 at 21:56 +0200, Markus Trippelsdorf wrote:
> On 2013.07.19 at 14:13 -0500, Ben Myers wrote:
> > Hey Markus,
> > 
> > On Fri, Jul 19, 2013 at 06:32:20PM +0200, Markus Trippelsdorf wrote:
> > > On 2013.07.19 at 11:02 -0500, Eric Sandeen wrote:
> > > > > Unfortunately it turned out that in this case there is filesystem
> > > > > corruption. (Fortunately this normally happens only very rarely on rc1
> > > > > kernels).
> > > > 
> > > > Corruption is when you get back data that you did not write,
> > > > or metadata which is inconsistent or unreadable even after a proper
> > > > log replay.
> > > > 
> > > > Corruption is _not_ unsynced, buffered data that was lost on a
> > > > crash or poweroff.
> > > > 
> > > > But I might not have followed the thread properly, and I might
> > > > misunderstand your situation.
> > > > 
> > > > When you experience this lost file [data] scenario, was it after an
> > > > orderly reboot, or after a crash and/or system reset?
> > > 
> > > To reproduce this issue simply boot into your desktop and then hit
> > > sysrq-c and reboot. After log replay without error messages, the
> > > filesystem is in an inconsistent state and many small config files are
> > > lost. There are also undeletable files. You need to run xfs_repair
> > > manually to bring the filesystem back to normal.
> > > 
> > > When cca9f93a52d is reverted, you don't loose your config files and the
> > > filesystem is OK after log replay. xfs_repair reports no issues at all.
> > 
> > I'm a bit late to the party, but I wanted to give this a try.
> > 
> > On the machine I tried, I was not able to reproduce any corruption with a
> > 
> > echo b > /proc/sysrq-trigger
> > 
> > xfs_repair -n found no problems at all.  I'll try it on a few more.
> > 
> > Could you post some of your latest xfs_repair output?  And, have you been able
> > to reproduce this on more than one machine?  I may have missed that detail
> > earlier in the thread.
> 
> I didn't save the xfs_repair output on every run. See the examples that
> I've posted in this thread before.
> And the issue always happens on the same machine.

To add some more info I'll attach the full dmseg of my machine.
I/O scheduler is deadline on both disks.


[    0.000000] Linux version 3.11.0-rc1-00181-gb8a33fc-dirty (markus@x4) (gcc version 4.8.1 (GCC) ) #87 SMP Fri Jul 19 19:42:54 CEST 2013
[    0.000000] Command line: root=PARTUUID=F61ADF02-9A53-485C-9BD4-3DD2F964C27C init=/sbin/minit rootflags=logbsize=262144 fbcon=rotate:3 radeon.dpm=1 drm_kms_helper.poll=0 quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfe8ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfe90000-0x00000000dfea7fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dfea8000-0x00000000dfecffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dfed0000-0x00000000dfefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x220000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000220000000 aka 8704M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdfe90 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01bb6000, 0x01bb6fff] PGTABLE
[    0.000000] BRK [0x01bb7000, 0x01bb7fff] PGTABLE
[    0.000000] BRK [0x01bb8000, 0x01bb8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21fe00000-0x21fffffff]
[    0.000000]  [mem 0x21fe00000-0x21fffffff] page 2M
[    0.000000] BRK [0x01bb9000, 0x01bb9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21fdfffff]
[    0.000000]  [mem 0x21c000000-0x21fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfe8ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfe8ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] ACPI: RSDP 00000000000fb880 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000dfe90100 0005C (v01 041311 XSDT1656 20110413 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000dfe90290 000F4 (v03 041311 FACP1656 20110413 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20130517/tbfadt-603)
[    0.000000] ACPI: DSDT 00000000dfe90450 0E6FE (v01  A1152 A1152000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 00000000dfea8000 00040
[    0.000000] ACPI: APIC 00000000dfe90390 0007C (v01 041311 APIC1656 20110413 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000dfe90410 0003C (v01 041311 OEMMCFG  20110413 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000dfea8040 00072 (v01 041311 OEMB1656 20110413 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000dfe9f450 000E8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 00000000dfe9f540 00038 (v01 041311 OEMHPET  20110413 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000dfe9f580 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880217600000-ffff88021f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfe8ffff]
[    0.000000]   node   0: [mem 0x100000000-0x21fffffff]
[    0.000000] On node 0 totalpages: 2096686
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14267 pages used for memmap
[    0.000000]   DMA32 zone: 913040 pages, LIFO batch:31
[    0.000000]   Normal zone: 18432 pages used for memmap
[    0.000000]   Normal zone: 1179648 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0xdff00000-0xffefffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages/cpu @ffff88021fc00000 s75328 r0 d22976 u524288
[    0.000000] pcpu-alloc: s75328 r0 d22976 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063902
[    0.000000] Kernel command line: root=PARTUUID=F61ADF02-9A53-485C-9BD4-3DD2F964C27C init=/sbin/minit rootflags=logbsize=262144 fbcon=rotate:3 radeon.dpm=1 drm_kms_helper.poll=0 quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Memory: 8164696K/8386744K available (5654K kernel code, 434K rwdata, 2068K rodata, 688K init, 600K bss, 222048K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 3210.683 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6423.92 BogoMIPS (lpj=10702276)
[    0.000003] pid_max: default: 32768 minimum: 301
[    0.000026] Mount-cache hash table entries: 256
[    0.000148] tseg: 0000000000
[    0.000152] CPU: Physical Processor ID: 0
[    0.000153] CPU: Processor Core ID: 3
[    0.000154] mce: CPU supports 6 MCE banks
[    0.000157] LVT offset 0 assigned for vector 0xf9
[    0.000160] process: using AMD E400 aware idle routine
[    0.000161] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
tlb_flushall_shift: 4
[    0.000217] Freeing SMP alternatives memory: 20K (ffffffff81b1a000 - ffffffff81b1f000)
[    0.000218] ACPI: Core revision 20130517
[    0.002779] ACPI: All ACPI Tables successfully acquired
[    0.003164] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036174] smpboot: CPU0: AMD Phenom(tm) II X4 955 Processor (fam: 10, model: 04, stepping: 02)
[    0.142539] Performance Events: AMD PMU driver.
[    0.142542] ... version:                0
[    0.142542] ... bit width:              48
[    0.142543] ... generic registers:      4
[    0.142543] ... value mask:             0000ffffffffffff
[    0.142544] ... max period:             00007fffffffffff
[    0.142544] ... fixed-purpose events:   0
[    0.142545] ... event mask:             000000000000000f
[    0.142621] MCE: In-kernel MCE decoding enabled.
[    0.155796] process: System has AMD C1E enabled
[    0.155806] process: Switch to broadcast mode on CPU1
[    0.169182] process: Switch to broadcast mode on CPU2
[    0.142659] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
[    0.182310] Brought up 4 CPUs
[    0.182311] smpboot: Total of 4 processors activated (25695.69 BogoMIPS)
[    0.182317] process: Switch to broadcast mode on CPU3
[    0.188006] process: Switch to broadcast mode on CPU0
[    0.188189] devtmpfs: initialized
[    0.188372] NET: Registered protocol family 16
[    0.188438] node 0 link 0: io port [1000, ffffff]
[    0.188439] TOM: 00000000e0000000 aka 3584M
[    0.188441] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.188442] node 0 link 0: mmio [a0000, bffff]
[    0.188444] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.188445] node 0 link 0: mmio [f0000000, fbcfffff]
[    0.188446] node 0 link 0: mmio [fbd00000, fbefffff]
[    0.188447] node 0 link 0: mmio [fbf00000, ffefffff]
[    0.188448] TOM2: 0000000220000000 aka 8704M
[    0.188449] bus: [bus 00-07] on node 0 link 0
[    0.188450] bus: 00 [io  0x0000-0xffff]
[    0.188450] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.188451] bus: 00 [mem 0xf0000000-0xffffffff]
[    0.188452] bus: 00 [mem 0x220000000-0xfcffffffff]
[    0.188487] ACPI: bus type PCI registered
[    0.188491] PCI: Using configuration type 1 for base access
[    0.188491] PCI: Using configuration type 1 for extended access
[    0.189301] bio: create slab <bio-0> at 0
[    0.189417] ACPI: Added _OSI(Module Device)
[    0.189418] ACPI: Added _OSI(Processor Device)
[    0.189419] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.189419] ACPI: Added _OSI(Processor Aggregator Device)
[    0.190052] ACPI: EC: Look up EC in DSDT
[    0.191049] ACPI: Executed 3 blocks of module-level executable AML code
[    0.272841] ACPI: Interpreter enabled
[    0.272846] ACPI: (supports S0 S5)
[    0.272846] ACPI: Using IOAPIC for interrupt routing
[    0.272867] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.276246] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.276355] PCI host bridge to bus 0000:00
[    0.276358] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.276359] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.276360] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.276362] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.276363] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.276364] pci_bus 0000:00: root bus resource [mem 0xdff00000-0xdfffffff]
[    0.276365] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    0.276374] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
[    0.276429] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
[    0.276475] pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
[    0.276501] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.276546] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.276561] pci 0000:00:11.0: reg 0x10: [io  0xc000-0xc007]
[    0.276570] pci 0000:00:11.0: reg 0x14: [io  0xb000-0xb003]
[    0.276578] pci 0000:00:11.0: reg 0x18: [io  0xa000-0xa007]
[    0.276586] pci 0000:00:11.0: reg 0x1c: [io  0x9000-0x9003]
[    0.276595] pci 0000:00:11.0: reg 0x20: [io  0x8000-0x800f]
[    0.276603] pci 0000:00:11.0: reg 0x24: [mem 0xfbcffc00-0xfbcfffff]
[    0.276676] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.276687] pci 0000:00:12.0: reg 0x10: [mem 0xfbcfd000-0xfbcfdfff]
[    0.276773] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    0.276785] pci 0000:00:12.1: reg 0x10: [mem 0xfbcfe000-0xfbcfefff]
[    0.276876] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.276893] pci 0000:00:12.2: reg 0x10: [mem 0xfbcff800-0xfbcff8ff]
[    0.276971] pci 0000:00:12.2: supports D1 D2
[    0.276972] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.277019] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.277031] pci 0000:00:13.0: reg 0x10: [mem 0xfbcfb000-0xfbcfbfff]
[    0.277119] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    0.277130] pci 0000:00:13.1: reg 0x10: [mem 0xfbcfc000-0xfbcfcfff]
[    0.277224] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.277241] pci 0000:00:13.2: reg 0x10: [mem 0xfbcff400-0xfbcff4ff]
[    0.277318] pci 0000:00:13.2: supports D1 D2
[    0.277319] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.277371] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.277484] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.277499] pci 0000:00:14.1: reg 0x10: [io  0x0000-0x0007]
[    0.277508] pci 0000:00:14.1: reg 0x14: [io  0x0000-0x0003]
[    0.277516] pci 0000:00:14.1: reg 0x18: [io  0x0000-0x0007]
[    0.277524] pci 0000:00:14.1: reg 0x1c: [io  0x0000-0x0003]
[    0.277532] pci 0000:00:14.1: reg 0x20: [io  0xff00-0xff0f]
[    0.277608] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.277627] pci 0000:00:14.2: reg 0x10: [mem 0xfbcf4000-0xfbcf7fff 64bit]
[    0.277689] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.277726] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.277823] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.277886] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.277898] pci 0000:00:14.5: reg 0x10: [mem 0xfbcfa000-0xfbcfafff]
[    0.277989] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.278031] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.278069] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.278107] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.278147] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.278217] pci 0000:01:05.0: [1002:9614] type 00 class 0x030000
[    0.278223] pci 0000:01:05.0: reg 0x10: [mem 0xf0000000-0xf7ffffff pref]
[    0.278227] pci 0000:01:05.0: reg 0x14: [io  0xd000-0xd0ff]
[    0.278230] pci 0000:01:05.0: reg 0x18: [mem 0xfbee0000-0xfbeeffff]
[    0.278237] pci 0000:01:05.0: reg 0x24: [mem 0xfbd00000-0xfbdfffff]
[    0.278251] pci 0000:01:05.0: supports D1 D2
[    0.278275] pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
[    0.278281] pci 0000:01:05.1: reg 0x10: [mem 0xfbefc000-0xfbefffff]
[    0.278305] pci 0000:01:05.1: supports D1 D2
[    0.278349] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.278351] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.278353] pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
[    0.278355] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.278409] pci 0000:02:00.0: [1969:1026] type 00 class 0x020000
[    0.278444] pci 0000:02:00.0: reg 0x10: [mem 0xfbfc0000-0xfbffffff 64bit]
[    0.278464] pci 0000:02:00.0: reg 0x18: [io  0xec00-0xec7f]
[    0.278613] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.278648] pci 0000:00:06.0: PCI bridge to [bus 02]
[    0.278650] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    0.278652] pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.278715] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.278722] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.278724] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.278725] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.278726] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.278727] pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
[    0.278728] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.278737] pci_bus 0000:00: on NUMA node 0
[    0.278739] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.278740] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.279178] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279217] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279246] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279275] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279305] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279334] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279363] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279392] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.279498] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.279502] ACPI: \_SB_.PCI0: notify handler is installed
[    0.279525] Found 1 acpi root devices
[    0.279582] SCSI subsystem initialized
[    0.279631] libata version 3.00 loaded.
[    0.279633] ACPI: bus type USB registered
[    0.279642] usbcore: registered new interface driver usbfs
[    0.279647] usbcore: registered new interface driver hub
[    0.279667] usbcore: registered new device driver usb
[    0.279685] EDAC MC: Ver: 3.0.0
[    0.279787] Advanced Linux Sound Architecture Driver Initialized.
[    0.279788] PCI: Using ACPI for IRQ routing
[    0.279789] PCI: pci_cache_line_size set to 64 bytes
[    0.279838] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.279839] e820: reserve RAM buffer [mem 0xdfe90000-0xdfffffff]
[    0.279914] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.279917] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.281965] Switched to clocksource hpet
[    0.281992] pnp: PnP ACPI init
[    0.281997] ACPI: bus type PNP registered
[    0.282080] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.282106] pnp 00:01: [dma 4]
[    0.282117] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.282135] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.282148] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.282164] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.282193] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.282256] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.282257] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.282258] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.282411] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.282412] system 00:07: [io  0x040b] has been reserved
[    0.282413] system 00:07: [io  0x04d6] has been reserved
[    0.282415] system 00:07: [io  0x0c00-0x0c01] has been reserved
[    0.282416] system 00:07: [io  0x0c14] has been reserved
[    0.282417] system 00:07: [io  0x0c50-0x0c51] has been reserved
[    0.282418] system 00:07: [io  0x0c52] has been reserved
[    0.282419] system 00:07: [io  0x0c6c] has been reserved
[    0.282421] system 00:07: [io  0x0c6f] has been reserved
[    0.282422] system 00:07: [io  0x0cd0-0x0cd1] has been reserved
[    0.282423] system 00:07: [io  0x0cd2-0x0cd3] has been reserved
[    0.282424] system 00:07: [io  0x0cd4-0x0cd5] has been reserved
[    0.282426] system 00:07: [io  0x0cd6-0x0cd7] has been reserved
[    0.282427] system 00:07: [io  0x0cd8-0x0cdf] has been reserved
[    0.282428] system 00:07: [io  0x0b00-0x0b3f] has been reserved
[    0.282429] system 00:07: [io  0x0800-0x089f] could not be reserved
[    0.282431] system 00:07: [io  0x0b00-0x0b0f] has been reserved
[    0.282432] system 00:07: [io  0x0b20-0x0b3f] has been reserved
[    0.282433] system 00:07: [io  0x0900-0x090f] has been reserved
[    0.282435] system 00:07: [io  0x0910-0x091f] has been reserved
[    0.282436] system 00:07: [io  0xfe00-0xfefe] has been reserved
[    0.282438] system 00:07: [mem 0xdff00000-0xdfffffff] has been reserved
[    0.282439] system 00:07: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.282440] system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.282442] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.282860] system 00:08: [io  0x0230-0x023f] has been reserved
[    0.282862] system 00:08: [io  0x0290-0x029f] has been reserved
[    0.282863] system 00:08: [io  0x0f40-0x0f4f] has been reserved
[    0.282864] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.282866] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.282901] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.282902] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.283037] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.283038] system 00:0a: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.283040] system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.283041] system 00:0a: [mem 0x00100000-0xdfefffff] could not be reserved
[    0.283042] system 00:0a: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.283044] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.283115] pnp: PnP ACPI: found 11 devices
[    0.283115] ACPI: bus type PNP unregistered
[    0.289521] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.289523] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.289525] pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
[    0.289527] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.289530] pci 0000:00:06.0: PCI bridge to [bus 02]
[    0.289531] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    0.289533] pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.289536] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.289626] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.289627] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.289628] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.289629] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.289630] pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
[    0.289631] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.289633] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.289634] pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
[    0.289635] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.289636] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.289637] pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.289638] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.289639] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.289641] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.289642] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.289643] pci_bus 0000:03: resource 8 [mem 0xdff00000-0xdfffffff]
[    0.289644] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.289664] NET: Registered protocol family 2
[    0.289745] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.289966] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.290173] TCP: Hash tables configured (established 65536 bind 65536)
[    0.290207] TCP: reno registered
[    0.290209] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.290247] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.290318] NET: Registered protocol family 1
[    0.290323] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.555536] pci 0000:01:05.0: Boot video device
[    0.555543] PCI: CLS 64 bytes, default 64
[    0.555554] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.555556] software IO TLB [mem 0xdbe90000-0xdfe90000] (64MB) mapped at [ffff8800dbe90000-ffff8800dfe8ffff]
[    0.555666] kvm: Nested Virtualization enabled
[    0.555667] kvm: Nested Paging enabled
[    0.555821] LVT offset 1 assigned for vector 0x400
[    0.555823] IBS: LVT offset 1 assigned
[    0.555842] perf: AMD IBS detected (0x0000001f)
[    0.556060] microcode: CPU0: patch_level=0x010000db
[    0.556066] microcode: CPU1: patch_level=0x010000db
[    0.556077] microcode: CPU2: patch_level=0x010000db
[    0.556087] microcode: CPU3: patch_level=0x010000db
[    0.556114] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.557221] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[    0.557469] 9p: Installing v9fs 9p2000 file system support
[    0.557481] msgmni has been set to 15946
[    0.557728] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.557729] io scheduler noop registered
[    0.557730] io scheduler deadline registered (default)
[    0.557773] ACPI: processor limited to max C-state 1
[    0.558662] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.558992] [drm] Initialized drm 1.1.0 20060810
[    0.558999] [drm] radeon kernel modesetting enabled.
[    0.559160] [drm] initializing kernel modesetting (RS780 0x1002:0x9614 0x1043:0x834D).
[    0.559166] [drm] register mmio base: 0xFBEE0000
[    0.559166] [drm] register mmio size: 65536
[    0.559695] ATOM BIOS: 113
[    0.559709] radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
[    0.559710] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    0.559713] [drm] Detected VRAM RAM=128M, BAR=128M
[    0.559714] [drm] RAM width 32bits DDR
[    0.559784] [TTM] Zone  kernel: Available graphics memory: 4082358 kiB
[    0.559785] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    0.559785] [TTM] Initializing pool allocator
[    0.559789] [TTM] Initializing DMA pool allocator
[    0.559806] [drm] radeon: 128M of VRAM memory ready
[    0.559807] [drm] radeon: 512M of GTT memory ready.
[    0.559814] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    0.560470] [drm] Loading RS780 Microcode
[    0.566021] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
[    0.566075] radeon 0000:01:05.0: WB enabled
[    0.566077] radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff880215c46c00
[    0.566078] radeon 0000:01:05.0: fence driver on ring 3 use gpu addr 0x00000000a0000c0c and cpu addr 0xffff880215c46c0c
[    0.566080] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.566080] [drm] Driver supports precise vblank timestamp query.
[    0.566097] [drm] radeon: irq initialized.
[    0.566331] radeon 0000:01:05.0: setting latency timer to 64
[    0.598447] [drm] ring test on 0 succeeded in 1 usecs
[    0.598503] [drm] ring test on 3 succeeded in 1 usecs
[    0.598789] [drm] ib test on ring 0 succeeded in 0 usecs
[    0.598801] [drm] ib test on ring 3 succeeded in 0 usecs
[    0.598884] [drm] Radeon Display Connectors
[    0.598885] [drm] Connector 0:
[    0.598886] [drm]   VGA-1
[    0.598887] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    0.598887] [drm]   Encoders:
[    0.598888] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    0.598888] [drm] Connector 1:
[    0.598889] [drm]   DVI-D-1
[    0.598889] [drm]   HPD3
[    0.598890] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    0.598890] [drm]   Encoders:
[    0.598891] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[    0.598904] == power state 0 ==
[    0.598905] 	ui class: none
[    0.598906] 	internal class: boot 
[    0.598907] 	caps: video 
[    0.598908] 	uvd    vclk: 0 dclk: 0
[    0.598909] 		power level 0    sclk: 50000 vddc_index: 2
[    0.598909] 		power level 1    sclk: 50000 vddc_index: 2
[    0.598909] 	status: c r b 
[    0.598911] == power state 1 ==
[    0.598911] 	ui class: performance
[    0.598911] 	internal class: none
[    0.598912] 	caps: video 
[    0.598913] 	uvd    vclk: 0 dclk: 0
[    0.598913] 		power level 0    sclk: 50000 vddc_index: 1
[    0.598914] 		power level 1    sclk: 70000 vddc_index: 2
[    0.598914] 	status: 
[    0.598914] == power state 2 ==
[    0.598915] 	ui class: none
[    0.598915] 	internal class: uvd 
[    0.598916] 	caps: video 
[    0.598916] 	uvd    vclk: 53300 dclk: 40000
[    0.598917] 		power level 0    sclk: 50000 vddc_index: 1
[    0.598917] 		power level 1    sclk: 50000 vddc_index: 1
[    0.598918] 	status: 
[    0.598971] switching from power state:
[    0.598971] 	ui class: none
[    0.598971] 	internal class: boot 
[    0.598972] 	caps: video 
[    0.598973] 	uvd    vclk: 0 dclk: 0
[    0.598973] 		power level 0    sclk: 50000 vddc_index: 2
[    0.598974] 		power level 1    sclk: 50000 vddc_index: 2
[    0.598974] 	status: c b 
[    0.598975] switching to power state:
[    0.598975] 	ui class: performance
[    0.598975] 	internal class: none
[    0.598976] 	caps: video 
[    0.598977] 	uvd    vclk: 0 dclk: 0
[    0.598977] 		power level 0    sclk: 50000 vddc_index: 1
[    0.598978] 		power level 1    sclk: 70000 vddc_index: 2
[    0.598978] 	status: r 
[    0.599096] [drm] radeon: dpm initialized
[    0.641400] [drm] fb mappable at 0xF0142000
[    0.641401] [drm] vram apper at 0xF0000000
[    0.641402] [drm] size 7299072
[    0.641402] [drm] fb depth is 24
[    0.641402] [drm]    pitch is 6912
[    0.641448] fbcon: radeondrmfb (fb0) is primary device
[    0.658594] Console: switching to colour frame buffer device 131x105
[    0.665515] radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
[    0.665516] radeon 0000:01:05.0: registered panic notifier
[    0.665564] [drm] Initialized radeon 2.34.0 20080528 for 0000:01:05.0 on minor 0
[    0.665702] loop: module loaded
[    0.665790] ahci 0000:00:11.0: version 3.0
[    0.665966] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.665968] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    0.666475] scsi0 : ahci
[    0.666532] scsi1 : ahci
[    0.666579] scsi2 : ahci
[    0.666625] scsi3 : ahci
[    0.666673] scsi4 : ahci
[    0.666719] scsi5 : ahci
[    0.666738] ata1: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd00 irq 22
[    0.666740] ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
[    0.666742] ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
[    0.666744] ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
[    0.666746] ata5: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff00 irq 22
[    0.666748] ata6: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff80 irq 22
[    0.667060] scsi6 : pata_atiixp
[    0.667106] scsi7 : pata_atiixp
[    0.667141] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    0.667142] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    0.667227] tun: Universal TUN/TAP device driver, 1.6
[    0.667228] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.712271] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.712272] ehci-pci: EHCI PCI platform driver
[    0.712363] ehci-pci 0000:00:12.2: EHCI Host Controller
[    0.712390] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.712395] QUIRK: Enable AMD PLL fix
[    0.712396] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.712398] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    0.712410] ehci-pci 0000:00:12.2: debug port 1
[    0.712440] ehci-pci 0000:00:12.2: irq 17, io mem 0xfbcff800
[    0.722179] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.722256] hub 1-0:1.0: USB hub found
[    0.722258] hub 1-0:1.0: 6 ports detected
[    0.722389] ehci-pci 0000:00:13.2: EHCI Host Controller
[    0.722417] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.722419] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.722420] ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    0.722432] ehci-pci 0000:00:13.2: debug port 1
[    0.722457] ehci-pci 0000:00:13.2: irq 19, io mem 0xfbcff400
[    0.732190] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.732249] hub 2-0:1.0: USB hub found
[    0.732250] hub 2-0:1.0: 6 ports detected
[    0.732313] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.732313] ohci-pci: OHCI PCI platform driver
[    0.732378] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    0.732407] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.732423] ohci-pci 0000:00:12.0: irq 16, io mem 0xfbcfd000
[    0.789613] hub 3-0:1.0: USB hub found
[    0.789618] hub 3-0:1.0: 3 ports detected
[    0.789722] ohci-pci 0000:00:12.1: OHCI PCI host controller
[    0.789751] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.789761] ohci-pci 0000:00:12.1: irq 16, io mem 0xfbcfe000
[    0.826093] ata7.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
[    0.832656] ata7.00: configured for UDMA/66
[    0.846358] hub 4-0:1.0: USB hub found
[    0.846364] hub 4-0:1.0: 3 ports detected
[    0.846483] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    0.846514] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.846525] ohci-pci 0000:00:13.0: irq 18, io mem 0xfbcfb000
[    0.902980] hub 5-0:1.0: USB hub found
[    0.902984] hub 5-0:1.0: 3 ports detected
[    0.903087] ohci-pci 0000:00:13.1: OHCI PCI host controller
[    0.903116] ohci-pci 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.903127] ohci-pci 0000:00:13.1: irq 18, io mem 0xfbcfc000
[    0.959690] hub 6-0:1.0: USB hub found
[    0.959694] hub 6-0:1.0: 3 ports detected
[    0.959798] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    0.959827] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.959837] ohci-pci 0000:00:14.5: irq 18, io mem 0xfbcfa000
[    0.978929] ata6: SATA link down (SStatus 0 SControl 300)
[    0.978971] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.979843] ata2.00: ATA-8: ST1500DL003-9VT16L, CC32, max UDMA/133
[    0.979846] ata2.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.980890] ata2.00: configured for UDMA/133
[    0.985598] ata4: SATA link down (SStatus 0 SControl 300)
[    0.985628] ata1: SATA link down (SStatus 0 SControl 300)
[    0.985659] ata5: SATA link down (SStatus 0 SControl 300)
[    0.985699] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.985747] scsi 1:0:0:0: Direct-Access     ATA      ST1500DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    0.985840] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    0.985888] ata3.00: ATA-8: OCZ VERTEX-TURBO, 1.7, max UDMA/133
[    0.985890] ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    0.985905] sd 1:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    0.986022] sd 1:0:0:0: [sda] Write Protect is off
[    0.986024] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.986069] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.987918] ata3.00: configured for UDMA/133
[    0.988012] scsi 2:0:0:0: Direct-Access     ATA      OCZ VERTEX-TURBO 1.7  PQ: 0 ANSI: 5
[    0.988091] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    0.988108] sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    0.988269] sd 2:0:0:0: [sdb] Write Protect is off
[    0.988274] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.988319] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.989292] scsi 6:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
[    0.990975]  sdb: sdb1 sdb2
[    0.991322] sd 2:0:0:0: [sdb] Attached SCSI disk
[    0.991617] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.991619] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.991671] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    0.991739] sr 6:0:0:0: Attached scsi generic sg2 type 5
[    1.004419]  sda: unknown partition table
[    1.004657] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.016348] hub 7-0:1.0: USB hub found
[    1.016352] hub 7-0:1.0: 2 ports detected
[    1.016404] usbcore: registered new interface driver usblp
[    1.016421] usbcore: registered new interface driver usb-storage
[    1.016443] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.016966] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.016970] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.017031] mousedev: PS/2 mouse device common for all mice
[    1.017063] rtc_cmos 00:02: RTC can wake from S4
[    1.017156] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.017178] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.017183] i2c /dev entries driver
[    1.017413] AMD64 EDAC driver v3.4.0
[    1.017422] EDAC amd64: DRAM ECC enabled.
[    1.017443] EDAC amd64: F10h detected (node 0).
[    1.017453] EDAC MC: DCT0 chip selects:
[    1.017454] EDAC amd64: MC: 0:  1024MB 1:  1024MB
[    1.017455] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[    1.017456] EDAC amd64: MC: 4:     0MB 5:     0MB
[    1.017456] EDAC amd64: MC: 6:     0MB 7:     0MB
[    1.017457] EDAC MC: DCT1 chip selects:
[    1.017458] EDAC amd64: MC: 0:  1024MB 1:  1024MB
[    1.017458] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[    1.017459] EDAC amd64: MC: 4:     0MB 5:     0MB
[    1.017459] EDAC amd64: MC: 6:     0MB 7:     0MB
[    1.017460] EDAC amd64: using x4 syndromes.
[    1.017461] EDAC amd64: MCT channel count: 2
[    1.017474] EDAC amd64: CS0: Unbuffered DDR3 RAM
[    1.017475] EDAC amd64: CS1: Unbuffered DDR3 RAM
[    1.017475] EDAC amd64: CS2: Unbuffered DDR3 RAM
[    1.017476] EDAC amd64: CS3: Unbuffered DDR3 RAM
[    1.017565] EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
[    1.017576] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[    1.017579] cpuidle: using governor ladder
[    1.017579] cpuidle: using governor menu
[    1.017586] hidraw: raw HID events driver (C) Jiri Kosina
[    1.017604] usbcore: registered new interface driver usbhid
[    1.017605] usbhid: USB HID core driver
[    1.033112] snd_hda_intel 0000:01:05.1: setting latency timer to 64
[    1.036076] usbcore: registered new interface driver snd-usb-audio
[    1.036087] Netfilter messages via NETLINK v0.30.
[    1.036103] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.036170] ctnetlink v0.93: registering with nfnetlink.
[    1.036455] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.036505] TCP: cubic registered
[    1.036507] NET: Registered protocol family 17
[    1.036517] 9pnet: Installing 9P2000 support
[    1.036715] registered taskstats version 1
[    1.037059] rtc_cmos 00:02: setting system clock to 2013-07-19 17:51:55 UTC (1374256315)
[    1.037092] acpi-cpufreq: overriding BIOS provided _PSD data
[    1.037531] ALSA device list:
[    1.037532]   #0: HDA ATI SB at 0xfbcf4000 irq 16
[    1.037532]   #1: HDA ATI HDMI at 0xfbefc000 irq 19
[    1.095857] XFS (sdb2): Mounting Filesystem
[    1.138144] XFS (sdb2): Ending clean mount
[    1.138172] VFS: Mounted root (xfs filesystem) readonly on device 8:18.
[    1.142877] devtmpfs: mounted
[    1.144968] Freeing unused kernel memory: 688K (ffffffff81a6e000 - ffffffff81b1a000)
[    1.144971] Write protecting the kernel read-only data: 10240k
[    1.148692] Freeing unused kernel memory: 484K (ffff880001587000 - ffff880001600000)
[    1.161654] Freeing unused kernel memory: 2028K (ffff880001805000 - ffff880001a00000)
[    1.559092] tsc: Refined TSC clocksource calibration: 3210.827 MHz
[    1.621229] XFS (sda): Mounting Filesystem
[    1.722500] usb 4-2: new full-speed USB device number 2 using ohci-pci
[    1.908899] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
[    1.913493] input: Logitech Unifying Device. Wireless PID:4026 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.2/0003:046D:C52B.0003/input/input0
[    1.913717] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4026] on usb-0000:00:12.1-2:1
[    2.039242] usb 3-1: new low-speed USB device number 2 using ohci-pci
[    2.063203] XFS (sda): Ending clean mount
[    2.200891] input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input1
[    2.201061] hid-generic 0003:046A:0011.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
[    2.373959] udevd[97]: starting eudev version 1.0
[    2.559376] Switched to clocksource tsc
[    2.790907] ATL1E 0000:02:00.0 eth0: NIC Link is Up <1000 Mbps Full Duplex>
[    4.379267] Adding 3071996k swap on /var/cache/swapfile.img.  Priority:-1 extents:2 across:8430928k 
-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
