Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6D287uC103400 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 21:08:07 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id yUD5xsm8TijSPbYD for
	<xfs@oss.sgi.com>; Thu, 12 Jul 2012 19:08:05 -0700 (PDT)
Date: Fri, 13 Jul 2012 10:08:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
	worker_pool
Message-ID: <20120713020800.GA14026@localhost>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20120712214514.GD20167@google.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, Tony Luck <tony.luck@intel.com>, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 12, 2012 at 02:45:14PM -0700, Tejun Heo wrote:
> Hello, again.
> 
> On Thu, Jul 12, 2012 at 10:05:19AM -0700, Tejun Heo wrote:
> > On Thu, Jul 12, 2012 at 09:06:48PM +0800, Fengguang Wu wrote:
> > > [    0.207977] WARNING: at /c/kernel-tests/mm/kernel/workqueue.c:1217 worker_enter_idle+0x2b8/0x32b()
> > > [    0.207977] Modules linked in:
> > > [    0.207977] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc6-08414-g9645fff #15
> > > [    0.207977] Call Trace:
> > > [    0.207977]  [<ffffffff81087189>] ? worker_enter_idle+0x2b8/0x32b
> > > [    0.207977]  [<ffffffff810559d9>] warn_slowpath_common+0xae/0xdb
> > > [    0.207977]  [<ffffffff81055a2e>] warn_slowpath_null+0x28/0x31
> > > [    0.207977]  [<ffffffff81087189>] worker_enter_idle+0x2b8/0x32b
> > > [    0.207977]  [<ffffffff81087222>] start_worker+0x26/0x42
> > > [    0.207977]  [<ffffffff81c8b261>] init_workqueues+0x2d2/0x59a
> > > [    0.207977]  [<ffffffff81c8af8f>] ? usermodehelper_init+0x8a/0x8a
> > > [    0.207977]  [<ffffffff81000284>] do_one_initcall+0xce/0x272
> > > [    0.207977]  [<ffffffff81c6f650>] kernel_init+0x12e/0x3c1
> > > [    0.207977]  [<ffffffff814b9b74>] kernel_thread_helper+0x4/0x10
> > > [    0.207977]  [<ffffffff814b80b0>] ? retint_restore_args+0x13/0x13
> > > [    0.207977]  [<ffffffff81c6f522>] ? start_kernel+0x737/0x737
> > > [    0.207977]  [<ffffffff814b9b70>] ? gs_change+0x13/0x13
> > 
> > Yeah, I forgot to flip the WARN_ON_ONCE() condition so that it checks
> > nr_running before looking at pool->nr_running.  The warning is
> > spurious.  Will post fix soon.
> 
> I was wrong and am now dazed and confused.  That's from
> init_workqueues() where only cpu0 is running.  How the hell did
> nr_running manage to become non-zero at that point?  Can you please
> apply the following patch and report the boot log?  Thank you.

Tejun, here is the data I got:

[    0.165669] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.167001] XXX cpu=0 gcwq=ffff88000dc0cfc0 base=ffff88000dc11e80
[    0.167989] XXX cpu=0 nr_running=0 @ ffff88000dc11e80
[    0.168988] XXX cpu=0 nr_running=0 @ ffff88000dc11e88
[    0.169988] XXX cpu=1 gcwq=ffff88000dd0cfc0 base=ffff88000dd11e80
[    0.170988] XXX cpu=1 nr_running=0 @ ffff88000dd11e80
[    0.171987] XXX cpu=1 nr_running=0 @ ffff88000dd11e88
[    0.172988] XXX cpu=8 nr_running=0 @ ffffffff81d7c430
[    0.173987] XXX cpu=8 nr_running=12 @ ffffffff81d7c438
[    0.175416] ------------[ cut here ]------------
[    0.175981] WARNING: at /c/wfg/linux/kernel/workqueue.c:1220 worker_enter_idle+0x2b8/0x32b()
[    0.175981] Modules linked in:
[    0.175981] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc6-bisect-next-20120712-dirty #102
[    0.175981] Call Trace:
[    0.175981]  [<ffffffff81087455>] ? worker_enter_idle+0x2b8/0x32b
[    0.175981]  [<ffffffff810559d1>] warn_slowpath_common+0xae/0xdb
[    0.175981]  [<ffffffff81055a26>] warn_slowpath_null+0x28/0x31
[    0.175981]  [<ffffffff81087455>] worker_enter_idle+0x2b8/0x32b
[    0.175981]  [<ffffffff810874ee>] start_worker+0x26/0x42
[    0.175981]  [<ffffffff81c7dc4d>] init_workqueues+0x370/0x638
[    0.175981]  [<ffffffff81c7d8dd>] ? usermodehelper_init+0x8a/0x8a
[    0.175981]  [<ffffffff81000284>] do_one_initcall+0xce/0x272
[    0.175981]  [<ffffffff81c62652>] kernel_init+0x12e/0x3c1
[    0.175981]  [<ffffffff814b6e74>] kernel_thread_helper+0x4/0x10
[    0.175981]  [<ffffffff814b53b0>] ? retint_restore_args+0x13/0x13
[    0.175981]  [<ffffffff81c62524>] ? start_kernel+0x739/0x739
[    0.175981]  [<ffffffff814b6e70>] ? gs_change+0x13/0x13
[    0.175981] ---[ end trace c22d98677c4d3e37 ]---
[    0.178091] Testing tracer nop: PASSED

The attached dmesg is not complete because, once get the oops message,
my script will kill the kvm to save time.

