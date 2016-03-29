Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 117927CA3
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:16:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C42708F8049
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 10:16:01 -0700 (PDT)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[81.169.146.220]) by cuda.sgi.com with ESMTP id
	3feRzEEuWGPCA5eS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 10:15:56 -0700 (PDT)
Received: from probook ([2001:a62:1280:ddff:38da:30c:6dd5:66f4])
	by smtp.strato.de (RZmta 37.22 AUTH) with ESMTPSA id L026bds2THFs6ak
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1
	with 521 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate) for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2016 19:15:54 +0200 (CEST)
Date: Tue, 29 Mar 2016 19:15:53 +0200
From: Olaf Hering <olaf@aepfle.de>
Subject: BUG in xfs_trans_binval
Message-ID: <20160329171553.GA17885@aepfle.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

During receiving a backup stream (netcal -l 12345 | tar xf -) the host
crashed and rebooted, no idea why.
After reboot I tried to remove the received directory (rm -rf dir) and
got this BUG:

"_xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000"

xfs_trans_binval
xfs_alloc_fix_freelist
xfs_free_extent
xfs_trans_free_extent
xfs_bmap_finis
xfs_itruncate_extents
xfs_incative_truncate
xfs_incative
xfs_fs_evict_inode
evict
iput
do_unlinkat
SyS_unlinkat

Kernel is 4.5.0 from openSUSE Tumbleweed.
dmesg is attached, I just realized it has the backtrace.

#  dmesg | grep sdb
[    1.882794] sd 4:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    1.883317] sd 4:0:0:0: [sdb] Write Protect is off
[    1.883324] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.883626] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.898471]  sdb: sdb1 sdb2
[    1.900079] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    3.613022] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[   11.690375] EXT4-fs (sdb2): re-mounted. Opts: acl,user_xattr
[   20.083397] XFS (sdb1): Mounting V5 Filesystem
[   20.291900] XFS (sdb1): Starting recovery (logdev: internal)
[   25.285846] XFS (sdb1): Bad dir block magic!
[   26.448027] XFS (sdb1): Ending recovery (logdev: internal)
[  130.489414] XFS (sdb1): _xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000 
[  130.494271] XFS (sdb1): _xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000 


Olaf

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-4.5.0-1-default.txt"

