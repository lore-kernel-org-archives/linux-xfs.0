Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbdFFVkb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 17:40:31 -0400
Date: Tue, 6 Jun 2017 17:40:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [xfs] 63db7c815b:  XFS: Assertion failed:
 spin_is_locked(&bp->b_lock), file: fs/xfs/xfs_buf.c, line: 120
Message-ID: <20170606214026.GA60185@bfoster.bfoster>
References: <5936ef0f.fBmgdMZp5n1XOXiy%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5936ef0f.fBmgdMZp5n1XOXiy%fengguang.wu@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kernel test robot <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, wfg@linux.intel.com, linux-xfs@vger.kernel.org

cc linux-xfs

On Wed, Jun 07, 2017 at 02:06:07AM +0800, kernel test robot wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> commit 63db7c815bc0997c29e484d2409684fdd9fcd93b
> Author:     Brian Foster <bfoster@redhat.com>
> AuthorDate: Wed May 31 08:22:52 2017 -0700
> Commit:     Darrick J. Wong <darrick.wong@oracle.com>
> CommitDate: Wed May 31 08:22:52 2017 -0700
> 
>     xfs: use ->b_state to fix buffer I/O accounting release race
>     
>     We've had user reports of unmount hangs in xfs_wait_buftarg() that
>     analysis shows is due to btp->bt_io_count == -1. bt_io_count
>     represents the count of in-flight asynchronous buffers and thus
>     should always be >= 0. xfs_wait_buftarg() waits for this value to
>     stabilize to zero in order to ensure that all untracked (with
>     respect to the lru) buffers have completed I/O processing before
>     unmount proceeds to tear down in-core data structures.
>     
>     The value of -1 implies an I/O accounting decrement race. Indeed,
>     the fact that xfs_buf_ioacct_dec() is called from xfs_buf_rele()
>     (where the buffer lock is no longer held) means that bp->b_flags can
>     be updated from an unsafe context. While a user-level reproducer is
>     currently not available, some intrusive hacks to run racing buffer
>     lookups/ioacct/releases from multiple threads was used to
>     successfully manufacture this problem.
>     
>     Existing callers do not expect to acquire the buffer lock from
>     xfs_buf_rele(). Therefore, we can not safely update ->b_flags from
>     this context. It turns out that we already have separate buffer
>     state bits and associated serialization for dealing with buffer LRU
>     state in the form of ->b_state and ->b_lock. Therefore, replace the
>     _XBF_IN_FLIGHT flag with a ->b_state variant, update the I/O
>     accounting wrappers appropriately and make sure they are used with
>     the correct locking. This ensures that buffer in-flight state can be
>     modified at buffer release time without racing with modifications
>     from a buffer lock holder.
>     
>     Fixes: 9c7504aa72b6 ("xfs: track and serialize in-flight async buffers against unmount")
>     Cc: <stable@vger.kernel.org> # v4.8+
>     Signed-off-by: Brian Foster <bfoster@redhat.com>
>     Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>     Tested-by: Libor Pechacek <lpechacek@suse.com>
>     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> a54fba8f5a  xfs: Move handling of missing page into one place in xfs_find_get_desired_pgoff()
> 63db7c815b  xfs: use ->b_state to fix buffer I/O accounting release race
> ba7b2387ad  Merge branch 'for-4.12-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
> 19ce14199a  Add linux-next specific files for 20170606
> +------------------------------------------+------------+------------+------------+---------------+
> |                                          | a54fba8f5a | 63db7c815b | ba7b2387ad | next-20170606 |
> +------------------------------------------+------------+------------+------------+---------------+
> | boot_successes                           | 37         | 4          | 8          | 10            |
> | boot_failures                            | 0          | 11         | 11         | 11            |
> | Assertion_failed                         | 0          | 11         | 11         | 11            |
> | kernel_BUG_at_fs/xfs/xfs_message.c       | 0          | 11         | 11         | 11            |
> | invalid_opcode:#[##]                     | 0          | 11         | 11         | 11            |
> | EIP:assfail                              | 0          | 11         | 11         | 11            |
> | Kernel_panic-not_syncing:Fatal_exception | 0          | 11         | 11         | 11            |
> +------------------------------------------+------------+------------+------------+---------------+
> 
> [    7.938397] rodata_test: all tests were successful
> [    8.869407] qnx6: unable to read the first superblock
> [    8.934965] qnx6: unable to read the first superblock
> [    8.952962] qnx6: unable to read the first superblock
> [    8.955407] qnx6: unable to read the first superblock
> [    9.006193] XFS: Assertion failed: spin_is_locked(&bp->b_lock), file: fs/xfs/xfs_buf.c, line: 120
> [    9.006207] ------------[ cut here ]------------

AFAICT, this appears to be due to spin_is_locked() being hardcoded to
return 0 on !CONFIG_SMP kernels. XFS uses spin_is_locked() in assert
checks in a few different spots. This patch adds one to the buffer
release path, which happens to be triggered on mount (perhaps due to the
release/re-read of the superblock buffer).

Without this assert, a similar pre-existing assert triggers on a simple
mount/umount cycle of an XFS filesystem, so I'm a bit curious why this
one triggers a test failure where one didn't trigger before. Perhaps
this test is attempting to mount a non-XFS device and that's where we've
invoked the buffer release path..?

Anyways, I wouldn't necessarily consider this purely a problem with the
patch above. The problem is basically a spurious assert failure. It will
never occur on production (!CONFIG_XFS_WARN && !CONFIG_XFS_DEBUG)
kernels or CONFIG_SMP kernels and otherwise shouldn't cause any
functional problems.

As far as fixing this goes, the simplest approach seems to be to include
an IS_ENABLED(CONFIG_SMP) check in the few asserts that use
spin_is_locked(). Before I send a patch, do XFS folks have any other
opinions or ideas?

Brian

> [    9.006208] kernel BUG at fs/xfs/xfs_message.c:113!
> [    9.006210] invalid opcode: 0000 [#1] PREEMPT
> [    9.006211] Modules linked in:
> [    9.006215] CPU: 0 PID: 398 Comm: mount Not tainted 4.12.0-rc1-00012-g63db7c8 #1
> [    9.006216] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
> [    9.006218] task: cc445a40 task.stack: cc596000
> [    9.006223] EIP: assfail+0x17/0x19
> [    9.006225] EFLAGS: 00010282 CPU: 0
> [    9.006226] EAX: ffffffea EBX: cc46b3e8 ECX: c7a68e9f EDX: c7aa464a
> [    9.006227] ESI: cc46b3c0 EDI: cc46b3e8 EBP: cc597e40 ESP: cc597e2c
> [    9.006229]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    9.006230] CR0: 80050033 CR2: b776c000 CR3: 0c4aa820 CR4: 00140630
> [    9.006234] Call Trace:
> [    9.006238]  xfs_buf_rele+0xdd/0x63f
> [    9.006240]  ? xfs_buf_unlock+0x71/0xc3
> [    9.006243]  xfs_readsb+0x1b8/0x1c2
> [    9.006246]  xfs_fs_fill_super+0x21f/0x435
> [    9.006250]  mount_bdev+0x137/0x182
> [    9.006253]  xfs_fs_mount+0x15/0x17
> [    9.006255]  ? xfs_finish_flags+0x114/0x114
> [    9.006257]  mount_fs+0x17/0xf8
> [    9.006260]  vfs_kern_mount+0x51/0x13c
> [    9.006263]  do_mount+0x857/0xad1
> [    9.006266]  SyS_mount+0xac/0xd0
> [    9.006269]  do_int80_syscall_32+0x6c/0x102
> [    9.006274]  entry_INT80_32+0x31/0x31
> [    9.006275] EIP: 0x47f46fee
> [    9.006276] EFLAGS: 00000282 CPU: 0
> [    9.006277] EAX: ffffffda EBX: bfe3fe9d ECX: bfe3fea6 EDX: 080d36d0
> [    9.006279] ESI: 00008010 EDI: 00000000 EBP: 00000000 ESP: bfe3f7a0
> [    9.006280]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
> [    9.006282] Code: 00 00 00 6a 01 b8 10 3f be c7 e8 89 bb e3 ff 83 c4 1c c9 c3 55 89 e5 e8 6b 38 db ff 51 52 50 68 ac 46 aa c7 6a 00 e8 85 fc ff ff <0f> 0b 55 89 e5 e8 52 38 db ff b9 01 00 00 00 6a 01 52 ba 9b 61
> [    9.006312] EIP: assfail+0x17/0x19 SS:ESP: 0068:cc597e2c
> [    9.006314] ---[ end trace b5abbbc5416845ea ]---
> [    9.006315] Kernel panic - not syncing: Fatal exception
> 
>                                                           # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
> git bisect start 3c2993b8c6143d8a5793746a54eba8f86f95240f v4.11 --
> git bisect good 29250d301b0c75ef142b51eebee6b7403cc79624  # 22:42  G     11     0    0   0  Merge tag 'trace-v4.12-3' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect good 334a023ee50997b45ffb8fbcc8bc875519040aac  # 22:56  G     11     0    0   0  Clean up x86 unsafe_get/put_user() type handling
> git bisect good b0f5a8f32e8bbdaae1abb8abe2d3cbafaba57e08  # 23:07  G     11     0    0   0  kthread: fix boot hang (regression) on MIPS/OpenRISC
> git bisect good 6f37fa4364a1099b59f73d1a71538895fd2ef975  # 23:18  G     11     0    0   0  Merge tag 'md/4.12-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/shli/md
> git bisect  bad cc54874055c007cd599138a394d1f039e4e0764b  # 23:31  B      0     8   20   0  Merge tag 'for-linus-20170602' of git://git.infradead.org/linux-mtd
> git bisect  bad e6e6d074369c839e84071c3b056adf20ead8da6e  # 23:47  B      0    11   23   0  Merge tag 'xfs-4.12-fixes-3' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
> git bisect good 65d03328aace31043be98f807f6e20332cdb19c8  # 00:04  G     11     0    0   0  Merge tag 'ceph-for-4.12-rc4' of git://github.com/ceph/ceph-client
> git bisect good b939c51445f0542e80a8f910014c418d04b5de6e  # 00:24  G     10     0    0   0  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
> git bisect  bad 63db7c815bc0997c29e484d2409684fdd9fcd93b  # 00:37  B      0    11   23   0  xfs: use ->b_state to fix buffer I/O accounting release race
> # first bad commit: [63db7c815bc0997c29e484d2409684fdd9fcd93b] xfs: use ->b_state to fix buffer I/O accounting release race
> git bisect good a54fba8f5a0dc36161cacdf2aa90f007f702ec1a  # 00:51  G     30     0    0   0  xfs: Move handling of missing page into one place in xfs_find_get_desired_pgoff()
> # extra tests with CONFIG_DEBUG_INFO_REDUCED
> git bisect  bad 63db7c815bc0997c29e484d2409684fdd9fcd93b  # 01:01  B      0    11   23   0  xfs: use ->b_state to fix buffer I/O accounting release race
> # extra tests on HEAD of linux-devel/devel-spot-201706062120
> git bisect  bad 231575479432f3449f51bb810d5b8b116f81557b  # 01:01  B      0    13   28   0  0day head guard for 'devel-spot-201706062120'
> # extra tests on tree/branch linus/master
> git bisect  bad ba7b2387ad239a519041f2a2d35a1902bdd03dfb  # 01:17  B      0     3   15   0  Merge branch 'for-4.12-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
> # extra tests with first bad commit reverted
> git bisect good a22863108b531d27f722d99567c102340e7a4153  # 01:35  G     11     0    0   0  Revert "xfs: use ->b_state to fix buffer I/O accounting release race"
> # extra tests on tree/branch linux-next/master
> git bisect  bad 19ce14199afdacb1621ccc681d1ba5938efad8b3  # 02:05  B      0    11   24   0  Add linux-next specific files for 20170606
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/lkp                          Intel Corporation


