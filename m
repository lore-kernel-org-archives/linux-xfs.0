Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A70757F3F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 19:59:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 949F78F8035
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 17:59:19 -0700 (PDT)
Date: Thu, 10 Oct 2013 11:59:00 +1100
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010005900.GE2025@devil.localdomain>
References: <20131009073910.GA387@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131009073910.GA387@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[add xfs@oss.sgi.com to cc]

On Wed, Oct 09, 2013 at 03:39:10PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 98021821a502db347bd9c7671beeee6e8ce07ea6
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Mon Nov 12 22:54:03 2012 +1100
> 
>     xfs: verify superblocks as they are read from disk
>     
>     Add a superblock verify callback function and pass it into the
>     buffer read functions. Remove the now redundant verification code
>     that is currently in use.
>     
>     Adding verification shows that secondary superblocks never have
>     their "sb_inprogress" flag cleared by mkfs.xfs, so when validating
>     the secondary superblocks during a grow operation we have to avoid
>     checking this field. Even if we fix mkfs, we will still have to
>     ignore this field for verification purposes unless a version of mkfs
>     that does not have this bug was used.
>     
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>     Reviewed-by: Phil White <pwhite@sgi.com>
>     Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> It's an old commit, however the problem still remains in current
> upstream and linux-next.
> 
> [    4.607918] gfs2: error -5 reading superblock
> [    4.609575] block nbd7: Attempted send on closed socket
> [    4.611643] BUG: unable to handle kernel NULL pointer dereference at 00000003
> [    4.614242] IP: [<c10334dd>] move_linked_works+0x1d/0x50
> [    4.614724] *pdpt = 000000000cead001 *pde = 0000000000000000 
> [    4.614724] Oops: 0002 [#1] 
> [    4.614724] CPU: 0 PID: 662 Comm: kworker/0:1H Not tainted 3.12.0-rc1-00279-ga0c7d83 #138
> [    4.614724] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.614724] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.614724] EIP: 0060:[<c10334dd>] EFLAGS: 00010086 CPU: 0
> [    4.614724] EIP is at move_linked_works+0x1d/0x50
> [    4.614724] EAX: ccae5858 EBX: fffffffb ECX: 00000000 EDX: cc8b2eb8
> [    4.614724] ESI: 00000000 EDI: ffffffff EBP: ccf27f54 ESP: ccf27f44
> [    4.614724]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.614724] CR0: 8005003b CR2: 0000005c CR3: 0cc66000 CR4: 000006b0
> [    4.614724] Stack:
> [    4.614724]  ccae585c cc8b2ea0 c1a81d50 cc8b2eb8 ccf27f70 c1034d34 ccab0a20 c1a81d60
> [    4.614724]  cec55ed0 cc8b2ea0 c1034c02 ccf27fac c10388f7 ccf27f94 00000000 00000000
> [    4.614724]  cc8b2ea0 00000000 ccf27f8c ccf27f8c 00000000 ccf27f98 ccf27f98 ccab0a20
> [    4.614724] Call Trace:
> [    4.614724]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.614724]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.614724]  [<c10388f7>] kthread+0x6d/0x72
> [    4.614724]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.614724]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.614724] Code: 74 0a 8b 00 85 c0 75 ed eb 02 31 c0 5d c3 55 89 e5 57 56 53 53 8b 58 04 83 eb 04 89 c6 83 c6 04 89 75 f0 74 21 8b 78 04 8b 70 08 <89> 77 04 89 3e 8b 72 04 8b 7d f0 89 7a 04 89 50 04 89 70 08 89
> [    4.614724] EIP: [<c10334dd>] move_linked_works+0x1d/0x50 SS:ESP 0068:ccf27f44
> [    4.614724] CR2: 0000000000000003
> [    4.614724] ---[ end trace 346f0648092682e5 ]---
> 
> The bisect has been verified manually: disable CONFIG_XFS_FS and the
> problem disappears.
> 
> It's a kvm based boot test. As you may see in the attached dmesg log,
> there are some errors in the superblock reading and the other file
> systems complained, too.
> 
> git bisect start v3.8 v3.7 --
> git bisect  bad dadfab4873256d2145640c0ce468fcbfb48977fe  # 17:26      0-  Merge tag 'firewire-updates' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394
> git bisect  bad 2989950cea13711f0cc573c26cde8fe08a36be03  # 17:26      0-  Merge tag 'fixes-non-critical' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good 7bcb57cde66c19df378f3468ea342166a8a4504d  # 21:07  10000+  Merge tag 'iio-for-3.8f' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next
> git bisect good c6bd5bcc4983f1a2d2f87a3769bf309482ee8c04  # 04:35  10000+  Merge tag 'tty-3.8-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect good 090f8ccba37034cec5a5972a70abeaae7eb0222b  # 11:09  10000+  Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good fef3ff2eb777e76cfa5ae67591982d902c17139c  # 17:17  10000+    658  Merge branch 'for-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
> git bisect  bad 3f1c64f410e4394ecefadd7a597a7c20368a65fc  # 17:18      0-    307  Merge tag 'for-linus-v3.8-rc1' of git://oss.sgi.com/xfs/xfs
> git bisect  bad ef9d873344ff9f5084eacb9f3735982314dfda9e  # 17:18      0-    148  xfs: byte range granularity for XFS_IOC_ZERO_RANGE
> git bisect good 07428d7f0ca46087f7f1efa895322bb9dc1ac21d  # 19:00   1325+    179  xfs: fix attr tree double split corruption
> git bisect  bad 3d3e6f64e22c94115d47de670611bcd3ecda3796  # 19:00      0-   1198  xfs: verify btree blocks as they are read from disk
> git bisect good 95eacf0f71b7682a05b8242c49c68e8e4bb673e3  # 20:33   1000+     81  xfs: remove xfs_wait_on_pages()
> git bisect  bad 98021821a502db347bd9c7671beeee6e8ce07ea6  # 20:33      0-   2443  xfs: verify superblocks as they are read from disk
> git bisect good fb59581404ab7ec5075299065c22cb211a9262a9  # 21:56   1000+     22  xfs: remove xfs_flushinval_pages
> git bisect good eab4e63368b4cfa597dbdac66d1a7a836a693b7d  # 01:12   1000+     35  xfs: uncached buffer reads need to return an error
> git bisect good eab4e63368b4cfa597dbdac66d1a7a836a693b7d  # 04:48   3000+    184  xfs: uncached buffer reads need to return an error
> git bisect  bad a0c7d83322521880caf8c9c1ef20a2a1cd5cb955  # 04:49      0-     23  can: sja1000: remove unnecessary pci_set_drvdata()
> git bisect  bad fd848319e751739a93aa9fc8182e57e87c5a0df1  # 04:53      1-      9  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
> git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 04:57      0-     13  Add linux-next specific files for 20130927
> 
> Thanks,
> Fengguang

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.12.0-rc1-00279-ga0c7d83 (kbuild@cairo) (gcc version 4.8.1 (Debian 4.8.1-8) ) #138 Sat Sep 21 22:44:02 CST 2013
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [c00fdae0]
> [    0.000000]   mpc: fdaf0-fdbec
> [    0.000000] initial memory mapped: [mem 0x00000000-0x021fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
> [    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
> [    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
> [    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
> [    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
> [    0.000000] BRK [0x01c36000, 0x01c36fff] PGTABLE
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 127992(97%)
> [    0.000000] RAMDISK: [mem 0x0fce4000-0x0ffeffff]
> [    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0fffff40 00040
> [    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] 255MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 0fffe000
> [    0.000000]   low ram: 0 - 0fffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
> [    0.000000] On node 0 totalpages: 65436
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 480 pages used for memmap
> [    0.000000]   Normal zone: 61438 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] Using ACPI for processor (LAPIC) configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] Intel MultiProcessor Specification v1.4
> [    0.000000]     Virtual Wire compatibility mode.
> [    0.000000]   mpc: fdaf0-fdbec
> [    0.000000] MPTABLE: OEM ID: BOCHSCPU
> [    0.000000] MPTABLE: Product ID: 0.1         
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> [    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
> [    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
> [    0.000000] Processors: 1
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1a7f9c0
> [    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64924
> [    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-c4-0920/can:for-davem/.vmlinuz-a0c7d83322521880caf8c9c1ef20a2a1cd5cb955-20130921224411-2-lkp-tt02 branch=can/for-davem BOOT_IMAGE=/kernel/i386-randconfig-c4-0920/a0c7d83322521880caf8c9c1ef20a2a1cd5cb955/vmlinuz-3.12.0-rc1-00279-ga0c7d83
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Memory: 233488K/261744K available (7553K kernel code, 639K rwdata, 3120K rodata, 544K init, 568K bss, 28256K reserved)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
> [    0.000000]     vmalloc : 0xd07fe000 - 0xfffdf000   ( 759 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
> [    0.000000]       .init : 0xc1b0e000 - 0xc1b96000   ( 544 kB)
> [    0.000000]       .data : 0xc176089c - 0xc1b0dc80   (3764 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc176089c   (7554 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] CPU 0 irqstacks, hard=cec08000 soft=cec0a000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2393.914 MHz processor
> [    0.006666] Calibrating delay loop (skipped) preset value.. 4789.32 BogoMIPS (lpj=7979713)
> [    0.008187] pid_max: default: 32768 minimum: 301
> [    0.010052] Security Framework initialized
> [    0.011528] SELinux:  Initializing.
> [    0.013346] SELinux:  Starting in enforcing mode
> [    0.014973] Mount-cache hash table entries: 512
> [    0.016958] Initializing cgroup subsys debug
> [    0.018507] Initializing cgroup subsys devices
> [    0.020006] Initializing cgroup subsys freezer
> [    0.021603] Initializing cgroup subsys net_cls
> [    0.023468] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.023468] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.023468] tlb_flushall_shift: 6
> [    0.026672] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.035926] ACPI: Core revision 20130725
> [    0.037632] ACPI: All ACPI Tables successfully acquired
> [    0.040013] ACPI: setting ELCR to 0200 (from 0c00)
> [    0.041891] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.045929] Getting VERSION: 50014
> [    0.046681] Getting VERSION: 50014
> [    0.047998] Getting ID: 0
> [    0.049118] Getting ID: f000000
> [    0.050017] Getting LVT0: 8700
> [    0.051242] Getting LVT1: 8400
> [    0.053449] enabled ExtINT on CPU#0
> [    0.054845] Using local APIC timer interrupts.
> [    0.054845] calibrating APIC timer ...
> [    0.059999] ... lapic delta = 6249972
> [    0.059999] ... PM-Timer delta = 357951
> [    0.059999] ... PM-Timer result ok
> [    0.059999] ..... delta 6249972
> [    0.059999] ..... mult: 268434280
> [    0.059999] ..... calibration result: 3333318
> [    0.059999] ..... CPU clock speed is 2394.0422 MHz.
> [    0.059999] ..... host bus clock speed is 1000.0318 MHz.
> [    0.060310] devtmpfs: initialized
> [    0.062437] EVM: security.selinux
> [    0.063336] EVM: security.SMACK64
> [    0.064611] EVM: security.capability
> [    0.067018] atomic64 test passed for i586+ platform with CX8 and with SSE
> [    0.069199] regulator-dummy: no parameters
> [    0.070055] NET: Registered protocol family 16
> [    0.072434] EISA bus registered
> [    0.073336] cpuidle: using governor ladder
> [    0.074798] cpuidle: using governor menu
> [    0.077328] ACPI: bus type PCI registered
> [    0.079023] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
> [    0.080005] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=0
> [    0.083335] PCI: Using configuration type 1 for base access
> [    0.089646] bio: create slab <bio-0> at 0
> [    0.090211] ACPI: Added _OSI(Module Device)
> [    0.091689] ACPI: Added _OSI(Processor Device)
> [    0.093336] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.094959] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.097339] ACPI: EC: Look up EC in DSDT
> [    0.101724] ACPI: Interpreter enabled
> [    0.103117] ACPI: (supports S0 S5)
> [    0.103336] ACPI: Using PIC for interrupt routing
> [    0.104988] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.112980] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.113342] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    0.116816] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    0.120044] PCI host bridge to bus 0000:00
> [    0.121528] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.123343] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.126670] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.128651] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.130003] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    0.132205] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    0.133894] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    0.137508] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    0.142901] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
> [    0.144674] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    0.147320] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    0.150018] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    0.153672] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    0.157344] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    0.161311] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
> [    0.169104] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
> [    0.170362] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
> [    0.174500] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
> [    0.177735] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
> [    0.184851] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
> [    0.187067] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
> [    0.190526] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
> [    0.193338] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
> [    0.200531] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
> [    0.202849] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
> [    0.203914] pci 0000:00:05.0: reg 0x10: [mem 0xfebe2000-0xfebe200f]
> [    0.211335] pci_bus 0000:00: on NUMA node 0
> [    0.213477] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.216212] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.218131] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.221458] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.224086] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    0.227090] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    0.229038] ACPI: \_SB_.PCI0: notify handler is installed
> [    0.230024] Found 1 acpi root devices
> [    0.231766] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.233336] vgaarb: loaded
> [    0.234448] vgaarb: bridge control possible 0000:00:02.0
> [    0.236976] SCSI subsystem initialized
> [    0.240030] libata version 3.00 loaded.
> [    0.241441] ACPI: bus type USB registered
> [    0.242884] usbcore: registered new interface driver usbfs
> [    0.243352] usbcore: registered new interface driver hub
> [    0.245130] usbcore: registered new device driver usb
> [    0.246770] Linux video capture interface: v2.00
> [    0.248376] pps_core: LinuxPPS API ver. 1 registered
> [    0.250002] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.253345] PTP clock support registered
> [    0.254791] EDAC MC: Ver: 3.0.0
> [    0.256985] PCI: Using ACPI for IRQ routing
> [    0.258480] PCI: pci_cache_line_size set to 64 bytes
> [    0.260237] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.262156] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
> [    0.263491] NetLabel: Initializing
> [    0.264784] NetLabel:  domain hash size = 128
> [    0.266668] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.268368] NetLabel:  unlabeled traffic allowed by default
> [    0.270054] nfc: nfc_init: NFC Core ver 0.1
> [    0.271547] NET: Registered protocol family 39
> [    0.274091] Switched to clocksource kvm-clock
> [    0.274907] FS-Cache: Loaded
> [    0.276130] CacheFiles: Loaded
> [    0.277344] pnp: PnP ACPI init
> [    0.278565] ACPI: bus type PNP registered
> [    0.280072] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.282157] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.284245] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    0.286347] pnp 00:03: [dma 2]
> [    0.287577] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.289710] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.291815] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.294047] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.296252] pnp: PnP ACPI: found 7 devices
> [    0.297696] ACPI: bus type PNP unregistered
> [    0.762921] mdacon: MDA with 8K of memory detected.
> [    0.762961] Console: switching consoles 13-16 to MDA-2
> [    0.801328] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.803218] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.805060] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.807067] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    0.809157] NET: Registered protocol family 2
> [    0.810835] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.813083] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.815108] TCP: Hash tables configured (established 2048 bind 2048)
> [    0.817148] TCP: reno registered
> [    0.818404] UDP hash table entries: 256 (order: 0, 4096 bytes)
> [    0.820315] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
> [    0.822385] NET: Registered protocol family 1
> [    0.823995] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    0.825993] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    0.827888] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    0.830009] pci 0000:00:02.0: Boot video device
> [    0.831709] PCI: CLS 0 bytes, default 64
> [    0.833268] Trying to unpack rootfs image as initramfs...
> [    0.941148] Freeing initrd memory: 3120K (cfce4000 - cfff0000)
> [    0.952791] DMA-API: preallocated 65536 debug entries
> [    0.954611] DMA-API: debugging enabled by kernel config
> [    0.957381] PCLMULQDQ-NI instructions are not detected.
> [    0.959194] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
> [    0.962462] audit: initializing netlink socket (disabled)
> [    0.964291] type=2000 audit(1379740295.691:1): initialized
> [    0.968524] zbud: loaded
> [    0.969698] VFS: Disk quotas dquot_6.5.2
> [    0.971196] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.973584] DLM installed
> [    0.975168] fuse init (API version 7.22)
> [    0.976770] JFS: nTxBlock = 1848, nTxLock = 14788
> [    0.980227] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
> [    0.983831] OCFS2 1.5.0
> [    0.985080] ocfs2: Registered cluster interface o2cb
> [    0.986880] ocfs2: Registered cluster interface user
> [    0.988648] OCFS2 DLMFS 1.5.0
> [    0.989958] OCFS2 User DLM kernel interface loaded
> [    0.991661] OCFS2 Node Manager 1.5.0
> [    0.993165] OCFS2 DLM 1.5.0
> [    0.994860] GFS2 installed
> [    0.996068] msgmni has been set to 462
> [    0.999093] Key type asymmetric registered
> [    1.000650] Asymmetric key parser 'x509' registered
> [    1.002437] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
> [    1.005090] io scheduler noop registered
> [    1.006551] io scheduler cfq registered (default)
> [    1.008199] test_string_helpers: Running tests...
> [    1.010109] Console: switching consoles 13-16 to MDA-2
> [    1.012025] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    1.014626] ACPI: Power Button [PWRF]
> [    1.016312] r3964: Philips r3964 Driver $Revision: 1.10 $
> [    1.018170] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    1.044473] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    1.047514] STMicroelectronics ASC driver initialized
> [    1.049297] serial: Freescale lpuart driver
> [    1.050910] DoubleTalk PC - not found
> [    1.052350] Non-volatile memory driver v1.3
> [    1.053843] toshiba: not a supported Toshiba laptop
> [    1.055546] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
> [    1.068125] platform pc8736x_gpio.0: no device found
> [    1.069844] nsc_gpio initializing
> [    1.071150] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    1.072862] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    1.075867] Hangcheck: Using getrawmonotonic().
> [    1.077573] parport_pc 00:04: reported by Plug and Play ACPI
> [    1.079546] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
> [    1.082654] Floppy drive(s): fd0 is 1.44M
> [    1.085270] brd: module loaded
> [    1.086927] loop: module loaded
> [    1.088296] nbd: registered device at major 43
> [    1.090909] rbd: loaded rbd (rados block device)
> [    1.092572] dummy-irq: no IRQ given.  Use irq=N
> [    1.094168] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    1.096849] usbcore: registered new interface driver viperboard
> [    1.098849] Uniform Multi-Platform E-IDE driver
> [    1.101216] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    1.104467] ide-gd driver 1.18
> [    1.105716] ide-cd driver 5.00
> [    1.107086] Loading iSCSI transport class v2.0-870.
> [    1.109434] FDC 0 is a S82078B
> [    1.111058] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    1.113134] SCSI Media Changer driver v0.25 
> [    1.228164] parport0: AVR Butterfly
> [    1.229583] parport0: cannot grant exclusive access for device spi-lm70llp
> [    1.231740] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    1.233643] HSI/SSI char device loaded
> [    1.235057] slcan: serial line CAN interface driver
> [    1.236711] slcan: 10 dynamic interface channels.
> [    1.238350] CAN device driver interface
> [    1.239767] usbcore: registered new interface driver ems_usb
> [    1.241630] usbcore: registered new interface driver kvaser_usb
> [    1.243564] usbcore: registered new interface driver peak_usb
> [    1.245462] usbcore: registered new interface driver usb_8dev
> [    1.247355] parport0: cannot grant exclusive access for device ks0108
> [    1.249422] ks0108: ERROR: parport didn't register new device
> [    1.251459] aoe: cannot create debugfs directory
> [    1.253096] aoe: AoE v85 initialised.
> [    1.254515] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.256619] ehci-pci: EHCI PCI platform driver
> [    1.258209] ehci-platform: EHCI generic platform driver
> [    1.259965] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.261950] ohci-pci: OHCI PCI platform driver
> [    1.263522] ohci-platform: OHCI generic platform driver
> [    1.265325] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
> [    1.267269] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
> [    1.270299] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
> [    1.272223] 
> [    1.275240] usbcore: registered new interface driver cdc_acm
> [    1.277094] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> [    1.279862] usbcore: registered new interface driver usblp
> [    1.281696] usbcore: registered new interface driver cdc_wdm
> [    1.283556] usbcore: registered new interface driver usbtmc
> [    1.285406] usbcore: registered new interface driver mdc800
> [    1.287236] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
> [    1.289951] usbcore: registered new interface driver appledisplay
> [    1.291947] usbcore: registered new interface driver cypress_cy7c63
> [    1.293963] usbcore: registered new interface driver cytherm
> [    1.295843] usbcore: registered new interface driver emi26 - firmware loader
> [    1.298055] usbcore: registered new interface driver emi62 - firmware loader
> [    1.300251] usbcore: registered new interface driver idmouse
> [    1.302136] usbcore: registered new interface driver isight_firmware
> [    1.304188] usbcore: registered new interface driver usblcd
> [    1.306083] usbcore: registered new interface driver ldusb
> [    1.307905] usbcore: registered new interface driver usbled
> [    1.309812] usbcore: registered new interface driver legousbtower
> [    1.311824] usbcore: registered new interface driver rio500
> [    1.313676] usbcore: registered new interface driver usb_ehset_test
> [    1.315711] usbcore: registered new interface driver trancevibrator
> [    1.317718] usbcore: registered new interface driver uss720
> [    1.319581] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
> [    1.322671] uss720: NOTE: this is a special purpose driver to allow nonstandard
> [    1.325259] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
> [    1.327808] uss720: If you just want to connect to a printer, use usblp instead
> [    1.330457] usbcore: registered new interface driver usbsevseg
> [    1.332367] usbcore: registered new interface driver yurex
> [    1.334178] usbcore: registered new interface driver sisusb
> [    1.336160] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
> [    1.338722] dummy_hcd dummy_hcd.0: Dummy host controller
> [    1.340515] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
> [    1.343176] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.345307] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.347843] usb usb1: Product: Dummy host controller
> [    1.349564] usb usb1: Manufacturer: Linux 3.12.0-rc1-00279-ga0c7d83 dummy_hcd
> [    1.351787] usb usb1: SerialNumber: dummy_hcd.0
> [    1.353471] hub 1-0:1.0: USB hub found
> [    1.354871] hub 1-0:1.0: 1 port detected
> [    1.356484] using random self ethernet address
> [    1.358058] using random host ethernet address
> [    1.359707] usb0: HOST MAC de:35:a9:0d:21:7f
> [    1.361244] usb0: MAC da:b4:df:c7:47:e4
> [    1.362706] g_ncm gadget: NCM Gadget
> [    1.364078] g_ncm gadget: g_ncm ready
> [    1.365508] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    1.369160] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.370826] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.372703] mousedev: PS/2 mouse device common for all mice
> [    1.374533] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
> [    1.377441] usbcore: registered new interface driver usb_acecad
> [    1.379388] usbcore: registered new interface driver aiptek
> [    1.381209] usbcore: registered new interface driver gtco
> [    1.383024] usbcore: registered new interface driver hanwang
> [    1.384868] usbcore: registered new interface driver kbtab
> [    1.386709] usbcore: registered new interface driver i2c-diolan-u2c
> [    1.388717] i2c-parport-light: adapter type unspecified
> [    1.390497] usbcore: registered new interface driver i2c-tiny-usb
> [    1.392554] isa i2c-pca-isa.0: Please specify I/O base
> [    1.395062] pps_ldisc: PPS line discipline registered
> [    1.396799] pps_parport: parallel port PPS client
> [    1.398455] parport0: cannot grant exclusive access for device pps_parport
> [    1.400594] pps_parport: couldn't register with parport0
> [    1.402404] Driver for 1-wire Dallas network protocol.
> [    1.404152] usbcore: registered new interface driver DS9490R
> [    1.406006] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
> [    1.409256] applesmc: supported laptop not found!
> [    1.410866] applesmc: driver init failed (ret=-19)!
> [    1.413399] mixcomwd: No card detected, or port not available
> [    1.415312] acquirewdt: WDT driver for Acquire single board computer initialising
> [    1.418062] acquirewdt: I/O address 0x0043 already in use
> [    1.419846] acquirewdt: probe of acquirewdt failed with error -5
> [    1.422336] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    1.425249] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
> [    1.428509] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=1)
> [    1.431186] ib700wdt: WDT driver for IB700 single board computer initialising
> [    1.433455] ib700wdt: failed to register misc device
> [    1.435150] ib700wdt: probe of ib700wdt failed with error -16
> [    1.437151] it87_wdt: no device
> [    1.438386] sc1200wdt: build 20020303
> [    1.439750] sc1200wdt: io parameter must be specified
> [    1.441475] pc87413_wdt: Version 1.1 at io 0x2E
> [    1.443051] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
> [    1.445152] sbc8360: failed to register misc device
> [    1.446796] sbc7240_wdt: timeout set to 30 seconds
> [    1.448446] sbc7240_wdt: cannot register miscdev on minor=130 (err=-16)
> [    1.450530] cpu5wdt: misc_register failed
> [    1.452002] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
> [    1.454966] w83697ug_wdt: No W83697UG/UF could be found
> [    1.456720] w83877f_wdt: cannot register miscdev on minor=130 (err=-16)
> [    1.458821] w83977f_wdt: driver v1.00
> [    1.460198] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
> [    1.462297] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
> [    1.464393] platform eisa.0: Probing EISA bus 0
> [    1.466331] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    1.469034] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.471159] usbcore: registered new interface driver usbhid
> [    1.473080] usbhid: USB HID core driver
> [    1.474576] usbip_core: usbip_core_init:805: USB/IP Core v1.0.0
> [    1.476624] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
> [    1.478545] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
> [    1.480506] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 2
> [    1.482729] vhci_hcd: vhci_start:884: enter vhci_start
> [    1.484588] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.486787] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.489391] usb usb2: Product: USB/IP Virtual Host Controller
> [    1.491307] usb usb2: Manufacturer: Linux 3.12.0-rc1-00279-ga0c7d83 vhci_hcd
> [    1.493582] usb usb2: SerialNumber: vhci_hcd
> [    1.505825] hub 2-0:1.0: USB hub found
> [    1.507336] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
> [    1.509595] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
> [    1.511531] vhci_hcd: vhci_hub_control:398: port -1
> [    1.513245] vhci_hcd: vhci_hub_control:405:  bye
> [    1.514864] hub 2-0:1.0: 8 ports detected
> [    1.516356] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
> [    1.518529] vhci_hcd: vhci_hub_control:309:  GetHubStatus
> [    1.520334] vhci_hcd: vhci_hub_control:398: port -1
> [    1.522039] vhci_hcd: vhci_hub_control:405:  bye
> [    1.523770] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
> [    1.525954] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.528066] vhci_hcd: vhci_hub_control:398: port 0
> [    1.529706] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.532556] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.534381] vhci_hcd: dump_port_status_diff:119: 
> [    1.536055] vhci_hcd: vhci_hub_control:405:  bye
> [    1.537663] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
> [    1.539864] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.541956] vhci_hcd: vhci_hub_control:398: port 1
> [    1.543651] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.546535] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.548333] vhci_hcd: dump_port_status_diff:119: 
> [    1.550019] vhci_hcd: vhci_hub_control:405:  bye
> [    1.551666] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
> [    1.553847] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.555951] vhci_hcd: vhci_hub_control:398: port 2
> [    1.557660] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.560570] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.562363] vhci_hcd: dump_port_status_diff:119: 
> [    1.564040] vhci_hcd: vhci_hub_control:405:  bye
> [    1.565672] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
> [    1.567877] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.570060] vhci_hcd: vhci_hub_control:398: port 3
> [    1.571731] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.574614] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.576481] vhci_hcd: dump_port_status_diff:119: 
> [    1.578178] vhci_hcd: vhci_hub_control:405:  bye
> [    1.579819] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
> [    1.582044] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.584116] vhci_hcd: vhci_hub_control:398: port 4
> [    1.585785] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.588635] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.590452] vhci_hcd: dump_port_status_diff:119: 
> [    1.592130] vhci_hcd: vhci_hub_control:405:  bye
> [    1.593785] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
> [    1.595993] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.598091] vhci_hcd: vhci_hub_control:398: port 5
> [    1.599732] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.602581] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.604408] vhci_hcd: dump_port_status_diff:119: 
> [    1.606106] vhci_hcd: vhci_hub_control:405:  bye
> [    1.607722] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
> [    1.609954] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.612092] vhci_hcd: vhci_hub_control:398: port 6
> [    1.613735] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.616621] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.618425] vhci_hcd: dump_port_status_diff:119: 
> [    1.620095] vhci_hcd: vhci_hub_control:405:  bye
> [    1.621729] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
> [    1.623938] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [    1.626087] vhci_hcd: vhci_hub_control:398: port 7
> [    1.627729] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [    1.630668] vhci_hcd: dump_port_status_diff:115:  +POWER
> [    1.632473] vhci_hcd: dump_port_status_diff:119: 
> [    1.634117] vhci_hcd: vhci_hub_control:405:  bye
> [    1.635820] vhci_hcd: vhci_hcd_probe:1034: bye
> [    1.637426] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
> [    1.698071] usb 1-1: new high-speed USB device number 2 using dummy_hcd
> [    1.734731] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
> [    1.737018] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
> [    1.739004] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.741069] vhci_hcd: vhci_hub_control:398: port 0
> [    1.742740] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.745567] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.747343] vhci_hcd: dump_port_status_diff:119: 
> [    1.748990] vhci_hcd: vhci_hub_control:405:  bye
> [    1.750591] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
> [    1.752764] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
> [    1.754725] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.756779] vhci_hcd: vhci_hub_control:398: port 1
> [    1.758528] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.761607] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.763585] vhci_hcd: dump_port_status_diff:119: 
> [    1.765511] vhci_hcd: vhci_hub_control:405:  bye
> [    1.767421] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
> [    1.769885] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
> [    1.772018] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.774087] vhci_hcd: vhci_hub_control:398: port 2
> [    1.775775] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.778607] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.780381] vhci_hcd: dump_port_status_diff:119: 
> [    1.782031] vhci_hcd: vhci_hub_control:405:  bye
> [    1.783656] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
> [    1.785850] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
> [    1.787830] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.789905] vhci_hcd: vhci_hub_control:398: port 3
> [    1.791584] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.794396] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.796222] vhci_hcd: dump_port_status_diff:119: 
> [    1.797834] vhci_hcd: vhci_hub_control:405:  bye
> [    1.799518] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
> [    1.801715] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
> [    1.803685] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.805721] vhci_hcd: vhci_hub_control:398: port 4
> [    1.807366] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.810215] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.812019] vhci_hcd: dump_port_status_diff:119: 
> [    1.813624] vhci_hcd: vhci_hub_control:405:  bye
> [    1.815274] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
> [    1.817446] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
> [    1.819426] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.821512] vhci_hcd: vhci_hub_control:398: port 5
> [    1.823172] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.826024] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.827792] vhci_hcd: dump_port_status_diff:119: 
> [    1.829482] vhci_hcd: vhci_hub_control:405:  bye
> [    1.831098] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
> [    1.833295] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
> [    1.835286] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.837309] vhci_hcd: vhci_hub_control:398: port 6
> [    1.838947] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.841788] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.843565] vhci_hcd: dump_port_status_diff:119: 
> [    1.845203] vhci_hcd: vhci_hub_control:405:  bye
> [    1.846805] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
> [    1.849021] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
> [    1.851051] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [    1.853112] vhci_hcd: vhci_hub_control:398: port 7
> [    1.854789] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [    1.857657] vhci_hcd: dump_port_status_diff:115:   POWER
> [    1.859526] vhci_hcd: dump_port_status_diff:119: 
> [    1.861199] vhci_hcd: vhci_hub_control:405:  bye
> [    1.904704] usb 1-1: New USB device found, idVendor=0525, idProduct=a4a1
> [    1.906870] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.909134] usb 1-1: Product: NCM Gadget
> [    1.910548] usb 1-1: Manufacturer: Linux 3.12.0-rc1-00279-ga0c7d83 with dummy_udc
> [    1.914697] g_ncm gadget: high-speed config #1: CDC Ethernet (NCM)
> [    1.921393] usbip-host 1-1:1.0: Enter
> [    1.922765] usbip-host 1-1:1.0: 1-1 is not in match_busid table... skip!
> [    1.928050] usbip-host 1-1:1.1: Enter
> [    1.929421] usbip-host 1-1:1.1: 1-1 is not in match_busid table... skip!
> [    1.931596] usbip-host 1-1:1.0: Enter
> [    1.932958] usbip-host 1-1:1.0: 1-1 is not in match_busid table... skip!
> [    1.935102] usbip-host 1-1:1.1: Enter
> [    1.936478] usbip-host 1-1:1.1: 1-1 is not in match_busid table... skip!
> [    1.938613] usbcore: registered new interface driver usbip-host
> [    1.940535] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
> [    1.942610] panel: could not claim access to parport0. Aborting.
> [    1.944548] panel: driver version 0.9.5 not yet registered
> [    1.946411] usbcore: registered new interface driver rts5139
> [    1.948279] usbcore: registered new interface driver tranzport
> [    1.950179] usbcore: registered new interface driver alphatrack
> [    1.952468] usb usb2: vhci_bus_suspend
> [    1.953853] vhci_hcd: vhci_hub_status:208: changed 0
> [    1.955596] zram: Created 1 device(s) ...
> [    1.957061] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
> [    1.959081] Copyright 2010. Beceem Communications Inc
> [    1.960791] usbcore: registered new interface driver usbbcm
> [    1.962702] logger: created 256K log 'log_main'
> [    1.964330] logger: created 256K log 'log_events'
> [    1.966035] logger: created 256K log 'log_radio'
> [    1.978129] logger: created 256K log 'log_system'
> [    1.979796] usbcore: registered new interface driver gdm_wimax
> [    1.981721] usbcore: registered new interface driver cedusb
> [    1.983623] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
> [    1.985916] dgap: For the tools package or updated drivers please visit http://www.digi.com
> [    1.989409]  fake-fmc-carrier: mezzanine 0
> [    1.990875]       Manufacturer: fake-vendor
> [    1.992408]       Product name: fake-design-for-testing
> [    1.994196] fmc fake-design-for-testing-f001: Driver has no ID: matches all
> [    1.996420] fmc_trivial: probe of fake-design-for-testing-f001 failed with error -95
> [    1.999158] fmc fake-design-for-testing-f001: Driver has no ID: matches all
> [    2.001383] tsc: Refined TSC clocksource calibration: 2393.911 MHz
> [    2.003396] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
> [    2.006591] pktgen: Packet Generator for packet performance testing. Version: 2.74
> [    2.009338] NET: Registered protocol family 26
> [    2.010898] netem: version 1.3
> [    2.012218] ipip: IPv4 over IPv4 tunneling driver
> [    2.013947] gre: GRE over IPv4 demultiplexor driver
> [    2.015643] ip_gre: GRE over IPv4 tunneling driver
> [    2.017461] TCP: cubic registered
> [    2.018749] Initializing XFRM netlink socket
> [    2.020448] NET: Registered protocol family 10
> [    2.022278] mip6: Mobile IPv6
> [    2.023468] sit: IPv6 over IPv4 tunneling driver
> [    2.025297] ip6_gre: GRE over IPv6 tunneling driver
> [    2.027078] NET: Registered protocol family 17
> [    2.028663] NET: Registered protocol family 4
> [    2.030222] NET: Registered protocol family 5
> [    2.031773] can: controller area network core (rev 20120528 abi 9)
> [    2.033777] NET: Registered protocol family 29
> [    2.035352] can: raw protocol (rev 20120528)
> [    2.036861] can: broadcast manager protocol (rev 20120528 t)
> [    2.038741] can: netlink gateway (rev 20130117) max_hops=1
> [    2.040614] NET: Registered protocol family 33
> [    2.042206] Key type rxrpc registered
> [    2.043575] Key type rxrpc_s registered
> [    2.045043] l2tp_core: L2TP core driver, V2.0
> [    2.046613] NET: Registered protocol family 35
> [    2.048416] DCCP: Activated CCID 2 (TCP-like)
> [    2.050279] sctp: Hash tables configured (established 8192 bind 16384)
> [    2.052578] NET: Registered protocol family 21
> [    2.054218] Registered RDS/tcp transport
> [    2.055776] 9pnet: Installing 9P2000 support
> [    2.057376] Key type dns_resolver registered
> [    2.058922] Key type ceph registered
> [    2.060368] libceph: loaded (mon/osd proto 15/24)
> [    2.062105] batman_adv: B.A.T.M.A.N. advanced 2013.4.0 (compatibility version 14) loaded
> [    2.065633] Using IPI Shortcut mode
> [    2.067108] registered taskstats version 1
> [    2.068702] Key type trusted registered
> [    2.070189] Key type encrypted registered
> [    2.071699] IMA: No TPM chip found, activating TPM-bypass!
> [    2.073880] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
> [    2.076705] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    2.078706] EDD information not available.
> [    2.080947] Freeing unused kernel memory: 544K (c1b0e000 - c1b96000)
> [    2.083282] Write protecting the kernel text: 7556k
> [    2.085115] Write protecting the kernel read-only data: 3124k
> [    2.087032] NX-protecting the kernel data: 4732k
> [    3.593313] block nbd15: Attempted send on closed socket
> [    3.595253] end_request: I/O error, dev nbd15, sector 2
> [    3.597039] EXT3-fs (nbd15): error: unable to read superblock
> [    3.600292] block nbd3: Attempted send on closed socket
> [    3.602118] end_request: I/O error, dev nbd3, sector 2
> [    3.603865] EXT3-fs (nbd3): error: unable to read superblock
> [    3.613249] block nbd6: Attempted send on closed socket
> [    3.615081] end_request: I/O error, dev nbd6, sector 2
> [    3.616835] EXT3-fs (nbd6): error: unable to read superblock
> [    3.626378] EXT3-fs (zram0): error: unable to read superblock
> [    3.630270] block nbd4: Attempted send on closed socket
> [    3.632088] end_request: I/O error, dev nbd4, sector 2
> [    3.633838] EXT3-fs (nbd4): error: unable to read superblock
> [    3.640137] block nbd0: Attempted send on closed socket
> [    3.642005] end_request: I/O error, dev nbd0, sector 2
> [    3.643749] EXT3-fs (nbd0): error: unable to read superblock
> [    3.650162] block nbd9: Attempted send on closed socket
> [    3.652003] end_request: I/O error, dev nbd9, sector 2
> [    3.653754] EXT3-fs (nbd9): error: unable to read superblock
> [    3.657875] block nbd7: Attempted send on closed socket
> [    3.659718] end_request: I/O error, dev nbd7, sector 2
> [    3.661494] EXT3-fs (nbd7): error: unable to read superblock
> [    3.665558] block nbd5: Attempted send on closed socket
> [    3.667350] end_request: I/O error, dev nbd5, sector 2
> [    3.669107] EXT3-fs (nbd5): error: unable to read superblock
> [    3.672915] block nbd2: Attempted send on closed socket
> [    3.674736] end_request: I/O error, dev nbd2, sector 2
> [    3.676499] EXT3-fs (nbd2): error: unable to read superblock
> [    3.678420] end_request: I/O error, dev fd0, sector 0
> [    3.686036] block nbd12: Attempted send on closed socket
> [    3.687868] EXT3-fs (nbd12): error: unable to read superblock
> [    3.693222] block nbd14: Attempted send on closed socket
> [    3.695081] EXT3-fs (nbd14): error: unable to read superblock
> [    3.701419] block nbd3: Attempted send on closed socket
> [    3.703229] EXT2-fs (nbd3): error: unable to read superblock
> [    3.706370] block nbd11: Attempted send on closed socket
> [    3.708198] EXT3-fs (nbd11): error: unable to read superblock
> [    3.713198] block nbd1: Attempted send on closed socket
> [    3.715012] EXT3-fs (nbd1): error: unable to read superblock
> [    3.717397] block nbd8: Attempted send on closed socket
> [    3.719206] EXT3-fs (nbd8): error: unable to read superblock
> [    3.721851] block nbd10: Attempted send on closed socket
> [    3.723652] EXT3-fs (nbd10): error: unable to read superblock
> [    3.726953] block nbd13: Attempted send on closed socket
> [    3.728799] EXT3-fs (nbd13): error: unable to read superblock
> [    3.730792] block nbd9: Attempted send on closed socket
> [    3.732609] EXT2-fs (nbd9): error: unable to read superblock
> [    3.734559] EXT2-fs (zram0): error: unable to read superblock
> [    3.736604] block nbd5: Attempted send on closed socket
> [    3.738415] EXT2-fs (nbd5): error: unable to read superblock
> [    3.740355] block nbd3: Attempted send on closed socket
> [    3.742182] FAT-fs (nbd3): unable to read boot sector
> [    3.744002] block nbd2: Attempted send on closed socket
> [    3.745782] EXT2-fs (nbd2): error: unable to read superblock
> [    3.748111] block nbd0: Attempted send on closed socket
> [    3.749884] EXT2-fs (nbd0): error: unable to read superblock
> [    3.751876] block nbd12: Attempted send on closed socket
> [    3.753691] EXT2-fs (nbd12): error: unable to read superblock
> [    3.755678] block nbd14: Attempted send on closed socket
> [    3.757480] EXT2-fs (nbd14): error: unable to read superblock
> [    3.759468] block nbd15: Attempted send on closed socket
> [    3.761283] EXT2-fs (nbd15): error: unable to read superblock
> [    3.763303] block nbd8: Attempted send on closed socket
> [    3.765125] EXT2-fs (nbd8): error: unable to read superblock
> [    3.767313] block nbd11: Attempted send on closed socket
> [    3.769142] EXT2-fs (nbd11): error: unable to read superblock
> [    3.771349] block nbd9: Attempted send on closed socket
> [    3.773145] FAT-fs (nbd9): unable to read boot sector
> [    3.774943] block nbd10: Attempted send on closed socket
> [    3.776722] EXT2-fs (nbd10): error: unable to read superblock
> [    3.778662] FAT-fs (zram0): unable to read boot sector
> [    3.780461] REISERFS warning (device zram0): sh-2006 read_super_block: bread failed (dev zram0, block 2, size 4096)
> [    3.783903] REISERFS warning (device zram0): sh-2006 read_super_block: bread failed (dev zram0, block 16, size 4096)
> [    3.787386] block nbd5: Attempted send on closed socket
> [    3.789181] FAT-fs (nbd5): unable to read boot sector
> [    3.791239] block nbd3: Attempted send on closed socket
> [    3.793072] REISERFS warning (device nbd3): sh-2006 read_super_block: bread failed (dev nbd3, block 2, size 4096)
> [    3.796469] block nbd3: Attempted send on closed socket
> [    3.798260] REISERFS warning (device nbd3): sh-2006 read_super_block: bread failed (dev nbd3, block 16, size 4096)
> [    3.801701] block nbd7: Attempted send on closed socket
> [    3.803486] EXT2-fs (nbd7): error: unable to read superblock
> [    3.805444] block nbd1: Attempted send on closed socket
> [    3.807204] EXT2-fs (nbd1): error: unable to read superblock
> [    3.809355] block nbd2: Attempted send on closed socket
> [    3.811142] FAT-fs (nbd2): unable to read boot sector
> [    3.812952] block nbd13: Attempted send on closed socket
> [    3.814763] EXT2-fs (nbd13): error: unable to read superblock
> [    3.816701] block nbd0: Attempted send on closed socket
> [    3.818495] FAT-fs (nbd0): unable to read boot sector
> [    3.820266] block nbd12: Attempted send on closed socket
> [    3.822086] FAT-fs (nbd12): unable to read boot sector
> [    3.824102] block nbd14: Attempted send on closed socket
> [    3.825895] FAT-fs (nbd14): unable to read boot sector
> [    3.827697] block nbd15: Attempted send on closed socket
> [    3.829538] FAT-fs (nbd15): unable to read boot sector
> [    3.831610] block nbd8: Attempted send on closed socket
> [    3.833392] FAT-fs (nbd8): unable to read boot sector
> [    3.835220] block nbd6: Attempted send on closed socket
> [    3.836961] EXT2-fs (nbd6): error: unable to read superblock
> [    3.838903] block nbd11: Attempted send on closed socket
> [    3.840708] FAT-fs (nbd11): unable to read boot sector
> [    3.842544] block nbd9: Attempted send on closed socket
> [    3.844324] REISERFS warning (device nbd9): sh-2006 read_super_block: bread failed (dev nbd9, block 2, size 4096)
> [    3.847752] block nbd9: Attempted send on closed socket
> [    3.849602] REISERFS warning (device nbd9): sh-2006 read_super_block: bread failed (dev nbd9, block 16, size 4096)
> [    3.863821] block nbd10: Attempted send on closed socket
> [    3.865655] FAT-fs (nbd10): unable to read boot sector
> [    3.867496] block nbd4: Attempted send on closed socket
> [    3.869317] EXT2-fs (nbd4): error: unable to read superblock
> [    3.871359] block nbd5: Attempted send on closed socket
> [    3.873172] REISERFS warning (device nbd5): sh-2006 read_super_block: bread failed (dev nbd5, block 2, size 4096)
> [    3.876604] block nbd5: Attempted send on closed socket
> [    3.878418] REISERFS warning (device nbd5): sh-2006 read_super_block: bread failed (dev nbd5, block 16, size 4096)
> [    3.882493] block nbd3: Attempted send on closed socket
> [    3.884301] EXT3-fs (nbd3): error: unable to read superblock
> [    3.886289] block nbd7: Attempted send on closed socket
> [    3.888108] FAT-fs (nbd7): unable to read boot sector
> [    3.889904] block nbd1: Attempted send on closed socket
> [    3.891730] FAT-fs (nbd1): unable to read boot sector
> [    3.893542] block nbd2: Attempted send on closed socket
> [    3.895368] REISERFS warning (device nbd2): sh-2006 read_super_block: bread failed (dev nbd2, block 2, size 4096)
> [    3.898776] block nbd2: Attempted send on closed socket
> [    3.900581] REISERFS warning (device nbd2): sh-2006 read_super_block: bread failed (dev nbd2, block 16, size 4096)
> [    3.904401] block nbd12: Attempted send on closed socket
> [    3.906246] REISERFS warning (device nbd12): sh-2006 read_super_block: bread failed (dev nbd12, block 2, size 4096)
> [    3.909660] block nbd12: Attempted send on closed socket
> [    3.911460] REISERFS warning (device nbd12): sh-2006 read_super_block: bread failed (dev nbd12, block 16, size 4096)
> [    3.914928] block nbd13: Attempted send on closed socket
> [    3.916724] FAT-fs (nbd13): unable to read boot sector
> [    3.918538] block nbd0: Attempted send on closed socket
> [    3.920307] REISERFS warning (device nbd0): sh-2006 read_super_block: bread failed (dev nbd0, block 2, size 4096)
> [    3.923673] block nbd0: Attempted send on closed socket
> [    3.925461] REISERFS warning (device nbd0): sh-2006 read_super_block: bread failed (dev nbd0, block 16, size 4096)
> [    3.929165] block nbd14: Attempted send on closed socket
> [    3.930939] REISERFS warning (device nbd14): sh-2006 read_super_block: bread failed (dev nbd14, block 2, size 4096)
> [    3.934406] block nbd14: Attempted send on closed socket
> [    3.936232] REISERFS warning (device nbd14): sh-2006 read_super_block: bread failed (dev nbd14, block 16, size 4096)
> [    3.939946] block nbd8: Attempted send on closed socket
> [    3.941743] REISERFS warning (device nbd8): sh-2006 read_super_block: bread failed (dev nbd8, block 2, size 4096)
> [    3.945135] block nbd8: Attempted send on closed socket
> [    3.946890] REISERFS warning (device nbd8): sh-2006 read_super_block: bread failed (dev nbd8, block 16, size 4096)
> [    3.950438] block nbd15: Attempted send on closed socket
> [    3.952271] REISERFS warning (device nbd15): sh-2006 read_super_block: bread failed (dev nbd15, block 2, size 4096)
> [    3.955693] block nbd15: Attempted send on closed socket
> [    3.957505] REISERFS warning (device nbd15): sh-2006 read_super_block: bread failed (dev nbd15, block 16, size 4096)
> [    3.961051] block nbd6: Attempted send on closed socket
> [    3.962853] FAT-fs (nbd6): unable to read boot sector
> [    3.964676] block nbd11: Attempted send on closed socket
> [    3.966503] REISERFS warning (device nbd11): sh-2006 read_super_block: bread failed (dev nbd11, block 2, size 4096)
> [    3.969917] block nbd11: Attempted send on closed socket
> [    3.971728] REISERFS warning (device nbd11): sh-2006 read_super_block: bread failed (dev nbd11, block 16, size 4096)
> [    3.975207] block nbd9: Attempted send on closed socket
> [    3.976958] EXT3-fs (nbd9): error: unable to read superblock
> [    3.978921] block nbd10: Attempted send on closed socket
> [    3.980733] REISERFS warning (device nbd10): sh-2006 read_super_block: bread failed (dev nbd10, block 2, size 4096)
> [    3.984191] block nbd10: Attempted send on closed socket
> [    3.986001] REISERFS warning (device nbd10): sh-2006 read_super_block: bread failed (dev nbd10, block 16, size 4096)
> [    3.989477] block nbd4: Attempted send on closed socket
> [    3.991264] FAT-fs (nbd4): unable to read boot sector
> [    3.993339] block nbd5: Attempted send on closed socket
> [    3.995153] EXT3-fs (nbd5): error: unable to read superblock
> [    3.997098] block nbd3: Attempted send on closed socket
> [    3.998890] EXT2-fs (nbd3): error: unable to read superblock
> [    4.000819] block nbd7: Attempted send on closed socket
> [    4.002657] REISERFS warning (device nbd7): sh-2006 read_super_block: bread failed (dev nbd7, block 2, size 4096)
> [    4.006059] block nbd7: Attempted send on closed socket
> [    4.007808] REISERFS warning (device nbd7): sh-2006 read_super_block: bread failed (dev nbd7, block 16, size 4096)
> [    4.011313] block nbd1: Attempted send on closed socket
> [    4.013145] REISERFS warning (device nbd1): sh-2006 read_super_block: bread failed (dev nbd1, block 2, size 4096)
> [    4.016518] block nbd1: Attempted send on closed socket
> [    4.018308] REISERFS warning (device nbd1): sh-2006 read_super_block: bread failed (dev nbd1, block 16, size 4096)
> [    4.021735] block nbd2: Attempted send on closed socket
> [    4.023510] EXT3-fs (nbd2): error: unable to read superblock
> [    4.025436] block nbd13: Attempted send on closed socket
> [    4.027238] REISERFS warning (device nbd13): sh-2006 read_super_block: bread failed (dev nbd13, block 2, size 4096)
> [    4.030658] block nbd13: Attempted send on closed socket
> [    4.032469] REISERFS warning (device nbd13): sh-2006 read_super_block: bread failed (dev nbd13, block 16, size 4096)
> [    4.035924] block nbd12: Attempted send on closed socket
> [    4.037743] EXT3-fs (nbd12): error: unable to read superblock
> [    4.039739] block nbd0: Attempted send on closed socket
> [    4.041544] EXT3-fs (nbd0): error: unable to read superblock
> [    4.043455] block nbd14: Attempted send on closed socket
> [    4.045295] EXT3-fs (nbd14): error: unable to read superblock
> [    4.047315] block nbd8: Attempted send on closed socket
> [    4.049138] EXT3-fs (nbd8): error: unable to read superblock
> [    4.051293] block nbd15: Attempted send on closed socket
> [    4.053165] EXT3-fs (nbd15): error: unable to read superblock
> [    4.055148] block nbd6: Attempted send on closed socket
> [    4.056906] REISERFS warning (device nbd6): sh-2006 read_super_block: bread failed (dev nbd6, block 2, size 4096)
> [    4.061316] block nbd6: Attempted send on closed socket
> [    4.063155] REISERFS warning (device nbd6): sh-2006 read_super_block: bread failed (dev nbd6, block 16, size 4096)
> [    4.066658] block nbd9: Attempted send on closed socket
> [    4.068469] EXT2-fs (nbd9): error: unable to read superblock
> [    4.070413] block nbd11: Attempted send on closed socket
> [    4.072247] EXT3-fs (nbd11): error: unable to read superblock
> [    4.074211] block nbd10: Attempted send on closed socket
> [    4.076044] EXT3-fs (nbd10): error: unable to read superblock
> [    4.078008] block nbd4: Attempted send on closed socket
> [    4.080573] REISERFS warning (device nbd4): sh-2006 read_super_block: bread failed (dev nbd4, block 2, size 4096)
> [    4.084066] block nbd4: Attempted send on closed socket
> [    4.085857] REISERFS warning (device nbd4): sh-2006 read_super_block: bread failed (dev nbd4, block 16, size 4096)
> [    4.089339] block nbd5: Attempted send on closed socket
> [    4.091148] EXT2-fs (nbd5): error: unable to read superblock
> [    4.093162] block nbd3: Attempted send on closed socket
> [    4.094963] FAT-fs (nbd3): unable to read boot sector
> [    4.096769] block nbd7: Attempted send on closed socket
> [    4.098616] EXT3-fs (nbd7): error: unable to read superblock
> [    4.100572] block nbd1: Attempted send on closed socket
> [    4.102419] EXT3-fs (nbd1): error: unable to read superblock
> [    4.104347] block nbd2: Attempted send on closed socket
> [    4.106174] EXT2-fs (nbd2): error: unable to read superblock
> [    4.108395] block nbd8: Attempted send on closed socket
> [    4.110196] EXT2-fs (nbd8): error: unable to read superblock
> [    4.112166] block nbd13: Attempted send on closed socket
> [    4.114001] EXT3-fs (nbd13): error: unable to read superblock
> [    4.116004] block nbd12: Attempted send on closed socket
> [    4.117811] EXT2-fs (nbd12): error: unable to read superblock
> [    4.119817] block nbd0: Attempted send on closed socket
> [    4.121628] EXT2-fs (nbd0): error: unable to read superblock
> [    4.123582] block nbd14: Attempted send on closed socket
> [    4.125434] EXT2-fs (nbd14): error: unable to read superblock
> [    4.127398] block nbd15: Attempted send on closed socket
> [    4.129240] EXT2-fs (nbd15): error: unable to read superblock
> [    4.131193] block nbd6: Attempted send on closed socket
> [    4.133042] EXT3-fs (nbd6): error: unable to read superblock
> [    4.135055] block nbd9: Attempted send on closed socket
> [    4.136856] FAT-fs (nbd9): unable to read boot sector
> [    4.138692] block nbd11: Attempted send on closed socket
> [    4.140532] EXT2-fs (nbd11): error: unable to read superblock
> [    4.142552] block nbd10: Attempted send on closed socket
> [    4.144401] EXT2-fs (nbd10): error: unable to read superblock
> [    4.146449] block nbd2: Attempted send on closed socket
> [    4.148234] FAT-fs (nbd2): unable to read boot sector
> [    4.150011] block nbd5: Attempted send on closed socket
> [    4.151792] FAT-fs (nbd5): unable to read boot sector
> [    4.153601] block nbd3: Attempted send on closed socket
> [    4.155431] FAT-fs (nbd3): unable to read boot sector
> [    4.157237] block nbd7: Attempted send on closed socket
> [    4.159061] EXT2-fs (nbd7): error: unable to read superblock
> [    4.161000] block nbd1: Attempted send on closed socket
> [    4.162812] EXT2-fs (nbd1): error: unable to read superblock
> [    4.165049] block nbd8: Attempted send on closed socket
> [    4.166833] FAT-fs (nbd8): unable to read boot sector
> [    4.168640] block nbd4: Attempted send on closed socket
> [    4.170467] EXT3-fs (nbd4): error: unable to read superblock
> [    4.172477] block nbd13: Attempted send on closed socket
> [    4.174292] EXT2-fs (nbd13): error: unable to read superblock
> [    4.176283] block nbd12: Attempted send on closed socket
> [    4.178092] FAT-fs (nbd12): unable to read boot sector
> [    4.179897] block nbd0: Attempted send on closed socket
> [    4.181707] FAT-fs (nbd0): unable to read boot sector
> [    4.183514] block nbd14: Attempted send on closed socket
> [    4.185362] FAT-fs (nbd14): unable to read boot sector
> [    4.187404] block nbd15: Attempted send on closed socket
> [    4.189232] FAT-fs (nbd15): unable to read boot sector
> [    4.191049] block nbd6: Attempted send on closed socket
> [    4.203198] EXT2-fs (nbd6): error: unable to read superblock
> [    4.205190] EXT3-fs (zram0): error: unable to read superblock
> [    4.207123] EXT2-fs (zram0): error: unable to read superblock
> [    4.209088] block nbd9: Attempted send on closed socket
> [    4.210847] FAT-fs (nbd9): unable to read boot sector
> [    4.212941] block nbd11: Attempted send on closed socket
> [    4.214739] FAT-fs (nbd11): unable to read boot sector
> [    4.216536] block nbd10: Attempted send on closed socket
> [    4.218361] FAT-fs (nbd10): unable to read boot sector
> [    4.220453] block nbd2: Attempted send on closed socket
> [    4.222263] FAT-fs (nbd2): unable to read boot sector
> [    4.224030] block nbd5: Attempted send on closed socket
> [    4.225810] FAT-fs (nbd5): unable to read boot sector
> [    4.227599] block nbd1: Attempted send on closed socket
> [    4.229409] FAT-fs (nbd1): unable to read boot sector
> [    4.231205] block nbd3: Attempted send on closed socket
> [    4.233036] isofs_fill_super: bread failed, dev=nbd3, iso_blknum=16, block=32
> [    4.235359] GFS2: gfs2 mount does not exist
> [    4.238031] block nbd7: Attempted send on closed socket
> [    4.239792] FAT-fs (nbd7): unable to read boot sector
> [    4.241627] block nbd8: Attempted send on closed socket
> [    4.243429] FAT-fs (nbd8): unable to read boot sector
> [    4.247137] block nbd4: Attempted send on closed socket
> [    4.248926] EXT2-fs (nbd4): error: unable to read superblock
> [    4.250841] block nbd12: Attempted send on closed socket
> [    4.252669] FAT-fs (nbd12): unable to read boot sector
> [    4.254455] block nbd0: Attempted send on closed socket
> [    4.256272] FAT-fs (nbd0): unable to read boot sector
> [    4.258041] block nbd13: Attempted send on closed socket
> [    4.259802] FAT-fs (nbd13): unable to read boot sector
> [    4.261604] block nbd14: Attempted send on closed socket
> [    4.263403] FAT-fs (nbd14): unable to read boot sector
> [    4.265216] block nbd15: Attempted send on closed socket
> [    4.267007] FAT-fs (nbd15): unable to read boot sector
> [    4.268776] block nbd10: Attempted send on closed socket
> [    4.270571] FAT-fs (nbd10): unable to read boot sector
> [    4.272395] block nbd9: Attempted send on closed socket
> [    4.274170] isofs_fill_super: bread failed, dev=nbd9, iso_blknum=16, block=32
> [    4.278078] block nbd11: Attempted send on closed socket
> [    4.279866] FAT-fs (nbd11): unable to read boot sector
> [    4.283578] block nbd2: Attempted send on closed socket
> [    4.285390] isofs_fill_super: bread failed, dev=nbd2, iso_blknum=16, block=32
> [    4.287671] block nbd5: Attempted send on closed socket
> [    4.289486] isofs_fill_super: bread failed, dev=nbd5, iso_blknum=16, block=32
> [    4.291759] block nbd1: Attempted send on closed socket
> [    4.293525] FAT-fs (nbd1): unable to read boot sector
> [    4.295320] block nbd3: Attempted send on closed socket
> [    4.297090] block nbd3: Attempted send on closed socket
> [    4.301045] block nbd7: Attempted send on closed socket
> [    4.302847] FAT-fs (nbd7): unable to read boot sector
> [    4.304621] block nbd8: Attempted send on closed socket
> [    4.306426] isofs_fill_super: bread failed, dev=nbd8, iso_blknum=16, block=32
> [    4.308710] block nbd4: Attempted send on closed socket
> [    4.310477] FAT-fs (nbd4): unable to read boot sector
> [    4.312282] block nbd13: Attempted send on closed socket
> [    4.314079] FAT-fs (nbd13): unable to read boot sector
> [    4.315865] block nbd0: Attempted send on closed socket
> [    4.317633] isofs_fill_super: bread failed, dev=nbd0, iso_blknum=16, block=32
> [    4.319931] block nbd12: Attempted send on closed socket
> [    4.321749] isofs_fill_super: bread failed, dev=nbd12, iso_blknum=16, block=32
> [    4.325786] block nbd14: Attempted send on closed socket
> [    4.327604] isofs_fill_super: bread failed, dev=nbd14, iso_blknum=16, block=32
> [    4.330521] block nbd15: Attempted send on closed socket
> [    4.332347] isofs_fill_super: bread failed, dev=nbd15, iso_blknum=16, block=32
> [    4.335000] block nbd10: Attempted send on closed socket
> [    4.336772] isofs_fill_super: bread failed, dev=nbd10, iso_blknum=16, block=32
> [    4.339424] block nbd9: Attempted send on closed socket
> [    4.341209] block nbd9: Attempted send on closed socket
> [    4.343114] block nbd11: Attempted send on closed socket
> [    4.344928] isofs_fill_super: bread failed, dev=nbd11, iso_blknum=16, block=32
> [    4.347611] FAT-fs (zram0): unable to read boot sector
> [    4.349864] block nbd2: Attempted send on closed socket
> [    4.351680] block nbd2: Attempted send on closed socket
> [    4.353490] block nbd1: Attempted send on closed socket
> [    4.355276] isofs_fill_super: bread failed, dev=nbd1, iso_blknum=16, block=32
> [    4.357557] block nbd5: Attempted send on closed socket
> [    4.359364] block nbd5: Attempted send on closed socket
> [    4.361239] block nbd7: Attempted send on closed socket
> [    4.363045] isofs_fill_super: bread failed, dev=nbd7, iso_blknum=16, block=32
> [    4.365340] block nbd8: Attempted send on closed socket
> [    4.367129] block nbd8: Attempted send on closed socket
> [    4.370845] block nbd4: Attempted send on closed socket
> [    4.372681] FAT-fs (nbd4): unable to read boot sector
> [    4.374476] block nbd13: Attempted send on closed socket
> [    4.376324] isofs_fill_super: bread failed, dev=nbd13, iso_blknum=16, block=32
> [    4.378942] block nbd0: Attempted send on closed socket
> [    4.380704] block nbd0: Attempted send on closed socket
> [    4.382533] block nbd12: Attempted send on closed socket
> [    4.384334] block nbd12: Attempted send on closed socket
> [    4.386477] block nbd14: Attempted send on closed socket
> [    4.388284] block nbd14: Attempted send on closed socket
> [    4.390132] block nbd15: Attempted send on closed socket
> [    4.391946] block nbd15: Attempted send on closed socket
> [    4.394768] block nbd10: Attempted send on closed socket
> [    4.396577] block nbd10: Attempted send on closed socket
> [    4.398473] block nbd11: Attempted send on closed socket
> [    4.400271] block nbd11: Attempted send on closed socket
> [    4.402105] FAT-fs (zram0): unable to read boot sector
> [    4.403849] isofs_fill_super: bread failed, dev=zram0, iso_blknum=16, block=0
> [    4.406205] block nbd1: Attempted send on closed socket
> [    4.407958] block nbd1: Attempted send on closed socket
> [    4.409927] block nbd7: Attempted send on closed socket
> [    4.411725] block nbd7: Attempted send on closed socket
> [    4.414834] block nbd4: Attempted send on closed socket
> [    4.416619] isofs_fill_super: bread failed, dev=nbd4, iso_blknum=16, block=32
> [    4.418910] block nbd3: Attempted send on closed socket
> [    4.420795] block nbd3: Attempted send on closed socket
> [    4.422589] (mount,615,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.424589] (mount,615,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.426563] (mount,615,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.429208] (mount,615,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.431325] block nbd13: Attempted send on closed socket
> [    4.433177] block nbd13: Attempted send on closed socket
> [    4.436677] block nbd9: Attempted send on closed socket
> [    4.438814] block nbd9: Attempted send on closed socket
> [    4.440605] (mount,636,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.442653] (mount,636,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.444638] (mount,636,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.447320] (mount,636,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.449590] block nbd3: Attempted send on closed socket
> [    4.451403] gfs2: error -5 reading superblock
> [    4.453221] block nbd2: Attempted send on closed socket
> [    4.455095] block nbd2: Attempted send on closed socket
> [    4.456873] (mount,639,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.458925] (mount,639,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.460879] (mount,639,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.463559] (mount,639,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.465688] block nbd4: Attempted send on closed socket
> [    4.467486] block nbd4: Attempted send on closed socket
> [    4.469347] block nbd5: Attempted send on closed socket
> [    4.471222] block nbd5: Attempted send on closed socket
> [    4.473048] (mount,628,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.475067] (mount,628,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.477003] (mount,628,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.479615] (mount,628,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.481822] block nbd8: Attempted send on closed socket
> [    4.483690] block nbd8: Attempted send on closed socket
> [    4.485475] (mount,642,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.487481] (mount,642,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.489432] (mount,642,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.492055] (mount,642,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.494354] block nbd0: Attempted send on closed socket
> [    4.496256] block nbd0: Attempted send on closed socket
> [    4.498040] (mount,622,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.500039] (mount,622,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.502022] (mount,622,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.504630] (mount,622,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.506771] block nbd9: Attempted send on closed socket
> [    4.508561] gfs2: error -5 reading superblock
> [    4.510170] block nbd12: Attempted send on closed socket
> [    4.512070] block nbd12: Attempted send on closed socket
> [    4.513845] (mount,641,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.515865] (mount,641,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.517811] (mount,641,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.520481] (mount,641,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.522534] block nbd14: Attempted send on closed socket
> [    4.524417] block nbd14: Attempted send on closed socket
> [    4.526253] (mount,643,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.528275] (mount,643,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.530221] (mount,643,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.532860] (mount,643,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.535014] block nbd15: Attempted send on closed socket
> [    4.536893] block nbd15: Attempted send on closed socket
> [    4.538735] (mount,625,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.540751] (mount,625,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.542727] (mount,625,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.555866] (mount,625,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.558232] block nbd10: Attempted send on closed socket
> [    4.560130] block nbd10: Attempted send on closed socket
> [    4.561924] (mount,645,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.563937] (mount,645,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.565896] (mount,645,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.568519] (mount,645,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.570644] block nbd11: Attempted send on closed socket
> [    4.572599] block nbd11: Attempted send on closed socket
> [    4.574468] (mount,644,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.576581] (mount,644,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.578574] (mount,644,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.581190] (mount,644,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.583266] block nbd2: Attempted send on closed socket
> [    4.585068] gfs2: error -5 reading superblock
> [    4.586700] block nbd5: Attempted send on closed socket
> [    4.588576] gfs2: error -5 reading superblock
> [    4.590300] block nbd8: Attempted send on closed socket
> [    4.592094] gfs2: error -5 reading superblock
> [    4.593701] block nbd1: Attempted send on closed socket
> [    4.595589] block nbd1: Attempted send on closed socket
> [    4.597380] (mount,647,0):ocfs2_get_sector:1861 ERROR: status = -5
> [    4.599446] (mount,647,0):ocfs2_sb_probe:770 ERROR: status = -5
> [    4.601415] (mount,647,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [    4.604033] (mount,647,0):ocfs2_fill_super:1229 ERROR: status = -5
> [    4.606149] block nbd0: Attempted send on closed socket
> [    4.607918] gfs2: error -5 reading superblock
> [    4.609575] block nbd7: Attempted send on closed socket
> [    4.611643] BUG: unable to handle kernel NULL pointer dereference at 00000003
> [    4.614242] IP: [<c10334dd>] move_linked_works+0x1d/0x50
> [    4.614724] *pdpt = 000000000cead001 *pde = 0000000000000000 
> [    4.614724] Oops: 0002 [#1] 
> [    4.614724] CPU: 0 PID: 662 Comm: kworker/0:1H Not tainted 3.12.0-rc1-00279-ga0c7d83 #138
> [    4.614724] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.614724] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.614724] EIP: 0060:[<c10334dd>] EFLAGS: 00010086 CPU: 0
> [    4.614724] EIP is at move_linked_works+0x1d/0x50
> [    4.614724] EAX: ccae5858 EBX: fffffffb ECX: 00000000 EDX: cc8b2eb8
> [    4.614724] ESI: 00000000 EDI: ffffffff EBP: ccf27f54 ESP: ccf27f44
> [    4.614724]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.614724] CR0: 8005003b CR2: 0000005c CR3: 0cc66000 CR4: 000006b0
> [    4.614724] Stack:
> [    4.614724]  ccae585c cc8b2ea0 c1a81d50 cc8b2eb8 ccf27f70 c1034d34 ccab0a20 c1a81d60
> [    4.614724]  cec55ed0 cc8b2ea0 c1034c02 ccf27fac c10388f7 ccf27f94 00000000 00000000
> [    4.614724]  cc8b2ea0 00000000 ccf27f8c ccf27f8c 00000000 ccf27f98 ccf27f98 ccab0a20
> [    4.614724] Call Trace:
> [    4.614724]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.614724]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.614724]  [<c10388f7>] kthread+0x6d/0x72
> [    4.614724]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.614724]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.614724] Code: 74 0a 8b 00 85 c0 75 ed eb 02 31 c0 5d c3 55 89 e5 57 56 53 53 8b 58 04 83 eb 04 89 c6 83 c6 04 89 75 f0 74 21 8b 78 04 8b 70 08 <89> 77 04 89 3e 8b 72 04 8b 7d f0 89 7a 04 89 50 04 89 70 08 89
> [    4.614724] EIP: [<c10334dd>] move_linked_works+0x1d/0x50 SS:ESP 0068:ccf27f44
> [    4.614724] CR2: 0000000000000003
> [    4.614724] ---[ end trace 346f0648092682e5 ]---
> [    4.614724] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> [    4.614724] in_atomic(): 1, irqs_disabled(): 1, pid: 662, name: kworker/0:1H
> [    4.614724] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.614724] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.614724]  00000000 ccab0bd0 ccf27d94 c1759620 ccf27da8 c103f58c ccbc0bf4 00000009
> [    4.614724]  ccf27f08 ccf27db4 c175defa ccab0a20 ccf27dcc c102fc15 ffffffff 00000000
> [    4.614724]  ccab0a20 00000009 ccf27e00 c1027833 00000000 00000000 c197d991 ccf27df0
> [    4.614724] Call Trace:
> [    4.614724]  [<c1759620>] dump_stack+0x16/0x18
> [    4.614724]  [<c103f58c>] __might_sleep+0xc4/0xcc
> [    4.614724]  [<c175defa>] down_read+0x17/0x25
> [    4.614724]  [<c102fc15>] exit_signals+0x1a/0xde
> [    4.614724]  [<c1027833>] do_exit+0xc6/0x715
> [    4.614724]  [<c1003813>] oops_end+0x90/0x98
> [    4.614724]  [<c17551f9>] no_context+0x191/0x19b
> [    4.614724]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.614724]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.614724]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.614724]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.614724]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.614724]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.614724]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.614724]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.614724]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.614724]  [<c175f5f8>] error_code+0x58/0x60
> [    4.614724]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.614724]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.614724]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.614724]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.614724]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.614724]  [<c10388f7>] kthread+0x6d/0x72
> [    4.614724]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.614724]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.614724] note: kworker/0:1H[662] exited with preempt_count 1
> [    4.753245] BUG: unable to handle kernel paging request at fffffff0
> [    4.755616] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#2] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf27d58 ESP: ccf27d58
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf27d64 c103460f ccab0a20 ccf27dc4 c175e2b8 ccab0a20 ccab0a20 c10941ef
> [    4.756528]  cec0d000 c10941ef c1024ff3 c1024ff3 ccf26000 cf27c500 ccc29600 ccbc0a00
> [    4.756528]  00000246 ccf27da8 c1063c0d ccab0a20 ccf27dcc c1026d0e ccc29600 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf27d58
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682e6 ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#3] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf27b68 ESP: ccf27b68
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf27b74 c103460f ccab0a20 ccf27bd4 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  000004f0 00000002 0000002c 00000006 00000046 ccf27bbc c104548a 000004ef
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf27d1c ccf27bdc c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf27b68
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682e7 ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#4] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf27978 ESP: ccf27978
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf27984 c103460f ccab0a20 ccf279e4 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  0000053e 00000006 0000002c 00000006 00000046 ccf279cc c104548a 0000053d
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf27b2c ccf279ec c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf27978
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682e8 ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#5] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf27788 ESP: ccf27788
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf27794 c103460f ccab0a20 ccf277f4 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  000005a3 00000002 0000002c 00000006 00000046 ccf277dc c104548a 000005a2
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf2793c ccf277fc c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf27788
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682e9 ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#6] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf27598 ESP: ccf27598
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf275a4 c103460f ccab0a20 ccf27604 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  0000061f 00000006 0000002c 00000006 00000046 ccf275ec c104548a 0000061e
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf2774c ccf2760c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf27598
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682ea ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#7] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf273a8 ESP: ccf273a8
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf273b4 c103460f ccab0a20 ccf27414 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  000006b2 00000006 0000002c 00000006 00000046 ccf273fc c104548a 000006b1
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf2755c ccf2741c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf273a8
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682eb ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#8] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf271b8 ESP: ccf271b8
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf271c4 c103460f ccab0a20 ccf27224 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  0000075c 00000002 0000002c 00000006 00000046 ccf2720c c104548a 0000075b
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf2736c ccf2722c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf271b8
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682ec ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#9] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf26fc8 ESP: ccf26fc8
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf26fd4 c103460f ccab0a20 ccf27034 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  0000081d 00000002 0000002c 00000006 00000046 ccf2701c c104548a 0000081c
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf2717c ccf2703c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf26fc8
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682ed ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#10] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf26dd8 ESP: ccf26dd8
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf26de4 c103460f ccab0a20 ccf26e44 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  000008f5 00000006 0000002c 00000006 00000046 ccf26e2c c104548a 000008f4
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf26f8c ccf26e4c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf26dd8
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682ee ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#11] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf26be8 ESP: ccf26be8
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf26bf4 c103460f ccab0a20 ccf26c54 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  000009e4 00000006 0000002c 00000006 00000046 ccf26c3c c104548a 000009e3
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf26d9c ccf26c5c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf26be8
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682ef ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#12] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf269f8 ESP: ccf269f8
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf26a04 c103460f ccab0a20 ccf26a64 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  00000aea 00000002 0000002c 00000006 00000046 ccf26a4c c104548a 00000ae9
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf26bac ccf26a6c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c12d0584>] ? number.isra.2+0x147/0x238
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c10941ef>] ? kmem_cache_free+0x85/0x8e
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1024ff3>] ? __cleanup_sighand+0x22/0x25
> [    4.756528]  [<c1063c0d>] ? call_rcu_sched+0x27/0x2a
> [    4.756528]  [<c1026d0e>] ? release_task+0x29b/0x2b1
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c1027e80>] do_exit+0x713/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c10408b4>] ? update_curr+0x69/0xaf
> [    4.756528]  [<c1040be9>] ? dequeue_task_fair+0x6a/0xaf
> [    4.756528]  [<c1000f06>] ? __switch_to+0xd8/0x2c0
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c103007b>] ? copy_siginfo_to_user+0x126/0x1cb
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10334dd>] ? move_linked_works+0x1d/0x50
> [    4.756528]  [<c1034d34>] worker_thread+0x132/0x1bd
> [    4.756528]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
> [    4.756528]  [<c10388f7>] kthread+0x6d/0x72
> [    4.756528]  [<c175f837>] ret_from_kernel_thread+0x1b/0x28
> [    4.756528]  [<c103888a>] ? init_completion+0x1d/0x1d
> [    4.756528] Code: ff ff 31 d2 84 c0 74 0c b8 01 00 00 00 e8 36 12 01 00 88 c2 85 db 74 02 88 13 e8 91 ff ff ff 5b 5d c3 55 89 e5 8b 80 38 01 00 00 <8b> 40 f0 5d c3 55 89 e5 52 8b 90 38 01 00 00 c7 45 fc 00 00 00
> [    4.756528] EIP: [<c10389be>] kthread_data+0x9/0xe SS:ESP 0068:ccf269f8
> [    4.756528] CR2: 00000000fffffff0
> [    4.756528] ---[ end trace 346f0648092682f0 ]---
> [    4.756528] Fixing recursive fault but reboot is needed!
> [    4.756528] BUG: unable to handle kernel paging request at fffffff0
> [    4.756528] IP: [<c10389be>] kthread_data+0x9/0xe
> [    4.756528] *pdpt = 0000000001b96001 *pde = 0000000001b9b067 *pte = 0000000000000000 
> [    4.756528] Oops: 0000 [#13] 
> [    4.756528] CPU: 0 PID: 662 Comm: kworker/0:1H Tainted: G      D      3.12.0-rc1-00279-ga0c7d83 #138
> [    4.756528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.756528] task: ccab0a20 ti: ccf26000 task.ti: ccf26000
> [    4.756528] EIP: 0060:[<c10389be>] EFLAGS: 00010046 CPU: 0
> [    4.756528] EIP is at kthread_data+0x9/0xe
> [    4.756528] EAX: 00000000 EBX: 00000000 ECX: 5d853a86 EDX: 00000000
> [    4.756528] ESI: ccab0a20 EDI: ccab0b84 EBP: ccf26808 ESP: ccf26808
> [    4.756528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    4.756528] CR0: 8005003b CR2: 00000014 CR3: 0cc66000 CR4: 000006b0
> [    4.756528] Stack:
> [    4.756528]  ccf26814 c103460f ccab0a20 ccf26874 c175e2b8 ccab0a20 ccab0a20 0103bc21
> [    4.756528]  00000c07 00000006 0000002c 00000006 00000046 ccf2685c c104548a 00000c06
> [    4.756528]  00000000 00000046 ccab0a20 00000009 ccf269bc ccf2687c c1755877 00000000
> [    4.756528] Call Trace:
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] ? kthread_data+0x9/0xe
> [    4.756528]  [<c103460f>] wq_worker_sleeping+0xb/0x69
> [    4.756528]  [<c175e2b8>] __schedule+0xe2/0x369
> [    4.756528]  [<c104548a>] ? vprintk_emit+0x299/0x2a3
> [    4.756528]  [<c1755877>] ? printk+0x17/0x19
> [    4.756528]  [<c175e590>] schedule+0x51/0x53
> [    4.756528]  [<c102782b>] do_exit+0xbe/0x715
> [    4.756528]  [<c1003813>] oops_end+0x90/0x98
> [    4.756528]  [<c17551f9>] no_context+0x191/0x19b
> [    4.756528]  [<c17552fb>] __bad_area_nosemaphore+0xf8/0x102
> [    4.756528]  [<c1754c16>] ? pte_offset_kernel+0x10/0x2a
> [    4.756528]  [<c1755312>] bad_area_nosemaphore+0xd/0x10
> [    4.756528]  [<c101d4c1>] __do_page_fault+0x253/0x36a
> [    4.756528]  [<c101bfd0>] ? kvm_clock_read+0x18/0x26
> [    4.756528]  [<c10058fb>] ? paravirt_sched_clock+0x9/0xd
> [    4.756528]  [<c1005da6>] ? sched_clock+0x9/0xc
> [    4.756528]  [<c103fc85>] ? sched_clock_local.constprop.3+0xe/0x106
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c101d67f>] do_page_fault+0x8/0xa
> [    4.756528]  [<c101bd70>] do_async_page_fault+0x23/0x49
> [    4.756528]  [<c175f5f8>] error_code+0x58/0x60
> [    4.756528]  [<c176007b>] ? iret_exc+0x21f/0xa40
> [    4.756528]  [<c101bd4d>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
> [    4.756528]  [<c10389be>] 
> BUG: kernel boot oops
> Elapsed time: 10
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c4-0920/a0c7d83322521880caf8c9c1ef20a2a1cd5cb955/vmlinuz-3.12.0-rc1-00279-ga0c7d83 -append 'hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-c4-0920/can:for-davem/.vmlinuz-a0c7d83322521880caf8c9c1ef20a2a1cd5cb955-20130921224411-2-lkp-tt02 branch=can/for-davem BOOT_IMAGE=/kernel/i386-randconfig-c4-0920/a0c7d83322521880caf8c9c1ef20a2a1cd5cb955/vmlinuz-3.12.0-rc1-00279-ga0c7d83'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 256M -smp 2 -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio -net user,vlan=0,hostfwd=tcp::15782-:22 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -pidfile /dev/shm/kboot/pid-lkp-tt02-lkp-11
 686 -serial file:/dev/shm/kboot/serial-lkp-tt02-lkp-11686 -daemonize -display none -monitor null 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.12.0-rc1 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
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
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_COMPILE_TEST=y
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> CONFIG_KERNEL_BZIP2=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_FHANDLE=y
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_WATCH=y
> CONFIG_AUDIT_TREE=y
> # CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> CONFIG_TASKSTATS=y
> # CONFIG_TASK_DELAY_ACCT is not set
> # CONFIG_TASK_XACCT is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_STALL_COMMON is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> # CONFIG_CGROUP_CPUACCT is not set
> # CONFIG_RESOURCE_COUNTERS is not set
> # CONFIG_CGROUP_PERF is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_CFS_BANDWIDTH is not set
> # CONFIG_RT_GROUP_SCHED is not set
> # CONFIG_BLK_CGROUP is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> CONFIG_IPC_NS=y
> CONFIG_USER_NS=y
> CONFIG_PID_NS=y
> # CONFIG_NET_NS is not set
> CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_PROFILING=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_JUMP_LABEL is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
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
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_CMDLINE_PARSER is not set
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_DEADLINE is not set
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_ASN1=y
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> CONFIG_INLINE_READ_UNLOCK=y
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> CONFIG_INLINE_WRITE_UNLOCK=y
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> # CONFIG_X86_GOLDFISH is not set
> # CONFIG_X86_WANT_INTEL_MID is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_RDC321X is not set
> CONFIG_X86_32_IRIS=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_XEN is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_LGUEST_GUEST is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> CONFIG_MPENTIUM4=y
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
> CONFIG_X86_INTERNODE_CACHE_SHIFT=7
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_INTEL_USERCOPY=y
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
> CONFIG_NR_CPUS=1
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_UP_APIC=y
> # CONFIG_X86_UP_IOAPIC is not set
> CONFIG_X86_LOCAL_APIC=y
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> CONFIG_TOSHIBA=y
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> # CONFIG_MICROCODE_INTEL is not set
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_MICROCODE_EARLY=y
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_X86_PAE=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_NEED_NODE_MEMMAP_SIZE=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> # CONFIG_BOUNCE is not set
> CONFIG_NEED_BOUNCE_POOL=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_NEED_PER_CPU_KM=y
> CONFIG_CLEANCACHE=y
> CONFIG_FRONTSWAP=y
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> CONFIG_ZBUD=y
> CONFIG_ZSWAP=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
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
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> CONFIG_HZ_300=y
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=300
> # CONFIG_SCHED_HRTICK is not set
> CONFIG_KEXEC=y
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_COMPAT_VDSO=y
> # CONFIG_CMDLINE_BOOL is not set
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
> CONFIG_ACPI=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> # CONFIG_ACPI_VIDEO is not set
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
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
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> CONFIG_EISA=y
> # CONFIG_EISA_VLB_PRIMING is not set
> CONFIG_EISA_PCI_EISA=y
> CONFIG_EISA_VIRTUAL_ROOT=y
> CONFIG_EISA_NAMES=y
> # CONFIG_SCx200 is not set
> # CONFIG_ALIX is not set
> # CONFIG_NET5501 is not set
> CONFIG_GEOS=y
> CONFIG_AMD_NB=y
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> CONFIG_X86_SYSFB=y
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=y
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=y
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> # CONFIG_IP_MULTICAST is not set
> CONFIG_IP_ADVANCED_ROUTER=y
> # CONFIG_IP_FIB_TRIE_STATS is not set
> # CONFIG_IP_MULTIPLE_TABLES is not set
> # CONFIG_IP_ROUTE_MULTIPATH is not set
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=y
> CONFIG_NET_IPGRE_DEMUX=y
> CONFIG_NET_IP_TUNNEL=y
> CONFIG_NET_IPGRE=y
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> CONFIG_INET_ESP=y
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> CONFIG_INET_XFRM_MODE_BEET=y
> # CONFIG_INET_LRO is not set
> # CONFIG_INET_DIAG is not set
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> # CONFIG_IPV6_PRIVACY is not set
> CONFIG_IPV6_ROUTER_PREF=y
> # CONFIG_IPV6_ROUTE_INFO is not set
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=y
> # CONFIG_INET6_ESP is not set
> CONFIG_INET6_IPCOMP=y
> CONFIG_IPV6_MIP6=y
> CONFIG_INET6_XFRM_TUNNEL=y
> CONFIG_INET6_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_TRANSPORT=y
> CONFIG_INET6_XFRM_MODE_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_BEET=y
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
> CONFIG_IPV6_SIT=y
> # CONFIG_IPV6_SIT_6RD is not set
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=y
> CONFIG_IPV6_GRE=y
> CONFIG_IPV6_MULTIPLE_TABLES=y
> CONFIG_IPV6_SUBTREES=y
> # CONFIG_IPV6_MROUTE is not set
> CONFIG_NETLABEL=y
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> CONFIG_IP_DCCP=y
> 
> #
> # DCCP CCIDs Configuration
> #
> CONFIG_IP_DCCP_CCID2_DEBUG=y
> # CONFIG_IP_DCCP_CCID3 is not set
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_IP_SCTP=y
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
> CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
> # CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
> CONFIG_SCTP_COOKIE_HMAC_SHA1=y
> CONFIG_RDS=y
> CONFIG_RDS_TCP=y
> CONFIG_RDS_DEBUG=y
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> CONFIG_L2TP=y
> # CONFIG_L2TP_V3 is not set
> CONFIG_STP=y
> CONFIG_BRIDGE=y
> CONFIG_BRIDGE_IGMP_SNOOPING=y
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_IPX=y
> CONFIG_IPX_INTERN=y
> CONFIG_ATALK=y
> # CONFIG_DEV_APPLETALK is not set
> # CONFIG_X25 is not set
> CONFIG_LAPB=y
> CONFIG_PHONET=y
> # CONFIG_IEEE802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=y
> # CONFIG_NET_SCH_HTB is not set
> # CONFIG_NET_SCH_HFSC is not set
> # CONFIG_NET_SCH_PRIO is not set
> # CONFIG_NET_SCH_MULTIQ is not set
> CONFIG_NET_SCH_RED=y
> CONFIG_NET_SCH_SFB=y
> CONFIG_NET_SCH_SFQ=y
> # CONFIG_NET_SCH_TEQL is not set
> CONFIG_NET_SCH_TBF=y
> CONFIG_NET_SCH_GRED=y
> CONFIG_NET_SCH_DSMARK=y
> CONFIG_NET_SCH_NETEM=y
> CONFIG_NET_SCH_DRR=y
> CONFIG_NET_SCH_MQPRIO=y
> CONFIG_NET_SCH_CHOKE=y
> CONFIG_NET_SCH_QFQ=y
> CONFIG_NET_SCH_CODEL=y
> # CONFIG_NET_SCH_FQ_CODEL is not set
> CONFIG_NET_SCH_FQ=y
> CONFIG_NET_SCH_PLUG=y
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> # CONFIG_NET_CLS_BASIC is not set
> # CONFIG_NET_CLS_TCINDEX is not set
> # CONFIG_NET_CLS_ROUTE4 is not set
> CONFIG_NET_CLS_FW=y
> # CONFIG_NET_CLS_U32 is not set
> # CONFIG_NET_CLS_RSVP is not set
> # CONFIG_NET_CLS_RSVP6 is not set
> # CONFIG_NET_CLS_FLOW is not set
> CONFIG_NET_CLS_CGROUP=y
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=y
> CONFIG_NET_EMATCH_NBYTE=y
> CONFIG_NET_EMATCH_U32=y
> CONFIG_NET_EMATCH_META=y
> CONFIG_NET_EMATCH_TEXT=y
> CONFIG_NET_EMATCH_CANID=y
> # CONFIG_NET_CLS_ACT is not set
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> CONFIG_BATMAN_ADV=y
> # CONFIG_BATMAN_ADV_BLA is not set
> # CONFIG_BATMAN_ADV_DAT is not set
> CONFIG_BATMAN_ADV_NC=y
> CONFIG_BATMAN_ADV_DEBUG=y
> # CONFIG_OPENVSWITCH is not set
> CONFIG_VSOCKETS=y
> CONFIG_NETLINK_MMAP=y
> # CONFIG_NETLINK_DIAG is not set
> # CONFIG_NET_MPLS_GSO is not set
> # CONFIG_NETPRIO_CGROUP is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=y
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> # CONFIG_AX25 is not set
> CONFIG_CAN=y
> CONFIG_CAN_RAW=y
> CONFIG_CAN_BCM=y
> CONFIG_CAN_GW=y
> 
> #
> # CAN Device Drivers
> #
> # CONFIG_CAN_VCAN is not set
> CONFIG_CAN_SLCAN=y
> CONFIG_CAN_DEV=y
> # CONFIG_CAN_CALC_BITTIMING is not set
> # CONFIG_CAN_LEDS is not set
> CONFIG_CAN_MCP251X=y
> # CONFIG_PCH_CAN is not set
> # CONFIG_CAN_SJA1000 is not set
> # CONFIG_CAN_C_CAN is not set
> # CONFIG_CAN_CC770 is not set
> 
> #
> # CAN USB interfaces
> #
> CONFIG_CAN_EMS_USB=y
> # CONFIG_CAN_ESD_USB2 is not set
> CONFIG_CAN_KVASER_USB=y
> CONFIG_CAN_PEAK_USB=y
> CONFIG_CAN_8DEV_USB=y
> # CONFIG_CAN_SOFTING is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_AF_RXRPC=y
> # CONFIG_AF_RXRPC_DEBUG is not set
> # CONFIG_RXKAD is not set
> CONFIG_FIB_RULES=y
> # CONFIG_WIRELESS is not set
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_RFKILL_REGULATOR=y
> CONFIG_NET_9P=y
> CONFIG_NET_9P_VIRTIO=y
> # CONFIG_NET_9P_DEBUG is not set
> # CONFIG_CAIF is not set
> CONFIG_CEPH_LIB=y
> CONFIG_CEPH_LIB_PRETTYDEBUG=y
> CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
> CONFIG_NFC=y
> # CONFIG_NFC_NCI is not set
> CONFIG_NFC_HCI=y
> # CONFIG_NFC_SHDLC is not set
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_PN533 is not set
> CONFIG_NFC_SIM=y
> CONFIG_NFC_PN544=y
> # CONFIG_NFC_MICROREAD is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> # CONFIG_STANDALONE is not set
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> # CONFIG_DMA_SHARED_BUFFER is not set
> # CONFIG_DMA_CMA is not set
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> # CONFIG_MTD is not set
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_SERIAL is not set
> # CONFIG_PARPORT_PC_FIFO is not set
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> CONFIG_BLK_DEV_CRYPTOLOOP=y
> # CONFIG_BLK_DEV_DRBD is not set
> CONFIG_BLK_DEV_NBD=y
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> # CONFIG_BLK_DEV_XIP is not set
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> CONFIG_CDROM_PKTCDVD_WCACHE=y
> CONFIG_ATA_OVER_ETH=y
> CONFIG_VIRTIO_BLK=y
> CONFIG_BLK_DEV_HD=y
> CONFIG_BLK_DEV_RBD=y
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> # CONFIG_AD525X_DPOT is not set
> CONFIG_DUMMY_IRQ=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ICS932S401 is not set
> CONFIG_ATMEL_SSC=y
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_APDS9802ALS is not set
> CONFIG_ISL29003=y
> # CONFIG_ISL29020 is not set
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> # CONFIG_SENSORS_BH1770 is not set
> CONFIG_SENSORS_APDS990X=y
> CONFIG_HMC6352=y
> # CONFIG_DS1682 is not set
> CONFIG_TI_DAC7512=y
> CONFIG_VMWARE_BALLOON=y
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=y
> # CONFIG_BMP085_SPI is not set
> # CONFIG_PCH_PHUB is not set
> CONFIG_USB_SWITCH_FSA9480=y
> # CONFIG_LATTICE_ECP3_CONFIG is not set
> CONFIG_SRAM=y
> CONFIG_C2PORT=y
> # CONFIG_C2PORT_DURAMAR_2150 is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> CONFIG_EEPROM_LEGACY=y
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> # CONFIG_EEPROM_93XX46 is not set
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> # CONFIG_INTEL_MEI is not set
> # CONFIG_INTEL_MEI_ME is not set
> # CONFIG_VMWARE_VMCI is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> CONFIG_IDE_LEGACY=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=y
> # CONFIG_IDE_GD_ATA is not set
> CONFIG_IDE_GD_ATAPI=y
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> CONFIG_BLK_DEV_IDETAPE=y
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> # CONFIG_IDE_PROC_FS is not set
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> # CONFIG_BLK_DEV_PLATFORM is not set
> CONFIG_BLK_DEV_CMD640=y
> CONFIG_BLK_DEV_CMD640_ENHANCED=y
> CONFIG_BLK_DEV_IDEPNP=y
> 
> #
> # PCI IDE chipsets support
> #
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_CS5535 is not set
> # CONFIG_BLK_DEV_CS5536 is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8172 is not set
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
> 
> #
> # Other IDE chipsets support
> #
> 
> #
> # Note: most of these also require special kernel boot parameters
> #
> CONFIG_BLK_DEV_4DRIVES=y
> # CONFIG_BLK_DEV_ALI14XX is not set
> CONFIG_BLK_DEV_DTC2278=y
> CONFIG_BLK_DEV_HT6560B=y
> # CONFIG_BLK_DEV_QD65XX is not set
> CONFIG_BLK_DEV_UMC8672=y
> # CONFIG_BLK_DEV_IDEDMA is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=y
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_CHR_DEV_SG=y
> CONFIG_CHR_DEV_SCH=y
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> CONFIG_SCSI_FC_TGT_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> # CONFIG_SATA_PMP is not set
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> # CONFIG_ATA_PIIX is not set
> # CONFIG_SATA_HIGHBANK is not set
> CONFIG_SATA_MV=y
> # CONFIG_SATA_NV is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_RCAR is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARASAN_CF is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> CONFIG_PATA_QDI=y
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_WINBOND_VLB is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> # CONFIG_ATA_GENERIC is not set
> CONFIG_PATA_LEGACY=y
> # CONFIG_MD is not set
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> # CONFIG_NETDEVICES is not set
> CONFIG_VHOST_NET=y
> CONFIG_VHOST_RING=y
> CONFIG_VHOST=y
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> # CONFIG_INPUT_EVDEV is not set
> CONFIG_INPUT_EVBUG=y
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5588=y
> CONFIG_KEYBOARD_ADP5589=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=y
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> CONFIG_KEYBOARD_GPIO=y
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> CONFIG_KEYBOARD_TCA6416=y
> CONFIG_KEYBOARD_TCA8418=y
> CONFIG_KEYBOARD_MATRIX=y
> # CONFIG_KEYBOARD_LM8323 is not set
> CONFIG_KEYBOARD_LM8333=y
> CONFIG_KEYBOARD_MAX7359=y
> CONFIG_KEYBOARD_MCS=y
> CONFIG_KEYBOARD_MPR121=y
> CONFIG_KEYBOARD_NEWTON=y
> # CONFIG_KEYBOARD_OPENCORES is not set
> CONFIG_KEYBOARD_STOWAWAY=y
> CONFIG_KEYBOARD_SUNKBD=y
> CONFIG_KEYBOARD_STMPE=y
> CONFIG_KEYBOARD_TWL4030=y
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_INPUT_MOUSE is not set
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=y
> CONFIG_JOYSTICK_A3D=y
> # CONFIG_JOYSTICK_ADI is not set
> # CONFIG_JOYSTICK_COBRA is not set
> CONFIG_JOYSTICK_GF2K=y
> CONFIG_JOYSTICK_GRIP=y
> CONFIG_JOYSTICK_GRIP_MP=y
> CONFIG_JOYSTICK_GUILLEMOT=y
> # CONFIG_JOYSTICK_INTERACT is not set
> CONFIG_JOYSTICK_SIDEWINDER=y
> CONFIG_JOYSTICK_TMDC=y
> CONFIG_JOYSTICK_IFORCE=y
> # CONFIG_JOYSTICK_IFORCE_USB is not set
> # CONFIG_JOYSTICK_IFORCE_232 is not set
> CONFIG_JOYSTICK_WARRIOR=y
> CONFIG_JOYSTICK_MAGELLAN=y
> CONFIG_JOYSTICK_SPACEORB=y
> # CONFIG_JOYSTICK_SPACEBALL is not set
> CONFIG_JOYSTICK_STINGER=y
> # CONFIG_JOYSTICK_TWIDJOY is not set
> # CONFIG_JOYSTICK_ZHENHUA is not set
> CONFIG_JOYSTICK_DB9=y
> CONFIG_JOYSTICK_GAMECON=y
> CONFIG_JOYSTICK_TURBOGRAFX=y
> CONFIG_JOYSTICK_AS5011=y
> # CONFIG_JOYSTICK_JOYDUMP is not set
> # CONFIG_JOYSTICK_XPAD is not set
> CONFIG_INPUT_TABLET=y
> CONFIG_TABLET_USB_ACECAD=y
> CONFIG_TABLET_USB_AIPTEK=y
> CONFIG_TABLET_USB_GTCO=y
> CONFIG_TABLET_USB_HANWANG=y
> CONFIG_TABLET_USB_KBTAB=y
> # CONFIG_TABLET_USB_WACOM is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PARKBD is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_GAMEPORT=y
> # CONFIG_GAMEPORT_NS558 is not set
> CONFIG_GAMEPORT_L4=y
> # CONFIG_GAMEPORT_EMU10K1 is not set
> # CONFIG_GAMEPORT_FM801 is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> CONFIG_TRACE_ROUTER=y
> CONFIG_TRACE_SINK=y
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> # CONFIG_SERIAL_8250_SHARE_IRQ is not set
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> CONFIG_SERIAL_8250_RSA=y
> CONFIG_SERIAL_8250_DW=y
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MAX3100=y
> # CONFIG_SERIAL_MAX310X is not set
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_SERIAL_SCCNXP=y
> # CONFIG_SERIAL_SCCNXP_CONSOLE is not set
> CONFIG_SERIAL_TIMBERDALE=y
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
> # CONFIG_SERIAL_ALTERA_UART is not set
> CONFIG_SERIAL_IFX6X60=y
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> CONFIG_SERIAL_FSL_LPUART=y
> CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
> CONFIG_SERIAL_ST_ASC=y
> # CONFIG_SERIAL_ST_ASC_CONSOLE is not set
> # CONFIG_PRINTER is not set
> # CONFIG_PPDEV is not set
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> CONFIG_NVRAM=y
> CONFIG_DTLK=y
> CONFIG_R3964=y
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> CONFIG_TCG_TIS_I2C_INFINEON=y
> CONFIG_TCG_NSC=y
> CONFIG_TCG_ATMEL=y
> # CONFIG_TCG_INFINEON is not set
> CONFIG_TCG_ST33_I2C=y
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> # CONFIG_I2C_CHARDEV is not set
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> # CONFIG_I2C_MUX_GPIO is not set
> CONFIG_I2C_MUX_PCA9541=y
> # CONFIG_I2C_MUX_PCA954x is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_CBUS_GPIO is not set
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> CONFIG_I2C_GPIO=y
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=y
> # CONFIG_I2C_PARPORT is not set
> CONFIG_I2C_PARPORT_LIGHT=y
> CONFIG_I2C_TAOS_EVM=y
> CONFIG_I2C_TINY_USB=y
> CONFIG_I2C_VIPERBOARD=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_ELEKTOR=y
> CONFIG_I2C_PCA_ISA=y
> # CONFIG_SCx200_ACB is not set
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
> # CONFIG_SPI_ALTERA is not set
> # CONFIG_SPI_ATMEL is not set
> # CONFIG_SPI_BCM2835 is not set
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_BUTTERFLY=y
> CONFIG_SPI_EP93XX=y
> CONFIG_SPI_GPIO=y
> CONFIG_SPI_IMX=y
> CONFIG_SPI_LM70_LLP=y
> CONFIG_SPI_FSL_DSPI=y
> # CONFIG_SPI_OC_TINY is not set
> # CONFIG_SPI_OMAP24XX is not set
> CONFIG_SPI_TI_QSPI=y
> # CONFIG_SPI_OMAP_100K is not set
> # CONFIG_SPI_ORION is not set
> # CONFIG_SPI_PXA2XX is not set
> # CONFIG_SPI_PXA2XX_PCI is not set
> # CONFIG_SPI_SC18IS602 is not set
> CONFIG_SPI_SH=y
> # CONFIG_SPI_SH_HSPI is not set
> CONFIG_SPI_TEGRA114=y
> CONFIG_SPI_TEGRA20_SFLASH=y
> CONFIG_SPI_TEGRA20_SLINK=y
> # CONFIG_SPI_TOPCLIFF_PCH is not set
> CONFIG_SPI_TXX9=y
> CONFIG_SPI_XCOMM=y
> # CONFIG_SPI_XILINX is not set
> CONFIG_SPI_DESIGNWARE=y
> # CONFIG_SPI_DW_PCI is not set
> 
> #
> # SPI Protocol Masters
> #
> # CONFIG_SPI_SPIDEV is not set
> CONFIG_SPI_TLE62X0=y
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=y
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> # CONFIG_NTP_PPS is not set
> 
> #
> # PPS clients support
> #
> # CONFIG_PPS_CLIENT_KTIMER is not set
> CONFIG_PPS_CLIENT_LDISC=y
> CONFIG_PPS_CLIENT_PARPORT=y
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_ACPI=y
> # CONFIG_DEBUG_GPIO is not set
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_DA9055=y
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> CONFIG_GPIO_IT8761E=y
> # CONFIG_GPIO_F7188X is not set
> CONFIG_GPIO_TS5500=y
> # CONFIG_GPIO_SCH is not set
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> # CONFIG_GPIO_MAX7300 is not set
> # CONFIG_GPIO_MAX732X is not set
> CONFIG_GPIO_PCA953X=y
> CONFIG_GPIO_PCA953X_IRQ=y
> CONFIG_GPIO_PCF857X=y
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_STMPE=y
> CONFIG_GPIO_TPS65912=y
> CONFIG_GPIO_TWL4030=y
> CONFIG_GPIO_WM831X=y
> # CONFIG_GPIO_WM8994 is not set
> CONFIG_GPIO_ADP5588=y
> CONFIG_GPIO_ADP5588_IRQ=y
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> # CONFIG_GPIO_LANGWELL is not set
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> CONFIG_GPIO_MAX7301=y
> # CONFIG_GPIO_MCP23S08 is not set
> CONFIG_GPIO_MC33880=y
> CONFIG_GPIO_74X164=y
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_TPS65910=y
> 
> #
> # USB GPIO expanders:
> #
> # CONFIG_GPIO_VIPERBOARD is not set
> CONFIG_W1=y
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2490=y
> # CONFIG_W1_MASTER_DS2482 is not set
> # CONFIG_W1_MASTER_DS1WM is not set
> # CONFIG_W1_MASTER_GPIO is not set
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> CONFIG_W1_SLAVE_SMEM=y
> # CONFIG_W1_SLAVE_DS2408 is not set
> CONFIG_W1_SLAVE_DS2413=y
> # CONFIG_W1_SLAVE_DS2423 is not set
> CONFIG_W1_SLAVE_DS2431=y
> # CONFIG_W1_SLAVE_DS2433 is not set
> CONFIG_W1_SLAVE_DS2760=y
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> # CONFIG_W1_SLAVE_DS28E04 is not set
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> # CONFIG_MAX8925_POWER is not set
> # CONFIG_WM831X_BACKUP is not set
> CONFIG_WM831X_POWER=y
> # CONFIG_TEST_POWER is not set
> CONFIG_BATTERY_DS2760=y
> CONFIG_BATTERY_DS2780=y
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> CONFIG_BATTERY_BQ27X00_I2C=y
> # CONFIG_BATTERY_BQ27X00_PLATFORM is not set
> CONFIG_BATTERY_DA9030=y
> CONFIG_BATTERY_MAX17040=y
> CONFIG_BATTERY_MAX17042=y
> CONFIG_BATTERY_TWL4030_MADC=y
> CONFIG_BATTERY_RX51=y
> CONFIG_CHARGER_ISP1704=y
> CONFIG_CHARGER_MAX8903=y
> CONFIG_CHARGER_TWL4030=y
> CONFIG_CHARGER_LP8727=y
> # CONFIG_CHARGER_LP8788 is not set
> CONFIG_CHARGER_GPIO=y
> CONFIG_CHARGER_BQ2415X=y
> CONFIG_CHARGER_BQ24190=y
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_BATTERY_GOLDFISH is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=y
> CONFIG_SENSORS_ABITUGURU3=y
> CONFIG_SENSORS_AD7314=y
> CONFIG_SENSORS_AD7414=y
> CONFIG_SENSORS_AD7418=y
> # CONFIG_SENSORS_ADCXX is not set
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> CONFIG_SENSORS_ADM1031=y
> # CONFIG_SENSORS_ADM9240 is not set
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7310=y
> # CONFIG_SENSORS_ADT7410 is not set
> CONFIG_SENSORS_ADT7411=y
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> # CONFIG_SENSORS_ADT7475 is not set
> CONFIG_SENSORS_ASC7621=y
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> CONFIG_SENSORS_ASB100=y
> # CONFIG_SENSORS_ATXP1 is not set
> CONFIG_SENSORS_DS620=y
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_DA9055=y
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> CONFIG_SENSORS_F71882FG=y
> CONFIG_SENSORS_F75375S=y
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_GPIO_FAN=y
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_HTU21=y
> CONFIG_SENSORS_CORETEMP=y
> CONFIG_SENSORS_IIO_HWMON=y
> # CONFIG_SENSORS_IT87 is not set
> CONFIG_SENSORS_JC42=y
> CONFIG_SENSORS_LINEAGE=y
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM70 is not set
> CONFIG_SENSORS_LM73=y
> # CONFIG_SENSORS_LM75 is not set
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> # CONFIG_SENSORS_LM80 is not set
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> # CONFIG_SENSORS_LM87 is not set
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> CONFIG_SENSORS_LM93=y
> # CONFIG_SENSORS_LTC4151 is not set
> CONFIG_SENSORS_LTC4215=y
> # CONFIG_SENSORS_LTC4245 is not set
> CONFIG_SENSORS_LTC4261=y
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> # CONFIG_SENSORS_LM95245 is not set
> CONFIG_SENSORS_MAX1111=y
> CONFIG_SENSORS_MAX16065=y
> # CONFIG_SENSORS_MAX1619 is not set
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> CONFIG_SENSORS_MAX6650=y
> CONFIG_SENSORS_MAX6697=y
> CONFIG_SENSORS_MCP3021=y
> # CONFIG_SENSORS_NCT6775 is not set
> # CONFIG_SENSORS_PC87360 is not set
> CONFIG_SENSORS_PC87427=y
> # CONFIG_SENSORS_PCF8591 is not set
> CONFIG_PMBUS=y
> CONFIG_SENSORS_PMBUS=y
> CONFIG_SENSORS_ADM1275=y
> CONFIG_SENSORS_LM25066=y
> CONFIG_SENSORS_LTC2978=y
> # CONFIG_SENSORS_MAX16064 is not set
> # CONFIG_SENSORS_MAX34440 is not set
> # CONFIG_SENSORS_MAX8688 is not set
> CONFIG_SENSORS_UCD9000=y
> CONFIG_SENSORS_UCD9200=y
> CONFIG_SENSORS_ZL6100=y
> # CONFIG_SENSORS_SHT15 is not set
> CONFIG_SENSORS_SHT21=y
> # CONFIG_SENSORS_SIS5595 is not set
> CONFIG_SENSORS_SMM665=y
> CONFIG_SENSORS_DME1737=y
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=y
> # CONFIG_SENSORS_EMC6W201 is not set
> CONFIG_SENSORS_SMSC47M1=y
> # CONFIG_SENSORS_SMSC47M192 is not set
> CONFIG_SENSORS_SMSC47B397=y
> CONFIG_SENSORS_SCH56XX_COMMON=y
> CONFIG_SENSORS_SCH5627=y
> CONFIG_SENSORS_SCH5636=y
> CONFIG_SENSORS_ADS1015=y
> # CONFIG_SENSORS_ADS7828 is not set
> CONFIG_SENSORS_ADS7871=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> # CONFIG_SENSORS_INA2XX is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> CONFIG_SENSORS_TMP401=y
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_TWL4030_MADC=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> CONFIG_SENSORS_W83781D=y
> # CONFIG_SENSORS_W83791D is not set
> CONFIG_SENSORS_W83792D=y
> # CONFIG_SENSORS_W83793 is not set
> CONFIG_SENSORS_W83795=y
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> CONFIG_SENSORS_WM831X=y
> CONFIG_SENSORS_APPLESMC=y
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_GOV_STEP_WISE is not set
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> CONFIG_WATCHDOG_NOWAYOUT=y
> 
> #
> # Watchdog Device Drivers
> #
> # CONFIG_SOFT_WATCHDOG is not set
> # CONFIG_DA9055_WATCHDOG is not set
> CONFIG_WM831X_WATCHDOG=y
> CONFIG_TWL4030_WATCHDOG=y
> CONFIG_ACQUIRE_WDT=y
> # CONFIG_ADVANTECH_WDT is not set
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> # CONFIG_F71808E_WDT is not set
> # CONFIG_SP5100_TCO is not set
> CONFIG_SC520_WDT=y
> # CONFIG_SBC_FITPC2_WATCHDOG is not set
> # CONFIG_EUROTECH_WDT is not set
> CONFIG_IB700_WDT=y
> CONFIG_IBMASR=y
> # CONFIG_WAFER_WDT is not set
> # CONFIG_I6300ESB_WDT is not set
> # CONFIG_IE6XX_WDT is not set
> # CONFIG_ITCO_WDT is not set
> CONFIG_IT8712F_WDT=y
> CONFIG_IT87_WDT=y
> # CONFIG_HP_WATCHDOG is not set
> CONFIG_SC1200_WDT=y
> CONFIG_PC87413_WDT=y
> # CONFIG_NV_TCO is not set
> # CONFIG_60XX_WDT is not set
> CONFIG_SBC8360_WDT=y
> CONFIG_SBC7240_WDT=y
> CONFIG_CPU5_WDT=y
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> # CONFIG_VIA_WDT is not set
> # CONFIG_W83627HF_WDT is not set
> # CONFIG_W83697HF_WDT is not set
> CONFIG_W83697UG_WDT=y
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=y
> # CONFIG_MACHZ_WDT is not set
> CONFIG_SBC_EPX_C3_WATCHDOG=y
> CONFIG_MEN_A21_WDT=y
> 
> #
> # ISA-based Watchdog Cards
> #
> # CONFIG_PCWATCHDOG is not set
> CONFIG_MIXCOMWD=y
> # CONFIG_WDT is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> 
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> # CONFIG_SSB_DEBUG is not set
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> # CONFIG_SSB_DRIVER_PCICORE is not set
> # CONFIG_SSB_DRIVER_GPIO is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> CONFIG_BCMA_HOST_SOC=y
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> CONFIG_MFD_AS3711=y
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_AAT2870_CORE is not set
> # CONFIG_MFD_CROS_EC is not set
> CONFIG_PMIC_DA903X=y
> # CONFIG_MFD_DA9052_SPI is not set
> # CONFIG_MFD_DA9052_I2C is not set
> CONFIG_MFD_DA9055=y
> # CONFIG_MFD_DA9063 is not set
> # CONFIG_MFD_MC13XXX_SPI is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_KEMPLD is not set
> CONFIG_MFD_88PM800=y
> CONFIG_MFD_88PM805=y
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_MAX77686 is not set
> CONFIG_MFD_MAX77693=y
> # CONFIG_MFD_MAX8907 is not set
> CONFIG_MFD_MAX8925=y
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> CONFIG_EZX_PCAP=y
> CONFIG_MFD_VIPERBOARD=y
> # CONFIG_MFD_RETU is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_SEC_CORE is not set
> CONFIG_MFD_SI476X_CORE=y
> # CONFIG_MFD_SM501 is not set
> CONFIG_MFD_SMSC=y
> CONFIG_ABX500_CORE=y
> # CONFIG_AB3100_CORE is not set
> CONFIG_MFD_STMPE=y
> 
> #
> # STMicroelectronics STMPE Interface Drivers
> #
> CONFIG_STMPE_I2C=y
> # CONFIG_STMPE_SPI is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> CONFIG_MFD_LP8788=y
> # CONFIG_MFD_PALMAS is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> # CONFIG_MFD_TPS6586X is not set
> CONFIG_MFD_TPS65910=y
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> # CONFIG_MFD_TPS65912_SPI is not set
> CONFIG_MFD_TPS80031=y
> CONFIG_TWL4030_CORE=y
> CONFIG_TWL4030_MADC=y
> CONFIG_MFD_TWL4030_AUDIO=y
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_LM3533=y
> # CONFIG_MFD_TIMBERDALE is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> # CONFIG_MFD_ARIZONA_SPI is not set
> # CONFIG_MFD_WM5102 is not set
> # CONFIG_MFD_WM5110 is not set
> # CONFIG_MFD_WM8997 is not set
> CONFIG_MFD_WM8400=y
> CONFIG_MFD_WM831X=y
> # CONFIG_MFD_WM831X_I2C is not set
> CONFIG_MFD_WM831X_SPI=y
> # CONFIG_MFD_WM8350_I2C is not set
> CONFIG_MFD_WM8994=y
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> CONFIG_REGULATOR_DUMMY=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_88PM800=y
> CONFIG_REGULATOR_AD5398=y
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_AS3711=y
> CONFIG_REGULATOR_DA903X=y
> CONFIG_REGULATOR_DA9055=y
> # CONFIG_REGULATOR_DA9210 is not set
> # CONFIG_REGULATOR_FAN53555 is not set
> CONFIG_REGULATOR_GPIO=y
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_LP3972 is not set
> CONFIG_REGULATOR_LP872X=y
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_LP8788=y
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8649=y
> CONFIG_REGULATOR_MAX8660=y
> # CONFIG_REGULATOR_MAX8925 is not set
> # CONFIG_REGULATOR_MAX8952 is not set
> CONFIG_REGULATOR_MAX8973=y
> # CONFIG_REGULATOR_MAX8998 is not set
> CONFIG_REGULATOR_MAX77693=y
> # CONFIG_REGULATOR_PCAP is not set
> CONFIG_REGULATOR_PFUZE100=y
> CONFIG_REGULATOR_TPS51632=y
> # CONFIG_REGULATOR_TPS62360 is not set
> # CONFIG_REGULATOR_TPS65023 is not set
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65217=y
> CONFIG_REGULATOR_TPS6524X=y
> # CONFIG_REGULATOR_TPS65910 is not set
> CONFIG_REGULATOR_TPS65912=y
> CONFIG_REGULATOR_TPS80031=y
> CONFIG_REGULATOR_TWL4030=y
> CONFIG_REGULATOR_WM831X=y
> CONFIG_REGULATOR_WM8400=y
> # CONFIG_REGULATOR_WM8994 is not set
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> # CONFIG_MEDIA_CAMERA_SUPPORT is not set
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
> CONFIG_MEDIA_RADIO_SUPPORT=y
> # CONFIG_MEDIA_RC_SUPPORT is not set
> CONFIG_VIDEO_DEV=y
> CONFIG_VIDEO_V4L2=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> # CONFIG_VIDEO_V4L2_INT_DEVICE is not set
> CONFIG_DVB_CORE=y
> # CONFIG_DVB_NET is not set
> # CONFIG_TTPCI_EEPROM is not set
> CONFIG_DVB_MAX_ADAPTERS=8
> CONFIG_DVB_DYNAMIC_MINORS=y
> 
> #
> # Media drivers
> #
> # CONFIG_MEDIA_USB_SUPPORT is not set
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> # CONFIG_RADIO_ADAPTERS is not set
> CONFIG_CYPRESS_FIRMWARE=y
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
> 
> #
> # Encoders, decoders, sensors and other helper chips
> #
> 
> #
> # Audio decoders, processors and mixers
> #
> # CONFIG_VIDEO_TVAUDIO is not set
> CONFIG_VIDEO_TDA7432=y
> CONFIG_VIDEO_TDA9840=y
> # CONFIG_VIDEO_TEA6415C is not set
> CONFIG_VIDEO_TEA6420=y
> CONFIG_VIDEO_MSP3400=y
> # CONFIG_VIDEO_CS5345 is not set
> CONFIG_VIDEO_CS53L32A=y
> # CONFIG_VIDEO_TLV320AIC23B is not set
> # CONFIG_VIDEO_UDA1342 is not set
> # CONFIG_VIDEO_WM8775 is not set
> # CONFIG_VIDEO_WM8739 is not set
> # CONFIG_VIDEO_VP27SMPX is not set
> CONFIG_VIDEO_SONY_BTF_MPX=y
> 
> #
> # RDS decoders
> #
> CONFIG_VIDEO_SAA6588=y
> 
> #
> # Video decoders
> #
> # CONFIG_VIDEO_ADV7180 is not set
> CONFIG_VIDEO_ADV7183=y
> CONFIG_VIDEO_BT819=y
> # CONFIG_VIDEO_BT856 is not set
> # CONFIG_VIDEO_BT866 is not set
> # CONFIG_VIDEO_KS0127 is not set
> CONFIG_VIDEO_ML86V7667=y
> CONFIG_VIDEO_SAA7110=y
> # CONFIG_VIDEO_SAA711X is not set
> CONFIG_VIDEO_SAA7191=y
> CONFIG_VIDEO_TVP514X=y
> CONFIG_VIDEO_TVP5150=y
> # CONFIG_VIDEO_TVP7002 is not set
> # CONFIG_VIDEO_TW2804 is not set
> # CONFIG_VIDEO_TW9903 is not set
> CONFIG_VIDEO_TW9906=y
> CONFIG_VIDEO_VPX3220=y
> 
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_SAA717X=y
> # CONFIG_VIDEO_CX25840 is not set
> 
> #
> # Video encoders
> #
> CONFIG_VIDEO_SAA7127=y
> CONFIG_VIDEO_SAA7185=y
> CONFIG_VIDEO_ADV7170=y
> CONFIG_VIDEO_ADV7175=y
> # CONFIG_VIDEO_ADV7343 is not set
> # CONFIG_VIDEO_ADV7393 is not set
> CONFIG_VIDEO_AK881X=y
> CONFIG_VIDEO_THS8200=y
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
> CONFIG_VIDEO_UPD64031A=y
> CONFIG_VIDEO_UPD64083=y
> 
> #
> # Miscelaneous helper chips
> #
> CONFIG_VIDEO_THS7303=y
> # CONFIG_VIDEO_M52790 is not set
> 
> #
> # Sensors used on soc_camera driver
> #
> CONFIG_MEDIA_TUNER=y
> 
> #
> # Customize TV tuners
> #
> # CONFIG_MEDIA_TUNER_SIMPLE is not set
> CONFIG_MEDIA_TUNER_TDA8290=y
> CONFIG_MEDIA_TUNER_TDA827X=y
> CONFIG_MEDIA_TUNER_TDA18271=y
> CONFIG_MEDIA_TUNER_TDA9887=y
> # CONFIG_MEDIA_TUNER_TEA5761 is not set
> # CONFIG_MEDIA_TUNER_TEA5767 is not set
> CONFIG_MEDIA_TUNER_MT20XX=y
> # CONFIG_MEDIA_TUNER_MT2060 is not set
> CONFIG_MEDIA_TUNER_MT2063=y
> CONFIG_MEDIA_TUNER_MT2266=y
> CONFIG_MEDIA_TUNER_MT2131=y
> CONFIG_MEDIA_TUNER_QT1010=y
> # CONFIG_MEDIA_TUNER_XC2028 is not set
> CONFIG_MEDIA_TUNER_XC5000=y
> CONFIG_MEDIA_TUNER_XC4000=y
> CONFIG_MEDIA_TUNER_MXL5005S=y
> CONFIG_MEDIA_TUNER_MXL5007T=y
> # CONFIG_MEDIA_TUNER_MC44S803 is not set
> CONFIG_MEDIA_TUNER_MAX2165=y
> CONFIG_MEDIA_TUNER_TDA18218=y
> CONFIG_MEDIA_TUNER_FC0011=y
> CONFIG_MEDIA_TUNER_FC0012=y
> CONFIG_MEDIA_TUNER_FC0013=y
> # CONFIG_MEDIA_TUNER_TDA18212 is not set
> # CONFIG_MEDIA_TUNER_E4000 is not set
> CONFIG_MEDIA_TUNER_FC2580=y
> # CONFIG_MEDIA_TUNER_TUA9001 is not set
> # CONFIG_MEDIA_TUNER_IT913X is not set
> CONFIG_MEDIA_TUNER_R820T=y
> 
> #
> # Customise DVB Frontends
> #
> 
> #
> # Multistandard (satellite) frontends
> #
> # CONFIG_DVB_STB0899 is not set
> CONFIG_DVB_STB6100=y
> # CONFIG_DVB_STV090x is not set
> CONFIG_DVB_STV6110x=y
> 
> #
> # Multistandard (cable + terrestrial) frontends
> #
> CONFIG_DVB_DRXK=y
> # CONFIG_DVB_TDA18271C2DD is not set
> 
> #
> # DVB-S (satellite) frontends
> #
> CONFIG_DVB_CX24110=y
> # CONFIG_DVB_CX24123 is not set
> CONFIG_DVB_MT312=y
> CONFIG_DVB_ZL10036=y
> CONFIG_DVB_ZL10039=y
> CONFIG_DVB_S5H1420=y
> CONFIG_DVB_STV0288=y
> CONFIG_DVB_STB6000=y
> # CONFIG_DVB_STV0299 is not set
> CONFIG_DVB_STV6110=y
> # CONFIG_DVB_STV0900 is not set
> CONFIG_DVB_TDA8083=y
> CONFIG_DVB_TDA10086=y
> # CONFIG_DVB_TDA8261 is not set
> CONFIG_DVB_VES1X93=y
> CONFIG_DVB_TUNER_ITD1000=y
> CONFIG_DVB_TUNER_CX24113=y
> # CONFIG_DVB_TDA826X is not set
> # CONFIG_DVB_TUA6100 is not set
> CONFIG_DVB_CX24116=y
> # CONFIG_DVB_SI21XX is not set
> # CONFIG_DVB_TS2020 is not set
> CONFIG_DVB_DS3000=y
> # CONFIG_DVB_MB86A16 is not set
> # CONFIG_DVB_TDA10071 is not set
> 
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP8870=y
> CONFIG_DVB_SP887X=y
> CONFIG_DVB_CX22700=y
> # CONFIG_DVB_CX22702 is not set
> CONFIG_DVB_S5H1432=y
> CONFIG_DVB_DRXD=y
> CONFIG_DVB_L64781=y
> CONFIG_DVB_TDA1004X=y
> # CONFIG_DVB_NXT6000 is not set
> # CONFIG_DVB_MT352 is not set
> CONFIG_DVB_ZL10353=y
> # CONFIG_DVB_DIB3000MB is not set
> CONFIG_DVB_DIB3000MC=y
> # CONFIG_DVB_DIB7000M is not set
> CONFIG_DVB_DIB7000P=y
> CONFIG_DVB_DIB9000=y
> CONFIG_DVB_TDA10048=y
> # CONFIG_DVB_AF9013 is not set
> CONFIG_DVB_EC100=y
> CONFIG_DVB_HD29L2=y
> # CONFIG_DVB_STV0367 is not set
> CONFIG_DVB_CXD2820R=y
> CONFIG_DVB_RTL2830=y
> CONFIG_DVB_RTL2832=y
> 
> #
> # DVB-C (cable) frontends
> #
> # CONFIG_DVB_VES1820 is not set
> CONFIG_DVB_TDA10021=y
> # CONFIG_DVB_TDA10023 is not set
> CONFIG_DVB_STV0297=y
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=y
> # CONFIG_DVB_OR51211 is not set
> # CONFIG_DVB_OR51132 is not set
> CONFIG_DVB_BCM3510=y
> CONFIG_DVB_LGDT330X=y
> CONFIG_DVB_LGDT3305=y
> # CONFIG_DVB_LG2160 is not set
> CONFIG_DVB_S5H1409=y
> CONFIG_DVB_AU8522=y
> CONFIG_DVB_AU8522_DTV=y
> # CONFIG_DVB_AU8522_V4L is not set
> CONFIG_DVB_S5H1411=y
> 
> #
> # ISDB-T (terrestrial) frontends
> #
> # CONFIG_DVB_S921 is not set
> CONFIG_DVB_DIB8000=y
> CONFIG_DVB_MB86A20S=y
> 
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=y
> CONFIG_DVB_TUNER_DIB0070=y
> CONFIG_DVB_TUNER_DIB0090=y
> 
> #
> # SEC control devices for DVB-S
> #
> # CONFIG_DVB_LNBP21 is not set
> # CONFIG_DVB_LNBP22 is not set
> CONFIG_DVB_ISL6405=y
> CONFIG_DVB_ISL6421=y
> # CONFIG_DVB_ISL6423 is not set
> CONFIG_DVB_A8293=y
> # CONFIG_DVB_LGS8GL5 is not set
> # CONFIG_DVB_LGS8GXX is not set
> # CONFIG_DVB_ATBM8830 is not set
> # CONFIG_DVB_TDA665x is not set
> CONFIG_DVB_IX2505V=y
> CONFIG_DVB_IT913X_FE=y
> # CONFIG_DVB_M88RS2000 is not set
> # CONFIG_DVB_AF9033 is not set
> 
> #
> # Tools to develop new frontends
> #
> CONFIG_DVB_DUMMY_FE=y
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> # CONFIG_FB is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> CONFIG_BACKLIGHT_LM3533=y
> # CONFIG_BACKLIGHT_DA903X is not set
> CONFIG_BACKLIGHT_MAX8925=y
> # CONFIG_BACKLIGHT_APPLE is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> # CONFIG_BACKLIGHT_LM3630 is not set
> # CONFIG_BACKLIGHT_LM3639 is not set
> # CONFIG_BACKLIGHT_LP855X is not set
> CONFIG_BACKLIGHT_LP8788=y
> # CONFIG_BACKLIGHT_PANDORA is not set
> CONFIG_BACKLIGHT_TPS65217=y
> # CONFIG_BACKLIGHT_AS3711 is not set
> CONFIG_BACKLIGHT_GPIO=y
> # CONFIG_BACKLIGHT_LV5207LP is not set
> CONFIG_BACKLIGHT_BD6107=y
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_MDA_CONSOLE=y
> CONFIG_DUMMY_CONSOLE=y
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> CONFIG_HIDRAW=y
> CONFIG_UHID=y
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_APPLEIR=y
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CYPRESS=y
> CONFIG_HID_DRAGONRISE=y
> # CONFIG_DRAGONRISE_FF is not set
> CONFIG_HID_EMS_FF=y
> CONFIG_HID_ELECOM=y
> # CONFIG_HID_ELO is not set
> CONFIG_HID_EZKEY=y
> # CONFIG_HID_HOLTEK is not set
> CONFIG_HID_HUION=y
> CONFIG_HID_KEYTOUCH=y
> # CONFIG_HID_KYE is not set
> CONFIG_HID_UCLOGIC=y
> CONFIG_HID_WALTOP=y
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> # CONFIG_HID_LCPOWER is not set
> CONFIG_HID_LENOVO_TPKBD=y
> CONFIG_HID_LOGITECH=y
> # CONFIG_HID_LOGITECH_DJ is not set
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_LOGIG940_FF=y
> # CONFIG_LOGIWHEELS_FF is not set
> CONFIG_HID_MAGICMOUSE=y
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> # CONFIG_HID_MULTITOUCH is not set
> CONFIG_HID_NTRIG=y
> CONFIG_HID_ORTEK=y
> CONFIG_HID_PANTHERLORD=y
> # CONFIG_PANTHERLORD_FF is not set
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LEDS=y
> # CONFIG_HID_PRIMAX is not set
> CONFIG_HID_ROCCAT=y
> CONFIG_HID_SAITEK=y
> CONFIG_HID_SAMSUNG=y
> # CONFIG_HID_SONY is not set
> CONFIG_HID_SPEEDLINK=y
> CONFIG_HID_STEELSERIES=y
> CONFIG_HID_SUNPLUS=y
> # CONFIG_HID_GREENASIA is not set
> CONFIG_HID_SMARTJOYPLUS=y
> CONFIG_SMARTJOYPLUS_FF=y
> # CONFIG_HID_TIVO is not set
> CONFIG_HID_TOPSEED=y
> CONFIG_HID_THINGM=y
> # CONFIG_HID_THRUSTMASTER is not set
> CONFIG_HID_WACOM=y
> # CONFIG_HID_WIIMOTE is not set
> # CONFIG_HID_XINMO is not set
> # CONFIG_HID_ZEROPLUS is not set
> CONFIG_HID_ZYDACRON=y
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=y
> CONFIG_HID_PID=y
> CONFIG_USB_HIDDEV=y
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=y
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> # CONFIG_USB_DEFAULT_PERSIST is not set
> CONFIG_USB_DYNAMIC_MINORS=y
> # CONFIG_USB_OTG is not set
> CONFIG_USB_MON=y
> # CONFIG_USB_WUSB_CBAF is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_XHCI_PLATFORM=y
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_PCI=y
> CONFIG_USB_EHCI_HCD_PLATFORM=y
> # CONFIG_USB_OXU210HP_HCD is not set
> CONFIG_USB_ISP116X_HCD=y
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_FUSBH200_HCD=y
> CONFIG_USB_FOTG210_HCD=y
> CONFIG_USB_OHCI_HCD=y
> CONFIG_USB_OHCI_HCD_PCI=y
> CONFIG_USB_OHCI_HCD_SSB=y
> CONFIG_USB_OHCI_HCD_PLATFORM=y
> # CONFIG_USB_UHCI_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> CONFIG_USB_R8A66597_HCD=y
> CONFIG_USB_RENESAS_USBHS_HCD=y
> # CONFIG_USB_HCD_BCMA is not set
> CONFIG_USB_HCD_SSB=y
> CONFIG_USB_HCD_TEST_MODE=y
> CONFIG_USB_MUSB_HDRC=y
> CONFIG_USB_MUSB_HOST=y
> # CONFIG_USB_MUSB_GADGET is not set
> # CONFIG_USB_MUSB_DUAL_ROLE is not set
> CONFIG_USB_MUSB_TUSB6010=y
> # CONFIG_USB_MUSB_UX500 is not set
> CONFIG_MUSB_PIO_ONLY=y
> CONFIG_USB_RENESAS_USBHS=y
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=y
> CONFIG_USB_PRINTER=y
> CONFIG_USB_WDM=y
> CONFIG_USB_TMC=y
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> # CONFIG_USB_STORAGE is not set
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=y
> # CONFIG_USB_MICROTEK is not set
> CONFIG_USB_DWC3=y
> CONFIG_USB_DWC3_HOST=y
> # CONFIG_USB_DWC3_GADGET is not set
> # CONFIG_USB_DWC3_DUAL_ROLE is not set
> 
> #
> # Platform Glue Driver Support
> #
> # CONFIG_USB_DWC3_OMAP is not set
> # CONFIG_USB_DWC3_EXYNOS is not set
> CONFIG_USB_DWC3_PCI=y
> 
> #
> # Debugging features
> #
> CONFIG_USB_DWC3_DEBUG=y
> # CONFIG_USB_DWC3_VERBOSE is not set
> CONFIG_USB_CHIPIDEA=y
> # CONFIG_USB_CHIPIDEA_UDC is not set
> CONFIG_USB_CHIPIDEA_HOST=y
> # CONFIG_USB_CHIPIDEA_DEBUG is not set
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=y
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=y
> CONFIG_USB_EMI26=y
> # CONFIG_USB_ADUTUX is not set
> CONFIG_USB_SEVSEG=y
> CONFIG_USB_RIO500=y
> CONFIG_USB_LEGOTOWER=y
> CONFIG_USB_LCD=y
> CONFIG_USB_LED=y
> CONFIG_USB_CYPRESS_CY7C63=y
> CONFIG_USB_CYTHERM=y
> CONFIG_USB_IDMOUSE=y
> # CONFIG_USB_FTDI_ELAN is not set
> CONFIG_USB_APPLEDISPLAY=y
> CONFIG_USB_SISUSBVGA=y
> # CONFIG_USB_SISUSBVGA_CON is not set
> CONFIG_USB_LD=y
> CONFIG_USB_TRANCEVIBRATOR=y
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> CONFIG_USB_EHSET_TEST_FIXTURE=y
> CONFIG_USB_ISIGHTFW=y
> CONFIG_USB_YUREX=y
> CONFIG_USB_EZUSB_FX2=y
> # CONFIG_USB_HSIC_USB3503 is not set
> 
> #
> # USB Physical Layer drivers
> #
> CONFIG_USB_PHY=y
> CONFIG_NOP_USB_XCEIV=y
> CONFIG_OMAP_CONTROL_USB=y
> CONFIG_OMAP_USB3=y
> CONFIG_AM335X_CONTROL_USB=y
> CONFIG_AM335X_PHY_USB=y
> CONFIG_SAMSUNG_USBPHY=y
> CONFIG_SAMSUNG_USB2PHY=y
> CONFIG_SAMSUNG_USB3PHY=y
> # CONFIG_USB_GPIO_VBUS is not set
> CONFIG_USB_ISP1301=y
> # CONFIG_USB_RCAR_PHY is not set
> CONFIG_USB_GADGET=y
> # CONFIG_USB_GADGET_DEBUG is not set
> CONFIG_USB_GADGET_DEBUG_FILES=y
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
> 
> #
> # USB Peripheral Controller
> #
> CONFIG_USB_FOTG210_UDC=y
> CONFIG_USB_R8A66597=y
> CONFIG_USB_RENESAS_USBHS_UDC=y
> # CONFIG_USB_PXA27X is not set
> CONFIG_USB_MV_UDC=y
> # CONFIG_USB_MV_U3D is not set
> CONFIG_USB_M66592=y
> # CONFIG_USB_AMD5536UDC is not set
> CONFIG_USB_NET2272=y
> # CONFIG_USB_NET2272_DMA is not set
> # CONFIG_USB_NET2280 is not set
> # CONFIG_USB_GOKU is not set
> # CONFIG_USB_EG20T is not set
> CONFIG_USB_DUMMY_HCD=y
> CONFIG_USB_LIBCOMPOSITE=y
> CONFIG_USB_U_ETHER=y
> CONFIG_USB_F_NCM=y
> # CONFIG_USB_CONFIGFS is not set
> # CONFIG_USB_ZERO is not set
> # CONFIG_USB_ETH is not set
> CONFIG_USB_G_NCM=y
> # CONFIG_USB_GADGETFS is not set
> # CONFIG_USB_FUNCTIONFS is not set
> # CONFIG_USB_MASS_STORAGE is not set
> # CONFIG_USB_G_SERIAL is not set
> # CONFIG_USB_G_PRINTER is not set
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_NOKIA is not set
> # CONFIG_USB_G_ACM_MS is not set
> # CONFIG_USB_G_MULTI is not set
> # CONFIG_USB_G_HID is not set
> # CONFIG_USB_G_DBGP is not set
> # CONFIG_USB_G_WEBCAM is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> CONFIG_MEMSTICK=y
> CONFIG_MEMSTICK_DEBUG=y
> 
> #
> # MemoryStick drivers
> #
> CONFIG_MEMSTICK_UNSAFE_RESUME=y
> # CONFIG_MSPRO_BLOCK is not set
> CONFIG_MS_BLOCK=y
> 
> #
> # MemoryStick Host Controller Drivers
> #
> # CONFIG_MEMSTICK_TIFM_MS is not set
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> # CONFIG_MEMSTICK_R592 is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=y
> CONFIG_LEDS_LM3533=y
> CONFIG_LEDS_LM3642=y
> CONFIG_LEDS_PCA9532=y
> # CONFIG_LEDS_PCA9532_GPIO is not set
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> # CONFIG_LEDS_LP8501 is not set
> CONFIG_LEDS_LP8788=y
> # CONFIG_LEDS_CLEVO_MAIL is not set
> CONFIG_LEDS_PCA955X=y
> CONFIG_LEDS_PCA963X=y
> CONFIG_LEDS_WM831X_STATUS=y
> CONFIG_LEDS_DA903X=y
> CONFIG_LEDS_DAC124S085=y
> CONFIG_LEDS_REGULATOR=y
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_INTEL_SS4200 is not set
> CONFIG_LEDS_LT3593=y
> CONFIG_LEDS_TCA6507=y
> CONFIG_LEDS_LM355x=y
> CONFIG_LEDS_OT200=y
> CONFIG_LEDS_BLINKM=y
> 
> #
> # LED Triggers
> #
> # CONFIG_LEDS_TRIGGERS is not set
> CONFIG_ACCESSIBILITY=y
> # CONFIG_A11Y_BRAILLE_CONSOLE is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_MM_EDAC=y
> # CONFIG_EDAC_AMD76X is not set
> # CONFIG_EDAC_E7XXX is not set
> # CONFIG_EDAC_E752X is not set
> # CONFIG_EDAC_I82875P is not set
> # CONFIG_EDAC_I82975X is not set
> # CONFIG_EDAC_I3000 is not set
> # CONFIG_EDAC_I3200 is not set
> # CONFIG_EDAC_X38 is not set
> # CONFIG_EDAC_I5400 is not set
> # CONFIG_EDAC_I82860 is not set
> # CONFIG_EDAC_R82600 is not set
> # CONFIG_EDAC_I5000 is not set
> # CONFIG_EDAC_I5100 is not set
> # CONFIG_EDAC_I7300 is not set
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> CONFIG_DMADEVICES=y
> CONFIG_DMADEVICES_DEBUG=y
> CONFIG_DMADEVICES_VDEBUG=y
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> # CONFIG_INTEL_IOATDMA is not set
> # CONFIG_DW_DMAC_CORE is not set
> # CONFIG_DW_DMAC is not set
> # CONFIG_DW_DMAC_PCI is not set
> CONFIG_TIMB_DMA=y
> # CONFIG_PCH_DMA is not set
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> 
> #
> # DMA Clients
> #
> # CONFIG_NET_DMA is not set
> # CONFIG_ASYNC_TX_DMA is not set
> CONFIG_DMATEST=y
> CONFIG_AUXDISPLAY=y
> CONFIG_KS0108=y
> CONFIG_KS0108_PORT=0x378
> CONFIG_KS0108_DELAY=2
> # CONFIG_UIO is not set
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_MMIO=y
> CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> CONFIG_STAGING=y
> # CONFIG_SLICOSS is not set
> CONFIG_USBIP_CORE=y
> CONFIG_USBIP_VHCI_HCD=y
> CONFIG_USBIP_HOST=y
> CONFIG_USBIP_DEBUG=y
> CONFIG_ECHO=y
> CONFIG_PANEL=y
> CONFIG_PANEL_PARPORT=0
> CONFIG_PANEL_PROFILE=5
> # CONFIG_PANEL_CHANGE_MESSAGE is not set
> CONFIG_RTS5139=y
> CONFIG_RTS5139_DEBUG=y
> CONFIG_TRANZPORT=y
> # CONFIG_IDE_PHISON is not set
> # CONFIG_DX_SEP is not set
> 
> #
> # IIO staging drivers
> #
> 
> #
> # Accelerometers
> #
> CONFIG_ADIS16201=y
> CONFIG_ADIS16203=y
> # CONFIG_ADIS16204 is not set
> CONFIG_ADIS16209=y
> # CONFIG_ADIS16220 is not set
> # CONFIG_ADIS16240 is not set
> # CONFIG_LIS3L02DQ is not set
> CONFIG_SCA3000=y
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD7291=y
> CONFIG_AD7606=y
> CONFIG_AD7606_IFACE_PARALLEL=y
> CONFIG_AD7606_IFACE_SPI=y
> CONFIG_AD799X=y
> CONFIG_AD799X_RING_BUFFER=y
> CONFIG_AD7780=y
> # CONFIG_AD7816 is not set
> CONFIG_AD7192=y
> CONFIG_AD7280=y
> 
> #
> # Analog digital bi-direction converters
> #
> CONFIG_ADT7316=y
> CONFIG_ADT7316_SPI=y
> # CONFIG_ADT7316_I2C is not set
> 
> #
> # Capacitance to digital converters
> #
> CONFIG_AD7150=y
> CONFIG_AD7152=y
> CONFIG_AD7746=y
> 
> #
> # Direct Digital Synthesis
> #
> # CONFIG_AD5930 is not set
> CONFIG_AD9832=y
> CONFIG_AD9834=y
> CONFIG_AD9850=y
> CONFIG_AD9852=y
> CONFIG_AD9910=y
> # CONFIG_AD9951 is not set
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_ADIS16060=y
> 
> #
> # Network Analyzer, Impedance Converters
> #
> CONFIG_AD5933=y
> 
> #
> # Light sensors
> #
> CONFIG_SENSORS_ISL29018=y
> # CONFIG_SENSORS_ISL29028 is not set
> CONFIG_TSL2583=y
> CONFIG_TSL2x7x=y
> 
> #
> # Magnetometer sensors
> #
> CONFIG_SENSORS_HMC5843=y
> 
> #
> # Active energy metering IC
> #
> CONFIG_ADE7753=y
> CONFIG_ADE7754=y
> CONFIG_ADE7758=y
> CONFIG_ADE7759=y
> CONFIG_ADE7854=y
> # CONFIG_ADE7854_I2C is not set
> CONFIG_ADE7854_SPI=y
> 
> #
> # Resolver to digital converters
> #
> # CONFIG_AD2S90 is not set
> CONFIG_AD2S1200=y
> CONFIG_AD2S1210=y
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_DUMMY_EVGEN=y
> CONFIG_IIO_SIMPLE_DUMMY=y
> CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
> # CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
> CONFIG_ZSMALLOC=y
> CONFIG_ZRAM=y
> CONFIG_ZRAM_DEBUG=y
> # CONFIG_CRYSTALHD is not set
> # CONFIG_ACPI_QUICKSTART is not set
> CONFIG_BCM_WIMAX=y
> # CONFIG_FT1000 is not set
> 
> #
> # Speakup console speech
> #
> # CONFIG_SPEAKUP is not set
> CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
> # CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
> CONFIG_STAGING_MEDIA=y
> # CONFIG_DVB_AS102 is not set
> # CONFIG_DVB_CXD2099 is not set
> # CONFIG_VIDEO_DT3155 is not set
> # CONFIG_USB_MSI3101 is not set
> 
> #
> # Android
> #
> CONFIG_ANDROID=y
> # CONFIG_ANDROID_BINDER_IPC is not set
> # CONFIG_ASHMEM is not set
> CONFIG_ANDROID_LOGGER=y
> CONFIG_ANDROID_TIMED_OUTPUT=y
> CONFIG_ANDROID_TIMED_GPIO=y
> CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> # CONFIG_SYNC is not set
> # CONFIG_USB_WPAN_HCD is not set
> CONFIG_WIMAX_GDM72XX=y
> CONFIG_WIMAX_GDM72XX_QOS=y
> CONFIG_WIMAX_GDM72XX_K_MODE=y
> # CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
> CONFIG_WIMAX_GDM72XX_USB=y
> CONFIG_WIMAX_GDM72XX_USB_PM=y
> CONFIG_CED1401=y
> CONFIG_DGRP=y
> CONFIG_USB_DWC2=y
> CONFIG_USB_DWC2_DEBUG=y
> CONFIG_USB_DWC2_VERBOSE=y
> CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
> CONFIG_USB_DWC2_DEBUG_PERIODIC=y
> # CONFIG_XILLYBUS is not set
> # CONFIG_DGNC is not set
> CONFIG_DGAP=y
> # CONFIG_X86_PLATFORM_DEVICES is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_MAILBOX is not set
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> CONFIG_STE_MODEM_RPROC=y
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_GPIO=y
> # CONFIG_EXTCON_ADC_JACK is not set
> CONFIG_EXTCON_MAX77693=y
> CONFIG_MEMORY=y
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> # CONFIG_IIO_BUFFER_CB is not set
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> CONFIG_BMA180=y
> CONFIG_HID_SENSOR_ACCEL_3D=y
> # CONFIG_IIO_ST_ACCEL_3AXIS is not set
> # CONFIG_KXSD9 is not set
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD_SIGMA_DELTA=y
> CONFIG_AD7266=y
> # CONFIG_AD7298 is not set
> CONFIG_AD7476=y
> CONFIG_AD7791=y
> CONFIG_AD7793=y
> CONFIG_AD7887=y
> CONFIG_AD7923=y
> CONFIG_LP8788_ADC=y
> CONFIG_MAX1363=y
> CONFIG_MCP320X=y
> CONFIG_NAU7802=y
> CONFIG_TI_ADC081C=y
> CONFIG_TI_AM335X_ADC=y
> CONFIG_TWL6030_GPADC=y
> CONFIG_VIPERBOARD_ADC=y
> 
> #
> # Amplifiers
> #
> # CONFIG_AD8366 is not set
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=y
> CONFIG_HID_SENSOR_IIO_TRIGGER=y
> CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_SPI=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=y
> CONFIG_AD5360=y
> # CONFIG_AD5380 is not set
> CONFIG_AD5421=y
> # CONFIG_AD5446 is not set
> CONFIG_AD5449=y
> # CONFIG_AD5504 is not set
> CONFIG_AD5624R_SPI=y
> CONFIG_AD5686=y
> CONFIG_AD5755=y
> # CONFIG_AD5764 is not set
> CONFIG_AD5791=y
> # CONFIG_AD7303 is not set
> CONFIG_MAX517=y
> # CONFIG_MCP4725 is not set
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> CONFIG_AD9523=y
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> CONFIG_ADF4350=y
> 
> #
> # Digital gyroscope sensors
> #
> # CONFIG_ADIS16080 is not set
> CONFIG_ADIS16130=y
> # CONFIG_ADIS16136 is not set
> CONFIG_ADIS16260=y
> CONFIG_ADXRS450=y
> CONFIG_HID_SENSOR_GYRO_3D=y
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
> CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
> CONFIG_ITG3200=y
> 
> #
> # Inertial measurement units
> #
> CONFIG_ADIS16400=y
> CONFIG_ADIS16480=y
> CONFIG_IIO_ADIS_LIB=y
> CONFIG_IIO_ADIS_LIB_BUFFER=y
> # CONFIG_INV_MPU6050_IIO is not set
> 
> #
> # Light sensors
> #
> CONFIG_ADJD_S311=y
> # CONFIG_APDS9300 is not set
> CONFIG_HID_SENSOR_ALS=y
> CONFIG_SENSORS_LM3533=y
> CONFIG_SENSORS_TSL2563=y
> # CONFIG_VCNL4000 is not set
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=y
> # CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
> # CONFIG_IIO_ST_MAGN_3AXIS is not set
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=y
> 
> #
> # Pressure sensors
> #
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> CONFIG_IIO_ST_PRESS_SPI=y
> 
> #
> # Temperature sensors
> #
> CONFIG_TMP006=y
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> # CONFIG_SERIAL_IPOCTAL is not set
> CONFIG_RESET_CONTROLLER=y
> CONFIG_FMC=y
> CONFIG_FMC_FAKEDEV=y
> CONFIG_FMC_TRIVIAL=y
> # CONFIG_FMC_WRITE_EEPROM is not set
> CONFIG_FMC_CHARDEV=y
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> CONFIG_EDD_OFF=y
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> # CONFIG_DMIID is not set
> CONFIG_DMI_SYSFS=y
> CONFIG_ISCSI_IBFT_FIND=y
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> # CONFIG_GOOGLE_SMI is not set
> CONFIG_GOOGLE_MEMCONSOLE=y
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> # CONFIG_EXT2_FS_POSIX_ACL is not set
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> # CONFIG_EXT3_FS_XATTR is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD=y
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> CONFIG_REISERFS_PROC_INFO=y
> # CONFIG_REISERFS_FS_XATTR is not set
> CONFIG_JFS_FS=y
> # CONFIG_JFS_POSIX_ACL is not set
> CONFIG_JFS_SECURITY=y
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_DEBUG=y
> CONFIG_GFS2_FS=y
> # CONFIG_GFS2_FS_LOCKING_DLM is not set
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> # CONFIG_CUSE is not set
> CONFIG_GENERIC_ACL=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> CONFIG_FSCACHE_STATS=y
> CONFIG_FSCACHE_HISTOGRAM=y
> CONFIG_FSCACHE_DEBUG=y
> CONFIG_FSCACHE_OBJECT_LIST=y
> CONFIG_CACHEFILES=y
> CONFIG_CACHEFILES_DEBUG=y
> CONFIG_CACHEFILES_HISTOGRAM=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=y
> CONFIG_NLS_CODEPAGE_855=y
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> CONFIG_NLS_CODEPAGE_950=y
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> CONFIG_NLS_ISO8859_3=y
> # CONFIG_NLS_ISO8859_4 is not set
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> CONFIG_NLS_KOI8_U=y
> # CONFIG_NLS_MAC_ROMAN is not set
> CONFIG_NLS_MAC_CELTIC=y
> # CONFIG_NLS_MAC_CENTEURO is not set
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> # CONFIG_NLS_MAC_GAELIC is not set
> CONFIG_NLS_MAC_GREEK=y
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> CONFIG_NLS_MAC_ROMANIAN=y
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
> CONFIG_DLM=y
> CONFIG_DLM_DEBUG=y
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
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
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
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> CONFIG_SLUB_STATS=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
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
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_KOBJECT_RELEASE is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_WRITECOUNT is not set
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> CONFIG_DMA_API_DEBUG=y
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_TRUSTED_KEYS=y
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> # CONFIG_SECURITY_NETWORK_XFRM is not set
> CONFIG_SECURITY_PATH=y
> CONFIG_LSM_MMAP_MIN_ADDR=65536
> CONFIG_SECURITY_SELINUX=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
> # CONFIG_SECURITY_SELINUX_DISABLE is not set
> # CONFIG_SECURITY_SELINUX_DEVELOP is not set
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
> CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
> CONFIG_SECURITY_SMACK=y
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> # CONFIG_SECURITY_YAMA is not set
> CONFIG_INTEGRITY=y
> CONFIG_INTEGRITY_SIGNATURE=y
> CONFIG_INTEGRITY_AUDIT=y
> CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
> CONFIG_IMA=y
> CONFIG_IMA_MEASURE_PCR_IDX=10
> CONFIG_IMA_LSM_RULES=y
> # CONFIG_IMA_APPRAISE is not set
> CONFIG_EVM=y
> CONFIG_EVM_HMAC_VERSION=2
> CONFIG_DEFAULT_SECURITY_SELINUX=y
> # CONFIG_DEFAULT_SECURITY_SMACK is not set
> # CONFIG_DEFAULT_SECURITY_DAC is not set
> CONFIG_DEFAULT_SECURITY="selinux"
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
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> # CONFIG_CRYPTO_CTS is not set
> # CONFIG_CRYPTO_ECB is not set
> CONFIG_CRYPTO_LRW=y
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> # CONFIG_CRYPTO_RMD128 is not set
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> # CONFIG_CRYPTO_CAMELLIA is not set
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_586=y
> CONFIG_CRYPTO_SEED=y
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> CONFIG_CRYPTO_LZ4=y
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> # CONFIG_CRYPTO_HW is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> # CONFIG_LGUEST is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> CONFIG_AUDIT_GENERIC=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_COMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> # CONFIG_XZ_DEC_POWERPC is not set
> # CONFIG_XZ_DEC_IA64 is not set
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CLZ_TAB=y
> # CONFIG_CORDIC is not set
> # CONFIG_DDR is not set
> CONFIG_MPILIB=y
> CONFIG_SIGNATURE=y
> CONFIG_OID_REGISTRY=y


-- 
Dave Chinner
dchinner@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
