Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 00:21:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5I7LlsN021244
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:21:47 -0700
Received: from bay0-omc3-s27.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8B6D1037CDC
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:22:41 -0700 (PDT)
Received: from bay0-omc3-s27.bay0.hotmail.com (bay0-omc3-s27.bay0.hotmail.com [65.54.246.227]) by cuda.sgi.com with ESMTP id ms7KwnGVla6cKEsX for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:22:41 -0700 (PDT)
Message-ID: <BAY103-DAV69C6DA19A8910BC1A438BB2AB0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Fw: 2.6.26-rc6 link count mismatch for inode
Date: Wed, 18 Jun 2008 09:22:03 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Marco Berizzi wrote:

> Hi Folk,
>
> I was tring to compile firefox 3.0rc3
> and while I was erasing a previous
> /tmp/mozilla tree, I started a new
> tar xjf mozilla-blabla.
> After a while linux 2.6.26-rc6 was
> unresponsive: I have unplugged the
> power cable. No problem at startup,
> but:

sorry folks,

is there any news about this problem?

> root@Venus:/tmp# rm -r mozilla/
> rm: cannot remove `mozilla//netwerk/build/.deps': No such file or
> directory
> rm: cannot remove `mozilla//netwerk/resources/content/CVS': No such
file
> or directory
>
> root@Venus:/tmp/mozilla/netwerk# rm -r build
> rm: cannot remove `build/.deps': No such file or directory
> root@Venus:/tmp/mozilla/netwerk# cd build/
> root@Venus:/tmp/mozilla/netwerk/build# rm -r .deps
> rm: cannot remove `.deps': No such file or directory
> root@Venus:/tmp/mozilla/netwerk/build# ls -fl
> /bin/ls: cannot access .deps: No such file or directory
> total 0
> drwxr-xr-x 3 root root 18 2008-06-16 10:03 ./
> drwxr-xr-x 4 root root 34 2008-06-16 10:03 ../
> ?????????? ? ?    ?     ?                ? .deps
>
> so, I have checked the filesystem with:
> xfs_check /dev/sda2:
>
> bad format 1 for inode 70353 type 0
> bad format 2 for inode 98831 type 0
> agi unlinked bucket 13 is 10573 in ag 0 (inode=10573)
> agi unlinked bucket 6 is 1309318 in ag 1 (inode=18086534)
> agi unlinked bucket 7 is 1309319 in ag 1 (inode=18086535)
> agi unlinked bucket 40 is 471720 in ag 2 (inode=34026152)
> bad format 1 for inode 85450805 type 0
> bad format 2 for inode 85450806 type 0
> bad format 2 for inode 85450807 type 0
> bad format 2 for inode 85450808 type 0
> bad format 2 for inode 85450809 type 0
> block 0/6279 type unknown not expected
> block 0/6280 type unknown not expected
> block 0/6281 type unknown not expected
> block 0/6282 type unknown not expected
> block 0/6283 type unknown not expected
> block 0/6284 type unknown not expected
> block 0/6285 type unknown not expected
> block 5/97840 type unknown not expected
> block 5/97841 type unknown not expected
> block 5/97842 type unknown not expected
> block 5/97843 type unknown not expected
> link count mismatch for inode 70353 (name ?), nlink 0, counted 1
> allocated inode 98831 has 0 link count
> allocated inode 10573 has 0 link count
> allocated inode 18086534 has 0 link count
> allocated inode 18086535 has 0 link count
> link count mismatch for inode 19893187 (name ?), nlink 3, counted 2
> allocated inode 34026152 has 0 link count
> link count mismatch for inode 67179727 (name ?), nlink 3, counted 2
> link count mismatch for inode 85450805 (name ?), nlink 0, counted 1
> allocated inode 85450806 has 0 link count
> allocated inode 85450807 has 0 link count
> allocated inode 85450808 has 0 link count
> allocated inode 85450809 has 0 link count
>
> I have not run xfs_repair. If anyone
> need ssh access to the box just drop
> me a message.
>
> Metadump available at:
>
> http://80.204.235.230/metadump.bin.bz2
>
> and xfs_check verbose:
>
> http://80.204.235.230/xfs_check_log.bz2
>
> Linux Venus 2.6.26-rc6 #1 SMP PREEMPT Fri Jun 13 13:01:19 CEST 2008
i686
> Intel(R
> ) Core(TM)2 Duo CPU     T8100  @ 2.10GHz GenuineIntel GNU/Linux
>
> Gnu C                  4.2.3
> Gnu make               3.81
> binutils               2.17.50.0.17.20070615
> util-linux             2.13.1
> mount                  2.13.1
> module-init-tools      3.4
> e2fsprogs              1.40.8
> xfsprogs               2.9.7
> pcmciautils            014
> PPP                    2.4.4
> Linux C Library        2.7
> Dynamic linker (ldd)   2.7
> Linux C++ Library      6.0.9
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.2
> Sh-utils               6.9
> Modules Loaded         ext2 snd_seq_oss snd_seq_device
> snd_seq_midi_event snd_se
> q snd_pcm_oss snd_mixer_oss snd_hda_intel snd_pcm snd_timer snd
> soundcore snd_pa
> ge_alloc pcmcia crc32 yenta_socket rsrc_nonstatic pcmcia_core battery
ac
> ppp_syn
> ctty ppp_deflate zlib_deflate zlib_inflate ppp_async crc_ccitt
bsd_comp
> ppp_gene
> ric slhc intel_agp ohci_hcd option usbserial usbcore tg3 psmouse
>
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.26-rc6
> # Fri Jun 13 13:13:53 2008
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> # CONFIG_GENERIC_LOCKBREAK is not set
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> # CONFIG_GENERIC_GPIO is not set
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> # CONFIG_GENERIC_TIME_VSYSCALL is not set
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_AOUT=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_X86_SMP=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_X86_TRAMPOLINE=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # General setup
> #
> # CONFIG_EXPERIMENTAL is not set
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=14
> # CONFIG_CGROUPS is not set
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> # CONFIG_SYSFS_DEPRECATED_V2 is not set
> # CONFIG_RELAY is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> # CONFIG_BLK_DEV_INITRD is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_SYSCTL_SYSCALL_CHECK=y
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_COMPAT_BRK=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> # CONFIG_PROFILING is not set
> # CONFIG_MARKERS is not set
> CONFIG_HAVE_OPROFILE=y
> # CONFIG_KPROBES is not set
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> # CONFIG_HAVE_DMA_ATTRS is not set
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_KMOD is not set
> CONFIG_STOP_MACHINE=y
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
> # CONFIG_IOSCHED_DEADLINE is not set
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_AS is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_CLASSIC_RCU=y
>
> #
> # Processor type and features
> #
> # CONFIG_TICK_ONESHOT is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_X86_SUMMIT is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_VISWS is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_ES7000 is not set
> # CONFIG_X86_RDC321X is not set
> # CONFIG_X86_VSMP is not set
> # CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
> # CONFIG_PARAVIRT_GUEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
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
> # CONFIG_MPSC is not set
> CONFIG_MCORE2=y
> # CONFIG_GENERIC_CPU is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_CPU=y
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_XADD=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_P6_NOP=y
> CONFIG_X86_TSC=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=6
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_NR_CPUS=2
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> # CONFIG_PREEMPT_RCU is not set
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
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> # CONFIG_SPARSEMEM_STATIC is not set
> # CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_RESOURCES_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_HIGHPTE is not set
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> # CONFIG_X86_PAT is not set
> # CONFIG_EFI is not set
> # CONFIG_IRQBALANCE is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> # CONFIG_SCHED_HRTICK is not set
> # CONFIG_KEXEC is not set
> CONFIG_PHYSICAL_START=0x100000
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_COMPAT_VDSO is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>
> #
> # Power management options
> #
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_PROCFS_POWER=y
> # CONFIG_ACPI_SYSFS_POWER is not set
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_THERMAL=m
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_SBS=m
>
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> # CONFIG_CPU_IDLE is not set
>
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_LEGACY is not set
> # CONFIG_HT_IRQ is not set
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_MCA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_OLPC is not set
> CONFIG_PCCARD=m
> # CONFIG_PCMCIA_DEBUG is not set
> CONFIG_PCMCIA=m
> # CONFIG_PCMCIA_IOCTL is not set
> CONFIG_CARDBUS=y
>
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_PD6729=m
> CONFIG_I82092=m
> CONFIG_PCCARD_NONSTATIC=m
> # CONFIG_HOTPLUG_PCI is not set
>
> #
> # Executable file formats / Emulations
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
> CONFIG_NET_KEY=m
> CONFIG_INET=y
> # CONFIG_IP_MULTICAST is not set
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE=m
> CONFIG_SYN_COOKIES=y
> # CONFIG_INET_AH is not set
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> # CONFIG_INET_XFRM_MODE_BEET is not set
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_IP_VS is not set
> # CONFIG_IPV6 is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
>
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CT_PROTO_UDPLITE=m
> CONFIG_NF_CONNTRACK_AMANDA=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_H323=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_PPTP=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NF_CT_NETLINK=m
> CONFIG_NETFILTER_XTABLES=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_RATEEST=m
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_OWNER=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_RATEEST=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_TIME=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
>
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV4=m
> # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_RECENT=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_MATCH_ADDRTYPE=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_NF_NAT_SNMP_BASIC=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_PROTO_UDPLITE=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NF_NAT_AMANDA=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_NF_NAT_H323=m
> CONFIG_NF_NAT_SIP=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> CONFIG_NET_SCHED=y
>
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_RR=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
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
> CONFIG_NET_CLS_FLOW=m
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
> CONFIG_NET_ACT_NAT=m
> CONFIG_NET_ACT_PEDIT=m
> # CONFIG_NET_ACT_SIMP is not set
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_SCH_FIFO=y
>
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=m
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_FIB_RULES=y
>
> #
> # Wireless
> #
> # CONFIG_CFG80211 is not set
> # CONFIG_WIRELESS_EXT is not set
> # CONFIG_MAC80211 is not set
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
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> # CONFIG_FW_LOADER is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
>
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_MISC_DEVICES is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=m
> # CONFIG_BLK_DEV_IDE is not set
> # CONFIG_BLK_DEV_HD_ONLY is not set
> # CONFIG_BLK_DEV_HD is not set
>
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_SCSI_PROC_FS is not set
>
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=m
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
>
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
>
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_PMP is not set
> CONFIG_SATA_AHCI=y
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> # CONFIG_SATA_SVW is not set
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_NV is not set
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_PATA_ACPI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_PCMCIA is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_MD is not set
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
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> # CONFIG_NETDEVICES_MULTIQUEUE is not set
> CONFIG_IFB=m
> CONFIG_DUMMY=m
> # CONFIG_BONDING is not set
> # CONFIG_EQUALIZER is not set
> CONFIG_TUN=m
> # CONFIG_VETH is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_NET_ETHERNET is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_E1000E_ENABLED is not set
> # CONFIG_IGB is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> CONFIG_TIGON3=m
> CONFIG_BNX2=m
> # CONFIG_QLA3XXX is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
>
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> # CONFIG_WLAN_80211 is not set
> # CONFIG_IWLWIFI_LEDS is not set
>
> #
> # USB Network Adapters
> #
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_NET_PCMCIA is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> CONFIG_PPP=m
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_BSDCOMP=m
> # CONFIG_SLIP is not set
> CONFIG_SLHC=m
> # CONFIG_NET_FC is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
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
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=m
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_PCSPKR=m
> # CONFIG_INPUT_WISTRON_BTNS is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_UINPUT is not set
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
> # CONFIG_DEVKMEM is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
>
> #
> # Serial drivers
> #
> # CONFIG_SERIAL_8250 is not set
> CONFIG_FIX_EARLYCON_MEM=y
>
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> # CONFIG_RTC is not set
> # CONFIG_GEN_RTC is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
>
> #
> # PCMCIA character devices
> #
> # CONFIG_SYNCLINK_CS is not set
> # CONFIG_CARDMAN_4000 is not set
> # CONFIG_CARDMAN_4040 is not set
> # CONFIG_IPWIRELESS is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_CS5535_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> CONFIG_DEVPORT=y
> # CONFIG_I2C is not set
> # CONFIG_SPI is not set
> # CONFIG_W1 is not set
> # CONFIG_POWER_SUPPLY is not set
> # CONFIG_HWMON is not set
> CONFIG_THERMAL=m
> # CONFIG_WATCHDOG is not set
>
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB_POSSIBLE=y
> # CONFIG_SSB is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
>
> #
> # Multimedia devices
> #
>
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_VIDEO_MEDIA is not set
>
> #
> # Multimedia drivers
> #
> # CONFIG_DAB is not set
>
> #
> # Graphics support
> #
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=m
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_DRM=m
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> CONFIG_DRM_I810=m
> CONFIG_DRM_I830=m
> CONFIG_DRM_I915=m
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
>
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
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
> CONFIG_SOUND=m
>
> #
> # Advanced Linux Sound Architecture
> #
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_SEQUENCER=m
> CONFIG_SND_SEQ_DUMMY=m
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_SEQUENCER_OSS=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
>
> #
> # Generic devices
> #
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_DUMMY=m
> CONFIG_SND_VIRMIDI=m
> CONFIG_SND_MTPAV=m
> CONFIG_SND_SERIAL_U16550=m
> CONFIG_SND_MPU401=m
>
> #
> # PCI devices
> #
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> # CONFIG_SND_HDA_HWDEP is not set
> # CONFIG_SND_HDA_CODEC_REALTEK is not set
> CONFIG_SND_HDA_CODEC_ANALOG=y
> # CONFIG_SND_HDA_CODEC_SIGMATEL is not set
> # CONFIG_SND_HDA_CODEC_VIA is not set
> # CONFIG_SND_HDA_CODEC_ATIHDMI is not set
> # CONFIG_SND_HDA_CODEC_CONEXANT is not set
> # CONFIG_SND_HDA_CODEC_CMEDIA is not set
> # CONFIG_SND_HDA_CODEC_SI3054 is not set
> CONFIG_SND_HDA_GENERIC=y
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_HIFIER is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SIS7019 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
>
> #
> # USB devices
> #
> # CONFIG_SND_USB_AUDIO is not set
> # CONFIG_SND_USB_USX2Y is not set
> # CONFIG_SND_USB_CAIAQ is not set
>
> #
> # PCMCIA devices
> #
> # CONFIG_SND_VXPOCKET is not set
> # CONFIG_SND_PDAUDIOCF is not set
>
> #
> # System on Chip audio support
> #
> # CONFIG_SND_SOC is not set
>
> #
> # ALSA SoC audio for Freescale SOCs
> #
>
> #
> # SoC Audio for the Texas Instruments OMAP
> #
>
> #
> # Open Sound System
> #
> # CONFIG_SOUND_PRIME is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=m
> # CONFIG_HID_DEBUG is not set
> # CONFIG_HIDRAW is not set
>
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=m
> # CONFIG_USB_HIDINPUT_POWERBOOK is not set
> # CONFIG_USB_HIDDEV is not set
>
> #
> # USB HID Boot Protocol drivers
> #
> # CONFIG_USB_KBD is not set
> # CONFIG_USB_MOUSE is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=m
> # CONFIG_USB_DEBUG is not set
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
>
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_SUSPEND is not set
>
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_EHCI_HCD=m
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_OHCI_HCD=m
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=m
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
>
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> # CONFIG_USB_PRINTER is not set
> # CONFIG_USB_WDM is not set
>
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
>
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_DPCM is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_LIBUSUAL is not set
>
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> # CONFIG_USB_MON is not set
>
> #
> # USB port drivers
> #
> CONFIG_USB_SERIAL=m
> # CONFIG_USB_EZUSB is not set
> # CONFIG_USB_SERIAL_GENERIC is not set
> # CONFIG_USB_SERIAL_AIRCABLE is not set
> CONFIG_USB_SERIAL_AIRPRIME=m
> # CONFIG_USB_SERIAL_ARK3116 is not set
> # CONFIG_USB_SERIAL_BELKIN is not set
> # CONFIG_USB_SERIAL_CH341 is not set
> # CONFIG_USB_SERIAL_WHITEHEAT is not set
> # CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
> # CONFIG_USB_SERIAL_CP2101 is not set
> # CONFIG_USB_SERIAL_CYPRESS_M8 is not set
> # CONFIG_USB_SERIAL_EMPEG is not set
> # CONFIG_USB_SERIAL_FTDI_SIO is not set
> # CONFIG_USB_SERIAL_FUNSOFT is not set
> # CONFIG_USB_SERIAL_VISOR is not set
> # CONFIG_USB_SERIAL_IPAQ is not set
> # CONFIG_USB_SERIAL_IR is not set
> # CONFIG_USB_SERIAL_EDGEPORT is not set
> # CONFIG_USB_SERIAL_EDGEPORT_TI is not set
> # CONFIG_USB_SERIAL_GARMIN is not set
> # CONFIG_USB_SERIAL_IPW is not set
> # CONFIG_USB_SERIAL_IUU is not set
> # CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
> # CONFIG_USB_SERIAL_KEYSPAN is not set
> # CONFIG_USB_SERIAL_KLSI is not set
> # CONFIG_USB_SERIAL_KOBIL_SCT is not set
> # CONFIG_USB_SERIAL_MCT_U232 is not set
> # CONFIG_USB_SERIAL_MOS7720 is not set
> # CONFIG_USB_SERIAL_MOS7840 is not set
> # CONFIG_USB_SERIAL_MOTOROLA is not set
> # CONFIG_USB_SERIAL_NAVMAN is not set
> # CONFIG_USB_SERIAL_PL2303 is not set
> # CONFIG_USB_SERIAL_OTI6858 is not set
> # CONFIG_USB_SERIAL_SPCP8X5 is not set
> # CONFIG_USB_SERIAL_HP4X is not set
> # CONFIG_USB_SERIAL_SAFE is not set
> CONFIG_USB_SERIAL_SIERRAWIRELESS=m
> # CONFIG_USB_SERIAL_TI is not set
> # CONFIG_USB_SERIAL_CYBERJACK is not set
> # CONFIG_USB_SERIAL_XIRCOM is not set
> CONFIG_USB_SERIAL_OPTION=m
> # CONFIG_USB_SERIAL_OMNINET is not set
> # CONFIG_USB_SERIAL_DEBUG is not set
>
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_AUERSWALD is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_PHIDGET is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> # CONFIG_UIO is not set
>
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> # CONFIG_DMIID is not set
> # CONFIG_ISCSI_IBFT_FIND is not set
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
> CONFIG_FS_POSIX_ACL=y
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_DNOTIFY is not set
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> CONFIG_FUSE_FS=m
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
>
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
>
> #
> # Miscellaneous filesystems
> #
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=m
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> # CONFIG_SMB_FS is not set
> CONFIG_CIFS=m
> CONFIG_CIFS_STATS=y
> CONFIG_CIFS_STATS2=y
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> # CONFIG_CIFS_DEBUG2 is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
>
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_NLS=m
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=m
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=m
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=m
>
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> # CONFIG_PRINTK_TIME is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> # CONFIG_MAGIC_SYSRQ is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_KERNEL is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_LATENCYTOP is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_NONPROMISC_DEVMEM is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_4KSTACKS is not set
> CONFIG_X86_FIND_SMP_CONFIG=y
> CONFIG_X86_MPPARSE=y
> CONFIG_DOUBLEFAULT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
>
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> CONFIG_CRYPTO=y
>
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=m
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_HASH=m
> CONFIG_CRYPTO_MANAGER=m
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=m
> # CONFIG_CRYPTO_TEST is not set
>
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
>
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=m
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> # CONFIG_CRYPTO_ECB is not set
> # CONFIG_CRYPTO_PCBC is not set
>
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=m
>
> #
> # Digest
> #
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=m
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> CONFIG_CRYPTO_SHA1=m
> CONFIG_CRYPTO_SHA256=m
> CONFIG_CRYPTO_SHA512=m
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
>
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=m
> CONFIG_CRYPTO_AES_586=m
> # CONFIG_CRYPTO_ANUBIS is not set
> # CONFIG_CRYPTO_ARC4 is not set
> CONFIG_CRYPTO_BLOWFISH=m
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=m
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=m
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_586=m
>
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_LZO=m
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=m
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> CONFIG_CRC_CCITT=m
> # CONFIG_CRC16 is not set
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=m
> # CONFIG_CRC7 is not set
> # CONFIG_LIBCRC32C is not set
> CONFIG_ZLIB_INFLATE=m
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_LZO_COMPRESS=m
> CONFIG_LZO_DECOMPRESS=m
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
>
>