> #!/bin/bash
> 
> kernel=$1
> initrd=yocto-trinity-i386.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-enable-kvm
> 	-cpu Haswell,+smep,+smap
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 256
> 	-smp 1
> 	-device e1000,netdev=net0
> 	-netdev user,id=net0
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-watchdog-action debug
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null
> )
> 
> append=(
> 	root=/dev/ram0
> 	hung_task_panic=1
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	net.ifnames=0
> 	printk.devkmsg=on
> 	panic=-1
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	oops=panic
> 	load_ramdisk=2
> 	prompt_ramdisk=0
> 	drbd.minor_count=8
> 	systemd.log_level=err
> 	ignore_loglevel
> 	earlyprintk=ttyS0,115200
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" -append "${append[*]}"

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 4.12.0-rc1 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_ARCH_MMAP_RND_BITS_MIN=8
> CONFIG_ARCH_MMAP_RND_BITS_MAX=16
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_PGTABLE_LEVELS=3
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> CONFIG_THREAD_INFO_IN_TASK=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_KERNEL_LZ4=y
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> # CONFIG_SYSVIPC is not set
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_FHANDLE=y
> # CONFIG_USELIB is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_DEBUG=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> CONFIG_IRQ_TIME_ACCOUNTING=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_PREEMPT_RCU=y
> # CONFIG_RCU_EXPERT is not set
> CONFIG_SRCU=y
> CONFIG_TREE_SRCU=y
> CONFIG_TASKS_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_NEED_SEGCBLIST=y
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_BUILD_BIN2C=y
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_CGROUPS=y
> # CONFIG_MEMCG is not set
> # CONFIG_BLK_CGROUP is not set
> # CONFIG_CGROUP_SCHED is not set
> # CONFIG_CGROUP_PIDS is not set
> # CONFIG_CGROUP_RDMA is not set
> # CONFIG_CGROUP_FREEZER is not set
> # CONFIG_CGROUP_HUGETLB is not set
> # CONFIG_CPUSETS is not set
> # CONFIG_CGROUP_DEVICE is not set
> # CONFIG_CGROUP_CPUACCT is not set
> # CONFIG_CGROUP_PERF is not set
> # CONFIG_CGROUP_BPF is not set
> # CONFIG_CGROUP_DEBUG is not set
> # CONFIG_SOCK_CGROUP_DATA is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> CONFIG_NET_NS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> CONFIG_RD_LZMA=y
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_RD_LZ4 is not set
> CONFIG_INITRAMFS_COMPRESSION=".gz"
> # CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_BPF=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> CONFIG_MULTIUSER=y
> CONFIG_SGETMASK_SYSCALL=y
> CONFIG_SYSFS_SYSCALL=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_POSIX_TIMERS=y
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> # CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
> CONFIG_KALLSYMS_BASE_RELATIVE=y
> CONFIG_PRINTK=y
> CONFIG_PRINTK_NMI=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_BPF_SYSCALL=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_ADVISE_SYSCALLS=y
> # CONFIG_USERFAULTFD is not set
> CONFIG_PCI_QUIRKS=y
> CONFIG_MEMBARRIER=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> # CONFIG_PC104 is not set
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_SLAB_FREELIST_RANDOM=y
> # CONFIG_SYSTEM_DATA_VERIFICATION is not set
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> # CONFIG_JUMP_LABEL is not set
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_NMI=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_ARCH_HAS_SET_MEMORY=y
> CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_CLK=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_GCC_PLUGINS=y
> # CONFIG_GCC_PLUGINS is not set
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR_NONE is not set
> CONFIG_CC_STACKPROTECTOR_REGULAR=y
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_HUGE_VMAP=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
> CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
> CONFIG_HAVE_EXIT_THREAD=y
> CONFIG_ARCH_MMAP_RND_BITS=8
> CONFIG_HAVE_COPY_THREAD_TLS=y
> # CONFIG_HAVE_ARCH_HASH is not set
> # CONFIG_ISA_BUS_API is not set
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> # CONFIG_CPU_NO_EFFICIENT_FFS is not set
> # CONFIG_HAVE_ARCH_VMAP_STACK is not set
> # CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
> # CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
> CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
> CONFIG_STRICT_KERNEL_RWX=y
> CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
> CONFIG_STRICT_MODULE_RWX=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
> # CONFIG_GCOV_PROFILE_ALL is not set
> # CONFIG_GCOV_FORMAT_AUTODETECT is not set
> CONFIG_GCOV_FORMAT_3_4=y
> # CONFIG_GCOV_FORMAT_4_7 is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_FORCE_LOAD=y
> # CONFIG_MODULE_UNLOAD is not set
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_MODULE_SIG is not set
> # CONFIG_MODULE_COMPRESS is not set
> CONFIG_MODULES_TREE_LOOKUP=y
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_SCSI_REQUEST=y
> CONFIG_BLK_DEV_BSG=y
> # CONFIG_BLK_DEV_BSGLIB is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> CONFIG_BLK_DEV_ZONED=y
> CONFIG_BLK_CMDLINE_PARSER=y
> # CONFIG_BLK_WBT is not set
> # CONFIG_BLK_DEBUG_FS is not set
> CONFIG_BLK_SED_OPAL=y
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_AMIGA_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> CONFIG_BLK_MQ_PCI=y
> CONFIG_BLK_MQ_VIRTIO=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=m
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_MQ_IOSCHED_DEADLINE=y
> CONFIG_MQ_IOSCHED_KYBER=m
> CONFIG_IOSCHED_BFQ=y
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
> CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
> CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> CONFIG_X86_FEATURE_NAMES=y
> CONFIG_X86_FAST_FEATURE_TESTS=y
> CONFIG_GOLDFISH=y
> # CONFIG_INTEL_RDT_A is not set
> CONFIG_X86_EXTENDED_PLATFORM=y
> # CONFIG_X86_GOLDFISH is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_AMD_PLATFORM_DEVICE is not set
> CONFIG_IOSF_MBI=m
> # CONFIG_IOSF_MBI_DEBUG is not set
> CONFIG_X86_RDC321X=y
> CONFIG_X86_32_IRIS=m
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_KVM_GUEST=y
> CONFIG_KVM_DEBUG_FS=y
> CONFIG_LGUEST_GUEST=y
> CONFIG_PARAVIRT_TIME_ACCOUNTING=y
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> CONFIG_M686=y
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
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=5
> CONFIG_X86_L1_CACHE_SHIFT=5
> # CONFIG_X86_PPRO_FENCE is not set
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_NR_CPUS=1
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> # CONFIG_X86_UP_APIC is not set
> # CONFIG_X86_MCE is not set
> 
> #
> # Performance monitoring
> #
> # CONFIG_PERF_EVENTS_INTEL_UNCORE is not set
> CONFIG_PERF_EVENTS_INTEL_RAPL=m
> # CONFIG_PERF_EVENTS_INTEL_CSTATE is not set
> # CONFIG_PERF_EVENTS_AMD_POWER is not set
> # CONFIG_X86_LEGACY_VM86 is not set
> # CONFIG_VM86 is not set
> CONFIG_X86_16BIT=y
> CONFIG_X86_ESPFIX32=y
> CONFIG_TOSHIBA=y
> CONFIG_I8K=m
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> # CONFIG_MICROCODE_INTEL is not set
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> # CONFIG_HIGHMEM4G is not set
> CONFIG_HIGHMEM64G=y
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_X86_PAE=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> # CONFIG_BOUNCE is not set
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
> CONFIG_NEED_PER_CPU_KM=y
> CONFIG_CLEANCACHE=y
> # CONFIG_FRONTSWAP is not set
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> CONFIG_CMA_DEBUGFS=y
> CONFIG_CMA_AREAS=7
> CONFIG_ZPOOL=y
> # CONFIG_ZBUD is not set
> CONFIG_Z3FOLD=y
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
> # CONFIG_IDLE_PAGE_TRACKING is not set
> CONFIG_FRAME_VECTOR=y
> CONFIG_X86_PMEM_LEGACY_DEVICE=y
> CONFIG_X86_PMEM_LEGACY=y
> # CONFIG_HIGHPTE is not set
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MATH_EMULATION=y
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> CONFIG_X86_INTEL_MPX=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_RANDOMIZE_BASE=y
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_MODIFY_LDT_SYSCALL=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_PM_CLK=y
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
> CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
> CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
> # CONFIG_ACPI_DEBUGGER is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_CPU_FREQ_PSS=y
> CONFIG_ACPI_PROCESSOR_CSTATE=y
> CONFIG_ACPI_PROCESSOR_IDLE=y
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
> CONFIG_ACPI_TABLE_UPGRADE=y
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> # CONFIG_ACPI_NFIT is not set
> CONFIG_HAVE_ACPI_APEI=y
> CONFIG_HAVE_ACPI_APEI_NMI=y
> # CONFIG_ACPI_APEI is not set
> # CONFIG_DPTF_POWER is not set
> # CONFIG_PMIC_OPREGION is not set
> # CONFIG_ACPI_CONFIGFS is not set
> CONFIG_SFI=y
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_ATTR_SET=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> # CONFIG_CPU_FREQ_STAT is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=m
> CONFIG_CPU_FREQ_GOV_ONDEMAND=m
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
> 
> #
> # CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_POWERNOW_K6 is not set
> # CONFIG_X86_POWERNOW_K7 is not set
> # CONFIG_X86_GX_SUSPMOD is not set
> CONFIG_X86_SPEEDSTEP_CENTRINO=m
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> CONFIG_X86_SPEEDSTEP_ICH=y
> CONFIG_X86_SPEEDSTEP_SMI=y
> CONFIG_X86_P4_CLOCKMOD=y
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> # CONFIG_X86_LONGRUN is not set
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_GOV_LADDER is not set
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> CONFIG_PCI_GODIRECT=y
> # CONFIG_PCI_GOANY is not set
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> # CONFIG_HOTPLUG_PCI_PCIE is not set
> CONFIG_PCIEAER=y
> # CONFIG_PCIE_ECRC is not set
> CONFIG_PCIEAER_INJECT=m
> CONFIG_PCIEASPM=y
> CONFIG_PCIEASPM_DEBUG=y
> # CONFIG_PCIEASPM_DEFAULT is not set
> CONFIG_PCIEASPM_POWERSAVE=y
> # CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> CONFIG_PCIE_PME=y
> CONFIG_PCIE_DPC=y
> # CONFIG_PCIE_PTM is not set
> CONFIG_PCI_BUS_ADDR_T_64BIT=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> # CONFIG_PCI_PRI is not set
> CONFIG_PCI_PASID=y
> CONFIG_PCI_LABEL=y
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_ACPI is not set
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> CONFIG_HOTPLUG_PCI_SHPC=y
> 
> #
> # DesignWare PCI Core Support
> #
> 
> #
> # PCI host controller drivers
> #
> 
> #
> # PCI Endpoint
> #
> # CONFIG_PCI_ENDPOINT is not set
> 
> #
> # PCI switch controller drivers
> #
> CONFIG_PCI_SW_SWITCHTEC=y
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> CONFIG_SCx200=y
> CONFIG_SCx200HR_TIMER=m
> CONFIG_ALIX=y
> CONFIG_NET5501=y
> CONFIG_GEOS=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=y
> # CONFIG_PCMCIA_LOAD_CIS is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> CONFIG_PD6729=m
> CONFIG_I82092=m
> CONFIG_PCCARD_NONSTATIC=y
> CONFIG_RAPIDIO=m
> CONFIG_RAPIDIO_TSI721=m
> CONFIG_RAPIDIO_DISC_TIMEOUT=30
> CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
> # CONFIG_RAPIDIO_DMA_ENGINE is not set
> CONFIG_RAPIDIO_DEBUG=y
> CONFIG_RAPIDIO_ENUM_BASIC=m
> # CONFIG_RAPIDIO_CHMAN is not set
> CONFIG_RAPIDIO_MPORT_CDEV=m
> 
> #
> # RapidIO Switch drivers
> #
> # CONFIG_RAPIDIO_TSI57X is not set
> CONFIG_RAPIDIO_CPS_XX=m
> CONFIG_RAPIDIO_TSI568=m
> CONFIG_RAPIDIO_CPS_GEN2=m
> # CONFIG_RAPIDIO_RXS_GEN3 is not set
> CONFIG_X86_SYSFB=y
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ELFCORE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=m
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_COMPAT_32=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> # CONFIG_NET_KEY is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NET_PTP_CLASSIFY is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_DIAG is not set
> # CONFIG_MPLS is not set
> # CONFIG_HSR is not set
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_STREAM_PARSER is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_NFC is not set
> # CONFIG_PSAMPLE is not set
> # CONFIG_NET_IFE is not set
> # CONFIG_LWTUNNEL is not set
> # CONFIG_DST_CACHE is not set
> # CONFIG_GRO_CELLS is not set
> # CONFIG_NET_DEVLINK is not set
> CONFIG_MAY_USE_DEVLINK=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER=y
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
> CONFIG_ALLOW_DEV_COREDUMP=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
> # CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=m
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_SPMI=m
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_DMA_FENCE_TRACE is not set
> # CONFIG_DMA_CMA is not set
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_OF is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT=y
> # CONFIG_PARPORT_PC is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_NULL_BLK is not set
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> CONFIG_BLK_CPQ_CISS_DA=y
> CONFIG_BLK_DEV_DAC960=m
> CONFIG_BLK_DEV_UMEM=y
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> CONFIG_BLK_DEV_SX8=m
> CONFIG_BLK_DEV_RAM=m
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_RAM_DAX=y
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> CONFIG_VIRTIO_BLK=y
> # CONFIG_VIRTIO_BLK_SCSI is not set
> CONFIG_BLK_DEV_RSXX=y
> CONFIG_NVME_CORE=y
> CONFIG_BLK_DEV_NVME=y
> # CONFIG_BLK_DEV_NVME_SCSI is not set
> CONFIG_NVME_FABRICS=y
> # CONFIG_NVME_FC is not set
> CONFIG_NVME_TARGET=y
> CONFIG_NVME_TARGET_LOOP=y
> # CONFIG_NVME_TARGET_FC is not set
> 
> #
> # Misc devices
> #
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_AD525X_DPOT is not set
> CONFIG_DUMMY_IRQ=y
> CONFIG_IBM_ASM=m
> CONFIG_PHANTOM=m
> # CONFIG_SGI_IOC4 is not set
> CONFIG_TIFM_CORE=m
> # CONFIG_TIFM_7XX1 is not set
> # CONFIG_ICS932S401 is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> CONFIG_CS5535_MFGPT=m
> CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
> CONFIG_CS5535_CLOCK_EVENT_SRC=m
> # CONFIG_HP_ILO is not set
> # CONFIG_APDS9802ALS is not set
> CONFIG_ISL29003=m
> CONFIG_ISL29020=m
> CONFIG_SENSORS_TSL2550=m
> CONFIG_SENSORS_BH1770=m
> # CONFIG_SENSORS_APDS990X is not set
> CONFIG_HMC6352=m
> # CONFIG_DS1682 is not set
> CONFIG_TI_DAC7512=m
> CONFIG_PCH_PHUB=y
> CONFIG_USB_SWITCH_FSA9480=m
> # CONFIG_LATTICE_ECP3_CONFIG is not set
> # CONFIG_SRAM is not set
> # CONFIG_PCI_ENDPOINT_TEST is not set
> CONFIG_C2PORT=m
> # CONFIG_C2PORT_DURAMAR_2150 is not set
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> CONFIG_EEPROM_AT25=m
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> CONFIG_EEPROM_93XX46=m
> CONFIG_EEPROM_IDT_89HPESX=m
> CONFIG_CB710_CORE=y
> # CONFIG_CB710_DEBUG is not set
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=m
> CONFIG_INTEL_MEI=y
> CONFIG_INTEL_MEI_ME=y
> CONFIG_INTEL_MEI_TXE=m
> # CONFIG_VMWARE_VMCI is not set
> 
> #
> # Intel MIC Bus Driver
> #
> 
> #
> # SCIF Bus Driver
> #
> 
> #
> # VOP Bus Driver
> #
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> 
> #
> # SCIF Driver
> #
> 
> #
> # Intel MIC Coprocessor State Management (COSM) Drivers
> #
> 
> #
> # VOP Driver
> #
> CONFIG_ECHO=y
> # CONFIG_CXL_BASE is not set
> # CONFIG_CXL_AFU_DRIVER_OPS is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=m
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=m
> # CONFIG_IDE_GD_ATA is not set
> CONFIG_IDE_GD_ATAPI=y
> CONFIG_BLK_DEV_IDECS=m
> # CONFIG_BLK_DEV_DELKIN is not set
> CONFIG_BLK_DEV_IDECD=m
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
> 
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> CONFIG_BLK_DEV_PLATFORM=m
> CONFIG_BLK_DEV_CMD640=m
> CONFIG_BLK_DEV_CMD640_ENHANCED=y
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> 
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> CONFIG_BLK_DEV_GENERIC=m
> CONFIG_BLK_DEV_OPTI621=m
> CONFIG_BLK_DEV_RZ1000=m
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> CONFIG_BLK_DEV_AEC62XX=m
> CONFIG_BLK_DEV_ALI15X3=m
> CONFIG_BLK_DEV_AMD74XX=m
> # CONFIG_BLK_DEV_ATIIXP is not set
> CONFIG_BLK_DEV_CMD64X=m
> # CONFIG_BLK_DEV_TRIFLEX is not set
> CONFIG_BLK_DEV_CS5520=m
> CONFIG_BLK_DEV_CS5530=m
> CONFIG_BLK_DEV_CS5535=m
> # CONFIG_BLK_DEV_CS5536 is not set
> CONFIG_BLK_DEV_HPT366=m
> # CONFIG_BLK_DEV_JMICRON is not set
> CONFIG_BLK_DEV_SC1200=m
> CONFIG_BLK_DEV_PIIX=m
> # CONFIG_BLK_DEV_IT8172 is not set
> CONFIG_BLK_DEV_IT8213=m
> # CONFIG_BLK_DEV_IT821X is not set
> CONFIG_BLK_DEV_NS87415=m
> CONFIG_BLK_DEV_PDC202XX_OLD=m
> CONFIG_BLK_DEV_PDC202XX_NEW=m
> # CONFIG_BLK_DEV_SVWKS is not set
> CONFIG_BLK_DEV_SIIMAGE=m
> CONFIG_BLK_DEV_SIS5513=m
> CONFIG_BLK_DEV_SLC90E66=m
> # CONFIG_BLK_DEV_TRM290 is not set
> CONFIG_BLK_DEV_VIA82CXXX=m
> # CONFIG_BLK_DEV_TC86C001 is not set
> CONFIG_BLK_DEV_IDEDMA=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=m
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=m
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_MQ_DEFAULT=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=m
> CONFIG_CHR_DEV_ST=m
> CONFIG_CHR_DEV_OSST=m
> CONFIG_BLK_DEV_SR=m
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_CONSTANTS=y
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> CONFIG_SCSI_SAS_ATTRS=m
> # CONFIG_SCSI_SAS_LIBSAS is not set
> CONFIG_SCSI_SRP_ATTRS=m
> # CONFIG_SCSI_LOWLEVEL is not set
> CONFIG_SCSI_LOWLEVEL_PCMCIA=y
> CONFIG_PCMCIA_AHA152X=m
> CONFIG_PCMCIA_FDOMAIN=m
> CONFIG_PCMCIA_NINJA_SCSI=m
> # CONFIG_PCMCIA_QLOGIC is not set
> # CONFIG_PCMCIA_SYM53C500 is not set
> # CONFIG_SCSI_DH is not set
> CONFIG_SCSI_OSD_INITIATOR=m
> CONFIG_SCSI_OSD_ULD=m
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=m
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> CONFIG_SATA_AHCI_PLATFORM=m
> CONFIG_SATA_INIC162X=m
> CONFIG_SATA_ACARD_AHCI=m
> CONFIG_SATA_SIL24=m
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> CONFIG_PDC_ADMA=m
> CONFIG_SATA_QSTOR=m
> # CONFIG_SATA_SX4 is not set
> # CONFIG_ATA_BMDMA is not set
> 
> #
> # PIO-only SFF controllers
> #
> CONFIG_PATA_CMD640_PCI=m
> CONFIG_PATA_MPIIX=m
> CONFIG_PATA_NS87410=m
> CONFIG_PATA_OPTI=m
> CONFIG_PATA_PCMCIA=m
> CONFIG_PATA_RZ1000=m
> 
> #
> # Generic fallback / legacy drivers
> #
> CONFIG_PATA_LEGACY=m
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> # CONFIG_MD_LINEAR is not set
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> # CONFIG_MD_MULTIPATH is not set
> CONFIG_MD_FAULTY=m
> # CONFIG_BCACHE is not set
> CONFIG_BLK_DEV_DM_BUILTIN=y
> CONFIG_BLK_DEV_DM=m
> CONFIG_DM_MQ_DEFAULT=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=m
> CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING=y
> # CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
> CONFIG_DM_BIO_PRISON=m
> CONFIG_DM_PERSISTENT_DATA=m
> # CONFIG_DM_CRYPT is not set
> CONFIG_DM_SNAPSHOT=m
> # CONFIG_DM_THIN_PROVISIONING is not set
> CONFIG_DM_CACHE=m
> CONFIG_DM_CACHE_SMQ=m
> CONFIG_DM_ERA=m
> # CONFIG_DM_MIRROR is not set
> CONFIG_DM_RAID=m
> # CONFIG_DM_ZERO is not set
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> # CONFIG_DM_UEVENT is not set
> # CONFIG_DM_FLAKEY is not set
> CONFIG_DM_VERITY=m
> # CONFIG_DM_VERITY_FEC is not set
> CONFIG_DM_SWITCH=m
> CONFIG_DM_LOG_WRITES=m
> # CONFIG_DM_INTEGRITY is not set
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=m
> CONFIG_FIREWIRE_OHCI=m
> CONFIG_FIREWIRE_SBP2=m
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> # CONFIG_NETDEVICES is not set
> CONFIG_NVM=y
> # CONFIG_NVM_DEBUG is not set
> CONFIG_NVM_RRPC=y
> CONFIG_NVM_PBLK=y
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_LEDS=m
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=y
> # CONFIG_INPUT_SPARSEKMAP is not set
> CONFIG_INPUT_MATRIXKMAP=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=m
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=m
> CONFIG_INPUT_EVDEV=y
> CONFIG_INPUT_EVBUG=m
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADC is not set
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_SAMSUNG is not set
> # CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> # CONFIG_RMI4_CORE is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> CONFIG_SERIO_CT82C710=m
> CONFIG_SERIO_PARKBD=m
> CONFIG_SERIO_PCIPS2=m
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> CONFIG_SERIO_ALTERA_PS2=m
> CONFIG_SERIO_PS2MULT=m
> CONFIG_SERIO_ARC_PS2=m
> CONFIG_USERIO=m
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> CONFIG_TRACE_ROUTER=m
> CONFIG_TRACE_SINK=m
> CONFIG_GOLDFISH_TTY=m
> # CONFIG_DEVMEM is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> # CONFIG_SERIAL_8250_FINTEK is not set
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=m
> # CONFIG_SERIAL_8250_EXAR is not set
> CONFIG_SERIAL_8250_CS=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> # CONFIG_SERIAL_8250_SHARE_IRQ is not set
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> # CONFIG_SERIAL_8250_RSA is not set
> # CONFIG_SERIAL_8250_FSL is not set
> # CONFIG_SERIAL_8250_DW is not set
> CONFIG_SERIAL_8250_RT288X=y
> CONFIG_SERIAL_8250_LPSS=y
> CONFIG_SERIAL_8250_MID=m
> CONFIG_SERIAL_8250_MOXA=m
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MAX3100=y
> CONFIG_SERIAL_MAX310X=y
> CONFIG_SERIAL_UARTLITE=m
> CONFIG_SERIAL_UARTLITE_NR_UARTS=1
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=y
> # CONFIG_SERIAL_SCCNXP is not set
> CONFIG_SERIAL_SC16IS7XX=m
> # CONFIG_SERIAL_SC16IS7XX_I2C is not set
> # CONFIG_SERIAL_SC16IS7XX_SPI is not set
> CONFIG_SERIAL_TIMBERDALE=m
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
> CONFIG_SERIAL_IFX6X60=m
> CONFIG_SERIAL_PCH_UART=y
> CONFIG_SERIAL_PCH_UART_CONSOLE=y
> CONFIG_SERIAL_ARC=m
> CONFIG_SERIAL_ARC_NR_PORTS=1
> CONFIG_SERIAL_RP2=y
> CONFIG_SERIAL_RP2_NR_UARTS=32
> CONFIG_SERIAL_FSL_LPUART=m
> CONFIG_SERIAL_DEV_BUS=m
> CONFIG_PRINTER=m
> CONFIG_LP_CONSOLE=y
> CONFIG_PPDEV=y
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> # CONFIG_HW_RANDOM_INTEL is not set
> CONFIG_HW_RANDOM_AMD=m
> CONFIG_HW_RANDOM_GEODE=m
> CONFIG_HW_RANDOM_VIA=y
> # CONFIG_HW_RANDOM_VIRTIO is not set
> CONFIG_NVRAM=m
> # CONFIG_R3964 is not set
> CONFIG_APPLICOM=m
> CONFIG_SONYPI=m
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=m
> CONFIG_CARDMAN_4000=m
> CONFIG_CARDMAN_4040=m
> CONFIG_SCR24X=y
> # CONFIG_MWAVE is not set
> CONFIG_SCx200_GPIO=m
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_XILLYBUS=m
> 
> #
> # I2C support
> #
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_MUX=m
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_MUX_GPIO=m
> CONFIG_I2C_MUX_LTC4306=m
> # CONFIG_I2C_MUX_PCA9541 is not set
> CONFIG_I2C_MUX_PCA954x=m
> # CONFIG_I2C_MUX_REG is not set
> # CONFIG_I2C_MUX_MLXCPLD is not set
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=m
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=m
> # CONFIG_I2C_ALGOPCF is not set
> CONFIG_I2C_ALGOPCA=m
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=m
> # CONFIG_I2C_ALI1563 is not set
> CONFIG_I2C_ALI15X3=m
> CONFIG_I2C_AMD756=m
> CONFIG_I2C_AMD756_S4882=m
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=m
> CONFIG_I2C_ISCH=m
> CONFIG_I2C_ISMT=m
> # CONFIG_I2C_PIIX4 is not set
> CONFIG_I2C_NFORCE2=m
> CONFIG_I2C_NFORCE2_S4985=m
> CONFIG_I2C_SIS5595=m
> CONFIG_I2C_SIS630=m
> CONFIG_I2C_SIS96X=m
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=m
> CONFIG_I2C_DESIGNWARE_CORE=m
> CONFIG_I2C_DESIGNWARE_PLATFORM=m
> CONFIG_I2C_DESIGNWARE_PCI=m
> # CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
> CONFIG_I2C_EG20T=m
> # CONFIG_I2C_EMEV2 is not set
> # CONFIG_I2C_GPIO is not set
> # CONFIG_I2C_KEMPLD is not set
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_PCA_PLATFORM=m
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=m
> CONFIG_I2C_XILINX=m
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=m
> CONFIG_I2C_PARPORT_LIGHT=m
> CONFIG_I2C_TAOS_EVM=m
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_CROS_EC_TUNNEL is not set
> CONFIG_SCx200_ACB=m
> CONFIG_I2C_STUB=m
> CONFIG_I2C_SLAVE=y
> CONFIG_I2C_SLAVE_EEPROM=m
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_ALTERA=m
> CONFIG_SPI_AXI_SPI_ENGINE=m
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_BUTTERFLY=m
> CONFIG_SPI_CADENCE=m
> CONFIG_SPI_DESIGNWARE=m
> # CONFIG_SPI_DW_PCI is not set
> CONFIG_SPI_DW_MMIO=m
> # CONFIG_SPI_GPIO is not set
> # CONFIG_SPI_LM70_LLP is not set
> CONFIG_SPI_OC_TINY=m
> CONFIG_SPI_PXA2XX=y
> CONFIG_SPI_PXA2XX_PCI=y
> # CONFIG_SPI_ROCKCHIP is not set
> # CONFIG_SPI_SC18IS602 is not set
> CONFIG_SPI_TOPCLIFF_PCH=y
> CONFIG_SPI_XCOMM=m
> # CONFIG_SPI_XILINX is not set
> CONFIG_SPI_ZYNQMP_GQSPI=m
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> # CONFIG_SPI_LOOPBACK_TEST is not set
> # CONFIG_SPI_TLE62X0 is not set
> CONFIG_SPMI=m
> CONFIG_HSI=m
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI controllers
> #
> 
> #
> # HSI clients
> #
> # CONFIG_HSI_CHAR is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_ACPI=y
> CONFIG_GPIOLIB_IRQCHIP=y
> # CONFIG_DEBUG_GPIO is not set
> CONFIG_GPIO_SYSFS=y
> CONFIG_GPIO_GENERIC=y
> CONFIG_GPIO_MAX730X=m
> 
> #
> # Memory mapped GPIO drivers
> #
> # CONFIG_GPIO_AMDPT is not set
> CONFIG_GPIO_DWAPB=y
> CONFIG_GPIO_GENERIC_PLATFORM=m
> CONFIG_GPIO_ICH=m
> # CONFIG_GPIO_LYNXPOINT is not set
> # CONFIG_GPIO_MOCKUP is not set
> CONFIG_GPIO_VX855=y
> 
> #
> # Port-mapped I/O GPIO drivers
> #
> CONFIG_GPIO_F7188X=m
> CONFIG_GPIO_IT87=y
> # CONFIG_GPIO_SCH is not set
> CONFIG_GPIO_SCH311X=y
> 
> #
> # I2C GPIO expanders
> #
> # CONFIG_GPIO_ADP5588 is not set
> # CONFIG_GPIO_MAX7300 is not set
> # CONFIG_GPIO_MAX732X is not set
> CONFIG_GPIO_PCA953X=m
> CONFIG_GPIO_PCF857X=m
> CONFIG_GPIO_TPIC2810=m
> 
> #
> # MFD GPIO expanders
> #
> CONFIG_GPIO_CS5535=m
> # CONFIG_GPIO_DA9052 is not set
> # CONFIG_GPIO_JANZ_TTL is not set
> CONFIG_GPIO_KEMPLD=m
> CONFIG_GPIO_LP873X=m
> CONFIG_GPIO_TPS65218=m
> # CONFIG_GPIO_TPS65912 is not set
> CONFIG_GPIO_UCB1400=m
> CONFIG_GPIO_WM8994=m
> 
> #
> # PCI GPIO expanders
> #
> CONFIG_GPIO_AMD8111=y
> CONFIG_GPIO_BT8XX=y
> CONFIG_GPIO_ML_IOH=m
> CONFIG_GPIO_PCH=y
> CONFIG_GPIO_PCI_IDIO_16=y
> CONFIG_GPIO_RDC321X=y
> 
> #
> # SPI GPIO expanders
> #
> CONFIG_GPIO_MAX7301=m
> CONFIG_GPIO_MC33880=m
> # CONFIG_GPIO_PISOSR is not set
> 
> #
> # SPI or I2C GPIO expanders
> #
> CONFIG_W1=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2482=m
> CONFIG_W1_MASTER_DS1WM=y
> CONFIG_W1_MASTER_GPIO=y
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=m
> CONFIG_W1_SLAVE_SMEM=m
> CONFIG_W1_SLAVE_DS2405=y
> CONFIG_W1_SLAVE_DS2408=y
> CONFIG_W1_SLAVE_DS2408_READBACK=y
> CONFIG_W1_SLAVE_DS2413=m
> CONFIG_W1_SLAVE_DS2406=y
> # CONFIG_W1_SLAVE_DS2423 is not set
> CONFIG_W1_SLAVE_DS2431=y
> # CONFIG_W1_SLAVE_DS2433 is not set
> # CONFIG_W1_SLAVE_DS2438 is not set
> CONFIG_W1_SLAVE_DS2760=m
> CONFIG_W1_SLAVE_DS2780=y
> # CONFIG_W1_SLAVE_DS2781 is not set
> CONFIG_W1_SLAVE_DS28E04=y
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_AVS=y
> CONFIG_POWER_RESET=y
> # CONFIG_POWER_RESET_RESTART is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> # CONFIG_GENERIC_ADC_BATTERY is not set
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_DS2760=m
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=m
> CONFIG_BATTERY_SBS=m
> CONFIG_CHARGER_SBS=m
> # CONFIG_BATTERY_BQ27XXX is not set
> CONFIG_BATTERY_DA9052=y
> CONFIG_BATTERY_MAX17040=m
> CONFIG_BATTERY_MAX17042=m
> CONFIG_CHARGER_PCF50633=m
> CONFIG_CHARGER_MAX8903=y
> # CONFIG_CHARGER_LP8727 is not set
> CONFIG_CHARGER_GPIO=y
> # CONFIG_CHARGER_MAX14577 is not set
> CONFIG_CHARGER_BQ2415X=m
> CONFIG_CHARGER_BQ24257=m
> # CONFIG_CHARGER_BQ24735 is not set
> # CONFIG_CHARGER_BQ25890 is not set
> # CONFIG_CHARGER_SMB347 is not set
> CONFIG_CHARGER_TPS65217=m
> CONFIG_BATTERY_GAUGE_LTC2941=m
> CONFIG_BATTERY_GOLDFISH=m
> CONFIG_BATTERY_RT5033=m
> CONFIG_CHARGER_RT9455=m
> CONFIG_HWMON=m
> CONFIG_HWMON_VID=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> CONFIG_SENSORS_ABITUGURU3=m
> CONFIG_SENSORS_AD7314=m
> # CONFIG_SENSORS_AD7414 is not set
> CONFIG_SENSORS_AD7418=m
> CONFIG_SENSORS_ADM1021=m
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> CONFIG_SENSORS_ADM9240=m
> CONFIG_SENSORS_ADT7X10=m
> CONFIG_SENSORS_ADT7310=m
> CONFIG_SENSORS_ADT7410=m
> CONFIG_SENSORS_ADT7411=m
> CONFIG_SENSORS_ADT7462=m
> CONFIG_SENSORS_ADT7470=m
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> CONFIG_SENSORS_K8TEMP=m
> # CONFIG_SENSORS_K10TEMP is not set
> CONFIG_SENSORS_FAM15H_POWER=m
> # CONFIG_SENSORS_APPLESMC is not set
> CONFIG_SENSORS_ASB100=m
> CONFIG_SENSORS_ASPEED=m
> CONFIG_SENSORS_ATXP1=m
> CONFIG_SENSORS_DS620=m
> CONFIG_SENSORS_DS1621=m
> CONFIG_SENSORS_DELL_SMM=m
> CONFIG_SENSORS_DA9052_ADC=m
> CONFIG_SENSORS_I5K_AMB=m
> CONFIG_SENSORS_F71805F=m
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=m
> CONFIG_SENSORS_MC13783_ADC=m
> CONFIG_SENSORS_FSCHMD=m
> # CONFIG_SENSORS_GL518SM is not set
> CONFIG_SENSORS_GL520SM=m
> # CONFIG_SENSORS_G760A is not set
> CONFIG_SENSORS_G762=m
> CONFIG_SENSORS_GPIO_FAN=m
> # CONFIG_SENSORS_HIH6130 is not set
> # CONFIG_SENSORS_IIO_HWMON is not set
> # CONFIG_SENSORS_I5500 is not set
> # CONFIG_SENSORS_CORETEMP is not set
> CONFIG_SENSORS_IT87=m
> # CONFIG_SENSORS_JC42 is not set
> CONFIG_SENSORS_POWR1220=m
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LTC2945=m
> CONFIG_SENSORS_LTC2990=m
> CONFIG_SENSORS_LTC4151=m
> CONFIG_SENSORS_LTC4215=m
> # CONFIG_SENSORS_LTC4222 is not set
> CONFIG_SENSORS_LTC4245=m
> # CONFIG_SENSORS_LTC4260 is not set
> CONFIG_SENSORS_LTC4261=m
> CONFIG_SENSORS_MAX1111=m
> CONFIG_SENSORS_MAX16065=m
> # CONFIG_SENSORS_MAX1619 is not set
> CONFIG_SENSORS_MAX1668=m
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX31722=m
> CONFIG_SENSORS_MAX6639=m
> # CONFIG_SENSORS_MAX6642 is not set
> CONFIG_SENSORS_MAX6650=m
> CONFIG_SENSORS_MAX6697=m
> CONFIG_SENSORS_MAX31790=m
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_TC654=m
> CONFIG_SENSORS_ADCXX=m
> CONFIG_SENSORS_LM63=m
> # CONFIG_SENSORS_LM70 is not set
> CONFIG_SENSORS_LM73=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=m
> CONFIG_SENSORS_LM95241=m
> CONFIG_SENSORS_LM95245=m
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> CONFIG_SENSORS_NCT6683=m
> CONFIG_SENSORS_NCT6775=m
> CONFIG_SENSORS_NCT7802=m
> CONFIG_SENSORS_NCT7904=m
> CONFIG_SENSORS_PCF8591=m
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=m
> CONFIG_SENSORS_SHT21=m
> CONFIG_SENSORS_SHT3x=m
> CONFIG_SENSORS_SHTC1=m
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=m
> CONFIG_SENSORS_EMC6W201=m
> CONFIG_SENSORS_SMSC47M1=m
> # CONFIG_SENSORS_SMSC47M192 is not set
> CONFIG_SENSORS_SMSC47B397=m
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> CONFIG_SENSORS_STTS751=m
> CONFIG_SENSORS_SMM665=m
> # CONFIG_SENSORS_ADC128D818 is not set
> CONFIG_SENSORS_ADS1015=m
> CONFIG_SENSORS_ADS7828=m
> # CONFIG_SENSORS_ADS7871 is not set
> CONFIG_SENSORS_AMC6821=m
> # CONFIG_SENSORS_INA209 is not set
> # CONFIG_SENSORS_INA2XX is not set
> CONFIG_SENSORS_INA3221=m
> # CONFIG_SENSORS_TC74 is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> CONFIG_SENSORS_TMP103=m
> # CONFIG_SENSORS_TMP108 is not set
> CONFIG_SENSORS_TMP401=m
> CONFIG_SENSORS_TMP421=m
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> CONFIG_SENSORS_VIA686A=m
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> CONFIG_SENSORS_W83791D=m
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=m
> CONFIG_SENSORS_W83795=m
> CONFIG_SENSORS_W83795_FANCTRL=y
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> CONFIG_SENSORS_W83627HF=m
> CONFIG_SENSORS_W83627EHF=m
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
> CONFIG_THERMAL_WRITABLE_TRIPS=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_BANG_BANG=y
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
> CONFIG_THERMAL_EMULATION=y
> CONFIG_INTEL_POWERCLAMP=m
> CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
> CONFIG_INTEL_SOC_DTS_THERMAL=m
> 
> #
> # ACPI INT340X thermal drivers
> #
> # CONFIG_INT340X_THERMAL is not set
> CONFIG_INTEL_PCH_THERMAL=m
> # CONFIG_GENERIC_ADC_THERMAL is not set
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=m
> # CONFIG_MFD_BCM590XX is not set
> # CONFIG_MFD_AXP20X_I2C is not set
> CONFIG_MFD_CROS_EC=m
> CONFIG_MFD_CROS_EC_I2C=m
> CONFIG_MFD_CROS_EC_SPI=m
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_SPI=y
> CONFIG_MFD_DA9062=m
> # CONFIG_MFD_DA9063 is not set
> # CONFIG_MFD_DA9150 is not set
> CONFIG_MFD_MC13XXX=m
> CONFIG_MFD_MC13XXX_SPI=m
> CONFIG_MFD_MC13XXX_I2C=m
> # CONFIG_HTC_PASIC3 is not set
> CONFIG_MFD_INTEL_QUARK_I2C_GPIO=m
> CONFIG_LPC_ICH=m
> CONFIG_LPC_SCH=y
> CONFIG_MFD_INTEL_LPSS=y
> # CONFIG_MFD_INTEL_LPSS_ACPI is not set
> CONFIG_MFD_INTEL_LPSS_PCI=y
> CONFIG_MFD_JANZ_CMODIO=m
> CONFIG_MFD_KEMPLD=m
> # CONFIG_MFD_88PM800 is not set
> # CONFIG_MFD_88PM805 is not set
> CONFIG_MFD_MAX14577=m
> # CONFIG_MFD_MAX77693 is not set
> CONFIG_MFD_MAX8907=m
> # CONFIG_MFD_MT6397 is not set
> # CONFIG_MFD_MENF21BMC is not set
> # CONFIG_EZX_PCAP is not set
> # CONFIG_MFD_RETU is not set
> CONFIG_MFD_PCF50633=m
> # CONFIG_PCF50633_ADC is not set
> CONFIG_PCF50633_GPIO=m
> CONFIG_UCB1400_CORE=m
> CONFIG_MFD_RDC321X=y
> CONFIG_MFD_RTSX_PCI=m
> CONFIG_MFD_RT5033=m
> CONFIG_MFD_SI476X_CORE=m
> CONFIG_MFD_SM501=m
> CONFIG_MFD_SM501_GPIO=y
> CONFIG_MFD_SKY81452=m
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_SYSCON=y
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> # CONFIG_MFD_LP3943 is not set
> CONFIG_MFD_TI_LMU=m
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65086 is not set
> CONFIG_MFD_TPS65217=m
> CONFIG_MFD_TI_LP873X=m
> CONFIG_MFD_TPS65218=m
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=m
> CONFIG_MFD_TPS65912_SPI=y
> CONFIG_MFD_WL1273_CORE=m
> CONFIG_MFD_LM3533=m
> # CONFIG_MFD_TIMBERDALE is not set
> # CONFIG_MFD_TMIO is not set
> CONFIG_MFD_VX855=y
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_ARIZONA_SPI is not set
> # CONFIG_MFD_WM831X_SPI is not set
> CONFIG_MFD_WM8994=m
> # CONFIG_REGULATOR is not set
> CONFIG_MEDIA_SUPPORT=m
> 
> #
> # Multimedia core support
> #
> CONFIG_MEDIA_CAMERA_SUPPORT=y
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> CONFIG_MEDIA_RADIO_SUPPORT=y
> # CONFIG_MEDIA_SDR_SUPPORT is not set
> CONFIG_MEDIA_RC_SUPPORT=y
> CONFIG_MEDIA_CEC_SUPPORT=y
> CONFIG_CEC_CORE=m
> CONFIG_MEDIA_CEC_RC=y
> CONFIG_MEDIA_CEC_DEBUG=y
> CONFIG_MEDIA_CONTROLLER=y
> CONFIG_VIDEO_DEV=m
> # CONFIG_VIDEO_V4L2_SUBDEV_API is not set
> CONFIG_VIDEO_V4L2=m
> CONFIG_VIDEO_ADV_DEBUG=y
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> # CONFIG_VIDEO_PCI_SKELETON is not set
> CONFIG_V4L2_MEM2MEM_DEV=m
> CONFIG_VIDEOBUF2_CORE=m
> CONFIG_VIDEOBUF2_MEMOPS=m
> CONFIG_VIDEOBUF2_DMA_CONTIG=m
> CONFIG_VIDEOBUF2_VMALLOC=m
> # CONFIG_TTPCI_EEPROM is not set
> 
> #
> # Media drivers
> #
> CONFIG_RC_CORE=m
> CONFIG_RC_MAP=m
> CONFIG_RC_DECODERS=y
> CONFIG_LIRC=m
> CONFIG_IR_LIRC_CODEC=m
> # CONFIG_IR_NEC_DECODER is not set
> CONFIG_IR_RC5_DECODER=m
> # CONFIG_IR_RC6_DECODER is not set
> CONFIG_IR_JVC_DECODER=m
> CONFIG_IR_SONY_DECODER=m
> # CONFIG_IR_SANYO_DECODER is not set
> CONFIG_IR_SHARP_DECODER=m
> # CONFIG_IR_MCE_KBD_DECODER is not set
> CONFIG_IR_XMP_DECODER=m
> CONFIG_RC_DEVICES=y
> # CONFIG_RC_ATI_REMOTE is not set
> # CONFIG_IR_ENE is not set
> CONFIG_IR_HIX5HD2=m
> # CONFIG_IR_IMON is not set
> # CONFIG_IR_MCEUSB is not set
> # CONFIG_IR_ITE_CIR is not set
> # CONFIG_IR_FINTEK is not set
> # CONFIG_IR_NUVOTON is not set
> # CONFIG_IR_REDRAT3 is not set
> CONFIG_IR_SPI=m
> # CONFIG_IR_STREAMZAP is not set
> # CONFIG_IR_WINBOND_CIR is not set
> # CONFIG_IR_IGORPLUGUSB is not set
> # CONFIG_IR_IGUANA is not set
> # CONFIG_IR_TTUSBIR is not set
> CONFIG_RC_LOOPBACK=m
> # CONFIG_IR_GPIO_CIR is not set
> CONFIG_IR_SERIAL=m
> CONFIG_IR_SERIAL_TRANSMITTER=y
> CONFIG_IR_SIR=m
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> # CONFIG_V4L_PLATFORM_DRIVERS is not set
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
> CONFIG_V4L_TEST_DRIVERS=y
> CONFIG_VIDEO_VIVID=m
> # CONFIG_VIDEO_VIVID_CEC is not set
> CONFIG_VIDEO_VIVID_MAX_DEVS=64
> CONFIG_VIDEO_VIM2M=m
> # CONFIG_CEC_PLATFORM_DRIVERS is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> # CONFIG_RADIO_ADAPTERS is not set
> CONFIG_VIDEO_V4L2_TPG=m
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
> #
> CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
> CONFIG_MEDIA_ATTACH=y
> CONFIG_VIDEO_IR_I2C=m
> 
> #
> # Audio decoders, processors and mixers
> #
> 
> #
> # RDS decoders
> #
> 
> #
> # Video decoders
> #
> 
> #
> # Video and audio decoders
> #
> 
> #
> # Video encoders
> #
> 
> #
> # Camera sensor devices
> #
> 
> #
> # Flash devices
> #
> 
> #
> # Video improvement chips
> #
> 
> #
> # Audio/Video compression chips
> #
> 
> #
> # Miscellaneous helper chips
> #
> 
> #
> # Sensors used on soc_camera driver
> #
> CONFIG_MEDIA_TUNER=m
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_XC2028=m
> CONFIG_MEDIA_TUNER_XC5000=m
> CONFIG_MEDIA_TUNER_XC4000=m
> CONFIG_MEDIA_TUNER_MC44S803=m
> 
> #
> # Tools to develop new frontends
> #
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_INTEL_GTT=m
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=m
> CONFIG_DRM_MIPI_DSI=y
> # CONFIG_DRM_DP_AUX_CHARDEV is not set
> # CONFIG_DRM_DEBUG_MM_SELFTEST is not set
> CONFIG_DRM_KMS_HELPER=m
> CONFIG_DRM_KMS_FB_HELPER=y
> CONFIG_DRM_FBDEV_EMULATION=y
> CONFIG_DRM_FBDEV_OVERALLOC=100
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=m
> CONFIG_DRM_VM=y
> 
> #
> # I2C encoder or helper chips
> #
> # CONFIG_DRM_I2C_CH7006 is not set
> # CONFIG_DRM_I2C_SIL164 is not set
> CONFIG_DRM_I2C_NXP_TDA998X=m
> CONFIG_DRM_RADEON=m
> # CONFIG_DRM_RADEON_USERPTR is not set
> CONFIG_DRM_AMDGPU=m
> CONFIG_DRM_AMDGPU_SI=y
> CONFIG_DRM_AMDGPU_CIK=y
> # CONFIG_DRM_AMDGPU_USERPTR is not set
> CONFIG_DRM_AMDGPU_GART_DEBUGFS=y
> 
> #
> # ACP (Audio CoProcessor) Configuration
> #
> # CONFIG_DRM_AMD_ACP is not set
> CONFIG_DRM_NOUVEAU=m
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> CONFIG_DRM_I915=m
> # CONFIG_DRM_I915_ALPHA_SUPPORT is not set
> CONFIG_DRM_I915_CAPTURE_ERROR=y
> # CONFIG_DRM_I915_COMPRESS_ERROR is not set
> CONFIG_DRM_I915_USERPTR=y
> CONFIG_DRM_VGEM=m
> CONFIG_DRM_VMWGFX=m
> # CONFIG_DRM_VMWGFX_FBCON is not set
> CONFIG_DRM_GMA500=m
> # CONFIG_DRM_GMA600 is not set
> CONFIG_DRM_GMA3600=y
> # CONFIG_DRM_UDL is not set
> # CONFIG_DRM_AST is not set
> CONFIG_DRM_MGAG200=m
> # CONFIG_DRM_CIRRUS_QEMU is not set
> CONFIG_DRM_QXL=m
> CONFIG_DRM_BOCHS=m
> CONFIG_DRM_VIRTIO_GPU=m
> CONFIG_DRM_PANEL=y
> 
> #
> # Display Panels
> #
> CONFIG_DRM_BRIDGE=y
> 
> #
> # Display Interface Bridges
> #
> # CONFIG_DRM_ANALOGIX_ANX78XX is not set
> CONFIG_DRM_HISI_HIBMC=m
> # CONFIG_DRM_TINYDRM is not set
> CONFIG_DRM_LEGACY=y
> CONFIG_DRM_TDFX=m
> CONFIG_DRM_R128=m
> CONFIG_DRM_MGA=m
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_LIB_RANDOM is not set
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=m
> # CONFIG_FIRMWARE_EDID is not set
> CONFIG_FB_CMDLINE=y
> CONFIG_FB_NOTIFY=y
> CONFIG_FB_DDC=m
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_FB_CFB_COPYAREA=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=m
> CONFIG_FB_SYS_COPYAREA=m
> CONFIG_FB_SYS_IMAGEBLIT=m
> # CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=m
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_HECUBA=m
> CONFIG_FB_SVGALIB=m
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> CONFIG_FB_CIRRUS=m
> # CONFIG_FB_PM2 is not set
> CONFIG_FB_CYBER2000=m
> # CONFIG_FB_CYBER2000_DDC is not set
> CONFIG_FB_ARC=m
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_N411=m
> # CONFIG_FB_HGA is not set
> CONFIG_FB_OPENCORES=m
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> CONFIG_FB_RIVA=m
> CONFIG_FB_RIVA_I2C=y
> # CONFIG_FB_RIVA_DEBUG is not set
> CONFIG_FB_RIVA_BACKLIGHT=y
> CONFIG_FB_I740=m
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> CONFIG_FB_RADEON=m
> CONFIG_FB_RADEON_I2C=y
> # CONFIG_FB_RADEON_BACKLIGHT is not set
> # CONFIG_FB_RADEON_DEBUG is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> CONFIG_FB_S3=m
> # CONFIG_FB_S3_DDC is not set
> # CONFIG_FB_SAVAGE is not set
> CONFIG_FB_SIS=m
> # CONFIG_FB_SIS_300 is not set
> CONFIG_FB_SIS_315=y
> CONFIG_FB_VIA=m
> CONFIG_FB_VIA_DIRECT_PROCFS=y
> CONFIG_FB_VIA_X_COMPATIBILITY=y
> # CONFIG_FB_NEOMAGIC is not set
> CONFIG_FB_KYRO=m
> CONFIG_FB_3DFX=m
> CONFIG_FB_3DFX_ACCEL=y
> CONFIG_FB_3DFX_I2C=y
> CONFIG_FB_VOODOO1=m
> CONFIG_FB_VT8623=m
> CONFIG_FB_TRIDENT=m
> CONFIG_FB_ARK=m
> CONFIG_FB_PM3=m
> CONFIG_FB_CARMINE=m
> CONFIG_FB_CARMINE_DRAM_EVAL=y
> # CONFIG_CARMINE_DRAM_CUSTOM is not set
> # CONFIG_FB_GEODE is not set
> CONFIG_FB_SM501=m
> # CONFIG_FB_IBM_GXT4500 is not set
> CONFIG_FB_GOLDFISH=m
> CONFIG_FB_VIRTUAL=m
> CONFIG_FB_METRONOME=m
> CONFIG_FB_MB862XX=m
> CONFIG_FB_MB862XX_PCI_GDC=y
> CONFIG_FB_MB862XX_I2C=y
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_FB_AUO_K190X=m
> CONFIG_FB_AUO_K1900=m
> CONFIG_FB_AUO_K1901=m
> # CONFIG_FB_SM712 is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_L4F00242T03=y
> CONFIG_LCD_LMS283GF05=y
> CONFIG_LCD_LTV350QV=m
> CONFIG_LCD_ILI922X=m
> CONFIG_LCD_ILI9320=m
> # CONFIG_LCD_TDO24M is not set
> CONFIG_LCD_VGG2432A4=m
> # CONFIG_LCD_PLATFORM is not set
> # CONFIG_LCD_S6E63M0 is not set
> CONFIG_LCD_LD9040=m
> CONFIG_LCD_AMS369FG06=m
> CONFIG_LCD_LMS501KF03=y
> CONFIG_LCD_HX8357=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> # CONFIG_BACKLIGHT_GENERIC is not set
> # CONFIG_BACKLIGHT_LM3533 is not set
> # CONFIG_BACKLIGHT_DA9052 is not set
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_PM8941_WLED=m
> CONFIG_BACKLIGHT_SAHARA=m
> CONFIG_BACKLIGHT_ADP8860=m
> # CONFIG_BACKLIGHT_ADP8870 is not set
> CONFIG_BACKLIGHT_PCF50633=m
> # CONFIG_BACKLIGHT_LM3639 is not set
> CONFIG_BACKLIGHT_OT200=m
> CONFIG_BACKLIGHT_SKY81452=m
> CONFIG_BACKLIGHT_TPS65217=m
> # CONFIG_BACKLIGHT_GPIO is not set
> # CONFIG_BACKLIGHT_LV5207LP is not set
> CONFIG_BACKLIGHT_BD6107=m
> # CONFIG_BACKLIGHT_ARCXCNN is not set
> CONFIG_VGASTATE=m
> CONFIG_HDMI=y
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT=y
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_DUMMY_CONSOLE_COLUMNS=80
> CONFIG_DUMMY_CONSOLE_ROWS=25
> CONFIG_FRAMEBUFFER_CONSOLE=m
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> # CONFIG_LOGO_LINUX_VGA16 is not set
> # CONFIG_LOGO_LINUX_CLUT224 is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_PCM_ELD=y
> CONFIG_SND_PCM_IEC958=y
> CONFIG_SND_DMAENGINE_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_JACK=y
> CONFIG_SND_JACK_INPUT_DEV=y
> # CONFIG_SND_SEQUENCER is not set
> CONFIG_SND_OSSEMUL=y
> # CONFIG_SND_MIXER_OSS is not set
> CONFIG_SND_PCM_OSS=m
> # CONFIG_SND_PCM_OSS_PLUGINS is not set
> CONFIG_SND_PCM_TIMER=y
> # CONFIG_SND_HRTIMER is not set
> # CONFIG_SND_DYNAMIC_MINORS is not set
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_PROC_FS=y
> # CONFIG_SND_VERBOSE_PROCFS is not set
> CONFIG_SND_VERBOSE_PRINTK=y
> CONFIG_SND_DEBUG=y
> CONFIG_SND_DEBUG_VERBOSE=y
> CONFIG_SND_VMASTER=y
> CONFIG_SND_DMA_SGBUF=y
> # CONFIG_SND_RAWMIDI_SEQ is not set
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_OPL3_LIB=m
> CONFIG_SND_VX_LIB=m
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_PCSP=m
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_ALOOP is not set
> # CONFIG_SND_MTPAV is not set
> CONFIG_SND_MTS64=m
> CONFIG_SND_SERIAL_U16550=m
> # CONFIG_SND_MPU401 is not set
> CONFIG_SND_PORTMAN2X4=m
> # CONFIG_SND_AC97_POWER_SAVE is not set
> CONFIG_SND_SB_COMMON=m
> CONFIG_SND_SB16_DSP=m
> CONFIG_SND_PCI=y
> CONFIG_SND_AD1889=m
> # CONFIG_SND_ALS300 is not set
> CONFIG_SND_ALS4000=m
> CONFIG_SND_ALI5451=m
> CONFIG_SND_ASIHPI=m
> CONFIG_SND_ATIIXP=m
> CONFIG_SND_ATIIXP_MODEM=m
> CONFIG_SND_AU8810=m
> CONFIG_SND_AU8820=m
> CONFIG_SND_AU8830=m
> CONFIG_SND_AW2=m
> CONFIG_SND_AZT3328=m
> CONFIG_SND_BT87X=m
> # CONFIG_SND_BT87X_OVERCLOCK is not set
> CONFIG_SND_CA0106=m
> CONFIG_SND_CMIPCI=m
> CONFIG_SND_OXYGEN_LIB=m
> CONFIG_SND_OXYGEN=m
> CONFIG_SND_CS4281=m
> # CONFIG_SND_CS46XX is not set
> CONFIG_SND_CS5530=m
> CONFIG_SND_CS5535AUDIO=m
> # CONFIG_SND_CTXFI is not set
> CONFIG_SND_DARLA20=m
> CONFIG_SND_GINA20=m
> CONFIG_SND_LAYLA20=m
> CONFIG_SND_DARLA24=m
> CONFIG_SND_GINA24=m
> CONFIG_SND_LAYLA24=m
> CONFIG_SND_MONA=m
> CONFIG_SND_MIA=m
> CONFIG_SND_ECHO3G=m
> CONFIG_SND_INDIGO=m
> # CONFIG_SND_INDIGOIO is not set
> CONFIG_SND_INDIGODJ=m
> CONFIG_SND_INDIGOIOX=m
> CONFIG_SND_INDIGODJX=m
> CONFIG_SND_EMU10K1=m
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> CONFIG_SND_ENS1371=m
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDSP=m
> CONFIG_SND_HDSPM=m
> CONFIG_SND_ICE1712=m
> CONFIG_SND_ICE1724=m
> CONFIG_SND_INTEL8X0=m
> # CONFIG_SND_INTEL8X0M is not set
> CONFIG_SND_KORG1212=m
> CONFIG_SND_LOLA=m
> # CONFIG_SND_LX6464ES is not set
> CONFIG_SND_MAESTRO3=m
> # CONFIG_SND_MAESTRO3_INPUT is not set
> CONFIG_SND_MIXART=m
> CONFIG_SND_NM256=m
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SIS7019 is not set
> CONFIG_SND_SONICVIBES=m
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> CONFIG_SND_VIA82XX_MODEM=m
> # CONFIG_SND_VIRTUOSO is not set
> CONFIG_SND_VX222=m
> CONFIG_SND_YMFPCI=m
> 
> #
> # HD-Audio
> #
> # CONFIG_SND_HDA_INTEL is not set
> CONFIG_SND_HDA_PREALLOC_SIZE=64
> CONFIG_SND_SPI=y
> # CONFIG_SND_FIREWIRE is not set
> CONFIG_SND_PCMCIA=y
> CONFIG_SND_VXPOCKET=m
> CONFIG_SND_PDAUDIOCF=m
> CONFIG_SND_SOC=m
> CONFIG_SND_SOC_AC97_BUS=y
> CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
> CONFIG_SND_SOC_AMD_ACP=m
> # CONFIG_SND_ATMEL_SOC is not set
> # CONFIG_SND_DESIGNWARE_I2S is not set
> 
> #
> # SoC Audio for Freescale CPUs
> #
> 
> #
> # Common SoC Audio options for Freescale CPUs:
> #
> CONFIG_SND_SOC_FSL_ASRC=m
> CONFIG_SND_SOC_FSL_SAI=m
> # CONFIG_SND_SOC_FSL_SSI is not set
> # CONFIG_SND_SOC_FSL_SPDIF is not set
> CONFIG_SND_SOC_FSL_ESAI=m
> # CONFIG_SND_SOC_IMX_AUDMUX is not set
> # CONFIG_SND_I2S_HI6210_I2S is not set
> CONFIG_SND_SOC_IMG=y
> CONFIG_SND_SOC_IMG_I2S_IN=m
> CONFIG_SND_SOC_IMG_I2S_OUT=m
> # CONFIG_SND_SOC_IMG_PARALLEL_OUT is not set
> CONFIG_SND_SOC_IMG_SPDIF_IN=m
> CONFIG_SND_SOC_IMG_SPDIF_OUT=m
> CONFIG_SND_SOC_IMG_PISTACHIO_INTERNAL_DAC=m
> # CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH is not set
> # CONFIG_SND_SOC_INTEL_BXT_RT298_MACH is not set
> # CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH is not set
> # CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH is not set
> # CONFIG_SND_SOC_INTEL_SKL_RT286_MACH is not set
> CONFIG_SND_SOC_XTFPGA_I2S=m
> # CONFIG_ZX_TDM is not set
> CONFIG_SND_SOC_I2C_AND_SPI=m
> 
> #
> # CODEC drivers
> #
> CONFIG_SND_SOC_AC97_CODEC=m
> CONFIG_SND_SOC_ADAU_UTILS=m
> CONFIG_SND_SOC_ADAU1701=m
> CONFIG_SND_SOC_ADAU17X1=m
> CONFIG_SND_SOC_ADAU1761=m
> CONFIG_SND_SOC_ADAU1761_I2C=m
> CONFIG_SND_SOC_ADAU1761_SPI=m
> CONFIG_SND_SOC_ADAU7002=m
> CONFIG_SND_SOC_AK4104=m
> CONFIG_SND_SOC_AK4554=m
> CONFIG_SND_SOC_AK4613=m
> CONFIG_SND_SOC_AK4642=m
> CONFIG_SND_SOC_AK5386=m
> CONFIG_SND_SOC_ALC5623=m
> CONFIG_SND_SOC_BT_SCO=m
> CONFIG_SND_SOC_CS35L32=m
> CONFIG_SND_SOC_CS35L33=m
> CONFIG_SND_SOC_CS35L34=m
> CONFIG_SND_SOC_CS35L35=m
> CONFIG_SND_SOC_CS42L42=m
> CONFIG_SND_SOC_CS42L51=m
> CONFIG_SND_SOC_CS42L51_I2C=m
> CONFIG_SND_SOC_CS42L52=m
> CONFIG_SND_SOC_CS42L56=m
> CONFIG_SND_SOC_CS42L73=m
> CONFIG_SND_SOC_CS4265=m
> CONFIG_SND_SOC_CS4270=m
> CONFIG_SND_SOC_CS4271=m
> CONFIG_SND_SOC_CS4271_I2C=m
> CONFIG_SND_SOC_CS4271_SPI=m
> CONFIG_SND_SOC_CS42XX8=m
> CONFIG_SND_SOC_CS42XX8_I2C=m
> CONFIG_SND_SOC_CS4349=m
> CONFIG_SND_SOC_CS53L30=m
> CONFIG_SND_SOC_DIO2125=m
> CONFIG_SND_SOC_HDMI_CODEC=m
> CONFIG_SND_SOC_ES7134=m
> CONFIG_SND_SOC_ES8328=m
> CONFIG_SND_SOC_ES8328_I2C=m
> CONFIG_SND_SOC_ES8328_SPI=m
> CONFIG_SND_SOC_GTM601=m
> CONFIG_SND_SOC_INNO_RK3036=m
> CONFIG_SND_SOC_MAX98504=m
> CONFIG_SND_SOC_MAX98927=m
> CONFIG_SND_SOC_MAX9860=m
> # CONFIG_SND_SOC_MSM8916_WCD_ANALOG is not set
> CONFIG_SND_SOC_MSM8916_WCD_DIGITAL=m
> CONFIG_SND_SOC_PCM1681=m
> CONFIG_SND_SOC_PCM179X=m
> CONFIG_SND_SOC_PCM179X_I2C=m
> CONFIG_SND_SOC_PCM179X_SPI=m
> CONFIG_SND_SOC_PCM3168A=m
> CONFIG_SND_SOC_PCM3168A_I2C=m
> CONFIG_SND_SOC_PCM3168A_SPI=m
> CONFIG_SND_SOC_PCM512x=m
> CONFIG_SND_SOC_PCM512x_I2C=m
> CONFIG_SND_SOC_PCM512x_SPI=m
> CONFIG_SND_SOC_RL6231=m
> CONFIG_SND_SOC_RT5616=m
> CONFIG_SND_SOC_RT5631=m
> # CONFIG_SND_SOC_RT5677_SPI is not set
> CONFIG_SND_SOC_SGTL5000=m
> CONFIG_SND_SOC_SIGMADSP=m
> CONFIG_SND_SOC_SIGMADSP_I2C=m
> CONFIG_SND_SOC_SIGMADSP_REGMAP=m
> CONFIG_SND_SOC_SIRF_AUDIO_CODEC=m
> CONFIG_SND_SOC_SPDIF=m
> CONFIG_SND_SOC_SSM2602=m
> CONFIG_SND_SOC_SSM2602_SPI=m
> CONFIG_SND_SOC_SSM2602_I2C=m
> CONFIG_SND_SOC_SSM4567=m
> CONFIG_SND_SOC_STA32X=m
> CONFIG_SND_SOC_STA350=m
> CONFIG_SND_SOC_STI_SAS=m
> CONFIG_SND_SOC_TAS2552=m
> CONFIG_SND_SOC_TAS5086=m
> CONFIG_SND_SOC_TAS571X=m
> CONFIG_SND_SOC_TAS5720=m
> CONFIG_SND_SOC_TFA9879=m
> CONFIG_SND_SOC_TLV320AIC23=m
> CONFIG_SND_SOC_TLV320AIC23_I2C=m
> CONFIG_SND_SOC_TLV320AIC23_SPI=m
> CONFIG_SND_SOC_TLV320AIC31XX=m
> CONFIG_SND_SOC_TLV320AIC3X=m
> CONFIG_SND_SOC_TS3A227E=m
> CONFIG_SND_SOC_WM8510=m
> CONFIG_SND_SOC_WM8523=m
> CONFIG_SND_SOC_WM8580=m
> CONFIG_SND_SOC_WM8711=m
> CONFIG_SND_SOC_WM8728=m
> CONFIG_SND_SOC_WM8731=m
> CONFIG_SND_SOC_WM8737=m
> CONFIG_SND_SOC_WM8741=m
> CONFIG_SND_SOC_WM8750=m
> CONFIG_SND_SOC_WM8753=m
> CONFIG_SND_SOC_WM8770=m
> CONFIG_SND_SOC_WM8776=m
> CONFIG_SND_SOC_WM8804=m
> CONFIG_SND_SOC_WM8804_I2C=m
> CONFIG_SND_SOC_WM8804_SPI=m
> CONFIG_SND_SOC_WM8903=m
> CONFIG_SND_SOC_WM8960=m
> CONFIG_SND_SOC_WM8962=m
> CONFIG_SND_SOC_WM8974=m
> CONFIG_SND_SOC_WM8978=m
> CONFIG_SND_SOC_WM8985=m
> CONFIG_SND_SOC_NAU8540=m
> CONFIG_SND_SOC_NAU8810=m
> CONFIG_SND_SOC_NAU8824=m
> CONFIG_SND_SOC_TPA6130A2=m
> CONFIG_SND_SIMPLE_CARD_UTILS=m
> CONFIG_SND_SIMPLE_CARD=m
> CONFIG_SND_X86=y
> CONFIG_HDMI_LPE_AUDIO=m
> CONFIG_AC97_BUS=m
> 
> #
> # HID support
> #
> CONFIG_HID=m
> # CONFIG_HID_BATTERY_STRENGTH is not set
> CONFIG_HIDRAW=y
> CONFIG_UHID=m
> # CONFIG_HID_GENERIC is not set
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_A4TECH is not set
> CONFIG_HID_ACRUX=m
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=m
> # CONFIG_HID_ASUS is not set
> CONFIG_HID_AUREAL=m
> CONFIG_HID_BELKIN=m
> CONFIG_HID_CHERRY=m
> CONFIG_HID_CHICONY=m
> CONFIG_HID_PRODIKEYS=m
> CONFIG_HID_CMEDIA=m
> CONFIG_HID_CYPRESS=m
> # CONFIG_HID_DRAGONRISE is not set
> CONFIG_HID_EMS_FF=m
> CONFIG_HID_ELECOM=m
> CONFIG_HID_EZKEY=m
> CONFIG_HID_GEMBIRD=m
> # CONFIG_HID_GFRM is not set
> CONFIG_HID_KEYTOUCH=m
> CONFIG_HID_KYE=m
> CONFIG_HID_WALTOP=m
> CONFIG_HID_GYRATION=m
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=m
> # CONFIG_HID_LCPOWER is not set
> CONFIG_HID_LED=m
> # CONFIG_HID_LENOVO is not set
> # CONFIG_HID_LOGITECH is not set
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MAYFLASH=m
> CONFIG_HID_MICROSOFT=m
> # CONFIG_HID_MONTEREY is not set
> CONFIG_HID_MULTITOUCH=m
> # CONFIG_HID_NTI is not set
> CONFIG_HID_ORTEK=m
> CONFIG_HID_PANTHERLORD=m
> CONFIG_PANTHERLORD_FF=y
> CONFIG_HID_PETALYNX=m
> # CONFIG_HID_PICOLCD is not set
> CONFIG_HID_PLANTRONICS=m
> CONFIG_HID_PRIMAX=m
> CONFIG_HID_SAITEK=m
> CONFIG_HID_SAMSUNG=m
> CONFIG_HID_SPEEDLINK=m
> CONFIG_HID_STEELSERIES=m
> CONFIG_HID_SUNPLUS=m
> # CONFIG_HID_RMI is not set
> CONFIG_HID_GREENASIA=m
> CONFIG_GREENASIA_FF=y
> # CONFIG_HID_SMARTJOYPLUS is not set
> CONFIG_HID_TIVO=m
> CONFIG_HID_TOPSEED=m
> CONFIG_HID_THINGM=m
> # CONFIG_HID_THRUSTMASTER is not set
> CONFIG_HID_UDRAW_PS3=m
> # CONFIG_HID_WACOM is not set
> CONFIG_HID_WIIMOTE=m
> CONFIG_HID_XINMO=m
> CONFIG_HID_ZEROPLUS=m
> CONFIG_ZEROPLUS_FF=y
> CONFIG_HID_ZYDACRON=m
> # CONFIG_HID_SENSOR_HUB is not set
> # CONFIG_HID_ALPS is not set
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=m
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> # CONFIG_USB is not set
> CONFIG_USB_PCI=y
> 
> #
> # USB port drivers
> #
> 
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_USB_GADGET is not set
> 
> #
> # USB Power Delivery and Type-C drivers
> #
> # CONFIG_USB_LED_TRIG is not set
> # CONFIG_USB_ULPI_BUS is not set
> CONFIG_UWB=m
> CONFIG_UWB_WHCI=m
> CONFIG_MMC=m
> # CONFIG_MMC_DEBUG is not set
> # CONFIG_MMC_BLOCK is not set
> # CONFIG_SDIO_UART is not set
> CONFIG_MMC_TEST=m
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_SDHCI is not set
> CONFIG_MMC_WBSD=m
> # CONFIG_MMC_TIFM_SD is not set
> CONFIG_MMC_GOLDFISH=m
> # CONFIG_MMC_SDRICOH_CS is not set
> # CONFIG_MMC_CB710 is not set
> # CONFIG_MMC_VIA_SDMMC is not set
> CONFIG_MMC_USDHI6ROL0=m
> CONFIG_MMC_REALTEK_PCI=m
> CONFIG_MMC_TOSHIBA_PCI=m
> CONFIG_MMC_MTK=m
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=m
> CONFIG_LEDS_CLASS_FLASH=m
> # CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=m
> # CONFIG_LEDS_LM3533 is not set
> CONFIG_LEDS_LM3642=m
> CONFIG_LEDS_NET48XX=m
> # CONFIG_LEDS_WRAP is not set
> CONFIG_LEDS_PCA9532=m
> # CONFIG_LEDS_PCA9532_GPIO is not set
> # CONFIG_LEDS_GPIO is not set
> CONFIG_LEDS_LP3944=m
> CONFIG_LEDS_LP3952=m
> CONFIG_LEDS_LP55XX_COMMON=m
> CONFIG_LEDS_LP5521=m
> CONFIG_LEDS_LP5523=m
> # CONFIG_LEDS_LP5562 is not set
> CONFIG_LEDS_LP8501=m
> # CONFIG_LEDS_LP8860 is not set
> CONFIG_LEDS_CLEVO_MAIL=m
> CONFIG_LEDS_PCA955X=m
> CONFIG_LEDS_PCA963X=m
> CONFIG_LEDS_DA9052=m
> # CONFIG_LEDS_DAC124S085 is not set
> CONFIG_LEDS_BD2802=m
> # CONFIG_LEDS_INTEL_SS4200 is not set
> CONFIG_LEDS_LT3593=m
> # CONFIG_LEDS_MC13783 is not set
> CONFIG_LEDS_TCA6507=m
> # CONFIG_LEDS_TLC591XX is not set
> # CONFIG_LEDS_LM355x is not set
> CONFIG_LEDS_OT200=m
> 
> #
> # LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
> #
> # CONFIG_LEDS_BLINKM is not set
> CONFIG_LEDS_USER=m
> # CONFIG_LEDS_NIC78BX is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> # CONFIG_LEDS_TRIGGER_ONESHOT is not set
> # CONFIG_LEDS_TRIGGER_DISK is not set
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> # CONFIG_LEDS_TRIGGER_CPU is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> # CONFIG_LEDS_TRIGGER_CAMERA is not set
> # CONFIG_LEDS_TRIGGER_PANIC is not set
> CONFIG_ACCESSIBILITY=y
> CONFIG_A11Y_BRAILLE_CONSOLE=y
> CONFIG_EDAC_ATOMIC_SCRUB=y
> CONFIG_EDAC_SUPPORT=y
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_MC146818_LIB=y
> # CONFIG_RTC_CLASS is not set
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_VIRTUAL_CHANNELS=m
> CONFIG_DMA_ACPI=y
> CONFIG_INTEL_IDMA64=m
> # CONFIG_PCH_DMA is not set
> CONFIG_QCOM_HIDMA_MGMT=m
> CONFIG_QCOM_HIDMA=y
> CONFIG_DW_DMAC_CORE=y
> CONFIG_DW_DMAC=y
> # CONFIG_DW_DMAC_PCI is not set
> CONFIG_HSU_DMA=m
> 
> #
> # DMA Clients
> #
> CONFIG_ASYNC_TX_DMA=y
> CONFIG_DMATEST=y
> CONFIG_DMA_ENGINE_RAID=y
> 
> #
> # DMABUF options
> #
> CONFIG_SYNC_FILE=y
> # CONFIG_SW_SYNC is not set
> CONFIG_AUXDISPLAY=y
> CONFIG_CHARLCD=m
> # CONFIG_HD44780 is not set
> CONFIG_IMG_ASCII_LCD=y
> CONFIG_PANEL=m
> CONFIG_PANEL_PARPORT=0
> CONFIG_PANEL_PROFILE=5
> CONFIG_PANEL_CHANGE_MESSAGE=y
> CONFIG_PANEL_BOOT_MESSAGE=""
> CONFIG_UIO=y
> CONFIG_UIO_CIF=m
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=m
> CONFIG_UIO_AEC=m
> CONFIG_UIO_SERCOS3=y
> CONFIG_UIO_PCI_GENERIC=y
> CONFIG_UIO_NETX=m
> # CONFIG_UIO_PRUSS is not set
> # CONFIG_UIO_MF624 is not set
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=y
> # CONFIG_VIRTIO_PCI_LEGACY is not set
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_INPUT=y
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV_TSCPAGE is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> # CONFIG_ACERHDF is not set
> # CONFIG_ALIENWARE_WMI is not set
> # CONFIG_ASUS_LAPTOP is not set
> CONFIG_DELL_SMBIOS=m
> CONFIG_DELL_LAPTOP=m
> # CONFIG_DELL_WMI is not set
> # CONFIG_DELL_WMI_AIO is not set
> # CONFIG_DELL_WMI_LED is not set
> # CONFIG_DELL_SMO8800 is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_TC1100_WMI is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_SURFACE3_WMI is not set
> # CONFIG_THINKPAD_ACPI is not set
> CONFIG_SENSORS_HDAPS=y
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_EEEPC_LAPTOP is not set
> # CONFIG_ASUS_WMI is not set
> # CONFIG_ASUS_WIRELESS is not set
> CONFIG_ACPI_WMI=m
> # CONFIG_MSI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_TOSHIBA_HAPS is not set
> # CONFIG_TOSHIBA_WMI is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_CHT_INT33FE is not set
> # CONFIG_INTEL_HID_EVENT is not set
> # CONFIG_INTEL_VBTN is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_INTEL_PMC_CORE is not set
> CONFIG_IBM_RTL=y
> CONFIG_SAMSUNG_LAPTOP=m
> CONFIG_MXM_WMI=m
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> # CONFIG_INTEL_PMC_IPC is not set
> # CONFIG_SURFACE_PRO3_BUTTON is not set
> CONFIG_INTEL_PUNIT_IPC=m
> CONFIG_MLX_CPLD_PLATFORM=m
> CONFIG_PMC_ATOM=y
> # CONFIG_GOLDFISH_BUS is not set
> CONFIG_GOLDFISH_PIPE=y
> CONFIG_CHROME_PLATFORMS=y
> CONFIG_CHROMEOS_LAPTOP=m
> CONFIG_CHROMEOS_PSTORE=y
> CONFIG_CROS_EC_CHARDEV=m
> # CONFIG_CROS_EC_LPC is not set
> CONFIG_CROS_EC_PROTO=y
> # CONFIG_CROS_KBD_LED_BACKLIGHT is not set
> CONFIG_CLKDEV_LOOKUP=y
> CONFIG_HAVE_CLK_PREPARE=y
> CONFIG_COMMON_CLK=y
> 
> #
> # Common Clock Framework
> #
> CONFIG_COMMON_CLK_SI5351=m
> CONFIG_COMMON_CLK_CDCE706=m
> CONFIG_COMMON_CLK_CS2000_CP=m
> # CONFIG_COMMON_CLK_NXP is not set
> # CONFIG_COMMON_CLK_PXA is not set
> # CONFIG_COMMON_CLK_PIC32 is not set
> 
> #
> # Hardware Spinlock drivers
> #
> 
> #
> # Clock Source drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_ATMEL_PIT is not set
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> CONFIG_MAILBOX=y
> # CONFIG_PCC is not set
> CONFIG_ALTERA_MBOX=m
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> 
> #
> # Rpmsg drivers
> #
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> 
> #
> # Broadcom SoC drivers
> #
> 
> #
> # i.MX SoC drivers
> #
> # CONFIG_SUNXI_SRAM is not set
> # CONFIG_SOC_TI is not set
> CONFIG_SOC_ZTE=y
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> CONFIG_IIO_BUFFER_CB=m
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_CONFIGFS=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> CONFIG_IIO_SW_DEVICE=y
> CONFIG_IIO_SW_TRIGGER=m
> 
> #
> # Accelerometers
> #
> CONFIG_ADXL345=m
> # CONFIG_ADXL345_I2C is not set
> CONFIG_ADXL345_SPI=m
> CONFIG_BMA180=m
> CONFIG_BMA220=m
> CONFIG_BMC150_ACCEL=m
> CONFIG_BMC150_ACCEL_I2C=m
> CONFIG_BMC150_ACCEL_SPI=m
> CONFIG_DA280=m
> # CONFIG_DA311 is not set
> CONFIG_DMARD09=m
> CONFIG_DMARD10=m
> CONFIG_IIO_ST_ACCEL_3AXIS=m
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
> CONFIG_IIO_ST_ACCEL_SPI_3AXIS=m
> # CONFIG_KXSD9 is not set
> CONFIG_KXCJK1013=m
> CONFIG_MC3230=m
> CONFIG_MMA7455=y
> # CONFIG_MMA7455_I2C is not set
> CONFIG_MMA7455_SPI=y
> CONFIG_MMA7660=m
> CONFIG_MMA8452=m
> # CONFIG_MMA9551 is not set
> # CONFIG_MMA9553 is not set
> # CONFIG_MXC4005 is not set
> CONFIG_MXC6255=m
> # CONFIG_SCA3000 is not set
> CONFIG_STK8312=m
> CONFIG_STK8BA50=m
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD_SIGMA_DELTA=y
> # CONFIG_AD7266 is not set
> CONFIG_AD7291=m
> # CONFIG_AD7298 is not set
> # CONFIG_AD7476 is not set
> CONFIG_AD7766=m
> CONFIG_AD7791=y
> CONFIG_AD7793=y
> CONFIG_AD7887=y
> # CONFIG_AD7923 is not set
> CONFIG_AD799X=m
> # CONFIG_HI8435 is not set
> CONFIG_HX711=m
> # CONFIG_INA2XX_ADC is not set
> CONFIG_LTC2485=m
> CONFIG_LTC2497=m
> CONFIG_MAX1027=m
> # CONFIG_MAX11100 is not set
> CONFIG_MAX1118=m
> CONFIG_MAX1363=m
> # CONFIG_MAX9611 is not set
> CONFIG_MCP320X=y
> # CONFIG_MCP3422 is not set
> CONFIG_NAU7802=m
> CONFIG_QCOM_VADC_COMMON=m
> CONFIG_QCOM_SPMI_IADC=m
> CONFIG_QCOM_SPMI_VADC=m
> # CONFIG_TI_ADC081C is not set
> CONFIG_TI_ADC0832=m
> CONFIG_TI_ADC12138=m
> CONFIG_TI_ADC128S052=y
> CONFIG_TI_ADC161S626=y
> CONFIG_TI_ADS1015=m
> # CONFIG_TI_ADS7950 is not set
> CONFIG_TI_TLC4541=m
> 
> #
> # Amplifiers
> #
> CONFIG_AD8366=m
> 
> #
> # Chemical Sensors
> #
> CONFIG_ATLAS_PH_SENSOR=m
> CONFIG_IAQCORE=m
> CONFIG_VZ89X=m
> # CONFIG_IIO_CROS_EC_SENSORS_CORE is not set
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_IIO_MS_SENSORS_I2C=m
> 
> #
> # SSP Sensor Common
> #
> # CONFIG_IIO_SSP_SENSORHUB is not set
> CONFIG_IIO_ST_SENSORS_I2C=m
> CONFIG_IIO_ST_SENSORS_SPI=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Counters
> #
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=m
> CONFIG_AD5360=m
> CONFIG_AD5380=m
> CONFIG_AD5421=m
> CONFIG_AD5446=m
> CONFIG_AD5449=m
> CONFIG_AD5592R_BASE=m
> # CONFIG_AD5592R is not set
> CONFIG_AD5593R=m
> CONFIG_AD5504=m
> CONFIG_AD5624R_SPI=y
> CONFIG_LTC2632=m
> CONFIG_AD5686=y
> CONFIG_AD5755=m
> CONFIG_AD5761=y
> # CONFIG_AD5764 is not set
> # CONFIG_AD5791 is not set
> CONFIG_AD7303=m
> # CONFIG_AD8801 is not set
> CONFIG_M62332=m
> CONFIG_MAX517=m
> # CONFIG_MCP4725 is not set
> CONFIG_MCP4922=m
> 
> #
> # IIO dummy driver
> #
> CONFIG_IIO_SIMPLE_DUMMY=y
> # CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
> CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> CONFIG_AD9523=m
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> CONFIG_ADF4350=y
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_ADIS16080=m
> # CONFIG_ADIS16130 is not set
> CONFIG_ADIS16136=y
> # CONFIG_ADIS16260 is not set
> # CONFIG_ADXRS450 is not set
> # CONFIG_BMG160 is not set
> # CONFIG_MPU3050_I2C is not set
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
> CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
> # CONFIG_ITG3200 is not set
> 
> #
> # Health Sensors
> #
> 
> #
> # Heart Rate Monitors
> #
> CONFIG_AFE4403=y
> # CONFIG_AFE4404 is not set
> # CONFIG_MAX30100 is not set
> CONFIG_MAX30102=m
> 
> #
> # Humidity sensors
> #
> # CONFIG_AM2315 is not set
> CONFIG_DHT11=m
> CONFIG_HDC100X=m
> # CONFIG_HTS221 is not set
> # CONFIG_HTU21 is not set
> CONFIG_SI7005=m
> # CONFIG_SI7020 is not set
> 
> #
> # Inertial measurement units
> #
> # CONFIG_ADIS16400 is not set
> # CONFIG_ADIS16480 is not set
> CONFIG_BMI160=m
> CONFIG_BMI160_I2C=m
> # CONFIG_BMI160_SPI is not set
> CONFIG_KMX61=m
> CONFIG_INV_MPU6050_IIO=y
> # CONFIG_INV_MPU6050_I2C is not set
> CONFIG_INV_MPU6050_SPI=y
> # CONFIG_IIO_ST_LSM6DSX is not set
> CONFIG_IIO_ADIS_LIB=y
> CONFIG_IIO_ADIS_LIB_BUFFER=y
> 
> #
> # Light sensors
> #
> # CONFIG_ACPI_ALS is not set
> CONFIG_ADJD_S311=m
> CONFIG_AL3320A=m
> # CONFIG_APDS9300 is not set
> CONFIG_APDS9960=m
> CONFIG_BH1750=m
> CONFIG_BH1780=m
> CONFIG_CM32181=m
> CONFIG_CM3232=m
> # CONFIG_CM3323 is not set
> CONFIG_CM36651=m
> # CONFIG_GP2AP020A00F is not set
> CONFIG_SENSORS_ISL29018=m
> CONFIG_ISL29125=m
> CONFIG_JSA1212=m
> # CONFIG_RPR0521 is not set
> # CONFIG_SENSORS_LM3533 is not set
> # CONFIG_LTR501 is not set
> CONFIG_MAX44000=m
> CONFIG_OPT3001=m
> CONFIG_PA12203001=m
> CONFIG_SI1145=m
> CONFIG_STK3310=m
> # CONFIG_TCS3414 is not set
> CONFIG_TCS3472=m
> CONFIG_SENSORS_TSL2563=m
> CONFIG_TSL2583=m
> CONFIG_TSL4531=m
> CONFIG_US5182D=m
> CONFIG_VCNL4000=m
> # CONFIG_VEML6070 is not set
> CONFIG_VL6180=m
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=m
> # CONFIG_AK09911 is not set
> CONFIG_BMC150_MAGN=m
> CONFIG_BMC150_MAGN_I2C=m
> CONFIG_BMC150_MAGN_SPI=m
> # CONFIG_MAG3110 is not set
> CONFIG_MMC35240=m
> CONFIG_IIO_ST_MAGN_3AXIS=y
> CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
> CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
> CONFIG_SENSORS_HMC5843=m
> CONFIG_SENSORS_HMC5843_I2C=m
> CONFIG_SENSORS_HMC5843_SPI=m
> 
> #
> # Inclinometer sensors
> #
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_HRTIMER_TRIGGER=m
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_TIGHTLOOP_TRIGGER=m
> # CONFIG_IIO_SYSFS_TRIGGER is not set
> 
> #
> # Digital potentiometers
> #
> # CONFIG_DS1803 is not set
> # CONFIG_MAX5481 is not set
> CONFIG_MAX5487=m
> CONFIG_MCP4131=m
> CONFIG_MCP4531=m
> CONFIG_TPL0102=m
> 
> #
> # Digital potentiostats
> #
> # CONFIG_LMP91000 is not set
> 
> #
> # Pressure sensors
> #
> CONFIG_ABP060MG=m
> # CONFIG_BMP280 is not set
> # CONFIG_HP03 is not set
> CONFIG_MPL115=m
> CONFIG_MPL115_I2C=m
> # CONFIG_MPL115_SPI is not set
> CONFIG_MPL3115=m
> CONFIG_MS5611=y
> CONFIG_MS5611_I2C=m
> # CONFIG_MS5611_SPI is not set
> CONFIG_MS5637=m
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=m
> CONFIG_IIO_ST_PRESS_SPI=y
> CONFIG_T5403=m
> CONFIG_HP206C=m
> CONFIG_ZPA2326=y
> CONFIG_ZPA2326_I2C=m
> CONFIG_ZPA2326_SPI=y
> 
> #
> # Lightning sensors
> #
> # CONFIG_AS3935 is not set
> 
> #
> # Proximity and distance sensors
> #
> # CONFIG_LIDAR_LITE_V2 is not set
> # CONFIG_SRF04 is not set
> # CONFIG_SX9500 is not set
> # CONFIG_SRF08 is not set
> 
> #
> # Temperature sensors
> #
> CONFIG_MAXIM_THERMOCOUPLE=y
> CONFIG_MLX90614=m
> CONFIG_TMP006=m
> CONFIG_TMP007=m
> CONFIG_TSYS01=m
> # CONFIG_TSYS02D is not set
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_ARM_GIC_MAX_NR=1
> # CONFIG_IPACK_BUS is not set
> CONFIG_RESET_CONTROLLER=y
> # CONFIG_RESET_ATH79 is not set
> # CONFIG_RESET_BERLIN is not set
> # CONFIG_RESET_IMX7 is not set
> # CONFIG_RESET_LPC18XX is not set
> # CONFIG_RESET_MESON is not set
> # CONFIG_RESET_PISTACHIO is not set
> # CONFIG_RESET_SOCFPGA is not set
> # CONFIG_RESET_STM32 is not set
> # CONFIG_RESET_SUNXI is not set
> CONFIG_TI_SYSCON_RESET=y
> # CONFIG_RESET_ZYNQ is not set
> # CONFIG_RESET_TEGRA_BPMP is not set
> CONFIG_FMC=y
> # CONFIG_FMC_FAKEDEV is not set
> CONFIG_FMC_TRIVIAL=m
> # CONFIG_FMC_WRITE_EEPROM is not set
> # CONFIG_FMC_CHARDEV is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> CONFIG_PHY_PXA_28NM_HSIC=y
> CONFIG_PHY_PXA_28NM_USB2=y
> CONFIG_BCM_KONA_USB2_PHY=m
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Performance monitor support
> #
> CONFIG_RAS=y
> CONFIG_THUNDERBOLT=y
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> CONFIG_LIBNVDIMM=y
> CONFIG_BLK_DEV_PMEM=m
> # CONFIG_ND_BLK is not set
> CONFIG_ND_CLAIM=y
> CONFIG_ND_BTT=m
> CONFIG_BTT=y
> CONFIG_DAX=y
> CONFIG_DEV_DAX=y
> CONFIG_NVMEM=y
> # CONFIG_STM is not set
> CONFIG_INTEL_TH=m
> # CONFIG_INTEL_TH_PCI is not set
> CONFIG_INTEL_TH_GTH=m
> CONFIG_INTEL_TH_MSU=m
> # CONFIG_INTEL_TH_PTI is not set
> # CONFIG_INTEL_TH_DEBUG is not set
> 
> #
> # FPGA Configuration Support
> #
> CONFIG_FPGA=y
> CONFIG_FPGA_MGR_XILINX_SPI=m
> # CONFIG_ALTERA_PR_IP_CORE is not set
> 
> #
> # FSI support
> #
> CONFIG_FSI=y
> # CONFIG_TEE is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=m
> CONFIG_DMIID=y
> CONFIG_DMI_SYSFS=m
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> CONFIG_FW_CFG_SYSFS=y
> CONFIG_FW_CFG_SYSFS_CMDLINE=y
> CONFIG_GOOGLE_FIRMWARE=y
> # CONFIG_GOOGLE_COREBOOT_TABLE_ACPI is not set
> # CONFIG_GOOGLE_MEMCONSOLE_X86_LEGACY is not set
> # CONFIG_EFI_DEV_PATH_PARSER is not set
> 
> #
> # Tegra firmware driver
> #
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_FS_IOMAP=y
> CONFIG_EXT2_FS=m
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> # CONFIG_REISERFS_FS is not set
> CONFIG_JFS_FS=m
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_DEBUG=y
> CONFIG_GFS2_FS=y
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> CONFIG_NILFS2_FS=m
> # CONFIG_F2FS_FS is not set
> CONFIG_FS_DAX=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_EXPORTFS_BLOCK_OPS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_MANDATORY_FILE_LOCKING=y
> CONFIG_FS_ENCRYPTION=m
> CONFIG_FSNOTIFY=y
> # CONFIG_DNOTIFY is not set
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> CONFIG_OVERLAY_FS=m
> CONFIG_OVERLAY_FS_REDIRECT_DIR=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=m
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> CONFIG_FSCACHE_DEBUG=y
> CONFIG_FSCACHE_OBJECT_LIST=y
> # CONFIG_CACHEFILES is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> # CONFIG_JOLIET is not set
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> # CONFIG_MSDOS_FS is not set
> # CONFIG_VFAT_FS is not set
> CONFIG_NTFS_FS=y
> CONFIG_NTFS_DEBUG=y
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> # CONFIG_PROC_CHILDREN is not set
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ORANGEFS_FS=y
> CONFIG_ADFS_FS=y
> CONFIG_ADFS_FS_RW=y
> CONFIG_AFFS_FS=y
> # CONFIG_ECRYPT_FS is not set
> CONFIG_HFS_FS=y
> # CONFIG_HFSPLUS_FS is not set
> CONFIG_BEFS_FS=m
> CONFIG_BEFS_DEBUG=y
> # CONFIG_BFS_FS is not set
> CONFIG_EFS_FS=y
> # CONFIG_CRAMFS is not set
> # CONFIG_SQUASHFS is not set
> CONFIG_VXFS_FS=m
> CONFIG_MINIX_FS=y
> # CONFIG_OMFS_FS is not set
> CONFIG_HPFS_FS=m
> # CONFIG_QNX4FS_FS is not set
> CONFIG_QNX6FS_FS=y
> # CONFIG_QNX6FS_DEBUG is not set
> # CONFIG_ROMFS_FS is not set
> CONFIG_PSTORE=m
> # CONFIG_PSTORE_ZLIB_COMPRESS is not set
> # CONFIG_PSTORE_LZO_COMPRESS is not set
> CONFIG_PSTORE_LZ4_COMPRESS=y
> # CONFIG_PSTORE_CONSOLE is not set
> CONFIG_PSTORE_PMSG=y
> # CONFIG_PSTORE_FTRACE is not set
> CONFIG_PSTORE_RAM=m
> CONFIG_SYSV_FS=m
> CONFIG_UFS_FS=m
> CONFIG_UFS_FS_WRITE=y
> CONFIG_UFS_DEBUG=y
> CONFIG_EXOFS_FS=m
> # CONFIG_EXOFS_DEBUG is not set
> CONFIG_ORE=m
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=m
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=m
> CONFIG_NLS_CODEPAGE_857=m
> # CONFIG_NLS_CODEPAGE_860 is not set
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> # CONFIG_NLS_CODEPAGE_863 is not set
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=m
> # CONFIG_NLS_CODEPAGE_869 is not set
> CONFIG_NLS_CODEPAGE_936=m
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=m
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=y
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=m
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=m
> # CONFIG_NLS_ISO8859_5 is not set
> CONFIG_NLS_ISO8859_6=m
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> CONFIG_NLS_KOI8_U=y
> # CONFIG_NLS_MAC_ROMAN is not set
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=m
> # CONFIG_NLS_MAC_GREEK is not set
> CONFIG_NLS_MAC_ICELAND=y
> CONFIG_NLS_MAC_INUIT=m
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=m
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
> CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> CONFIG_UNUSED_SYMBOLS=y
> # CONFIG_PAGE_OWNER is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_SECTION_MISMATCH_WARN_ONLY=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_MAGIC_SYSRQ_SERIAL=y
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> CONFIG_PAGE_EXTENSION=y
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_PAGE_POISONING=y
> # CONFIG_PAGE_POISONING_NO_SANITY is not set
> # CONFIG_PAGE_POISONING_ZERO is not set
> # CONFIG_DEBUG_PAGE_REF is not set
> CONFIG_DEBUG_RODATA_TEST=y
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_SLUB_DEBUG_ON=y
> # CONFIG_SLUB_STATS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_HIGHMEM is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> # CONFIG_WQ_WATCHDOG is not set
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHED_INFO is not set
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_SCHED_STACK_END_CHECK is not set
> # CONFIG_DEBUG_TIMEKEEPING is not set
> CONFIG_DEBUG_PREEMPT=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> CONFIG_WW_MUTEX_SELFTEST=m
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_LIST=y
> # CONFIG_DEBUG_PI_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU is not set
> CONFIG_SPARSE_RCU_POINTER=y
> # CONFIG_TORTURE_TEST is not set
> # CONFIG_RCU_PERF_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> # CONFIG_RCU_TRACE is not set
> # CONFIG_RCU_EQS_DEBUG is not set
> # CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_PREEMPT_TRACER is not set
> CONFIG_SCHED_TRACER=y
> # CONFIG_HWLAT_TRACER is not set
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> CONFIG_PROFILE_ANNOTATED_BRANCHES=y
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> CONFIG_TRACING_BRANCHES=y
> CONFIG_BRANCH_TRACER=y
> CONFIG_STACK_TRACER=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> # CONFIG_UPROBE_EVENTS is not set
> # CONFIG_PROBE_EVENTS is not set
> # CONFIG_DYNAMIC_FTRACE is not set
> # CONFIG_FUNCTION_PROFILER is not set
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> # CONFIG_HIST_TRIGGERS is not set
> # CONFIG_TRACEPOINT_BENCHMARK is not set
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> # CONFIG_TRACE_ENUM_MAP_FILE is not set
> # CONFIG_TRACING_EVENTS_GPIO is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_LKDTM is not set
> CONFIG_TEST_LIST_SORT=m
> CONFIG_TEST_SORT=m
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PERCPU_TEST is not set
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_ASYNC_RAID6_TEST=m
> # CONFIG_TEST_HEXDUMP is not set
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=m
> CONFIG_TEST_PRINTF=y
> CONFIG_TEST_BITMAP=m
> CONFIG_TEST_UUID=m
> CONFIG_TEST_RHASHTABLE=m
> CONFIG_TEST_HASH=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_TEST_LKM is not set
> # CONFIG_TEST_USER_COPY is not set
> # CONFIG_TEST_BPF is not set
> # CONFIG_TEST_FIRMWARE is not set
> CONFIG_TEST_UDELAY=m
> CONFIG_MEMTEST=y
> CONFIG_TEST_STATIC_KEYS=m
> CONFIG_BUG_ON_DATA_CORRUPTION=y
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> # CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
> # CONFIG_UBSAN is not set
> CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
> CONFIG_EARLY_PRINTK_USB=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_EARLY_PRINTK_USB_XDBC=y
> CONFIG_X86_PTDUMP_CORE=y
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_WX=y
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> CONFIG_IOMMU_STRESS=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> CONFIG_IO_DELAY_0XED=y
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=1
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_ENTRY is not set
> CONFIG_X86_DEBUG_FPU=y
> CONFIG_PUNIT_ATOM_DEBUG=m
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_PERSISTENT_KEYRINGS=y
> # CONFIG_BIG_KEYS is not set
> CONFIG_ENCRYPTED_KEYS=y
> CONFIG_KEY_DH_OPERATIONS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
> # CONFIG_HARDENED_USERCOPY is not set
> CONFIG_STATIC_USERMODEHELPER=y
> CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=m
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_ASYNC_PQ=m
> CONFIG_ASYNC_RAID6_RECOV=m
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_RNG_DEFAULT=y
> CONFIG_CRYPTO_AKCIPHER2=y
> CONFIG_CRYPTO_AKCIPHER=y
> CONFIG_CRYPTO_KPP2=y
> CONFIG_CRYPTO_KPP=y
> CONFIG_CRYPTO_ACOMP2=y
> CONFIG_CRYPTO_RSA=y
> CONFIG_CRYPTO_DH=y
> CONFIG_CRYPTO_ECDH=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_NULL2=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_MCRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_ABLK_HELPER=m
> CONFIG_CRYPTO_SIMD=m
> CONFIG_CRYPTO_GLUE_HELPER_X86=m
> CONFIG_CRYPTO_ENGINE=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> # CONFIG_CRYPTO_CHACHA20POLY1305 is not set
> CONFIG_CRYPTO_SEQIV=y
> CONFIG_CRYPTO_ECHAINIV=m
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
> # CONFIG_CRYPTO_KEYWRAP is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=m
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=m
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_CRC32C_INTEL is not set
> # CONFIG_CRYPTO_CRC32 is not set
> CONFIG_CRYPTO_CRC32_PCLMUL=m
> CONFIG_CRYPTO_CRCT10DIF=m
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_POLY1305=m
> # CONFIG_CRYPTO_MD4 is not set
> # CONFIG_CRYPTO_MD5 is not set
> CONFIG_CRYPTO_MICHAEL_MIC=y
> # CONFIG_CRYPTO_RMD128 is not set
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_SHA3=y
> # CONFIG_CRYPTO_TGR192 is not set
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_TI=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_AES_NI_INTEL=m
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> # CONFIG_CRYPTO_CAMELLIA is not set
> CONFIG_CRYPTO_CAST_COMMON=y
> # CONFIG_CRYPTO_CAST5 is not set
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_SALSA20=m
> CONFIG_CRYPTO_SALSA20_586=y
> CONFIG_CRYPTO_CHACHA20=y
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_SERPENT_SSE2_586=m
> # CONFIG_CRYPTO_TEA is not set
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_LZO=m
> CONFIG_CRYPTO_842=y
> CONFIG_CRYPTO_LZ4=m
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_DRBG_MENU=y
> CONFIG_CRYPTO_DRBG_HMAC=y
> # CONFIG_CRYPTO_DRBG_HASH is not set
> # CONFIG_CRYPTO_DRBG_CTR is not set
> CONFIG_CRYPTO_DRBG=y
> CONFIG_CRYPTO_JITTERENTROPY=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> # CONFIG_CRYPTO_USER_API_RNG is not set
> # CONFIG_CRYPTO_USER_API_AEAD is not set
> CONFIG_CRYPTO_HASH_INFO=y
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_PADLOCK is not set
> CONFIG_CRYPTO_DEV_GEODE=y
> # CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC is not set
> CONFIG_CRYPTO_DEV_CCP=y
> CONFIG_CRYPTO_DEV_CCP_DD=y
> # CONFIG_CRYPTO_DEV_CCP_CRYPTO is not set
> CONFIG_CRYPTO_DEV_QAT=y
> CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
> CONFIG_CRYPTO_DEV_QAT_C3XXX=m
> # CONFIG_CRYPTO_DEV_QAT_C62X is not set
> CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=y
> CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
> CONFIG_CRYPTO_DEV_QAT_C62XVF=m
> CONFIG_CRYPTO_DEV_VIRTIO=y
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_X509_CERTIFICATE_PARSER=m
> CONFIG_PKCS7_MESSAGE_PARSER=m
> 
> #
> # Certificates for signature checking
> #
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> CONFIG_SYSTEM_TRUSTED_KEYS=""
> # CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
> CONFIG_SECONDARY_TRUSTED_KEYRING=y
> CONFIG_SYSTEM_BLACKLIST_KEYRING=y
> CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> # CONFIG_KVM is not set
> # CONFIG_VHOST_NET is not set
> CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
> CONFIG_LGUEST=y
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=m
> CONFIG_BITREVERSE=y
> # CONFIG_HAVE_ARCH_BITREVERSE is not set
> CONFIG_RATIONAL=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
> # CONFIG_CRC_CCITT is not set
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=m
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=m
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=m
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> # CONFIG_RANDOM32_SELFTEST is not set
> CONFIG_842_COMPRESS=y
> CONFIG_842_DECOMPRESS=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_COMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=m
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_REED_SOLOMON=m
> CONFIG_REED_SOLOMON_ENC8=y
> CONFIG_REED_SOLOMON_DEC8=y
> CONFIG_INTERVAL_TREE=y
> CONFIG_RADIX_TREE_MULTIORDER=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> # CONFIG_DMA_NOOP_OPS is not set
> # CONFIG_DMA_VIRT_OPS is not set
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_DQL=y
> CONFIG_GLOB=y
> # CONFIG_GLOB_SELFTEST is not set
> CONFIG_NLATTR=y
> CONFIG_CLZ_TAB=y
> # CONFIG_CORDIC is not set
> # CONFIG_DDR is not set
> CONFIG_IRQ_POLL=y
> CONFIG_MPILIB=y
> CONFIG_OID_REGISTRY=m
> CONFIG_FONT_SUPPORT=m
> CONFIG_FONTS=y
> # CONFIG_FONT_8x8 is not set
> CONFIG_FONT_8x16=y
> # CONFIG_FONT_6x11 is not set
> # CONFIG_FONT_7x14 is not set
> CONFIG_FONT_PEARL_8x8=y
> CONFIG_FONT_ACORN_8x8=y
> CONFIG_FONT_MINI_4x6=y
> CONFIG_FONT_6x10=y
> CONFIG_FONT_10x18=y
> CONFIG_FONT_SUN8x16=y
> CONFIG_FONT_SUN12x22=y
> # CONFIG_SG_SPLIT is not set
> CONFIG_SG_POOL=y
> CONFIG_ARCH_HAS_SG_CHAIN=y
> CONFIG_ARCH_HAS_MMIO_FLUSH=y
> CONFIG_SBITMAP=y

