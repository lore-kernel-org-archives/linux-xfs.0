Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 13:09:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HK9IYl026863
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 13:09:18 -0700
Received: from smtp1.betherenow.co.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 1D119182CBC
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 13:10:02 -0700 (PDT)
Received: from smtp1.betherenow.co.uk (smtp1.betherenow.co.uk [87.194.0.68]) by cuda.sgi.com with SMTP id MGbhW9OCohH8suBa for <xfs@oss.sgi.com>; Sat, 17 May 2008 13:10:02 -0700 (PDT)
From: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Date: Sat, 17 May 2008 21:09:58 +0100
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805171922.56272.alistair@devzero.co.uk> <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805172109.59244.alistair@devzero.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org

On Saturday 17 May 2008 19:37:35 Linus Torvalds wrote:
> On Sat, 17 May 2008, Alistair John Strachan wrote:
> > My guess is that when the kernel runs out of MemFree and starts
> > reclaiming the cache, something is deadlocking somewhere. Just doing a:
> >
> > cat /dev/zero >/path/to/file
>
> Do this on the console (and having a serial console or working netconsole
> is a wonderful thing to log it, because otherwise it will generally just
> scroll off the screen), and trigger SysRQ-w. That dumps all blocked tasks
> to the screen.

I actually had the opposite problem, too little was showing. I guess this is
because the log level the "SysRq : Show Blocked State" bit goes out on is
higher than the level of the actual result, so it was being trapped by sysklogd.