[    0.000000] Linux version 4.5.0-1-default (geeko@buildhost) (gcc version 5.3.1 20151207 [gcc-5-branch revision 231355] (SUSE Linux) ) #1 SMP PREEMPT Wed Mar 16 17:30:21 UTC 2016 (b2c9ae5)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.5.0-1-default root=UUID=861a7aa5-a56f-48a6-9884-a4b35d39c0f2 quiet panic=9 sysrq_always_enabled splash=silent showopts
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'lazy' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000db6cfbff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db6cfc00-0x00000000db723bff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db723c00-0x00000000db725bff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000db725c00-0x00000000dbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed9ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Dell Inc. OptiPlex 980                 /0D441T, BIOS A16 05/28/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x220000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: last_pfn = 0xdb6cf max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fe710-0x000fe71f] mapped at [ffff8800000fe710]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] BRK [0x0224a000, 0x0224afff] PGTABLE
[    0.000000] BRK [0x0224b000, 0x0224bfff] PGTABLE
[    0.000000] BRK [0x0224c000, 0x0224cfff] PGTABLE
[    0.000000] BRK [0x0224d000, 0x0224dfff] PGTABLE
[    0.000000] BRK [0x0224e000, 0x0224efff] PGTABLE
[    0.000000] BRK [0x0224f000, 0x0224ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37277000-0x37932fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FEC00 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000000FC7E0 00007C (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: FACP 0x00000000000FC8D0 0000F4 (v03 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/64 (20160108/tbfadt-623)
[    0.000000] ACPI: DSDT 0x00000000FFDCBEE5 0047BC (v01 DELL   dt_ex    00001000 INTL 20050624)
[    0.000000] ACPI: FACS 0x00000000DB6CFC00 000040
[    0.000000] ACPI: FACS 0x00000000DB6CFC00 000040
[    0.000000] ACPI: SSDT 0x00000000FFDD07C2 0000AC (v01 DELL   st_ex    00001000 INTL 20050624)
[    0.000000] ACPI: APIC 0x00000000000FC9C4 000092 (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 0x00000000000FCA56 000028 (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 0x00000000000FCA7E 000096 (v32 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 0x00000000000FCB14 00003C (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: HPET 0x00000000000FCB50 000038 (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 0x00000000000FCDAC 000032 (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: DMAR 0x00000000000FCDDE 000068 (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 0x00000000000FCB88 000176 (v01 DELL   B11K     00000015 ASL  00000061)
[    0.000000] ACPI: SSDT 0x00000000DB725C00 002874 (v01 INTEL  PPM RCM  80000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x21ffe8000-0x21fff9fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000021fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000db6cefff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000021fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000021fffffff]
[    0.000000] On node 0 totalpages: 2078316
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13980 pages used for memmap
[    0.000000]   DMA32 zone: 894671 pages, LIFO batch:31
[    0.000000]   Normal zone: 18432 pages used for memmap
[    0.000000]   Normal zone: 1179648 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb6cf000-0xdb6cffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb6d0000-0xdb722fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb723000-0xdb723fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb724000-0xdb724fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb725000-0xdb725fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb726000-0xdbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfed9ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeda0000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xffafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xffffffff]
[    0.000000] e820: [mem 0xdc000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 34 pages/cpu @ffff88021fc00000 s99096 r8192 d31976 u262144
[    0.000000] pcpu-alloc: s99096 r8192 d31976 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2045819
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.5.0-1-default root=UUID=861a7aa5-a56f-48a6-9884-a4b35d39c0f2 quiet panic=9 sysrq_always_enabled splash=silent showopts
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 32768 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 229376 bytes
[    0.000000] log_buf_len min size: 262144 bytes
[    0.000000] log_buf_len: 524288 bytes
[    0.000000] early log buf free: 252696(96%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 5600524K/8313264K available (6978K kernel code, 1179K rwdata, 5152K rodata, 1628K init, 1544K bss, 224804K reserved, 0K cma-reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=8
[    0.000000] NR_IRQS:33024 nr_irqs:488 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2793.023 MHz processor
[    0.000030] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.04 BogoMIPS (lpj=11172092)
[    0.000033] pid_max: default: 32768 minimum: 301
[    0.000045] ACPI: Core revision 20160108
[    0.069516] ACPI: 3 ACPI AML tables successfully acquired and loaded

[    0.069558] Security Framework initialized
[    0.069564] AppArmor: AppArmor initialized
[    0.070043] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.071504] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.072118] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.072126] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.072377] CPU: Physical Processor ID: 0
[    0.072378] CPU: Processor Core ID: 0
[    0.072382] mce: CPU supports 9 MCE banks
[    0.072391] CPU0: Thermal monitoring enabled (TM1)
[    0.072397] process: using mwait in idle threads
[    0.072399] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.072400] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.072637] Freeing SMP alternatives memory: 28K (ffffffff820bf000 - ffffffff820c6000)
[    0.073993] ftrace: allocating 26991 entries in 106 pages
[    0.084244] DMAR: Host address width 36
[    0.084246] DMAR: DRHD base: 0x000000fedc0000 flags: 0x1
[    0.084254] DMAR: dmar0: reg_base_addr fedc0000 ver 1:0 cap c90780106f0462 ecap f020e2
[    0.084255] DMAR: RMRR base: 0x000000db730000 end: 0x000000db76ffff
[    0.084641] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.229437] smpboot: CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz (family: 0x6, model: 0x1e, stepping: 0x5)
[    0.229456] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.229470] perf_event_intel: CPU erratum AAJ80 worked around
[    0.229471] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.229473] ... version:                3
[    0.229473] ... bit width:              48
[    0.229474] ... generic registers:      4
[    0.229475] ... value mask:             0000ffffffffffff
[    0.229476] ... max period:             000000007fffffff
[    0.229477] ... fixed-purpose events:   3
[    0.229477] ... event mask:             000000070000000f
[    0.265492] x86: Booting SMP configuration:
[    0.265496] .... node  #0, CPUs:      #1
[    0.268073] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.277499]  #2 #3 #4 #5 #6 #7
[    0.339974] x86: Booted up 1 node, 8 CPUs
[    0.339977] smpboot: Total of 8 processors activated (44688.36 BogoMIPS)
[    0.360818] node 0 initialised, 621984 pages in 16ms
[    0.360938] devtmpfs: initialized
[    0.363443] PM: Registering ACPI NVS region [mem 0xdb6cfc00-0xdb723bff] (344064 bytes)
[    0.363538] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.363602] pinctrl core: initialized pinctrl subsystem
[    0.363639] RTC time: 16:57:38, date: 03/29/16
[    0.363747] NET: Registered protocol family 16
[    0.373481] cpuidle: using governor ladder
[    0.385478] cpuidle: using governor menu
[    0.385551] Simple Boot Flag at 0x7a set to 0x1
[    0.385586] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.385588] ACPI: bus type PCI registered
[    0.385589] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.385658] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.385660] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.385668] PCI: Using configuration type 1 for base access
[    0.385674] dmi type 0xB1 record - unknown flag
[    0.397627] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.397857] ACPI: Added _OSI(Module Device)
[    0.397859] ACPI: Added _OSI(Processor Device)
[    0.397860] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.397861] ACPI: Added _OSI(Processor Aggregator Device)
[    0.433272] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.436787] ACPI: Interpreter enabled
[    0.436806] ACPI: (supports S0 S1 S3 S4 S5)
[    0.436807] ACPI: Using IOAPIC for interrupt routing
[    0.436918] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.498137] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.498142] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.498147] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.498156] acpi PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.504270] PCI host bridge to bus 0000:00
[    0.504273] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.504274] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.504276] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.504277] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000effff window]
[    0.504279] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff window]
[    0.504280] pci_bus 0000:00: root bus resource [mem 0xdb800000-0xf7ffffff window]
[    0.504282] pci_bus 0000:00: root bus resource [mem 0xff87c000-0xff87ffff window]
[    0.504283] pci_bus 0000:00: root bus resource [mem 0xff870000-0xff8707ff window]
[    0.504285] pci_bus 0000:00: root bus resource [mem 0xfed20000-0xfed9ffff window]
[    0.504287] pci_bus 0000:00: root bus resource [mem 0xfeda6000-0xfeda6fff window]
[    0.504288] pci_bus 0000:00: root bus resource [mem 0xfeda7000-0xfeda7fff window]
[    0.504290] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.504298] pci 0000:00:00.0: [8086:d131] type 00 class 0x060000
[    0.504620] pci 0000:00:03.0: [8086:d138] type 01 class 0x060400
[    0.504667] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.504962] pci 0000:00:08.0: [8086:d155] type 00 class 0x088000
[    0.505276] pci 0000:00:08.1: [8086:d156] type 00 class 0x088000
[    0.505593] pci 0000:00:08.2: [8086:d157] type 00 class 0x088000
[    0.505912] pci 0000:00:10.0: [8086:d150] type 00 class 0x088000
[    0.506212] pci 0000:00:10.1: [8086:d151] type 00 class 0x088000
[    0.506526] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.506551] pci 0000:00:16.0: reg 0x10: [mem 0xfeda6000-0xfeda600f 64bit]
[    0.506637] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.506930] pci 0000:00:16.2: [8086:3b66] type 00 class 0x010185
[    0.506947] pci 0000:00:16.2: reg 0x10: [io  0xfe80-0xfe87]
[    0.506957] pci 0000:00:16.2: reg 0x14: [io  0xfe90-0xfe93]
[    0.506965] pci 0000:00:16.2: reg 0x18: [io  0xfea0-0xfea7]
[    0.506975] pci 0000:00:16.2: reg 0x1c: [io  0xfeb0-0xfeb3]
[    0.506983] pci 0000:00:16.2: reg 0x20: [io  0xfef0-0xfeff]
[    0.507320] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.507337] pci 0000:00:16.3: reg 0x10: [io  0xec98-0xec9f]
[    0.507346] pci 0000:00:16.3: reg 0x14: [mem 0xf7fdb000-0xf7fdbfff]
[    0.507705] pci 0000:00:19.0: [8086:10ef] type 00 class 0x020000
[    0.507718] pci 0000:00:19.0: reg 0x10: [mem 0xf7fe0000-0xf7ffffff]
[    0.507726] pci 0000:00:19.0: reg 0x14: [mem 0xf7fdc000-0xf7fdcfff]
[    0.507733] pci 0000:00:19.0: reg 0x18: [io  0xecc0-0xecdf]
[    0.507787] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.508080] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.508097] pci 0000:00:1a.0: reg 0x10: [mem 0xf7fdd000-0xf7fdd3ff]
[    0.508173] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.508433] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.508475] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.508490] pci 0000:00:1b.0: reg 0x10: [mem 0xff87c000-0xff87ffff 64bit]
[    0.508555] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.508847] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.508908] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.509168] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.509212] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.509272] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.509536] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.509580] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.509596] pci 0000:00:1d.0: reg 0x10: [mem 0xf7fde000-0xf7fde3ff]
[    0.509673] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.509933] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.509971] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.510268] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.510309] pci 0000:00:1f.0: [8086:3b0a] type 00 class 0x060100
[    0.510690] pci 0000:00:1f.2: [8086:3b22] type 00 class 0x010601
[    0.510703] pci 0000:00:1f.2: reg 0x10: [io  0xfe00-0xfe07]
[    0.510710] pci 0000:00:1f.2: reg 0x14: [io  0xfe10-0xfe13]
[    0.510717] pci 0000:00:1f.2: reg 0x18: [io  0xfe20-0xfe27]
[    0.510723] pci 0000:00:1f.2: reg 0x1c: [io  0xfe30-0xfe33]
[    0.510730] pci 0000:00:1f.2: reg 0x20: [io  0xfec0-0xfedf]
[    0.510737] pci 0000:00:1f.2: reg 0x24: [mem 0xff870000-0xff8707ff]
[    0.510774] pci 0000:00:1f.2: PME# supported from D3hot
[    0.511060] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.511073] pci 0000:00:1f.3: reg 0x10: [mem 0xf7fdf000-0xf7fdf0ff 64bit]
[    0.511091] pci 0000:00:1f.3: reg 0x20: [io  0xece0-0xecff]
[    0.511425] pci 0000:01:00.0: [1002:95c5] type 00 class 0x030000
[    0.511439] pci 0000:01:00.0: reg 0x10: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.511448] pci 0000:01:00.0: reg 0x18: [mem 0xf7df0000-0xf7dfffff 64bit]
[    0.511455] pci 0000:01:00.0: reg 0x20: [io  0xdc00-0xdcff]
[    0.511466] pci 0000:01:00.0: reg 0x30: [mem 0xf7e00000-0xf7e1ffff pref]
[    0.511497] pci 0000:01:00.0: supports D1 D2
[    0.519986] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.519992] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    0.519997] pci 0000:00:03.0:   bridge window [mem 0xf7d00000-0xf7efffff]
[    0.520004] pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.520082] pci 0000:02:00.0: [8086:10d3] type 00 class 0x020000
[    0.520109] pci 0000:02:00.0: reg 0x10: [mem 0xf7b60000-0xf7b7ffff]
[    0.520125] pci 0000:02:00.0: reg 0x14: [mem 0xf7b80000-0xf7bfffff]
[    0.520142] pci 0000:02:00.0: reg 0x18: [io  0xcce0-0xccff]
[    0.520158] pci 0000:02:00.0: reg 0x1c: [mem 0xf7b5c000-0xf7b5ffff]
[    0.520204] pci 0000:02:00.0: reg 0x30: [mem 0xf7c00000-0xf7c3ffff pref]
[    0.520303] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.527994] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.528000] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.528006] pci 0000:00:1c.0:   bridge window [mem 0xf7b00000-0xf7cfffff]
[    0.528065] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.528108] pci 0000:04:02.0: [14e4:4318] type 00 class 0x028000
[    0.528120] pci 0000:04:02.0: reg 0x10: [mem 0xf7afe000-0xf7afffff]
[    0.528233] pci 0000:00:1e.0: PCI bridge to [bus 04] (subtractive decode)
[    0.528238] pci 0000:00:1e.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.528243] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    0.528244] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.528246] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.528248] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff window] (subtractive decode)
[    0.528249] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff window] (subtractive decode)
[    0.528251] pci 0000:00:1e.0:   bridge window [mem 0xdb800000-0xf7ffffff window] (subtractive decode)
[    0.528252] pci 0000:00:1e.0:   bridge window [mem 0xff87c000-0xff87ffff window] (subtractive decode)
[    0.528254] pci 0000:00:1e.0:   bridge window [mem 0xff870000-0xff8707ff window] (subtractive decode)
[    0.528255] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff window] (subtractive decode)
[    0.528257] pci 0000:00:1e.0:   bridge window [mem 0xfeda6000-0xfeda6fff window] (subtractive decode)
[    0.528258] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfeda7fff window] (subtractive decode)
[    0.542385] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    0.543289] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.544196] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.545118] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    0.546043] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    0.546947] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.547868] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    0.548774] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.549424] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.549511] vgaarb: setting as boot device: PCI:0000:01:00.0
[    0.549513] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.549514] vgaarb: loaded
[    0.549515] vgaarb: bridge control possible 0000:01:00.0
[    0.549607] SCSI subsystem initialized
[    0.549642] libata version 3.00 loaded.
[    0.549702] PCI: Using ACPI for IRQ routing
[    0.550999] PCI: Discovered peer bus 3f
[    0.551000] PCI: root bus 3f: using default resources
[    0.551001] PCI: Probing PCI hardware (bus 3f)
[    0.551027] ACPI: \: failed to evaluate _DSM (0x1001)
[    0.551028] PCI host bridge to bus 0000:3f
[    0.551030] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.551032] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
[    0.551033] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    0.551035] pci_bus 0000:3f: busn_res: can not insert [bus 3f-ff] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    0.551040] pci 0000:3f:00.0: [8086:2c51] type 00 class 0x060000
[    0.551081] pci 0000:3f:00.1: [8086:2c81] type 00 class 0x060000
[    0.551123] pci 0000:3f:02.0: [8086:2c90] type 00 class 0x060000
[    0.551162] pci 0000:3f:02.1: [8086:2c91] type 00 class 0x060000
[    0.551202] pci 0000:3f:03.0: [8086:2c98] type 00 class 0x060000
[    0.551240] pci 0000:3f:03.1: [8086:2c99] type 00 class 0x060000
[    0.551280] pci 0000:3f:03.4: [8086:2c9c] type 00 class 0x060000
[    0.551319] pci 0000:3f:04.0: [8086:2ca0] type 00 class 0x060000
[    0.551359] pci 0000:3f:04.1: [8086:2ca1] type 00 class 0x060000
[    0.551398] pci 0000:3f:04.2: [8086:2ca2] type 00 class 0x060000
[    0.551436] pci 0000:3f:04.3: [8086:2ca3] type 00 class 0x060000
[    0.551477] pci 0000:3f:05.0: [8086:2ca8] type 00 class 0x060000
[    0.551516] pci 0000:3f:05.1: [8086:2ca9] type 00 class 0x060000
[    0.551554] pci 0000:3f:05.2: [8086:2caa] type 00 class 0x060000
[    0.551594] pci 0000:3f:05.3: [8086:2cab] type 00 class 0x060000
[    0.551641] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.551644] pci_bus 0000:3f: busn_res: can not insert [bus 3f] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    0.551648] PCI: pci_cache_line_size set to 64 bytes
[    0.551705] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.551707] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.551708] e820: reserve RAM buffer [mem 0xdb6cfc00-0xdbffffff]
[    0.551812] NetLabel: Initializing
[    0.551813] NetLabel:  domain hash size = 128
[    0.551813] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.551826] NetLabel:  unlabeled traffic allowed by default
[    0.551885] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    0.551891] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[    0.551895] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.553919] hpet: hpet2 irq 24 for MSI
[    0.553956] hpet: hpet3 irq 25 for MSI
[    0.553994] hpet: hpet4 irq 26 for MSI
[    0.554032] hpet: hpet5 irq 27 for MSI
[    0.554065] hpet: hpet6 irq 28 for MSI
[    0.554155] clocksource: Switched to clocksource hpet
[    0.560231] VFS: Disk quotas dquot_6.6.0
[    0.560262] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.560346] AppArmor: AppArmor Filesystem Enabled
[    0.560390] pnp: PnP ACPI init
[    0.562850] system 00:00: [io  0x0800-0x085f] could not be reserved
[    0.562852] system 00:00: [io  0x0c00-0x0c7f] has been reserved
[    0.562854] system 00:00: [io  0x0860-0x08ff] has been reserved
[    0.562858] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.563093] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.569695] pnp 00:02: [dma 0 disabled]
[    0.569759] pnp 00:02: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.574309] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.583533] pnp: PnP ACPI: found 4 devices
[    0.590093] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.590112] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.590119] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.590121] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.590123] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 03] add_size 200000 add_align 100000
[    0.590133] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.590134] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.590136] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.590138] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.590139] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.590141] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.590143] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.590144] pci 0000:00:1c.4: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.590152] pci 0000:00:1c.0: BAR 15: assigned [mem 0xdc000000-0xdc1fffff 64bit pref]
[    0.590160] pci 0000:00:1c.4: BAR 14: assigned [mem 0xdc200000-0xdc3fffff]
[    0.590164] pci 0000:00:1c.4: BAR 15: assigned [mem 0xdc400000-0xdc5fffff 64bit pref]
[    0.590166] pci 0000:00:1c.4: BAR 13: assigned [io  0x1000-0x1fff]
[    0.590169] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.590171] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    0.590174] pci 0000:00:03.0:   bridge window [mem 0xf7d00000-0xf7efffff]
[    0.590177] pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.590181] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.590183] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.590186] pci 0000:00:1c.0:   bridge window [mem 0xf7b00000-0xf7cfffff]
[    0.590189] pci 0000:00:1c.0:   bridge window [mem 0xdc000000-0xdc1fffff 64bit pref]
[    0.590194] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.590196] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.590199] pci 0000:00:1c.4:   bridge window [mem 0xdc200000-0xdc3fffff]
[    0.590202] pci 0000:00:1c.4:   bridge window [mem 0xdc400000-0xdc5fffff 64bit pref]
[    0.590207] pci 0000:00:1e.0: PCI bridge to [bus 04]
[    0.590211] pci 0000:00:1e.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.590218] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.590219] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.590221] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.590222] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff window]
[    0.590223] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff window]
[    0.590225] pci_bus 0000:00: resource 9 [mem 0xdb800000-0xf7ffffff window]
[    0.590226] pci_bus 0000:00: resource 10 [mem 0xff87c000-0xff87ffff window]
[    0.590228] pci_bus 0000:00: resource 11 [mem 0xff870000-0xff8707ff window]
[    0.590229] pci_bus 0000:00: resource 12 [mem 0xfed20000-0xfed9ffff window]
[    0.590230] pci_bus 0000:00: resource 13 [mem 0xfeda6000-0xfeda6fff window]
[    0.590232] pci_bus 0000:00: resource 14 [mem 0xfeda7000-0xfeda7fff window]
[    0.590233] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.590235] pci_bus 0000:01: resource 1 [mem 0xf7d00000-0xf7efffff]
[    0.590236] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.590237] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.590239] pci_bus 0000:02: resource 1 [mem 0xf7b00000-0xf7cfffff]
[    0.590240] pci_bus 0000:02: resource 2 [mem 0xdc000000-0xdc1fffff 64bit pref]
[    0.590242] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.590243] pci_bus 0000:03: resource 1 [mem 0xdc200000-0xdc3fffff]
[    0.590244] pci_bus 0000:03: resource 2 [mem 0xdc400000-0xdc5fffff 64bit pref]
[    0.590246] pci_bus 0000:04: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.590247] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7 window]
[    0.590248] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff window]
[    0.590250] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.590251] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000effff window]
[    0.590253] pci_bus 0000:04: resource 8 [mem 0x000f0000-0x000fffff window]
[    0.590254] pci_bus 0000:04: resource 9 [mem 0xdb800000-0xf7ffffff window]
[    0.590255] pci_bus 0000:04: resource 10 [mem 0xff87c000-0xff87ffff window]
[    0.590257] pci_bus 0000:04: resource 11 [mem 0xff870000-0xff8707ff window]
[    0.590258] pci_bus 0000:04: resource 12 [mem 0xfed20000-0xfed9ffff window]
[    0.590260] pci_bus 0000:04: resource 13 [mem 0xfeda6000-0xfeda6fff window]
[    0.590261] pci_bus 0000:04: resource 14 [mem 0xfeda7000-0xfeda7fff window]
[    0.590264] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.590265] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.590330] NET: Registered protocol family 2
[    0.590509] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.590695] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.590949] TCP: Hash tables configured (established 65536 bind 65536)
[    0.590974] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.591028] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.591145] NET: Registered protocol family 1
[    0.592896] pci 0000:01:00.0: Video device with shadowed ROM
[    0.592916] PCI: CLS 64 bytes, default 64
[    0.592957] Unpacking initramfs...
[    1.274540] Freeing initrd memory: 6896K (ffff880037277000 - ffff880037933000)
[    1.274570] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.274572] software IO TLB [mem 0xd76cf000-0xdb6cf000] (64MB) mapped at [ffff8800d76cf000-ffff8800db6cefff]
[    1.274732] Scanning for low memory corruption every 60 seconds
[    1.275053] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.275094] audit: initializing netlink subsys (disabled)
[    1.275111] audit: type=2000 audit(1459270658.172:1): initialized
[    1.275520] zbud: loaded
[    1.275838] Key type big_key registered
[    1.276136] Key type asymmetric registered
[    1.276139] Asymmetric key parser 'x509' registered
[    1.276165] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    1.276197] io scheduler noop registered
[    1.276200] io scheduler deadline registered
[    1.276216] io scheduler cfq registered (default)
[    1.277680] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.277686] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.277710] intel_idle: MWAIT substates: 0x1120
[    1.277719] intel_idle: v0.4 model 0x1E
[    1.277720] intel_idle: lapic_timer_reliable_states 0x2
[    1.278298] GHES: HEST is not enabled!
[    1.278366] Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
[    1.298789] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.321098] 0000:00:16.3: ttyS4 at I/O 0xec98 (irq = 17, base_baud = 115200) is a 16550A
[    1.321491] Non-volatile memory driver v1.3
[    1.321523] Linux agpgart interface v0.103
[    1.322448] ahci 0000:00:1f.2: version 3.0
[    1.333091] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x17 impl SATA mode
[    1.333095] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp fbs pio ems sxs apst 
[    1.333102] ahci 0000:00:1f.2: port 0 is not capable of FBS
[    1.333123] ahci 0000:00:1f.2: port 1 is not capable of FBS
[    1.338189] ahci 0000:00:1f.2: port 2 is not capable of FBS
[    1.354820] scsi host0: ahci
[    1.354968] scsi host1: ahci
[    1.355110] scsi host2: ahci
[    1.355235] scsi host3: ahci
[    1.355363] scsi host4: ahci
[    1.355486] scsi host5: ahci
[    1.355543] ata1: SATA max UDMA/133 abar m2048@0xff870000 port 0xff870100 irq 29
[    1.355545] ata2: SATA max UDMA/133 abar m2048@0xff870000 port 0xff870180 irq 29
[    1.355547] ata3: SATA max UDMA/133 abar m2048@0xff870000 port 0xff870200 irq 29
[    1.355548] ata4: DUMMY
[    1.355550] ata5: SATA max UDMA/133 abar m2048@0xff870000 port 0xff870300 irq 29
[    1.355552] ata6: DUMMY
[    1.355614] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.358468] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.358508] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.358626] mousedev: PS/2 mouse device common for all mice
[    1.358722] rtc_cmos 00:01: RTC can wake from S4
[    1.358868] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.358892] rtc_cmos 00:01: alarms up to one day, 242 bytes nvram, hpet irqs
[    1.358906] ledtrig-cpu: registered to indicate activity on CPUs
[    1.358925] hidraw: raw HID events driver (C) Jiri Kosina
[    1.359259] NET: Registered protocol family 10
[    1.359718] microcode: CPU0 sig=0x106e5, pf=0x2, revision=0x5
[    1.359725] microcode: CPU1 sig=0x106e5, pf=0x2, revision=0x5
[    1.359733] microcode: CPU2 sig=0x106e5, pf=0x2, revision=0x5
[    1.359740] microcode: CPU3 sig=0x106e5, pf=0x2, revision=0x5
[    1.359747] microcode: CPU4 sig=0x106e5, pf=0x2, revision=0x5
[    1.359754] microcode: CPU5 sig=0x106e5, pf=0x2, revision=0x5
[    1.359760] microcode: CPU6 sig=0x106e5, pf=0x2, revision=0x5
[    1.359766] microcode: CPU7 sig=0x106e5, pf=0x2, revision=0x5
[    1.359801] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.359927] registered taskstats version 1
[    1.359956] zswap: loaded using pool lzo/zbud
[    1.363054] Key type encrypted registered
[    1.363059] AppArmor: AppArmor sha1 policy hashing enabled
[    1.363418]   Magic number: 8:301:996
[    1.363458] memory memory39: hash matches
[    1.363548] rtc_cmos 00:01: setting system clock to 2016-03-29 16:57:39 UTC (1459270659)
[    1.363603] PM: Hibernation image not present or could not be loaded.
[    1.663795] ata3: SATA link down (SStatus 4 SControl 300)
[    1.822372] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.822392] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.822411] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.823096] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-H653G, DW30, max UDMA/100
[    1.823104] ata2.00: applying bridge limits
[    1.823274] ata1.00: ATA-9: WDC WD20EZRX-00D8PB0, 80.00A80, max UDMA/133
[    1.823280] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.824092] ata2.00: configured for UDMA/100
[    1.824380] ata1.00: configured for UDMA/133
[    1.824905] scsi 0:0:0:0: Direct-Access     ATA      WDC WD20EZRX-00D 0A80 PQ: 0 ANSI: 5
[    1.831231] ata5.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    1.831237] ata5.00: 2930277168 sectors, multi 0: LBA48 
[    1.840785] ata5.00: configured for UDMA/133
[    1.846773] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
[    1.846776] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.847255] sd 0:0:0:0: [sda] Write Protect is off
[    1.847262] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.847473] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.847505] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-H653G DW30 PQ: 0 ANSI: 5
[    1.855703] scsi 4:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P 0A01 PQ: 0 ANSI: 5
[    1.882794] sd 4:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    1.883317] sd 4:0:0:0: [sdb] Write Protect is off
[    1.883324] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.883626] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.898471]  sdb: sdb1 sdb2
[    1.900079] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    2.274199] tsc: Refined TSC clocksource calibration: 2792.982 MHz
[    2.274204] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x28425adda3a, max_idle_ns: 440795215496 ns
[    2.775263]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 sda15 sda16 sda17 sda18 sda19 sda20 sda21 sda22 sda23 sda24 sda25 sda26 sda27 sda28 sda29 sda30 sda31 sda32 sda33 sda34 sda35 sda36 sda37 sda38 sda39 sda40 sda41 sda42 sda43 sda44 sda45 sda46 sda47 sda48 sda49 sda50 >
[    2.778716] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.780069] Freeing unused kernel memory: 1628K (ffffffff81f28000 - ffffffff820bf000)
[    2.780071] Write protecting the kernel read-only data: 14336k
[    2.780715] Freeing unused kernel memory: 1200K (ffff8800016d4000 - ffff880001800000)
[    2.782744] Freeing unused kernel memory: 992K (ffff880001d08000 - ffff880001e00000)
[    2.784956] random: systemd urandom read with 45 bits of entropy available
[    2.787474] systemd[1]: systemd 228 running in system mode. (+PAM +AUDIT +SELINUX -IMA +APPARMOR -SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID -ELFUTILS +KMOD +IDN)
[    2.787702] systemd[1]: Detected architecture x86-64.
[    2.787705] systemd[1]: Running in initial RAM disk.
[    2.787726] systemd[1]: Set hostname to <linux-ry46>.
[    2.830358] systemd[1]: Listening on udev Kernel Socket.
[    2.830393] systemd[1]: Reached target Swap.
[    2.830425] systemd[1]: Listening on Journal Socket.
[    2.830453] systemd[1]: Listening on udev Control Socket.
[    2.830463] systemd[1]: Reached target Timers.
[    2.830496] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    2.830506] systemd[1]: Reached target Paths.
[    2.830515] systemd[1]: Reached target Local File Systems.
[    2.830573] systemd[1]: Listening on Journal Audit Socket.
[    2.830596] systemd[1]: Listening on Journal Socket (/dev/log).
[    2.830827] systemd[1]: Created slice System Slice.
[    2.830840] systemd[1]: Reached target Slices.
[    2.842550] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    2.842942] systemd[1]: Started Entropy Daemon based on the HAVEGE algorithm.
[    2.843554] systemd[1]: Starting Load Kernel Modules...
[    2.844149] systemd[1]: Starting dracut cmdline hook...
[    2.844171] systemd[1]: Reached target Sockets.
[    2.844755] systemd[1]: Starting Journal Service...
[    2.845412] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.845467] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    2.845520] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    2.846534] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    2.846809] systemd[1]: Started Load Kernel Modules.
[    2.846832] audit: type=1130 audit(1459270660.980:2): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-modules-load comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.860079] systemd[1]: Starting Apply Kernel Variables...
[    2.860736] systemd[1]: Starting Create Static Device Nodes in /dev...
[    2.862611] systemd[1]: Started Apply Kernel Variables.
[    2.862657] audit: type=1130 audit(1459270660.996:3): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.862903] systemd[1]: Started Create Static Device Nodes in /dev.
[    2.862930] audit: type=1130 audit(1459270660.996:4): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.871229] systemd[1]: Started Journal Service.
[    2.871287] audit: type=1130 audit(1459270661.004:5): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.884768] audit: type=1130 audit(1459270661.016:6): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.888468] audit: type=1130 audit(1459270661.020:7): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.899924] audit: type=1130 audit(1459270661.032:8): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=dracut-pre-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.949665] ACPI: bus type USB registered
[    2.949703] usbcore: registered new interface driver usbfs
[    2.949717] usbcore: registered new interface driver hub
[    2.949758] usbcore: registered new device driver usb
[    2.950385] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.950451] audit: type=1130 audit(1459270661.084:9): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-udev-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.950583] ehci-pci: EHCI PCI platform driver
[    2.951268] scsi host6: ata_generic
[    2.951378] scsi host7: ata_generic
[    2.951420] ata7: PATA max UDMA/100 cmd 0xfe80 ctl 0xfe90 bmdma 0xfef0 irq 18
[    2.951422] ata8: PATA max UDMA/100 cmd 0xfea0 ctl 0xfeb0 bmdma 0xfef8 irq 18
[    2.951945] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.951952] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.951963] ehci-pci 0000:00:1a.0: debug port 2
[    2.955887] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    2.955903] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7fdd000
[    2.966159] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.970818] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.970822] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.970824] usb usb1: Product: EHCI Host Controller
[    2.970826] usb usb1: Manufacturer: Linux 4.5.0-1-default ehci_hcd
[    2.970828] usb usb1: SerialNumber: 0000:00:1a.0
[    2.971012] hub 1-0:1.0: USB hub found
[    2.971025] hub 1-0:1.0: 3 ports detected
[    2.971785] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.971793] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.971805] ehci-pci 0000:00:1d.0: debug port 2
[    2.975756] sr 1:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.975759] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.975895] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.977508] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    2.977524] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7fde000
[    2.986169] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.986212] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.986214] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.986216] usb usb2: Product: EHCI Host Controller
[    2.986217] usb usb2: Manufacturer: Linux 4.5.0-1-default ehci_hcd
[    2.986219] usb usb2: SerialNumber: 0000:00:1d.0
[    2.986360] hub 2-0:1.0: USB hub found
[    2.986368] hub 2-0:1.0: 3 ports detected
[    3.285554] clocksource: Switched to clocksource tsc
[    3.285558] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    3.298239] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    3.315708] random: nonblocking pool is initialized
[    3.414605] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    3.414608] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.414855] hub 1-1:1.0: USB hub found
[    3.414935] hub 1-1:1.0: 6 ports detected
[    3.434561] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    3.434564] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.434726] hub 2-1:1.0: USB hub found
[    3.434809] hub 2-1:1.0: 8 ports detected
[    3.591289] audit: type=1130 audit(1459270661.726:10): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    3.613022] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    3.710122] usb 2-1.5: new low-speed USB device number 3 using ehci-pci
[    3.805874] usb 2-1.5: New USB device found, idVendor=046a, idProduct=0011
[    3.805877] usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.878209] usb 2-1.6: new low-speed USB device number 4 using ehci-pci
[    3.976472] usb 2-1.6: New USB device found, idVendor=046d, idProduct=c050
[    3.976479] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.976483] usb 2-1.6: Product: USB-PS/2 Optical Mouse
[    3.976486] usb 2-1.6: Manufacturer: Logitech
[    9.079515] audit_printk_skb: 42 callbacks suppressed
[    9.079518] audit: type=1130 audit(1459270667.214:25): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.079532] audit: type=1131 audit(1459270667.214:26): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.103284] audit: type=1130 audit(1459270667.238:27): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.103297] audit: type=1131 audit(1459270667.238:28): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.103821] audit: type=1130 audit(1459270667.238:29): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=kmod-static-nodes comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.103832] audit: type=1131 audit(1459270667.238:30): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=kmod-static-nodes comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.120963] audit: type=1130 audit(1459270667.254:31): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=initrd-udevadm-cleanup-db comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.120977] audit: type=1131 audit(1459270667.254:32): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=initrd-udevadm-cleanup-db comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.182971] systemd-journald[157]: Received SIGTERM from PID 1 (systemd).
[   11.208191] audit: type=1130 audit(1459270669.342:33): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=haveged comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   11.208205] audit: type=1131 audit(1459270669.342:34): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=haveged comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   11.690375] EXT4-fs (sdb2): re-mounted. Opts: acl,user_xattr
[   12.265497] systemd-journald[405]: File /var/log/journal/ccd9567dcb1d7c87983a02da56d44567/system.journal corrupted or uncleanly shut down, renaming and replacing.
[   12.428595] systemd-journald[405]: Received request to flush runtime journal from PID 1
[   13.020724] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[   13.020772] ACPI: Power Button [VBTN]
[   13.020839] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   13.020869] ACPI: Power Button [PWRF]
[   13.056751] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   13.097933] wmi: Mapper loaded
[   13.188482] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.225016] EDAC MC: Ver: 3.0.0
[   13.246230] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   13.246919] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   13.308824] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   13.396556] dell_wmi: Detected Dell WMI interface version 1
[   13.396599] input: Dell WMI hotkeys as /devices/virtual/input/input6
[   13.398325] ACPI Warning: SystemIO range 0x0000000000000828-0x000000000000082F conflicts with OpRegion 0x0000000000000828-0x000000000000082D (\GLBC) (20160108/utaddress-255)
[   13.398330] ACPI Warning: SystemIO range 0x0000000000000828-0x000000000000082F conflicts with OpRegion 0x000000000000082A-0x000000000000082A (\SACT) (20160108/utaddress-255)
[   13.398334] ACPI Warning: SystemIO range 0x0000000000000828-0x000000000000082F conflicts with OpRegion 0x0000000000000828-0x0000000000000828 (\SSTS) (20160108/utaddress-255)
[   13.398338] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.398369] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   13.399056] pps_core: LinuxPPS API ver. 1 registered
[   13.399059] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   13.399526] parport_pc 00:02: reported by Plug and Play ACPI
[   13.399592] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,EPP,ECP]
[   13.404400] usbcore: registered new interface driver usbhid
[   13.404402] usbhid: USB HID core driver
[   13.420341] PTP clock support registered
[   13.466453] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[   13.466455] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   13.466978] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   13.524244] iTCO_vendor_support: vendor-support=0
[   13.524812] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   13.524839] iTCO_wdt: Found a Q57 TCO device (Version=2, TCOBASE=0x0860)
[   13.524903] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   13.530310] gpio_ich: GPIO from 436 to 511 on gpio_ich
[   13.539576] input: HID 046a:0011 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/0003:046A:0011.0001/input/input7
[   13.546536] EDAC MC0: Giving out device to module i7core_edac.c controller i7 core #0: DEV 0000:3f:03.0 (POLLED)
[   13.546601] EDAC PCI0: Giving out device to module i7core_edac controller EDAC PCI controller: DEV 0000:3f:03.0 (POLLED)
[   13.546608] EDAC i7core: Driver loaded, 1 memory controller(s) found.
[   13.554307] ppdev: user-space parallel port driver
[   13.594115] hid-generic 0003:046A:0011.0001: input,hidraw0: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:1d.0-1.5/input0
[   13.594230] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/0003:046D:C050.0002/input/input8
[   13.594315] hid-generic 0003:046D:C050.0002: input,hidraw1: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.6/input0
[   13.688310] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) b8:ac:6f:a3:7d:0a
[   13.688316] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[   13.688350] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 9, PBA No: A002FF-0FF
[   13.689107] e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   13.796995] e1000e 0000:02:00.0 eth1: registered PHC clock
[   13.796998] e1000e 0000:02:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 68:05:ca:39:d6:f0
[   13.797001] e1000e 0000:02:00.0 eth1: Intel(R) PRO/1000 Network Connection
[   13.797014] e1000e 0000:02:00.0 eth1: MAC: 3, PHY: 8, PBA No: E46981-008
[   13.995157] [drm] Initialized drm 1.1.0 20060810
[   14.070600] [drm] radeon kernel modesetting enabled.
[   14.091812] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[   14.091814] AMD IOMMUv2 functionality not available on this system
[   14.102323] CRAT table not found
[   14.102325] Finished initializing topology ret=0
[   14.102377] kfd kfd: Initialized module
[   14.103235] [drm] initializing kernel modesetting (RV620 0x1002:0x95C5 0x1028:0x0342).
[   14.103246] [drm] register mmio base: 0xF7DF0000
[   14.103248] [drm] register mmio size: 65536
[   14.103284] ATOM BIOS: 113
[   14.103300] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
[   14.103302] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 0x000000002FFFFFFF
[   14.103304] [drm] Detected VRAM RAM=256M, BAR=256M
[   14.103305] [drm] RAM width 64bits DDR
[   14.103350] [TTM] Zone  kernel: Available graphics memory: 4049602 kiB
[   14.103351] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   14.103352] [TTM] Initializing pool allocator
[   14.103358] [TTM] Initializing DMA pool allocator
[   14.103375] [drm] radeon: 256M of VRAM memory ready
[   14.103377] [drm] radeon: 512M of GTT memory ready.
[   14.103389] [drm] Loading RV620 Microcode
[   14.117873] e1000e 0000:02:00.0 p4p1: renamed from eth1
[   14.123396] snd_hda_codec_realtek hdaudioC0D0: ALC269VB: SKU not ready 0x411111f0
[   14.123921] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC269VB: line_outs=1 (0x1b/0x0/0x0/0x0/0x0) type:line
[   14.123924] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   14.123926] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[   14.123928] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   14.123929] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   14.123932] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x19
[   14.123934] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x18
[   14.130572] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   14.131606] input: HDA Intel MID Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   14.131680] input: HDA Intel MID Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   14.131750] input: HDA Intel MID Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   14.131817] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   14.134046] e1000e 0000:00:19.0 em1: renamed from eth0
[   14.196367] [drm] Internal thermal controller with fan control
[   14.196402] [drm] radeon: power management initialized
[   14.199191] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   14.199632] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[   14.206395] [drm] PCIE GART of 512M enabled (table at 0x0000000000254000).
[   14.206445] radeon 0000:01:00.0: WB enabled
[   14.206448] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000010000c00 and cpu addr 0xffff880211849c00
[   14.207112] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x00000000000521d0 and cpu addr 0xffffc900014121d0
[   14.207113] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   14.207114] [drm] Driver supports precise vblank timestamp query.
[   14.207115] radeon 0000:01:00.0: radeon: MSI limited to 32-bit
[   14.207136] radeon 0000:01:00.0: radeon: using MSI.
[   14.207157] [drm] radeon: irq initialized.
[   14.239071] [drm] ring test on 0 succeeded in 1 usecs
[   14.350006] ssb: Found chip with id 0x4318, rev 0x02 and package 0x00
[   14.350013] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x0D, vendor 0x4243)
[   14.350018] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x09, vendor 0x4243)
[   14.350023] ssb: Core 2 found: PCI (cc 0x804, rev 0x0C, vendor 0x4243)
[   14.350028] ssb: Core 3 found: PCMCIA (cc 0x80D, rev 0x07, vendor 0x4243)
[   14.390038] ssb: Sonics Silicon Backplane found on PCI device 0000:04:02.0
[   14.414023] [drm] ring test on 5 succeeded in 1 usecs
[   14.414032] [drm] UVD initialized successfully.
[   14.414248] [drm] ib test on ring 0 succeeded in 0 usecs
[   14.596603] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
[   14.625990] b43-phy0: Found PHY: Analog 3, Type 2 (G), Revision 7
[   14.626009] b43-phy0: Found Radio: Manuf 0x17F, ID 0x2050, Revision 8, Version 0
[   14.638147] Broadcom 43xx driver loaded [ Features: PNLS ]
[   14.710559] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   14.733144] audit_printk_skb: 63 callbacks suppressed
[   14.733146] audit: type=1130 audit(1459270672.866:56): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-rfkill comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.062075] [drm] ib test on ring 5 succeeded
[   15.062394] [drm] Radeon Display Connectors
[   15.062396] [drm] Connector 0:
[   15.062397] [drm]   DIN-1
[   15.062398] [drm]   Encoders:
[   15.062399] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[   15.062399] [drm] Connector 1:
[   15.062400] [drm]   DVI-I-1
[   15.062401] [drm]   HPD1
[   15.062402] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[   15.062403] [drm]   Encoders:
[   15.062404] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   15.062404] [drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[   15.062405] [drm] Connector 2:
[   15.062406] [drm]   DVI-I-2
[   15.062407] [drm]   HPD2
[   15.062408] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[   15.062408] [drm]   Encoders:
[   15.062409] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[   15.062410] [drm]     DFP1: INTERNAL_UNIPHY
[   15.116631] [drm] fb mappable at 0xE0355000
[   15.116632] [drm] vram apper at 0xE0000000
[   15.116633] [drm] size 8294400
[   15.116634] [drm] fb depth is 24
[   15.116635] [drm]    pitch is 7680
[   15.116816] fbcon: radeondrmfb (fb0) is primary device
[   15.143340] Console: switching to colour frame buffer device 240x67
[   15.147345] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[   15.162060] [drm] Initialized radeon 2.43.0 20080528 for 0000:01:00.0 on minor 0
[   16.305953] floppy0: no floppy controllers found
[   18.502801] audit: type=1130 audit(1459270676.638:57): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-udev-settle comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   18.628761] Adding 8388604k swap on /dev/sda3.  Priority:-1 extents:1 across:8388604k FS
[   19.739096] audit: type=1131 audit(1459270677.874:58): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-rfkill comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   19.741788] audit: type=1130 audit(1459270677.874:59): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-activation-early comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   19.741817] audit: type=1131 audit(1459270677.874:60): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-activation-early comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   19.851564] audit: type=1130 audit(1459270677.986:61): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-activation comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   19.851608] audit: type=1131 audit(1459270677.986:62): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-activation comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   19.979209] audit: type=1130 audit(1459270678.114:63): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD15_optiplx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   20.082343] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[   20.083397] XFS (sdb1): Mounting V5 Filesystem
[   20.291900] XFS (sdb1): Starting recovery (logdev: internal)
[   22.559804] audit: type=1130 audit(1459270680.694:64): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SL12 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   23.003329] EXT4-fs (sda32): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   24.396101] audit: type=1130 audit(1459270682.530:65): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-activation-net comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   24.396118] audit: type=1131 audit(1459270682.530:66): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-activation-net comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   24.871782] audit: type=1130 audit(1459270683.006:67): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SL11SP3 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   24.992189] EXT4-fs (sda26): mounting ext3 file system using the ext4 subsystem
[   25.012711] EXT4-fs (sda26): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   25.066685] audit: type=1130 audit(1459270683.202:68): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_Debian comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   25.285846] XFS (sdb1): Bad dir block magic!
[   25.316146] audit: type=1130 audit(1459270683.450:69): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SLED12 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   25.360240] EXT4-fs (sda39): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   25.368605] audit: type=1130 audit(1459270683.502:70): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_VM_IMG comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   25.439120] EXT4-fs (sda30): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   25.439391] XFS (sda49): Mounting V4 Filesystem
[   25.755628] audit: type=1130 audit(1459270683.890:71): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_13.2 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   26.051706] EXT4-fs (sda16): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   26.081978] XFS (sda49): Ending clean mount
[   26.448027] XFS (sdb1): Ending recovery (logdev: internal)
[   27.568655] audit: type=1130 audit(1459270685.702:72): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SL11DEV comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   27.610753] audit: type=1130 audit(1459270685.746:73): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_MUSIC comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   27.644246] EXT4-fs (sda22): mounting ext3 file system using the ext4 subsystem
[   27.672267] XFS (sda48): Mounting V4 Filesystem
[   28.235188] EXT4-fs (sda22): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   28.236916] XFS (sda48): Ending clean mount
[   29.367420] audit: type=1130 audit(1459270687.502:74): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_BOOT comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   29.484851] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   29.652239] audit: type=1130 audit(1459270687.786:75): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_11.4 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   29.995766] EXT4-fs (sda14): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   31.285159] audit: type=1130 audit(1459270689.418:76): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SLED11 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   31.306398] audit: type=1130 audit(1459270689.442:77): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_DIST comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   31.308955] EXT4-fs (sda29): mounting ext3 file system using the ext4 subsystem
[   31.384396] XFS (sda50): Mounting V4 Filesystem
[   31.520593] EXT4-fs (sda29): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   31.829496] XFS (sda50): Ending clean mount
[   33.175003] audit: type=1130 audit(1459270691.310:78): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SL11SP4 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   33.229142] EXT4-fs (sda27): mounting ext3 file system using the ext4 subsystem
[   33.284536] EXT4-fs (sda27): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   33.493852] audit: type=1130 audit(1459270691.630:79): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SL12DEV comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   33.704382] EXT4-fs (sda23): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   33.759545] audit: type=1130 audit(1459270691.894:80): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_13.1 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   34.081651] EXT4-fs (sda15): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   35.299909] audit: type=1130 audit(1459270693.434:81): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SL11SP2 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   35.346232] EXT4-fs (sda25): mounting ext3 file system using the ext4 subsystem
[   35.387406] EXT4-fs (sda25): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   35.555118] audit: type=1130 audit(1459270693.690:82): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_TW comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   35.759629] EXT4-fs (sda13): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   35.820003] audit: type=1130 audit(1459270693.954:83): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_SL12SP1 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   35.904108] EXT4-fs (sda33): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   36.073661] audit: type=1130 audit(1459270694.210:84): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_42.1 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.094748] audit: type=1130 audit(1459270694.230:85): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-fsck@dev-disk-by\x2dlabel-WD20_WORK comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.137135] EXT4-fs (sda17): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   36.171996] XFS (sda47): Mounting V4 Filesystem
[   36.263812] XFS (sda47): Ending clean mount
[   36.292697] audit: type=1130 audit(1459270694.426:86): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.358176] audit: type=1130 audit(1459270694.494:87): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.358655] audit: type=1130 audit(1459270694.494:88): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=dracut-shutdown comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.383860] audit: type=1127 audit(1459270694.518:89): pid=1021 uid=0 auid=4294967295 ses=4294967295 msg=' comm="systemd-update-utmp" exe="/usr/lib/systemd/systemd-update-utmp" hostname=? addr=? terminal=? res=success'
[   36.400697] audit: type=1130 audit(1459270694.534:90): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-update-utmp comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.648563] audit: type=1130 audit(1459270694.782:91): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=dbus comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.790167] audit: type=1130 audit(1459270694.926:92): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=irqbalance comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.791394] audit: type=1130 audit(1459270694.926:93): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=rc-local comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.791743] audit: type=1130 audit(1459270694.926:94): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=nscd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   36.838579] audit: type=1130 audit(1459270694.974:95): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=wickedd-dhcp4 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   37.033358] No iBFT detected.
[   37.346006] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[   41.118914] e1000e: em1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
[   41.119062] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   41.251972] NET: Registered protocol family 17
[   62.289302] audit_printk_skb: 24 callbacks suppressed
[   62.289307] audit: type=1130 audit(1459270720.426:104): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=wicked comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.541739] audit: type=1130 audit(1459270720.678:105): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=sshd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.889492] audit: type=1130 audit(1459270720.611:106): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=ntpd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.919904] audit: type=1129 audit(1459270720.639:107): pid=1581 uid=0 auid=4294967295 ses=4294967295 msg='old-level=N new-level=3 comm="systemd-update-utmp" exe="/usr/lib/systemd/systemd-update-utmp" hostname=? addr=? terminal=? res=success'
[   62.920963] audit: type=1130 audit(1459270720.639:108): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-update-utmp-runlevel comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   62.920978] audit: type=1131 audit(1459270720.639:109): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-update-utmp-runlevel comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   65.442222] audit: type=2404 audit(1459270723.163:110): pid=1586 uid=0 auid=4294967295 ses=4294967295 msg='op=destroy kind=server fp=c9:88:34:d0:8a:ee:cc:07:58:e9:cb:82:78:28:90:08 [MD5] direction=? spid=1586 suid=0  exe="/usr/sbin/sshd" hostname=? addr=fd00:172:16:0:38da:30c:6dd5:66f4 terminal=? res=success'
[   65.442341] audit: type=2404 audit(1459270723.163:111): pid=1586 uid=0 auid=4294967295 ses=4294967295 msg='op=destroy kind=server fp=ec:bb:cc:b7:3a:dc:74:e1:13:03:aa:2b:81:b0:8c:44 [MD5] direction=? spid=1586 suid=0  exe="/usr/sbin/sshd" hostname=? addr=fd00:172:16:0:38da:30c:6dd5:66f4 terminal=? res=success'
[   65.442596] audit: type=2404 audit(1459270723.163:112): pid=1586 uid=0 auid=4294967295 ses=4294967295 msg='op=destroy kind=server fp=bf:3e:17:14:81:29:58:f9:47:c7:95:68:cf:d4:90:bb [MD5] direction=? spid=1586 suid=0  exe="/usr/sbin/sshd" hostname=? addr=fd00:172:16:0:38da:30c:6dd5:66f4 terminal=? res=success'
[   65.442688] audit: type=2404 audit(1459270723.163:113): pid=1586 uid=0 auid=4294967295 ses=4294967295 msg='op=destroy kind=server fp=12:84:48:01:40:04:70:38:72:54:4f:8b:96:9d:b5:44 [MD5] direction=? spid=1586 suid=0  exe="/usr/sbin/sshd" hostname=? addr=fd00:172:16:0:38da:30c:6dd5:66f4 terminal=? res=success'
[   65.804435] cgroup: cgroup: disabling cgroup2 socket matching due to net_prio or net_cls activation
[  130.489414] XFS (sdb1): _xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000 
[  130.489500] ------------[ cut here ]------------
[  130.489557] WARNING: CPU: 5 PID: 1665 at ../fs/xfs/xfs_buf.c:472 _xfs_buf_find+0x350/0x3b0 [xfs]()
[  130.489559] Modules linked in: af_packet iscsi_ibft iscsi_boot_sysfs xfs libcrc32c arc4 b43 bcma mac80211 cfg80211 rfkill ssb mmc_core pcmcia snd_hda_codec_realtek amdkfd amd_iommu_v2 radeon ttm drm_kms_helper drm fb_sys_fops syscopyarea snd_hda_codec_generic sysfillrect sysimgblt acpi_cpufreq i2c_algo_bit snd_hda_intel snd_hda_codec snd_hda_core ppdev i7core_edac hid_generic gpio_ich iTCO_wdt iTCO_vendor_support snd_hwdep snd_pcm snd_timer snd soundcore e1000e ptp parport_pc pps_core mei_me lpc_ich usbhid dell_wmi 8250_fintek mfd_core coretemp kvm_intel sparse_keymap video i2c_i801 pcspkr tpm_tis edac_core tpm shpchp parport pcmcia_core mei kvm wmi dcdbas button irqbypass crc32c_intel serio_raw sr_mod cdrom ehci_pci ata_generic ehci_hcd usbcore usb_common sg
[  130.489637] CPU: 5 PID: 1665 Comm: rm Not tainted 4.5.0-1-default #1
[  130.489639] Hardware name: Dell Inc. OptiPlex 980                 /0D441T, BIOS A16 05/28/2014
[  130.489642]  0000000000000000 ffff880215edba30 ffffffff81395921 0000000000000000
[  130.489647]  ffffffffa098234b ffff880215edba68 ffffffff8107d912 ffff880212b15700
[  130.489651]  0000000000000008 ffff880212b15700 ffff880215edbb58 0000000000000000
[  130.489656] Call Trace:
[  130.489670]  [<ffffffff8101b175>] try_stack_unwind+0x175/0x190
[  130.489681]  [<ffffffff8101a0c9>] dump_trace+0x69/0x3a0
[  130.489687]  [<ffffffff8101b1db>] show_trace_log_lvl+0x4b/0x60
[  130.489693]  [<ffffffff8101a50c>] show_stack_log_lvl+0x10c/0x180
[  130.489698]  [<ffffffff8101b275>] show_stack+0x25/0x50
[  130.489707]  [<ffffffff81395921>] dump_stack+0x63/0x82
[  130.489715]  [<ffffffff8107d912>] warn_slowpath_common+0x82/0xc0
[  130.489722]  [<ffffffff8107da0a>] warn_slowpath_null+0x1a/0x20
[  130.489766]  [<ffffffffa0941b80>] _xfs_buf_find+0x350/0x3b0 [xfs]
[  130.489824]  [<ffffffffa0941c0a>] xfs_buf_get_map+0x2a/0x2c0 [xfs]
[  130.489876]  [<ffffffffa097026a>] xfs_trans_get_buf_map+0x11a/0x1c0 [xfs]
[  130.489923]  [<ffffffffa0919040>] xfs_btree_get_bufs+0x50/0x60 [xfs]
[  130.489961]  [<ffffffffa090283f>] xfs_alloc_fix_freelist+0x20f/0x3c0 [xfs]
[  130.489999]  [<ffffffffa09031cd>] xfs_free_extent+0x8d/0x110 [xfs]
[  130.490050]  [<ffffffffa0970ea6>] xfs_trans_free_extent+0x26/0x60 [xfs]
[  130.490096]  [<ffffffffa093dc45>] xfs_bmap_finish+0x115/0x130 [xfs]
[  130.490147]  [<ffffffffa095525f>] xfs_itruncate_extents+0xef/0x240 [xfs]
[  130.490196]  [<ffffffffa0955436>] xfs_inactive_truncate+0x86/0xf0 [xfs]
[  130.490244]  [<ffffffffa0956132>] xfs_inactive+0x102/0x120 [xfs]
[  130.490294]  [<ffffffffa095b2f5>] xfs_fs_evict_inode+0xa5/0x110 [xfs]
[  130.490303]  [<ffffffff81225a75>] evict+0xc5/0x190
[  130.490308]  [<ffffffff81225d69>] iput+0x1d9/0x260
[  130.490316]  [<ffffffff8121ab24>] do_unlinkat+0x184/0x2b0
[  130.490325]  [<ffffffff8121b5cb>] SyS_unlinkat+0x1b/0x30
[  130.490333]  [<ffffffff816cbff2>] entry_SYSCALL_64_fastpath+0x16/0x71
[  130.494236] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x16/0x71