Thanks,
Fengguang

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm_bisect-waimea-27649-2012-07-13-08-34-35

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc6-bisect-next-20120712-dirty (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #102 SMP Fri Jul 13 08:32:30 CST 2012
[    0.000000] Command line: bisect-reboot x86_64-randconfig run_test= trinity=0 auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=x86_64/vmlinuz-bisect
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffd000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffbc000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f8860-0x000f886f] mapped at [ffff8800000f8860]
[    0.000000]   mpc: f8870-f898c
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128176(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffcfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffcfff]
[    0.000000]   NODE_DATA [mem 0x0fff8000-0x0fffcfff]
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:1c5fe01, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 60477 pages, LIFO batch:15
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: f8870-f898c
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88000dc00000 s76800 r8192 d21504 u1048576
[    0.000000] pcpu-alloc: s76800 r8192 d21504 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] kvm-clock: cpu 0, msr 0:dc11e01, primary cpu clock
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64390
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: bisect-reboot x86_64-randconfig run_test= trinity=0 auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=x86_64/vmlinuz-bisect
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 200000k/262132k available (4835k kernel code, 452k absent, 61680k reserved, 7751k data, 568k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:4352 nr_irqs:56 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] tsc: Detected 3299.986 MHz processor
[    0.000999] Calibrating delay loop (skipped) preset value.. 6599.97 BogoMIPS (lpj=3299986)
[    0.002008] pid_max: default: 32768 minimum: 301
[    0.003176] Security Framework initialized
[    0.004304] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.006232] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.007245] Mount-cache hash table entries: 256
[    0.010107] Initializing cgroup subsys debug
[    0.010876] Initializing cgroup subsys freezer
[    0.011009] Initializing cgroup subsys perf_event
[    0.012104] Disabled fast string operations
[    0.014242] ftrace: allocating 10983 entries in 43 pages
[    0.020312] Getting VERSION: 50014
[    0.021011] Getting VERSION: 50014
[    0.021605] Getting ID: 0
[    0.022010] Getting ID: ff000000
[    0.022583] Getting LVT0: 8700
[    0.023008] Getting LVT1: 8400
[    0.023589] enabled ExtINT on CPU#0
[    0.025253] ENABLING IO-APIC IRQs
[    0.025839] init IO_APIC IRQs
[    0.026007]  apic 2 pin 0 not connected
[    0.027032] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.028026] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.029033] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.030043] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.031022] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.033031] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.034022] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.036021] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.037028] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 33 Mode:1 Active:0 Dest:1)
[    0.038025] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 34 Mode:1 Active:0 Dest:1)
[    0.040023] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 35 Mode:1 Active:0 Dest:1)
[    0.041019] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.043020] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.044021] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.046005] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.047016]  apic 2 pin 16 not connected
[    0.048002]  apic 2 pin 17 not connected
[    0.048693]  apic 2 pin 18 not connected
[    0.049001]  apic 2 pin 19 not connected
[    0.050001]  apic 2 pin 20 not connected
[    0.050681]  apic 2 pin 21 not connected
[    0.051001]  apic 2 pin 22 not connected
[    0.052001]  apic 2 pin 23 not connected
[    0.052857] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054000] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.056001] Using local APIC timer interrupts.
[    0.056001] calibrating APIC timer ...
[    0.057995] ... lapic delta = 6248865
[    0.057995] ..... delta 6248865
[    0.057995] ..... mult: 268427509
[    0.057995] ..... calibration result: 999818
[    0.057995] ..... CPU clock speed is 3299.0401 MHz.
[    0.057995] ..... host bus clock speed is 999.0818 MHz.
[    0.057995] ... verify APIC timer
[    0.164423] ... jiffies delta = 100
[    0.164989] ... jiffies result ok
[    0.165669] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.167001] XXX cpu=0 gcwq=ffff88000dc0cfc0 base=ffff88000dc11e80
[    0.167989] XXX cpu=0 nr_running=0 @ ffff88000dc11e80
[    0.168988] XXX cpu=0 nr_running=0 @ ffff88000dc11e88
[    0.169988] XXX cpu=1 gcwq=ffff88000dd0cfc0 base=ffff88000dd11e80
[    0.170988] XXX cpu=1 nr_running=0 @ ffff88000dd11e80
[    0.171987] XXX cpu=1 nr_running=0 @ ffff88000dd11e88
[    0.172988] XXX cpu=8 nr_running=0 @ ffffffff81d7c430
[    0.173987] XXX cpu=8 nr_running=12 @ ffffffff81d7c438
[    0.175416] ------------[ cut here ]------------
[    0.175981] WARNING: at /c/wfg/linux/kernel/workqueue.c:1220 worker_enter_idle+0x2b8/0x32b()
[    0.175981] Modules linked in:
[    0.175981] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc6-bisect-next-20120712-dirty #102
[    0.175981] Call Trace:
[    0.175981]  [<ffffffff81087455>] ? worker_enter_idle+0x2b8/0x32b
[    0.175981]  [<ffffffff810559d1>] warn_slowpath_common+0xae/0xdb
[    0.175981]  [<ffffffff81055a26>] warn_slowpath_null+0x28/0x31
[    0.175981]  [<ffffffff81087455>] worker_enter_idle+0x2b8/0x32b
[    0.175981]  [<ffffffff810874ee>] start_worker+0x26/0x42
[    0.175981]  [<ffffffff81c7dc4d>] init_workqueues+0x370/0x638
[    0.175981]  [<ffffffff81c7d8dd>] ? usermodehelper_init+0x8a/0x8a
[    0.175981]  [<ffffffff81000284>] do_one_initcall+0xce/0x272
[    0.175981]  [<ffffffff81c62652>] kernel_init+0x12e/0x3c1
[    0.175981]  [<ffffffff814b6e74>] kernel_thread_helper+0x4/0x10
[    0.175981]  [<ffffffff814b53b0>] ? retint_restore_args+0x13/0x13
[    0.175981]  [<ffffffff81c62524>] ? start_kernel+0x739/0x739
[    0.175981]  [<ffffffff814b6e70>] ? gs_change+0x13/0x13
[    0.175981] ---[ end trace c22d98677c4d3e37 ]---
[    0.178091] Testing tracer nop: PASSED
[    0.179138] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.181221] SMP alternatives: lockdep: fixing up alternatives
[    0.181995] smpboot: Booting Node   0, Processors  #1 OK
[    0.000999] kvm-clock: cpu 1, msr 0:dd11e01, secondary cpu clock
[    0.000999] masked ExtINT on CPU#1
[    0.000999] Disabled fast string operations
[    0.207203] Brought up 2 CPUs
[    0.207732] smpboot: Total of 2 processors activated (13199.94 BogoMIPS)
[    0.209280] CPU0 attaching sched-domain:
[    0.210007]  domain 0: span 0-1 level CPU
[    0.210710]   groups: 0 (cpu_power = 1023) 1
[    0.211440] CPU1 attaching sched-domain:
[    0.211983]  domain 0: span 0-1 level CPU
[    0.212694]   groups: 1 0 (cpu_power = 1023)
[    0.218232] devtmpfs: initialized
[    0.218877] device: 'platform': device_add
[    0.219027] PM: Adding info for No Bus:platform
[    0.220063] bus: 'platform': registered
[    0.221055] bus: 'cpu': registered
[    0.221683] device: 'cpu': device_add
[    0.222014] PM: Adding info for No Bus:cpu
[    0.223020] bus: 'memory': registered
[    0.223985] device: 'memory': device_add
[    0.224670] PM: Adding info for No Bus:memory
[    0.230912] device: 'memory0': device_add
[    0.231006] bus: 'memory': add device memory0
[    0.232066] PM: Adding info for memory:memory0
[    0.233071] device: 'memory1': device_add
[    0.233986] bus: 'memory': add device memory1
[    0.234765] PM: Adding info for memory:memory1
[    0.248722] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.249977] device class 'regulator': registering
[    0.251020] Registering platform device 'reg-dummy'. Parent at platform
[    0.251991] device: 'reg-dummy': device_add
[    0.252985] bus: 'platform': add device reg-dummy
[    0.253848] PM: Adding info for platform:reg-dummy
[    0.260849] bus: 'platform': add driver reg-dummy
[    0.260984] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.262977] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.264070] device: 'regulator.0': device_add
[    0.265133] PM: Adding info for No Bus:regulator.0
[    0.266085] dummy: 
[    0.273208] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.274005] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.275092] RTC time:  0:34:29, date: 07/13/12
[    0.276994] NET: Registered protocol family 16
[    0.277905] device class 'bdi': registering
[    0.278011] device class 'tty': registering
[    0.279013] bus: 'node': registered
[    0.286795] device: 'node': device_add
[    0.287020] PM: Adding info for No Bus:node
[    0.288127] device class 'dma': registering
[    0.289071] device: 'node0': device_add
[    0.289747] bus: 'node': add device node0
[    0.289994] PM: Adding info for node:node0
[    0.291031] device: 'cpu0': device_add
[    0.291977] bus: 'cpu': add device cpu0
[    0.292677] PM: Adding info for cpu:cpu0
[    0.299186] device: 'cpu1': device_add
[    0.299860] bus: 'cpu': add device cpu1
[    0.299992] PM: Adding info for cpu:cpu1
[    0.301007] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.301969] mtrr: your CPUs had inconsistent MTRRdefType settings
[    0.302968] mtrr: probably your BIOS does not setup all CPUs.
[    0.303968] mtrr: corrected configuration.
[    0.311821] device: 'default': device_add
[    0.312027] PM: Adding info for No Bus:default
[    0.314526] bio: create slab <bio-0> at 0
[    0.315020] device class 'block': registering
[    0.317769] device class 'misc': registering
[    0.318022] bus: 'serio': registered
[    0.318967] device class 'input': registering
[    0.320006] device class 'power_supply': registering
[    0.320994] device class 'leds': registering
[    0.321795] device class 'net': registering
[    0.322030] device: 'lo': device_add
[    0.323147] PM: Adding info for No Bus:lo
[    0.330653] Switching to clocksource kvm-clock
[    0.332373] Warning: could not register all branches stats
[    0.333365] Warning: could not register annotated branches stats
[    0.413675] device class 'mem': registering
[    0.414493] device: 'mem': device_add
[    0.420754] PM: Adding info for No Bus:mem
[    0.421550] device: 'kmem': device_add
[    0.423861] PM: Adding info for No Bus:kmem
[    0.424642] device: 'null': device_add
[    0.426918] PM: Adding info for No Bus:null
[    0.427694] device: 'zero': device_add
[    0.430025] PM: Adding info for No Bus:zero
[    0.430773] device: 'full': device_add
[    0.433074] PM: Adding info for No Bus:full
[    0.433838] device: 'random': device_add
[    0.436151] PM: Adding info for No Bus:random
[    0.436919] device: 'urandom': device_add
[    0.439276] PM: Adding info for No Bus:urandom
[    0.440100] device: 'kmsg': device_add
[    0.442396] PM: Adding info for No Bus:kmsg
[    0.443148] device: 'tty': device_add
[    0.445317] PM: Adding info for No Bus:tty
[    0.446087] device: 'console': device_add
[    0.448386] PM: Adding info for No Bus:console
[    0.449224] NET: Registered protocol family 1
[    0.450284] Unpacking initramfs...
[    1.877893] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    1.903095] DMA-API: preallocated 32768 debug entries
[    1.903966] DMA-API: debugging enabled by kernel config
[    1.905059] Registering platform device 'rtc_cmos'. Parent at platform
[    1.906178] device: 'rtc_cmos': device_add
[    1.906884] bus: 'platform': add device rtc_cmos
[    1.907727] PM: Adding info for platform:rtc_cmos
[    1.908579] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.910170] device: 'snapshot': device_add
[    1.911083] PM: Adding info for No Bus:snapshot
[    1.911949] bus: 'clocksource': registered
[    1.912686] device: 'clocksource': device_add
[    1.913480] PM: Adding info for No Bus:clocksource
[    1.914328] device: 'clocksource0': device_add
[    1.915092] bus: 'clocksource': add device clocksource0
[    1.915985] PM: Adding info for clocksource:clocksource0
[    1.916938] bus: 'platform': add driver alarmtimer
[    1.917799] Registering platform device 'alarmtimer'. Parent at platform
[    1.918948] device: 'alarmtimer': device_add
[    1.919693] bus: 'platform': add device alarmtimer
[    1.920546] PM: Adding info for platform:alarmtimer
[    1.921413] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    1.922931] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    1.924342] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    1.925525] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    1.926945] audit: initializing netlink socket (disabled)
[    1.927924] type=2000 audit(1342139670.926:1): initialized
[    1.941097] Testing tracer function: PASSED
[    2.087999] Testing dynamic ftrace: PASSED
[    2.338209] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 940) (2 2 4 1 1027) PASSED
[    2.431997] Testing dynamic ftrace ops #2: (1 0 1 28 0) (1 1 2 297 0) (2 1 3 1 13) (2 2 4 84 96) PASSED
[    2.540363] bus: 'event_source': registered
[    2.541114] device: 'breakpoint': device_add
[    2.541860] bus: 'event_source': add device breakpoint
[    2.542799] PM: Adding info for event_source:breakpoint
[    2.543767] device: 'tracepoint': device_add
[    2.544535] bus: 'event_source': add device tracepoint
[    2.545493] PM: Adding info for event_source:tracepoint
[    2.546442] device: 'software': device_add
[    2.547170] bus: 'event_source': add device software
[    2.548449] PM: Adding info for event_source:software
[    2.549665] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.560548] msgmni has been set to 390
[    2.561843] cryptomgr_test (26) used greatest stack depth: 5736 bytes left
[    2.563190] alg: No test for stdrng (krng)
[    2.564112] device class 'bsg': registering
[    2.564859] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    2.566155] io scheduler noop registered (default)
[    2.567035] device: 'ptyp0': device_add
[    2.567860] PM: Adding info for No Bus:ptyp0
[    2.568687] device: 'ptyp1': device_add
[    2.569492] PM: Adding info for No Bus:ptyp1
[    2.570277] device: 'ptyp2': device_add
[    2.571095] PM: Adding info for No Bus:ptyp2
[    2.571873] device: 'ptyp3': device_add
[    2.572693] PM: Adding info for No Bus:ptyp3
[    2.573479] device: 'ptyp4': device_add
[    2.574329] PM: Adding info for No Bus:ptyp4
[    2.575100] device: 'ptyp5': device_add
[    2.575944] PM: Adding info for No Bus:ptyp5
[    2.576723] device: 'ptyp6': device_add
[    2.577525] PM: Adding info for No Bus:ptyp6
[    2.578310] device: 'ptyp7': device_add
[    2.579113] PM: Adding info for No Bus:ptyp7
[    2.579872] device: 'ptyp8': device_add
[    2.580685] PM: Adding info for No Bus:ptyp8
[    2.581469] device: 'ptyp9': device_add
[    2.582286] PM: Adding info for No Bus:ptyp9
[    2.583057] device: 'ptypa': device_add
[    2.583831] PM: Adding info for No Bus:ptypa
[    2.584604] device: 'ptypb': device_add
[    2.585418] PM: Adding info for No Bus:ptypb
[    2.586179] device: 'ptypc': device_add
[    2.586966] PM: Adding info for No Bus:ptypc
[    2.587739] device: 'ptypd': device_add
[    2.588551] PM: Adding info for No Bus:ptypd
[    2.589341] device: 'ptype': device_add
[    2.590252] PM: Adding info for No Bus:ptype
[    2.590998] device: 'ptypf': device_add
[    2.591795] PM: Adding info for No Bus:ptypf
[    2.592572] device: 'ptyq0': device_add
[    2.593400] PM: Adding info for No Bus:ptyq0
[    2.594164] device: 'ptyq1': device_add
[    2.594938] PM: Adding info for No Bus:ptyq1
[    2.595710] device: 'ptyq2': device_add
[    2.596515] PM: Adding info for No Bus:ptyq2
[    2.597330] device: 'ptyq3': device_add
[    2.598162] PM: Adding info for No Bus:ptyq3
[    2.598944] device: 'ptyq4': device_add
[    2.599757] PM: Adding info for No Bus:ptyq4
[    2.600545] device: 'ptyq5': device_add
[    2.601363] PM: Adding info for No Bus:ptyq5
[    2.602125] device: 'ptyq6': device_add
[    2.602949] PM: Adding info for No Bus:ptyq6
[    2.603723] device: 'ptyq7': device_add
[    2.604536] PM: Adding info for No Bus:ptyq7
[    2.605313] device: 'ptyq8': device_add
[    2.606115] PM: Adding info for No Bus:ptyq8
[    2.606877] device: 'ptyq9': device_add
[    2.607708] PM: Adding info for No Bus:ptyq9
[    2.608497] device: 'ptyqa': device_add
[    2.609318] PM: Adding info for No Bus:ptyqa
[    2.610081] device: 'ptyqb': device_add
[    2.610861] PM: Adding info for No Bus:ptyqb
[    2.611631] device: 'ptyqc': device_add
[    2.612444] PM: Adding info for No Bus:ptyqc
[    2.613210] device: 'ptyqd': device_add
[    2.613981] PM: Adding info for No Bus:ptyqd
[    2.614764] device: 'ptyqe': device_add
[    2.615591] PM: Adding info for No Bus:ptyqe
[    2.616375] device: 'ptyqf': device_add
[    2.617165] PM: Adding info for No Bus:ptyqf
[    2.617915] device: 'ptyr0': device_add
[    2.618743] PM: Adding info for No Bus:ptyr0
[    2.619519] device: 'ptyr1': device_add
[    2.620410] PM: Adding info for No Bus:ptyr1
[    2.621175] device: 'ptyr2': device_add
[    2.621952] PM: Adding info for No Bus:ptyr2
[    2.622761] device: 'ptyr3': device_add
[    2.623590] PM: Adding info for No Bus:ptyr3
[    2.624382] device: 'ptyr4': device_add
[    2.625194] PM: Adding info for No Bus:ptyr4
[    2.625964] device: 'ptyr5': device_add
[    2.626783] PM: Adding info for No Bus:ptyr5
[    2.627559] device: 'ptyr6': device_add
[    2.628369] PM: Adding info for No Bus:ptyr6
[    2.629133] device: 'ptyr7': device_add
[    2.629969] PM: Adding info for No Bus:ptyr7
[    2.630741] device: 'ptyr8': device_add
[    2.631555] PM: Adding info for No Bus:ptyr8
[    2.632348] device: 'ptyr9': device_add
[    2.633151] PM: Adding info for No Bus:ptyr9
[    2.633911] device: 'ptyra': device_add
[    2.634730] PM: Adding info for No Bus:ptyra
[    2.635504] device: 'ptyrb': device_add
[    2.636326] PM: Adding info for No Bus:ptyrb
[    2.637086] device: 'ptyrc': device_add
[    2.637887] PM: Adding info for No Bus:ptyrc
[    2.638679] device: 'ptyrd': device_add
[    2.639477] PM: Adding info for No Bus:ptyrd
[    2.640237] device: 'ptyre': device_add
[    2.641060] PM: Adding info for No Bus:ptyre
[    2.641829] device: 'ptyrf': device_add
[    2.642658] PM: Adding info for No Bus:ptyrf
[    2.643433] device: 'ptys0': device_add
[    2.644216] PM: Adding info for No Bus:ptys0
[    2.644963] device: 'ptys1': device_add
[    2.645775] PM: Adding info for No Bus:ptys1
[    2.646550] device: 'ptys2': device_add
[    2.647346] PM: Adding info for No Bus:ptys2
[    2.648134] device: 'ptys3': device_add
[    2.648943] PM: Adding info for No Bus:ptys3
[    2.649735] device: 'ptys4': device_add
[    2.650649] PM: Adding info for No Bus:ptys4
[    2.651445] device: 'ptys5': device_add
[    2.652265] PM: Adding info for No Bus:ptys5
[    2.653031] device: 'ptys6': device_add
[    2.653830] PM: Adding info for No Bus:ptys6
[    2.654604] device: 'ptys7': device_add
[    2.655402] PM: Adding info for No Bus:ptys7
[    2.656162] device: 'ptys8': device_add
[    2.656994] PM: Adding info for No Bus:ptys8
[    2.657777] device: 'ptys9': device_add
[    2.658606] PM: Adding info for No Bus:ptys9
[    2.659397] device: 'ptysa': device_add
[    2.660209] PM: Adding info for No Bus:ptysa
[    2.660961] device: 'ptysb': device_add
[    2.661761] PM: Adding info for No Bus:ptysb
[    2.662534] device: 'ptysc': device_add
[    2.663346] PM: Adding info for No Bus:ptysc
[    2.664106] device: 'ptysd': device_add
[    2.664899] PM: Adding info for No Bus:ptysd
[    2.665672] device: 'ptyse': device_add
[    2.666472] PM: Adding info for No Bus:ptyse
[    2.667259] device: 'ptysf': device_add
[    2.668082] PM: Adding info for No Bus:ptysf
[    2.668851] device: 'ptyt0': device_add
[    2.669657] PM: Adding info for No Bus:ptyt0
[    2.670428] device: 'ptyt1': device_add
[    2.671233] PM: Adding info for No Bus:ptyt1
[    2.671982] device: 'ptyt2': device_add
[    2.672780] PM: Adding info for No Bus:ptyt2
[    2.673586] device: 'ptyt3': device_add
[    2.674402] PM: Adding info for No Bus:ptyt3
[    2.675173] device: 'ptyt4': device_add
[    2.675995] PM: Adding info for No Bus:ptyt4
[    2.676805] device: 'ptyt5': device_add
[    2.677725] PM: Adding info for No Bus:ptyt5
[    2.678507] device: 'ptyt6': device_add
[    2.679343] PM: Adding info for No Bus:ptyt6
[    2.680165] device: 'ptyt7': device_add
[    2.680943] PM: Adding info for No Bus:ptyt7
[    2.681712] device: 'ptyt8': device_add
[    2.682524] PM: Adding info for No Bus:ptyt8
[    2.683294] device: 'ptyt9': device_add
[    2.684136] PM: Adding info for No Bus:ptyt9
[    2.684897] device: 'ptyta': device_add
[    2.685729] PM: Adding info for No Bus:ptyta
[    2.686503] device: 'ptytb': device_add
[    2.687320] PM: Adding info for No Bus:ptytb
[    2.688083] device: 'ptytc': device_add
[    2.688876] PM: Adding info for No Bus:ptytc
[    2.689644] device: 'ptytd': device_add
[    2.690456] PM: Adding info for No Bus:ptytd
[    2.691218] device: 'ptyte': device_add
[    2.691995] PM: Adding info for No Bus:ptyte
[    2.692781] device: 'ptytf': device_add
[    2.693607] PM: Adding info for No Bus:ptytf
[    2.694392] device: 'ptyu0': device_add
[    2.695182] PM: Adding info for No Bus:ptyu0
[    2.695933] device: 'ptyu1': device_add
[    2.696746] PM: Adding info for No Bus:ptyu1
[    2.697516] device: 'ptyu2': device_add
[    2.698371] PM: Adding info for No Bus:ptyu2
[    2.699166] device: 'ptyu3': device_add
[    2.699967] PM: Adding info for No Bus:ptyu3
[    2.700743] device: 'ptyu4': device_add
[    2.701587] PM: Adding info for No Bus:ptyu4
[    2.702392] device: 'ptyu5': device_add
[    2.703192] PM: Adding info for No Bus:ptyu5
[    2.703944] device: 'ptyu6': device_add
[    2.704762] PM: Adding info for No Bus:ptyu6
[    2.705538] device: 'ptyu7': device_add
[    2.706334] PM: Adding info for No Bus:ptyu7
[    2.707093] device: 'ptyu8': device_add
[    2.707894] PM: Adding info for No Bus:ptyu8
[    2.708686] device: 'ptyu9': device_add
[    2.709503] PM: Adding info for No Bus:ptyu9
[    2.710368] device: 'ptyua': device_add
[    2.711209] PM: Adding info for No Bus:ptyua
[    2.711966] device: 'ptyub': device_add
[    2.712873] PM: Adding info for No Bus:ptyub
[    2.713652] device: 'ptyuc': device_add
[    2.714448] PM: Adding info for No Bus:ptyuc
[    2.715210] device: 'ptyud': device_add
[    2.716008] PM: Adding info for No Bus:ptyud
[    2.716780] device: 'ptyue': device_add
[    2.717578] PM: Adding info for No Bus:ptyue
[    2.718367] device: 'ptyuf': device_add
[    2.719187] PM: Adding info for No Bus:ptyuf
[    2.719954] device: 'ptyv0': device_add
[    2.720776] PM: Adding info for No Bus:ptyv0
[    2.721552] device: 'ptyv1': device_add
[    2.722418] PM: Adding info for No Bus:ptyv1
[    2.723180] device: 'ptyv2': device_add
[    2.724095] PM: Adding info for No Bus:ptyv2
[    2.724884] device: 'ptyv3': device_add
[    2.725769] PM: Adding info for No Bus:ptyv3
[    2.726544] device: 'ptyv4': device_add
[    2.727500] PM: Adding info for No Bus:ptyv4
[    2.728325] device: 'ptyv5': device_add
[    2.729140] PM: Adding info for No Bus:ptyv5
[    2.729889] device: 'ptyv6': device_add
[    2.730726] PM: Adding info for No Bus:ptyv6
[    2.731504] device: 'ptyv7': device_add
[    2.732445] PM: Adding info for No Bus:ptyv7
[    2.733206] device: 'ptyv8': device_add
[    2.734081] PM: Adding info for No Bus:ptyv8
[    2.734831] device: 'ptyv9': device_add
[    2.735716] PM: Adding info for No Bus:ptyv9
[    2.736502] device: 'ptyva': device_add
[    2.737435] PM: Adding info for No Bus:ptyva
[    2.738212] device: 'ptyvb': device_add
[    2.739086] PM: Adding info for No Bus:ptyvb
[    2.739837] device: 'ptyvc': device_add
[    2.740723] PM: Adding info for No Bus:ptyvc
[    2.741497] device: 'ptyvd': device_add
[    2.742336] PM: Adding info for No Bus:ptyvd
[    2.743093] device: 'ptyve': device_add
[    2.743890] PM: Adding info for No Bus:ptyve
[    2.744667] device: 'ptyvf': device_add
[    2.745476] PM: Adding info for No Bus:ptyvf
[    2.746265] device: 'ptyw0': device_add
[    2.747090] PM: Adding info for No Bus:ptyw0
[    2.747841] device: 'ptyw1': device_add
[    2.748653] PM: Adding info for No Bus:ptyw1
[    2.749428] device: 'ptyw2': device_add
[    2.750230] PM: Adding info for No Bus:ptyw2
[    2.751033] device: 'ptyw3': device_add
[    2.751816] PM: Adding info for No Bus:ptyw3
[    2.752589] device: 'ptyw4': device_add
[    2.753422] PM: Adding info for No Bus:ptyw4
[    2.754213] device: 'ptyw5': device_add
[    2.755052] PM: Adding info for No Bus:ptyw5
[    2.755813] device: 'ptyw6': device_add
[    2.756721] PM: Adding info for No Bus:ptyw6
[    2.757502] device: 'ptyw7': device_add
[    2.758327] PM: Adding info for No Bus:ptyw7
[    2.759087] device: 'ptyw8': device_add
[    2.759882] PM: Adding info for No Bus:ptyw8
[    2.760655] device: 'ptyw9': device_add
[    2.761472] PM: Adding info for No Bus:ptyw9
[    2.762255] device: 'ptywa': device_add
[    2.763062] PM: Adding info for No Bus:ptywa
[    2.763826] device: 'ptywb': device_add
[    2.764645] PM: Adding info for No Bus:ptywb
[    2.765420] device: 'ptywc': device_add
[    2.766272] PM: Adding info for No Bus:ptywc
[    2.767041] device: 'ptywd': device_add
[    2.767827] PM: Adding info for No Bus:ptywd
[    2.768607] device: 'ptywe': device_add
[    2.769421] PM: Adding info for No Bus:ptywe
[    2.770262] device: 'ptywf': device_add
[    2.771064] PM: Adding info for No Bus:ptywf
[    2.771835] device: 'ptyx0': device_add
[    2.772670] PM: Adding info for No Bus:ptyx0
[    2.773444] device: 'ptyx1': device_add
[    2.774231] PM: Adding info for No Bus:ptyx1
[    2.774978] device: 'ptyx2': device_add
[    2.775811] PM: Adding info for No Bus:ptyx2
[    2.776619] device: 'ptyx3': device_add
[    2.777442] PM: Adding info for No Bus:ptyx3
[    2.778202] device: 'ptyx4': device_add
[    2.779048] PM: Adding info for No Bus:ptyx4
[    2.779823] device: 'ptyx5': device_add
[    2.780653] PM: Adding info for No Bus:ptyx5
[    2.781441] device: 'ptyx6': device_add
[    2.782229] PM: Adding info for No Bus:ptyx6
[    2.782979] device: 'ptyx7': device_add
[    2.783883] PM: Adding info for No Bus:ptyx7
[    2.784659] device: 'ptyx8': device_add
[    2.785541] PM: Adding info for No Bus:ptyx8
[    2.786307] device: 'ptyx9': device_add
[    2.787205] PM: Adding info for No Bus:ptyx9
[    2.787955] device: 'ptyxa': device_add
[    2.788797] PM: Adding info for No Bus:ptyxa
[    2.789596] device: 'ptyxb': device_add
[    2.790419] PM: Adding info for No Bus:ptyxb
[    2.791188] device: 'ptyxc': device_add
[    2.792099] PM: Adding info for No Bus:ptyxc
[    2.792849] device: 'ptyxd': device_add
[    2.793809] PM: Adding info for No Bus:ptyxd
[    2.794582] device: 'ptyxe': device_add
[    2.795471] PM: Adding info for No Bus:ptyxe
[    2.796232] device: 'ptyxf': device_add
[    2.797104] PM: Adding info for No Bus:ptyxf
[    2.797869] device: 'ptyy0': device_add
[    2.798705] PM: Adding info for No Bus:ptyy0
[    2.799486] device: 'ptyy1': device_add
[    2.800389] PM: Adding info for No Bus:ptyy1
[    2.801152] device: 'ptyy2': device_add
[    2.801928] PM: Adding info for No Bus:ptyy2
[    2.802729] device: 'ptyy3': device_add
[    2.803547] PM: Adding info for No Bus:ptyy3
[    2.804321] device: 'ptyy4': device_add
[    2.805132] PM: Adding info for No Bus:ptyy4
[    2.805897] device: 'ptyy5': device_add
[    2.806726] PM: Adding info for No Bus:ptyy5
[    2.807510] device: 'ptyy6': device_add
[    2.808326] PM: Adding info for No Bus:ptyy6
[    2.809083] device: 'ptyy7': device_add
[    2.809890] PM: Adding info for No Bus:ptyy7
[    2.810662] device: 'ptyy8': device_add
[    2.811476] PM: Adding info for No Bus:ptyy8
[    2.812251] device: 'ptyy9': device_add
[    2.813044] PM: Adding info for No Bus:ptyy9
[    2.813794] device: 'ptyya': device_add
[    2.814610] PM: Adding info for No Bus:ptyya
[    2.815401] device: 'ptyyb': device_add
[    2.816204] PM: Adding info for No Bus:ptyyb
[    2.816969] device: 'ptyyc': device_add
[    2.817779] PM: Adding info for No Bus:ptyyc
[    2.818568] device: 'ptyyd': device_add
[    2.819372] PM: Adding info for No Bus:ptyyd
[    2.820130] device: 'ptyye': device_add
[    2.820962] PM: Adding info for No Bus:ptyye
[    2.821735] device: 'ptyyf': device_add
[    2.822548] PM: Adding info for No Bus:ptyyf
[    2.823326] device: 'ptyz0': device_add
[    2.824123] PM: Adding info for No Bus:ptyz0
[    2.824886] device: 'ptyz1': device_add
[    2.825710] PM: Adding info for No Bus:ptyz1
[    2.826488] device: 'ptyz2': device_add
[    2.827283] PM: Adding info for No Bus:ptyz2
[    2.828085] device: 'ptyz3': device_add
[    2.828895] PM: Adding info for No Bus:ptyz3
[    2.829672] device: 'ptyz4': device_add
[    2.830567] PM: Adding info for No Bus:ptyz4
[    2.831354] device: 'ptyz5': device_add
[    2.832178] PM: Adding info for No Bus:ptyz5
[    2.832942] device: 'ptyz6': device_add
[    2.833776] PM: Adding info for No Bus:ptyz6
[    2.834553] device: 'ptyz7': device_add
[    2.835352] PM: Adding info for No Bus:ptyz7
[    2.836114] device: 'ptyz8': device_add
[    2.836906] PM: Adding info for No Bus:ptyz8
[    2.837681] device: 'ptyz9': device_add
[    2.838488] PM: Adding info for No Bus:ptyz9
[    2.839264] device: 'ptyza': device_add
[    2.840073] PM: Adding info for No Bus:ptyza
[    2.840831] device: 'ptyzb': device_add
[    2.841642] PM: Adding info for No Bus:ptyzb
[    2.842430] device: 'ptyzc': device_add
[    2.843238] PM: Adding info for No Bus:ptyzc
[    2.843995] device: 'ptyzd': device_add
[    2.844808] PM: Adding info for No Bus:ptyzd
[    2.845584] device: 'ptyze': device_add
[    2.846381] PM: Adding info for No Bus:ptyze
[    2.847141] device: 'ptyzf': device_add
[    2.847975] PM: Adding info for No Bus:ptyzf
[    2.848761] device: 'ptya0': device_add
[    2.849573] PM: Adding info for No Bus:ptya0
[    2.850360] device: 'ptya1': device_add
[    2.851179] PM: Adding info for No Bus:ptya1
[    2.851930] device: 'ptya2': device_add
[    2.852729] PM: Adding info for No Bus:ptya2
[    2.853533] device: 'ptya3': device_add
[    2.854356] PM: Adding info for No Bus:ptya3
[    2.855119] device: 'ptya4': device_add
[    2.855931] PM: Adding info for No Bus:ptya4
[    2.856721] device: 'ptya5': device_add
[    2.857531] PM: Adding info for No Bus:ptya5
[    2.858325] device: 'ptya6': device_add
[    2.859143] PM: Adding info for No Bus:ptya6
[    2.859994] device: 'ptya7': device_add
[    2.860792] PM: Adding info for No Bus:ptya7
[    2.861559] device: 'ptya8': device_add
[    2.862372] PM: Adding info for No Bus:ptya8
[    2.863136] device: 'ptya9': device_add
[    2.863912] PM: Adding info for No Bus:ptya9
[    2.864687] device: 'ptyaa': device_add
[    2.865502] PM: Adding info for No Bus:ptyaa
[    2.866275] device: 'ptyab': device_add
[    2.867093] PM: Adding info for No Bus:ptyab
[    2.867865] device: 'ptyac': device_add
[    2.868697] PM: Adding info for No Bus:ptyac
[    2.869475] device: 'ptyad': device_add
[    2.870294] PM: Adding info for No Bus:ptyad
[    2.871061] device: 'ptyae': device_add
[    2.871837] PM: Adding info for No Bus:ptyae
[    2.872608] device: 'ptyaf': device_add
[    2.873422] PM: Adding info for No Bus:ptyaf
[    2.874185] device: 'ptyb0': device_add
[    2.875023] PM: Adding info for No Bus:ptyb0
[    2.875784] device: 'ptyb1': device_add
[    2.876610] PM: Adding info for No Bus:ptyb1
[    2.877390] device: 'ptyb2': device_add
[    2.878203] PM: Adding info for No Bus:ptyb2
[    2.878995] device: 'ptyb3': device_add
[    2.879798] PM: Adding info for No Bus:ptyb3
[    2.880568] device: 'ptyb4': device_add
[    2.881406] PM: Adding info for No Bus:ptyb4
[    2.882185] device: 'ptyb5': device_add
[    2.882964] PM: Adding info for No Bus:ptyb5
[    2.883733] device: 'ptyb6': device_add
[    2.884551] PM: Adding info for No Bus:ptyb6
[    2.885342] device: 'ptyb7': device_add
[    2.886148] PM: Adding info for No Bus:ptyb7
[    2.886901] device: 'ptyb8': device_add
[    2.887717] PM: Adding info for No Bus:ptyb8
[    2.888503] device: 'ptyb9': device_add
[    2.889346] PM: Adding info for No Bus:ptyb9
[    2.890200] device: 'ptyba': device_add
[    2.890993] PM: Adding info for No Bus:ptyba
[    2.891770] device: 'ptybb': device_add
[    2.892581] PM: Adding info for No Bus:ptybb
[    2.893365] device: 'ptybc': device_add
[    2.894169] PM: Adding info for No Bus:ptybc
[    2.894937] device: 'ptybd': device_add
[    2.895806] PM: Adding info for No Bus:ptybd
[    2.896580] device: 'ptybe': device_add
[    2.897380] PM: Adding info for No Bus:ptybe
[    2.898142] device: 'ptybf': device_add
[    2.898949] PM: Adding info for No Bus:ptybf
[    2.899727] device: 'ptyc0': device_add
[    2.900538] PM: Adding info for No Bus:ptyc0
[    2.901315] device: 'ptyc1': device_add
[    2.902151] PM: Adding info for No Bus:ptyc1
[    2.902915] device: 'ptyc2': device_add
[    2.903746] PM: Adding info for No Bus:ptyc2
[    2.904553] device: 'ptyc3': device_add
[    2.905354] PM: Adding info for No Bus:ptyc3
[    2.906116] device: 'ptyc4': device_add
[    2.906926] PM: Adding info for No Bus:ptyc4
[    2.907714] device: 'ptyc5': device_add
[    2.908626] PM: Adding info for No Bus:ptyc5
[    2.909401] device: 'ptyc6': device_add
[    2.910205] PM: Adding info for No Bus:ptyc6
[    2.910970] device: 'ptyc7': device_add
[    2.911800] PM: Adding info for No Bus:ptyc7
[    2.912588] device: 'ptyc8': device_add
[    2.913391] PM: Adding info for No Bus:ptyc8
[    2.914150] device: 'ptyc9': device_add
[    2.915065] PM: Adding info for No Bus:ptyc9
[    2.915816] device: 'ptyca': device_add
[    2.916703] PM: Adding info for No Bus:ptyca
[    2.917474] device: 'ptycb': device_add
[    2.918415] PM: Adding info for No Bus:ptycb
[    2.919181] device: 'ptycc': device_add
[    2.919988] PM: Adding info for No Bus:ptycc
[    2.920919] device: 'ptycd': device_add
[    2.921787] PM: Adding info for No Bus:ptycd
[    2.922593] device: 'ptyce': device_add
[    2.923485] PM: Adding info for No Bus:ptyce
[    2.924261] device: 'ptycf': device_add
[    2.925108] PM: Adding info for No Bus:ptycf
[    2.925857] device: 'ptyd0': device_add
[    2.926738] PM: Adding info for No Bus:ptyd0
[    2.927515] device: 'ptyd1': device_add
[    2.928387] PM: Adding info for No Bus:ptyd1
[    2.929159] device: 'ptyd2': device_add
[    2.930059] PM: Adding info for No Bus:ptyd2
[    2.930840] device: 'ptyd3': device_add
[    2.931645] PM: Adding info for No Bus:ptyd3
[    2.932417] device: 'ptyd4': device_add
[    2.933239] PM: Adding info for No Bus:ptyd4
[    2.934032] device: 'ptyd5': device_add
[    2.934827] PM: Adding info for No Bus:ptyd5
[    2.935599] device: 'ptyd6': device_add
[    2.936399] PM: Adding info for No Bus:ptyd6
[    2.937173] device: 'ptyd7': device_add
[    2.937978] PM: Adding info for No Bus:ptyd7
[    2.938784] device: 'ptyd8': device_add
[    2.939587] PM: Adding info for No Bus:ptyd8
[    2.940353] device: 'ptyd9': device_add
[    2.941162] PM: Adding info for No Bus:ptyd9
[    2.941916] device: 'ptyda': device_add
[    2.942716] PM: Adding info for No Bus:ptyda
[    2.943486] device: 'ptydb': device_add
[    2.944309] PM: Adding info for No Bus:ptydb
[    2.945071] device: 'ptydc': device_add
[    2.945877] PM: Adding info for No Bus:ptydc
[    2.946667] device: 'ptydd': device_add
[    2.947478] PM: Adding info for No Bus:ptydd
[    2.948236] device: 'ptyde': device_add
[    2.949061] PM: Adding info for No Bus:ptyde
[    2.949882] device: 'ptydf': device_add
[    2.950680] PM: Adding info for No Bus:ptydf
[    2.951456] device: 'ptye0': device_add
[    2.952271] PM: Adding info for No Bus:ptye0
[    2.953040] device: 'ptye1': device_add
[    2.953819] PM: Adding info for No Bus:ptye1
[    2.954603] device: 'ptye2': device_add
[    2.955431] PM: Adding info for No Bus:ptye2
[    2.956233] device: 'ptye3': device_add
[    2.957093] PM: Adding info for No Bus:ptye3
[    2.957843] device: 'ptye4': device_add
[    2.958674] PM: Adding info for No Bus:ptye4
[    2.959462] device: 'ptye5': device_add
[    2.960274] PM: Adding info for No Bus:ptye5
[    2.961038] device: 'ptye6': device_add
[    2.961817] PM: Adding info for No Bus:ptye6
[    2.962592] device: 'ptye7': device_add
[    2.963423] PM: Adding info for No Bus:ptye7
[    2.964207] device: 'ptye8': device_add
[    2.965002] PM: Adding info for No Bus:ptye8
[    2.965799] device: 'ptye9': device_add
[    2.966631] PM: Adding info for No Bus:ptye9
[    2.967429] device: 'ptyea': device_add
[    2.968275] PM: Adding info for No Bus:ptyea
[    2.969064] device: 'ptyeb': device_add
[    2.969856] PM: Adding info for No Bus:ptyeb
[    2.970645] device: 'ptyec': device_add
[    2.971479] PM: Adding info for No Bus:ptyec
[    2.972274] device: 'ptyed': device_add
[    2.973082] PM: Adding info for No Bus:ptyed
[    2.973846] device: 'ptyee': device_add
[    2.974673] PM: Adding info for No Bus:ptyee
[    2.975449] device: 'ptyef': device_add
[    2.976237] PM: Adding info for No Bus:ptyef
[    2.976991] device: 'ttyp0': device_add
[    2.977809] PM: Adding info for No Bus:ttyp0
[    2.978596] device: 'ttyp1': device_add
[    2.979415] PM: Adding info for No Bus:ttyp1
[    2.980256] device: 'ttyp2': device_add
[    2.981058] PM: Adding info for No Bus:ttyp2
[    2.981854] device: 'ttyp3': device_add
[    2.982690] PM: Adding info for No Bus:ttyp3
[    2.983475] device: 'ttyp4': device_add
[    2.984337] PM: Adding info for No Bus:ttyp4
[    2.985111] device: 'ttyp5': device_add
[    2.985911] PM: Adding info for No Bus:ttyp5
[    2.986683] device: 'ttyp6': device_add
[    2.987515] PM: Adding info for No Bus:ttyp6
[    2.988297] device: 'ttyp7': device_add
[    2.989107] PM: Adding info for No Bus:ttyp7
[    2.989863] device: 'ttyp8': device_add
[    2.990689] PM: Adding info for No Bus:ttyp8
[    2.991492] device: 'ttyp9': device_add
[    2.992300] PM: Adding info for No Bus:ttyp9
[    2.993065] device: 'ttypa': device_add
[    2.993862] PM: Adding info for No Bus:ttypa
[    2.994638] device: 'ttypb': device_add
[    2.995438] PM: Adding info for No Bus:ttypb
[    2.996196] device: 'ttypc': device_add
[    2.996987] PM: Adding info for No Bus:ttypc
[    2.997761] device: 'ttypd': device_add
[    2.998577] PM: Adding info for No Bus:ttypd
[    2.999365] device: 'ttype': device_add
[    3.000187] PM: Adding info for No Bus:ttype
[    3.000939] device: 'ttypf': device_add
[    3.001756] PM: Adding info for No Bus:ttypf
[    3.002533] device: 'ttyq0': device_add
[    3.003348] PM: Adding info for No Bus:ttyq0
[    3.004110] device: 'ttyq1': device_add
[    3.004906] PM: Adding info for No Bus:ttyq1
[    3.005686] device: 'ttyq2': device_add
[    3.006481] PM: Adding info for No Bus:ttyq2
[    3.007293] device: 'ttyq3': device_add
[    3.008117] PM: Adding info for No Bus:ttyq3
[    3.008895] device: 'ttyq4': device_add
[    3.009868] PM: Adding info for No Bus:ttyq4
[    3.010751] device: 'ttyq5': device_add
[    3.011611] PM: Adding info for No Bus:ttyq5
[    3.012386] device: 'ttyq6': device_add
[    3.013190] PM: Adding info for No Bus:ttyq6
[    3.013944] device: 'ttyq7': device_add
[    3.014749] PM: Adding info for No Bus:ttyq7
[    3.015524] device: 'ttyq8': device_add
[    3.016364] PM: Adding info for No Bus:ttyq8
[    3.017146] device: 'ttyq9': device_add
[    3.017939] PM: Adding info for No Bus:ttyq9
[    3.018728] device: 'ttyqa': device_add
[    3.019544] PM: Adding info for No Bus:ttyqa
[    3.020317] device: 'ttyqb': device_add
[    3.021110] PM: Adding info for No Bus:ttyqb
[    3.021863] device: 'ttyqc': device_add
[    3.022680] PM: Adding info for No Bus:ttyqc
[    3.023452] device: 'ttyqd': device_add
[    3.024268] PM: Adding info for No Bus:ttyqd
[    3.025054] device: 'ttyqe': device_add
[    3.025844] PM: Adding info for No Bus:ttyqe
[    3.026625] device: 'ttyqf': device_add
[    3.027537] PM: Adding info for No Bus:ttyqf
[    3.028323] device: 'ttyr0': device_add
[    3.029115] PM: Adding info for No Bus:ttyr0
[    3.029863] device: 'ttyr1': device_add
[    3.030676] PM: Adding info for No Bus:ttyr1
[    3.031451] device: 'ttyr2': device_add
[    3.032239] PM: Adding info for No Bus:ttyr2
[    3.033054] device: 'ttyr3': device_add
[    3.033868] PM: Adding info for No Bus:ttyr3
[    3.034656] device: 'ttyr4': device_add
[    3.035497] PM: Adding info for No Bus:ttyr4
[    3.036290] device: 'ttyr5': device_add
[    3.037081] PM: Adding info for No Bus:ttyr5
[    3.037834] device: 'ttyr6': device_add
[    3.038699] PM: Adding info for No Bus:ttyr6
[    3.039523] device: 'ttyr7': device_add
[    3.040362] PM: Adding info for No Bus:ttyr7
[    3.041124] device: 'ttyr8': device_add
[    3.041923] PM: Adding info for No Bus:ttyr8
[    3.042711] device: 'ttyr9': device_add
[    3.043518] PM: Adding info for No Bus:ttyr9
[    3.044291] device: 'ttyra': device_add
[    3.045106] PM: Adding info for No Bus:ttyra
[    3.045856] device: 'ttyrb': device_add
[    3.046671] PM: Adding info for No Bus:ttyrb
[    3.047448] device: 'ttyrc': device_add
[    3.048237] PM: Adding info for No Bus:ttyrc
[    3.048996] device: 'ttyrd': device_add
[    3.049815] PM: Adding info for No Bus:ttyrd
[    3.050593] device: 'ttyre': device_add
[    3.051407] PM: Adding info for No Bus:ttyre
[    3.052178] device: 'ttyrf': device_add
[    3.052983] PM: Adding info for No Bus:ttyrf
[    3.053760] device: 'ttys0': device_add
[    3.054557] PM: Adding info for No Bus:ttys0
[    3.055331] device: 'ttys1': device_add
[    3.056142] PM: Adding info for No Bus:ttys1
[    3.056894] device: 'ttys2': device_add
[    3.057711] PM: Adding info for No Bus:ttys2
[    3.058530] device: 'ttys3': device_add
[    3.059348] PM: Adding info for No Bus:ttys3
[    3.060126] device: 'ttys4': device_add
[    3.060952] PM: Adding info for No Bus:ttys4
[    3.061761] device: 'ttys5': device_add
[    3.062568] PM: Adding info for No Bus:ttys5
[    3.063340] device: 'ttys6': device_add
[    3.064139] PM: Adding info for No Bus:ttys6
[    3.064892] device: 'ttys7': device_add
[    3.065730] PM: Adding info for No Bus:ttys7
[    3.066504] device: 'ttys8': device_add
[    3.067329] PM: Adding info for No Bus:ttys8
[    3.068094] device: 'ttys9': device_add
[    3.068917] PM: Adding info for No Bus:ttys9
[    3.069715] device: 'ttysa': device_add
[    3.070589] PM: Adding info for No Bus:ttysa
[    3.071363] device: 'ttysb': device_add
[    3.072175] PM: Adding info for No Bus:ttysb
[    3.072925] device: 'ttysc': device_add
[    3.073730] PM: Adding info for No Bus:ttysc
[    3.074501] device: 'ttysd': device_add
[    3.075322] PM: Adding info for No Bus:ttysd
[    3.076085] device: 'ttyse': device_add
[    3.076869] PM: Adding info for No Bus:ttyse
[    3.077658] device: 'ttysf': device_add
[    3.078498] PM: Adding info for No Bus:ttysf
[    3.079273] device: 'ttyt0': device_add
[    3.080082] PM: Adding info for No Bus:ttyt0
[    3.080835] device: 'ttyt1': device_add
[    3.081635] PM: Adding info for No Bus:ttyt1
[    3.082408] device: 'ttyt2': device_add
[    3.083229] PM: Adding info for No Bus:ttyt2
[    3.084032] device: 'ttyt3': device_add
[    3.084841] PM: Adding info for No Bus:ttyt3
[    3.085628] device: 'ttyt4': device_add
[    3.086474] PM: Adding info for No Bus:ttyt4
[    3.087274] device: 'ttyt5': device_add
[    3.088077] PM: Adding info for No Bus:ttyt5
[    3.088844] device: 'ttyt6': device_add
[    3.089663] PM: Adding info for No Bus:ttyt6
[    3.090435] device: 'ttyt7': device_add
[    3.091239] PM: Adding info for No Bus:ttyt7
[    3.091992] device: 'ttyt8': device_add
[    3.092834] PM: Adding info for No Bus:ttyt8
[    3.093608] device: 'ttyt9': device_add
[    3.094436] PM: Adding info for No Bus:ttyt9
[    3.095213] device: 'ttyta': device_add
[    3.096035] PM: Adding info for No Bus:ttyta
[    3.096784] device: 'ttytb': device_add
[    3.097604] PM: Adding info for No Bus:ttytb
[    3.098391] device: 'ttytc': device_add
[    3.099178] PM: Adding info for No Bus:ttytc
[    3.099925] device: 'ttytd': device_add
[    3.100815] PM: Adding info for No Bus:ttytd
[    3.101592] device: 'ttyte': device_add
[    3.102408] PM: Adding info for No Bus:ttyte
[    3.103184] device: 'ttytf': device_add
[    3.103981] PM: Adding info for No Bus:ttytf
[    3.104771] device: 'ttyu0': device_add
[    3.105592] PM: Adding info for No Bus:ttyu0
[    3.106370] device: 'ttyu1': device_add
[    3.107163] PM: Adding info for No Bus:ttyu1
[    3.107913] device: 'ttyu2': device_add
[    3.108743] PM: Adding info for No Bus:ttyu2
[    3.109558] device: 'ttyu3': device_add
[    3.110363] PM: Adding info for No Bus:ttyu3
[    3.111125] device: 'ttyu4': device_add
[    3.111951] PM: Adding info for No Bus:ttyu4
[    3.112754] device: 'ttyu5': device_add
[    3.113589] PM: Adding info for No Bus:ttyu5
[    3.114364] device: 'ttyu6': device_add
[    3.115157] PM: Adding info for No Bus:ttyu6
[    3.115905] device: 'ttyu7': device_add
[    3.116726] PM: Adding info for No Bus:ttyu7
[    3.117499] device: 'ttyu8': device_add
[    3.118324] PM: Adding info for No Bus:ttyu8
[    3.119085] device: 'ttyu9': device_add
[    3.119935] PM: Adding info for No Bus:ttyu9
[    3.120725] device: 'ttyua': device_add
[    3.121548] PM: Adding info for No Bus:ttyua
[    3.122324] device: 'ttyub': device_add
[    3.123128] PM: Adding info for No Bus:ttyub
[    3.123878] device: 'ttyuc': device_add
[    3.124693] PM: Adding info for No Bus:ttyuc
[    3.125467] device: 'ttyud': device_add
[    3.126270] PM: Adding info for No Bus:ttyud
[    3.127030] device: 'ttyue': device_add
[    3.127826] PM: Adding info for No Bus:ttyue
[    3.128616] device: 'ttyuf': device_add
[    3.129428] PM: Adding info for No Bus:ttyuf
[    3.130259] device: 'ttyv0': device_add
[    3.131072] PM: Adding info for No Bus:ttyv0
[    3.131833] device: 'ttyv1': device_add
[    3.132640] PM: Adding info for No Bus:ttyv1
[    3.133411] device: 'ttyv2': device_add
[    3.134216] PM: Adding info for No Bus:ttyv2
[    3.134993] device: 'ttyv3': device_add
[    3.135811] PM: Adding info for No Bus:ttyv3
[    3.136586] device: 'ttyv4': device_add
[    3.137405] PM: Adding info for No Bus:ttyv4
[    3.138199] device: 'ttyv5': device_add
[    3.139049] PM: Adding info for No Bus:ttyv5
[    3.139809] device: 'ttyv6': device_add
[    3.140609] PM: Adding info for No Bus:ttyv6
[    3.141380] device: 'ttyv7': device_add
[    3.142184] PM: Adding info for No Bus:ttyv7
[    3.142935] device: 'ttyv8': device_add
[    3.143734] PM: Adding info for No Bus:ttyv8
[    3.144503] device: 'ttyv9': device_add
[    3.145346] PM: Adding info for No Bus:ttyv9
[    3.146113] device: 'ttyva': device_add
[    3.146969] PM: Adding info for No Bus:ttyva
[    3.147764] device: 'ttyvb': device_add
[    3.148581] PM: Adding info for No Bus:ttyvb
[    3.149354] device: 'ttyvc': device_add
[    3.150167] PM: Adding info for No Bus:ttyvc
[    3.150921] device: 'ttyvd': device_add
[    3.151720] PM: Adding info for No Bus:ttyvd
[    3.152487] device: 'ttyve': device_add
[    3.153305] PM: Adding info for No Bus:ttyve
[    3.154068] device: 'ttyvf': device_add
[    3.154853] PM: Adding info for No Bus:ttyvf
[    3.155640] device: 'ttyw0': device_add
[    3.156463] PM: Adding info for No Bus:ttyw0
[    3.157228] device: 'ttyw1': device_add
[    3.158047] PM: Adding info for No Bus:ttyw1
[    3.158811] device: 'ttyw2': device_add
[    3.159612] PM: Adding info for No Bus:ttyw2
[    3.160482] device: 'ttyw3': device_add
[    3.161305] PM: Adding info for No Bus:ttyw3
[    3.162068] device: 'ttyw4': device_add
[    3.162865] PM: Adding info for No Bus:ttyw4
[    3.163662] device: 'ttyw5': device_add
[    3.164492] PM: Adding info for No Bus:ttyw5
[    3.165281] device: 'ttyw6': device_add
[    3.166075] PM: Adding info for No Bus:ttyw6
[    3.166822] device: 'ttyw7': device_add
[    3.167636] PM: Adding info for No Bus:ttyw7
[    3.168423] device: 'ttyw8': device_add
[    3.169224] PM: Adding info for No Bus:ttyw8
[    3.169973] device: 'ttyw9': device_add
[    3.170771] PM: Adding info for No Bus:ttyw9
[    3.171542] device: 'ttywa': device_add
[    3.172363] PM: Adding info for No Bus:ttywa
[    3.173138] device: 'ttywb': device_add
[    3.173969] PM: Adding info for No Bus:ttywb
[    3.174743] device: 'ttywc': device_add
[    3.175560] PM: Adding info for No Bus:ttywc
[    3.176335] device: 'ttywd': device_add
[    3.177122] PM: Adding info for No Bus:ttywd
[    3.177869] device: 'ttywe': device_add
[    3.178728] PM: Adding info for No Bus:ttywe
[    3.179501] device: 'ttywf': device_add
[    3.180324] PM: Adding info for No Bus:ttywf
[    3.181097] device: 'ttyx0': device_add
[    3.181886] PM: Adding info for No Bus:ttyx0
[    3.182669] device: 'ttyx1': device_add
[    3.183486] PM: Adding info for No Bus:ttyx1
[    3.184260] device: 'ttyx2': device_add
[    3.185075] PM: Adding info for No Bus:ttyx2
[    3.185852] device: 'ttyx3': device_add
[    3.186673] PM: Adding info for No Bus:ttyx3
[    3.187448] device: 'ttyx4': device_add
[    3.188278] PM: Adding info for No Bus:ttyx4
[    3.189057] device: 'ttyx5': device_add
[    3.189860] PM: Adding info for No Bus:ttyx5
[    3.190728] device: 'ttyx6': device_add
[    3.191556] PM: Adding info for No Bus:ttyx6
[    3.192328] device: 'ttyx7': device_add
[    3.193118] PM: Adding info for No Bus:ttyx7
[    3.193864] device: 'ttyx8': device_add
[    3.194678] PM: Adding info for No Bus:ttyx8
[    3.195450] device: 'ttyx9': device_add
[    3.196237] PM: Adding info for No Bus:ttyx9
[    3.196990] device: 'ttyxa': device_add
[    3.197806] PM: Adding info for No Bus:ttyxa
[    3.198602] device: 'ttyxb': device_add
[    3.199416] PM: Adding info for No Bus:ttyxb
[    3.200181] device: 'ttyxc': device_add
[    3.201041] PM: Adding info for No Bus:ttyxc
[    3.201799] device: 'ttyxd': device_add
[    3.202616] PM: Adding info for No Bus:ttyxd
[    3.203391] device: 'ttyxe': device_add
[    3.204178] PM: Adding info for No Bus:ttyxe
[    3.204924] device: 'ttyxf': device_add
[    3.205742] PM: Adding info for No Bus:ttyxf
[    3.206517] device: 'ttyy0': device_add
[    3.207337] PM: Adding info for No Bus:ttyy0
[    3.208110] device: 'ttyy1': device_add
[    3.208922] PM: Adding info for No Bus:ttyy1
[    3.209699] device: 'ttyy2': device_add
[    3.210500] PM: Adding info for No Bus:ttyy2
[    3.211301] device: 'ttyy3': device_add
[    3.212108] PM: Adding info for No Bus:ttyy3
[    3.212857] device: 'ttyy4': device_add
[    3.213688] PM: Adding info for No Bus:ttyy4
[    3.214477] device: 'ttyy5': device_add
[    3.215284] PM: Adding info for No Bus:ttyy5
[    3.216061] device: 'ttyy6': device_add
[    3.216874] PM: Adding info for No Bus:ttyy6
[    3.217663] device: 'ttyy7': device_add
[    3.218473] PM: Adding info for No Bus:ttyy7
[    3.219230] device: 'ttyy8': device_add
[    3.220127] PM: Adding info for No Bus:ttyy8
[    3.220874] device: 'ttyy9': device_add
[    3.221673] PM: Adding info for No Bus:ttyy9
[    3.222442] device: 'ttyya': device_add
[    3.223257] PM: Adding info for No Bus:ttyya
[    3.224007] device: 'ttyyb': device_add
[    3.224836] PM: Adding info for No Bus:ttyyb
[    3.225632] device: 'ttyyc': device_add
[    3.226435] PM: Adding info for No Bus:ttyyc
[    3.227195] device: 'ttyyd': device_add
[    3.228054] PM: Adding info for No Bus:ttyyd
[    3.228816] device: 'ttyye': device_add
[    3.229618] PM: Adding info for No Bus:ttyye
[    3.230390] device: 'ttyyf': device_add
[    3.231192] PM: Adding info for No Bus:ttyyf
[    3.231942] device: 'ttyz0': device_add
[    3.232747] PM: Adding info for No Bus:ttyz0
[    3.233533] device: 'ttyz1': device_add
[    3.234356] PM: Adding info for No Bus:ttyz1
[    3.235127] device: 'ttyz2': device_add
[    3.235925] PM: Adding info for No Bus:ttyz2
[    3.236729] device: 'ttyz3': device_add
[    3.237534] PM: Adding info for No Bus:ttyz3
[    3.238318] device: 'ttyz4': device_add
[    3.239141] PM: Adding info for No Bus:ttyz4
[    3.239909] device: 'ttyz5': device_add
[    3.240714] PM: Adding info for No Bus:ttyz5
[    3.241490] device: 'ttyz6': device_add
[    3.242330] PM: Adding info for No Bus:ttyz6
[    3.243105] device: 'ttyz7': device_add
[    3.243887] PM: Adding info for No Bus:ttyz7
[    3.244662] device: 'ttyz8': device_add
[    3.245479] PM: Adding info for No Bus:ttyz8
[    3.246252] device: 'ttyz9': device_add
[    3.247062] PM: Adding info for No Bus:ttyz9
[    3.247833] device: 'ttyza': device_add
[    3.248654] PM: Adding info for No Bus:ttyza
[    3.249430] device: 'ttyzb': device_add
[    3.250350] PM: Adding info for No Bus:ttyzb
[    3.251129] device: 'ttyzc': device_add
[    3.251924] PM: Adding info for No Bus:ttyzc
[    3.252764] device: 'ttyzd': device_add
[    3.253575] PM: Adding info for No Bus:ttyzd
[    3.254348] device: 'ttyze': device_add
[    3.255179] PM: Adding info for No Bus:ttyze
[    3.255925] device: 'ttyzf': device_add
[    3.256742] PM: Adding info for No Bus:ttyzf
[    3.257515] device: 'ttya0': device_add
[    3.258340] PM: Adding info for No Bus:ttya0
[    3.259116] device: 'ttya1': device_add
[    3.259921] PM: Adding info for No Bus:ttya1
[    3.260709] device: 'ttya2': device_add
[    3.261648] PM: Adding info for No Bus:ttya2
[    3.262544] device: 'ttya3': device_add
[    3.263339] PM: Adding info for No Bus:ttya3
[    3.264096] device: 'ttya4': device_add
[    3.264905] PM: Adding info for No Bus:ttya4
[    3.265696] device: 'ttya5': device_add
[    3.266503] PM: Adding info for No Bus:ttya5
[    3.267272] device: 'ttya6': device_add
[    3.268087] PM: Adding info for No Bus:ttya6
[    3.268868] device: 'ttya7': device_add
[    3.269703] PM: Adding info for No Bus:ttya7
[    3.270478] device: 'ttya8': device_add
[    3.271276] PM: Adding info for No Bus:ttya8
[    3.272052] device: 'ttya9': device_add
[    3.272845] PM: Adding info for No Bus:ttya9
[    3.273623] device: 'ttyaa': device_add
[    3.274436] PM: Adding info for No Bus:ttyaa
[    3.275196] device: 'ttyab': device_add
[    3.275993] PM: Adding info for No Bus:ttyab
[    3.276789] device: 'ttyac': device_add
[    3.277602] PM: Adding info for No Bus:ttyac
[    3.278396] device: 'ttyad': device_add
[    3.279199] PM: Adding info for No Bus:ttyad
[    3.280051] device: 'ttyae': device_add
[    3.280842] PM: Adding info for No Bus:ttyae
[    3.281620] device: 'ttyaf': device_add
[    3.282459] PM: Adding info for No Bus:ttyaf
[    3.283221] device: 'ttyb0': device_add
[    3.284050] PM: Adding info for No Bus:ttyb0
[    3.284810] device: 'ttyb1': device_add
[    3.285620] PM: Adding info for No Bus:ttyb1
[    3.286407] device: 'ttyb2': device_add
[    3.287211] PM: Adding info for No Bus:ttyb2
[    3.287992] device: 'ttyb3': device_add
[    3.288811] PM: Adding info for No Bus:ttyb3
[    3.289586] device: 'ttyb4': device_add
[    3.290418] PM: Adding info for No Bus:ttyb4
[    3.291193] device: 'ttyb5': device_add
[    3.291993] PM: Adding info for No Bus:ttyb5
[    3.292768] device: 'ttyb6': device_add
[    3.293573] PM: Adding info for No Bus:ttyb6
[    3.294355] device: 'ttyb7': device_add
[    3.295176] PM: Adding info for No Bus:ttyb7
[    3.295928] device: 'ttyb8': device_add
[    3.296729] PM: Adding info for No Bus:ttyb8
[    3.297501] device: 'ttyb9': device_add
[    3.298313] PM: Adding info for No Bus:ttyb9
[    3.299074] device: 'ttyba': device_add
[    3.299866] PM: Adding info for No Bus:ttyba
[    3.300641] device: 'ttybb': device_add
[    3.301461] PM: Adding info for No Bus:ttybb
[    3.302233] device: 'ttybc': device_add
[    3.303068] PM: Adding info for No Bus:ttybc
[    3.303835] device: 'ttybd': device_add
[    3.304728] PM: Adding info for No Bus:ttybd
[    3.305502] device: 'ttybe': device_add
[    3.306321] PM: Adding info for No Bus:ttybe
[    3.307083] device: 'ttybf': device_add
[    3.307856] PM: Adding info for No Bus:ttybf
[    3.308640] device: 'ttyc0': device_add
[    3.309499] PM: Adding info for No Bus:ttyc0
[    3.310355] device: 'ttyc1': device_add
[    3.311156] PM: Adding info for No Bus:ttyc1
[    3.311918] device: 'ttyc2': device_add
[    3.312748] PM: Adding info for No Bus:ttyc2
[    3.313556] device: 'ttyc3': device_add
[    3.314375] PM: Adding info for No Bus:ttyc3
[    3.315139] device: 'ttyc4': device_add
[    3.315940] PM: Adding info for No Bus:ttyc4
[    3.316729] device: 'ttyc5': device_add
[    3.317548] PM: Adding info for No Bus:ttyc5
[    3.318336] device: 'ttyc6': device_add
[    3.319122] PM: Adding info for No Bus:ttyc6
[    3.319886] device: 'ttyc7': device_add
[    3.320716] PM: Adding info for No Bus:ttyc7
[    3.321504] device: 'ttyc8': device_add
[    3.322457] PM: Adding info for No Bus:ttyc8
[    3.323219] device: 'ttyc9': device_add
[    3.324042] PM: Adding info for No Bus:ttyc9
[    3.324789] device: 'ttyca': device_add
[    3.325603] PM: Adding info for No Bus:ttyca
[    3.326379] device: 'ttycb': device_add
[    3.327170] PM: Adding info for No Bus:ttycb
[    3.327920] device: 'ttycc': device_add
[    3.328761] PM: Adding info for No Bus:ttycc
[    3.329549] device: 'ttycd': device_add
[    3.330363] PM: Adding info for No Bus:ttycd
[    3.331123] device: 'ttyce': device_add
[    3.331922] PM: Adding info for No Bus:ttyce
[    3.332702] device: 'ttycf': device_add
[    3.333503] PM: Adding info for No Bus:ttycf
[    3.334271] device: 'ttyd0': device_add
[    3.335081] PM: Adding info for No Bus:ttyd0
[    3.335829] device: 'ttyd1': device_add
[    3.336684] PM: Adding info for No Bus:ttyd1
[    3.337470] device: 'ttyd2': device_add
[    3.338300] PM: Adding info for No Bus:ttyd2
[    3.339105] device: 'ttyd3': device_add
[    3.339995] PM: Adding info for No Bus:ttyd3
[    3.340855] device: 'ttyd4': device_add
[    3.341674] PM: Adding info for No Bus:ttyd4
[    3.342472] device: 'ttyd5': device_add
[    3.343288] PM: Adding info for No Bus:ttyd5
[    3.344059] device: 'ttyd6': device_add
[    3.344840] PM: Adding info for No Bus:ttyd6
[    3.345615] device: 'ttyd7': device_add
[    3.346447] PM: Adding info for No Bus:ttyd7
[    3.347222] device: 'ttyd8': device_add
[    3.348047] PM: Adding info for No Bus:ttyd8
[    3.348813] device: 'ttyd9': device_add
[    3.349614] PM: Adding info for No Bus:ttyd9
[    3.350387] device: 'ttyda': device_add
[    3.351193] PM: Adding info for No Bus:ttyda
[    3.351943] device: 'ttydb': device_add
[    3.352741] PM: Adding info for No Bus:ttydb
[    3.353513] device: 'ttydc': device_add
[    3.354341] PM: Adding info for No Bus:ttydc
[    3.355115] device: 'ttydd': device_add
[    3.355904] PM: Adding info for No Bus:ttydd
[    3.356689] device: 'ttyde': device_add
[    3.357507] PM: Adding info for No Bus:ttyde
[    3.358294] device: 'ttydf': device_add
[    3.359094] PM: Adding info for No Bus:ttydf
[    3.359847] device: 'ttye0': device_add
[    3.360646] PM: Adding info for No Bus:ttye0
[    3.361419] device: 'ttye1': device_add
[    3.362223] PM: Adding info for No Bus:ttye1
[    3.362981] device: 'ttye2': device_add
[    3.363838] PM: Adding info for No Bus:ttye2
[    3.364654] device: 'ttye3': device_add
[    3.365489] PM: Adding info for No Bus:ttye3
[    3.366263] device: 'ttye4': device_add
[    3.367075] PM: Adding info for No Bus:ttye4
[    3.367841] device: 'ttye5': device_add
[    3.368679] PM: Adding info for No Bus:ttye5
[    3.369456] device: 'ttye6': device_add
[    3.370333] PM: Adding info for No Bus:ttye6
[    3.371096] device: 'ttye7': device_add
[    3.371877] PM: Adding info for No Bus:ttye7
[    3.372661] device: 'ttye8': device_add
[    3.373488] PM: Adding info for No Bus:ttye8
[    3.374270] device: 'ttye9': device_add
[    3.375069] PM: Adding info for No Bus:ttye9
[    3.375820] device: 'ttyea': device_add
[    3.376636] PM: Adding info for No Bus:ttyea
[    3.377409] device: 'ttyeb': device_add
[    3.378198] PM: Adding info for No Bus:ttyeb
[    3.378959] device: 'ttyec': device_add
[    3.379776] PM: Adding info for No Bus:ttyec
[    3.380548] device: 'ttyed': device_add
[    3.381374] PM: Adding info for No Bus:ttyed
[    3.382157] device: 'ttyee': device_add
[    3.382944] PM: Adding info for No Bus:ttyee
[    3.383718] device: 'ttyef': device_add
[    3.384533] PM: Adding info for No Bus:ttyef
[    3.385305] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.386419] Registering platform device 'serial8250'. Parent at platform
[    3.387574] device: 'serial8250': device_add
[    3.388345] bus: 'platform': add device serial8250
[    3.389203] PM: Adding info for platform:serial8250
[    3.414529] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.415600] device: 'ttyS0': device_add
[    3.416501] PM: Adding info for No Bus:ttyS0
[    3.417378] device: 'ttyS1': device_add
[    3.418315] PM: Adding info for No Bus:ttyS1
[    3.419133] device: 'ttyS2': device_add
[    3.419926] PM: Adding info for No Bus:ttyS2
[    3.420806] device: 'ttyS3': device_add
[    3.421680] PM: Adding info for No Bus:ttyS3
[    3.422475] bus: 'platform': add driver serial8250
[    3.423329] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    3.424864] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    3.426333] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    3.427551] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    3.428975] device: 'ttyprintk': device_add
[    3.429964] PM: Adding info for No Bus:ttyprintk
[    3.430795] bus: 'platform': add driver tpm_tis
[    3.431616] Registering platform device 'tpm_tis'. Parent at platform
[    3.432728] device: 'tpm_tis': device_add
[    3.433455] bus: 'platform': add device tpm_tis
[    3.434306] PM: Adding info for platform:tpm_tis
[    3.435137] bus: 'platform': driver_probe_device: matched device tpm_tis with driver tpm_tis
[    3.436587] bus: 'platform': really_probe: probing driver tpm_tis with device tpm_tis
[    3.437930] driver: 'tpm_tis': driver_bound: bound to device 'tpm_tis'
[    3.439067] bus: 'platform': really_probe: bound device tpm_tis to driver tpm_tis
[    3.440362] device: 'tpm0': device_add
[    3.441156] PM: Adding info for No Bus:tpm0
[    4.195061] device: 'tpm0': device_unregister
[    4.195834] PM: Removing info for No Bus:tpm0
[    4.197167] device: 'tpm0': device_create_release
[    4.198234] PM: Removing info for platform:tpm_tis
[    4.199181] bus: 'platform': remove device tpm_tis
[    4.200169] bus: 'platform': remove driver tpm_tis
[    4.201056] driver: 'tpm_tis': driver_release
[    4.201866] Registering platform device 'i8042'. Parent at platform
[    4.202958] device: 'i8042': device_add
[    4.203650] bus: 'platform': add device i8042
[    4.204445] PM: Adding info for platform:i8042
[    4.205233] bus: 'platform': add driver i8042
[    4.205989] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    4.207383] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    4.209696] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.210710] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.211694] device: 'serio0': device_add
[    4.212434] bus: 'serio': add device serio0
[    4.213211] PM: Adding info for serio:serio0
[    4.214044] driver: 'i8042': driver_bound: bound to device 'i8042'
[    4.215125] device: 'serio1': device_add
[    4.215818] bus: 'serio': add device serio1
[    4.216637] PM: Adding info for serio:serio1
[    4.217436] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    4.218699] bus: 'serio': add driver atkbd
[    4.219484] cpuidle: using governor ladder
[    4.220333] 
[    4.220333] printing PIC contents
[    4.221167] ... PIC  IMR: fffb
[    4.221702] ... PIC  IRR: 1013
[    4.222263] ... PIC  ISR: 0000
[    4.222790] ... PIC ELCR: 0c00
[    4.223345] printing local APIC contents on CPU#0/0:
[    4.224185] ... APIC ID:      00000000 (0)
[    4.224329] ... APIC VERSION: 00050014
[    4.224329] ... APIC TASKPRI: 00000000 (00)
[    4.224329] ... APIC PROCPRI: 00000000
[    4.224329] ... APIC LDR: 01000000
[    4.224329] ... APIC DFR: ffffffff
[    4.224329] ... APIC SPIV: 000001ff
[    4.224329] ... APIC ISR field:
[    4.224329] 0000000000000000000000000000000000000000000000000000000000000000
[    4.224329] ... APIC TMR field:
[    4.224329] 0000000000000000000000000000000000000000000000000000000000000000
[    4.224329] ... APIC IRR field:
[    4.224329] 0000000000000000000000000000000000000000000000000000000020008000
[    4.224329] ... APIC ESR: 00000000
[    4.224329] ... APIC ICR: 00000841
[    4.224329] ... APIC ICR2: 01000000
[    4.224329] ... APIC LVTT: 000000ef
[    4.224329] ... APIC LVTPC: 00010000
[    4.224329] ... APIC LVT0: 00010700
[    4.224329] ... APIC LVT1: 00000400
[    4.224329] ... APIC LVTERR: 000000fe
[    4.224329] ... APIC TMICT: 0000a2d2
[    4.224329] ... APIC TMCCT: 00000000
[    4.224329] ... APIC TDCR: 00000003
[    4.224329] 
[    4.241632] number of MP IRQ sources: 20.
[    4.242350] number of IO-APIC #2 registers: 24.
[    4.243145] testing the IO APIC.......................
[    4.244064] IO APIC #2......
[    4.244565] .... register #00: 00000000
[    4.245234] .......    : physical APIC id: 00
[    4.245976] .......    : Delivery Type: 0
[    4.246686] .......    : LTS          : 0
[    4.247398] .... register #01: 00170011
[    4.248068] .......     : max redirection entries: 17
[    4.248936] .......     : PRQ implemented: 0
[    4.249687] .......     : IO APIC version: 11
[    4.250456] .... register #02: 00000000
[    4.251139] .......     : arbitration: 00
[    4.251841] .... IRQ redirection table:
[    4.252600]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    4.253557]  00 00  1    0    0   0   0    0    0    00
[    4.254494]  01 03  0    0    0   0   0    1    1    41
[    4.255445]  02 03  0    0    0   0   0    1    1    51
[    4.256380]  03 01  0    0    0   0   0    1    1    61
[    4.257321]  04 01  1    0    0   0   0    1    1    71
[    4.258269]  05 01  0    0    0   0   0    1    1    81
[    4.259201]  06 01  0    0    0   0   0    1    1    91
[    4.260156]  07 01  0    0    0   0   0    1    1    A1
[    4.261116]  08 01  0    0    0   0   0    1    1    B1
[    4.262064]  09 03  1    1    0   0   0    1    1    C1
[    4.263075]  0a 03  1    1    0   0   0    1    1    D1
[    4.263993]  0b 03  1    1    0   0   0    1    1    E1
[    4.264927]  0c 03  0    0    0   0   0    1    1    22
[    4.265864]  0d 01  0    0    0   0   0    1    1    42
[    4.266798]  0e 01  0    0    0   0   0    1    1    52
[    4.267738]  0f 01  0    0    0   0   0    1    1    62
[    4.268703]  10 00  1    0    0   0   0    0    0    00
[    4.269711]  11 00  1    0    0   0   0    0    0    00
[    4.270679]  12 00  1    0    0   0   0    0    0    00
[    4.271623]  13 00  1    0    0   0   0    0    0    00
[    4.272560]  14 00  1    0    0   0   0    0    0    00
[    4.273498]  15 00  1    0    0   0   0    0    0    00
[    4.274437]  16 00  1    0    0   0   0    0    0    00
[    4.275374]  17 00  1    0    0   0   0    0    0    00
[    4.276302] IRQ to pin mappings:
[    4.276861] IRQ0 -> 0:2
[    4.277369] IRQ1 -> 0:1
[    4.277846] IRQ3 -> 0:3
[    4.278368] IRQ4 -> 0:4
[    4.278840] IRQ5 -> 0:5
[    4.279341] IRQ6 -> 0:6
[    4.279806] IRQ7 -> 0:7
[    4.280307] IRQ8 -> 0:8
[    4.280772] IRQ12 -> 0:12
[    4.281299] IRQ13 -> 0:13
[    4.281794] IRQ14 -> 0:14
[    4.282323] IRQ15 -> 0:15
[    4.282818] IRQ33 -> 0:9
[    4.283330] IRQ34 -> 0:10
[    4.283821] IRQ35 -> 0:11
[    4.284346] .................................... done.
[    4.285272] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    4.285342] device: 'cpu_dma_latency': device_add
[    4.285428] PM: Adding info for No Bus:cpu_dma_latency
[    4.285464] device: 'network_latency': device_add
[    4.285544] PM: Adding info for No Bus:network_latency
[    4.285575] device: 'network_throughput': device_add
[    4.285639] PM: Adding info for No Bus:network_throughput
[    4.285682] PM: Hibernation image not present or could not be loaded.
[    4.285721] registered taskstats version 1
[    4.285723] Running tests on trace events:
[    4.285725] Testing event kfree_skb: [    4.294208] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    4.297195] device: 'input0': device_add
[    4.298042] PM: Adding info for No Bus:input0
[    4.298925] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.300637] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    4.300706] Testing event consume_skb: OK
[    4.302376] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    4.303686] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    4.305078] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    4.306670] atkbd: probe of serio1 rejects match -19
[    4.308159] OK
[    4.308516] Testing event skb_copy_datagram_iovec: OK
[    4.313332] Testing event net_dev_xmit: OK
[    4.318324] Testing event net_dev_queue: OK
[    4.323321] Testing event netif_receive_skb: OK
[    4.328338] Testing event netif_rx: OK
[    4.333307] Testing event napi_poll: OK
[    4.338312] Testing event sock_rcvqueue_full: OK
[    4.343327] Testing event sock_exceed_buf_limit: OK
[    4.348306] Testing event udp_fail_queue_rcv_skb: OK
[    4.353292] Testing event regmap_reg_write: OK
[    4.358307] Testing event regmap_reg_read: OK
[    4.363288] Testing event regmap_reg_read_cache: OK
[    4.368310] Testing event regmap_hw_read_start: OK
[    4.373288] Testing event regmap_hw_read_done: OK
[    4.378311] Testing event regmap_hw_write_start: OK
[    4.383292] Testing event regmap_hw_write_done: OK
[    4.388300] Testing event regcache_sync: OK
[    4.393289] Testing event regmap_cache_only: OK
[    4.398338] Testing event regmap_cache_bypass: OK
[    4.403288] Testing event mix_pool_bytes: OK
[    4.408307] Testing event mix_pool_bytes_nolock: OK
[    4.413289] Testing event credit_entropy_bits: OK
[    4.418306] Testing event get_random_bytes: OK
[    4.423309] Testing event extract_entropy: OK
[    4.428309] Testing event extract_entropy_user: OK
[    4.433289] Testing event regulator_enable: OK
[    4.438303] Testing event regulator_enable_delay: OK
[    4.443323] Testing event regulator_enable_complete: OK
[    4.448298] Testing event regulator_disable: OK
[    4.453291] Testing event regulator_disable_complete: OK
[    4.458307] Testing event regulator_set_voltage: OK
[    4.463288] Testing event regulator_set_voltage_complete: OK
[    4.468304] Testing event gpio_direction: OK
[    4.473295] Testing event gpio_value: OK
[    4.478304] Testing event block_rq_abort: OK
[    4.483238] Testing event block_rq_requeue: OK
[    4.488339] Testing event block_rq_complete: OK
[    4.493294] Testing event block_rq_insert: OK
[    4.498307] Testing event block_rq_issue: OK
[    4.503303] Testing event block_bio_bounce: OK
[    4.508298] Testing event block_bio_complete: OK
[    4.513292] Testing event block_bio_backmerge: OK
[    4.518301] Testing event block_bio_frontmerge: OK
[    4.523291] Testing event block_bio_queue: OK
[    4.528303] Testing event block_getrq: OK
[    4.533329] Testing event block_sleeprq: OK
[    4.538301] Testing event block_plug: OK
[    4.543289] Testing event block_unplug: OK
[    4.548309] Testing event block_split: OK
[    4.553295] Testing event block_bio_remap: OK
[    4.558301] Testing event block_rq_remap: OK
[    4.563298] Testing event writeback_nothread: OK
[    4.568301] Testing event writeback_queue: OK
[    4.573290] Testing event writeback_exec: OK
[    4.578330] Testing event writeback_start: OK
[    4.583291] Testing event writeback_written: OK
[    4.588303] Testing event writeback_wait: OK
[    4.593292] Testing event writeback_pages_written: OK
[    4.598237] Testing event writeback_nowork: OK
[    4.603288] Testing event writeback_wake_background: OK
[    4.608306] Testing event writeback_wake_thread: OK
[    4.613301] Testing event writeback_wake_forker_thread: OK
[    4.618306] Testing event writeback_bdi_register: OK
[    4.623290] Testing event writeback_bdi_unregister: OK
[    4.628303] Testing event writeback_thread_start: OK
[    4.633329] Testing event writeback_thread_stop: OK
[    4.638304] Testing event wbc_writepage: OK
[    4.643290] Testing event writeback_queue_io: OK
[    4.648306] Testing event global_dirty_state: OK
[    4.653237] Testing event bdi_dirty_ratelimit: OK
[    4.658295] Testing event balance_dirty_pages: OK
[    4.663256] Testing event writeback_sb_inodes_requeue: OK
[    4.668272] Testing event writeback_congestion_wait: OK
[    4.673256] Testing event writeback_wait_iff_congested: OK
[    4.678306] Testing event writeback_single_inode: OK
[    4.683271] Testing event mm_compaction_isolate_migratepages: OK
[    4.688266] Testing event mm_compaction_isolate_freepages: OK
[    4.693258] Testing event mm_compaction_migratepages: OK
[    4.698274] Testing event kmalloc: OK
[    4.703263] Testing event kmem_cache_alloc: OK
[    4.708277] Testing event kmalloc_node: OK
[    4.713254] Testing event kmem_cache_alloc_node: OK
[    4.718264] Testing event kfree: OK
[    4.722270] Testing event kmem_cache_free: OK
[    4.727261] Testing event mm_page_free: OK
[    4.732307] Testing event mm_page_free_batched: OK
[    4.737256] Testing event mm_page_alloc: OK
[    4.742272] Testing event mm_page_alloc_zone_locked: OK
[    4.747257] Testing event mm_page_pcpu_drain: OK
[    4.752254] Testing event mm_page_alloc_extfrag: OK
[    4.757256] Testing event mm_vmscan_kswapd_sleep: OK
[    4.762257] Testing event mm_vmscan_kswapd_wake: OK
[    4.767263] Testing event mm_vmscan_wakeup_kswapd: OK
[    4.772256] Testing event mm_vmscan_direct_reclaim_begin: OK
[    4.777293] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    4.782256] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    4.787260] Testing event mm_vmscan_direct_reclaim_end: OK
[    4.792254] Testing event mm_vmscan_memcg_reclaim_end: OK
[    4.797258] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    4.802258] Testing event mm_shrink_slab_start: OK
[    4.807254] Testing event mm_shrink_slab_end: OK
[    4.812267] Testing event mm_vmscan_lru_isolate: OK
[    4.817256] Testing event mm_vmscan_memcg_isolate: OK
[    4.822294] Testing event mm_vmscan_writepage: OK
[    4.827257] Testing event mm_vmscan_lru_shrink_inactive: OK
[    4.832255] Testing event oom_score_adj_update: OK
[    4.837272] Testing event rpm_suspend: OK
[    4.842266] Testing event rpm_resume: OK
[    4.847254] Testing event rpm_idle: OK
[    4.852275] Testing event rpm_return_int: OK
[    4.857259] Testing event cpu_idle: OK
[    4.862274] Testing event cpu_frequency: OK
[    4.867257] Testing event machine_suspend: OK
[    4.872277] Testing event wakeup_source_activate: OK
[    4.877254] Testing event wakeup_source_deactivate: OK
[    4.882258] Testing event clock_enable: OK
[    4.887259] Testing event clock_disable: OK
[    4.892270] Testing event clock_set_rate: OK
[    4.897258] Testing event power_domain_target: OK
[    4.902257] Testing event ftrace_test_filter: OK
[    4.907300] Testing event module_load: OK
[    4.912275] Testing event module_free: OK
[    4.917497] Testing event module_request: OK
[    4.923568] Testing event lock_acquire: OK
[    4.928486] Testing event lock_release: OK
[    4.933310] Testing event sched_kthread_stop: OK
[    4.938267] Testing event sched_kthread_stop_ret: OK
[    4.943258] Testing event sched_wakeup: OK
[    4.948373] Testing event sched_wakeup_new: OK
[    4.953258] Testing event sched_switch: OK
[    4.958273] Testing event sched_migrate_task: OK
[    4.963253] Testing event sched_process_free: OK
[    4.968266] Testing event sched_process_exit: OK
[    4.973265] Testing event sched_wait_task: OK
[    4.978267] Testing event sched_process_wait: OK
[    4.983255] Testing event sched_process_fork: OK
[    4.988270] Testing event sched_process_exec: OK
[    4.993294] Testing event sched_stat_wait: OK
[    4.998277] Testing event sched_stat_sleep: OK
[    5.003261] Testing event sched_stat_iowait: OK
[    5.008266] Testing event sched_stat_blocked: OK
[    5.013261] Testing event sched_stat_runtime: OK
[    5.018276] Testing event sched_pi_setprio: OK
[    5.023255] Testing event rcu_utilization: OK
[    5.028279] Testing event rcu_grace_period: OK
[    5.033260] Testing event rcu_grace_period_init: OK
[    5.038307] Testing event rcu_preempt_task: OK
[    5.043266] Testing event rcu_unlock_preempted_task: OK
[    5.048267] Testing event rcu_quiescent_state_report: OK
[    5.053265] Testing event rcu_fqs: OK
[    5.058272] Testing event rcu_dyntick: OK
[    5.063270] Testing event rcu_prep_idle: OK
[    5.068278] Testing event rcu_callback: OK
[    5.073260] Testing event rcu_kfree_callback: OK
[    5.078266] Testing event rcu_batch_start: OK
[    5.083292] Testing event rcu_invoke_callback: OK
[    5.088274] Testing event rcu_invoke_kfree_callback: OK
[    5.093259] Testing event rcu_batch_end: OK
[    5.098278] Testing event rcu_torture_read: OK
[    5.103267] Testing event rcu_barrier: OK
[    5.108276] Testing event workqueue_queue_work: OK
[    5.113252] Testing event workqueue_activate_work: OK
[    5.118272] Testing event workqueue_execute_start: OK
[    5.123257] Testing event workqueue_execute_end: OK
[    5.128281] Testing event signal_generate: OK
[    5.133256] Testing event signal_deliver: OK
[    5.138276] Testing event timer_init: OK
[    5.143260] Testing event timer_start: OK
[    5.148265] Testing event timer_expire_entry: OK
[    5.153257] Testing event timer_expire_exit: OK
[    5.158277] Testing event timer_cancel: OK
[    5.163264] Testing event hrtimer_init: OK
[    5.168277] Testing event hrtimer_start: OK
[    5.173309] Testing event hrtimer_expire_entry: OK
[    5.178271] Testing event hrtimer_expire_exit: OK
[    5.183301] Testing event hrtimer_cancel: OK
[    5.188284] Testing event itimer_state: OK
[    5.193257] Testing event itimer_expire: OK
[    5.198282] Testing event irq_handler_entry: OK
[    5.203257] Testing event irq_handler_exit: OK
[    5.208266] Testing event softirq_entry: OK
[    5.213257] Testing event softirq_exit: OK
[    5.218277] Testing event softirq_raise: OK
[    5.223259] Testing event console: OK
[    5.228311] Testing event task_newtask: OK
[    5.233255] Testing event task_rename: OK
[    5.238268] Testing event sys_enter: OK
[    5.243258] Testing event sys_exit: OK
[    5.248272] Testing event emulate_vsyscall: OK
[    5.253276] Running tests on trace event systems:
[    5.254168] Testing event system skb: OK
[    5.259478] Testing event system net: OK
[    5.264351] Testing event system napi: OK
[    5.269296] Testing event system sock: OK
[    5.274296] Testing event system udp: OK
[    5.279472] Testing event system regmap: OK
[    5.284388] Testing event system random: OK
[    5.289346] Testing event system regulator: OK
[    5.294352] Testing event system gpio: OK
[    5.299290] Testing event system block: OK
[    5.304487] Testing event system writeback: OK
[    5.309652] Testing event system compaction: 
--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--OgqxwSJOaUobr8KG--