(I actually ended up getting netconsole working too, but it confusingly didn't
dump any messages that sysklogd trapped either, so I'd get the "SysRq :
Show Blocked State" message but nothing else. This isn't very user friendly.)

Regardless, I managed to get a log. Thanks for the help Linus..

Both XFS and md are showing up:

[    0.000000] Linux version 2.6.26-rc2-damocles (root@damocles) (gcc version 4.2.4 20080512 (prerelease) (Debian 4.2.3-6)) #2 SMP PREEMPT Sat May 17 20:42:49 BST 2008
[    0.000000] Command line: root=/dev/md1 ro mem=2000M iommu=off vga=791 quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 512000) 1 entries of 256 used
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.5 present.
[    0.000000] ACPI: RSDP 000F7860, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT CFEE3000, 0034 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP CFEE3080, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT CFEE3100, 4D0B (r1 INTELR AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS CFEE0000, 0040
[    0.000000] ACPI: MCFG CFEE7F00, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC CFEE7E40, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: SSDT CFEE85A0, 0380 (r1  PmRef    CpuPm     3000 INTL 20041203)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 512000) 1 entries of 256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-a2bc3f] TEXT DATA BSS
[    0.000000]   early res: 3 [9e000-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-cfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff810001200000-ffff810002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   512000
[    0.000000] On node 0 totalpages: 511902
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2199 pages reserved
[    0.000000]   DMA zone: 1743 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6944 pages used for memmap
[    0.000000]   DMA32 zone: 500960 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d0000000 (gap: cff00000:10100000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 34628 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 502703
[4294014.506571] Kernel command line: root=/dev/md1 ro mem=2000M iommu=off vga=791 quiet
[4294014.506571] Initializing CPU#0
[4294014.506571] Preemptible RCU implementation.
[4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes)
[4294014.506571] TSC calibrated against PM_TIMER
[4294014.506571] time.c: Detected 2996.999 MHz processor.
[4294014.506571] Console: colour dummy device 80x25
[4294014.506571] console [tty0] enabled
[4294014.506571] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[4294014.506571] ... MAX_LOCKDEP_SUBCLASSES:    8
[4294014.506571] ... MAX_LOCK_DEPTH:          48
[4294014.506571] ... MAX_LOCKDEP_KEYS:        2048
[4294014.506571] ... CLASSHASH_SIZE:           1024
[4294014.506571] ... MAX_LOCKDEP_ENTRIES:     8192
[4294014.506571] ... MAX_LOCKDEP_CHAINS:      16384
[4294014.506571] ... CHAINHASH_SIZE:          8192
[4294014.506571]  memory used by lock dependency info: 1648 kB
[4294014.506571]  per task-struct memory footprint: 2688 bytes
[4294014.506571] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[4294014.506571] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[4294014.506571] Checking aperture...
[4294014.506571] Memory: 2006672k/2048000k available (2559k kernel code, 40440k reserved, 1332k data, 232k init)
[4294014.506571] CPA: page pool initialized 1 of 1 pages preallocated
[4294014.506571] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[4294014.566565] Calibrating delay using timer specific routine.. 5997.96 BogoMIPS (lpj=2998980)
[4294014.566620] Mount-cache hash table entries: 256
[4294014.567148] CPU: L1 I cache: 32K, L1 D cache: 32K
[4294014.567150] CPU: L2 cache: 1024K
[4294014.567152] CPU: Physical Processor ID: 0
[4294014.567154] CPU: Processor Core ID: 0
[4294014.567158] CPU0: Thermal monitoring enabled (TM2)
[4294014.567160] using mwait in idle threads.
[4294014.567186] ACPI: Core revision 20080321
[4294014.568670] ACPI: Override [DSDT-AWRDACPI], this is unsafe: tainting kernel
[4294014.568675] ACPI: Table DSDT replaced by host OS
[4294014.568678] ACPI: DSDT 00000000, 477D (r1 INTELR AWRDACPI     1000 INTL 20061109)
[4294014.568681] ACPI: DSDT override uses original SSDTs unless "acpi_no_auto_ssdt"<6>CPU0: Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz stepping 0d
[4294014.582559] Using local APIC timer interrupts.
[4294014.583559] APIC timer calibration result 20812478
[4294014.583559] Detected 20.812 MHz APIC timer.
[4294014.583559] lockdep: fixing up alternatives.
[4294014.583559] Booting processor 1/1 ip 6000
[4294014.583559] Initializing CPU#1
[4294014.583559] Calibrating delay using timer specific routine.. 5993.90 BogoMIPS (lpj=2996954)
[4294014.583559] CPU: L1 I cache: 32K, L1 D cache: 32K
[4294014.583559] CPU: L2 cache: 1024K
[4294014.583559] CPU: Physical Processor ID: 0
[4294014.583559] CPU: Processor Core ID: 1
[4294014.583559] CPU1: Thermal monitoring enabled (TM2)
[4294014.583559] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[4294014.654548] CPU1: Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz stepping 0d
[4294014.654548] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[4294014.655562] Brought up 2 CPUs
[4294014.655564] Total of 2 processors activated (11991.86 BogoMIPS).
[4294014.655601] CPU0 attaching sched-domain:
[4294014.655603]  domain 0: span 0-1
[4294014.655605]   groups: 0 1
[4294014.655609] CPU1 attaching sched-domain:
[4294014.655610]  domain 0: span 0-1
[4294014.655612]   groups: 1 0
[4294014.656548] net_namespace: 464 bytes
[4294014.656548] xor: automatically using best checksumming function: generic_sse
[4294014.661160]    generic_sse: 10868.000 MB/sec
[4294014.661161] xor: using function: generic_sse (10868.000 MB/sec)
[4294014.661186] NET: Registered protocol family 16
[4294014.661341] No dock devices found.
[4294014.661426] ACPI: bus type pci registered
[4294014.661516] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.661518] PCI: MCFG area at e0000000 reserved in E820
[4294014.669475] PCI: Using MMCONFIG at e0000000 - efffffff
[4294014.669479] PCI: Using configuration type 1 for base access
[4294014.671454] ACPI: EC: Look up EC in DSDT
[4294014.676456] ACPI: Interpreter enabled
[4294014.676459] ACPI: (supports S0 S3 S5)
[4294014.676470] ACPI: Using IOAPIC for interrupt routing
[4294014.680947] ACPI: PCI Root Bridge [PCI0] (0000:00)
[4294014.681709] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[4294014.681714] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[4294014.681717] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[4294014.682768] PCI: Transparent bridge - 0000:00:1e.0
[4294014.682795] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[4294014.682991] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[4294014.683073] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[4294014.683154] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[4294014.696710] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *5 7 9 10 11 12)
[4294014.696797] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 9 *10 11 12)
[4294014.696882] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 *5 7 9 10 11 12)
[4294014.696967] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 9 10 *11 12)
[4294014.697051] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 9 10 *11 12)
[4294014.697136] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 9 *10 11 12)
[4294014.697220] ACPI: PCI Interrupt Link [LNK0] (IRQs 4 5 *7 9 10 11 12)
[4294014.697304] ACPI: PCI Interrupt Link [LNK1] (IRQs *4 5 7 9 10 11 12)
[4294014.697472] Linux Plug and Play Support v0.97 (c) Adam Belay
[4294014.697501] pnp: PnP ACPI init
[4294014.697509] ACPI: bus type pnp registered
[4294014.699665] pnp: PnP ACPI: found 12 devices
[4294014.699667] ACPI: ACPI bus type pnp unregistered
[4294014.699824] SCSI subsystem initialized
[4294014.699886] libata version 3.00 loaded.
[4294014.700017] PCI: Using ACPI for IRQ routing
[4294014.708627] PCI-GART: No AMD northbridge found.
[4294014.708704] hpet clockevent registered
[4294014.708709] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[4294014.708713] hpet0: 4 64-bit timers, 14318180 Hz
[4294014.721660] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[4294014.721663] system 00:01: ioport range 0x880-0x88f has been reserved
[4294014.721680] system 00:07: ioport range 0x400-0x4bf could not be reserved
[4294014.721693] system 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[4294014.721703] system 00:0b: iomem range 0xf0000-0xfffff could not be reserved
[4294014.721706] system 00:0b: iomem range 0xcff00000-0xcfffffff has been reserved
[4294014.721710] system 00:0b: iomem range 0xcfee0000-0xcfefffff could not be reserved
[4294014.721713] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[4294014.721717] system 00:0b: iomem range 0x100000-0xcfedffff could not be reserved
[4294014.721720] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
[4294014.721724] system 00:0b: iomem range 0xfed14000-0xfed1dfff could not be reserved
[4294014.721727] system 00:0b: iomem range 0xfed20000-0xfed9ffff could not be reserved
[4294014.721731] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[4294014.721737] system 00:0b: iomem range 0xffb00000-0xffb7ffff could not be reserved
[4294014.721739] system 00:0b: iomem range 0xfff00000-0xffffffff could not be reserved
[4294014.721741] system 00:0b: iomem range 0xe0000-0xeffff has been reserved
[4294014.722287] PCI: Bridge: 0000:00:01.0
[4294014.722290]   IO window: d000-dfff
[4294014.722293]   MEM window: 0xf8000000-0xfbffffff
[4294014.722295]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[4294014.722299] PCI: Bridge: 0000:00:1c.0
[4294014.722301]   IO window: c000-cfff
[4294014.722305]   MEM window: 0xfde00000-0xfdefffff
[4294014.722308]   PREFETCH window: 0x00000000fdb00000-0x00000000fdbfffff
[4294014.722314] PCI: Bridge: 0000:00:1c.4
[4294014.722316]   IO window: b000-bfff
[4294014.722320]   MEM window: 0xfda00000-0xfdafffff
[4294014.722323]   PREFETCH window: 0x00000000fd900000-0x00000000fd9fffff
[4294014.722329] PCI: Bridge: 0000:00:1e.0
[4294014.722332]   IO window: a000-afff
[4294014.722335]   MEM window: 0xfdd00000-0xfddfffff
[4294014.722339]   PREFETCH window: 0x00000000fdc00000-0x00000000fdcfffff
[4294014.722353] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[4294014.722358] PCI: Setting latency timer of device 0000:00:01.0 to 64
[4294014.722373] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[4294014.722378] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[4294014.722392] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
[4294014.722396] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[4294014.722405] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[4294014.722415] NET: Registered protocol family 2
[4294014.754957] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[4294014.755236] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[4294014.756695] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[4294014.758006] TCP: Hash tables configured (established 262144 bind 65536)
[4294014.758009] TCP reno registered
[4294014.770040] NET: Registered protocol family 1
[4294014.770040] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[4294014.772444] fuse init (API version 7.9)
[4294014.772603] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[4294014.773043] msgmni has been set to 3920 for ipc namespace ffffffff805ac120
[4294014.773071] async_tx: api initialized (sync-only)
[4294014.773166] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[4294014.773169] io scheduler noop registered
[4294014.773226] io scheduler cfq registered (default)
[4294014.773361] pci 0000:01:00.0: Boot video device
[4294014.773475] PCI: Setting latency timer of device 0000:00:01.0 to 64
[4294014.773502] assign_interrupt_mode Found MSI capability
[4294014.773526] Allocate Port Service[0000:00:01.0:pcie00]
[4294014.773571] Allocate Port Service[0000:00:01.0:pcie03]
[4294014.773647] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[4294014.773675] assign_interrupt_mode Found MSI capability
[4294014.773703] Allocate Port Service[0000:00:1c.0:pcie00]
[4294014.773745] Allocate Port Service[0000:00:1c.0:pcie02]
[4294014.773789] Allocate Port Service[0000:00:1c.0:pcie03]
[4294014.773868] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[4294014.773895] assign_interrupt_mode Found MSI capability
[4294014.773924] Allocate Port Service[0000:00:1c.4:pcie00]
[4294014.773965] Allocate Port Service[0000:00:1c.4:pcie02]
[4294014.774006] Allocate Port Service[0000:00:1c.4:pcie03]
[4294014.774246] vesafb: framebuffer at 0xf9000000, mapped to 0xffffc20010100000, using 3072k, total 14336k
[4294014.774248] vesafb: mode is 1024x768x16, linelength=2048, pages=1
[4294014.774250] vesafb: scrolling: redraw
[4294014.774251] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[4294014.784804] Console: switching to colour frame buffer device 128x48
[4294014.794263] fb0: VESA VGA frame buffer device
[4294014.794449] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[4294014.794452] ACPI: Power Button (FF) [PWRF]
[4294014.794527] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[4294014.794530] ACPI: Power Button (CM) [PWRB]
[4294014.794974] ACPI: SSDT CFEE7F80, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
[4294014.795070] ACPI: ACPI0007:00 is registered as cooling_device0
[4294014.795260] ACPI: SSDT CFEE8440, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
[4294014.795375] ACPI: ACPI0007:01 is registered as cooling_device1
[4294014.798936] ACPI: LNXTHERM:01 is registered as thermal_zone0
[4294014.799028] ACPI: Thermal Zone [THRM] (20 C)
[4294014.820282] Real Time Clock Driver v1.12ac
[4294014.820420] Linux agpgart interface v0.103
[4294014.821159] loop: module loaded
[4294014.821159] tun: Universal TUN/TAP device driver, 1.6
[4294014.821159] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[4294014.821159] Linux video capture interface: v2.00
[4294014.821159] Driver 'sd' needs updating - please use bus_type methods
[4294014.821159] Driver 'sr' needs updating - please use bus_type methods
[4294014.821209] ahci 0000:00:1f.2: version 3.0
[4294014.821232] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
[4294015.210601] Switched to high resolution mode on CPU 1
[4294015.212464] Switched to high resolution mode on CPU 0
[4294015.821085] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[4294015.821089] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part 
[4294015.821094] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[4294015.821723] scsi0 : ahci
[4294015.821723] scsi1 : ahci
[4294015.821723] scsi2 : ahci
[4294015.821723] scsi3 : ahci
[4294015.821723] scsi4 : ahci
[4294015.821723] scsi5 : ahci
[4294015.821723] ata1: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd100 irq 316
[4294015.821723] ata2: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd180 irq 316
[4294015.821723] ata3: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd200 irq 316
[4294015.821723] ata4: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd280 irq 316
[4294015.821723] ata5: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd300 irq 316
[4294015.821723] ata6: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd380 irq 316
[4294016.125735] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[4294016.126578] ata1.00: ATA-7: Hitachi HDT725050VLA360, V56OA7EA, max UDMA/133
[4294016.126581] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[4294016.126705] ata1.00: configured for UDMA/133
[4294016.431877] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[4294016.432969] ata2.00: ATA-7: Hitachi HDT725050VLA360, V56OA7EA, max UDMA/133
[4294016.432969] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[4294016.432969] ata2.00: configured for UDMA/133
[4294016.737825] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[4294016.738649] ata3.00: ATA-7: Hitachi HDT725050VLA360, V56OA7EA, max UDMA/133
[4294016.738652] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[4294016.738649] ata3.00: configured for UDMA/133
[4294017.043943] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[4294017.300918] ata4.00: ATA-7: Hitachi HDT725050VLA360, V56OA7EA, max UDMA/133
[4294017.300918] ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[4294017.300918] ata4.00: configured for UDMA/133
[4294017.605833] ata5: SATA link down (SStatus 0 SControl 300)
[4294017.910791] ata6: SATA link down (SStatus 0 SControl 300)
[4294017.921884] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDT72505 V56O PQ: 0 ANSI: 5
[4294017.922788] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[4294017.922801] sd 0:0:0:0: [sda] Write Protect is off
[4294017.922803] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.922825] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.922884] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[4294017.922896] sd 0:0:0:0: [sda] Write Protect is off
[4294017.922898] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294017.922919] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.922922]  sda: sda1 sda2 sda3 sda4
[4294017.931684] sd 0:0:0:0: [sda] Attached SCSI disk
[4294017.931706] sd 0:0:0:0: Attached scsi generic sg0 type 0
[4294017.931706] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDT72505 V56O PQ: 0 ANSI: 5
[4294017.931706] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[4294017.931706] sd 1:0:0:0: [sdb] Write Protect is off
[4294017.931706] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[4294017.931706] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.931706] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[4294017.931706] sd 1:0:0:0: [sdb] Write Protect is off
[4294017.931706] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[4294017.931706] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.931706]  sdb: sdb1 sdb2 sdb3
[4294017.942037] sd 1:0:0:0: [sdb] Attached SCSI disk
[4294017.942037] sd 1:0:0:0: Attached scsi generic sg1 type 0
[4294017.942037] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDT72505 V56O PQ: 0 ANSI: 5
[4294017.943027] sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
[4294017.943027] sd 2:0:0:0: [sdc] Write Protect is off
[4294017.943027] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[4294017.943027] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.943027] sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
[4294017.943027] sd 2:0:0:0: [sdc] Write Protect is off
[4294017.943027] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[4294017.943027] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.943027]  sdc: sdc1 sdc2 sdc3 sdc4
[4294017.957567] sd 2:0:0:0: [sdc] Attached SCSI disk
[4294017.957567] sd 2:0:0:0: Attached scsi generic sg2 type 0
[4294017.957567] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDT72505 V56O PQ: 0 ANSI: 5
[4294017.957568] sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[4294017.957568] sd 3:0:0:0: [sdd] Write Protect is off
[4294017.957568] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[4294017.957568] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.957568] sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[4294017.957568] sd 3:0:0:0: [sdd] Write Protect is off
[4294017.957568] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[4294017.957568] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294017.957568]  sdd: sdd1 sdd2 sdd3 sdd4
[4294017.964037] sd 3:0:0:0: [sdd] Attached SCSI disk
[4294017.964037] sd 3:0:0:0: Attached scsi generic sg3 type 0
[4294017.964037] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[4294018.964818] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[4294018.964822] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[4294018.964829] PCI: Setting latency timer of device 0000:03:00.0 to 64
[4294018.965781] scsi6 : ahci
[4294018.966027] scsi7 : ahci
[4294018.966027] ata7: SATA max UDMA/133 abar m8192@0xfdafe000 port 0xfdafe100 irq 16
[4294018.966027] ata8: SATA max UDMA/133 abar m8192@0xfdafe000 port 0xfdafe180 irq 16
[4294019.270061] ata7: SATA link down (SStatus 0 SControl 300)
[4294019.586697] ata8: SATA link down (SStatus 0 SControl 300)
[4294019.586697] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[4294019.586697] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[4294019.586697] serio: i8042 KBD port at 0x60,0x64 irq 1
[4294019.586697] mice: PS/2 mouse device common for all mice
[4294019.625677] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[4294019.649479] md: raid0 personality registered for level 0
[4294019.649479] md: raid1 personality registered for level 1
[4294019.666708] raid6: int64x1   2808 MB/s
[4294019.683708] raid6: int64x2   3535 MB/s
[4294019.700708] raid6: int64x4   2957 MB/s
[4294019.717708] raid6: int64x8   2660 MB/s
[4294019.734708] raid6: sse2x1    5101 MB/s
[4294019.751709] raid6: sse2x2    5578 MB/s
[4294019.768708] raid6: sse2x4    9027 MB/s
[4294019.768708] raid6: using algorithm sse2x4 (9027 MB/s)
[4294019.768708] md: raid6 personality registered for level 6
[4294019.768708] md: raid5 personality registered for level 5
[4294019.768708] md: raid4 personality registered for level 4
[4294019.768708] cpuidle: using governor ladder
[4294019.768708] cpuidle: using governor menu
[4294019.768860] TCP cubic registered
[4294019.768862] NET: Registered protocol family 17
[4294019.769709] md: Autodetecting RAID arrays.
[4294019.792424] md: Scanned 3 and added 3 devices.
[4294019.792424] md: autorun ...
[4294019.792424] md: considering sdd2 ...
[4294019.792424] md:  adding sdd2 ...
[4294019.792424] md:  adding sdc2 ...
[4294019.792424] md:  adding sda2 ...
[4294019.792424] md: created md1
[4294019.792424] md: bind<sda2>
[4294019.792424] md: bind<sdc2>
[4294019.792424] md: bind<sdd2>
[4294019.792424] md: running: <sdd2><sdc2><sda2>
[4294019.792424] raid5: device sdd2 operational as raid disk 2
[4294019.792424] raid5: device sdc2 operational as raid disk 1
[4294019.792424] raid5: device sda2 operational as raid disk 0
[4294019.792737] raid5: allocated 3236kB for md1
[4294019.792739] raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
[4294019.792741] RAID5 conf printout:
[4294019.792742]  --- rd:3 wd:3
[4294019.792744]  disk 0, o:1, dev:sda2
[4294019.792745]  disk 1, o:1, dev:sdc2
[4294019.792747]  disk 2, o:1, dev:sdd2
[4294019.793290] md: ... autorun DONE.
[4294019.800684] Filesystem "md1": Disabling barriers, not supported by the underlying device
[4294019.800684] XFS: correcting sb_features alignment problem
[4294019.800722] XFS mounting filesystem md1
[4294019.922250] Ending clean XFS mount for filesystem: md1
[4294019.922250] VFS: Mounted root (xfs filesystem) readonly.
[4294019.922250] Freeing unused kernel memory: 232k freed
[4294021.222724] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[4294021.222724] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 23 (level, low) -> IRQ 23
[4294021.222724] eth0: RTL8169sc/8110sc at 0xffffc2000001a000, 00:50:8d:b3:5f:de, XID 18000000 IRQ 23
[4294021.223674] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[4294021.223674] ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[4294021.223674] eth1: RTL8169sc/8110sc at 0xffffc20000068000, 00:50:8d:b3:5f:df, XID 18000000 IRQ 22
[4294021.241674] usbcore: registered new interface driver usbfs
[4294021.241674] usbcore: registered new interface driver hub
[4294021.242673] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 18 (level, low) -> IRQ 18
[4294021.246675] usbcore: registered new device driver usb
[4294021.277673] ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 21 (level, low) -> IRQ 21
[4294021.289674] USB Universal Host Controller Interface driver v3.0
[4294021.289674] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[4294021.289674] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[4294021.289674] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[4294021.289791] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[4294021.289815] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
[4294021.290674] usb usb1: configuration #1 chosen from 1 choice
[4294021.290674] hub 1-0:1.0: USB hub found
[4294021.290674] hub 1-0:1.0: 2 ports detected
[4294021.323673] udev: renamed network interface eth0 to lan0
[4294021.328674] udev: renamed network interface eth1 to lan1
[4294021.337686] firewire_ohci: Added fw-ohci device 0000:04:02.0, OHCI version 1.10
[4294021.337732] ACPI: PCI Interrupt 0000:04:05.2[B] -> GSI 21 (level, low) -> IRQ 21
[4294021.337738] PCI: Setting latency timer of device 0000:04:05.2 to 64
[4294021.391826] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[4294021.391841] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[4294021.391844] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[4294021.391871] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
[4294021.395779] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[4294021.395789] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
[4294021.397709] firewire_ohci: Added fw-ohci device 0000:04:05.2, OHCI version 1.10
[4294021.405694] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[4294021.405818] usb usb2: configuration #1 chosen from 1 choice
[4294021.405839] hub 2-0:1.0: USB hub found
[4294021.405845] hub 2-0:1.0: 6 ports detected
[4294021.506768] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[4294021.506778] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[4294021.506781] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[4294021.506807] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[4294021.506828] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00
[4294021.507673] usb usb3: configuration #1 chosen from 1 choice
[4294021.507673] hub 3-0:1.0: USB hub found
[4294021.507673] hub 3-0:1.0: 2 ports detected
[4294021.607883] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[4294021.607899] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[4294021.607902] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[4294021.607930] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[4294021.611815] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[4294021.611826] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
[4294021.715839] usb 2-4: new high speed USB device using ehci_hcd and address 2
[4294021.722695] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[4294021.722819] usb usb4: configuration #1 chosen from 1 choice
[4294021.722840] hub 4-0:1.0: USB hub found
[4294021.722846] hub 4-0:1.0: 6 ports detected
[4294021.822789] ACPI: PCI Interrupt 0000:00:1a.2[D] -> GSI 19 (level, low) -> IRQ 19
[4294021.822798] PCI: Setting latency timer of device 0000:00:1a.2 to 64
[4294021.822801] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[4294021.822827] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[4294021.822854] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fd00
[4294021.822947] usb usb5: configuration #1 chosen from 1 choice
[4294021.822969] hub 5-0:1.0: USB hub found
[4294021.822974] hub 5-0:1.0: 2 ports detected
[4294021.836775] firewire_core: created device fw0: GUID 00508d00009b4941, S400
[4294021.837718] usb 2-4: configuration #1 chosen from 1 choice
[4294021.837897] hub 2-4:1.0: USB hub found
[4294021.838215] hub 2-4:1.0: 4 ports detected
[4294021.896937] firewire_core: created device fw1: GUID 00023c0091023fd7, S400
[4294021.924678] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[4294021.924678] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[4294021.924678] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[4294021.924678] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[4294021.924678] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
[4294021.924798] usb usb6: configuration #1 chosen from 1 choice
[4294021.924822] hub 6-0:1.0: USB hub found
[4294021.924829] hub 6-0:1.0: 2 ports detected
[4294022.026678] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[4294022.026678] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[4294022.026678] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[4294022.026678] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[4294022.026678] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
[4294022.026678] usb usb7: configuration #1 chosen from 1 choice
[4294022.026678] hub 7-0:1.0: USB hub found
[4294022.026678] hub 7-0:1.0: 2 ports detected
[4294022.127678] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[4294022.127678] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[4294022.127678] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[4294022.127678] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[4294022.127678] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
[4294022.127678] usb usb8: configuration #1 chosen from 1 choice
[4294022.127678] hub 8-0:1.0: USB hub found
[4294022.127678] hub 8-0:1.0: 2 ports detected
[4294022.220820] usb 2-4.4: new low speed USB device using ehci_hcd and address 3
[4294022.226472] ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, low) -> IRQ 20
[4294022.226472] PCI: Setting latency timer of device 0000:04:05.0 to 64
[4294022.231423] Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
[4294022.314109] usb 2-4.4: configuration #1 chosen from 1 choice
[4294022.330236] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.7/usb2/2-4/2-4.4/2-4.4:1.0/input/input3
[4294022.344794] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.7-4.4
[4294022.344819] usbcore: registered new interface driver usbhid
[4294022.344822] usbhid: v2.6:USB HID core driver
[4294023.987374] Filesystem "md1": Disabling barriers, not supported by the underlying device
[4294024.978674] coretemp coretemp.0: Using relative temperature scale!
[4294024.978674] coretemp coretemp.1: Using relative temperature scale!
[4294024.999465] abituguru3: no Abit uGuru3 found, data = 0x00, cmd = 0x55
[4294025.412245] md: md0 stopped.
[4294025.591515] md: bind<sdc1>
[4294025.591862] md: bind<sdd1>
[4294025.591862] md: bind<sda1>
[4294025.595765] raid1: raid set md0 active with 3 out of 3 mirrors
[4294025.595971] md: md2 stopped.
[4294025.609929] md: bind<sdc3>
[4294025.610781] md: bind<sdb2>
[4294025.610781] md: bind<sdd3>
[4294025.610781] md: bind<sda3>
[4294025.614672] raid5: device sda3 operational as raid disk 0
[4294025.614672] raid5: device sdd3 operational as raid disk 3
[4294025.614672] raid5: device sdb2 operational as raid disk 2
[4294025.614672] raid5: device sdc3 operational as raid disk 1
[4294025.614817] raid5: allocated 4286kB for md2
[4294025.614820] raid5: raid level 5 set md2 active with 4 out of 4 devices, algorithm 2
[4294025.614823] RAID5 conf printout:
[4294025.614824]  --- rd:4 wd:4
[4294025.614827]  disk 0, o:1, dev:sda3
[4294025.614829]  disk 1, o:1, dev:sdc3
[4294025.614831]  disk 2, o:1, dev:sdb2
[4294025.614833]  disk 3, o:1, dev:sdd3
[4294025.616268] md: md3 stopped.
[4294025.648346] md: bind<sdc4>
[4294025.648346] md: bind<sdb3>
[4294025.648884] md: bind<sdd4>
[4294025.648951] md: bind<sda4>
[4294025.652650] raid5: device sda4 operational as raid disk 0
[4294025.652653] raid5: device sdd4 operational as raid disk 3
[4294025.652656] raid5: device sdb3 operational as raid disk 2
[4294025.652659] raid5: device sdc4 operational as raid disk 1
[4294025.652951] raid5: allocated 4286kB for md3
[4294025.652951] raid5: raid level 5 set md3 active with 4 out of 4 devices, algorithm 2
[4294025.652951] RAID5 conf printout:
[4294025.652951]  --- rd:4 wd:4
[4294025.652951]  disk 0, o:1, dev:sda4
[4294025.652951]  disk 1, o:1, dev:sdc4
[4294025.652951]  disk 2, o:1, dev:sdb3
[4294025.652951]  disk 3, o:1, dev:sdd4
[4294025.920950] Filesystem "md0": Disabling barriers, not supported by the underlying device
[4294025.929889] XFS mounting filesystem md0
[4294026.033461] Ending clean XFS mount for filesystem: md0
[4294026.043950] Filesystem "md2": Disabling barriers, not supported by the underlying device
[4294026.044346] XFS mounting filesystem md2
[4294026.224344] Ending clean XFS mount for filesystem: md2
[4294026.241391] Filesystem "md3": Disabling barriers, not supported by the underlying device
[4294026.241391] XFS mounting filesystem md3
[4294026.918094] Ending clean XFS mount for filesystem: md3
[4294027.663637] br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[4294027.667348] device lan0 entered promiscuous mode
[4294027.668966] r8169: lan0: link up
[4294027.670967] device lan1 entered promiscuous mode
[4294027.672350] r8169: lan1: link down
[4294027.683962] br0: port 1(lan0) entering learning state
[4294042.682966] br0: topology change detected, propagating
[4294042.682971] br0: port 1(lan0) entering forwarding state
[4294057.720963] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[4294133.341963] netconsole: couldn't parse config at 192.168.0.14!
[4294133.341963] netconsole: cleaning up
[4294146.028723] netconsole: local port 6665
[4294146.028723] netconsole: local IP 0.0.0.0
[4294146.028723] netconsole: interface br0
[4294146.028723] netconsole: remote port 1234
[4294146.028723] netconsole: remote IP 192.168.0.14
[4294146.028723] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[4294146.028723] netconsole: br0 doesn't support polling, aborting.
[4294146.031982] netconsole: cleaning up
[4294160.852001] netconsole: local port 6665
[4294160.852001] netconsole: local IP 0.0.0.0
[4294160.852001] netconsole: interface lan0
[4294160.852001] netconsole: remote port 1234
[4294160.852001] netconsole: remote IP 192.168.0.14
[4294160.852025] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[4294160.852098] netconsole: no IP address for lan0, aborting
[4294160.856195] netconsole: cleaning up
[4294173.023636] br0: port 1(lan0) entering disabled state
[4294173.046964] device lan0 left promiscuous mode
[4294173.046964] br0: port 1(lan0) entering disabled state
[4294173.059755] device lan1 left promiscuous mode
[4294173.059762] br0: port 2(lan1) entering disabled state
[4294200.651348] r8169: lan0: link up
[4294215.478349] netconsole: local port 6665
[4294215.478349] netconsole: local IP 0.0.0.0
[4294215.478349] netconsole: interface lan0
[4294215.478349] netconsole: remote port 1234
[4294215.478349] netconsole: remote IP 192.168.0.14
[4294215.478349] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[4294215.478349] netconsole: local IP 192.168.0.12
[4294215.486807] console [netcon0] enabled
[4294215.486816] netconsole: network logging started
[4294228.526185] SysRq : Emergency Sync
[4294228.526185] Emergency Sync complete
[4294293.003500] SysRq : Show Blocked State
[4294293.003500]   task                        PC stack   pid father
[4294293.003500] pdflush       D 0000000000000002     0   191      2
[4294293.003500]  ffff81007cee1660 0000000000000046 0000000000000082 0000000000000001
[4294293.003500]  0000000000000001 ffff81007cee1610 ffff81007cee15e0 ffffffff80625dc0
[4294293.003500]  ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0
[4294293.003500] Call Trace:
[4294293.003500]  [<ffffffff803f5256>] ? raid5_unplug_device+0xdd/0xe6
[4294293.003500]  [<ffffffff8047a79e>] io_schedule+0x28/0x33
[4294293.003500]  [<ffffffff8025f5cd>] sync_page+0x3f/0x43
[4294293.003500]  [<ffffffff8047aa31>] __wait_on_bit+0x45/0x77
[4294293.003500]  [<ffffffff8025f58e>] ? sync_page+0x0/0x43
[4294293.003500]  [<ffffffff8025f835>] wait_on_page_bit+0x6f/0x76
[4294293.003500]  [<ffffffff80243b2e>] ? wake_bit_function+0x0/0x2a
[4294293.003500]  [<ffffffff80268b99>] shrink_page_list+0x116/0x57b
[4294293.003500]  [<ffffffff803f5299>] ? get_active_stripe+0x3a/0x4cc
[4294293.003500]  [<ffffffff8047a889>] ? schedule_timeout+0x98/0xb4
[4294293.003500]  [<ffffffff80239ca9>] ? process_timeout+0x0/0xb
[4294293.003500]  [<ffffffff8047a879>] ? schedule_timeout+0x88/0xb4
[4294293.003500]  [<ffffffff8026b451>] ? congestion_wait+0x7a/0x88
[4294293.003500]  [<ffffffff802691ec>] shrink_inactive_list+0x1ee/0x414
[4294293.003500]  [<ffffffff80228b16>] ? enqueue_task_fair+0x1df/0x1eb
[4294293.003500]  [<ffffffff802694f7>] shrink_zone+0xe5/0x10a
[4294293.003500]  [<ffffffff802698e2>] try_to_free_pages+0x232/0x36e
[4294293.003500]  [<ffffffff80268357>] ? isolate_pages_global+0x0/0x34
[4294293.003500]  [<ffffffff802648dc>] __alloc_pages_internal+0x245/0x3c6
[4294293.003500]  [<ffffffff80264a73>] __alloc_pages+0xb/0xd
[4294293.003500]  [<ffffffff80264a8a>] __get_free_pages+0x15/0x54
[4294293.003500]  [<ffffffff8028106a>] __kmalloc+0x3e/0xe6
[4294293.003500]  [<ffffffff803067fc>] ? xfs_iflush_int+0x272/0x2fb
[4294293.003500]  [<ffffffff80320552>] kmem_alloc+0x6a/0xd1
[4294293.003500]  [<ffffffff80307a9c>] xfs_iflush_cluster+0x4b/0x33f
[4294293.003500]  [<ffffffff8030681e>] ? xfs_iflush_int+0x294/0x2fb
[4294293.003500]  [<ffffffff80307f4b>] xfs_iflush+0x1bb/0x29d
[4294293.003500]  [<ffffffff8031bc30>] xfs_inode_flush+0xb8/0xdd
[4294293.003500]  [<ffffffff80328b1f>] xfs_fs_write_inode+0x30/0x4c
[4294293.003500]  [<ffffffff802a0d3f>] __writeback_single_inode+0x197/0x2c5
[4294293.003500]  [<ffffffff8034379d>] ? __up_read+0x1c/0x97
[4294293.003500]  [<ffffffff802a1563>] ? writeback_inodes+0x69/0xd8
[4294293.003500]  [<ffffffff802a125f>] sync_sb_inodes+0x1cc/0x2cf
[4294293.003500]  [<ffffffff802a156e>] writeback_inodes+0x74/0xd8
[4294293.003500]  [<ffffffff8026608c>] background_writeout+0x93/0xcc
[4294293.003500]  [<ffffffff802665a1>] ? pdflush+0x0/0x1f2
[4294293.003500]  [<ffffffff802666e8>] pdflush+0x147/0x1f2
[4294293.003500]  [<ffffffff80265ff9>] ? background_writeout+0x0/0xcc
[4294293.003500]  [<ffffffff802439e6>] kthread+0x49/0x77
[4294293.003500]  [<ffffffff8020c258>] child_rip+0xa/0x12
[4294293.003500]  [<ffffffff8020b943>] ? restore_args+0x0/0x30
[4294293.003500]  [<ffffffff8024399d>] ? kthread+0x0/0x77
[4294293.003500]  [<ffffffff8020c24e>] ? child_rip+0x0/0x12
[4294293.003500] 
[4294293.003500] xfsdatad/0    D ffffffff8032085b     0   249      2
[4294293.003500]  ffff81007bd0bd70 0000000000000046 0000000000000002 0000000000000000
[4294293.003500]  ffff81007839c0d0 ffff81007bd0bd20 ffffffff8024660e ffffffff80625dc0
[4294293.003500]  ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0
[4294293.003500] Call Trace:
[4294293.003500]  [<ffffffff8024660e>] ? lock_hrtimer_base+0x25/0x4b
[4294293.003500]  [<ffffffff8032085b>] ? xfs_end_bio_delalloc+0x0/0x24
[4294293.003500]  [<ffffffff8047c49d>] __down_write_nested+0x91/0xab
[4294293.003500]  [<ffffffff8047c4c2>] __down_write+0xb/0xd
[4294293.003500]  [<ffffffff80246e66>] down_write_nested+0x2b/0x2f
[4294293.003500]  [<ffffffff8030320e>] xfs_ilock+0x5b/0x79
[4294293.003500]  [<ffffffff803206f3>] xfs_setfilesize+0x36/0x9d
[4294293.003500]  [<ffffffff80240291>] ? run_workqueue+0xa0/0x20c
[4294293.003500]  [<ffffffff80320873>] xfs_end_bio_delalloc+0x18/0x24
[4294293.003500]  [<ffffffff802402dc>] run_workqueue+0xeb/0x20c
[4294293.003500]  [<ffffffff80240ef7>] worker_thread+0xe5/0xf6
[4294293.003500]  [<ffffffff80243af6>] ? autoremove_wake_function+0x0/0x38
[4294293.003500]  [<ffffffff80240e12>] ? worker_thread+0x0/0xf6
[4294293.003500]  [<ffffffff802439e6>] kthread+0x49/0x77
[4294293.003500]  [<ffffffff8020c258>] child_rip+0xa/0x12
[4294293.003500]  [<ffffffff8020b943>] ? restore_args+0x0/0x30
[4294293.003500]  [<ffffffff8024399d>] ? kthread+0x0/0x77
[4294293.003500]  [<ffffffff8020c24e>] ? child_rip+0x0/0x12
[4294293.003500] 
[4294293.003500] xfsdatad/1    D ffffffff8032085b     0   250      2
[4294293.003500]  ffff81007bd0dd70 0000000000000046 0000000000000002 0000000000000000
[4294293.003500]  ffff81007839c0d0 ffff81007bd0dd20 ffffffff8024660e ffffffff80625dc0
[4294293.003500]  ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0
[4294293.003500] Call Trace:
[4294293.003500]  [<ffffffff8024660e>] ? lock_hrtimer_base+0x25/0x4b
[4294293.003500]  [<ffffffff8032085b>] ? xfs_end_bio_delalloc+0x0/0x24
[4294293.003500]  [<ffffffff8047c49d>] __down_write_nested+0x91/0xab
[4294293.003500]  [<ffffffff8047c4c2>] __down_write+0xb/0xd
[4294293.003500]  [<ffffffff80246e66>] down_write_nested+0x2b/0x2f
[4294293.003500]  [<ffffffff8030320e>] xfs_ilock+0x5b/0x79
[4294293.003500]  [<ffffffff803206f3>] xfs_setfilesize+0x36/0x9d
[4294293.003500]  [<ffffffff80240291>] ? run_workqueue+0xa0/0x20c
[4294293.003500]  [<ffffffff80320873>] xfs_end_bio_delalloc+0x18/0x24
[4294293.003500]  [<ffffffff802402dc>] run_workqueue+0xeb/0x20c
[4294293.003500]  [<ffffffff80240ef7>] worker_thread+0xe5/0xf6
[4294293.003500]  [<ffffffff80243af6>] ? autoremove_wake_function+0x0/0x38
[4294293.003500]  [<ffffffff80240e12>] ? worker_thread+0x0/0xf6
[4294293.003500]  [<ffffffff802439e6>] kthread+0x49/0x77
[4294293.003500]  [<ffffffff8020c258>] child_rip+0xa/0x12
[4294293.003500]  [<ffffffff8020b943>] ? restore_args+0x0/0x30
[4294293.003500]  [<ffffffff8024399d>] ? kthread+0x0/0x77
[4294293.003500]  [<ffffffff8020c24e>] ? child_rip+0x0/0x12
[4294293.003500] 
[4294293.003500] cat           D 0000000000001000     0  2627   2426
[4294293.003500]  ffff81007862d878 0000000000000046 0000000000000002 0000000000000000
[4294293.003500]  ffff81007839c0d0 ffff81007862d828 ffff81007862d7e8 ffffffff80625dc0
[4294293.003500]  ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0
[4294293.003500] Call Trace:
[4294293.003500]  [<ffffffff8047c49d>] __down_write_nested+0x91/0xab
[4294293.003500]  [<ffffffff8047c4c2>] __down_write+0xb/0xd
[4294293.003500]  [<ffffffff80246e66>] down_write_nested+0x2b/0x2f
[4294293.003500]  [<ffffffff8030320e>] xfs_ilock+0x5b/0x79
[4294293.003500]  [<ffffffff80309f94>] xfs_iomap+0x8b/0x27f
[4294293.003500]  [<ffffffff80246ed8>] ? up_read+0x26/0x2a
[4294293.003500]  [<ffffffff80321098>] __xfs_get_blocks+0x5b/0x144
[4294293.003500]  [<ffffffff803211aa>] xfs_get_blocks+0x12/0x14
[4294293.003500]  [<ffffffff802a60b6>] __block_prepare_write+0x1d9/0x3c5
[4294293.003500]  [<ffffffff80321198>] ? xfs_get_blocks+0x0/0x14
[4294293.003500]  [<ffffffff802a634f>] block_write_begin+0x7d/0xcd
[4294293.003500]  [<ffffffff80320b6c>] xfs_vm_write_begin+0x25/0x27
[4294293.003500]  [<ffffffff80321198>] ? xfs_get_blocks+0x0/0x14
[4294293.003500]  [<ffffffff80260380>] generic_file_buffered_write+0x155/0x676
[4294293.003500]  [<ffffffff8030be98>] ? xfs_log_move_tail+0x14d/0x159
[4294293.003500]  [<ffffffff8032804e>] xfs_write+0x507/0x6fe
[4294293.003500]  [<ffffffff80246878>] ? hrtimer_start+0x12d/0x14f
[4294293.003500]  [<ffffffff80324c11>] xfs_file_aio_write+0x53/0x55
[4294293.003500]  [<ffffffff80283b70>] do_sync_write+0xeb/0x132
[4294293.003500]  [<ffffffff80243af6>] ? autoremove_wake_function+0x0/0x38
[4294293.003500]  [<ffffffff80284308>] vfs_write+0xae/0x137
[4294293.003500]  [<ffffffff80284871>] sys_write+0x47/0x70
[4294293.003500]  [<ffffffff8020b2eb>] system_call_after_swapgs+0x7b/0x80
[4294293.003500] 
[4294293.003500] Sched Debug Version: v0.07, 2.6.26-rc2-damocles #2
[4294293.003500] now at 278245.105796 msecs
[4294293.003500]   .sysctl_sched_latency                    : 40.000000
[4294293.003500]   .sysctl_sched_min_granularity            : 8.000000
[4294293.003500]   .sysctl_sched_wakeup_granularity         : 20.000000
[4294293.003500]   .sysctl_sched_child_runs_first           : 0.000001
[4294293.003500]   .sysctl_sched_features                   : 895
[4294293.003500] 
[4294293.003500] cpu#0, 2996.999 MHz
[4294293.003500]   .nr_running                    : 3
[4294293.003500]   .load                          : 5169
[4294293.003500]   .nr_switches                   : 157419
[4294293.003500]   .nr_load_updates               : 39187
[4294293.003500]   .nr_uninterruptible            : -2
[4294293.003500]   .jiffies                       : 4294945538
[4294293.003500]   .next_balance                  : 4294.945508
[4294293.003500]   .curr->pid                     : 0
[4294293.003500]   .clock                         : 278241.306172
[4294293.003500]   .cpu_load[0]                   : 0
[4294293.003500]   .cpu_load[1]                   : 0
[4294293.003500]   .cpu_load[2]                   : 24
[4294293.003500]   .cpu_load[3]                   : 80
[4294293.003500]   .cpu_load[4]                   : 113
[4294293.003500] 
[4294293.003500] cfs_rq[0]:
[4294293.003500]   .exec_clock                    : 20036.790571
[4294293.003500]   .MIN_vruntime                  : 75667.048697
[4294293.003500]   .min_vruntime                  : 75908.962744
[4294293.003500]   .max_vruntime                  : 75868.968201
[4294293.003500]   .spread                        : 201.919504
[4294293.003500]   .spread0                       : 0.000000
[4294293.003500]   .nr_running                    : 3
[4294293.003500]   .load                          : 5169
[4294293.003500]   .bkl_count                     : 496
[4294293.003500]   .nr_spread_over                : 3817
[4294293.003500] 
[4294293.003500] runnable tasks:
[4294293.003500]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[4294293.003500] ----------------------------------------------------------------------------------------------------------
[4294293.003500]         events/0     7     75868.968201      3499   115     75868.968201       368.209941    277355.845917
[4294293.003500]            klogd  2005     75667.048697       506   120     75667.048697        12.759793    243588.378665
[4294293.003500]  hald-addon-inpu  2229     75868.962745      1308   120     75868.962745        89.199855    234248.040806
[4294293.003500] 
[4294293.003500] cpu#1, 2996.999 MHz
[4294293.003500]   .nr_running                    : 0
[4294293.003500]   .load                          : 0
[4294293.003500]   .nr_switches                   : 139883
[4294293.003500]   .nr_load_updates               : 39037
[4294293.003500]   .nr_uninterruptible            : 6
[4294293.003500]   .jiffies                       : 4294945538
[4294293.003500]   .next_balance                  : 4294.945692
[4294293.003500]   .curr->pid                     : 0
[4294293.003500]   .clock                         : 278231.672543
[4294293.003500]   .cpu_load[0]                   : 0
[4294293.003500]   .cpu_load[1]                   : 0
[4294293.003500]   .cpu_load[2]                   : 9
[4294293.003500]   .cpu_load[3]                   : 46
[4294293.003500]   .cpu_load[4]                   : 87
[4294293.003500] 
[4294293.003500] cfs_rq[1]:
[4294293.003500]   .exec_clock                    : 13515.188155
[4294293.003500]   .MIN_vruntime                  : 0.000001
[4294293.003500]   .min_vruntime                  : 61656.996671
[4294293.003500]   .max_vruntime                  : 0.000001
[4294293.003500]   .spread                        : 0.000000
[4294293.003500]   .spread0                       : -14251.966073
[4294293.003500]   .nr_running                    : 0
[4294293.003500]   .load                          : 0
[4294293.003500]   .bkl_count                     : 789
[4294293.003500]   .nr_spread_over                : 4637
[4294293.003500] 
[4294293.003500] runnable tasks:
[4294293.003500]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[4294293.003500] ----------------------------------------------------------------------------------------------------------
[4294293.003500] 

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
