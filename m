Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F3A17F59
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 18:47:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B6CB304032
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:47:44 -0800 (PST)
Received: from fftw.org (216.119.142.145.static.a2webhosting.com
	[216.119.142.145]) by cuda.sgi.com with ESMTP id
	UMIgOdZZrqLwKFE3 (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 16:47:39 -0800 (PST)
Received: from c-24-62-102-245.hsd1.ma.comcast.net ([24.62.102.245] helo=amd)
	by fftw.org with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80) (envelope-from <athena@fftw.org>) id 1UA8hm-0002qy-Qi
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 19:47:39 -0500
Received: from athena by amd with local (Exim 4.80)
	(envelope-from <athena@fftw.org>) id 1UA8hg-0004Xl-Fs
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 19:47:32 -0500
From: Matteo Frigo <athena@fftw.org>
Subject: [BUG] Internal error xfs_dir2_data_reada_verify
Date: Mon, 25 Feb 2013 19:47:32 -0500
Message-ID: <87d2vnc34r.fsf@fftw.org>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

For some reason XFS reliably crashes for me when used in conjunction
with LVM2's pvmove.  The error reliably appears when removing a large
number of files from a volume that is being pvmove'd at the same time.
I am using vanilla kernel 3.8.  A typical kernel message looks like the
following:

   [  262.396471] ffff88001ecfb000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   [  262.398314] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
   [  262.398314] 
   [  262.398740] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
   [  262.398742] Call Trace:
   [  262.398767]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
   [  262.398777]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
   [  262.398792]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
   [  262.398801]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
   [  262.398809]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
   [  262.398814]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
   [  262.398831]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
   [  262.398834]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
   [  262.398837]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
   [  262.398840]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
   [  262.398842]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
   [  262.398846]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
   [  262.398848]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
   [  262.398850] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
   [  262.399089] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 117 numblks 8

I have observed the problem with vanilla kernels 3.8 and 3.4.33, and
with CentOS 6.3 using the CentOS variant of 2.6.32.  I have observed the
problem on various virtual machines using debian wheezy/sid and Fedora
18, and on at least three physical machines.  Even though the kernel
reports "Corruption detected", xfs_repair appears to be able to fix any
problems, so I haven't actually lost any data.  The problem goes away
after stopping pvmove.

HOW TO REPRODUCE: I created a virtual machine with debian sid and two
virtual disks /dev/vdb and /dev/vdc.  Then, the following script
reliably triggers the failure.  

    pvcreate /dev/vd[bc]
    vgcreate test /dev/vd[bc]
    lvcreate -L 8G -n vol test /dev/vdb
    mkfs.xfs -f /dev/mapper/test-vol
    mount -o noatime /dev/mapper/test-vol /mnt
    cd /mnt
    git clone ~/linux-stable
    cd /
    umount /mnt

    mount -o noatime /dev/mapper/test-vol /mnt
    pvmove -b /dev/vdb /dev/vdc
    sleep 2
    rm -rf /mnt/linux-stable

The ~/linux-stable directory contains a copy of the linux git tree.
"git clone" is just a convenient excuse to create many files quickly.
The "rm" command is the one that actually triggers the errors.  In
addition to the kernel messages, the "rm" command reports various I/O
errors.

I have observed the problem even without unmounting and re-mounting the
file system, but it appears that the umount/mount sequence makes the
problem 100% reproducible.

I am not implying that this is an xfs bug---it may well be a dm bug for
all I know.  However, the same test completes correctly using ext4
instead of xfs, suggesting that dm is working in at least some cases.

Thanks for your attention.
Regards,
Matteo Frigo

