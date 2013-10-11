Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A54F7F51
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 23:56:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED4298F806F
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 21:56:51 -0700 (PDT)
Received: from LGEAMRELO02.lge.com (lgeamrelo02.lge.com [156.147.1.126]) by
	cuda.sgi.com with ESMTP id otPX954rQtSkBxST for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 21:56:39 -0700 (PDT)
Date: Fri, 11 Oct 2013 13:56:41 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [zram] WARNING: CPU: 0 PID: 361 at lib/debugobjects.c:260
	debug_print_object()
Message-ID: <20131011045641.GA1953@bbox>
References: <20131010125003.GA12055@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010125003.GA12055@localhost>
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
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>, Linux FS devel list <linux-fsdevel@vger.kernel.org>

Hello Fengguang,

On Thu, Oct 10, 2013 at 08:50:03PM +0800, Fengguang Wu wrote:
> [[
>    Dave and XFS folks: we seem to find the real culprit this time.
> 
>    Minchan, hopefully you are the right one to look for. I caught
>    the wrong people and went through hard times.. :-)
> ]]
> 
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 0231c403bb065307493fe997ad170487b4d55eb8
> Author: Minchan Kim <minchan@kernel.org>
> Date:   Wed Jan 30 11:41:40 2013 +0900
> 
>     zram: force disksize setting before using zram
>     
>     Now zram document syas "set disksize is optional"
>     but partly it's wrong. When you try to use zram firstly after
>     booting, you must set disksize, otherwise zram can't work because
>     zram gendisk's size is 0. But once you do it, you can use zram freely
>     after reset because reset doesn't reset to zero paradoxically.
>     So in this time, disksize setting is optional.:(
>     It's inconsitent for user behavior and not straightforward.
>     
>     This patch forces always setting disksize firstly before using zram.
>     Yes. It changes current behavior so someone could complain when
>     he upgrades zram. Apparently it could be a problem if zram is mainline
>     but it still lives in staging so behavior could be changed for right
>     way to go. Let them excuse.
>     
>     Acked-by: Jerome Marchand <jmarchand@redhat.com>
>     Acked-by: Nitin Gupta <ngupta@vflare.org>
>     Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
>     Signed-off-by: Minchan Kim <minchan@kernel.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [   35.635867] qnx6: unable to set blocksize
> [   35.638410] ADFS-fs error (device zram0): adfs_fill_super: unable to read superblock

I don't know what debugobjects says exactly but it seems regression
I mentioned in patch's description.
As I wrote, before the patch, everybody can use zram without explicit
initializtion step (ie, set disksize via /sys/block/zram0/disksize) but
we decided changing it so that everyuser should set disksize right before
zram block. Otherwise, it could encounter -EIO.
I guess xfs has a problem to recover the error?

Could you retry it with explicit initization of zram0 via setting disksize?


> [   35.662564] ------------[ cut here ]------------
> [   35.664652] WARNING: CPU: 0 PID: 361 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
> [   35.669001] ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0xfe
> [   35.670149] CPU: 0 PID: 361 Comm: mount Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #3
> [   35.670149]  00000000 00000000 8a299d30 8275c9a2 8a299d70 00000000 00000104 8a299d60
> [   35.670149]  8103f5e3 8334fafe 8a299d8c 00000169 8334fb3b 00000104 817001fb 817001fb
> [   35.670149]  8a73ebd8 8355b58c 83323588 8a299d78 8103f641 00000009 8a299d70 8334fafe
> [   35.670149] Call Trace:
> [   35.670149]  [<8275c9a2>] dump_stack+0x7a/0xaa
> [   35.670149]  [<8103f5e3>] warn_slowpath_common+0x8c/0xa3
> [   35.670149]  [<817001fb>] ? debug_print_object+0x94/0xa2
> [   35.670149]  [<817001fb>] ? debug_print_object+0x94/0xa2
> [   35.670149]  [<8103f641>] warn_slowpath_fmt+0x2e/0x30
> [   35.670149]  [<817001fb>] debug_print_object+0x94/0xa2
> [   35.670149]  [<81344703>] ? xfs_buf_unlock+0x17f/0x17f
> [   35.670149]  [<81700f1a>] debug_check_no_obj_freed+0xe2/0x1f8
> [   35.670149]  [<8115aaa1>] kmem_cache_free+0xfe/0x32b
> [   35.670149]  [<81342be0>] xfs_buf_free+0x263/0x26f
> [   35.670149]  [<81343a71>] xfs_buf_rele+0x3e0/0x3f0
> [   35.670149]  [<813635f6>] ? xfs_readsb+0x25e/0x268
> [   35.670149]  [<813635f6>] xfs_readsb+0x25e/0x268
> [   35.670149]  [<827243a5>] ? register_cpu_notifier+0x20/0x27
> [   35.670149]  [<81367344>] xfs_fs_fill_super+0x27d/0x495
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<811666bf>] mount_bdev+0x1d6/0x256
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<8115a80b>] ? __kmalloc_track_caller+0x21a/0x3b2
> [   35.670149]  [<816d87d6>] ? ida_get_new_above+0x24a/0x25b
> [   35.670149]  [<81364b69>] xfs_fs_mount+0x1a/0x1f
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<81166a09>] mount_fs+0x38/0x1b3
> [   35.670149]  [<811395a4>] ? __alloc_percpu+0xa/0xc
> [   35.670149]  [<8118b7ff>] ? alloc_vfsmnt+0x108/0x1d6
> [   35.670149]  [<8118ca68>] vfs_kern_mount+0x97/0x123
> [   35.670149]  [<8118ef8f>] do_mount+0xc8e/0xe0d
> [   35.670149]  [<8118e2e3>] ? copy_mount_string+0x51/0x6f
> [   35.670149]  [<8118f1ee>] SyS_mount+0xe0/0x10d
> [   35.670149]  [<827889ff>] syscall_call+0x7/0xb
> [   35.670149] ---[ end trace d814169ab0ed4dd3 ]---
> [   35.670149] BUG: sleeping function called from invalid context at kernel/workqueue.c:2810
> 
> git bisect start v3.9 v3.8 --
> git bisect  bad d778df51c09264076fe0208c099ef7d428f21790  # 14:59      0-      2  mm: vmscan: save work scanning (almost) empty LRU lists
> git bisect good 3278bb748d2437eb1464765f36429e5d6aa91c38  # 15:45     26+      4  ocfs2: unlock super lock if lockres refresh failed
> git bisect  bad b5c78e04dd061b776978dad61dd85357081147b0  # 16:02      0-      1  Merge tag 'staging-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
> git bisect  bad 4d1b2fbbaf6420f64fae8b3f3a7801fc97d07260  # 16:25      0-     13  staging/ozwpan: Fix NULL vs zero in ozusbsvc1.c (sparse warning)
> git bisect good 934efe63e8bece28c69d18ea5e3bfd1619fc23b2  # 17:02     26+      0  staging: comedi: addi_apci_2200: use addi_watchdog module
> git bisect good 6a6df2d9113856a4371ca4f1cb29221790320307  # 17:26     26+      0  Partially revert "staging:iio:gyro:adxrs450 make more use of spi_read and spi_write."
> git bisect  bad 4e98fcfb95dfd9c40976dcfa2f3b878eeec4dbaa  # 17:41      0-      7  Merge tag 'iio-for-3.9c' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next
> git bisect  bad a5e080b83e28f2b67c198cb3be96f4b190522109  # 18:04      0-      7  staging/xgifb: remove unnecessary temp variable in XGIfb_mode_rate_to_ddata
> git bisect good 42d1aeea844874961af00621f0a5584aa9b9e1a5  # 18:27     26+      0  staging: comedi: ni_mio_cs: convert to auto attach
> git bisect good de06d7c6b8e3b886eec0302ecbadf76944a42ca4  # 18:44     26+      0  staging: comedi: restrict comedi_set_hw_dev() usage
> git bisect  bad 3de738cd30306f754ea35d35b5dad29fdbec84c9  # 19:04      0-      2  zram: give up lazy initialization of zram metadata
> git bisect good 7f70410fe03f9f31a99bb5074b5e3c48f3b90541  # 19:17     26+      0  pci_ids.h: add common pci vendor ids from comedi subsystem
> git bisect  bad 0231c403bb065307493fe997ad170487b4d55eb8  # 19:26      7-      9  zram: force disksize setting before using zram
> git bisect good 7e5a5104c6af709a8d97d5f4711e7c917761d464  # 19:46     27+      0  zram: Fix deadlock bug in partial read/write
> git bisect good 7e5a5104c6af709a8d97d5f4711e7c917761d464  # 19:51     81+      0  zram: Fix deadlock bug in partial read/write
> git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 19:52      0-     11  Add linux-next specific files for 20130927
> git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 20:13      0-     11  Add linux-next specific files for 20130927
> 
> Thanks,
> Fengguang

