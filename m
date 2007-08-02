Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 07:15:22 -0700 (PDT)
Received: from bay0-omc1-s16.bay0.hotmail.com (bay0-omc1-s16.bay0.hotmail.com [65.54.246.88])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l72EFCbm000427
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 07:15:13 -0700
Message-ID: <BAY103-DAV4A7B78FF3C0C90989AE6DB2E90@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>] xfs_bmap_search_multi_extents+0x6f/0xe0)
Date: Thu, 2 Aug 2007 16:14:25 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Marco Berizzi <pupilla@hotmail.com>

Marco Berizzi wrote:

> Hello everybody.
> I'm running linux 2.6.22 on Slackware.
> This box is running openswan 2.4.9
> and squid 2.6S13
> I get tons of these messages:
>
> Jul 20 01:17:09 Gemini kernel: msnt_auth     S 00000000     0  8356
819
> (NOTLB)
> Jul 20 01:17:09 Gemini kernel:        c2bd5d54 00000086 00000001
> 00000000 00000000 00000001 00000000 c11df050
> Jul 20 01:17:09 Gemini kernel:        00000014 c2bd5e24 c2bd5e78
> c2bd5e78 c11df050 c1255b7c c019c63f 00006559
> Jul 20 01:17:09 Gemini kernel:        7601a27a 0002faa4 7fffffff
> 7fffffff c8af2d00 c2bd5db0 c02e9fc6 c2bd5e50
> Jul 20 01:17:09 Gemini kernel: Call Trace:
> Jul 20 01:17:09 Gemini kernel:  [<c019c63f>]
> xfs_bmap_search_multi_extents+0x6f/0xe0
> Jul 20 01:17:09 Gemini kernel:  [<c02e9fc6>]
schedule_timeout+0x96/0xa0
> Jul 20 01:17:09 Gemini kernel:  [<c02e0d09>]
> unix_stream_data_wait+0xa9/0xd0
> Jul 20 01:17:09 Gemini kernel:  [<c0125f60>]
> autoremove_wake_function+0x0/0x50
> Jul 20 01:17:09 Gemini kernel:  [<c0125f60>]
> autoremove_wake_function+0x0/0x50
> Jul 20 01:17:09 Gemini kernel:  [<c02e10ac>]
> unix_stream_recvmsg+0x37c/0x3e0
> Jul 20 01:17:09 Gemini kernel:  [<c026e46d>] do_sock_read+0x9d/0xb0
> Jul 20 01:17:09 Gemini kernel:  [<c026e4f8>] sock_aio_read+0x78/0x80
> Jul 20 01:17:09 Gemini kernel:  [<c01517a0>] do_sync_read+0xc0/0x100
> Jul 20 01:17:09 Gemini kernel:  [<c0125f60>]
> autoremove_wake_function+0x0/0x50
> Jul 20 01:17:09 Gemini kernel:  [<c0145313>] do_mmap_pgoff+0x3f3/0x730
> Jul 20 01:17:09 Gemini kernel:  [<c01518e0>] vfs_read+0x100/0x110
> Jul 20 01:17:09 Gemini kernel:  [<c0151b47>] sys_read+0x47/0x80
> Jul 20 01:17:09 Gemini kernel:  [<c010286e>] syscall_call+0x7/0xb
> Jul 20 01:17:09 Gemini kernel:  =======================
> Jul 20 09:01:35 Gemini kernel: atkbd.c: Spurious NAK on
isa0060/serio0.
> Some program might be trying access hardware directly.
> Jul 20 09:02:05 Gemini kernel: atkbd.c: Spurious NAK on
isa0060/serio0.
> Some program might be trying access hardware directly.
> Jul 20 09:05:39 Gemini kernel: atkbd.c: Spurious ACK on
isa0060/serio0.
> Some program might be trying access hardware directly.
>
> Here is the dmesg and .config output:
>
> Linux version 2.6.22 (root@Gemini) (gcc version 3.3.6) #1 Mon Jul 9
> 13:48:37 CEST 2007
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000000a000000 (usable)
>  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> 160MB LOWMEM available.
> Entering add_active_range(0, 0, 40960) 0 entries of 256 used
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->    40960
> early_node_map[1] active PFN ranges
>     0:        0 ->    40960
> On node 0 totalpages: 40960
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 4064 pages, LIFO batch:0
>   Normal zone: 288 pages used for memmap
>   Normal zone: 36576 pages, LIFO batch:7
> DMI 2.1 present.
> Allocating PCI resources starting at 10000000 (gap: 0a000000:f5ff0000)
> Built 1 zonelists.  Total pages: 40640
> Kernel command line: auto BOOT_IMAGE=Linux ro root=301
> Local APIC disabled by BIOS -- you can enable it with "lapic"
> mapped APIC to ffffd000 (01141000)
> Enabling fast FPU save and restore... done.
> Initializing CPU#0
> PID hash table entries: 1024 (order: 10, 4096 bytes)
> Detected 267.277 MHz processor.
> Console: colour VGA+ 80x25
> Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> Memory: 158964k/163840k available (1965k kernel code, 4444k reserved,
> 626k data, 160k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
>     vmalloc : 0xca800000 - 0xfffb5000   ( 855 MB)
>     lowmem  : 0xc0000000 - 0xca000000   ( 160 MB)
>       .init : 0xc038c000 - 0xc03b4000   ( 160 kB)
>       .data : 0xc02eb718 - 0xc0388300   ( 626 kB)
>       .text : 0xc0100000 - 0xc02eb718   (1965 kB)
> Checking if this processor honours the WP bit even in supervisor
mode...
> Ok.
> Calibrating delay using timer specific routine.. 535.18 BogoMIPS
> (lpj=1070367)
> Mount-cache hash table entries: 512
> CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000
> 00000000 00000000 00000000
> CPU: L1 I cache: 16K, L1 D cache: 16K
> CPU: After all inits, caps: 0183f9ff 00000000 00000000 00000040
00000000
> 00000000 00000000
> Compat vDSO mapped to ffffe000.
> CPU: Intel Celeron (Covington) stepping 00
> Checking 'hlt' instruction... OK.
> ACPI: Core revision 20070126
> ACPI Exception (tbxface-0618): AE_NO_ACPI_TABLES, While loading
> namespace from ACPI tables [20070126]
> ACPI: Unable to load the System Description Tables
> NET: Registered protocol family 16
> PCI: PCI BIOS revision 2.10 entry at 0xfda61, last bus=1
> PCI: Using configuration type 1
> Setting up standard PCI resources
> ACPI: Interpreter disabled.
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI: disabled
> PCI: Probing PCI hardware
> PCI: Probing PCI hardware (bus 00)
> * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
> * this clock source is slow. Consider trying other clock sources
> PCI quirk: region 6100-613f claimed by PIIX4 ACPI
> PCI quirk: region 5f00-5f0f claimed by PIIX4 SMB
> PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:07.0
> PCI: setting IRQ 11 as level-triggered
> PCI: Found IRQ 11 for device 0000:00:07.2
> PCI: Sharing IRQ 11 with 0000:00:0b.0
> Time: tsc clocksource has been installed.
> PCI: Bridge: 0000:00:01.0
>   IO window: b000-bfff
>   MEM window: efe00000-efefffff
>   PREFETCH window: e5c00000-e7cfffff
> NET: Registered protocol family 2
> IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
> TCP: Hash tables configured (established 8192 bind 8192)
> TCP reno registered
> SGI XFS with no debug enabled
> io scheduler noop registered
> io scheduler deadline registered (default)
> Limiting direct PCI/PCI transfers.
> Boot video device is 0000:01:00.0
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with
> idebus=xx
> PIIX4: IDE controller at PCI slot 0000:00:07.1
> PIIX4: chipset revision 1
> PIIX4: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
>     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
> Probing IDE interface ide0...
> hda: QUANTUM FIREBALL EX3.2A, ATA DISK drive
> hda: selected mode 0x42
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Probing IDE interface ide1...
> hda: max request size: 128KiB
> hda: 6306048 sectors (3228 MB) w/418KiB Cache, CHS=6256/16/63,
UDMA(33)
> hda: cache flushes not supported
>  hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 >
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> nf_conntrack version 0.5.0 (1280 buckets, 10240 max)
> ip_tables: (C) 2000-2006 Netfilter Core Team
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> NET: Registered protocol family 15
> Using IPI Shortcut mode
> Filesystem "hda1": Disabling barriers, not supported by the underlying
> device
> XFS mounting filesystem hda1
> Ending clean XFS mount for filesystem: hda1
> VFS: Mounted root (xfs filesystem) readonly.
> Freeing unused kernel memory: 160k freed
> input: AT Translated Set 2 keyboard as /class/input/input0
> Adding 209624k swap on /dev/hda9.  Priority:-1 extents:1
across:209624k
> Filesystem "hda1": Disabling barriers, not supported by the underlying
> device
> Filesystem "hda1": Disabling barriers, not supported by the underlying
> device
> PCI: setting IRQ 9 as level-triggered
> PCI: Found IRQ 9 for device 0000:00:09.0
> 3c59x: Donald Becker and others.
> 0000:00:09.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001de00.
> PCI: setting IRQ 10 as level-triggered
> PCI: Found IRQ 10 for device 0000:00:0a.0
> 0000:00:0a.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001dc00.
> PCI: Found IRQ 11 for device 0000:00:0b.0
> PCI: Sharing IRQ 11 with 0000:00:07.2
> 0000:00:0b.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001da00.
> Filesystem "hda5": Disabling barriers, not supported by the underlying
> device
> XFS mounting filesystem hda5
> Ending clean XFS mount for filesystem: hda5
> Filesystem "hda6": Disabling barriers, not supported by the underlying
> device
> XFS mounting filesystem hda6
> Ending clean XFS mount for filesystem: hda6
> Filesystem "hda7": Disabling barriers, not supported by the underlying
> device
> XFS mounting filesystem hda7
> Ending clean XFS mount for filesystem: hda7
> Filesystem "hda8": Disabling barriers, not supported by the underlying
> device
> XFS mounting filesystem hda8
> Ending clean XFS mount for filesystem: hda8
>
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.22
> # Mon Jul  9 11:57:41 2007
> #
> CONFIG_X86_32=y
> CONFIG_GENERIC_TIME=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_SEMAPHORE_SLEEPERS=y
> CONFIG_X86=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_QUICKLIST=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_DMI=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # Code maturity level options
> #
> # CONFIG_EXPERIMENTAL is not set
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
>
> #
> # General setup
> #
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> # CONFIG_IPC_NS is not set
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_UTS_NS is not set
> # CONFIG_AUDIT is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=14
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> # CONFIG_BLK_DEV_INITRD is not set
> CONFIG_SYSCTL=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
>
> #
> # Loadable module support
> #
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_KMOD is not set
>
> #
> # Block layer
> #
> CONFIG_BLOCK=y
> # CONFIG_LBD is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> # CONFIG_LSF is not set
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_AS is not set
> CONFIG_IOSCHED_DEADLINE=y
> # CONFIG_IOSCHED_CFQ is not set
> # CONFIG_DEFAULT_AS is not set
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
>
> #
> # Processor type and features
> #
> # CONFIG_TICK_ONESHOT is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> # CONFIG_SMP is not set
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_X86_SUMMIT is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_VISWS is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_ES7000 is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> CONFIG_MPENTIUMII=y
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=5
> CONFIG_X86_XADD=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_MODEL=4
> # CONFIG_HPET_TIMER is not set
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_X86_UP_APIC=y
> CONFIG_X86_UP_IOAPIC=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> # CONFIG_X86_REBOOTFIXUPS is not set
> # CONFIG_MICROCODE is not set
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
>
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> # CONFIG_SPARSEMEM_STATIC is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_RESOURCES_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_NR_QUICK=1
> # CONFIG_MATH_EMULATION is not set
> # CONFIG_MTRR is not set
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> # CONFIG_KEXEC is not set
> CONFIG_PHYSICAL_START=0x100000
> CONFIG_PHYSICAL_ALIGN=0x100000
> # CONFIG_COMPAT_VDSO is not set
>
> #
> # Power management options (ACPI, APM)
> #
> CONFIG_PM=y
> # CONFIG_PM_LEGACY is not set
> # CONFIG_PM_DEBUG is not set
> # CONFIG_PM_SYSFS_DEPRECATED is not set
> # CONFIG_SOFTWARE_SUSPEND is not set
>
> #
> # ACPI (Advanced Configuration and Power Interface) Support
> #
> CONFIG_ACPI=y
> # CONFIG_ACPI_SLEEP is not set
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_AC is not set
> # CONFIG_ACPI_BATTERY is not set
> # CONFIG_ACPI_BUTTON is not set
> # CONFIG_ACPI_FAN is not set
> # CONFIG_ACPI_PROCESSOR is not set
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> # CONFIG_APM is not set
>
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
>
> #
> # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_HT_IRQ is not set
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_MCA is not set
> # CONFIG_SCx200 is not set
>
> #
> # PCCARD (PCMCIA/CardBus) support
> #
> # CONFIG_PCCARD is not set
>
> #
> # Executable file formats
> #
> CONFIG_BINFMT_ELF=y
> # CONFIG_BINFMT_AOUT is not set
> # CONFIG_BINFMT_MISC is not set
>
> #
> # Networking
> #
> CONFIG_NET=y
>
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=y
> CONFIG_NET_KEY=y
> CONFIG_INET=y
> # CONFIG_IP_MULTICAST is not set
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> # CONFIG_IP_ROUTE_MULTIPATH_CACHED is not set
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE is not set
> CONFIG_SYN_COOKIES=y
> # CONFIG_INET_AH is not set
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> # CONFIG_INET_XFRM_MODE_BEET is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_IP_VS is not set
> # CONFIG_IPV6 is not set
> # CONFIG_INET6_XFRM_TUNNEL is not set
> # CONFIG_INET6_TUNNEL is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
>
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK_ENABLED=y
> CONFIG_NF_CONNTRACK=y
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CT_PROTO_GRE=m
> # CONFIG_NF_CONNTRACK_AMANDA is not set
> CONFIG_NF_CONNTRACK_FTP=m
> # CONFIG_NF_CONNTRACK_IRC is not set
> CONFIG_NF_CONNTRACK_PPTP=m
> # CONFIG_NF_CONNTRACK_TFTP is not set
> CONFIG_NETFILTER_XTABLES=y
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_MARK=y
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=y
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=y
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=y
> CONFIG_NETFILTER_XT_MATCH_POLICY=y
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
>
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV4=y
> # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=y
> CONFIG_IP_NF_MATCH_IPRANGE=m
> CONFIG_IP_NF_MATCH_TOS=m
> # CONFIG_IP_NF_MATCH_RECENT is not set
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_MATCH_OWNER=m
> CONFIG_IP_NF_MATCH_ADDRTYPE=m
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_REJECT=y
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=y
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_IP_NF_TARGET_SAME=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_FTP=m
> # CONFIG_NF_NAT_IRC is not set
> # CONFIG_NF_NAT_TFTP is not set
> # CONFIG_NF_NAT_AMANDA is not set
> CONFIG_NF_NAT_PPTP=m
> # CONFIG_NF_NAT_H323 is not set
> # CONFIG_NF_NAT_SIP is not set
> CONFIG_IP_NF_MANGLE=y
> CONFIG_IP_NF_TARGET_TOS=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
>
> #
> # QoS and/or fair queueing
> #
> CONFIG_NET_SCHED=y
> CONFIG_NET_SCH_FIFO=y
>
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> # CONFIG_NET_SCH_NETEM is not set
> CONFIG_NET_SCH_INGRESS=m
>
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_ROUTE=y
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=m
> # CONFIG_NET_CLS_RSVP6 is not set
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=m
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=m
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> CONFIG_NET_ACT_IPT=m
> CONFIG_NET_ACT_PEDIT=m
> # CONFIG_NET_ACT_SIMP is not set
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_ESTIMATOR=y
>
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_FIB_RULES=y
>
> #
> # Wireless
> #
> # CONFIG_CFG80211 is not set
> # CONFIG_WIRELESS_EXT is not set
> # CONFIG_IEEE80211 is not set
> # CONFIG_RFKILL is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> # CONFIG_FW_LOADER is not set
> # CONFIG_SYS_HYPERVISOR is not set
>
> #
> # Connector - unified userspace <-> kernelspace linker
> #
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
>
> #
> # Parallel port support
> #
> # CONFIG_PARPORT is not set
>
> #
> # Plug and Play support
> #
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
>
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
>
> #
> # Block devices
> #
> CONFIG_BLK_DEV_FD=m
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
>
> #
> # Misc devices
> #
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> CONFIG_IDE=y
> CONFIG_BLK_DEV_IDE=y
>
> #
> # Please see Documentation/ide.txt for help/info on IDE drives
> #
> # CONFIG_BLK_DEV_IDE_SATA is not set
> # CONFIG_BLK_DEV_HD_IDE is not set
> CONFIG_BLK_DEV_IDEDISK=y
> # CONFIG_IDEDISK_MULTI_MODE is not set
> CONFIG_BLK_DEV_IDECD=m
> # CONFIG_BLK_DEV_IDEFLOPPY is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> # CONFIG_IDE_PROC_FS is not set
>
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> # CONFIG_BLK_DEV_CMD640 is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_SHARE_IRQ=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> # CONFIG_BLK_DEV_IDEDMA_FORCED is not set
> CONFIG_IDEDMA_ONLYDISK=y
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CY82C693 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_CS5535 is not set
> # CONFIG_BLK_DEV_HPT34X is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> CONFIG_BLK_DEV_PIIX=y
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
> # CONFIG_IDE_ARM is not set
> CONFIG_BLK_DEV_IDEDMA=y
> # CONFIG_IDEDMA_IVB is not set
> # CONFIG_BLK_DEV_HD is not set
>
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> # CONFIG_SCSI is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_ATA is not set
>
> #
> # Multi-device support (RAID and LVM)
> #
> # CONFIG_MD is not set
>
> #
> # Fusion MPT device support
> #
> # CONFIG_FUSION is not set
>
> #
> # IEEE 1394 (FireWire) support
> #
>
> #
> # An alternative FireWire stack is available with EXPERIMENTAL=y
> #
> # CONFIG_IEEE1394 is not set
>
> #
> # I2O device support
> #
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
>
> #
> # Network device support
> #
> CONFIG_NETDEVICES=y
> CONFIG_IFB=m
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> # CONFIG_EQUALIZER is not set
> CONFIG_TUN=m
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_PHYLIB is not set
>
> #
> # Ethernet (10 or 100Mbit)
> #
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=m
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> CONFIG_NET_VENDOR_3COM=y
> CONFIG_VORTEX=m
> # CONFIG_TYPHOON is not set
>
> #
> # Tulip family network device support
> #
> # CONFIG_NET_TULIP is not set
> # CONFIG_HP100 is not set
> # CONFIG_NET_PCI is not set
> # CONFIG_NETDEV_1000 is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
>
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> # CONFIG_WLAN_80211 is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
>
> #
> # ISDN subsystem
> #
> # CONFIG_ISDN is not set
>
> #
> # Telephony Support
> #
> # CONFIG_PHONE is not set
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
>
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_TSDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
>
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
>
> #
> # Serial drivers
> #
> # CONFIG_SERIAL_8250 is not set
>
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_LEGACY_PTYS is not set
>
> #
> # IPMI
> #
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_WATCHDOG is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> # CONFIG_RTC is not set
> # CONFIG_GEN_RTC is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_AGP is not set
> # CONFIG_DRM is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_CS5535_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
>
> #
> # TPM devices
> #
> CONFIG_DEVPORT=y
> # CONFIG_I2C is not set
>
> #
> # SPI support
> #
> # CONFIG_SPI is not set
> # CONFIG_SPI_MASTER is not set
>
> #
> # Dallas's 1-wire bus
> #
> # CONFIG_W1 is not set
> # CONFIG_HWMON is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_SM501 is not set
>
> #
> # Multimedia devices
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_DAB is not set
>
> #
> # Graphics support
> #
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
>
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_FB is not set
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> # CONFIG_VIDEO_SELECT is not set
> CONFIG_DUMMY_CONSOLE=y
>
> #
> # Sound
> #
> # CONFIG_SOUND is not set
>
> #
> # HID Devices
> #
> # CONFIG_HID is not set
>
> #
> # USB support
> #
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> # CONFIG_USB is not set
>
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
>
> #
> # USB Gadget Support
> #
> # CONFIG_USB_GADGET is not set
> # CONFIG_MMC is not set
>
> #
> # LED devices
> #
> # CONFIG_NEW_LEDS is not set
>
> #
> # LED drivers
> #
>
> #
> # LED Triggers
> #
>
> #
> # InfiniBand support
> #
> # CONFIG_INFINIBAND is not set
>
> #
> # EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
> #
>
> #
> # Real Time Clock
> #
>
> #
> # DMA Engine support
> #
> # CONFIG_DMA_ENGINE is not set
>
> #
> # DMA Clients
> #
>
> #
> # DMA Devices
> #
>
> #
> # Virtualization
> #
>
> #
> # File systems
> #
> CONFIG_EXT2_FS=m
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> # CONFIG_EXT3_FS is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_FS_POSIX_ACL is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_SECURITY is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_ROMFS_FS is not set
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> CONFIG_DNOTIFY=y
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> # CONFIG_JOLIET is not set
> # CONFIG_ZISOFS is not set
> # CONFIG_UDF_FS is not set
>
> #
> # DOS/FAT/NT Filesystems
> #
> # CONFIG_MSDOS_FS is not set
> # CONFIG_VFAT_FS is not set
> # CONFIG_NTFS_FS is not set
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_RAMFS=y
>
> #
> # Miscellaneous filesystems
> #
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
>
> #
> # Network File Systems
> #
> # CONFIG_NFS_FS is not set
> # CONFIG_NFSD is not set
> # CONFIG_SMB_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
>
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
>
> #
> # Native Language Support
> #
> # CONFIG_NLS is not set
>
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> # CONFIG_PRINTK_TIME is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> # CONFIG_MAGIC_SYSRQ is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_KERNEL is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_X86_FIND_SMP_CONFIG=y
> CONFIG_X86_MPPARSE=y
> CONFIG_DOUBLEFAULT=y
>
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
>
> #
> # Cryptographic options
> #
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> # CONFIG_CRYPTO_WP512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> CONFIG_CRYPTO_BLOWFISH=m
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_586=m
> CONFIG_CRYPTO_SERPENT=m
> # CONFIG_CRYPTO_AES is not set
> CONFIG_CRYPTO_AES_586=y
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_ARC4 is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_DEFLATE=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_TEST is not set
>
> #
> # Hardware crypto devices
> #
> # CONFIG_CRYPTO_DEV_PADLOCK is not set
> # CONFIG_CRYPTO_DEV_GEODE is not set
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=m
> CONFIG_CRC_CCITT=m
> CONFIG_CRC16=m
> # CONFIG_CRC_ITU_T is not set
> CONFIG_CRC32=m
> CONFIG_LIBCRC32C=m
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_KTIME_SCALAR=y

Me again.
Just few minutes ago linux has been definitely
crashed. This is the dmesg:

Aug  2 15:24:36 Gemini kernel: BUG: unable to handle kernel paging
request at virtual address cbb93164
Aug  2 15:24:36 Gemini kernel:  printing eip:
Aug  2 15:24:36 Gemini kernel: c014e83f
Aug  2 15:24:36 Gemini kernel: *pde = 00000000
Aug  2 15:24:36 Gemini kernel: Oops: 0002 [#1]
Aug  2 15:24:36 Gemini kernel: Modules linked in: nf_nat_pptp
nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp
nf_conntrack_ftp 3c59x mii
Aug  2 15:24:36 Gemini kernel: CPU:    0
Aug  2 15:24:36 Gemini kernel: EIP:    0060:[<c014e83f>]    Not tainted
VLI
Aug  2 15:24:36 Gemini kernel: EFLAGS: 00010807   (2.6.22 #1)
Aug  2 15:24:36 Gemini kernel: EIP is at slab_put_obj+0x1f/0x40
Aug  2 15:24:36 Gemini kernel: eax: ffffffff   ebx: c925a000   ecx:
5a2cdcd1   edx: 00a4e452
Aug  2 15:24:36 Gemini kernel: esi: c11ff1e0   edi: c925a000   ebp:
0000000b   esp: c9fe9ed0
Aug  2 15:24:36 Gemini kernel: ds: 007b   es: 007b   fs: 0000  gs: 0000
ss: 0068
Aug  2 15:24:37 Gemini kernel: Process xfssyncd (pid: 223, ti=c9fe8000
task=c11b2a90 task.ti=c9fe8000)
Aug  2 15:24:37 Gemini kernel: Stack: c925a000 c11c06a0 c11ff1e0
c014ec16 00000000 0000003c c11b9010 c11b9010
Aug  2 15:24:37 Gemini kernel:        c11ff1e0 c11ff1e0 00000000
c014ecdf 00000000 0000003c c11b9000 c11b9000
Aug  2 15:24:37 Gemini kernel:        00000246 c11ff1e0 c9a3aaf0
c014f069 c9dce3e0 c9dce3e0 00000001 00000002
Aug  2 15:24:37 Gemini kernel: Call Trace:
Aug  2 15:24:37 Gemini kernel:  [<c014ec16>] free_block+0x86/0x100
Aug  2 15:24:37 Gemini kernel:  [<c014ecdf>] cache_flusharray+0x4f/0xc0
Aug  2 15:24:37 Gemini kernel:  [<c014f069>] kmem_cache_free+0x69/0x90
Aug  2 15:24:37 Gemini kernel:  [<c01be630>] xfs_idestroy+0x40/0x90
Aug  2 15:24:37 Gemini kernel:  [<c01dc683>]
xfs_finish_reclaim+0xb3/0x120
Aug  2 15:24:37 Gemini kernel:  [<c01dc7b9>]
xfs_finish_reclaim_all+0xc9/0xf0
Aug  2 15:24:37 Gemini kernel:  [<c01d6503>] xfs_syncsub+0x63/0x290
Aug  2 15:24:37 Gemini kernel:  [<c02e9f85>] schedule_timeout+0x55/0xa0
Aug  2 15:24:37 Gemini kernel:  [<c01e8572>] vfs_sync+0x22/0x30
Aug  2 15:24:37 Gemini kernel:  [<c01e7bf1>] vfs_sync_worker+0x41/0x50
Aug  2 15:24:37 Gemini kernel:  [<c01e7d09>] xfssyncd+0x109/0x180
Aug  2 15:24:37 Gemini kernel:  [<c01e7c00>] xfssyncd+0x0/0x180
Aug  2 15:24:37 Gemini kernel:  [<c0125b7a>] kthread+0x6a/0x70
Aug  2 15:24:37 Gemini kernel:  [<c0125b10>] kthread+0x0/0x70
Aug  2 15:24:37 Gemini kernel:  [<c0103387>]
kernel_thread_helper+0x7/0x10
Aug  2 15:24:37 Gemini kernel:  =======================
Aug  2 15:24:37 Gemini kernel: Code: 4a 14 c3 89 f6 8d bc 27 00 00 00 00
83 ec 0c 89 74 24 04 89 c6 89 7c 24 08 89 d7 89 1c 24 8b 42 0c 29 c1 89
c8 f7 66 14 8b 47 14 <89> 44 97 1c 8b 1c 24 89 57 14 8b 74 24 04 ff 4f
10 8b 7c 24 08
Aug  2 15:24:37 Gemini kernel: EIP: [<c014e83f>] slab_put_obj+0x1f/0x40
SS:ESP 0068:c9fe9ed0
Aug  2 15:24:40 Gemini kernel: BUG: unable to handle kernel paging
request at virtual address 00100104
Aug  2 15:24:40 Gemini kernel:  printing eip:
Aug  2 15:24:40 Gemini kernel: c014ebf4
Aug  2 15:24:40 Gemini kernel: *pde = 00000000
Aug  2 15:24:40 Gemini kernel: Oops: 0002 [#2]
Aug  2 15:24:40 Gemini kernel: Modules linked in: nf_nat_pptp
nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp
nf_conntrack_ftp 3c59x mii
Aug  2 15:24:40 Gemini kernel: CPU:    0
Aug  2 15:24:40 Gemini kernel: EIP:    0060:[<c014ebf4>]    Not tainted
VLI
Aug  2 15:24:40 Gemini kernel: EFLAGS: 00010082   (2.6.22 #1)
Aug  2 15:24:40 Gemini kernel: EIP is at free_block+0x64/0x100
Aug  2 15:24:40 Gemini kernel: eax: 00100100   ebx: c925a000   ecx:
c925a4ec   edx: 00200200
Aug  2 15:24:40 Gemini kernel: esi: c11c06a0   edi: c11ff1e0   ebp:
0000000b   esp: c11a3f14
Aug  2 15:24:40 Gemini kernel: ds: 007b   es: 007b   fs: 0000  gs: 0000
ss: 0068
Aug  2 15:24:40 Gemini kernel: Process events/0 (pid: 4, ti=c11a2000
task=c1195a50 task.ti=c11a2000)
Aug  2 15:24:40 Gemini kernel: Stack: 00000000 00000018 c11b9010
c11b9010 c11b9000 00000018 c11ff1e0 c014f4e1
Aug  2 15:24:40 Gemini kernel:        00000000 c11c06a0 c11ff1e0
c03cdc20 00000000 c014f55b 00000000 00000000
Aug  2 15:24:40 Gemini kernel:        00038e6b c03cdc20 c117e8a0
c014f500 c01228ea 00005ead 7180abb4 00073f12
Aug  2 15:24:40 Gemini kernel: Call Trace:
Aug  2 15:24:40 Gemini kernel:  [<c014f4e1>] drain_array+0x91/0xb0
Aug  2 15:24:40 Gemini kernel:  [<c014f55b>] cache_reap+0x5b/0x100
Aug  2 15:24:40 Gemini kernel:  [<c014f500>] cache_reap+0x0/0x100
Aug  2 15:24:40 Gemini kernel:  [<c01228ea>] run_workqueue+0x4a/0x100
Aug  2 15:24:40 Gemini kernel:  [<c0122a6b>] worker_thread+0xcb/0x100
Aug  2 15:24:40 Gemini kernel:  [<c0125f60>]
autoremove_wake_function+0x0/0x50
Aug  2 15:24:40 Gemini kernel:  [<c0112387>] __wake_up_common+0x37/0x70
Aug  2 15:24:40 Gemini kernel:  [<c0125f60>]
autoremove_wake_function+0x0/0x50
Aug  2 15:24:40 Gemini kernel:  [<c01229a0>] worker_thread+0x0/0x100
Aug  2 15:24:40 Gemini kernel:  [<c0125b7a>] kthread+0x6a/0x70
Aug  2 15:24:40 Gemini kernel:  [<c0125b10>] kthread+0x0/0x70
Aug  2 15:24:40 Gemini kernel:  [<c0103387>]
kernel_thread_helper+0x7/0x10
Aug  2 15:24:40 Gemini kernel:  =======================
Aug  2 15:24:40 Gemini kernel: Code: da 25 00 40 02 00 3d 00 40 02 00 0f
84 a8 00 00 00 8b 02 a8 80 0f 84 8b 00 00 00 8b 5a 1c 8b 44 24 20 8b 53
04 8b 74 87 4c 8b 03 <89> 50 04 89 02 89 da c7 03 00 01 10 00 c7 43 04
00 02 20 00 8b
Aug  2 15:24:40 Gemini kernel: EIP: [<c014ebf4>] free_block+0x64/0x100
SS:ESP 0068:c11a3f14
Aug  2 15:29:03 Gemini kernel: ------------[ cut here ]------------
Aug  2 15:29:03 Gemini kernel: kernel BUG at mm/slab.c:2980!
Aug  2 15:29:03 Gemini kernel: invalid opcode: 0000 [#3]
Aug  2 15:29:03 Gemini kernel: Modules linked in: nf_nat_pptp
nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp
nf_conntrack_ftp 3c59x mii
Aug  2 15:29:03 Gemini kernel: CPU:    0
Aug  2 15:29:03 Gemini kernel: EIP:    0060:[<c014eb3d>]    Not tainted
VLI
Aug  2 15:29:03 Gemini kernel: EFLAGS: 00010046   (2.6.22 #1)
Aug  2 15:29:03 Gemini kernel: EIP is at cache_alloc_refill+0x16d/0x1c0
Aug  2 15:29:03 Gemini kernel: eax: 0000001c   ebx: 00000005   ecx:
00000036   edx: c11ff1e0
Aug  2 15:29:03 Gemini kernel: esi: c8a40000   edi: c11c06a0   ebp:
c11b9000   esp: c8da7dc8
Aug  2 15:29:03 Gemini kernel: ds: 007b   es: 007b   fs: 0000  gs: 0033
ss: 0068
Aug  2 15:29:03 Gemini kernel: Process unlinkd (pid: 2476, ti=c8da6000
task=c11b3ab0 task.ti=c8da6000)
Aug  2 15:29:03 Gemini kernel: Stack: c9fb1400 c11c06a8 00000036
00000250 c11ff1e0 00000286 c11ff1e0 00000250
Aug  2 15:29:03 Gemini kernel:        c11ff1e0 c014ed8f 00000000
00000001 c01de776 c9fb1400 00025638 c01c5554
Aug  2 15:29:03 Gemini kernel:        c6355800 c9fb1400 c11ff1e0
c64340d4 c01de805 c6355800 c9fb1400 00000004
Aug  2 15:29:03 Gemini kernel: Call Trace:
Aug  2 15:29:03 Gemini kernel:  [<c014ed8f>] kmem_cache_alloc+0x3f/0x50
Aug  2 15:29:03 Gemini kernel:  [<c01de776>] kmem_zone_alloc+0x46/0xc0
Aug  2 15:29:03 Gemini kernel:  [<c01c5554>] xfs_log_reserve+0xa4/0xb0
Aug  2 15:29:03 Gemini kernel:  [<c01de805>] kmem_zone_zalloc+0x15/0x50
Aug  2 15:29:03 Gemini kernel:  [<c01c108d>]
xfs_inode_item_init+0x1d/0x80
Aug  2 15:29:03 Gemini kernel:  [<c01d3c1f>] xfs_trans_ijoin+0x6f/0x80
Aug  2 15:29:03 Gemini kernel:  [<c01da4b3>] xfs_remove+0x1c3/0x460
Aug  2 15:29:03 Gemini kernel:  [<c01e51b3>] xfs_vn_unlink+0x23/0x60
Aug  2 15:29:03 Gemini kernel:  [<c01d447b>]
xfs_dir_lookup_int+0x9b/0x100
Aug  2 15:29:03 Gemini kernel:  [<c01d2c78>]
xfs_trans_unlocked_item+0x38/0x60
Aug  2 15:29:03 Gemini kernel:  [<c01d9a4a>] xfs_lookup+0x6a/0x80
Aug  2 15:29:03 Gemini kernel:  [<c01619f0>] d_instantiate+0x30/0x50
Aug  2 15:29:03 Gemini kernel:  [<c0161ccd>] d_splice_alias+0x2d/0xa0
Aug  2 15:29:03 Gemini kernel:  [<c0157c99>] permission+0x89/0xd0
Aug  2 15:29:03 Gemini kernel:  [<c015a7a8>] vfs_unlink+0x88/0x90
Aug  2 15:29:03 Gemini kernel:  [<c015a844>] do_unlinkat+0x94/0x110
Aug  2 15:29:03 Gemini kernel:  [<c01518c8>] vfs_read+0xe8/0x110
Aug  2 15:29:03 Gemini kernel:  [<c0151b47>] sys_read+0x47/0x80
Aug  2 15:29:03 Gemini kernel:  [<c010286e>] syscall_call+0x7/0xb
Aug  2 15:29:03 Gemini kernel:  =======================
Aug  2 15:29:03 Gemini kernel: Code: d2 0f 84 cb fe ff ff eb ba 8b 55 00
31 c0 85 d2 75 b1 eb c0 8b 47 08 89 70 04 89 06 8b 44 24 04 89 77 08 89
46 04 e9 7a ff ff ff <0f> 0b 90 eb fe c7 47 30 01 00 00 00 8b 77 10 8d
47 10 39 c6 0f
Aug  2 15:29:03 Gemini kernel: EIP: [<c014eb3d>]
cache_alloc_refill+0x16d/0x1c0 SS:ESP 0068:c8da7dc8