[  130.494240] Leftover inexact backtrace:

[  130.494265] ---[ end trace c49eaff485dec326 ]---
[  130.494271] XFS (sdb1): _xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000 
[  130.494350] ------------[ cut here ]------------
[  130.494394] WARNING: CPU: 5 PID: 1665 at ../fs/xfs/xfs_buf.c:472 _xfs_buf_find+0x350/0x3b0 [xfs]()
[  130.494396] Modules linked in: af_packet iscsi_ibft iscsi_boot_sysfs xfs libcrc32c arc4 b43 bcma mac80211 cfg80211 rfkill ssb mmc_core pcmcia snd_hda_codec_realtek amdkfd amd_iommu_v2 radeon ttm drm_kms_helper drm fb_sys_fops syscopyarea snd_hda_codec_generic sysfillrect sysimgblt acpi_cpufreq i2c_algo_bit snd_hda_intel snd_hda_codec snd_hda_core ppdev i7core_edac hid_generic gpio_ich iTCO_wdt iTCO_vendor_support snd_hwdep snd_pcm snd_timer snd soundcore e1000e ptp parport_pc pps_core mei_me lpc_ich usbhid dell_wmi 8250_fintek mfd_core coretemp kvm_intel sparse_keymap video i2c_i801 pcspkr tpm_tis edac_core tpm shpchp parport pcmcia_core mei kvm wmi dcdbas button irqbypass crc32c_intel serio_raw sr_mod cdrom ehci_pci ata_generic ehci_hcd usbcore usb_common sg
[  130.494462] CPU: 5 PID: 1665 Comm: rm Tainted: G        W       4.5.0-1-default #1
[  130.494464] Hardware name: Dell Inc. OptiPlex 980                 /0D441T, BIOS A16 05/28/2014
[  130.494466]  0000000000000000 ffff880215edba30 ffffffff81395921 0000000000000000
[  130.494470]  ffffffffa098234b ffff880215edba68 ffffffff8107d912 ffff880212b15700
[  130.494474]  0000000000000008 ffff880212b15700 ffff880215edbb58 ffff88020bf649c0
[  130.494478] Call Trace:
[  130.494486]  [<ffffffff8101b175>] try_stack_unwind+0x175/0x190
[  130.494495]  [<ffffffff8101a0c9>] dump_trace+0x69/0x3a0
[  130.494500]  [<ffffffff8101b1db>] show_trace_log_lvl+0x4b/0x60
[  130.494506]  [<ffffffff8101a50c>] show_stack_log_lvl+0x10c/0x180
[  130.494511]  [<ffffffff8101b275>] show_stack+0x25/0x50
[  130.494517]  [<ffffffff81395921>] dump_stack+0x63/0x82
[  130.494524]  [<ffffffff8107d912>] warn_slowpath_common+0x82/0xc0
[  130.494530]  [<ffffffff8107da0a>] warn_slowpath_null+0x1a/0x20
[  130.494574]  [<ffffffffa0941b80>] _xfs_buf_find+0x350/0x3b0 [xfs]
[  130.494624]  [<ffffffffa0941dbb>] xfs_buf_get_map+0x1db/0x2c0 [xfs]
[  130.494678]  [<ffffffffa097026a>] xfs_trans_get_buf_map+0x11a/0x1c0 [xfs]
[  130.494725]  [<ffffffffa0919040>] xfs_btree_get_bufs+0x50/0x60 [xfs]
[  130.494761]  [<ffffffffa090283f>] xfs_alloc_fix_freelist+0x20f/0x3c0 [xfs]
[  130.494799]  [<ffffffffa09031cd>] xfs_free_extent+0x8d/0x110 [xfs]
[  130.494851]  [<ffffffffa0970ea6>] xfs_trans_free_extent+0x26/0x60 [xfs]
[  130.494896]  [<ffffffffa093dc45>] xfs_bmap_finish+0x115/0x130 [xfs]
[  130.494947]  [<ffffffffa095525f>] xfs_itruncate_extents+0xef/0x240 [xfs]
[  130.494995]  [<ffffffffa0955436>] xfs_inactive_truncate+0x86/0xf0 [xfs]
[  130.495043]  [<ffffffffa0956132>] xfs_inactive+0x102/0x120 [xfs]
[  130.495093]  [<ffffffffa095b2f5>] xfs_fs_evict_inode+0xa5/0x110 [xfs]
[  130.495100]  [<ffffffff81225a75>] evict+0xc5/0x190
[  130.495105]  [<ffffffff81225d69>] iput+0x1d9/0x260
[  130.495113]  [<ffffffff8121ab24>] do_unlinkat+0x184/0x2b0
[  130.495121]  [<ffffffff8121b5cb>] SyS_unlinkat+0x1b/0x30
[  130.495126]  [<ffffffff816cbff2>] entry_SYSCALL_64_fastpath+0x16/0x71
[  130.498992] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x16/0x71