> [    0.000000] Linux version 3.12.0-rc2-next-20130927-03100-ga0cf1ab (kbuild@jaketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #3 SMP Fri Oct 4 22:52:48 CST 2013
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
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
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [800fdae0]
> [    0.000000]   mpc: fdaf0-fdbec
> [    0.000000] initial memory mapped: [mem 0x00000000-0x047fffff]
> [    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
> [    0.000000]  [mem 0x0f800000-0x0fbfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
> [    0.000000]  [mem 0x08000000-0x0f7fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
> [    0.000000]  [mem 0x00100000-0x003fffff] page 4k
> [    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
> [    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
> [    0.000000] BRK [0x043cf000, 0x043cffff] PGTABLE
> [    0.000000] cma: dma_contiguous_reserve(limit 00000000)
> [    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
> [    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000, limit 00000000)
> [    0.000000] cma: CMA: reserved 28 MiB at 0e000000
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 127780(97%)
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
> [    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
> [    0.000000] On node 0 totalpages: 65436
> [    0.000000] free_area_init_node: node 0, pgdat 836a3780, node_mem_map 8d600020
> [    0.000000]   Normal zone: 512 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 65436 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffa000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 11 pages/cpu @8fcce000 s31616 r0 d13440 u45056
> [    0.000000] pcpu-alloc: s31616 r0 d13440 u45056 alloc=11*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr fcd05c0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64924
> [    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-j0-10042023/next:master/.vmlinuz-a0cf1abc25ac197dd97b857c0f6341066a8cb1cf-20131004225358-4-jaketown branch=next/master BOOT_IMAGE=/kernel/i386-randconfig-j0-10042023/a0cf1abc25ac197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next-20130927-03100-ga0cf1ab
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Memory: 166256K/261744K available (24104K kernel code, 7543K rwdata, 14088K rodata, 932K init, 6260K bss, 95488K reserved)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
> [    0.000000]     vmalloc : 0x907fe000 - 0xffd33000   (1781 MB)
> [    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
> [    0.000000]       .init : 0x83cac000 - 0x83d95000   ( 932 kB)
> [    0.000000]       .data : 0x8278a4cd - 0x83cabf00   (21638 kB)
> [    0.000000]       .text : 0x81000000 - 0x8278a4cd   (24105 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=80096000 soft=80080000
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3567 kB
> [    0.000000]  per task-struct memory footprint: 1152 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:  ok  |  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:  ok  |  ok  |  ok  |
> [    0.000000]                               try:  ok  |  ok  |  ok  |
> [    0.000000]                             block:  ok  |  ok  |  ok  |
> [    0.000000]                          spinlock:  ok  |  ok  |  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 253 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] ODEBUG: 13 of 13 active objects replaced
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 1600.055 MHz processor
> [    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
> [    0.020000] Calibrating delay loop (skipped) preset value.. 3200.11 BogoMIPS (lpj=16000550)
> [    0.020000] pid_max: default: 4096 minimum: 301
> [    0.020000] Mount-cache hash table entries: 512
> [    0.020846] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020846] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020846] tlb_flushall_shift: -1
> [    0.029216] Freeing SMP alternatives memory: 44K (83d95000 - 83da0000)
> [    0.045408] ACPI: Core revision 20130823
> [    0.052876] ACPI: All ACPI Tables successfully acquired
> [    0.054972] Getting VERSION: 50014
> [    0.055923] Getting VERSION: 50014
> [    0.056854] Getting ID: 0
> [    0.057589] Getting ID: f000000
> [    0.058459] Getting LVT0: 8700
> [    0.059284] Getting LVT1: 8400
> [    0.060020] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.061610] enabled ExtINT on CPU#0
> [    0.064756] ENABLING IO-APIC IRQs
> [    0.065656] init IO_APIC IRQs
> [    0.066458]  apic 0 pin 0 not connected
> [    0.067531] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.069646] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.070064] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.072188] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.074322] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.076450] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.080061] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.082168] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.084259] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.086344] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.088473] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.090071] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.092222] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.094362] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.096503] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.098637]  apic 0 pin 16 not connected
> [    0.100012]  apic 0 pin 17 not connected
> [    0.101065]  apic 0 pin 18 not connected
> [    0.102097]  apic 0 pin 19 not connected
> [    0.103136]  apic 0 pin 20 not connected
> [    0.104188]  apic 0 pin 21 not connected
> [    0.105218]  apic 0 pin 22 not connected
> [    0.106253]  apic 0 pin 23 not connected
> [    0.107472] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.110012] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.112759] Using local APIC timer interrupts.
> [    0.112759] calibrating APIC timer ...
> [    0.120000] ... lapic delta = 6250155
> [    0.120000] ... PM-Timer delta = 357970
> [    0.120000] ... PM-Timer result ok
> [    0.120000] ..... delta 6250155
> [    0.120000] ..... mult: 268442113
> [    0.120000] ..... calibration result: 10000248
> [    0.120000] ..... CPU clock speed is 1600.0035 MHz.
> [    0.120000] ..... host bus clock speed is 1000.0248 MHz.
> [    0.120000] Performance Events: 
> [    0.120000] ftrace: Allocated trace_printk buffers
> [    0.123331] SMP alternatives: lockdep: fixing up alternatives
> [    0.125114] CPU 1 irqstacks, hard=803f0000 soft=803f2000
> [    0.126691] smpboot: Booting Node   0, Processors  #   1 OK
> [    0.010000] Initializing CPU#1
> [    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
> [    0.020000] masked ExtINT on CPU#1
> [    0.143201] KVM setup async PF for cpu 1
> [    0.143417] Brought up 2 CPUs
> [    0.143424] smpboot: Total of 2 processors activated (6400.22 BogoMIPS)
> [    0.144102] kvm-stealtime: cpu 1, msr fcdb5c0
> [    0.151971] devtmpfs: initialized
> [    0.163243] xor: measuring software checksum speed
> [    0.257095]    pIII_sse  :  4642.400 MB/sec
> [    0.357091]    prefetch64-sse:  4996.400 MB/sec
> [    0.358355] xor: using function: prefetch64-sse (4996.400 MB/sec)
> [    0.360024] atomic64 test passed for i386+ platform with CX8 and with SSE
> [    0.363283] regulator-dummy: no parameters
> [    0.371714] NET: Registered protocol family 16
> [    0.376084] cpuidle: using governor ladder
> [    0.377245] cpuidle: using governor menu
> [    0.462944] ACPI: bus type PCI registered
> [    0.464453] PCI: Using configuration type 1 for base access
> [    0.468166] Missing cpus node, bailing out
> [    0.469459] Missing cpus node, bailing out
> [    0.511074] bio: create slab <bio-0> at 0
> [    0.677100] raid6: mmxx1     1787 MB/s
> [    0.847134] raid6: mmxx2     1967 MB/s
> [    1.017125] raid6: sse1x1    1516 MB/s
> [    1.187111] raid6: sse1x2    1754 MB/s
> [    1.357088] raid6: sse2x1    2922 MB/s
> [    1.527108] raid6: sse2x2    3471 MB/s
> [    1.528217] raid6: using algorithm sse2x2 (3471 MB/s)
> [    1.529586] raid6: using intx1 recovery algorithm
> [    1.531401] ACPI: Added _OSI(Module Device)
> [    1.533063] ACPI: Added _OSI(Processor Device)
> [    1.534736] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.540028] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.560725] ACPI: Interpreter enabled
> [    1.561746] ACPI: (supports S0 S5)
> [    1.562648] ACPI: Using IOAPIC for interrupt routing
> [    1.564009] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.595861] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.597482] acpi PNP0A03:00: _OSC: OS supports [Segments]
> [    1.599030] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    1.601138] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    1.604434] PCI host bridge to bus 0000:00
> [    1.605513] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.606940] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.608530] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    1.610018] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.611791] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    1.613703] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    1.616743] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    1.620899] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    1.628881] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
> [    1.633465] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    1.635868] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    1.637728] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    1.640916] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    1.645554] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    1.650046] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
> [    1.665646] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
> [    1.668474] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
> [    1.672513] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
> [    1.676295] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
> [    1.689394] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
> [    1.691169] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
> [    1.695238] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
> [    1.700018] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
> [    1.713726] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
> [    1.716450] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
> [    1.720018] pci 0000:00:05.0: reg 0x10: [mem 0xfebe2000-0xfebe200f]
> [    1.731233] pci_bus 0000:00: on NUMA node 0
> [    1.735377] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    1.737736] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    1.740068] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    1.742364] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    1.744370] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    1.747991] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    1.749387] ACPI: \_SB_.PCI0: notify handler is installed
> [    1.750245] Found 1 acpi root devices
> [    1.752950] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    1.752950] vgaarb: loaded
> [    1.753120] vgaarb: bridge control possible 0000:00:02.0
> [    1.754783] tps65010: version 2 May 2005
> [    1.800126] tps65010: no chip?
> [    1.802104] SCSI subsystem initialized
> [    1.803246] libata version 3.00 loaded.
> [    1.804426] ACPI: bus type USB registered
> [    1.805583] usbcore: registered new interface driver usbfs
> [    1.807047] usbcore: registered new interface driver hub
> [    1.808481] usbcore: registered new device driver usb
> [    1.810238] Linux video capture interface: v2.00
> [    1.811494] pps_core: LinuxPPS API ver. 1 registered
> [    1.812781] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.815100] PTP clock support registered
> [    1.816211] EDAC MC: Ver: 3.0.0
> [    1.817569] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    1.819163] wmi: Mapper loaded
> [    1.820336] Advanced Linux Sound Architecture Driver Initialized.
> [    1.822014] PCI: Using ACPI for IRQ routing
> [    1.823104] PCI: pci_cache_line_size set to 64 bytes
> [    1.824677] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    1.826237] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
> [    1.828858] Bluetooth: Core ver 2.16
> [    1.830082] NET: Registered protocol family 31
> [    1.831472] Bluetooth: HCI device and connection manager initialized
> [    1.833777] Bluetooth: HCI socket layer initialized
> [    1.835239] Bluetooth: L2CAP socket layer initialized
> [    1.836603] Bluetooth: SCO socket layer initialized
> [    1.837863] NET: Registered protocol family 8
> [    1.838995] NET: Registered protocol family 20
> [    1.842619] Switched to clocksource kvm-clock
> [    1.844664] Warning: could not register all branches stats
> [    1.846097] Warning: could not register annotated branches stats
> [    1.978800] FS-Cache: Loaded
> [    1.980274] CacheFiles: Loaded
> [    1.981272] pnp: PnP ACPI init
> [    1.982195] ACPI: bus type PNP registered
> [    1.983432] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    1.985671] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.987515] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    1.989668] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.991469] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    1.993676] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    1.995512] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    1.997573] pnp 00:03: [dma 2]
> [    1.998496] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    2.000387] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    2.002543] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    2.004375] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    2.006527] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.009232] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    2.011608] pnp: PnP ACPI: found 7 devices
> [    2.012666] ACPI: bus type PNP unregistered
> [    2.013732] INFO_MDMA: LNW DMA Driver Version 1.1.0
> [    2.051868] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    2.053295] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    2.054696] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    2.056280] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    2.058039] NET: Registered protocol family 1
> [    2.059197] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    2.060790] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    2.062282] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    2.063908] pci 0000:00:02.0: Boot video device
> [    2.065145] PCI: CLS 0 bytes, default 64
> [    2.066671] Unpacking initramfs...
> [    2.358410] Freeing initrd memory: 3120K (8fce4000 - 8fff0000)
> [    2.434960] DMA-API: preallocated 65536 debug entries
> [    2.436283] DMA-API: debugging enabled by kernel config
> [    2.441272] microcode: no support for this CPU vendor
> [    2.444760] NatSemi SCx200 Driver
> [    2.447016] audit: initializing netlink socket (disabled)
> [    2.448488] type=2000 audit(1380898450.634:1): initialized
> [    2.457119] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    2.459926] VFS: Disk quotas dquot_6.5.2
> [    2.461287] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    2.467641] QNX4 filesystem 0.2.3 registered.
> [    2.468863] QNX6 filesystem 1.0.0 registered.
> [    2.470152] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
> [    2.475430] NILFS version 2 loaded
> [    2.476326] BeFS version: 0.9.3
> [    2.477249] OCFS2 1.5.0
> [    2.478707] ocfs2: Registered cluster interface o2cb
> [    2.479999] OCFS2 DLMFS 1.5.0
> [    2.481306] OCFS2 User DLM kernel interface loaded
> [    2.482539] OCFS2 Node Manager 1.5.0
> [    2.488182] OCFS2 DLM 1.5.0
> [    2.489993] bio: create slab <bio-1> at 1
> [    2.492507] Btrfs loaded, assert=on
> [    2.493418] btrfs: selftest: Running btrfs free space cache tests
> [    2.494940] btrfs: selftest: Running extent only tests
> [    2.496301] btrfs: selftest: Running bitmap only tests
> [    2.497615] btrfs: selftest: Running bitmap and extent tests
> [    2.499095] btrfs: selftest: Free space cache tests finished
> [    2.502764] GFS2 installed
> [    2.504051] msgmni has been set to 386
> [    2.533647] alg: No test for lz4hc (lz4hc-generic)
> [    2.535581] alg: No test for stdrng (krng)
> [    2.537464] NET: Registered protocol family 38
> [    2.538922] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
> [    2.540900] io scheduler noop registered
> [    2.541905] io scheduler deadline registered
> [    2.543314] io scheduler cfq registered (default)
> [    2.544534] test_string_helpers: Running tests...
> [    2.546411] xz_dec_test: module loaded
> [    2.547381] xz_dec_test: Create a device node with 'mknod xz_dec_test c 249 0' and write .xz files to it.
> [    2.554727] rbtree testing -> 18040 cycles
> [    3.809815] augmented rbtree testing -> 29925 cycles
> [    5.867313] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    5.869631] rivafb_setup START
> [    5.870764] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    5.873219] hgafb: HGA card not detected.
> [    5.874282] hgafb: probe of hgafb.0 failed with error -22
> [    5.876843] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xfc000000
> [    5.880936] usbcore: registered new interface driver udlfb
> [    5.883028] usbcore: registered new interface driver smscufx
> [    6.005027] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension, 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
> [    6.014837] uvesafb: no monitor limits have been set, default refresh rate will be used
> [    6.018012] uvesafb: VBE state buffer size cannot be determined (eax=0x14f, err=0)
> [    6.020990] uvesafb: scrolling: redraw
> [    6.022422] uvesafb: request region 0x3c0-0x3e0 failed
> [    6.024411] uvesafb: probe of uvesafb.0 failed with error -5
> [    6.026704] ipmi message handler version 39.2
> [    6.028363] ipmi device interface
> [    6.029860] IPMI System Interface driver.
> [    6.031704] ipmi_si: Adding default-specified kcs state machine
> [    6.033985] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [    6.037687] ipmi_si: Interface detection failed
> [   16.040834] ipmi_si: Adding default-specified smic state machine
> [   16.042639] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> [   16.045680] ipmi_si: Interface detection failed
> [   16.120336] ipmi_si: Adding default-specified bt state machine
> [   16.122739] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> [   16.125628] ipmi_si: Interface detection failed
> [   16.240645] ipmi_si: Unable to find any System Interface(s)
> [   16.242130] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
> [   16.244831] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [   16.247221] ACPI: Power Button [PWRF]
> [   16.371965] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [   16.403431] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [   16.410390] lp: driver loaded but no devices found
> [   16.411905] toshiba: not a supported Toshiba laptop
> [   16.413684] ppdev: user-space parallel port driver
> [   16.415796] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
> [   16.417852] platform pc8736x_gpio.0: no device found
> [   16.419706] nsc_gpio initializing
> [   16.420771] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [   16.422210] Linux agpgart interface v0.103
> [   16.424252] [drm] Initialized drm 1.1.0 20060810
> [   16.425760] drm/i810 does not support SMP
> [   16.427407] usbcore: registered new interface driver udl
> [   16.429263] parport_pc 00:04: reported by Plug and Play ACPI
> [   16.431166] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
> [   16.435139] lp0: using parport0 (interrupt-driven).
> [   16.436510] lp0: console ready
> [   16.438992] dummy-irq: no IRQ given.  Use irq=N
> [   16.440434] lkdtm: No crash points registered, enable through debugfs
> [   16.442401] Phantom Linux Driver, version n0.9.8, init OK
> [   16.444231] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [   16.446528] c2port c2port0: C2 port uc added
> [   16.447753] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [   16.450275] Guest personality initialized and is inactive
> [   16.452398] VMCI host device registered (name=vmci, major=10, minor=60)
> [   16.454265] Initialized host personality
> [   16.456432] usbcore: registered new interface driver viperboard
> [   16.459179] Loading iSCSI transport class v2.0-870.
> [   16.461990] rdac: device handler registered
> [   16.463560] hp_sw: device handler registered
> [   16.464796] emc: device handler registered
> [   16.465996] alua: device handler registered
> [   16.469547] fnic: Cisco FCoE HBA Driver, ver 1.5.0.23
> [   16.472030] fnic: Successfully Initialized Trace Buffer
> [   16.474738] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.14 (Mar 08, 2013)
> [   16.478874] Adaptec aacraid driver 1.2-0[30200]-ms
> [   16.481985] iscsi: registered transport (qla4xxx)
> [   16.483389] QLogic iSCSI HBA Driver
> [   16.484367] Brocade BFA FC/FCOE SCSI driver - version: 3.2.21.1
> [   16.486062] csiostor: Chelsio FCoE driver 1.0.0
> [   16.488087] DC390: clustering now enabled by default. If you get problems load
> [   16.490388]        with "disable_clustering=1" and report to maintainers
> [   16.492659] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
> [   16.494780] mpt3sas version 02.100.00.00 loaded
> [   16.497323] GDT-HA: Storage RAID Controller Driver. Version: 3.05
> [   16.499237] 3ware Storage Controller device driver for Linux v1.26.02.003.
> [   16.501555] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
> [   16.503699] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v3.26.02.000.
> [   16.506153] ppa: Version 2.07 (for Linux 2.4.x)
> [   16.510659] imm: Version 2.05 (for Linux 2.4.0)
> [   16.512854] RocketRAID 3xxx/4xxx Controller driver v1.8
> [   16.514658] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
> [   16.516908] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2013)
> [   16.519273] iscsi: registered transport (bnx2i)
> [   16.521684] iscsi: registered transport (be2iscsi)
> [   16.523014] In beiscsi_module_init, tt=835f35a4
> [   16.524663] VMware PVSCSI driver - version 1.0.2.0-k
> [   16.526567] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [   16.530674] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [   16.540004] SSFDC read-only Flash Translation layer
> [   16.542960] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [   16.545405] Could not find PAR responsible for SC520CDP Flash Bank #1
> [   16.547062] Trying default address 0x8c00000
> [   16.548182] SC520 CDP flash device: 0x800000 at 0x8800000
> [   16.549549] Failed to ioremap_nocache
> [   16.550572] NetSc520 flash device: 0x100000 at 0x200000
> [   16.551915] Failed to ioremap_nocache
> [   16.552868] Failed to ioremap_nocache
> [   16.553925] slram: not enough parameters.
> [   16.554969] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
> [   16.557228] pmc551: not detected
> [   16.562479] ftl_cs: FTL header not found.
> [   16.568875] HSI/SSI char device loaded
> [   16.571432] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
> [   16.577140] libphy: Fixed MDIO Bus: probed
> [   16.578969] tun: Universal TUN/TAP device driver, 1.6
> [   16.580364] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   16.583501] arcnet loaded.
> [   16.584583] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
> [   16.587183] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
> [   16.590198] arcnet: raw mode (`r') encapsulation support loaded.
> [   16.592328] arcnet: cap mode (`c') encapsulation support loaded.
> [   16.594809] arcnet: COM90xx chipset support
> [   16.597204] S1: No ARCnet cards found.
> [   16.598801] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
> [   16.601455] E-mail me if you actually test this driver, please!
> [   16.603759]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
> [   16.606170] arcnet: RIM I (entirely mem-mapped) support
> [   16.607493] E-mail me if you actually test the RIM I driver, please!
> [   16.609093] Given: node 00h, shmem 0h, irq 0
> [   16.610312] No autoprobe for RIM I; you must specify the shmem and irq!
> [   16.612079] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
> [   16.614502] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
> [   16.616564] vcan: Virtual CAN interface driver
> [   16.617732] CAN device driver interface
> [   16.618775] usbcore: registered new interface driver ems_usb
> [   16.620430] usbcore: registered new interface driver kvaser_usb
> [   16.621997] usbcore: registered new interface driver peak_usb
> [   16.623714] usbcore: registered new interface driver usb_8dev
> [   16.625165] sja1000 CAN netdevice driver
> [   16.626523] cc770: CAN netdevice driver
> [   16.627958] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
> [   16.629926] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 01, 2013)
> [   16.632631] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.78.17-0 (2013/04/11)
> [   16.635978] Brocade 10G Ethernet driver - version: 3.2.21.1
> [   16.638265] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
> [   16.639880] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
> [   16.639880]   http://www.scyld.com/network/drivers.html
> [   16.643545] jme: JMicron JMC2XX ethernet driver version 1.0.8
> [   16.645159] sky2: driver version 1.30
> [   16.647741] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
> [   16.649986] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
> [   16.652662] Solarflare NET driver v4.0
> [   16.654962] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
> [   16.656725] tehuti: Options: hw_csum 
> [   16.657946] tlan: ThunderLAN driver v1.17
> [   16.659731] tlan: 0 devices installed, PCI: 0  EISA: 0
> [   16.661681] PPP generic driver version 2.4.2
> [   16.665017] PPP Deflate Compression module registered
> [   16.668575] PPP MPPE Compression module registered
> [   16.671895] NET: Registered protocol family 24
> [   16.675011] usbcore: registered new interface driver catc
> [   16.677922] usbcore: registered new interface driver kaweth
> [   16.680087] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
> [   16.682174] usbcore: registered new interface driver pegasus
> [   16.683810] usbcore: registered new interface driver rtl8150
> [   16.685378] usbcore: registered new interface driver r8152
> [   16.688784] usbcore: registered new interface driver hwa-rc
> [   16.690607] usbcore: registered new interface driver i1480-dfu-usb
> [   16.693388] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [   16.695377] ehci-pci: EHCI PCI platform driver
> [   16.696760] ehci-platform: EHCI generic platform driver
> [   16.698450] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [   16.700386] ohci-pci: OHCI PCI platform driver
> [   16.701803] ohci-platform: OHCI generic platform driver
> [   16.703524] driver u132_hcd
> [   16.705785] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
> [   16.707570] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
> [   16.710208] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
> [   16.711876] 
> [   16.714994] usbcore: registered new interface driver wusb-cbaf
> [   16.716662] usbcore: registered new interface driver usblp
> [   16.718255] usbcore: registered new interface driver usb-storage
> [   16.719981] usbcore: registered new interface driver ums-cypress
> [   16.721759] usbcore: registered new interface driver ums-datafab
> [   16.723445] usbcore: registered new interface driver ums-freecom
> [   16.725204] usbcore: registered new interface driver ums-jumpshot
> [   16.726952] usbcore: registered new interface driver ums-karma
> [   16.728586] usbcore: registered new interface driver ums-sddr09
> [   16.730357] usbcore: registered new interface driver ums-sddr55
> [   16.732102] usbcore: registered new interface driver mdc800
> [   16.733653] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
> [   16.735809] usbcore: registered new interface driver microtekX6
> [   16.737499] usbcore: registered new interface driver adutux
> [   16.739701] usbcore: registered new interface driver appledisplay
> [   16.741781] usbcore: registered new interface driver cypress_cy7c63
> [   16.743567] usbcore: registered new interface driver emi62 - firmware loader
> [   16.745651] driver ftdi-elan
> [   16.748106] usbcore: registered new interface driver ftdi-elan
> [   16.750119] usbcore: registered new interface driver idmouse
> [   16.751752] usbcore: registered new interface driver iowarrior
> [   16.753401] usbcore: registered new interface driver isight_firmware
> [   16.755243] usbcore: registered new interface driver usblcd
> [   16.756856] usbcore: registered new interface driver usbled
> [   16.758434] usbcore: registered new interface driver legousbtower
> [   16.760254] usbcore: registered new interface driver rio500
> [   16.761919] usbcore: registered new interface driver usbtest
> [   16.763517] usbcore: registered new interface driver usb_ehset_test
> [   16.765340] usbcore: registered new interface driver trancevibrator
> [   16.767165] usbcore: registered new interface driver uss720
> [   16.768708] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
> [   16.771450] uss720: NOTE: this is a special purpose driver to allow nonstandard
> [   16.773452] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
> [   16.775451] uss720: If you just want to connect to a printer, use usblp instead
> [   16.777583] usbcore: registered new interface driver usbsevseg
> [   16.779460] usbcore: registered new interface driver yurex
> [   16.781375] usbcore: registered new interface driver sisusb
> [   16.783972] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
> [   16.786465] dummy_hcd dummy_hcd.0: Dummy host controller
> [   16.788988] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
> [   16.791565] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [   16.793310] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   16.796217] usb usb1: Product: Dummy host controller
> [   16.798338] usb usb1: Manufacturer: Linux 3.12.0-rc2-next-20130927-03100-ga0cf1ab dummy_hcd
> [   16.801978] usb usb1: SerialNumber: dummy_hcd.0
> [   16.805643] hub 1-0:1.0: USB hub found
> [   16.806878] hub 1-0:1.0: 1 port detected
> [   16.811106] g_mass_storage gadget: no file given for LUN0
> [   16.813244] g_mass_storage dummy_udc.0: failed to start g_mass_storage: -22
> [   16.815550] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [   16.820440] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   16.822070] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   16.824210] parport0: cannot grant exclusive access for device parkbd
> [   16.826777] mousedev: PS/2 mouse device common for all mice
> [   16.830490] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [   16.830875] i2c /dev entries driver
> [   16.831853] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
> [   17.071124] i2c-parport-light: adapter type unspecified
> [   17.074010] usbcore: registered new interface driver hdpvr
> [   17.076610] usbcore: registered new interface driver pvrusb2
> [   17.078810] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
> [   17.082258] pvrusb2: Debug mask is 31 (0x1f)
> [   17.084179] usbcore: registered new interface driver stk1160
> [   17.086578] usbcore: registered new interface driver em28xx
> [   17.088738] usbcore: registered new interface driver radioshark2
> [   17.091265] usbcore: registered new interface driver dsbr100
> [   17.093319] usbcore: registered new interface driver radio-si470x
> [   17.095933] usbcore: registered new interface driver radio-ma901
> [   17.099035] pps pps0: new PPS source ktimer
> [   17.100212] pps pps0: ktimer PPS source registered
> [   17.101443] pps_parport: parallel port PPS client
> [   17.102673] parport0: cannot grant exclusive access for device pps_parport
> [   17.104409] pps_parport: couldn't register with parport0
> [   17.105849] Driver for 1-wire Dallas network protocol.
> [   17.107349] usbcore: registered new interface driver DS9490R
> [   17.108864] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
> [   17.447426] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
> [   25.591137] pc87360: PC8736x not detected, module not inserted
> [   26.732114] acquirewdt: WDT driver for Acquire single board computer initialising
> [   26.735443] acquirewdt: I/O address 0x0043 already in use
> [   26.737509] acquirewdt: probe of acquirewdt failed with error -5
> [   26.739745] advantechwdt: WDT driver for Advantech single board computer initialising
> [   26.744730] advantechwdt: initialized. timeout=60 sec (nowayout=0)
> [   26.747208] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
> [   26.749262] alim7101_wdt: ALi M7101 PMU not present - WDT not set
> [   26.751791] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
> [   26.754738] wafer5823wdt: I/O address 0x0443 already in use
> [   26.756845] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [   26.759257] it87_wdt: no device
> [   26.760750] sc1200wdt: build 20020303
> [   26.762304] sc1200wdt: io parameter must be specified
> [   26.764321] pc87413_wdt: Version 1.1 at io 0x2E
> [   26.766047] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
> [   26.768519] nv_tco: NV TCO WatchDog Timer Driver v0.01
> [   26.771894] sbc60xxwdt: I/O address 0x0443 already in use
> [   26.773938] sbc7240_wdt: I/O address 0x0443 already in use
> [   26.776006] cpu5wdt: misc_register failed
> [   26.777908] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
> [   26.781913] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
> [   26.784924] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
> [   26.787419] w83697hf_wdt: WDT driver for W83697HF/HG initializing
> [   26.789710] w83697hf_wdt: watchdog not found at address 0x2e
> [   26.791926] w83697hf_wdt: No W83697HF/HG could be found
> [   26.793907] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
> [   26.797151] w83697ug_wdt: No W83697UG/UF could be found
> [   26.799137] w83877f_wdt: I/O address 0x0443 already in use
> [   26.801274] w83977f_wdt: driver v1.00
> [   26.802689] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
> [   26.805143] machzwd: MachZ ZF-Logic Watchdog driver initializing
> [   26.807373] machzwd: no ZF-Logic found
> [   26.809517] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
> [   26.812632] watchdog: Software Watchdog: a legacy watchdog module is probably present.
> [   26.816370] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
> [   26.820605] Bluetooth: Virtual HCI driver ver 1.4
> [   26.823157] usbcore: registered new interface driver bcm203x
> [   26.825499] usbcore: registered new interface driver bpa10x
> [   26.827736] usbcore: registered new interface driver bfusb
> [   26.830203] EDAC DEBUG: i5000_init: MC:
> [   26.831875] EDAC DEBUG: i5400_init: MC:
> [   26.833535] EDAC DEBUG: i7300_init: 
> [   26.835726] EDAC DEBUG: i82875p_init: 875p pci_get_device fail
> [   26.838326] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [   26.841104] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [   26.844917] EDAC DEBUG: i82860_init: 860 pci_get_device fail
> [   33.160216]  (null): enodev DEV ADDR = 0xFF
> [   33.172488] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [   33.175601] usbcore: registered new interface driver usbhid
> [   33.177644] usbhid: USB HID core driver
> [   33.179270] usbip_core: usbip_core_init:805: USB/IP Core v1.0.0
> [   33.182049] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
> [   33.184235] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
> [   33.186831] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 2
> [   33.189429] vhci_hcd: vhci_start:884: enter vhci_start
> [   33.193350] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [   33.195896] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   33.198511] usb usb2: Product: USB/IP Virtual Host Controller
> [   33.200696] usb usb2: Manufacturer: Linux 3.12.0-rc2-next-20130927-03100-ga0cf1ab vhci_hcd
> [   33.203705] usb usb2: SerialNumber: vhci_hcd
> [   33.206307] hub 2-0:1.0: USB hub found
> [   33.207763] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
> [   33.210734] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
> [   33.212874] vhci_hcd: vhci_hub_control:398: port -1
> [   33.214719] vhci_hcd: vhci_hub_control:405:  bye
> [   33.216477] hub 2-0:1.0: 8 ports detected
> [   33.218043] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
> [   33.220706] vhci_hcd: vhci_hub_control:309:  GetHubStatus
> [   33.222711] vhci_hcd: vhci_hub_control:398: port -1
> [   33.224495] vhci_hcd: vhci_hub_control:405:  bye
> [   33.227365] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
> [   33.229877] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.232431] vhci_hcd: vhci_hub_control:398: port 0
> [   33.234237] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.237185] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.239123] vhci_hcd: dump_port_status_diff:119: 
> [   33.240954] vhci_hcd: vhci_hub_control:405:  bye
> [   33.242758] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
> [   33.245248] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.247618] vhci_hcd: vhci_hub_control:398: port 1
> [   33.249379] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.252441] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.254440] vhci_hcd: dump_port_status_diff:119: 
> [   33.256153] vhci_hcd: vhci_hub_control:405:  bye
> [   33.257914] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
> [   33.260506] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.262892] vhci_hcd: vhci_hub_control:398: port 2
> [   33.264650] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.267598] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.269519] vhci_hcd: dump_port_status_diff:119: 
> [   33.271335] vhci_hcd: vhci_hub_control:405:  bye
> [   33.273105] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
> [   33.275663] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.278016] vhci_hcd: vhci_hub_control:398: port 3
> [   33.279770] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.282837] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.284771] vhci_hcd: dump_port_status_diff:119: 
> [   33.286489] vhci_hcd: vhci_hub_control:405:  bye
> [   33.288232] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
> [   33.290823] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.293226] vhci_hcd: vhci_hub_control:398: port 4
> [   33.295041] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.297996] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.299923] vhci_hcd: dump_port_status_diff:119: 
> [   33.301763] vhci_hcd: vhci_hub_control:405:  bye
> [   33.303528] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
> [   33.306021] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.308394] vhci_hcd: vhci_hub_control:398: port 5
> [   33.310199] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.313200] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.315202] vhci_hcd: dump_port_status_diff:119: 
> [   33.316931] vhci_hcd: vhci_hub_control:405:  bye
> [   33.318694] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
> [   33.321296] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.323682] vhci_hcd: vhci_hub_control:398: port 6
> [   33.325441] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.328392] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.330407] vhci_hcd: dump_port_status_diff:119: 
> [   33.332156] vhci_hcd: vhci_hub_control:405:  bye
> [   33.333972] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
> [   33.336491] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
> [   33.338839] vhci_hcd: vhci_hub_control:398: port 7
> [   33.340678] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
> [   33.343657] vhci_hcd: dump_port_status_diff:115:  +POWER
> [   33.345595] vhci_hcd: dump_port_status_diff:119: 
> [   33.347318] vhci_hcd: vhci_hub_control:405:  bye
> [   33.349490] vhci_hcd: vhci_hcd_probe:1028: bye
> [   33.351261] vhci_hcd: vhci_hcd_init:1150: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
> [   33.440184] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
> [   33.442770] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
> [   33.444990] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.447307] vhci_hcd: vhci_hub_control:398: port 0
> [   33.449056] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.452085] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.454079] vhci_hcd: dump_port_status_diff:119: 
> [   33.455803] vhci_hcd: vhci_hub_control:405:  bye
> [   33.460587] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
> [   33.463093] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
> [   33.465329] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.467638] vhci_hcd: vhci_hub_control:398: port 1
> [   33.469407] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.472458] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.474452] vhci_hcd: dump_port_status_diff:119: 
> [   33.476227] vhci_hcd: vhci_hub_control:405:  bye
> [   33.478002] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
> [   33.480603] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
> [   33.482823] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.485116] vhci_hcd: vhci_hub_control:398: port 2
> [   33.486869] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.489821] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.491849] vhci_hcd: dump_port_status_diff:119: 
> [   33.493602] vhci_hcd: vhci_hub_control:405:  bye
> [   33.496440] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
> [   33.498954] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
> [   33.501248] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.503571] vhci_hcd: vhci_hub_control:398: port 3
> [   33.505329] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.508277] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.510288] vhci_hcd: dump_port_status_diff:119: 
> [   33.512006] vhci_hcd: vhci_hub_control:405:  bye
> [   33.514165] panel: driver version 0.9.5 registered on parport0 (io=0x378).
> [   33.516838] usbcore: registered new interface driver rts5139
> [   33.518988] usbcore: registered new interface driver line6usb
> [   33.521154] vme_pio2: No cards, skipping registration
> [   33.523078] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
> [   33.525584] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
> [   33.527797] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.530441] vhci_hcd: vhci_hub_control:398: port 4
> [   33.532203] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.535215] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.537160] vhci_hcd: dump_port_status_diff:119: 
> [   33.538884] vhci_hcd: vhci_hub_control:405:  bye
> [   33.540756] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
> [   33.543394] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
> [   33.545619] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.547921] vhci_hcd: vhci_hub_control:398: port 5
> [   33.549682] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.552809] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.554830] vhci_hcd: dump_port_status_diff:119: 
> [   33.556557] vhci_hcd: vhci_hub_control:405:  bye
> [   33.558446] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
> [   33.558957] zram: Created 1 device(s) ...
> [   33.559101] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
> [   33.559105] Copyright 2010. Beceem Communications Inc
> [   33.559227] usbcore: registered new interface driver usbbcm
> [   33.559346] usbcore: registered new interface driver ft1000usb
> [   33.570997] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
> [   33.573226] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.575593] vhci_hcd: vhci_hub_control:398: port 6
> [   33.577349] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.580356] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.582307] vhci_hcd: dump_port_status_diff:119: 
> [   33.584028] vhci_hcd: vhci_hub_control:405:  bye
> [   33.585958] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
> [   33.586806] ozwpan ozwpan: Ozmo Devices WPAN
> [   33.590218] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
> [   33.592458] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
> [   33.594821] vhci_hcd: vhci_hub_control:398: port 7
> [   33.596572] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
> [   33.599508] vhci_hcd: dump_port_status_diff:115:   POWER
> [   33.601520] vhci_hcd: dump_port_status_diff:119: 
> [   33.603238] vhci_hcd: vhci_hub_control:405:  bye
> [   33.605296] ozwpan ozwpan: new USB bus registered, assigned bus number 3
> [   33.608030] usb usb2: vhci_bus_suspend
> [   33.609524] vhci_hcd: vhci_hub_status:208: changed 0
> [   33.611834] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [   33.614813] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   33.617435] usb usb3: Product: Ozmo Devices WPAN
> [   33.619122] usb usb3: Manufacturer: Linux 3.12.0-rc2-next-20130927-03100-ga0cf1ab Ozmo WPAN
> [   33.622393] usb usb3: SerialNumber: ozwpan
> [   33.625443] hub 3-0:1.0: USB hub found
> [   33.627017] hub 3-0:1.0: 8 ports detected
> [   33.632251] usbcore: registered new interface driver gdm_wimax
> [   33.635063] usbcore: registered new interface driver cedusb
> [   33.641845] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
> [   33.644743] aedsp16: I/O, IRQ and DMA are mandatory
> [   33.646602] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
> [   33.648877] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [   33.651783] ad1848: No ISAPnP cards found, trying standard ones...
> [   33.654589] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [   33.657301] I/O, IRQ, DMA and type are mandatory
> [   33.659033] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [   33.662189] I/O, IRQ, DMA and type are mandatory
> [   33.664091] sb: Init: Starting Probe...
> [   33.665784] sb: Init: Done
> [   33.667090] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [   33.670357] MIDI Loopback device driver
> [   33.675719] usbcore: registered new interface driver snd-usb-audio
> [   33.678444] usbcore: registered new interface driver snd-usb-usx2y
> [   33.681401] usbcore: registered new interface driver snd-usb-us122l
> [   33.683922] usbcore: registered new interface driver snd-usb-caiaq
> [   33.690430] Error: Driver 'da9055' is already registered, aborting...
> [   33.704065] oprofile: using timer interrupt.
> [   33.706036] NET: Registered protocol family 15
> [   33.708161] NET: Registered protocol family 4
> [   33.709881] NET: Registered protocol family 5
> [   33.711669] NET: Registered protocol family 9
> [   33.713216] X.25 for Linux Version 0.2
> [   33.715103] can: controller area network core (rev 20120528 abi 9)
> [   33.717486] NET: Registered protocol family 29
> [   33.719061] can: raw protocol (rev 20120528)
> [   33.720788] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   33.722657] Bluetooth: BNEP filters: multicast
> [   33.724272] Bluetooth: BNEP socket layer initialized
> [   33.726241] lec:lane_module_init: lec.c: initialized
> [   33.728158] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
> [   33.733058] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
> [   33.735916] NET: Registered protocol family 12
> [   33.737652] NET: Registered protocol family 35
> [   33.739859] NET: Registered protocol family 37
> [   33.742057] batman_adv: B.A.T.M.A.N. advanced 2013.4.0 (compatibility version 14) loaded
> [   33.744859] openvswitch: Open vSwitch switching datapath
> [   33.748020] NET: Registered protocol family 40
> [   33.749664] mpls_gso: MPLS GSO support
> [   33.755009] 
> [   33.755009] printing PIC contents
> [   33.756784] ... PIC  IMR: ffff
> [   33.757926] ... PIC  IRR: 1013
> [   33.759096] ... PIC  ISR: 0000
> [   33.760323] ... PIC ELCR: 0c00
> [   33.761532] printing local APIC contents on CPU#0/0:
> [   33.763791] ... APIC ID:      00000000 (0)
> [   33.765648] ... APIC VERSION: 00050014
> [   33.767344] ... APIC TASKPRI: 00000000 (00)
> [   33.769218] ... APIC PROCPRI: 00000000
> [   33.770032] ... APIC LDR: 01000000
> [   33.770032] ... APIC DFR: ffffffff
> [   33.770032] ... APIC SPIV: 000001ff
> [   33.770032] ... APIC ISR field:
> [   33.770032] 0000000000000000000000000000000000000000000000000000000000000000
> [   33.770032] ... APIC TMR field:
> [   33.770032] 0000000002000000000000000000000000000000000000000000000000000000
> [   33.770032] ... APIC IRR field:
> [   33.770032] 0000000000000000000000000000000000000000000000000000000000008000
> [   33.770032] ... APIC ESR: 00000000
> [   33.770032] ... APIC ICR: 000008fd
> [   33.770032] ... APIC ICR2: 02000000
> [   33.770032] ... APIC LVTT: 000000ef
> [   33.770032] ... APIC LVTPC: 00010000
> [   33.770032] ... APIC LVT0: 00010700
> [   33.770032] ... APIC LVT1: 00000400
> [   33.770032] ... APIC LVTERR: 000000fe
> [   33.770032] ... APIC TMICT: 00097e80
> [   33.770032] ... APIC TMCCT: 00000000
> [   33.770032] ... APIC TDCR: 00000003
> [   33.770032] 
> [   33.809388] number of MP IRQ sources: 15.
> [   33.811011] number of IO-APIC #0 registers: 24.
> [   33.813346] testing the IO APIC.......................
> [   33.815706] IO APIC #0......
> [   33.816781] .... register #00: 00000000
> [   33.818189] .......    : physical APIC id: 00
> [   33.819766] .......    : Delivery Type: 0
> [   33.821317] .......    : LTS          : 0
> [   33.822782] .... register #01: 00170011
> [   33.824185] .......     : max redirection entries: 17
> [   33.826005] .......     : PRQ implemented: 0
> [   33.827555] .......     : IO APIC version: 11
> [   33.829120] .... register #02: 00000000
> [   33.830585] .......     : arbitration: 00
> [   33.832045] .... IRQ redirection table:
> [   33.833999] 1    0    0   0   0    0    0    00
> [   33.835689] 0    0    0   0   0    1    1    31
> [   33.837397] 0    0    0   0   0    1    1    30
> [   33.839071] 0    0    0   0   0    1    1    33
> [   33.841195] 1    0    0   0   0    1    1    34
> [   33.843095] 1    1    0   0   0    1    1    35
> [   33.845137] 0    0    0   0   0    1    1    36
> [   33.846986] 0    0    0   0   0    1    1    37
> [   33.849117] 0    0    0   0   0    1    1    38
> [   33.850996] 0    1    0   0   0    1    1    39
> [   33.852987] 1    1    0   0   0    1    1    3A
> [   33.855327] 1    1    0   0   0    1    1    3B
> [   33.857429] 0    0    0   0   0    1    1    3C
> [   33.859280] 0    0    0   0   0    1    1    3D
> [   33.861460] 0    0    0   0   0    1    1    3E
> [   33.863281] 0    0    0   0   0    1    1    3F
> [   33.865438] 1    0    0   0   0    0    0    00
> [   33.867195] 1    0    0   0   0    0    0    00
> [   33.869261] 1    0    0   0   0    0    0    00
> [   33.871284] 1    0    0   0   0    0    0    00
> [   33.873949] 1    0    0   0   0    0    0    00
> [   33.875895] 1    0    0   0   0    0    0    00
> [   33.877907] 1    0    0   0   0    0    0    00
> [   33.879697] 1    0    0   0   0    0    0    00
> [   33.884122] IRQ to pin mappings:
> [   33.885425] IRQ0 -> 0:2
> [   33.886509] IRQ1 -> 0:1
> [   33.887587] IRQ3 -> 0:3
> [   33.888864] IRQ4 -> 0:4
> [   33.889931] IRQ5 -> 0:5
> [   33.891111] IRQ6 -> 0:6
> [   33.892405] IRQ7 -> 0:7
> [   33.893889] IRQ8 -> 0:8
> [   33.894969] IRQ9 -> 0:9
> [   33.896251] IRQ10 -> 0:10
> [   33.897401] IRQ11 -> 0:11
> [   33.898556] IRQ12 -> 0:12
> [   33.899695] IRQ13 -> 0:13
> [   33.901129] IRQ14 -> 0:14
> [   33.902482] IRQ15 -> 0:15
> [   33.903621] .................................... done.
> [   33.905858] Using IPI No-Shortcut mode
> [   33.908848] registered taskstats version 1
> [   33.913679] Key type encrypted registered
> [   33.917062] RIO: rio_register_scan for mport_id=-1
> [   33.923499] console [netcon0] enabled
> [   33.924837] netconsole: network logging started
> [   33.926708] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [   33.928841] EDD information not available.
> [   33.930752] ALSA device list:
> [   33.931852]   No soundcards found.
> [   33.938077] Freeing unused kernel memory: 932K (83cac000 - 83d95000)
> [   33.943021] Write protecting the kernel text: 24108k
> [   33.945915] Write protecting the kernel read-only data: 14092k
> 
> /etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory
> 
> Please wait: booting...
> Starting udev
> [   35.460430] EXT4-fs (zram0): unable to read superblock
> [   35.468737] EXT3-fs (zram0): error: unable to read superblock
> [   35.474268] EXT2-fs (zram0): error: unable to read superblock
> [   35.501738] MINIX-fs: blocksize too small for device
> [   35.509687] REISERFS warning (device zram0): sh-2006 read_super_block: bread failed (dev zram0, block 2, size 4096)
> [   35.516867] REISERFS warning (device zram0): sh-2006 read_super_block: bread failed (dev zram0, block 16, size 4096)
> [   35.527721] EXT3-fs (zram0): error: unable to read superblock
> [   35.536435] EXT2-fs (zram0): error: unable to read superblock
> [   35.542614] EXT4-fs (zram0): unable to read superblock
> [   35.549729] MINIX-fs: blocksize too small for device
> [   35.556644] isofs_fill_super: bread failed, dev=zram0, iso_blknum=16, block=0
> [   35.600682] VFS: could not find a valid V7 on zram0.
> [   35.607024] UFS: failed to set blocksize
> [   35.633208] qnx4: unable to read the superblock
> [   35.635867] qnx6: unable to set blocksize
> [   35.638410] ADFS-fs error (device zram0): adfs_fill_super: unable to read superblock
> [   35.662564] ------------[ cut here ]------------
> [   35.664652] WARNING: CPU: 0 PID: 361 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
> [   35.669001] ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0xfe
> [   35.670149] CPU: 0 PID: 361 Comm: mount Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #3
> [   35.670149]  00000000 00000000 8a299d30 8275c9a2 8a299d70 00000000 00000104 8a299d60
> [   35.670149]  8103f5e3 8334fafe 8a299d8c 00000169 8334fb3b 00000104 817001fb 817001fb
> [   35.670149]  8a73ebd8 8355b58c 83323588 8a299d78 8103f641 00000009 8a299d70 8334fafe
> [   35.670149] Call Trace:
> [   35.670149]  [<8275c9a2>] dump_stack+0x7a/0xaa
> [   35.670149]  [<8103f5e3>] warn_slowpath_common+0x8c/0xa3
> [   35.670149]  [<817001fb>] ? debug_print_object+0x94/0xa2
> [   35.670149]  [<817001fb>] ? debug_print_object+0x94/0xa2
> [   35.670149]  [<8103f641>] warn_slowpath_fmt+0x2e/0x30
> [   35.670149]  [<817001fb>] debug_print_object+0x94/0xa2
> [   35.670149]  [<81344703>] ? xfs_buf_unlock+0x17f/0x17f
> [   35.670149]  [<81700f1a>] debug_check_no_obj_freed+0xe2/0x1f8
> [   35.670149]  [<8115aaa1>] kmem_cache_free+0xfe/0x32b
> [   35.670149]  [<81342be0>] xfs_buf_free+0x263/0x26f
> [   35.670149]  [<81343a71>] xfs_buf_rele+0x3e0/0x3f0
> [   35.670149]  [<813635f6>] ? xfs_readsb+0x25e/0x268
> [   35.670149]  [<813635f6>] xfs_readsb+0x25e/0x268
> [   35.670149]  [<827243a5>] ? register_cpu_notifier+0x20/0x27
> [   35.670149]  [<81367344>] xfs_fs_fill_super+0x27d/0x495
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<811666bf>] mount_bdev+0x1d6/0x256
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<8115a80b>] ? __kmalloc_track_caller+0x21a/0x3b2
> [   35.670149]  [<816d87d6>] ? ida_get_new_above+0x24a/0x25b
> [   35.670149]  [<81364b69>] xfs_fs_mount+0x1a/0x1f
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<81166a09>] mount_fs+0x38/0x1b3
> [   35.670149]  [<811395a4>] ? __alloc_percpu+0xa/0xc
> [   35.670149]  [<8118b7ff>] ? alloc_vfsmnt+0x108/0x1d6
> [   35.670149]  [<8118ca68>] vfs_kern_mount+0x97/0x123
> [   35.670149]  [<8118ef8f>] do_mount+0xc8e/0xe0d
> [   35.670149]  [<8118e2e3>] ? copy_mount_string+0x51/0x6f
> [   35.670149]  [<8118f1ee>] SyS_mount+0xe0/0x10d
> [   35.670149]  [<827889ff>] syscall_call+0x7/0xb
> [   35.670149] ---[ end trace d814169ab0ed4dd3 ]---
> [   35.670149] BUG: sleeping function called from invalid context at kernel/workqueue.c:2810
> [   35.670149] in_atomic(): 0, irqs_disabled(): 1, pid: 361, name: mount
> [   35.670149] 1 lock held by mount/361:
> [   35.670149]  #0:  (&type->s_umount_key#34/1){+.+.+.}, at: [<811653be>] sget+0x3d6/0x637
> [   35.670149] irq event stamp: 7098
> [   35.670149] hardirqs last  enabled at (7097): [<8111f635>] free_hot_cold_page+0x181/0x192
> [   35.670149] hardirqs last disabled at (7098): [<8115aa67>] kmem_cache_free+0xc4/0x32b
> [   35.670149] softirqs last  enabled at (6714): [<81045986>] __do_softirq+0x4ac/0x4db
> [   35.670149] softirqs last disabled at (6687): [<81045b17>] irq_exit+0x7d/0xf9
> [   35.670149] CPU: 0 PID: 361 Comm: mount Tainted: G        W    3.12.0-rc2-next-20130927-03100-ga0cf1ab #3
> [   35.670149]  00000000 00000000 8a299ca4 8275c9a2 00000169 00000000 00000000 8a299ccc
> [   35.670149]  810839ec 832cbaff 00000000 00000001 00000169 8a2f0cc0 8a058eb8 8a058ec8
> [   35.670149]  00000000 8a299d48 81061709 008fc482 00000001 8a2f0ad0 00000046 00000046
> [   35.670149] Call Trace:
> [   35.670149]  [<8275c9a2>] dump_stack+0x7a/0xaa
> [   35.670149]  [<810839ec>] __might_sleep+0x238/0x240
> [   35.670149]  [<81061709>] __flush_work+0x27/0x2a1
> [   35.670149]  [<810ae849>] ? __lock_is_held+0x2e/0x44
> [   35.670149]  [<8106426f>] ? drain_workqueue+0x365/0x365
> [   35.670149]  [<810642be>] flush_work+0x4f/0x56
> [   35.670149]  [<8106426f>] ? drain_workqueue+0x365/0x365
> [   35.670149]  [<8106441b>] __cancel_work_timer+0x156/0x1f9
> [   35.670149]  [<810644ca>] ? cancel_work_sync+0xc/0xc
> [   35.670149]  [<810644c8>] cancel_work_sync+0xa/0xc
> [   35.670149]  [<810644da>] work_fixup_free+0x10/0x27
> [   35.670149]  [<816ffffb>] debug_object_fixup+0x27/0x35
> [   35.670149]  [<81700f3d>] debug_check_no_obj_freed+0x105/0x1f8
> [   35.670149]  [<8115aaa1>] kmem_cache_free+0xfe/0x32b
> [   35.670149]  [<81342be0>] xfs_buf_free+0x263/0x26f
> [   35.670149]  [<81343a71>] xfs_buf_rele+0x3e0/0x3f0
> [   35.670149]  [<813635f6>] ? xfs_readsb+0x25e/0x268
> [   35.670149]  [<813635f6>] xfs_readsb+0x25e/0x268
> [   35.670149]  [<827243a5>] ? register_cpu_notifier+0x20/0x27
> [   35.670149]  [<81367344>] xfs_fs_fill_super+0x27d/0x495
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<811666bf>] mount_bdev+0x1d6/0x256
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<8115a80b>] ? __kmalloc_track_caller+0x21a/0x3b2
> [   35.670149]  [<816d87d6>] ? ida_get_new_above+0x24a/0x25b
> [   35.670149]  [<81364b69>] xfs_fs_mount+0x1a/0x1f
> [   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
> [   35.670149]  [<81166a09>] mount_fs+0x38/0x1b3
> [   35.670149]  [<811395a4>] ? __alloc_percpu+0xa/0xc
> [   35.670149]  [<8118b7ff>] ? alloc_vfsmnt+0x108/0x1d6
> [   35.670149]  [<8118ca68>] vfs_kern_mount+0x97/0x123
> [   35.670149]  [<8118ef8f>] do_mount+0xc8e/0xe0d
> [   35.670149]  [<8118e2e3>] ? copy_mount_string+0x51/0x6f
> [   35.670149]  [<8118f1ee>] SyS_mount+0xe0/0x10d
> [   35.670149]  [<827889ff>] syscall_call+0x7/0xb
> [   35.877144] grow_buffers: requested out-of-range block 4503599627370495 for device zram0
> [   35.880821] NILFS: unable to read superblock
> [   35.883432] BeFS(zram0): No write support. Marking filesystem read-only
> [   35.886476] BeFS(zram0): unable to read superblock
> [   35.889310] (mount,361,0):ocfs2_get_sector:1861 ERROR: status = -5
> [   35.892226] (mount,361,0):ocfs2_sb_probe:770 ERROR: status = -5
> [   35.894793] (mount,361,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
> [   35.897836] (mount,361,0):ocfs2_fill_super:1229 ERROR: status = -5
> [   35.901698] gfs2: error -5 reading superblock
> [   35.904062] GFS2: gfs2 mount does not exist
> [   35.906488] F2FS-fs (zram0): unable to read first superblock
> [   35.908941] F2FS-fs (zram0): unable to read second superblock
> Starting Bootlog daemon: bootlogd.
> [   36.114168] GFS2: path_lookup on rootfs returned error -2
> Configuring network interfaces... ifconfig: socket: Address family not supported by protocol
> done.
> hwclock: can't open '/dev/misc/rtc': No such file or directory
> Running postinst /etc/rpm-postinsts/100...
> 
> wfg: skip syslogd
> Kernel tests: Boot OK!Kernel tests: Boot OK!
> 
> Trinity v1.0  Dave Jones <davej@redhat.com> 2012
> Trinity v1.0  Dave Jones <davej@redhat.com> 2012
> Trinity v1.0  Dave Jones <davej@redhat.com> 2012
> No idea what syscall (get_robust_list) is.
> Trinity v1.0  Dave Jones <davej@redhat.com> 2012
> No idea what syscall (get_robust_list) is.
> Don't run as root (or pass --dangerous if you know what you are doing).
> Couldn't find socket cachefile. Regenerating.
> fcntl F_WRLCK F_SETLKW: Permission denied
> 
> BUG: kernel boot oops
> Elapsed time: 40
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-j0-10042023/a0cf1abc25ac197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next-20130927-03100-ga0cf1ab -append 'hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-j0-10042023/next:master/.vmlinuz-a0cf1abc25ac197dd97b857c0f6341066a8cb1cf-20131004225358-4-jaketown branch=next/master BOOT_IMAGE=/kernel/i386-randconfig-j0-10042023/a0cf1abc25ac197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next-20130927-03100-ga0cf1ab'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 256M -smp 2 -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio -net user,vlan=0,hostfwd=tcp::13376-:22 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -pidfil
 e /dev/shm/kboot/pid-yocto-jaketown-25 -serial file:/dev/shm/kboot/serial-yocto-jaketown-25 -daemonize -display none -monitor null 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.12.0-rc2 Kernel Configuration
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
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
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
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> CONFIG_KERNEL_LZO=y
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> # CONFIG_FHANDLE is not set
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
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
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
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> # CONFIG_NO_HZ is not set
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> # CONFIG_TICK_CPU_ACCOUNTING is not set
> CONFIG_IRQ_TIME_ACCOUNTING=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> CONFIG_TASKSTATS=y
> # CONFIG_TASK_DELAY_ACCT is not set
> # CONFIG_TASK_XACCT is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FANOUT_EXACT=y
> CONFIG_RCU_FAST_NO_HZ=y
> CONFIG_TREE_RCU_TRACE=y
> # CONFIG_RCU_NOCB_CPU is not set
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
> # CONFIG_NET_NS is not set
> # CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_RD_LZ4 is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> # CONFIG_PCSPKR_PLATFORM is not set
> # CONFIG_BASE_FULL is not set
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> # CONFIG_TIMERFD is not set
> # CONFIG_EVENTFD is not set
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
> # CONFIG_VM_EVENT_COUNTERS is not set
> CONFIG_COMPAT_BRK=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> CONFIG_OPROFILE=y
> # CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_JUMP_LABEL=y
> CONFIG_UPROBES=y
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
> CONFIG_USE_GENERIC_SMP_HELPERS=y
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
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=1
> # CONFIG_MODULES is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> # CONFIG_BLK_DEV_INTEGRITY is not set
> CONFIG_BLK_CMDLINE_PARSER=y
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
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_PADATA=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> # CONFIG_ZONE_DMA is not set
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_BIGSMP=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_32_IRIS is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_LGUEST_GUEST is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> CONFIG_M586MMX=y
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
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> # CONFIG_X86_PPRO_FENCE is not set
> CONFIG_X86_F00F_BUG=y
> CONFIG_X86_ALIGNMENT_16=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_TSC=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_PROCESSOR_SELECT=y
> # CONFIG_CPU_SUP_INTEL is not set
> # CONFIG_CPU_SUP_CYRIX_32 is not set
> CONFIG_CPU_SUP_AMD=y
> # CONFIG_CPU_SUP_CENTAUR is not set
> # CONFIG_CPU_SUP_TRANSMETA_32 is not set
> # CONFIG_CPU_SUP_UMC_32 is not set
> CONFIG_HPET_TIMER=y
> # CONFIG_DMI is not set
> CONFIG_NR_CPUS=32
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> # CONFIG_VM86 is not set
> CONFIG_TOSHIBA=y
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_LIB=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> # CONFIG_VMSPLIT_3G is not set
> # CONFIG_VMSPLIT_3G_OPT is not set
> CONFIG_VMSPLIT_2G=y
> # CONFIG_VMSPLIT_2G_OPT is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0x80000000
> # CONFIG_X86_PAE is not set
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
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> # CONFIG_CLEANCACHE is not set
> CONFIG_CMA=y
> CONFIG_CMA_DEBUG=y
> # CONFIG_ZBUD is not set
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> # CONFIG_X86_PAT is not set
> # CONFIG_ARCH_RANDOM is not set
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> CONFIG_CC_STACKPROTECTOR=y
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
> CONFIG_DEBUG_HOTPLUG_CPU0=y
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> # CONFIG_PM_ADVANCED_DEBUG is not set
> CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
> CONFIG_ACPI=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_APEI is not set
> CONFIG_SFI=y
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
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> CONFIG_PCI_GOMMCONFIG=y
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> # CONFIG_PCI_GOANY is not set
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_CNB20LE_QUIRK=y
> CONFIG_PCIEPORTBUS=y
> # CONFIG_HOTPLUG_PCI_PCIE is not set
> # CONFIG_PCIEAER is not set
> # CONFIG_PCIEASPM is not set
> CONFIG_PCIE_PME=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> CONFIG_PCI_REALLOC_ENABLE_AUTO=y
> CONFIG_PCI_STUB=y
> CONFIG_HT_IRQ=y
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> # CONFIG_PCI_PRI is not set
> CONFIG_PCI_PASID=y
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> CONFIG_SCx200=y
> CONFIG_SCx200HR_TIMER=y
> CONFIG_OLPC=y
> # CONFIG_OLPC_XO15_SCI is not set
> CONFIG_ALIX=y
> # CONFIG_NET5501 is not set
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> # CONFIG_CARDBUS is not set
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_ACPI is not set
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> # CONFIG_HOTPLUG_PCI_SHPC is not set
> CONFIG_RAPIDIO=y
> CONFIG_RAPIDIO_TSI721=y
> CONFIG_RAPIDIO_DISC_TIMEOUT=30
> CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
> CONFIG_RAPIDIO_DMA_ENGINE=y
> CONFIG_RAPIDIO_DEBUG=y
> CONFIG_RAPIDIO_ENUM_BASIC=y
> 
> #
> # RapidIO Switch drivers
> #
> # CONFIG_RAPIDIO_TSI57X is not set
> # CONFIG_RAPIDIO_CPS_XX is not set
> CONFIG_RAPIDIO_TSI568=y
> CONFIG_RAPIDIO_CPS_GEN2=y
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
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
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> CONFIG_UNIX_DIAG=y
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> CONFIG_NET_KEY=y
> # CONFIG_NET_KEY_MIGRATE is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> CONFIG_ATM=y
> CONFIG_ATM_LANE=y
> CONFIG_STP=y
> CONFIG_BRIDGE=y
> CONFIG_HAVE_NET_DSA=y
> CONFIG_NET_DSA=y
> CONFIG_NET_DSA_TAG_DSA=y
> CONFIG_NET_DSA_TAG_TRAILER=y
> # CONFIG_VLAN_8021Q is not set
> CONFIG_DECNET=y
> # CONFIG_DECNET_ROUTER is not set
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> CONFIG_IPX=y
> CONFIG_IPX_INTERN=y
> CONFIG_ATALK=y
> CONFIG_DEV_APPLETALK=y
> CONFIG_IPDDP=y
> # CONFIG_IPDDP_ENCAP is not set
> CONFIG_X25=y
> CONFIG_LAPB=y
> CONFIG_PHONET=y
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> CONFIG_BATMAN_ADV=y
> # CONFIG_BATMAN_ADV_NC is not set
> CONFIG_BATMAN_ADV_DEBUG=y
> CONFIG_OPENVSWITCH=y
> CONFIG_VSOCKETS=y
> CONFIG_VMWARE_VMCI_VSOCKETS=y
> # CONFIG_NETLINK_MMAP is not set
> CONFIG_NETLINK_DIAG=y
> CONFIG_NET_MPLS_GSO=y
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> # CONFIG_AX25 is not set
> CONFIG_CAN=y
> CONFIG_CAN_RAW=y
> # CONFIG_CAN_BCM is not set
> # CONFIG_CAN_GW is not set
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=y
> # CONFIG_CAN_SLCAN is not set
> CONFIG_CAN_DEV=y
> CONFIG_CAN_CALC_BITTIMING=y
> # CONFIG_CAN_LEDS is not set
> CONFIG_CAN_JANZ_ICAN3=y
> CONFIG_PCH_CAN=y
> # CONFIG_CAN_GRCAN is not set
> CONFIG_CAN_SJA1000=y
> # CONFIG_CAN_SJA1000_ISA is not set
> CONFIG_CAN_SJA1000_PLATFORM=y
> CONFIG_CAN_SJA1000_OF_PLATFORM=y
> # CONFIG_CAN_EMS_PCI is not set
> # CONFIG_CAN_PEAK_PCI is not set
> CONFIG_CAN_KVASER_PCI=y
> # CONFIG_CAN_PLX_PCI is not set
> # CONFIG_CAN_C_CAN is not set
> CONFIG_CAN_CC770=y
> # CONFIG_CAN_CC770_ISA is not set
> # CONFIG_CAN_CC770_PLATFORM is not set
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
> CONFIG_BT=y
> # CONFIG_BT_RFCOMM is not set
> CONFIG_BT_BNEP=y
> CONFIG_BT_BNEP_MC_FILTER=y
> # CONFIG_BT_BNEP_PROTO_FILTER is not set
> # CONFIG_BT_HIDP is not set
> 
> #
> # Bluetooth device drivers
> #
> # CONFIG_BT_HCIBTUSB is not set
> # CONFIG_BT_HCIUART is not set
> CONFIG_BT_HCIBCM203X=y
> CONFIG_BT_HCIBPA10X=y
> CONFIG_BT_HCIBFUSB=y
> CONFIG_BT_HCIVHCI=y
> CONFIG_BT_MRVL=y
> # CONFIG_WIRELESS is not set
> # CONFIG_WIMAX is not set
> CONFIG_RFKILL=y
> CONFIG_RFKILL_LEDS=y
> # CONFIG_RFKILL_INPUT is not set
> CONFIG_RFKILL_REGULATOR=y
> # CONFIG_NET_9P is not set
> CONFIG_CAIF=y
> # CONFIG_CAIF_DEBUG is not set
> # CONFIG_CAIF_NETDEV is not set
> CONFIG_CAIF_USB=y
> # CONFIG_NFC is not set
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
> CONFIG_STANDALONE=y
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
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> CONFIG_DMA_CMA=y
> 
> #
> # Default contiguous memory area size:
> #
> CONFIG_CMA_SIZE_PERCENTAGE=10
> # CONFIG_CMA_SIZE_SEL_MBYTES is not set
> CONFIG_CMA_SIZE_SEL_PERCENTAGE=y
> # CONFIG_CMA_SIZE_SEL_MIN is not set
> # CONFIG_CMA_SIZE_SEL_MAX is not set
> CONFIG_CMA_ALIGNMENT=8
> CONFIG_CMA_AREAS=7
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> # CONFIG_PROC_EVENTS is not set
> CONFIG_MTD=y
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
> CONFIG_MTD_REDBOOT_PARTS_READONLY=y
> CONFIG_MTD_CMDLINE_PARTS=y
> CONFIG_MTD_OF_PARTS=y
> CONFIG_MTD_AR7_PARTS=y
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=y
> CONFIG_FTL=y
> CONFIG_NFTL=y
> CONFIG_NFTL_RW=y
> CONFIG_INFTL=y
> CONFIG_RFD_FTL=y
> CONFIG_SSFDC=y
> CONFIG_SM_FTL=y
> # CONFIG_MTD_OOPS is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=y
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> CONFIG_MTD_ROM=y
> # CONFIG_MTD_ABSENT is not set
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> CONFIG_MTD_PHYSMAP=y
> # CONFIG_MTD_PHYSMAP_COMPAT is not set
> CONFIG_MTD_PHYSMAP_OF=y
> CONFIG_MTD_SC520CDP=y
> CONFIG_MTD_NETSC520=y
> CONFIG_MTD_TS5500=y
> # CONFIG_MTD_SCx200_DOCFLASH is not set
> CONFIG_MTD_AMD76XROM=y
> CONFIG_MTD_ICHXROM=y
> # CONFIG_MTD_ESB2ROM is not set
> CONFIG_MTD_CK804XROM=y
> CONFIG_MTD_SCB2_FLASH=y
> # CONFIG_MTD_NETtel is not set
> CONFIG_MTD_L440GX=y
> # CONFIG_MTD_INTEL_VR_NOR is not set
> # CONFIG_MTD_PLATRAM is not set
> 
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_PMC551=y
> # CONFIG_MTD_PMC551_BUGFIX is not set
> CONFIG_MTD_PMC551_DEBUG=y
> CONFIG_MTD_SLRAM=y
> CONFIG_MTD_PHRAM=y
> CONFIG_MTD_MTDRAM=y
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTDRAM_ABS_POS=0
> CONFIG_MTD_BLOCK2MTD=y
> 
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOCG3 is not set
> CONFIG_MTD_NAND_ECC=y
> CONFIG_MTD_NAND_ECC_SMC=y
> # CONFIG_MTD_NAND is not set
> CONFIG_MTD_ONENAND=y
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> CONFIG_MTD_ONENAND_GENERIC=y
> CONFIG_MTD_ONENAND_OTP=y
> # CONFIG_MTD_ONENAND_2X_PROGRAM is not set
> 
> #
> # LPDDR flash memory drivers
> #
> CONFIG_MTD_LPDDR=y
> CONFIG_MTD_QINFO_PROBE=y
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> CONFIG_MTD_UBI_FASTMAP=y
> CONFIG_MTD_UBI_GLUEBI=y
> CONFIG_OF=y
> 
> #
> # Device Tree and Open Firmware support
> #
> CONFIG_PROC_DEVICETREE=y
> # CONFIG_OF_SELFTEST is not set
> CONFIG_OF_PROMTREE=y
> CONFIG_OF_ADDRESS=y
> CONFIG_OF_IRQ=y
> CONFIG_OF_NET=y
> CONFIG_OF_MDIO=y
> CONFIG_OF_PCI=y
> CONFIG_OF_PCI_IRQ=y
> CONFIG_OF_MTD=y
> CONFIG_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_SERIAL is not set
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_VIRTIO_BLK is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RSXX is not set
> # CONFIG_BLOCKCONSOLE is not set
> 
> #
> # Misc devices
> #
> # CONFIG_SENSORS_LIS3LV02D is not set
> CONFIG_AD525X_DPOT=y
> # CONFIG_AD525X_DPOT_I2C is not set
> CONFIG_DUMMY_IRQ=y
> # CONFIG_IBM_ASM is not set
> CONFIG_PHANTOM=y
> # CONFIG_INTEL_MID_PTI is not set
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> CONFIG_TIFM_7XX1=y
> # CONFIG_ICS932S401 is not set
> # CONFIG_ATMEL_SSC is not set
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_CS5535_MFGPT is not set
> CONFIG_HP_ILO=y
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=y
> CONFIG_SENSORS_APDS990X=y
> # CONFIG_HMC6352 is not set
> CONFIG_DS1682=y
> CONFIG_VMWARE_BALLOON=y
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=y
> CONFIG_PCH_PHUB=y
> CONFIG_USB_SWITCH_FSA9480=y
> # CONFIG_SRAM is not set
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_LEGACY=y
> CONFIG_EEPROM_MAX6875=y
> CONFIG_EEPROM_93CX6=y
> # CONFIG_CB710_CORE is not set
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
> CONFIG_ALTERA_STAPL=y
> CONFIG_INTEL_MEI=y
> CONFIG_INTEL_MEI_ME=y
> CONFIG_VMWARE_VMCI=y
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
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
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
> # CONFIG_SCSI_ENCLOSURE is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> # CONFIG_SCSI_FC_TGT_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_BOOT_SYSFS=y
> CONFIG_SCSI_BNX2_ISCSI=y
> CONFIG_SCSI_BNX2X_FCOE=y
> CONFIG_BE2ISCSI=y
> CONFIG_BLK_DEV_3W_XXXX_RAID=y
> CONFIG_SCSI_HPSA=y
> CONFIG_SCSI_3W_9XXX=y
> CONFIG_SCSI_3W_SAS=y
> # CONFIG_SCSI_ACARD is not set
> CONFIG_SCSI_AACRAID=y
> # CONFIG_SCSI_AIC7XXX is not set
> CONFIG_SCSI_AIC7XXX_OLD=y
> CONFIG_SCSI_AIC79XX=y
> CONFIG_AIC79XX_CMDS_PER_DEVICE=32
> CONFIG_AIC79XX_RESET_DELAY_MS=5000
> CONFIG_AIC79XX_DEBUG_ENABLE=y
> CONFIG_AIC79XX_DEBUG_MASK=0
> # CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
> # CONFIG_SCSI_AIC94XX is not set
> CONFIG_SCSI_MVSAS=y
> CONFIG_SCSI_MVSAS_DEBUG=y
> # CONFIG_SCSI_MVSAS_TASKLET is not set
> CONFIG_SCSI_MVUMI=y
> # CONFIG_SCSI_DPT_I2O is not set
> CONFIG_SCSI_ADVANSYS=y
> CONFIG_SCSI_ARCMSR=y
> # CONFIG_SCSI_ESAS2R is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> CONFIG_MEGARAID_LEGACY=y
> CONFIG_MEGARAID_SAS=y
> # CONFIG_SCSI_MPT2SAS is not set
> CONFIG_SCSI_MPT3SAS=y
> CONFIG_SCSI_MPT3SAS_MAX_SGE=128
> # CONFIG_SCSI_MPT3SAS_LOGGING is not set
> CONFIG_SCSI_UFSHCD=y
> CONFIG_SCSI_UFSHCD_PCI=y
> CONFIG_SCSI_UFSHCD_PLATFORM=y
> CONFIG_SCSI_HPTIOP=y
> CONFIG_SCSI_BUSLOGIC=y
> # CONFIG_SCSI_FLASHPOINT is not set
> CONFIG_VMWARE_PVSCSI=y
> CONFIG_LIBFC=y
> CONFIG_LIBFCOE=y
> CONFIG_FCOE=y
> CONFIG_FCOE_FNIC=y
> CONFIG_SCSI_DMX3191D=y
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> CONFIG_SCSI_GDTH=y
> # CONFIG_SCSI_ISCI is not set
> # CONFIG_SCSI_IPS is not set
> CONFIG_SCSI_INITIO=y
> CONFIG_SCSI_INIA100=y
> CONFIG_SCSI_PPA=y
> CONFIG_SCSI_IMM=y
> CONFIG_SCSI_IZIP_EPP16=y
> CONFIG_SCSI_IZIP_SLOW_CTR=y
> CONFIG_SCSI_STEX=y
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> CONFIG_SCSI_QLOGIC_1280=y
> # CONFIG_SCSI_QLA_FC is not set
> CONFIG_SCSI_QLA_ISCSI=y
> # CONFIG_SCSI_LPFC is not set
> CONFIG_SCSI_DC395x=y
> CONFIG_SCSI_DC390T=y
> # CONFIG_SCSI_NSP32 is not set
> # CONFIG_SCSI_DEBUG is not set
> CONFIG_SCSI_PMCRAID=y
> # CONFIG_SCSI_PM8001 is not set
> # CONFIG_SCSI_SRP is not set
> CONFIG_SCSI_BFA_FC=y
> CONFIG_SCSI_VIRTIO=y
> CONFIG_SCSI_CHELSIO_FCOE=y
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> CONFIG_SCSI_DH_HP_SW=y
> CONFIG_SCSI_DH_EMC=y
> CONFIG_SCSI_DH_ALUA=y
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> CONFIG_SATA_AHCI=y
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> CONFIG_SATA_ACARD_AHCI=y
> # CONFIG_SATA_SIL24 is not set
> # CONFIG_ATA_SFF is not set
> # CONFIG_MD is not set
> CONFIG_TARGET_CORE=y
> # CONFIG_TCM_IBLOCK is not set
> # CONFIG_TCM_FILEIO is not set
> CONFIG_TCM_PSCSI=y
> CONFIG_LOOPBACK_TARGET=y
> CONFIG_TCM_FC=y
> CONFIG_ISCSI_TARGET=y
> CONFIG_SBP_TARGET=y
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> CONFIG_FIREWIRE_OHCI=y
> # CONFIG_FIREWIRE_SBP2 is not set
> CONFIG_FIREWIRE_NOSY=y
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> CONFIG_NET_CORE=y
> CONFIG_DUMMY=y
> CONFIG_EQUALIZER=y
> # CONFIG_NET_FC is not set
> CONFIG_NET_TEAM=y
> CONFIG_NET_TEAM_MODE_BROADCAST=y
> # CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
> CONFIG_NET_TEAM_MODE_RANDOM=y
> CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
> # CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
> # CONFIG_MACVLAN is not set
> CONFIG_NETCONSOLE=y
> # CONFIG_NETCONSOLE_DYNAMIC is not set
> CONFIG_NETPOLL=y
> # CONFIG_NETPOLL_TRAP is not set
> CONFIG_NET_POLL_CONTROLLER=y
> CONFIG_RIONET=y
> CONFIG_RIONET_TX_SIZE=128
> CONFIG_RIONET_RX_SIZE=128
> CONFIG_TUN=y
> CONFIG_VETH=y
> CONFIG_VIRTIO_NET=y
> CONFIG_NLMON=y
> CONFIG_SUNGEM_PHY=y
> CONFIG_ARCNET=y
> CONFIG_ARCNET_1201=y
> CONFIG_ARCNET_1051=y
> CONFIG_ARCNET_RAW=y
> CONFIG_ARCNET_CAP=y
> CONFIG_ARCNET_COM90xx=y
> CONFIG_ARCNET_COM90xxIO=y
> CONFIG_ARCNET_RIM_I=y
> # CONFIG_ARCNET_COM20020 is not set
> # CONFIG_ATM_DRIVERS is not set
> 
> #
> # CAIF transport drivers
> #
> # CONFIG_CAIF_TTY is not set
> CONFIG_CAIF_SPI_SLAVE=y
> # CONFIG_CAIF_SPI_SYNC is not set
> CONFIG_CAIF_HSI=y
> CONFIG_CAIF_VIRTIO=y
> CONFIG_VHOST_RING=y
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_NET_DSA_MV88E6XXX=y
> CONFIG_NET_DSA_MV88E6060=y
> CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
> CONFIG_NET_DSA_MV88E6131=y
> # CONFIG_NET_DSA_MV88E6123_61_65 is not set
> CONFIG_ETHERNET=y
> CONFIG_MDIO=y
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> CONFIG_NET_VENDOR_ALTEON=y
> # CONFIG_ACENIC is not set
> CONFIG_NET_VENDOR_AMD=y
> CONFIG_AMD8111_ETH=y
> CONFIG_PCNET32=y
> # CONFIG_NET_VENDOR_ARC is not set
> # CONFIG_NET_VENDOR_ATHEROS is not set
> # CONFIG_NET_CADENCE is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=y
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> CONFIG_BNX2=y
> CONFIG_CNIC=y
> # CONFIG_TIGON3 is not set
> CONFIG_BNX2X=y
> CONFIG_BNX2X_SRIOV=y
> CONFIG_NET_VENDOR_BROCADE=y
> CONFIG_BNA=y
> CONFIG_NET_CALXEDA_XGMAC=y
> CONFIG_NET_VENDOR_CHELSIO=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T4 is not set
> CONFIG_CHELSIO_T4VF=y
> CONFIG_NET_VENDOR_CISCO=y
> CONFIG_ENIC=y
> # CONFIG_DNET is not set
> CONFIG_NET_VENDOR_DEC=y
> CONFIG_NET_TULIP=y
> CONFIG_DE2104X=y
> CONFIG_DE2104X_DSL=0
> CONFIG_TULIP=y
> CONFIG_TULIP_MWI=y
> CONFIG_TULIP_MMIO=y
> # CONFIG_TULIP_NAPI is not set
> CONFIG_DE4X5=y
> CONFIG_WINBOND_840=y
> # CONFIG_DM9102 is not set
> # CONFIG_ULI526X is not set
> CONFIG_NET_VENDOR_DLINK=y
> # CONFIG_DL2K is not set
> # CONFIG_SUNDANCE is not set
> CONFIG_NET_VENDOR_EMULEX=y
> CONFIG_BE2NET=y
> # CONFIG_NET_VENDOR_EXAR is not set
> CONFIG_NET_VENDOR_HP=y
> # CONFIG_HP100 is not set
> # CONFIG_NET_VENDOR_INTEL is not set
> CONFIG_IP1000=y
> CONFIG_JME=y
> CONFIG_NET_VENDOR_MARVELL=y
> # CONFIG_MVMDIO is not set
> CONFIG_SKGE=y
> # CONFIG_SKGE_DEBUG is not set
> # CONFIG_SKGE_GENESIS is not set
> CONFIG_SKY2=y
> # CONFIG_SKY2_DEBUG is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> CONFIG_MLX4_EN=y
> CONFIG_MLX4_CORE=y
> CONFIG_MLX4_DEBUG=y
> CONFIG_MLX5_CORE=y
> CONFIG_NET_VENDOR_MICREL=y
> CONFIG_KS8842=y
> # CONFIG_KS8851_MLL is not set
> CONFIG_KSZ884X_PCI=y
> CONFIG_FEALNX=y
> CONFIG_NET_VENDOR_NATSEMI=y
> CONFIG_NATSEMI=y
> CONFIG_NS83820=y
> CONFIG_NET_VENDOR_8390=y
> CONFIG_NE2K_PCI=y
> CONFIG_NET_VENDOR_NVIDIA=y
> # CONFIG_FORCEDETH is not set
> # CONFIG_NET_VENDOR_OKI is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_PACKET_ENGINE is not set
> # CONFIG_NET_VENDOR_QLOGIC is not set
> CONFIG_NET_VENDOR_REALTEK=y
> CONFIG_ATP=y
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> CONFIG_R8169=y
> CONFIG_SH_ETH=y
> CONFIG_NET_VENDOR_RDC=y
> # CONFIG_R6040 is not set
> CONFIG_NET_VENDOR_SEEQ=y
> # CONFIG_NET_VENDOR_SILAN is not set
> CONFIG_NET_VENDOR_SIS=y
> CONFIG_SIS900=y
> CONFIG_SIS190=y
> CONFIG_SFC=y
> # CONFIG_SFC_MTD is not set
> CONFIG_SFC_MCDI_MON=y
> # CONFIG_SFC_SRIOV is not set
> CONFIG_NET_VENDOR_SMSC=y
> CONFIG_EPIC100=y
> CONFIG_SMSC911X=y
> # CONFIG_SMSC911X_ARCH_HOOKS is not set
> CONFIG_SMSC9420=y
> CONFIG_NET_VENDOR_STMICRO=y
> CONFIG_STMMAC_ETH=y
> CONFIG_STMMAC_PLATFORM=y
> CONFIG_STMMAC_PCI=y
> CONFIG_STMMAC_DEBUG_FS=y
> # CONFIG_STMMAC_DA is not set
> CONFIG_NET_VENDOR_SUN=y
> CONFIG_HAPPYMEAL=y
> CONFIG_SUNGEM=y
> # CONFIG_CASSINI is not set
> CONFIG_NIU=y
> CONFIG_NET_VENDOR_TEHUTI=y
> CONFIG_TEHUTI=y
> CONFIG_NET_VENDOR_TI=y
> CONFIG_TLAN=y
> CONFIG_NET_VENDOR_VIA=y
> # CONFIG_VIA_RHINE is not set
> CONFIG_VIA_VELOCITY=y
> # CONFIG_NET_VENDOR_WIZNET is not set
> CONFIG_FDDI=y
> CONFIG_DEFXX=y
> CONFIG_DEFXX_MMIO=y
> # CONFIG_SKFP is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AT803X_PHY=y
> CONFIG_AMD_PHY=y
> CONFIG_MARVELL_PHY=y
> CONFIG_DAVICOM_PHY=y
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=y
> # CONFIG_CICADA_PHY is not set
> CONFIG_VITESSE_PHY=y
> CONFIG_SMSC_PHY=y
> CONFIG_BROADCOM_PHY=y
> CONFIG_BCM87XX_PHY=y
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> CONFIG_NATIONAL_PHY=y
> CONFIG_STE10XP=y
> CONFIG_LSI_ET1011C_PHY=y
> CONFIG_MICREL_PHY=y
> CONFIG_FIXED_PHY=y
> CONFIG_MDIO_BITBANG=y
> # CONFIG_MDIO_GPIO is not set
> # CONFIG_MDIO_BUS_MUX_GPIO is not set
> # CONFIG_MDIO_BUS_MUX_MMIOREG is not set
> # CONFIG_PLIP is not set
> CONFIG_PPP=y
> # CONFIG_PPP_BSDCOMP is not set
> CONFIG_PPP_DEFLATE=y
> # CONFIG_PPP_FILTER is not set
> CONFIG_PPP_MPPE=y
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPPOATM=y
> CONFIG_PPPOE=y
> # CONFIG_PPP_ASYNC is not set
> # CONFIG_PPP_SYNC_TTY is not set
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
> 
> #
> # USB Network Adapters
> #
> CONFIG_USB_CATC=y
> CONFIG_USB_KAWETH=y
> CONFIG_USB_PEGASUS=y
> CONFIG_USB_RTL8150=y
> CONFIG_USB_RTL8152=y
> # CONFIG_USB_USBNET is not set
> # CONFIG_USB_HSO is not set
> # CONFIG_USB_CDC_PHONET is not set
> # CONFIG_USB_IPHETH is not set
> # CONFIG_WLAN is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
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
> # CONFIG_KEYBOARD_ADP5520 is not set
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
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_STMPE is not set
> # CONFIG_KEYBOARD_TC3589X is not set
> # CONFIG_KEYBOARD_TWL4030 is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_PS2_OLPC is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_CYAPA is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_GPIO is not set
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
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
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> CONFIG_SERIO_PARKBD=y
> CONFIG_SERIO_PCIPS2=y
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> # CONFIG_SERIO_ALTERA_PS2 is not set
> CONFIG_SERIO_PS2MULT=y
> # CONFIG_SERIO_ARC_PS2 is not set
> CONFIG_SERIO_APBPS2=y
> # CONFIG_SERIO_OLPC_APSP is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
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
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_OF_PLATFORM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_SERIAL_ST_ASC is not set
> # CONFIG_TTY_PRINTK is not set
> CONFIG_PRINTER=y
> CONFIG_LP_CONSOLE=y
> CONFIG_PPDEV=y
> # CONFIG_VIRTIO_CONSOLE is not set
> CONFIG_IPMI_HANDLER=y
> CONFIG_IPMI_PANIC_EVENT=y
> CONFIG_IPMI_PANIC_STRING=y
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> # CONFIG_IPMI_WATCHDOG is not set
> CONFIG_IPMI_POWEROFF=y
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> # CONFIG_SCx200_GPIO is not set
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> # CONFIG_I2C_MUX is not set
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=y
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> # CONFIG_I2C_ALGOPCF is not set
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=y
> CONFIG_I2C_ALI1563=y
> # CONFIG_I2C_ALI15X3 is not set
> CONFIG_I2C_AMD756=y
> CONFIG_I2C_AMD756_S4882=y
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> CONFIG_I2C_ISCH=y
> CONFIG_I2C_ISMT=y
> CONFIG_I2C_PIIX4=y
> CONFIG_I2C_NFORCE2=y
> # CONFIG_I2C_NFORCE2_S4985 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> CONFIG_I2C_SIS96X=y
> # CONFIG_I2C_VIA is not set
> CONFIG_I2C_VIAPRO=y
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
> CONFIG_I2C_EG20T=y
> CONFIG_I2C_GPIO=y
> CONFIG_I2C_KEMPLD=y
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> # CONFIG_I2C_PARPORT is not set
> CONFIG_I2C_PARPORT_LIGHT=y
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> # CONFIG_I2C_VIPERBOARD is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
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
> CONFIG_NTP_PPS=y
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> # CONFIG_PPS_CLIENT_LDISC is not set
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
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIOLIB=y
> CONFIG_OF_GPIO=y
> CONFIG_GPIO_ACPI=y
> CONFIG_DEBUG_GPIO=y
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=y
> # CONFIG_GPIO_DA9052 is not set
> # CONFIG_GPIO_DA9055 is not set
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> # CONFIG_GPIO_IT8761E is not set
> # CONFIG_GPIO_F7188X is not set
> CONFIG_GPIO_TS5500=y
> CONFIG_GPIO_SCH=y
> CONFIG_GPIO_ICH=y
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> # CONFIG_GPIO_GRGPIO is not set
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> CONFIG_GPIO_MAX7300=y
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCA953X is not set
> # CONFIG_GPIO_PCF857X is not set
> CONFIG_GPIO_SX150X=y
> CONFIG_GPIO_STMPE=y
> CONFIG_GPIO_TC3589X=y
> CONFIG_GPIO_TWL4030=y
> # CONFIG_GPIO_TWL6040 is not set
> CONFIG_GPIO_WM831X=y
> CONFIG_GPIO_WM8350=y
> # CONFIG_GPIO_WM8994 is not set
> CONFIG_GPIO_ADP5520=y
> CONFIG_GPIO_ADP5588=y
> CONFIG_GPIO_ADP5588_IRQ=y
> # CONFIG_GPIO_ADNP is not set
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_CS5535=y
> CONFIG_GPIO_BT8XX=y
> CONFIG_GPIO_AMD8111=y
> CONFIG_GPIO_LANGWELL=y
> CONFIG_GPIO_PCH=y
> CONFIG_GPIO_ML_IOH=y
> CONFIG_GPIO_SODAVILLE=y
> CONFIG_GPIO_RDC321X=y
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MCP23S08 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> CONFIG_GPIO_UCB1400=y
> 
> #
> # LPC GPIO expanders:
> #
> CONFIG_GPIO_KEMPLD=y
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_JANZ_TTL=y
> CONFIG_GPIO_TPS65910=y
> CONFIG_GPIO_BCM_KONA=y
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_GPIO_VIPERBOARD=y
> CONFIG_W1=y
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2490=y
> CONFIG_W1_MASTER_DS2482=y
> CONFIG_W1_MASTER_DS1WM=y
> # CONFIG_W1_MASTER_GPIO is not set
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> # CONFIG_W1_SLAVE_SMEM is not set
> # CONFIG_W1_SLAVE_DS2408 is not set
> CONFIG_W1_SLAVE_DS2413=y
> CONFIG_W1_SLAVE_DS2423=y
> CONFIG_W1_SLAVE_DS2431=y
> CONFIG_W1_SLAVE_DS2433=y
> CONFIG_W1_SLAVE_DS2433_CRC=y
> # CONFIG_W1_SLAVE_DS2760 is not set
> CONFIG_W1_SLAVE_DS2780=y
> # CONFIG_W1_SLAVE_DS2781 is not set
> # CONFIG_W1_SLAVE_DS28E04 is not set
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> CONFIG_WM831X_BACKUP=y
> CONFIG_WM831X_POWER=y
> CONFIG_WM8350_POWER=y
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_DS2780=y
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=y
> CONFIG_BATTERY_OLPC=y
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> CONFIG_BATTERY_BQ27X00_I2C=y
> CONFIG_BATTERY_BQ27X00_PLATFORM=y
> CONFIG_BATTERY_DA9030=y
> CONFIG_BATTERY_DA9052=y
> CONFIG_BATTERY_MAX17040=y
> # CONFIG_BATTERY_MAX17042 is not set
> CONFIG_BATTERY_TWL4030_MADC=y
> # CONFIG_CHARGER_PCF50633 is not set
> CONFIG_BATTERY_RX51=y
> # CONFIG_CHARGER_ISP1704 is not set
> CONFIG_CHARGER_MAX8903=y
> CONFIG_CHARGER_TWL4030=y
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_BQ2415X is not set
> CONFIG_CHARGER_BQ24190=y
> CONFIG_CHARGER_SMB347=y
> # CONFIG_CHARGER_TPS65090 is not set
> # CONFIG_BATTERY_GOLDFISH is not set
> CONFIG_POWER_RESET=y
> CONFIG_POWER_RESET_GPIO=y
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_AD7414 is not set
> CONFIG_SENSORS_AD7418=y
> CONFIG_SENSORS_ADM1021=y
> CONFIG_SENSORS_ADM1025=y
> CONFIG_SENSORS_ADM1026=y
> CONFIG_SENSORS_ADM1029=y
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7410 is not set
> CONFIG_SENSORS_ADT7411=y
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> CONFIG_SENSORS_K8TEMP=y
> CONFIG_SENSORS_K10TEMP=y
> CONFIG_SENSORS_FAM15H_POWER=y
> # CONFIG_SENSORS_ASB100 is not set
> CONFIG_SENSORS_ATXP1=y
> CONFIG_SENSORS_DS620=y
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_DA9052_ADC=y
> CONFIG_SENSORS_DA9055=y
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=y
> # CONFIG_SENSORS_F71882FG is not set
> CONFIG_SENSORS_F75375S=y
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_G760A=y
> # CONFIG_SENSORS_G762 is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> CONFIG_SENSORS_GPIO_FAN=y
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_HTU21=y
> # CONFIG_SENSORS_CORETEMP is not set
> CONFIG_SENSORS_IBMAEM=y
> # CONFIG_SENSORS_IBMPEX is not set
> CONFIG_SENSORS_IIO_HWMON=y
> CONFIG_SENSORS_IT87=y
> CONFIG_SENSORS_JC42=y
> CONFIG_SENSORS_LINEAGE=y
> CONFIG_SENSORS_LM63=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> # CONFIG_SENSORS_LM77 is not set
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=y
> # CONFIG_SENSORS_LM83 is not set
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> # CONFIG_SENSORS_LM90 is not set
> CONFIG_SENSORS_LM92=y
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4151 is not set
> # CONFIG_SENSORS_LTC4215 is not set
> CONFIG_SENSORS_LTC4245=y
> # CONFIG_SENSORS_LTC4261 is not set
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> CONFIG_SENSORS_MAX6650=y
> CONFIG_SENSORS_MAX6697=y
> CONFIG_SENSORS_MCP3021=y
> CONFIG_SENSORS_NCT6775=y
> CONFIG_SENSORS_NTC_THERMISTOR=y
> CONFIG_SENSORS_PC87360=y
> # CONFIG_SENSORS_PC87427 is not set
> CONFIG_SENSORS_PCF8591=y
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> CONFIG_SENSORS_SMM665=y
> # CONFIG_SENSORS_DME1737 is not set
> CONFIG_SENSORS_EMC1403=y
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_SCH5627 is not set
> # CONFIG_SENSORS_SCH5636 is not set
> CONFIG_SENSORS_ADS1015=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> CONFIG_SENSORS_INA2XX=y
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> CONFIG_SENSORS_TMP401=y
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_TWL4030_MADC is not set
> CONFIG_SENSORS_VIA_CPUTEMP=y
> CONFIG_SENSORS_VIA686A=y
> CONFIG_SENSORS_VT1211=y
> CONFIG_SENSORS_VT8231=y
> # CONFIG_SENSORS_W83781D is not set
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> CONFIG_SENSORS_W83793=y
> # CONFIG_SENSORS_W83795 is not set
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> # CONFIG_SENSORS_W83627HF is not set
> CONFIG_SENSORS_W83627EHF=y
> CONFIG_SENSORS_WM831X=y
> CONFIG_SENSORS_WM8350=y
> # CONFIG_SENSORS_APPLESMC is not set
> CONFIG_SENSORS_MC13783_ADC=y
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_GOV_STEP_WISE is not set
> CONFIG_THERMAL_GOV_USER_SPACE=y
> CONFIG_THERMAL_EMULATION=y
> 
> #
> # Texas Instruments thermal drivers
> #
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=y
> CONFIG_DA9052_WATCHDOG=y
> # CONFIG_DA9055_WATCHDOG is not set
> CONFIG_WM831X_WATCHDOG=y
> # CONFIG_WM8350_WATCHDOG is not set
> CONFIG_TWL4030_WATCHDOG=y
> CONFIG_RETU_WATCHDOG=y
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=y
> CONFIG_ALIM1535_WDT=y
> CONFIG_ALIM7101_WDT=y
> CONFIG_F71808E_WDT=y
> # CONFIG_SP5100_TCO is not set
> # CONFIG_SC520_WDT is not set
> CONFIG_SBC_FITPC2_WATCHDOG=y
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> CONFIG_IBMASR=y
> CONFIG_WAFER_WDT=y
> # CONFIG_I6300ESB_WDT is not set
> CONFIG_IE6XX_WDT=y
> CONFIG_ITCO_WDT=y
> # CONFIG_ITCO_VENDOR_SUPPORT is not set
> # CONFIG_IT8712F_WDT is not set
> CONFIG_IT87_WDT=y
> CONFIG_HP_WATCHDOG=y
> # CONFIG_KEMPLD_WDT is not set
> # CONFIG_HPWDT_NMI_DECODING is not set
> CONFIG_SC1200_WDT=y
> CONFIG_SCx200_WDT=y
> CONFIG_PC87413_WDT=y
> CONFIG_NV_TCO=y
> CONFIG_60XX_WDT=y
> # CONFIG_SBC8360_WDT is not set
> CONFIG_SBC7240_WDT=y
> CONFIG_CPU5_WDT=y
> CONFIG_SMSC_SCH311X_WDT=y
> # CONFIG_SMSC37B787_WDT is not set
> CONFIG_VIA_WDT=y
> CONFIG_W83627HF_WDT=y
> CONFIG_W83697HF_WDT=y
> CONFIG_W83697UG_WDT=y
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> CONFIG_MEN_A21_WDT=y
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> CONFIG_WDTPCI=y
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
> CONFIG_SSB_SILENT=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> # CONFIG_SSB_DRIVER_GPIO is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_HOST_SOC is not set
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> # CONFIG_BCMA_DRIVER_GPIO is not set
> CONFIG_BCMA_DEBUG=y
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> # CONFIG_MFD_AS3711 is not set
> CONFIG_PMIC_ADP5520=y
> # CONFIG_MFD_AAT2870_CORE is not set
> CONFIG_MFD_CROS_EC=y
> CONFIG_MFD_CROS_EC_I2C=y
> CONFIG_PMIC_DA903X=y
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_I2C=y
> CONFIG_MFD_DA9055=y
> CONFIG_MFD_DA9063=y
> CONFIG_MFD_MC13783=y
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_I2C=y
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> CONFIG_LPC_ICH=y
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=y
> CONFIG_MFD_KEMPLD=y
> CONFIG_MFD_88PM800=y
> CONFIG_MFD_88PM805=y
> # CONFIG_MFD_88PM860X is not set
> CONFIG_MFD_MAX77686=y
> # CONFIG_MFD_MAX77693 is not set
> CONFIG_MFD_MAX8907=y
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> CONFIG_MFD_VIPERBOARD=y
> CONFIG_MFD_RETU=y
> CONFIG_MFD_PCF50633=y
> CONFIG_PCF50633_ADC=y
> CONFIG_PCF50633_GPIO=y
> CONFIG_UCB1400_CORE=y
> CONFIG_MFD_RDC321X=y
> CONFIG_MFD_RTSX_PCI=y
> # CONFIG_MFD_RC5T583 is not set
> CONFIG_MFD_SEC_CORE=y
> CONFIG_MFD_SI476X_CORE=y
> # CONFIG_MFD_SM501 is not set
> # CONFIG_MFD_SMSC is not set
> CONFIG_ABX500_CORE=y
> CONFIG_AB3100_CORE=y
> CONFIG_AB3100_OTP=y
> CONFIG_MFD_STMPE=y
> 
> #
> # STMicroelectronics STMPE Interface Drivers
> #
> # CONFIG_STMPE_I2C is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> # CONFIG_MFD_LP8788 is not set
> # CONFIG_MFD_PALMAS is not set
> CONFIG_TPS6105X=y
> CONFIG_TPS65010=y
> CONFIG_TPS6507X=y
> CONFIG_MFD_TPS65090=y
> CONFIG_MFD_TPS65217=y
> # CONFIG_MFD_TPS6586X is not set
> CONFIG_MFD_TPS65910=y
> CONFIG_MFD_TPS65912=y
> # CONFIG_MFD_TPS65912_I2C is not set
> # CONFIG_MFD_TPS80031 is not set
> CONFIG_TWL4030_CORE=y
> CONFIG_TWL4030_MADC=y
> CONFIG_MFD_TWL4030_AUDIO=y
> CONFIG_TWL6040_CORE=y
> CONFIG_MFD_WL1273_CORE=y
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> CONFIG_MFD_VX855=y
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> CONFIG_MFD_WM5102=y
> CONFIG_MFD_WM5110=y
> # CONFIG_MFD_WM8997 is not set
> # CONFIG_MFD_WM8400 is not set
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> CONFIG_MFD_WM8994=y
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> # CONFIG_REGULATOR_88PM800 is not set
> CONFIG_REGULATOR_AD5398=y
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_AB3100=y
> CONFIG_REGULATOR_ARIZONA=y
> # CONFIG_REGULATOR_DA903X is not set
> CONFIG_REGULATOR_DA9052=y
> CONFIG_REGULATOR_DA9055=y
> CONFIG_REGULATOR_DA9063=y
> CONFIG_REGULATOR_DA9210=y
> CONFIG_REGULATOR_FAN53555=y
> CONFIG_REGULATOR_GPIO=y
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_LP3972 is not set
> CONFIG_REGULATOR_LP872X=y
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8649=y
> # CONFIG_REGULATOR_MAX8660 is not set
> CONFIG_REGULATOR_MAX8907=y
> CONFIG_REGULATOR_MAX8952=y
> # CONFIG_REGULATOR_MAX8973 is not set
> CONFIG_REGULATOR_MAX77686=y
> CONFIG_REGULATOR_MC13XXX_CORE=y
> # CONFIG_REGULATOR_MC13783 is not set
> CONFIG_REGULATOR_MC13892=y
> CONFIG_REGULATOR_PCF50633=y
> CONFIG_REGULATOR_PFUZE100=y
> CONFIG_REGULATOR_S2MPS11=y
> # CONFIG_REGULATOR_S5M8767 is not set
> # CONFIG_REGULATOR_TPS51632 is not set
> CONFIG_REGULATOR_TPS6105X=y
> CONFIG_REGULATOR_TPS62360=y
> # CONFIG_REGULATOR_TPS65023 is not set
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65090=y
> # CONFIG_REGULATOR_TPS65217 is not set
> CONFIG_REGULATOR_TPS65910=y
> # CONFIG_REGULATOR_TWL4030 is not set
> CONFIG_REGULATOR_WM831X=y
> CONFIG_REGULATOR_WM8350=y
> CONFIG_REGULATOR_WM8994=y
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> # CONFIG_MEDIA_CAMERA_SUPPORT is not set
> CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> CONFIG_MEDIA_RADIO_SUPPORT=y
> # CONFIG_MEDIA_RC_SUPPORT is not set
> CONFIG_VIDEO_DEV=y
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEO_ADV_DEBUG=y
> CONFIG_VIDEO_FIXED_MINOR_RANGES=y
> CONFIG_VIDEO_TUNER=y
> CONFIG_VIDEOBUF2_CORE=y
> CONFIG_VIDEOBUF2_MEMOPS=y
> CONFIG_VIDEOBUF2_VMALLOC=y
> CONFIG_VIDEO_V4L2_INT_DEVICE=y
> # CONFIG_TTPCI_EEPROM is not set
> 
> #
> # Media drivers
> #
> CONFIG_MEDIA_USB_SUPPORT=y
> 
> #
> # Analog TV USB devices
> #
> CONFIG_VIDEO_PVRUSB2=y
> # CONFIG_VIDEO_PVRUSB2_SYSFS is not set
> CONFIG_VIDEO_HDPVR=y
> # CONFIG_VIDEO_USBVISION is not set
> CONFIG_VIDEO_STK1160_COMMON=y
> CONFIG_VIDEO_STK1160_AC97=y
> CONFIG_VIDEO_STK1160=y
> 
> #
> # Analog/digital TV USB devices
> #
> 
> #
> # Webcam, TV (analog/digital) USB devices
> #
> CONFIG_VIDEO_EM28XX=y
> # CONFIG_VIDEO_EM28XX_ALSA is not set
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> CONFIG_RADIO_ADAPTERS=y
> CONFIG_RADIO_TEA575X=y
> CONFIG_RADIO_SI470X=y
> CONFIG_USB_SI470X=y
> CONFIG_RADIO_SI476X=y
> # CONFIG_USB_MR800 is not set
> CONFIG_USB_DSBR=y
> CONFIG_RADIO_MAXIRADIO=y
> # CONFIG_RADIO_SHARK is not set
> CONFIG_RADIO_SHARK2=y
> CONFIG_I2C_SI4713=y
> CONFIG_RADIO_SI4713=y
> # CONFIG_USB_KEENE is not set
> CONFIG_USB_MA901=y
> CONFIG_RADIO_TEA5764=y
> # CONFIG_RADIO_TEA5764_XTAL is not set
> CONFIG_RADIO_SAA7706H=y
> CONFIG_RADIO_TEF6862=y
> CONFIG_RADIO_WL1273=y
> 
> #
> # Texas Instruments WL128x FM driver (ST based)
> #
> # CONFIG_RADIO_WL128X is not set
> CONFIG_VIDEO_CX2341X=y
> CONFIG_VIDEO_TVEEPROM=y
> # CONFIG_CYPRESS_FIRMWARE is not set
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
> 
> #
> # Audio decoders, processors and mixers
> #
> CONFIG_VIDEO_MSP3400=y
> CONFIG_VIDEO_CS53L32A=y
> CONFIG_VIDEO_WM8775=y
> 
> #
> # RDS decoders
> #
> 
> #
> # Video decoders
> #
> CONFIG_VIDEO_SAA711X=y
> CONFIG_VIDEO_TVP5150=y
> 
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_CX25840=y
> 
> #
> # Video encoders
> #
> 
> #
> # Camera sensor devices
> #
> CONFIG_VIDEO_MT9V011=y
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
> # Miscelaneous helper chips
> #
> 
> #
> # Sensors used on soc_camera driver
> #
> CONFIG_MEDIA_TUNER=y
> CONFIG_MEDIA_TUNER_SIMPLE=y
> CONFIG_MEDIA_TUNER_TDA8290=y
> CONFIG_MEDIA_TUNER_TDA827X=y
> CONFIG_MEDIA_TUNER_TDA18271=y
> CONFIG_MEDIA_TUNER_TDA9887=y
> CONFIG_MEDIA_TUNER_TEA5761=y
> CONFIG_MEDIA_TUNER_TEA5767=y
> CONFIG_MEDIA_TUNER_MT20XX=y
> CONFIG_MEDIA_TUNER_XC2028=y
> CONFIG_MEDIA_TUNER_XC5000=y
> CONFIG_MEDIA_TUNER_XC4000=y
> CONFIG_MEDIA_TUNER_MC44S803=y
> 
> #
> # Tools to develop new frontends
> #
> # CONFIG_DVB_DUMMY_FE is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> CONFIG_AGP_ATI=y
> CONFIG_AGP_AMD=y
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=y
> CONFIG_AGP_NVIDIA=y
> CONFIG_AGP_SIS=y
> CONFIG_AGP_SWORKS=y
> CONFIG_AGP_VIA=y
> CONFIG_AGP_EFFICEON=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=y
> CONFIG_DRM_USB=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> CONFIG_DRM_TTM=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> CONFIG_DRM_I2C_SIL164=y
> CONFIG_DRM_I2C_NXP_TDA998X=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> CONFIG_DRM_I810=y
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> # CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
> CONFIG_DRM_MGA=y
> CONFIG_DRM_SIS=y
> # CONFIG_DRM_VIA is not set
> CONFIG_DRM_SAVAGE=y
> CONFIG_DRM_VMWGFX=y
> # CONFIG_DRM_VMWGFX_FBCON is not set
> CONFIG_DRM_GMA500=y
> CONFIG_DRM_GMA600=y
> CONFIG_DRM_GMA3600=y
> CONFIG_DRM_UDL=y
> # CONFIG_DRM_AST is not set
> CONFIG_DRM_MGAG200=y
> # CONFIG_DRM_CIRRUS_QEMU is not set
> CONFIG_DRM_QXL=y
> CONFIG_VGASTATE=y
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_HDMI=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> CONFIG_FB_FOREIGN_ENDIAN=y
> CONFIG_FB_BOTH_ENDIAN=y
> # CONFIG_FB_BIG_ENDIAN is not set
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> CONFIG_FB_CIRRUS=y
> # CONFIG_FB_PM2 is not set
> CONFIG_FB_CYBER2000=y
> CONFIG_FB_CYBER2000_DDC=y
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> CONFIG_FB_IMSTT=y
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_UVESA=y
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=y
> # CONFIG_FB_S1D13XXX is not set
> CONFIG_FB_NVIDIA=y
> # CONFIG_FB_NVIDIA_I2C is not set
> # CONFIG_FB_NVIDIA_DEBUG is not set
> CONFIG_FB_NVIDIA_BACKLIGHT=y
> CONFIG_FB_RIVA=y
> # CONFIG_FB_RIVA_I2C is not set
> CONFIG_FB_RIVA_DEBUG=y
> # CONFIG_FB_RIVA_BACKLIGHT is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_I810 is not set
> # CONFIG_FB_LE80578 is not set
> CONFIG_FB_MATROX=y
> CONFIG_FB_MATROX_MILLENIUM=y
> CONFIG_FB_MATROX_MYSTIQUE=y
> CONFIG_FB_MATROX_G=y
> # CONFIG_FB_MATROX_I2C is not set
> CONFIG_FB_RADEON=y
> CONFIG_FB_RADEON_I2C=y
> # CONFIG_FB_RADEON_BACKLIGHT is not set
> # CONFIG_FB_RADEON_DEBUG is not set
> CONFIG_FB_ATY128=y
> # CONFIG_FB_ATY128_BACKLIGHT is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> CONFIG_FB_SAVAGE=y
> # CONFIG_FB_SAVAGE_I2C is not set
> # CONFIG_FB_SAVAGE_ACCEL is not set
> # CONFIG_FB_SIS is not set
> CONFIG_FB_VIA=y
> # CONFIG_FB_VIA_DIRECT_PROCFS is not set
> # CONFIG_FB_VIA_X_COMPATIBILITY is not set
> # CONFIG_FB_NEOMAGIC is not set
> CONFIG_FB_KYRO=y
> # CONFIG_FB_3DFX is not set
> CONFIG_FB_VOODOO1=y
> CONFIG_FB_VT8623=y
> # CONFIG_FB_TRIDENT is not set
> CONFIG_FB_ARK=y
> CONFIG_FB_PM3=y
> CONFIG_FB_CARMINE=y
> # CONFIG_FB_CARMINE_DRAM_EVAL is not set
> CONFIG_CARMINE_DRAM_CUSTOM=y
> # CONFIG_FB_GEODE is not set
> CONFIG_FB_TMIO=y
> # CONFIG_FB_TMIO_ACCELL is not set
> CONFIG_FB_SMSCUFX=y
> CONFIG_FB_UDL=y
> # CONFIG_FB_GOLDFISH is not set
> CONFIG_FB_VIRTUAL=y
> # CONFIG_FB_METRONOME is not set
> CONFIG_FB_MB862XX=y
> CONFIG_FB_MB862XX_PCI_GDC=y
> CONFIG_FB_MB862XX_I2C=y
> CONFIG_FB_BROADSHEET=y
> # CONFIG_FB_AUO_K190X is not set
> # CONFIG_FB_SIMPLE is not set
> CONFIG_EXYNOS_VIDEO=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_PLATFORM=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> # CONFIG_BACKLIGHT_PWM is not set
> # CONFIG_BACKLIGHT_DA903X is not set
> CONFIG_BACKLIGHT_DA9052=y
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=y
> # CONFIG_BACKLIGHT_WM831X is not set
> CONFIG_BACKLIGHT_ADP5520=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> CONFIG_BACKLIGHT_PCF50633=y
> CONFIG_BACKLIGHT_LM3630A=y
> # CONFIG_BACKLIGHT_LM3639 is not set
> CONFIG_BACKLIGHT_LP855X=y
> CONFIG_BACKLIGHT_PANDORA=y
> # CONFIG_BACKLIGHT_TPS65217 is not set
> CONFIG_BACKLIGHT_GPIO=y
> CONFIG_BACKLIGHT_LV5207LP=y
> CONFIG_BACKLIGHT_BD6107=y
> # CONFIG_LOGO is not set
> CONFIG_FB_SSD1307=y
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_DMAENGINE_PCM=y
> CONFIG_SND_HWDEP=y
> CONFIG_SND_RAWMIDI=y
> CONFIG_SND_COMPRESS_OFFLOAD=y
> CONFIG_SND_JACK=y
> CONFIG_SND_SEQUENCER=y
> # CONFIG_SND_SEQ_DUMMY is not set
> CONFIG_SND_OSSEMUL=y
> # CONFIG_SND_MIXER_OSS is not set
> CONFIG_SND_PCM_OSS=y
> # CONFIG_SND_PCM_OSS_PLUGINS is not set
> # CONFIG_SND_SEQUENCER_OSS is not set
> # CONFIG_SND_HRTIMER is not set
> CONFIG_SND_DYNAMIC_MINORS=y
> CONFIG_SND_MAX_CARDS=32
> CONFIG_SND_SUPPORT_OLD_API=y
> # CONFIG_SND_VERBOSE_PROCFS is not set
> CONFIG_SND_VERBOSE_PRINTK=y
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=y
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_AC97_CODEC=y
> # CONFIG_SND_DRIVERS is not set
> # CONFIG_SND_PCI is not set
> CONFIG_SND_USB=y
> CONFIG_SND_USB_AUDIO=y
> # CONFIG_SND_USB_UA101 is not set
> CONFIG_SND_USB_USX2Y=y
> CONFIG_SND_USB_CAIAQ=y
> # CONFIG_SND_USB_CAIAQ_INPUT is not set
> CONFIG_SND_USB_US122L=y
> # CONFIG_SND_USB_6FIRE is not set
> # CONFIG_SND_USB_HIFACE is not set
> # CONFIG_SND_FIREWIRE is not set
> CONFIG_SND_SOC=y
> CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
> # CONFIG_SND_ATMEL_SOC is not set
> CONFIG_SND_SOC_FSL_SSI=y
> CONFIG_SND_SOC_FSL_SPDIF=y
> CONFIG_SND_IMX_SOC=y
> CONFIG_SND_SOC_IMX_PCM_DMA=y
> CONFIG_SND_SOC_IMX_AUDMUX=y
> CONFIG_SND_SOC_IMX_WM8962=y
> CONFIG_SND_SOC_IMX_SGTL5000=y
> CONFIG_SND_SOC_IMX_SPDIF=y
> CONFIG_SND_KIRKWOOD_SOC=y
> CONFIG_SND_KIRKWOOD_SOC_OPENRD=y
> CONFIG_SND_KIRKWOOD_SOC_T5325=y
> CONFIG_SND_SOC_TEGRA=y
> CONFIG_SND_SOC_TEGRA_RT5640=y
> CONFIG_SND_SOC_TEGRA_WM8753=y
> CONFIG_SND_SOC_TEGRA_WM8903=y
> CONFIG_SND_SOC_TEGRA_TRIMSLICE=y
> CONFIG_SND_SOC_TEGRA_ALC5632=y
> CONFIG_SND_SOC_I2C_AND_SPI=y
> CONFIG_SND_SOC_ALL_CODECS=y
> CONFIG_SND_SOC_ARIZONA=y
> CONFIG_SND_SOC_WM_HUBS=y
> CONFIG_SND_SOC_WM_ADSP=y
> CONFIG_SND_SOC_AB8500_CODEC=y
> CONFIG_SND_SOC_AD193X=y
> CONFIG_SND_SOC_AD73311=y
> CONFIG_SND_SOC_ADAU1701=y
> CONFIG_SND_SOC_ADAU1373=y
> CONFIG_SND_SOC_ADAV80X=y
> CONFIG_SND_SOC_ADS117X=y
> CONFIG_SND_SOC_AK4535=y
> CONFIG_SND_SOC_AK4641=y
> CONFIG_SND_SOC_AK4642=y
> CONFIG_SND_SOC_AK4671=y
> CONFIG_SND_SOC_AK5386=y
> CONFIG_SND_SOC_ALC5623=y
> CONFIG_SND_SOC_ALC5632=y
> CONFIG_SND_SOC_CS42L51=y
> CONFIG_SND_SOC_CS42L52=y
> CONFIG_SND_SOC_CS42L73=y
> CONFIG_SND_SOC_CS4270=y
> CONFIG_SND_SOC_CS4271=y
> CONFIG_SND_SOC_CX20442=y
> CONFIG_SND_SOC_JZ4740_CODEC=y
> CONFIG_SND_SOC_L3=y
> CONFIG_SND_SOC_DA7210=y
> CONFIG_SND_SOC_DA7213=y
> CONFIG_SND_SOC_DA732X=y
> CONFIG_SND_SOC_DA9055=y
> CONFIG_SND_SOC_BT_SCO=y
> CONFIG_SND_SOC_ISABELLE=y
> CONFIG_SND_SOC_LM49453=y
> CONFIG_SND_SOC_MAX98088=y
> CONFIG_SND_SOC_MAX98090=y
> CONFIG_SND_SOC_MAX98095=y
> CONFIG_SND_SOC_MAX9850=y
> CONFIG_SND_SOC_HDMI_CODEC=y
> CONFIG_SND_SOC_PCM1681=y
> CONFIG_SND_SOC_PCM3008=y
> CONFIG_SND_SOC_RT5631=y
> CONFIG_SND_SOC_RT5640=y
> CONFIG_SND_SOC_SGTL5000=y
> CONFIG_SND_SOC_SI476X=y
> CONFIG_SND_SOC_SIGMADSP=y
> CONFIG_SND_SOC_SPDIF=y
> CONFIG_SND_SOC_SSM2518=y
> CONFIG_SND_SOC_SSM2602=y
> CONFIG_SND_SOC_STA32X=y
> CONFIG_SND_SOC_STA529=y
> CONFIG_SND_SOC_TAS5086=y
> CONFIG_SND_SOC_TLV320AIC23=y
> CONFIG_SND_SOC_TLV320AIC32X4=y
> CONFIG_SND_SOC_TLV320AIC3X=y
> CONFIG_SND_SOC_TLV320DAC33=y
> CONFIG_SND_SOC_TWL4030=y
> CONFIG_SND_SOC_TWL6040=y
> CONFIG_SND_SOC_UDA134X=y
> CONFIG_SND_SOC_UDA1380=y
> CONFIG_SND_SOC_WL1273=y
> CONFIG_SND_SOC_WM1250_EV1=y
> CONFIG_SND_SOC_WM2000=y
> CONFIG_SND_SOC_WM2200=y
> CONFIG_SND_SOC_WM5100=y
> CONFIG_SND_SOC_WM5102=y
> CONFIG_SND_SOC_WM5110=y
> CONFIG_SND_SOC_WM8350=y
> CONFIG_SND_SOC_WM8510=y
> CONFIG_SND_SOC_WM8523=y
> CONFIG_SND_SOC_WM8580=y
> CONFIG_SND_SOC_WM8711=y
> CONFIG_SND_SOC_WM8727=y
> CONFIG_SND_SOC_WM8728=y
> CONFIG_SND_SOC_WM8731=y
> CONFIG_SND_SOC_WM8737=y
> CONFIG_SND_SOC_WM8741=y
> CONFIG_SND_SOC_WM8750=y
> CONFIG_SND_SOC_WM8753=y
> CONFIG_SND_SOC_WM8776=y
> CONFIG_SND_SOC_WM8782=y
> CONFIG_SND_SOC_WM8804=y
> CONFIG_SND_SOC_WM8900=y
> CONFIG_SND_SOC_WM8903=y
> CONFIG_SND_SOC_WM8904=y
> CONFIG_SND_SOC_WM8940=y
> CONFIG_SND_SOC_WM8955=y
> CONFIG_SND_SOC_WM8960=y
> CONFIG_SND_SOC_WM8961=y
> CONFIG_SND_SOC_WM8962=y
> CONFIG_SND_SOC_WM8971=y
> CONFIG_SND_SOC_WM8974=y
> CONFIG_SND_SOC_WM8978=y
> CONFIG_SND_SOC_WM8983=y
> CONFIG_SND_SOC_WM8985=y
> CONFIG_SND_SOC_WM8988=y
> CONFIG_SND_SOC_WM8990=y
> CONFIG_SND_SOC_WM8991=y
> CONFIG_SND_SOC_WM8993=y
> CONFIG_SND_SOC_WM8994=y
> CONFIG_SND_SOC_WM8995=y
> CONFIG_SND_SOC_WM8996=y
> CONFIG_SND_SOC_WM9081=y
> CONFIG_SND_SOC_WM9090=y
> CONFIG_SND_SOC_LM4857=y
> CONFIG_SND_SOC_MAX9768=y
> CONFIG_SND_SOC_MAX9877=y
> CONFIG_SND_SOC_MC13783=y
> CONFIG_SND_SOC_ML26124=y
> CONFIG_SND_SOC_TPA6130A2=y
> # CONFIG_SND_SIMPLE_CARD is not set
> CONFIG_SOUND_PRIME=y
> CONFIG_SOUND_OSS=y
> CONFIG_SOUND_TRACEINIT=y
> CONFIG_SOUND_DMAP=y
> CONFIG_SOUND_VMIDI=y
> CONFIG_SOUND_TRIX=y
> CONFIG_SOUND_MSS=y
> CONFIG_SOUND_MPU401=y
> CONFIG_SOUND_PAS=y
> # CONFIG_PAS_JOYSTICK is not set
> CONFIG_SOUND_PSS=y
> CONFIG_PSS_MIXER=y
> CONFIG_SOUND_SB=y
> # CONFIG_SOUND_YM3812 is not set
> # CONFIG_SOUND_UART6850 is not set
> CONFIG_SOUND_AEDSP16=y
> CONFIG_SC6600=y
> # CONFIG_SC6600_JOY is not set
> CONFIG_SC6600_CDROM=4
> CONFIG_SC6600_CDROMBASE=0
> CONFIG_SOUND_KAHLUA=y
> CONFIG_AC97_BUS=y
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> # CONFIG_HIDRAW is not set
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_A4TECH is not set
> # CONFIG_HID_ACRUX is not set
> # CONFIG_HID_APPLE is not set
> # CONFIG_HID_APPLEIR is not set
> # CONFIG_HID_AUREAL is not set
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CHERRY is not set
> # CONFIG_HID_CHICONY is not set
> # CONFIG_HID_PRODIKEYS is not set
> # CONFIG_HID_CYPRESS is not set
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_ELECOM is not set
> # CONFIG_HID_ELO is not set
> # CONFIG_HID_EZKEY is not set
> # CONFIG_HID_HOLTEK is not set
> # CONFIG_HID_HUION is not set
> # CONFIG_HID_KEYTOUCH is not set
> # CONFIG_HID_KYE is not set
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> # CONFIG_HID_KENSINGTON is not set
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LENOVO_TPKBD is not set
> # CONFIG_HID_LOGITECH is not set
> # CONFIG_HID_MAGICMOUSE is not set
> # CONFIG_HID_MICROSOFT is not set
> # CONFIG_HID_MONTEREY is not set
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_SAITEK is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SONY is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_STEELSERIES is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TIVO is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THINGM is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_WACOM is not set
> # CONFIG_HID_WIIMOTE is not set
> # CONFIG_HID_XINMO is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> # CONFIG_HID_SENSOR_HUB is not set
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=y
> # CONFIG_HID_PID is not set
> # CONFIG_USB_HIDDEV is not set
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
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
> CONFIG_USB_DEFAULT_PERSIST=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_OTG=y
> CONFIG_USB_OTG_WHITELIST=y
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> CONFIG_USB_MON=y
> CONFIG_USB_WUSB=y
> CONFIG_USB_WUSB_CBAF=y
> # CONFIG_USB_WUSB_CBAF_DEBUG is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_XHCI_PLATFORM=y
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> CONFIG_USB_EHCI_PCI=y
> CONFIG_USB_EHCI_HCD_PLATFORM=y
> # CONFIG_USB_OXU210HP_HCD is not set
> CONFIG_USB_ISP116X_HCD=y
> CONFIG_USB_ISP1760_HCD=y
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_FUSBH200_HCD=y
> CONFIG_USB_FOTG210_HCD=y
> CONFIG_USB_OHCI_HCD=y
> CONFIG_USB_OHCI_HCD_PCI=y
> CONFIG_USB_OHCI_HCD_SSB=y
> CONFIG_USB_OHCI_HCD_PLATFORM=y
> # CONFIG_USB_UHCI_HCD is not set
> CONFIG_USB_U132_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> CONFIG_USB_R8A66597_HCD=y
> CONFIG_USB_RENESAS_USBHS_HCD=y
> CONFIG_USB_WHCI_HCD=y
> # CONFIG_USB_HWA_HCD is not set
> CONFIG_USB_HCD_BCMA=y
> CONFIG_USB_HCD_SSB=y
> # CONFIG_USB_HCD_TEST_MODE is not set
> CONFIG_USB_MUSB_HDRC=y
> # CONFIG_USB_MUSB_HOST is not set
> # CONFIG_USB_MUSB_GADGET is not set
> CONFIG_USB_MUSB_DUAL_ROLE=y
> # CONFIG_USB_MUSB_TUSB6010 is not set
> CONFIG_USB_MUSB_DSPS=y
> # CONFIG_USB_MUSB_UX500 is not set
> CONFIG_USB_MUSB_AM335X_CHILD=y
> CONFIG_MUSB_PIO_ONLY=y
> CONFIG_USB_RENESAS_USBHS=y
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> CONFIG_USB_PRINTER=y
> # CONFIG_USB_WDM is not set
> # CONFIG_USB_TMC is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> CONFIG_USB_STORAGE_DEBUG=y
> # CONFIG_USB_STORAGE_REALTEK is not set
> CONFIG_USB_STORAGE_DATAFAB=y
> CONFIG_USB_STORAGE_FREECOM=y
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> CONFIG_USB_STORAGE_SDDR09=y
> CONFIG_USB_STORAGE_SDDR55=y
> CONFIG_USB_STORAGE_JUMPSHOT=y
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> CONFIG_USB_STORAGE_KARMA=y
> CONFIG_USB_STORAGE_CYPRESS_ATACB=y
> # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=y
> CONFIG_USB_MICROTEK=y
> CONFIG_USB_DWC3=y
> # CONFIG_USB_DWC3_HOST is not set
> CONFIG_USB_DWC3_GADGET=y
> # CONFIG_USB_DWC3_DUAL_ROLE is not set
> 
> #
> # Platform Glue Driver Support
> #
> CONFIG_USB_DWC3_OMAP=y
> CONFIG_USB_DWC3_EXYNOS=y
> CONFIG_USB_DWC3_PCI=y
> 
> #
> # Debugging features
> #
> # CONFIG_USB_DWC3_DEBUG is not set
> CONFIG_USB_CHIPIDEA=y
> CONFIG_USB_CHIPIDEA_UDC=y
> CONFIG_USB_CHIPIDEA_HOST=y
> CONFIG_USB_CHIPIDEA_DEBUG=y
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
> # CONFIG_USB_EMI26 is not set
> CONFIG_USB_ADUTUX=y
> CONFIG_USB_SEVSEG=y
> CONFIG_USB_RIO500=y
> CONFIG_USB_LEGOTOWER=y
> CONFIG_USB_LCD=y
> CONFIG_USB_LED=y
> CONFIG_USB_CYPRESS_CY7C63=y
> # CONFIG_USB_CYTHERM is not set
> CONFIG_USB_IDMOUSE=y
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=y
> CONFIG_USB_SISUSBVGA=y
> # CONFIG_USB_LD is not set
> CONFIG_USB_TRANCEVIBRATOR=y
> CONFIG_USB_IOWARRIOR=y
> CONFIG_USB_TEST=y
> CONFIG_USB_EHSET_TEST_FIXTURE=y
> CONFIG_USB_ISIGHTFW=y
> CONFIG_USB_YUREX=y
> CONFIG_USB_EZUSB_FX2=y
> CONFIG_USB_HSIC_USB3503=y
> # CONFIG_USB_ATM is not set
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
> CONFIG_USB_GPIO_VBUS=y
> CONFIG_USB_ISP1301=y
> CONFIG_USB_RCAR_PHY=y
> CONFIG_USB_GADGET=y
> # CONFIG_USB_GADGET_DEBUG is not set
> # CONFIG_USB_GADGET_DEBUG_FILES is not set
> # CONFIG_USB_GADGET_DEBUG_FS is not set
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
> 
> #
> # USB Peripheral Controller
> #
> CONFIG_USB_FUSB300=y
> CONFIG_USB_FOTG210_UDC=y
> CONFIG_USB_R8A66597=y
> # CONFIG_USB_RENESAS_USBHS_UDC is not set
> # CONFIG_USB_PXA27X is not set
> CONFIG_USB_MV_UDC=y
> CONFIG_USB_MV_U3D=y
> CONFIG_USB_M66592=y
> CONFIG_USB_AMD5536UDC=y
> CONFIG_USB_NET2272=y
> CONFIG_USB_NET2272_DMA=y
> CONFIG_USB_NET2280=y
> CONFIG_USB_GOKU=y
> CONFIG_USB_EG20T=y
> CONFIG_USB_DUMMY_HCD=y
> CONFIG_USB_LIBCOMPOSITE=y
> # CONFIG_USB_CONFIGFS is not set
> # CONFIG_USB_ZERO is not set
> # CONFIG_USB_AUDIO is not set
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_G_NCM is not set
> # CONFIG_USB_GADGETFS is not set
> # CONFIG_USB_FUNCTIONFS is not set
> CONFIG_USB_MASS_STORAGE=y
> # CONFIG_USB_GADGET_TARGET is not set
> # CONFIG_USB_G_SERIAL is not set
> # CONFIG_USB_MIDI_GADGET is not set
> # CONFIG_USB_G_PRINTER is not set
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_NOKIA is not set
> # CONFIG_USB_G_ACM_MS is not set
> # CONFIG_USB_G_MULTI is not set
> # CONFIG_USB_G_HID is not set
> # CONFIG_USB_G_DBGP is not set
> # CONFIG_USB_G_WEBCAM is not set
> CONFIG_UWB=y
> CONFIG_UWB_HWA=y
> CONFIG_UWB_WHCI=y
> CONFIG_UWB_I1480U=y
> # CONFIG_MMC is not set
> CONFIG_MEMSTICK=y
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> CONFIG_MEMSTICK_UNSAFE_RESUME=y
> # CONFIG_MSPRO_BLOCK is not set
> # CONFIG_MS_BLOCK is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=y
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> CONFIG_MEMSTICK_R592=y
> CONFIG_MEMSTICK_REALTEK_PCI=y
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=y
> # CONFIG_LEDS_LM3642 is not set
> # CONFIG_LEDS_PCA9532 is not set
> # CONFIG_LEDS_GPIO is not set
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP55XX_COMMON=y
> # CONFIG_LEDS_LP5521 is not set
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> # CONFIG_LEDS_LP8501 is not set
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_PCA963X is not set
> CONFIG_LEDS_WM831X_STATUS=y
> # CONFIG_LEDS_WM8350 is not set
> CONFIG_LEDS_DA903X=y
> CONFIG_LEDS_DA9052=y
> CONFIG_LEDS_PWM=y
> # CONFIG_LEDS_REGULATOR is not set
> CONFIG_LEDS_BD2802=y
> CONFIG_LEDS_LT3593=y
> CONFIG_LEDS_ADP5520=y
> # CONFIG_LEDS_DELL_NETBOOKS is not set
> CONFIG_LEDS_MC13783=y
> CONFIG_LEDS_TCA6507=y
> CONFIG_LEDS_LM355x=y
> CONFIG_LEDS_OT200=y
> CONFIG_LEDS_BLINKM=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> CONFIG_LEDS_TRIGGER_ONESHOT=y
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> CONFIG_LEDS_TRIGGER_BACKLIGHT=y
> # CONFIG_LEDS_TRIGGER_CPU is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> CONFIG_LEDS_TRIGGER_CAMERA=y
> CONFIG_ACCESSIBILITY=y
> CONFIG_INFINIBAND=y
> # CONFIG_INFINIBAND_USER_MAD is not set
> CONFIG_INFINIBAND_USER_ACCESS=y
> CONFIG_INFINIBAND_USER_MEM=y
> CONFIG_INFINIBAND_MTHCA=y
> CONFIG_INFINIBAND_MTHCA_DEBUG=y
> CONFIG_MLX4_INFINIBAND=y
> CONFIG_MLX5_INFINIBAND=y
> CONFIG_INFINIBAND_OCRDMA=y
> CONFIG_INFINIBAND_SRP=y
> CONFIG_INFINIBAND_SRPT=y
> CONFIG_EDAC=y
> # CONFIG_EDAC_LEGACY_SYSFS is not set
> CONFIG_EDAC_DEBUG=y
> CONFIG_EDAC_MM_EDAC=y
> CONFIG_EDAC_AMD76X=y
> CONFIG_EDAC_E7XXX=y
> CONFIG_EDAC_E752X=y
> CONFIG_EDAC_I82875P=y
> CONFIG_EDAC_I82975X=y
> # CONFIG_EDAC_I3000 is not set
> CONFIG_EDAC_I3200=y
> # CONFIG_EDAC_X38 is not set
> CONFIG_EDAC_I5400=y
> CONFIG_EDAC_I82860=y
> # CONFIG_EDAC_R82600 is not set
> CONFIG_EDAC_I5000=y
> # CONFIG_EDAC_I5100 is not set
> CONFIG_EDAC_I7300=y
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> CONFIG_DMADEVICES=y
> CONFIG_DMADEVICES_DEBUG=y
> CONFIG_DMADEVICES_VDEBUG=y
> 
> #
> # DMA Devices
> #
> CONFIG_INTEL_MID_DMAC=y
> # CONFIG_INTEL_IOATDMA is not set
> CONFIG_DW_DMAC_CORE=y
> CONFIG_DW_DMAC=y
> CONFIG_DW_DMAC_PCI=y
> CONFIG_TIMB_DMA=y
> CONFIG_PCH_DMA=y
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> CONFIG_DMA_OF=y
> 
> #
> # DMA Clients
> #
> CONFIG_NET_DMA=y
> # CONFIG_ASYNC_TX_DMA is not set
> # CONFIG_DMATEST is not set
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> # CONFIG_UIO_AEC is not set
> CONFIG_UIO_SERCOS3=y
> CONFIG_UIO_PCI_GENERIC=y
> # CONFIG_UIO_NETX is not set
> CONFIG_UIO_MF624=y
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_MMIO=y
> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> CONFIG_STAGING=y
> CONFIG_ET131X=y
> CONFIG_SLICOSS=y
> CONFIG_USBIP_CORE=y
> CONFIG_USBIP_VHCI_HCD=y
> # CONFIG_USBIP_HOST is not set
> CONFIG_USBIP_DEBUG=y
> CONFIG_ECHO=y
> CONFIG_FB_OLPC_DCON=y
> # CONFIG_FB_OLPC_DCON_1 is not set
> CONFIG_FB_OLPC_DCON_1_5=y
> CONFIG_PANEL=y
> CONFIG_PANEL_PARPORT=0
> CONFIG_PANEL_PROFILE=5
> CONFIG_PANEL_CHANGE_MESSAGE=y
> CONFIG_PANEL_BOOT_MESSAGE=""
> CONFIG_RTS5139=y
> CONFIG_RTS5139_DEBUG=y
> # CONFIG_TRANZPORT is not set
> CONFIG_LINE6_USB=y
> CONFIG_LINE6_USB_IMPULSE_RESPONSE=y
> # CONFIG_DX_SEP is not set
> 
> #
> # IIO staging drivers
> #
> 
> #
> # Accelerometers
> #
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD7291=y
> CONFIG_AD7606=y
> CONFIG_AD7606_IFACE_PARALLEL=y
> CONFIG_AD799X=y
> CONFIG_AD799X_RING_BUFFER=y
> 
> #
> # Analog digital bi-direction converters
> #
> CONFIG_ADT7316=y
> CONFIG_ADT7316_I2C=y
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
> 
> #
> # Digital gyroscope sensors
> #
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
> CONFIG_SENSORS_ISL29028=y
> # CONFIG_TSL2583 is not set
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
> CONFIG_ADE7854=y
> # CONFIG_ADE7854_I2C is not set
> 
> #
> # Resolver to digital converters
> #
> 
> #
> # Triggers - standalone
> #
> # CONFIG_IIO_SIMPLE_DUMMY is not set
> CONFIG_ZSMALLOC=y
> CONFIG_ZRAM=y
> CONFIG_ZRAM_DEBUG=y
> # CONFIG_FB_SM7XX is not set
> # CONFIG_CRYSTALHD is not set
> CONFIG_FB_XGI=y
> # CONFIG_ACPI_QUICKSTART is not set
> CONFIG_BCM_WIMAX=y
> CONFIG_FT1000=y
> CONFIG_FT1000_USB=y
> 
> #
> # Speakup console speech
> #
> # CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
> # CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
> # CONFIG_STAGING_MEDIA is not set
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> CONFIG_USB_WPAN_HCD=y
> CONFIG_WIMAX_GDM72XX=y
> CONFIG_WIMAX_GDM72XX_QOS=y
> # CONFIG_WIMAX_GDM72XX_K_MODE is not set
> CONFIG_WIMAX_GDM72XX_WIMAX2=y
> CONFIG_WIMAX_GDM72XX_USB=y
> CONFIG_WIMAX_GDM72XX_USB_PM=y
> # CONFIG_NET_VENDOR_SILICOM is not set
> CONFIG_CED1401=y
> # CONFIG_DGRP is not set
> # CONFIG_FIREWIRE_SERIAL is not set
> CONFIG_USB_DWC2=y
> # CONFIG_USB_DWC2_DEBUG is not set
> # CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
> # CONFIG_XILLYBUS is not set
> # CONFIG_DGNC is not set
> # CONFIG_DGAP is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_DELL_LAPTOP is not set
> # CONFIG_DELL_WMI is not set
> # CONFIG_DELL_WMI_AIO is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_AMILO_RFKILL is not set
> # CONFIG_TC1100_WMI is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_IDEAPAD_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_EEEPC_LAPTOP is not set
> # CONFIG_ASUS_WMI is not set
> CONFIG_ACPI_WMI=y
> # CONFIG_MSI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> CONFIG_IBM_RTL=y
> # CONFIG_XO1_RFKILL is not set
> # CONFIG_XO15_EBOOK is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> CONFIG_MXM_WMI=y
> # CONFIG_INTEL_OAKTRAIL is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_MAILBOX=y
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
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> # CONFIG_DEVFREQ_GOV_POWERSAVE is not set
> CONFIG_DEVFREQ_GOV_USERSPACE=y
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_OF_EXTCON=y
> CONFIG_EXTCON_GPIO=y
> CONFIG_EXTCON_ADC_JACK=y
> # CONFIG_EXTCON_ARIZONA is not set
> CONFIG_MEMORY=y
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> CONFIG_IIO_BUFFER_CB=y
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> CONFIG_BMA180=y
> # CONFIG_IIO_ST_ACCEL_3AXIS is not set
> 
> #
> # Analog to digital converters
> #
> CONFIG_EXYNOS_ADC=y
> CONFIG_MAX1363=y
> CONFIG_MCP3422=y
> # CONFIG_NAU7802 is not set
> CONFIG_TI_ADC081C=y
> CONFIG_TI_AM335X_ADC=y
> CONFIG_TWL6030_GPADC=y
> CONFIG_VIPERBOARD_ADC=y
> 
> #
> # Amplifiers
> #
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> # CONFIG_AD5064 is not set
> # CONFIG_AD5380 is not set
> CONFIG_AD5446=y
> CONFIG_MAX517=y
> CONFIG_MCP4725=y
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
> CONFIG_ITG3200=y
> 
> #
> # Inertial measurement units
> #
> CONFIG_INV_MPU6050_IIO=y
> 
> #
> # Light sensors
> #
> # CONFIG_ADJD_S311 is not set
> CONFIG_APDS9300=y
> # CONFIG_GP2AP020A00F is not set
> CONFIG_TCS3472=y
> CONFIG_SENSORS_TSL2563=y
> CONFIG_TSL4531=y
> CONFIG_VCNL4000=y
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=y
> CONFIG_IIO_ST_MAGN_3AXIS=y
> CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
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
> 
> #
> # Temperature sensors
> #
> CONFIG_TMP006=y
> # CONFIG_NTB is not set
> CONFIG_VME_BUS=y
> 
> #
> # VME Bridge Drivers
> #
> # CONFIG_VME_CA91CX42 is not set
> CONFIG_VME_TSI148=y
> 
> #
> # VME Board Drivers
> #
> # CONFIG_VMIVME_7805 is not set
> 
> #
> # VME Device Drivers
> #
> # CONFIG_VME_USER is not set
> CONFIG_VME_PIO2=y
> CONFIG_PWM=y
> CONFIG_PWM_SYSFS=y
> # CONFIG_PWM_PCA9685 is not set
> CONFIG_PWM_TWL=y
> # CONFIG_PWM_TWL_LED is not set
> CONFIG_IRQCHIP=y
> # CONFIG_IPACK_BUS is not set
> # CONFIG_RESET_CONTROLLER is not set
> CONFIG_FMC=y
> # CONFIG_FMC_FAKEDEV is not set
> CONFIG_FMC_TRIVIAL=y
> # CONFIG_FMC_WRITE_EEPROM is not set
> # CONFIG_FMC_CHARDEV is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> CONFIG_EDD_OFF=y
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> CONFIG_ISCSI_IBFT_FIND=y
> # CONFIG_ISCSI_IBFT is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> # CONFIG_EXT2_FS_SECURITY is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> # CONFIG_EXT3_FS_XATTR is not set
> CONFIG_EXT4_FS=y
> # CONFIG_EXT4_FS_POSIX_ACL is not set
> # CONFIG_EXT4_FS_SECURITY is not set
> CONFIG_EXT4_DEBUG=y
> CONFIG_JBD=y
> CONFIG_JBD_DEBUG=y
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> CONFIG_REISERFS_PROC_INFO=y
> CONFIG_REISERFS_FS_XATTR=y
> # CONFIG_REISERFS_FS_POSIX_ACL is not set
> # CONFIG_REISERFS_FS_SECURITY is not set
> # CONFIG_JFS_FS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_DEBUG=y
> CONFIG_GFS2_FS=y
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> CONFIG_BTRFS_FS=y
> # CONFIG_BTRFS_FS_POSIX_ACL is not set
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
> # CONFIG_BTRFS_DEBUG is not set
> CONFIG_BTRFS_ASSERT=y
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> # CONFIG_FILE_LOCKING is not set
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> CONFIG_PRINT_QUOTA_WARNING=y
> CONFIG_QUOTA_DEBUG=y
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> CONFIG_FSCACHE_STATS=y
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> CONFIG_FSCACHE_OBJECT_LIST=y
> CONFIG_CACHEFILES=y
> CONFIG_CACHEFILES_DEBUG=y
> CONFIG_CACHEFILES_HISTOGRAM=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
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
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> # CONFIG_PROC_PAGE_MONITOR is not set
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=y
> CONFIG_ADFS_FS_RW=y
> # CONFIG_AFFS_FS is not set
> CONFIG_ECRYPT_FS=y
> # CONFIG_ECRYPT_FS_MESSAGING is not set
> CONFIG_HFS_FS=y
> # CONFIG_HFSPLUS_FS is not set
> CONFIG_BEFS_FS=y
> CONFIG_BEFS_DEBUG=y
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_JFFS2_FS is not set
> # CONFIG_UBIFS_FS is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=y
> # CONFIG_SQUASHFS is not set
> CONFIG_VXFS_FS=y
> CONFIG_MINIX_FS=y
> CONFIG_OMFS_FS=y
> # CONFIG_HPFS_FS is not set
> CONFIG_QNX4FS_FS=y
> CONFIG_QNX6FS_FS=y
> CONFIG_QNX6FS_DEBUG=y
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> CONFIG_SYSV_FS=y
> CONFIG_UFS_FS=y
> CONFIG_UFS_FS_WRITE=y
> # CONFIG_UFS_DEBUG is not set
> CONFIG_F2FS_FS=y
> CONFIG_F2FS_STAT_FS=y
> # CONFIG_F2FS_FS_XATTR is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> # CONFIG_NCP_FS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> # CONFIG_NLS_CODEPAGE_860 is not set
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> # CONFIG_NLS_CODEPAGE_874 is not set
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=y
> # CONFIG_NLS_ISO8859_13 is not set
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=y
> CONFIG_NLS_MAC_GREEK=y
> CONFIG_NLS_MAC_ICELAND=y
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=y
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
> CONFIG_BOOT_PRINTK_DELAY=y
> CONFIG_DYNAMIC_DEBUG=y
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_READABLE_ASM is not set
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
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
> CONFIG_DEBUG_OBJECTS=y
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_DEBUG_OBJECTS_WORK=y
> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> # CONFIG_DEBUG_SLAB is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> # CONFIG_SCHED_DEBUG is not set
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_KOBJECT_RELEASE is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_WRITECOUNT is not set
> # CONFIG_DEBUG_LIST is not set
> CONFIG_DEBUG_SG=y
> CONFIG_DEBUG_NOTIFIERS=y
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> CONFIG_PROVE_RCU=y
> # CONFIG_PROVE_RCU_REPEATEDLY is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_INFO=y
> CONFIG_RCU_TRACE=y
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
> CONFIG_PM_NOTIFIER_ERROR_INJECT=y
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
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
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> CONFIG_PROFILE_ALL_BRANCHES=y
> # CONFIG_BRANCH_TRACER is not set
> # CONFIG_STACK_TRACER is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=y
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=y
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
> CONFIG_BUILD_DOCSRC=y
> CONFIG_DMA_API_DEBUG=y
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> # CONFIG_EARLY_PRINTK is not set
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> # CONFIG_DOUBLEFAULT is not set
> CONFIG_DEBUG_TLBFLUSH=y
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
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
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_PCRYPT=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> # CONFIG_CRYPTO_CRC32 is not set
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> # CONFIG_CRYPTO_RMD128 is not set
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> # CONFIG_CRYPTO_RMD320 is not set
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> CONFIG_CRYPTO_KHAZAD=y
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_586=y
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
> # CONFIG_CRYPTO_TEA is not set
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> # CONFIG_CRYPTO_ZLIB is not set
> CONFIG_CRYPTO_LZO=y
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=y
> CONFIG_CRYPTO_DEV_PADLOCK_AES=y
> # CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
> # CONFIG_CRYPTO_DEV_GEODE is not set
> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> # CONFIG_KVM is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_PERCPU_RWSEM=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> CONFIG_CRC32_BIT=y
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> CONFIG_CRC64_ECMA=y
> CONFIG_AUDIT_GENERIC=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> # CONFIG_XZ_DEC_POWERPC is not set
> CONFIG_XZ_DEC_IA64=y
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> CONFIG_CORDIC=y
> CONFIG_DDR=y


-- 
Kind regards,
Minchan Kim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