Rest of the email: full dmesg log.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0 (root@amd) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Mon Feb 25 16:38:42 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0 root=/dev/mapper/sid64-root ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x1fffdfff]
[    0.000000]  [mem 0x00000000-0x1fdfffff] page 2M
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x1fffdfff @ [mem 0x1fffb000-0x1fffdfff]
[    0.000000] RAMDISK: [mem 0x1ea11000-0x1f56dfff]
[    0.000000] ACPI: RSDP 00000000000fd980 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe4b0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe4f0 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffff800 00735 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffff6e0 00078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffff6a0 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1fff7000-0x1fffafff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1ffef001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e200000-ffff88001e9fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130957
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1736 pages used for memmap
[    0.000000]   DMA32 zone: 125238 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88001fc00000 s83968 r8192 d22528 u2097152
[    0.000000] pcpu-alloc: s83968 r8192 d22528 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] kvm-clock: cpu 0, msr 0:1ffef001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1fc0df40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 129159
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0 root=/dev/mapper/sid64-root ro quiet
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 495352k/524280k available (3588k kernel code, 452k absent, 28476k reserved, 3143k data, 616k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:33024 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3600.260 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 7200.52 BogoMIPS (lpj=14401040)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] Security Framework initialized
[    0.004000] AppArmor: AppArmor disabled by boot time parameter
[    0.004000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys devices
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys net_cls
[    0.004000] Initializing cgroup subsys blkio
[    0.004000] Initializing cgroup subsys perf_event
[    0.004000] mce: CPU supports 10 MCE banks
[    0.004000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.004000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.004000] tlb_flushall_shift: -1
[    0.008850] Freeing SMP alternatives: 8k freed
[    0.009810] ACPI: Core revision 20121018
[    0.011915] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.011918] smpboot: CPU0: AMD QEMU Virtual CPU version 1.1.2 (fam: 06, model: 02, stepping: 03)
[    0.012000] Performance Events: Broken PMU hardware detected, using software events only.
[    0.012000] Failed to access perfctr msr (MSR c0010001 is ffffffffffffffff)
[    0.012000] Brought up 1 CPUs
[    0.012000] smpboot: Total of 1 processors activated (7200.52 BogoMIPS)
[    0.012000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.012000] devtmpfs: initialized
[    0.012000] regulator-dummy: no parameters
[    0.012000] NET: Registered protocol family 16
[    0.012000] ACPI: bus type pci registered
[    0.012000] PCI: Using configuration type 1 for base access
[    0.012000] bio: create slab <bio-0> at 0
[    0.012009] ACPI: Added _OSI(Module Device)
[    0.012012] ACPI: Added _OSI(Processor Device)
[    0.012014] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.012015] ACPI: Added _OSI(Processor Aggregator Device)
[    0.012414] ACPI: EC: Look up EC in DSDT
[    0.013837] ACPI: Interpreter enabled
[    0.013840] ACPI: (supports S0 S3 S4 S5)
[    0.013854] ACPI: Using IOAPIC for interrupt routing
[    0.016521] ACPI: No dock devices found.
[    0.016525] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.016598] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.016600] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.016916] pci_root PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.016918] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.017032] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.017061] PCI host bridge to bus 0000:00
[    0.017064] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.017066] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.017068] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.017070] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.017072] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.017110] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.017360] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.017723] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.019403] pci 0000:00:01.1: reg 20: [io  0xc120-0xc12f]
[    0.020100] pci 0000:00:01.2: [8086:7020] type 00 class 0x0c0300
[    0.021759] pci 0000:00:01.2: reg 20: [io  0xc100-0xc11f]
[    0.022492] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.022806] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.022815] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.022939] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.024516] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.025513] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.030864] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.031097] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.031732] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.032331] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.035383] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.035491] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.036354] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.037020] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.040570] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.041299] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.041965] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.045617] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.046344] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.047013] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.050849] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.054000] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.054078] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.054145] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.054212] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.054251] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.054470] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.054472] vgaarb: loaded
[    0.054473] vgaarb: bridge control possible 0000:00:02.0
[    0.054555] PCI: Using ACPI for IRQ routing
[    0.054560] PCI: pci_cache_line_size set to 64 bytes
[    0.054714] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.054718] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[    0.054939] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.054955] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.054958] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.059157] Switching to clocksource kvm-clock
[    0.059167] pnp: PnP ACPI init
[    0.059167] ACPI: bus type pnp registered
[    0.059167] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.059167] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.059167] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.059167] pnp 00:03: [dma 2]
[    0.059167] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.059167] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.059167] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.059167] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.059167] pnp: PnP ACPI: found 7 devices
[    0.059167] ACPI: ACPI bus type pnp unregistered
[    0.065071] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.065073] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.065076] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.065078] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.065120] NET: Registered protocol family 2
[    0.065289] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[    0.065336] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
[    0.065380] TCP: Hash tables configured (established 4096 bind 4096)
[    0.065422] TCP: reno registered
[    0.065429] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.065437] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.065497] NET: Registered protocol family 1
[    0.065515] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.065533] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.065551] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.065681] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.065779] pci 0000:00:02.0: Boot video device
[    0.065817] PCI: CLS 0 bytes, default 64
[    0.065861] Unpacking initramfs...
[    0.303659] Freeing initrd memory: 11636k freed
[    0.306981] audit: initializing netlink socket (disabled)
[    0.306999] type=2000 audit(1361829867.304:1): initialized
[    0.319970] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.320229] VFS: Disk quotas dquot_6.5.2
[    0.320249] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.320330] msgmni has been set to 990
[    0.320571] alg: No test for stdrng (krng)
[    0.320585] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.320587] io scheduler noop registered
[    0.320589] io scheduler deadline registered
[    0.320598] io scheduler cfq registered (default)
[    0.320669] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.320684] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.320685] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.320751] acpiphp: Slot [3] registered
[    0.320772] acpiphp: Slot [4] registered
[    0.320786] acpiphp: Slot [5] registered
[    0.320799] acpiphp: Slot [6] registered
[    0.320819] acpiphp: Slot [7] registered
[    0.320839] acpiphp: Slot [8] registered
[    0.320853] acpiphp: Slot [9] registered
[    0.320868] acpiphp: Slot [10] registered
[    0.320887] acpiphp: Slot [11] registered
[    0.320901] acpiphp: Slot [12] registered
[    0.320914] acpiphp: Slot [13] registered
[    0.320927] acpiphp: Slot [14] registered
[    0.320941] acpiphp: Slot [15] registered
[    0.320955] acpiphp: Slot [16] registered
[    0.320977] acpiphp: Slot [17] registered
[    0.320994] acpiphp: Slot [18] registered
[    0.321013] acpiphp: Slot [19] registered
[    0.321028] acpiphp: Slot [20] registered
[    0.321041] acpiphp: Slot [21] registered
[    0.321060] acpiphp: Slot [22] registered
[    0.321079] acpiphp: Slot [23] registered
[    0.321093] acpiphp: Slot [24] registered
[    0.321106] acpiphp: Slot [25] registered
[    0.321124] acpiphp: Slot [26] registered
[    0.321143] acpiphp: Slot [27] registered
[    0.321157] acpiphp: Slot [28] registered
[    0.321170] acpiphp: Slot [29] registered
[    0.321189] acpiphp: Slot [30] registered
[    0.321203] acpiphp: Slot [31] registered
[    0.321350] GHES: HEST is not enabled!
[    0.321399] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.342838] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.343239] Linux agpgart interface v0.103
[    0.343361] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.344040] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.344045] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.344162] mousedev: PS/2 mouse device common for all mice
[    0.344407] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.344596] rtc_cmos 00:00: RTC can wake from S4
[    0.344830] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.344930] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    0.344941] cpuidle: using governor ladder
[    0.344942] cpuidle: using governor menu
[    0.344966] drop_monitor: Initializing network drop monitor service
[    0.345025] TCP: cubic registered
[    0.345055] NET: Registered protocol family 10
[    0.345299] mip6: Mobile IPv6
[    0.345301] NET: Registered protocol family 17
[    0.345319] Key type dns_resolver registered
[    0.345504] PM: Hibernation image not present or could not be loaded.
[    0.345515] registered taskstats version 1
[    0.345853] rtc_cmos 00:00: setting system clock to 2013-02-25 22:04:26 UTC (1361829866)
[    0.346879] Freeing unused kernel memory: 616k freed
[    0.347104] Write protecting the kernel read-only data: 6144k
[    0.348762] Freeing unused kernel memory: 496k freed
[    0.350824] Freeing unused kernel memory: 568k freed
[    0.364161] udevd[48]: starting version 175
[    0.390368] ACPI: bus type usb registered
[    0.390396] usbcore: registered new interface driver usbfs
[    0.390407] usbcore: registered new interface driver hub
[    0.391957] virtio-pci 0000:00:04.0: setting latency timer to 64
[    0.394624] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    0.394627] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.407852] SCSI subsystem initialized
[    0.412558] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.412608] virtio-pci 0000:00:05.0: setting latency timer to 64
[    0.414012] ACPI: bus type scsi registered
[    0.417434] usbcore: registered new device driver usb
[    0.417901] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.418225] uhci_hcd: USB Universal Host Controller Interface driver
[    0.419073] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.419101] e1000 0000:00:03.0: setting latency timer to 64
[    0.422991] libata version 3.00 loaded.
[    0.442630] Floppy drive(s): fd0 is 1.44M
[    0.715082] FDC 0 is a S82078B
[    0.715784] microcode: AMD CPU family 0x6 not supported
[    0.744644] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 00:00:10:00:03:35
[    0.744650] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.744716] uhci_hcd 0000:00:01.2: setting latency timer to 64
[    0.744724] uhci_hcd 0000:00:01.2: UHCI Host Controller
[    0.744730] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
[    0.744823] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c100
[    0.744880] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    0.744883] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.744884] usb usb1: Product: UHCI Host Controller
[    0.744886] usb usb1: Manufacturer: Linux 3.8.0 uhci_hcd
[    0.744888] usb usb1: SerialNumber: 0000:00:01.2
[    0.744973] hub 1-0:1.0: USB hub found
[    0.744976] hub 1-0:1.0: 2 ports detected
[    0.745485] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.745513] virtio-pci 0000:00:06.0: setting latency timer to 64
[    0.746626] ata_piix 0000:00:01.1: version 2.13
[    0.746708] ata_piix 0000:00:01.1: setting latency timer to 64
[    0.750145] scsi0 : ata_piix
[    0.752263] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    0.752283] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    0.753905] scsi1 : ata_piix
[    0.753974] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc120 irq 14
[    0.753976] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc128 irq 15
[    0.754767]  vda: vda1
[    0.755342] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    0.755361] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    0.756297]  vdb: unknown partition table
[    0.756797] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    0.756816] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    0.757597]  vdc: unknown partition table
[    0.908495] ata2.01: NODEV after polling detection
[    0.908759] ata2.00: ATAPI: QEMU DVD-ROM, 1.1.2, max UDMA/100
[    0.909177] ata2.00: configured for MWDMA2
[    0.909593] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.1. PQ: 0 ANSI: 5
[    0.914306] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    0.914310] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.914568] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    0.916489] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    0.930165] microcode: AMD CPU family 0x6 not supported
[    0.936101] device-mapper: uevent: version 1.0.3
[    0.936365] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    0.955614] bio: create slab <bio-1> at 1
[    0.990652] Btrfs loaded
[    1.001712] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    1.002996] XFS (dm-0): Mounting Filesystem
[    1.031619] XFS (dm-0): Ending clean mount
[    1.056042] usb 1-1: new full-speed USB device number 2 using uhci_hcd
[    1.216120] udevd[319]: starting version 175
[    1.265451] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.265457] ACPI: Power Button [PWRF]
[    1.301619] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    1.304081] tsc: Refined TSC clocksource calibration: 3600.247 MHz
[    1.305425] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    1.382415] parport_pc 00:04: reported by Plug and Play ACPI
[    1.382530] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    1.408969] microcode: AMD CPU family 0x6 not supported
[    1.430425] kvm: Nested Virtualization enabled
[    1.452960] usb 1-1: New USB device found, idVendor=0627, idProduct=0001
[    1.452963] usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=5
[    1.452966] usb 1-1: Product: QEMU USB Tablet
[    1.452967] usb 1-1: Manufacturer: QEMU 1.1.2
[    1.452969] usb 1-1: SerialNumber: 42
[    1.460485] WARNING! power/level is deprecated; use power/control instead
[    1.472190] usbcore: registered new interface driver usbhid
[    1.472192] usbhid: USB HID core driver
[    1.478627] input: QEMU 1.1.2 QEMU USB Tablet as /devices/pci0000:00/0000:00:01.2/usb1/1-1/1-1:1.0/input/input3
[    1.478793] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU 1.1.2 QEMU USB Tablet] on usb-0000:00:01.2-1/input0
[    1.672383] loop: module loaded
[    1.769023] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    2.395545] RPC: Registered named UNIX socket transport module.
[    2.395548] RPC: Registered udp transport module.
[    2.395549] RPC: Registered tcp transport module.
[    2.395551] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.398426] FS-Cache: Loaded
[    2.402241] FS-Cache: Netfs 'nfs' registered for caching
[    2.407269] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.455733] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.456496] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    4.456951] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  108.159748] btrfs: open /dev/dm-1 failed
[  108.181132] XFS (dm-1): Mounting Filesystem
[  108.184399] XFS (dm-1): Ending clean mount
[  115.145225] XFS (dm-1): Mounting Filesystem
[  115.148471] XFS (dm-1): Ending clean mount
[  147.335234] btrfs: open /dev/dm-1 failed
[  243.978751] btrfs: open /dev/dm-1 failed
[  243.988387] XFS (dm-1): Mounting Filesystem
[  243.991540] XFS (dm-1): Ending clean mount
[  260.095682] XFS (dm-1): Mounting Filesystem
[  260.200925] XFS (dm-1): Ending clean mount
[  260.218760] bio: create slab <bio-2> at 2
[  260.247525] btrfs: open /dev/dm-2 failed
[  260.378126] btrfs: open /dev/dm-1 failed
[  262.396471] ffff88001ecfb000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.398314] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.398314] 
[  262.398740] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.398742] Call Trace:
[  262.398767]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.398777]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.398792]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.398801]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.398809]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.398814]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.398831]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.398834]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.398837]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.398840]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.398842]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.398846]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.398848]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.398850] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.399089] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.399402] ffff88001ecfb000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.399684] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.399684] 
[  262.400124] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.400126] Call Trace:
[  262.400137]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.400153]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.400167]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.400176]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.400185]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.400188]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.400196]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.400199]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.400202]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.400204]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.400206]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.400209]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.400211]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.400213] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.400448] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.401880] ffff88001bb6d000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.402161] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.402161] 
[  262.402550] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.402552] Call Trace:
[  262.402568]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.402578]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.402592]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.402601]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.402609]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.402613]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.402622]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.402625]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.402627]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.402630]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.402632]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.402635]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.402637]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.402639] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.403041] XFS (dm-1): metadata I/O error: block 0x5285b8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.403699] ffff88001bb6d000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.404414] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.404414] 
[  262.405338] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.405339] Call Trace:
[  262.405351]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.405360]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.405377]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.405386]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.405395]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.405398]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.405407]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.405410]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.405412]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.405415]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.405417]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.405420]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.405422]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.405424] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.405910] XFS (dm-1): metadata I/O error: block 0x5285b8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.421759] ffff880001a88000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.422389] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.422389] 
[  262.423282] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.423283] Call Trace:
[  262.423308]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.423318]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.423332]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.423341]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.423349]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.423354]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.423363]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.423366]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.423369]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.423371]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.423374]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.423378]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.423380]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.423382] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.423783] XFS (dm-1): metadata I/O error: block 0x54f2b0 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.424486] ffff880001a88000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.425114] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.425114] 
[  262.426019] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.426020] Call Trace:
[  262.426031]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.426040]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.426054]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.426062]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.426071]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.426074]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.426083]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.426086]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.426088]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.426090]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.426093]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.426095]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.426098]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.426099] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.426499] XFS (dm-1): metadata I/O error: block 0x54f2b0 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.436206] ffff88001bb6a000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.436839] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.436839] 
[  262.437747] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.437748] Call Trace:
[  262.437764]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.437773]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.437787]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.437796]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.437805]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.437808]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.437817]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.437820]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.437823]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.437825]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.437827]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.437830]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.437833]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.437834] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.438241] XFS (dm-1): metadata I/O error: block 0x554eb8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.438919] ffff88001bb6a000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.439618] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.439618] 
[  262.440575] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.440576] Call Trace:
[  262.440588]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.440597]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.440610]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.440619]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.440628]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.440631]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.440639]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.440642]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.440645]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.440647]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.440649]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.440652]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.440654]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.440656] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.441067] XFS (dm-1): metadata I/O error: block 0x554eb8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.442003] ffff88001d9dc000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.442629] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.442629] 
[  262.443548] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.443549] Call Trace:
[  262.443563]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.443573]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.443586]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.443595]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.443604]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.443607]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.443616]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.443618]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.443621]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.443623]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.443626]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.443629]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.443631]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.443633] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.444073] XFS (dm-1): metadata I/O error: block 0x564ee0 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.444751] ffff88001d9dc000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.445412] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.445412] 
[  262.446333] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.446334] Call Trace:
[  262.446346]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.446355]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.446368]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.446377]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.446386]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.446389]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.446397]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.446400]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.446402]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.446405]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.446407]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.446410]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.446412]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.446414] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.446820] XFS (dm-1): metadata I/O error: block 0x564ee0 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.447731] ffff88001f366000: 80 91 9f 1d 00 88 ff ff 80 0f 62 81 ff ff ff ff  ..........b.....
[  262.448394] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.448394] 
[  262.449325] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.449326] Call Trace:
[  262.449339]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.449349]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.449362]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.449371]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.449380]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.449383]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.449392]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.449394]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.449397]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.449399]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.449402]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.449404]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.449407]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.449409] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.449821] XFS (dm-1): metadata I/O error: block 0xc0c460 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.450504] ffff88001f366000: 80 91 9f 1d 00 88 ff ff 80 0f 62 81 ff ff ff ff  ..........b.....
[  262.451198] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.451198] 
[  262.452153] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.452154] Call Trace:
[  262.452165]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.452174]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.452187]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.452196]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.452205]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.452207]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.452216]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.452219]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.452221]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.452224]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.452226]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.452229]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.452236]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.452238] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.452648] XFS (dm-1): metadata I/O error: block 0xc0c460 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.453592] ffff88001d068000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.454226] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.454226] 
[  262.455150] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.455152] Call Trace:
[  262.455165]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.455174]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.455187]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.455196]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.455205]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.455208]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.455217]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.455219]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.455222]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.455224]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.455227]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.455229]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.455232]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.455233] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.455638] XFS (dm-1): metadata I/O error: block 0x815188 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.456352] ffff88001d068000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.457032] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.457032] 
[  262.457942] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.457943] Call Trace:
[  262.457955]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.457965]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.457981]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.457991]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.458000]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.458003]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.458013]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.458016]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.458018]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.458021]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.458023]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.458026]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.458028]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.458030] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.458435] XFS (dm-1): metadata I/O error: block 0x815188 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.459333] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.459731] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.460153] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.460551] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.460947] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.461343] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.461739] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.462135] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.462531] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.462924] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.463316] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.463709] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.464124] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.464521] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.464918] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.465314] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.465714] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.466111] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.466508] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.466901] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.467297] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.467700] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.468115] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.468510] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.468904] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.469300] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.469697] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.470094] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.470490] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.470887] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.471280] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.471674] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.472116] XFS (dm-1): metadata I/O error: block 0xc32c10 ("xfs_trans_read_buf_map") error 117 numblks 16
[  262.472863] XFS (dm-1): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
[  262.473755] ffff88001d060000: c0 e1 98 1b 00 88 ff ff 80 0f 62 81 ff ff ff ff  ..........b.....
[  262.474389] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.474389] 
[  262.475299] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.475301] Call Trace:
[  262.475317]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.475327]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.475340]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.475349]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.475358]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.475362]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.475371]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.475373]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.475376]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.475378]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.475381]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.475384]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.475386]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.475388] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.475795] XFS (dm-1): metadata I/O error: block 0x83da70 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.476511] ffff88001d060000: c0 e1 98 1b 00 88 ff ff 80 0f 62 81 ff ff ff ff  ..........b.....
[  262.477145] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.477145] 
[  262.478086] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.478087] Call Trace:
[  262.478099]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.478107]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.478121]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.478129]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.478138]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.478141]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.478150]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.478153]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.478160]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.478162]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.478165]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.478167]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.478170]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.478171] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.478580] XFS (dm-1): metadata I/O error: block 0x83da70 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.479328] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.479728] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.480144] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.480536] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.480926] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.481317] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.481708] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.482100] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.482491] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.482882] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.483269] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.483657] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.484076] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.484507] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.495244] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.495640] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.496050] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.496442] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.496833] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.497224] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.497615] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.498010] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.498403] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.498795] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.499189] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.499585] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.499979] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.500385] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.500778] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.501170] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.501561] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.501956] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.502627] XFS (dm-1): metadata I/O error: block 0x58a500 ("xfs_trans_read_buf_map") error 117 numblks 16
[  262.503358] XFS (dm-1): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
[  262.504029] ffff88001f022000: c0 e8 8f 1b 00 88 ff ff 80 0f 62 81 ff ff ff ff  ..........b.....
[  262.504691] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.504691] 
[  262.505624] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.505625] Call Trace:
[  262.505642]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.505652]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.505665]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.505674]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.505683]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.505687]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.505696]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.505698]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.505701]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.505709]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.505712]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.505715]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.505717]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.505719] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.506159] XFS (dm-1): metadata I/O error: block 0x5905a8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.506987] XFS (dm-1): metadata I/O error: block 0x5905a8 ("xfs_trans_read_buf_map") error 11 numblks 8
[  262.508939] ffff88001f368000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.509587] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.509587] 
[  262.510502] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.510503] Call Trace:
[  262.510521]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.510530]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.510544]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.510553]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.510561]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.510565]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.510574]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.510577]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.510579]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.510582]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.510585]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.510588]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.510590]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.510592] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.511065] XFS (dm-1): metadata I/O error: block 0x8489a8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.511893] XFS (dm-1): metadata I/O error: block 0x8489a8 ("xfs_trans_read_buf_map") error 11 numblks 8
[  262.513631] ffff88001f1e6000: 40 30 96 1b 00 88 ff ff 80 0f 62 81 ff ff ff ff  @0........b.....
[  262.514306] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.514306] 
[  262.515230] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.515232] Call Trace:
[  262.515250]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.515260]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.515273]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.515282]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.515291]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.515295]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.515304]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.515306]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.515309]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.515311]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.515314]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.515317]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.515319]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.515321] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.515759] XFS (dm-1): metadata I/O error: block 0xc3afc0 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.516611] XFS (dm-1): metadata I/O error: block 0xc3afc0 ("xfs_trans_read_buf_map") error 11 numblks 8
[  262.518318] ffff88001d0f1000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.518972] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.518972] 
[  262.519891] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.519892] Call Trace:
[  262.519909]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.519925]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.519948]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.519957]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.519966]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.519970]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.519978]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.519981]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.519984]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.519986]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.519989]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.519992]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.519994]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.519996] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.520492] XFS (dm-1): metadata I/O error: block 0x5905e0 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.521283] XFS (dm-1): metadata I/O error: block 0x5905e0 ("xfs_trans_read_buf_map") error 11 numblks 8
[  262.523252] ffff88001f1bc000: 80 f7 24 1f 00 88 ff ff 80 0f 62 81 ff ff ff ff  ..$.......b.....
[  262.523909] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.523909] 
[  262.524864] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.524866] Call Trace:
[  262.524884]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.524893]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.524907]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.524916]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.524925]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.524929]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.524937]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.524940]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.524943]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.524945]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.524948]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.524950]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.524953]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.524955] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.525393] XFS (dm-1): metadata I/O error: block 0x8489b8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.526286] XFS (dm-1): metadata I/O error: block 0x8489b8 ("xfs_trans_read_buf_map") error 11 numblks 8
[  262.528055] ffff88001bb05000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.528709] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.528709] 
[  262.529625] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.529627] Call Trace:
[  262.529645]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.529655]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.529669]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.529677]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.529686]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.529690]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.529699]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.529702]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.529704]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.529707]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.529710]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.529713]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.529715]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.529717] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.530204] XFS (dm-1): metadata I/O error: block 0xc3b070 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.530979] XFS (dm-1): metadata I/O error: block 0xc3b070 ("xfs_trans_read_buf_map") error 11 numblks 8
[  262.532861] ffff88001d188000: 00 00 00 03 00 00 00 00 31 eb ea 6a 4f 01 c2 58  ........1..jO..X
[  262.533546] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.533546] 
[  262.534473] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.534474] Call Trace:
[  262.534491]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.534500]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.534514]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.534523]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.534531]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.534535]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.534544]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.534547]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.534549]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.534552]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.534555]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.534558]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.534560]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.534562] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.534997] XFS (dm-1): metadata I/O error: block 0x84e248 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.535834] XFS (dm-1): metadata I/O error: block 0x84e248 ("xfs_trans_read_buf_map") error 11 numblks 8
[  262.537624] ffff88001dad4000: 00 00 00 03 00 00 00 00 00 00 00 00 01 00 00 00  ................
[  262.538353] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.538353] 
[  262.539307] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.539309] Call Trace:
[  262.539328]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.539338]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.539352]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.539361]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.539370]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.539374]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.539383]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.539386]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.539388]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.539391]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.539393]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.539396]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.539399]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.539400] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.539879] XFS (dm-1): metadata I/O error: block 0x593ee8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.540749] ffff88001fbe3000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  262.541451] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.541451] 
[  262.542343] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.542345] Call Trace:
[  262.542361]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.542371]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.542385]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.542393]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.542402]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.542406]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.542415]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.542425]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.542428]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.542430]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.542433]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.542435]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.542438]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.542440] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.542886] XFS (dm-1): metadata I/O error: block 0x593ee8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.543922] ffff88001daa6000: 00 00 00 03 00 00 00 00 10 00 00 00 00 1e 00 00  ................
[  262.544588] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.544588] 
[  262.545512] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.545513] Call Trace:
[  262.545528]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.545538]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.545551]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.545560]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.545569]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.545572]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.545581]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.545584]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.545586]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.545588]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.545591]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.545594]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.545596]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.545598] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.546013] XFS (dm-1): metadata I/O error: block 0x593f40 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.546679] ffff88001daa6000: 00 00 00 03 00 00 00 00 10 00 00 00 00 1e 00 00  ................
[  262.547302] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.547302] 
[  262.548254] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.548255] Call Trace:
[  262.548265]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.548274]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.548287]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.548296]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.548305]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.548308]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.548317]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.548319]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.548322]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.548324]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.548326]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.548329]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.548331]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.548333] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.548760] XFS (dm-1): metadata I/O error: block 0x593f40 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.550144] ffff880012406000: 00 00 00 03 00 00 00 00 02 00 00 00 00 00 00 00  ................
[  262.550777] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.550777] 
[  262.551792] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.551793] Call Trace:
[  262.551807]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.551817]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.551830]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.551839]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.551853]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.551856]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.551865]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.551868]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.551871]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.551873]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.551876]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.551878]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.551881]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.551883] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.552326] XFS (dm-1): metadata I/O error: block 0xc3fca8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.553007] ffff880012406000: 00 00 00 03 00 00 00 00 02 00 00 00 00 00 00 00  ................
[  262.553702] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.553702] 
[  262.554623] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.554624] Call Trace:
[  262.554636]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.554645]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.554658]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.554667]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.554676]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.554679]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.554688]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.554690]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.554693]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.554695]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.554698]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.554700]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.554702]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.554704] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.555114] XFS (dm-1): metadata I/O error: block 0xc3fca8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.556098] ffff880012506000: 00 00 00 03 69 00 00 00 4e 49 a4 81 02 02 00 00  ....i...NI......
[  262.556725] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.556725] 
[  262.557640] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.557641] Call Trace:
[  262.557654]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.557664]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.557677]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.557686]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.557694]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.557698]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.557707]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.557709]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.557712]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.557714]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.557717]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.557720]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.557722]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.557724] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.558130] XFS (dm-1): metadata I/O error: block 0x84f4a8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.558807] ffff880012506000: 00 00 00 03 69 00 00 00 4e 49 a4 81 02 02 00 00  ....i...NI......
[  262.559469] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.559469] 
[  262.560415] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.560416] Call Trace:
[  262.560432]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.560442]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.560455]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.560464]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.560473]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.560476]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.560485]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.560487]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.560490]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.560492]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.560495]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.560497]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.560499]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.560501] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.560908] XFS (dm-1): metadata I/O error: block 0x84f4a8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.562310] ffff88001db1f000: 00 00 00 03 ed e0 2b 51 40 8b 23 0c ed e0 2b 51  ......+Q@.#...+Q
[  262.562943] XFS (dm-1): Internal error xfs_dir2_data_reada_verify at line 226 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa01eb42d
[  262.562943] 
[  262.563845] Pid: 134, comm: kworker/0:1H Not tainted 3.8.0 #1
[  262.563846] Call Trace:
[  262.563862]  [<ffffffffa01ed225>] ? xfs_corruption_error+0x54/0x6f [xfs]
[  262.563871]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.563885]  [<ffffffffa02194c5>] ? xfs_dir2_data_reada_verify+0x76/0x88 [xfs]
[  262.563894]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.563902]  [<ffffffffa01eb42d>] ? xfs_buf_iodone_work+0x2e/0x5c [xfs]
[  262.563906]  [<ffffffff81053399>] ? process_one_work+0x16d/0x2c5
[  262.563915]  [<ffffffffa01eb3ff>] ? xfs_buf_relse+0x12/0x12 [xfs]
[  262.563917]  [<ffffffff810537b4>] ? worker_thread+0x117/0x1b1
[  262.563920]  [<ffffffff8105369d>] ? rescuer_thread+0x187/0x187
[  262.563922]  [<ffffffff81056f6c>] ? kthread+0x81/0x89
[  262.563925]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.563927]  [<ffffffff8137d93c>] ? ret_from_fork+0x7c/0xb0
[  262.563930]  [<ffffffff81056eeb>] ? __kthread_parkme+0x5c/0x5c
[  262.563932] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
[  262.564479] XFS (dm-1): metadata I/O error: block 0xc42598 ("xfs_trans_read_buf_map") error 117 numblks 8
[  262.565297] XFS (dm-1): metadata I/O error: block 0xc42598 ("xfs_trans_read_buf_map") error 11 numblks 8


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