[  130.498995] Leftover inexact backtrace:

[  130.499026] ---[ end trace c49eaff485dec327 ]---
[  130.499037] BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
[  130.499109] IP: [<ffffffffa0970ad6>] xfs_trans_binval+0x16/0x120 [xfs]
[  130.499171] PGD 0 
[  130.499188] Oops: 0000 [#1] PREEMPT SMP 
[  130.499228] Modules linked in: af_packet iscsi_ibft iscsi_boot_sysfs xfs libcrc32c arc4 b43 bcma mac80211 cfg80211 rfkill ssb mmc_core pcmcia snd_hda_codec_realtek amdkfd amd_iommu_v2 radeon ttm drm_kms_helper drm fb_sys_fops syscopyarea snd_hda_codec_generic sysfillrect sysimgblt acpi_cpufreq i2c_algo_bit snd_hda_intel snd_hda_codec snd_hda_core ppdev i7core_edac hid_generic gpio_ich iTCO_wdt iTCO_vendor_support snd_hwdep snd_pcm snd_timer snd soundcore e1000e ptp parport_pc pps_core mei_me lpc_ich usbhid dell_wmi 8250_fintek mfd_core coretemp kvm_intel sparse_keymap video i2c_i801 pcspkr tpm_tis edac_core tpm shpchp parport pcmcia_core mei kvm wmi dcdbas button irqbypass crc32c_intel serio_raw sr_mod cdrom ehci_pci ata_generic ehci_hcd usbcore usb_common sg
[  130.499902] CPU: 5 PID: 1665 Comm: rm Tainted: G        W       4.5.0-1-default #1
[  130.499940] Hardware name: Dell Inc. OptiPlex 980                 /0D441T, BIOS A16 05/28/2014
[  130.499981] task: ffff8800d37fe340 ti: ffff880215ed8000 task.ti: ffff880215ed8000
[  130.500018] RIP: 0010:[<ffffffffa0970ad6>]  [<ffffffffa0970ad6>] xfs_trans_binval+0x16/0x120 [xfs]
[  130.500090] RSP: 0018:ffff880215edbb48  EFLAGS: 00010292
[  130.500118] RAX: 0000000000000000 RBX: ffff880215edbc50 RCX: 0000000000000003
[  130.500153] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8800376c8880
[  130.500187] RBP: ffff880215edbb68 R08: 0000000000000002 R09: 0000000000000282
[  130.500222] R10: 000000000000000f R11: 00000000000003f5 R12: ffff8800376c8880
[  130.500257] R13: 0000000000000005 R14: 0000000000000000 R15: ffff880215ee8000
[  130.500292] FS:  00007f13ed4cc700(0000) GS:ffff88021fd40000(0000) knlGS:0000000000000000
[  130.500332] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  130.500361] CR2: 00000000000000f8 CR3: 000000020c2eb000 CR4: 00000000000006e0
[  130.500395] Stack:
[  130.500408]  ffff880215edbc50 ffff8800376c8880 0000000000000005 ffff88021fe997c0
[  130.500460]  ffff880215edbc40 ffffffffa090284a ffff8802123cd240 0000000200000000
[  130.500512]  ffffffff376c8850 ffff8802123cd240 0000000000000000 0000000000000000
[  130.500564] Call Trace:
[  130.500600]  [<ffffffffa090284a>] xfs_alloc_fix_freelist+0x21a/0x3c0 [xfs]
[  130.500655]  [<ffffffffa09031cd>] xfs_free_extent+0x8d/0x110 [xfs]
[  130.500713]  [<ffffffffa0970ea6>] xfs_trans_free_extent+0x26/0x60 [xfs]
[  130.500769]  [<ffffffffa093dc45>] xfs_bmap_finish+0x115/0x130 [xfs]
[  130.500827]  [<ffffffffa095525f>] xfs_itruncate_extents+0xef/0x240 [xfs]
[  130.500886]  [<ffffffffa0955436>] xfs_inactive_truncate+0x86/0xf0 [xfs]
[  130.500944]  [<ffffffffa0956132>] xfs_inactive+0x102/0x120 [xfs]
[  130.501000]  [<ffffffffa095b2f5>] xfs_fs_evict_inode+0xa5/0x110 [xfs]
[  130.501035]  [<ffffffff81225a75>] evict+0xc5/0x190
[  130.501062]  [<ffffffff81225d69>] iput+0x1d9/0x260
[  130.501090]  [<ffffffff8121ab24>] do_unlinkat+0x184/0x2b0
[  130.501121]  [<ffffffff8121b5cb>] SyS_unlinkat+0x1b/0x30
[  130.501150]  [<ffffffff816cbff2>] entry_SYSCALL_64_fastpath+0x16/0x71
[  130.503229] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x16/0x71

[  130.503274] Leftover inexact backtrace:

[  130.503302] Code: 5f 74 05 e9 52 ff ff ff e8 5c 25 69 e0 e9 48 ff ff ff 0f 1f 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 49 89 f6 41 54 49 89 fc 53 <4c> 8b ae f8 00 00 00 66 66 66 66 90 41 f6 45 78 04 74 5a 5b 41 
[  130.503738] RIP  [<ffffffffa0970ad6>] xfs_trans_binval+0x16/0x120 [xfs]
[  130.503800]  RSP <ffff880215edbb48>
[  130.503819] CR2: 00000000000000f8
[  130.503844] ---[ end trace c49eaff485dec328 ]---

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--azLHFNyN32YCQGCU--
