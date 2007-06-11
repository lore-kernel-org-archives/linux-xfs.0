Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 07:34:02 -0700 (PDT)
Received: from bay0-omc3-s35.bay0.hotmail.com (bay0-omc3-s35.bay0.hotmail.com [65.54.246.235])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5BEXqWt010718
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 07:33:53 -0700
Message-ID: <BAY103-DAV980DD968BE606C6D2F197B21A0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <a781481a0706110649g34abf55pd34c2592a36d161d@mail.gmail.com>
Subject: Re: 2.6.21.3 Oops (was Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd)
Date: Mon, 11 Jun 2007 16:33:43 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <clameter@sgi.com>

Satyam Sharma wrote:

> Hi Marco,

Ciao Satyam, thanks for the feedback.

> [ Re-adding David, XFS, Andrew and Christoph; this appears to be
> some SLAB / fs (?) issue, so I'm a little out of my depth here :-) ]
>
> > > On 6/8/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> > >> After few hours linux has crashed with this message:
> > >> BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
>
> Well, _this_ particular "bug" (due to a WARN_ON(irqs_disabled)
> that should be avoided when we're panicing) is resolved in the latest
> 22-rc4 / -git kernel. However, interestingly, this is not the problem
that
> crashed your system in the first place. Your box had *already*
paniced,
> due to unknown reasons, and _then_ hit the aforementioned WARN_ON.
>
> > > Which kernel (exactly) was this
> >
> > 2.6.21.3
>
> Ok, so apparently what happened here was this:
>
> Some RCU callback (that calls kmem_cache_free()) oopsed and
> panic'ed his box. [ Marco had experienced fs issues lately, so we
could
> suspect file_free_rcu() here, but I can't really tell from the stack
trace;
> BTW whats with the rampant disease in the kernel to declare as inline
> even those functions exclusively meant to be dereferenced and passed
> as pointers to call_rcu()?! ]
>
> Sadly, 21.3 (21.4 too, actually) had a busticated smp_send_stop()
> that would always go WARN_ON when called by panic() as mentioned
> above, which meant that the original dmesg stuff outputted by the oops
+
> panic got scrolled up and all that we had on the screen was the stack
trace
> for the WARN_ON when you snapped the pic -- the system didn't write to
> syslog messages in time and so the extract below isn't quite useful
:-(
>
> > >  and does this occur
> > > reproducibly?
> >
> > I don't know. I try to explain. With all debugging options
> > enabled 2.6.21.x has never crashed. After two days 2.6.21.3
> > was running without any debug options, it has crashed.
> > Tomorrow morning I will start that linux box with linux 2.6.21.3
> > without any debug options, and I will keep you informed
> > (friday evening I have switched back to 2.6.21.3 with debug
> > options enabled, so the machine doesn't crash during the week
> > end: this system is my company firewall.)
>
> I hope you're able to reproduce this with various debug options
> enabled

No, I'm not able to reproduce this error with the debug options
enabled.
Friday evening (UTC) I have compiled 2.6.21.3 with only slab
debug option enabled and the machine has not been crashed
after 3 days (till now).

>  (and/or also try the latest 22-rc4 or -git kernel).

Yes, I can try 2.6.22-rc4. I'm going to compile it right
now...

> Could you
> please send the .config that crashed too?

Here is:
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21.3
# Thu May 31 14:53:05 2007
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
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
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
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y

#
# APM (Advanced Power Management) BIOS Support
#
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
# PCI Hotplug Support
#

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
# CONFIG_NETDEBUG is not set
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

#
# IP: Virtual Server Configuration
#
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
CONFIG_NF_CONNTRACK_SUPPORT=y
# CONFIG_IP_NF_CONNTRACK_SUPPORT is not set
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
# CONFIG_NET_SCH_CLK_JIFFIES is not set
CONFIG_NET_SCH_CLK_GETTIMEOFDAY=y
# CONFIG_NET_SCH_CLK_CPU is not set

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
# CONFIG_IEEE80211 is not set
CONFIG_FIB_RULES=y

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

#
# Memory Technology Devices (MTD)
#
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
# CONFIG_SGI_IOC4 is not set
# CONFIG_SONY_LAPTOP is not set

#
# ATA/ATAPI/MFM/RLL support
#
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

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
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

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
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
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Macintosh device drivers
#
# CONFIG_MAC_EMUMOUSEBTN is not set

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

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set

#
# Ethernet (1000 Mbit)
#
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
CONFIG_TIGON3=m
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
# CONFIG_NET_RADIO is not set

#
# Wan interfaces
#
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

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
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

#
# I2C support
#
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

#
# Hardware Monitoring support
#
# CONFIG_HWMON is not set
# CONFIG_HWMON_VID is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
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

#
# MMC/SD Card support
#
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
# Auxiliary Display support
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
CONFIG_LOG_BUF_SHIFT=15
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
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

> Anyway, I'd have to leave this upto the others Cc:'ed here. Doesn't
look
> like a known / resolved issue, though.
>
> > > Also, could you please send the dmesg,
> >
> > Jun 4 20:53:05 Pleiadi kernel: sanitize start
> > Jun 4 20:53:05 Pleiadi kernel: sanitize end
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
0000000000000000
> > size: 000000000009ac00 end: 000000000009ac00 type: 1
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
000000000009ac00
> > size: 0000000000005400 end: 00000000000a0000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
00000000000ce000
> > size: 0000000000002000 end: 00000000000d0000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
00000000000e0000
> > size: 0000000000020000 end: 0000000000100000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
0000000000100000
> > size: 000000003fdf0000 end: 000000003fef0000 type: 1
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
000000003fef0000
> > size: 000000000000b000 end: 000000003fefb000 type: 3
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
000000003fefb000
> > size: 0000000000005000 end: 000000003ff00000 type: 4
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
000000003ff00000
> > size: 0000000000080000 end: 000000003ff80000 type: 1
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
000000003ff80000
> > size: 0000000000080000 end: 0000000040000000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
00000000e0000000
> > size: 0000000010000000 end: 00000000f0000000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
00000000fec00000
> > size: 0000000000100400 end: 00000000fed00400 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
00000000fee00000
> > size: 0000000000100000 end: 00000000fef00000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
00000000ffb00000
> > size: 0000000000100000 end: 00000000ffc00000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start:
00000000fff00000
> > size: 0000000000100000 end: 0000000100000000 type: 2
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 0000000000000000 -
> > 000000000009ac00 (usable)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000000009ac00 -
> > 00000000000a0000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000000ce000 -
> > 00000000000d0000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000000e0000 -
> > 0000000000100000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 0000000000100000 -
> > 000000003fef0000 (usable)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003fef0000 -
> > 000000003fefb000 (ACPI data)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003fefb000 -
> > 000000003ff00000 (ACPI NVS)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003ff00000 -
> > 000000003ff80000 (usable)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003ff80000 -
> > 0000000040000000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000e0000000 -
> > 00000000f0000000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000fec00000 -
> > 00000000fed00400 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000fee00000 -
> > 00000000fef00000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000ffb00000 -
> > 00000000ffc00000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000fff00000 -
> > 0000000100000000 (reserved)
> > Jun 4 20:53:05 Pleiadi kernel: Zone PFN ranges:
> > Jun 4 20:53:05 Pleiadi kernel: DMA 0 -> 4096
> > Jun 4 20:53:05 Pleiadi kernel: Normal 4096 -> 229376
> > Jun 4 20:53:05 Pleiadi kernel: HighMem 229376 -> 262016
> > Jun 4 20:53:05 Pleiadi kernel: early_node_map[1] active PFN ranges
> > Jun 4 20:53:05 Pleiadi kernel: 0: 0 -> 262016
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: RSDP 000F6BA0, 0024 (r2 PTLTD )
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: XSDT 3FEF5381, 004C (r1 PTLTD
^I
> > XSDT 6040001 LTP 0)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: FACP 3FEF5441, 00F4 (r3 FSC
> > 6040001 F4240)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: DSDT 3FEF5535, 597B (r1 FSC
> > D1649 6040001 MSFT 2000002)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: FACS 3FEFBFC0, 0040
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: SPCR 3FEFAEB0, 0050 (r1 PTLTD
> > $UCRTBL$ 6040001 PTL 1)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: MCFG 3FEFAF00, 0040 (r1 PTLTD
> > MCFG 6040001 LTP 0)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: APIC 3FEFAF40, 0098 (r1 PTLTD
^I
> > APIC 6040001 LTP 0)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: BOOT 3FEFAFD8, 0028 (r1 PTLTD
> > $SBFTBL$ 6040001 LTP 1)
> > Jun 4 20:53:05 Pleiadi kernel: Processor #0 15:4 APIC version 20
> > Jun 4 20:53:05 Pleiadi kernel: Processor #1 15:4 APIC version 20
> > Jun 4 20:53:05 Pleiadi kernel: IOAPIC[0]: apic_id 2, version 32,
> > address 0xfec00000, GSI 0-23
> > Jun 4 20:53:05 Pleiadi kernel: IOAPIC[1]: apic_id 3, version 32,
> > address 0xfec80000, GSI 24-47
> > Jun 4 20:53:05 Pleiadi kernel: IOAPIC[2]: apic_id 4, version 32,
> > address 0xfec80800, GSI 48-71
> > Jun 4 20:53:05 Pleiadi kernel: IOAPIC[3]: apic_id 5, version 32,
> > address 0xfec84000, GSI 72-95
> > Jun 4 20:53:05 Pleiadi kernel: IOAPIC[4]: apic_id 6, version 32,
> > address 0xfec84800, GSI 96-119
> > Jun 4 20:53:05 Pleiadi kernel: Enabling APIC mode: Flat. Using 5 I/O
> > APICs
> > Jun 4 20:53:05 Pleiadi kernel: Allocating PCI resources starting at
> > 50000000 (gap: 40000000:a0000000)
> > Jun 4 20:53:05 Pleiadi kernel: Built 1 zonelists. Total pages:
259969
> > Jun 4 20:53:05 Pleiadi kernel: PID hash table entries: 4096 (order:
12,
> > 16384 bytes)
> > Jun 4 20:53:05 Pleiadi kernel: Detected 3200.428 MHz processor.
> > Jun 4 20:53:05 Pleiadi kernel: Console: colour VGA+ 80x25
> > Jun 4 20:53:05 Pleiadi kernel: Dentry cache hash table entries:
131072
> > (order: 7, 524288 bytes)
> > Jun 4 20:53:05 Pleiadi kernel: Inode-cache hash table entries: 65536
> > (order: 6, 262144 bytes)
> > Jun 4 20:53:05 Pleiadi kernel: virtual kernel memory layout:
> > Jun 4 20:53:05 Pleiadi kernel: fixmap : 0xfff9d000 - 0xfffff000
> > ( 392 kB)
> > Jun 4 20:53:05 Pleiadi kernel: pkmap : 0xff800000 - 0xffc00000
> > (4096 kB)
> > Jun 4 20:53:05 Pleiadi kernel: vmalloc : 0xf8800000 - 0xff7fe000
> > ( 111 MB)
> > Jun 4 20:53:05 Pleiadi kernel: lowmem : 0xc0000000 - 0xf8000000
> > ( 896 MB)
> > Jun 4 20:53:05 Pleiadi kernel: .init : 0xc039f000 - 0xc03ce000
> > ( 188 kB)
> > Jun 4 20:53:05 Pleiadi kernel: .data : 0xc02fd400 - 0xc0398114
> > ( 619 kB)
> > Jun 4 20:53:05 Pleiadi kernel: .text : 0xc0100000 - 0xc02fd400
> > (2037 kB)
> > Jun 4 20:53:05 Pleiadi kernel: Checking if this processor honours
the
> > WP bit even in supervisor mode... Ok.
> > Jun 4 20:53:05 Pleiadi kernel: Calibrating delay using timer
specific
> > routine.. 6403.78 BogoMIPS (lpj=32018905)
> > Jun 4 20:53:05 Pleiadi kernel: Mount-cache hash table entries: 512
> > Jun 4 20:53:05 Pleiadi kernel: monitor/mwait feature present.
> > Jun 4 20:53:05 Pleiadi kernel: using mwait in idle threads.
> > Jun 4 20:53:05 Pleiadi kernel: CPU0: Intel(R) Xeon(TM) CPU 3.20GHz
> > stepping 0a
> > Jun 4 20:53:05 Pleiadi kernel: Booting processor 1/1 eip 2000
> > Jun 4 20:53:05 Pleiadi kernel: Calibrating delay using timer
specific
> > routine.. 6400.45 BogoMIPS (lpj=32002267)
> > Jun 4 20:53:05 Pleiadi kernel: monitor/mwait feature present.
> > Jun 4 20:53:05 Pleiadi kernel: CPU1: Intel(R) Xeon(TM) CPU 3.20GHz
> > stepping 0a
> > Jun 4 20:53:05 Pleiadi kernel: ENABLING IO-APIC IRQs
> > Jun 4 20:53:05 Pleiadi kernel: migration_cost=142
> > Jun 4 20:53:05 Pleiadi kernel: Setting up standard PCI resources
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: Device [PS2M] status
[00000008]:
> > functional but not present; setting present
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: Device [ECP] status [00000008]:
> > functional but not present; setting present
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: Device [COM1] status
[00000008]:
> > functional but not present; setting present
> > Jun 4 20:53:05 Pleiadi kernel: PCI quirk: region f000-f07f claimed
by
> > ICH4 ACPI/GPIO/TCO
> > Jun 4 20:53:05 Pleiadi kernel: PCI quirk: region f180-f1bf claimed
by
> > ICH4 GPIO
> > Jun 4 20:53:05 Pleiadi kernel: PCI: PXH quirk detected, disabling
MSI
> > for SHPC device
> > Jun 4 20:53:05 Pleiadi kernel: PCI: PXH quirk detected, disabling
MSI
> > for SHPC device
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs
3
> > 4 5 6 7 9 10 *11 12 14 15)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs
3
> > 4 5 6 7 *9 10 11 12 14 15)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs
3
> > 4 *5 6 7 9 10 11 12 14 15)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs
3
> > 4 5 6 7 9 *10 11 12 14 15)
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs
3
> > 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs
3
> > 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs
3
> > 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> > Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs
3
> > *4 5 6 7 9 10 11 12 14 15)
> > Jun 4 20:53:05 Pleiadi kernel: IP route cache hash table entries:
32768
> > (order: 5, 131072 bytes)
> > Jun 4 20:53:05 Pleiadi kernel: TCP established hash table entries:
> > 131072 (order: 8, 1572864 bytes)
> > Jun 4 20:53:05 Pleiadi kernel: TCP bind hash table entries: 65536
> > (order: 7, 524288 bytes)
> > Jun 4 20:53:05 Pleiadi kernel: highmem bounce pool size: 64 pages
> > Jun 4 20:53:05 Pleiadi kernel: PNP: PS/2 controller doesn't have AUX
> > irq; using default 12
> > Jun 4 20:53:05 Pleiadi kernel: nf_conntrack version 0.5.0 (8188
> > buckets, 65504 max)
> > Jun 4 20:53:05 Pleiadi kernel: ip_tables: (C) 2000-2006 Netfilter
Core
> > Team
> > Jun 4 20:53:05 Pleiadi kernel: Using IPI Shortcut mode
> > Jun 4 20:53:05 Pleiadi kernel: VFS: Mounted root (xfs filesystem)
> > readonly.
> >
> > > stack trace, etc for when this happened?
> >
> > I have only a monitor bitmap. Tell me if you want it.
>
> [ Marco sent me the stack trace photo off-list; attached herewith. ]
>
> Satyam
>
