Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9792E85A
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 21:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717105686; cv=none; b=UHh+n99jflJi7c96yjHntEBG40gBg/BAZwbDQrCQ1XoQeyD/tEIWWHIEZZO1QnKcQxfEjyYds8WOCrbwfFmbQcfAphHp7n5TUGEeIp0t8bBH7MLpW/BTC8qbItvyLjwxMkUlA1m6r8OlBvOrqmqGuo7XKxEuXbiPQwoux9fqw+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717105686; c=relaxed/simple;
	bh=i95T01QtiowFmsGRxJ8JW4FxhPLN10T0U1jR728eYwc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PyHypJpny6U8nKCA1V5kMHQGlLGrkDm9xn2vxfVM2sxe9/DpfNhyhgng1TXwQX7V3B2vTk81B5c2whL2BrhvzbUVOg55G+ecK+l9tc9psWauYamMFSgF5q2SKWzzQZJBwsZ4NJLmaetPiow5BBYxDhqff9aR/Cf98CfBDvqHBH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E4vik3RX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E4vik3RX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=H1A0vMSpGdO0bO00koUPDMIDHPrEuD8Nlg3FfqYzPDc=; b=E4vik3RXyGkRZi4/+ZLRP5ij52
	Rc4890Mq2C7fUnNsPkF8uOFLT45Or65hLAxj577Yo9qr0HnnZEimxUnuYdHMAjdLcdK0m0sEKsHui
	gpPwLYH+g0c+u3T2/zPh7mTty0XXzLj3fCUPhz0FpTdZCgomGpXClUz9u7mdXhzW+c+CWQGnovKGQ
	aiwQT+7jzjaTQJI2LjcRLLDzdbuspxore2WV/l1FEIJjwm7CWJAWq+7VZ4Euw8hKSeV3wt+ukGnWV
	gChLiPPZ3Kg/zjDvQuFzsHPeeAktcWDDAx/8fShSuLM+ySGydLY73EmcPLY2ifgorTaxBGecLK33w
	fSXc70QA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCncm-00000008VV8-3Wb5;
	Thu, 30 May 2024 21:47:52 +0000
Date: Thu, 30 May 2024 14:47:52 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: surenb@google.com, kent.overstreet@linux.dev, linux-mm@kvack.org,
	david@fromorbit.com
Subject: allocation tagging splats xfs generic/531
Message-ID: <Zlj0CNam_zIuJuB6@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

In trying to help reproduce a generic/531 kernel bug I decided to enable
KASAN and then memory allocation tagging. Running the test immediately
produces a splat with kmem_cache_free() with memory allocation tagging.
But given the boot also produces other ones even on bootup on rcu core
is this known? Are these real isues? What's going on?

  Luis

May 30 11:10:09 linus-xfs-crc kernel: Linux version 6.10.0-rc1 (mcgrof@tumadreentangaroja) (gcc (Debian 13.2.0-23) 13.2.0, GNU ld (GNU Binutils for Debian) 2.42) #3 SMP PREEMPT_DYNAMIC Thu May 30 10:47:03 PDT 2024
May 30 11:10:09 linus-xfs-crc kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-6.10.0-rc1 root=UUID=ddf91058-656c-4606-806a-8a4a9d31676c ro console=tty0 console=tty1 console=ttyS0,115200n8 console=ttyS0,115200n8
May 30 11:10:09 linus-xfs-crc kernel: x86/split lock detection: #DB: warning on user-space bus_locks
May 30 11:10:09 linus-xfs-crc kernel: BIOS-provided physical RAM map:
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x0000000000100000-0x000000007ffdbfff] usable
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x000000007ffdc000-0x000000007fffffff] reserved
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x00000000b0000000-0x00000000bfffffff] reserved
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
May 30 11:10:09 linus-xfs-crc kernel: BIOS-e820: [mem 0x0000000100000000-0x000000017fffffff] usable
May 30 11:10:09 linus-xfs-crc kernel: NX (Execute Disable) protection: active
May 30 11:10:09 linus-xfs-crc kernel: APIC: Static calls initialized
May 30 11:10:09 linus-xfs-crc kernel: SMBIOS 3.0.0 present.
May 30 11:10:09 linus-xfs-crc kernel: DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
May 30 11:10:09 linus-xfs-crc kernel: DMI: Memory slots populated: 1/1
May 30 11:10:09 linus-xfs-crc kernel: Hypervisor detected: KVM
May 30 11:10:09 linus-xfs-crc kernel: kvm-clock: Using msrs 4b564d01 and 4b564d00
May 30 11:10:09 linus-xfs-crc kernel: kvm-clock: using sched offset of 2144875724032230 cycles
May 30 11:10:09 linus-xfs-crc kernel: clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
May 30 11:10:09 linus-xfs-crc kernel: tsc: Detected 2000.000 MHz processor
May 30 11:10:09 linus-xfs-crc kernel: e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
May 30 11:10:09 linus-xfs-crc kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
May 30 11:10:09 linus-xfs-crc kernel: last_pfn = 0x180000 max_arch_pfn = 0x400000000
May 30 11:10:09 linus-xfs-crc kernel: MTRR map: 4 entries (3 fixed + 1 variable; max 19), built from 8 variable MTRRs
May 30 11:10:09 linus-xfs-crc kernel: x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
May 30 11:10:09 linus-xfs-crc kernel: last_pfn = 0x7ffdc max_arch_pfn = 0x400000000
May 30 11:10:09 linus-xfs-crc kernel: found SMP MP-table at [mem 0x000f53e0-0x000f53ef]
May 30 11:10:09 linus-xfs-crc kernel: Using GB pages for direct mapping
May 30 11:10:09 linus-xfs-crc kernel: RAMDISK: [mem 0x28ad7000-0x30562fff]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Early table checksum verification disabled
May 30 11:10:09 linus-xfs-crc kernel: ACPI: RSDP 0x00000000000F53A0 000014 (v00 BOCHS )
May 30 11:10:09 linus-xfs-crc kernel: ACPI: RSDT 0x000000007FFE2CE9 000034 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: FACP 0x000000007FFE2AE1 0000F4 (v03 BOCHS  BXPC     00000001 BXPC 00000001)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: DSDT 0x000000007FFDFC80 002E61 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: FACS 0x000000007FFDFC40 000040
May 30 11:10:09 linus-xfs-crc kernel: ACPI: APIC 0x000000007FFE2BD5 0000B0 (v03 BOCHS  BXPC     00000001 BXPC 00000001)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: MCFG 0x000000007FFE2C85 00003C (v01 BOCHS  BXPC     00000001 BXPC 00000001)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: WAET 0x000000007FFE2CC1 000028 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Reserving FACP table memory at [mem 0x7ffe2ae1-0x7ffe2bd4]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Reserving DSDT table memory at [mem 0x7ffdfc80-0x7ffe2ae0]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Reserving FACS table memory at [mem 0x7ffdfc40-0x7ffdfc7f]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Reserving APIC table memory at [mem 0x7ffe2bd5-0x7ffe2c84]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Reserving MCFG table memory at [mem 0x7ffe2c85-0x7ffe2cc0]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Reserving WAET table memory at [mem 0x7ffe2cc1-0x7ffe2ce8]
May 30 11:10:09 linus-xfs-crc kernel: No NUMA configuration found
May 30 11:10:09 linus-xfs-crc kernel: Faking a node at [mem 0x0000000000000000-0x000000017fffffff]
May 30 11:10:09 linus-xfs-crc kernel: NODE_DATA(0) allocated [mem 0x17fffa000-0x17fffffff]
May 30 11:10:09 linus-xfs-crc kernel: Zone ranges:
May 30 11:10:09 linus-xfs-crc kernel:   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
May 30 11:10:09 linus-xfs-crc kernel:   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
May 30 11:10:09 linus-xfs-crc kernel:   Normal   [mem 0x0000000100000000-0x000000017fffffff]
May 30 11:10:09 linus-xfs-crc kernel:   Device   empty
May 30 11:10:09 linus-xfs-crc kernel: Movable zone start for each node
May 30 11:10:09 linus-xfs-crc kernel: Early memory node ranges
May 30 11:10:09 linus-xfs-crc kernel:   node   0: [mem 0x0000000000001000-0x000000000009efff]
May 30 11:10:09 linus-xfs-crc kernel:   node   0: [mem 0x0000000000100000-0x000000007ffdbfff]
May 30 11:10:09 linus-xfs-crc kernel:   node   0: [mem 0x0000000100000000-0x000000017fffffff]
May 30 11:10:09 linus-xfs-crc kernel: Initmem setup node 0 [mem 0x0000000000001000-0x000000017fffffff]
May 30 11:10:09 linus-xfs-crc kernel: On node 0, zone DMA: 1 pages in unavailable ranges
May 30 11:10:09 linus-xfs-crc kernel: On node 0, zone DMA: 97 pages in unavailable ranges
May 30 11:10:09 linus-xfs-crc kernel: On node 0, zone Normal: 36 pages in unavailable ranges
May 30 11:10:09 linus-xfs-crc kernel: kasan: KernelAddressSanitizer initialized
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PM-Timer IO Port: 0x608
May 30 11:10:09 linus-xfs-crc kernel: ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
May 30 11:10:09 linus-xfs-crc kernel: IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
May 30 11:10:09 linus-xfs-crc kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Using ACPI (MADT) for SMP configuration information
May 30 11:10:09 linus-xfs-crc kernel: TSC deadline timer available
May 30 11:10:09 linus-xfs-crc kernel: CPU topo: Max. logical packages:   8
May 30 11:10:09 linus-xfs-crc kernel: CPU topo: Max. logical dies:       8
May 30 11:10:09 linus-xfs-crc kernel: CPU topo: Max. dies per package:   1
May 30 11:10:09 linus-xfs-crc kernel: CPU topo: Max. threads per core:   1
May 30 11:10:09 linus-xfs-crc kernel: CPU topo: Num. cores per package:     1
May 30 11:10:09 linus-xfs-crc kernel: CPU topo: Num. threads per package:   1
May 30 11:10:09 linus-xfs-crc kernel: CPU topo: Allowing 8 present CPUs plus 0 hotplug CPUs
May 30 11:10:09 linus-xfs-crc kernel: kvm-guest: APIC: eoi() replaced with kvm_guest_apic_eoi_write()
May 30 11:10:09 linus-xfs-crc kernel: kvm-guest: KVM setup pv remote TLB flush
May 30 11:10:09 linus-xfs-crc kernel: kvm-guest: setup PV sched yield
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0x000a0000-0x000effff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0x000f0000-0x000fffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0x7ffdc000-0x7fffffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0x80000000-0xafffffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0xb0000000-0xbfffffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0xc0000000-0xfed1bfff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0xfed20000-0xfeffbfff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0xff000000-0xfffbffff]
May 30 11:10:09 linus-xfs-crc kernel: PM: hibernation: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
May 30 11:10:09 linus-xfs-crc kernel: [mem 0xc0000000-0xfed1bfff] available for PCI devices
May 30 11:10:09 linus-xfs-crc kernel: Booting paravirtualized kernel on KVM
May 30 11:10:09 linus-xfs-crc kernel: clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
May 30 11:10:09 linus-xfs-crc kernel: setup_percpu: NR_CPUS:512 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
May 30 11:10:09 linus-xfs-crc kernel: percpu: Embedded 551 pages/cpu s2159080 r65536 d32280 u4194304
May 30 11:10:09 linus-xfs-crc kernel: pcpu-alloc: s2159080 r65536 d32280 u4194304 alloc=2*2097152
May 30 11:10:09 linus-xfs-crc kernel: pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
May 30 11:10:09 linus-xfs-crc kernel: kvm-guest: PV spinlocks enabled
May 30 11:10:09 linus-xfs-crc kernel: PV qspinlock hash table entries: 256 (order: 0, 4096 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: Kernel command line: BOOT_IMAGE=/boot/vmlinuz-6.10.0-rc1 root=UUID=ddf91058-656c-4606-806a-8a4a9d31676c ro console=tty0 console=tty1 console=ttyS0,115200n8 console=ttyS0,115200n8
May 30 11:10:09 linus-xfs-crc kernel: Unknown kernel command line parameters "BOOT_IMAGE=/boot/vmlinuz-6.10.0-rc1", will be passed to user space.
May 30 11:10:09 linus-xfs-crc kernel: random: crng init done
May 30 11:10:09 linus-xfs-crc kernel: Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: Fallback order for Node 0: 0 
May 30 11:10:09 linus-xfs-crc kernel: Built 1 zonelists, mobility grouping on.  Total pages: 1048442
May 30 11:10:09 linus-xfs-crc kernel: Policy zone: Normal
May 30 11:10:09 linus-xfs-crc kernel: mem auto-init: stack:off, heap alloc:off, heap free:off, mlocked free:off
May 30 11:10:09 linus-xfs-crc kernel: stackdepot: allocating hash table via alloc_large_system_hash
May 30 11:10:09 linus-xfs-crc kernel: stackdepot hash table entries: 1048576 (order: 12, 16777216 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: software IO TLB: area num 8.
May 30 11:10:09 linus-xfs-crc kernel: Memory: 3271380K/4193768K available (38912K kernel code, 7857K rwdata, 9948K rodata, 7768K init, 16704K bss, 922132K reserved, 0K cma-reserved)
May 30 11:10:09 linus-xfs-crc kernel: SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
May 30 11:10:09 linus-xfs-crc kernel: allocated 8388608 bytes of page_ext
May 30 11:10:09 linus-xfs-crc kernel: ftrace: allocating 41242 entries in 162 pages
May 30 11:10:09 linus-xfs-crc kernel: ftrace: allocated 162 pages with 3 groups
May 30 11:10:09 linus-xfs-crc kernel: Dynamic Preempt: full
May 30 11:10:09 linus-xfs-crc kernel: Running RCU self tests
May 30 11:10:09 linus-xfs-crc kernel: Running RCU synchronous self tests
May 30 11:10:09 linus-xfs-crc kernel: rcu: Preemptible hierarchical RCU implementation.
May 30 11:10:09 linus-xfs-crc kernel: rcu:         RCU lockdep checking is enabled.
May 30 11:10:09 linus-xfs-crc kernel: rcu:         RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
May 30 11:10:09 linus-xfs-crc kernel:         Trampoline variant of Tasks RCU enabled.
May 30 11:10:09 linus-xfs-crc kernel:         Rude variant of Tasks RCU enabled.
May 30 11:10:09 linus-xfs-crc kernel:         Tracing variant of Tasks RCU enabled.
May 30 11:10:09 linus-xfs-crc kernel: rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
May 30 11:10:09 linus-xfs-crc kernel: rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
May 30 11:10:09 linus-xfs-crc kernel: Running RCU synchronous self tests
May 30 11:10:09 linus-xfs-crc kernel: RCU Tasks: Setting shift to 3 and lim to 1 rcu_task_cb_adjust=1.
May 30 11:10:09 linus-xfs-crc kernel: RCU Tasks Rude: Setting shift to 3 and lim to 1 rcu_task_cb_adjust=1.
May 30 11:10:09 linus-xfs-crc kernel: RCU Tasks Trace: Setting shift to 3 and lim to 1 rcu_task_cb_adjust=1.
May 30 11:10:09 linus-xfs-crc kernel: NR_IRQS: 33024, nr_irqs: 488, preallocated irqs: 16
May 30 11:10:09 linus-xfs-crc kernel: rcu: srcu_init: Setting srcu_struct sizes based on contention.
May 30 11:10:09 linus-xfs-crc kernel: Console: colour VGA+ 80x25
May 30 11:10:09 linus-xfs-crc kernel: printk: legacy console [tty0] enabled
May 30 11:10:09 linus-xfs-crc kernel: printk: legacy console [ttyS0] enabled
May 30 11:10:09 linus-xfs-crc kernel: Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
May 30 11:10:09 linus-xfs-crc kernel: ... MAX_LOCKDEP_SUBCLASSES:  8
May 30 11:10:09 linus-xfs-crc kernel: ... MAX_LOCK_DEPTH:          48
May 30 11:10:09 linus-xfs-crc kernel: ... MAX_LOCKDEP_KEYS:        8192
May 30 11:10:09 linus-xfs-crc kernel: ... CLASSHASH_SIZE:          4096
May 30 11:10:09 linus-xfs-crc kernel: ... MAX_LOCKDEP_ENTRIES:     32768
May 30 11:10:09 linus-xfs-crc kernel: ... MAX_LOCKDEP_CHAINS:      65536
May 30 11:10:09 linus-xfs-crc kernel: ... CHAINHASH_SIZE:          32768
May 30 11:10:09 linus-xfs-crc kernel:  memory used by lock dependency info: 6941 kB
May 30 11:10:09 linus-xfs-crc kernel:  memory used for stack traces: 4224 kB
May 30 11:10:09 linus-xfs-crc kernel:  per task-struct memory footprint: 2688 bytes
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Core revision 20240322
May 30 11:10:09 linus-xfs-crc kernel: APIC: Switch to symmetric I/O mode setup
May 30 11:10:09 linus-xfs-crc kernel: x2apic enabled
May 30 11:10:09 linus-xfs-crc kernel: APIC: Switched APIC routing to: physical x2apic
May 30 11:10:09 linus-xfs-crc kernel: kvm-guest: APIC: send_IPI_mask() replaced with kvm_send_ipi_mask()
May 30 11:10:09 linus-xfs-crc kernel: kvm-guest: APIC: send_IPI_mask_allbutself() replaced with kvm_send_ipi_mask_allbutself()
May 30 11:10:09 linus-xfs-crc kernel: kvm-guest: setup PV IPIs
May 30 11:10:09 linus-xfs-crc kernel: clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x39a85c9bff6, max_idle_ns: 881590591483 ns
May 30 11:10:09 linus-xfs-crc kernel: Calibrating delay loop (skipped) preset value.. 4000.00 BogoMIPS (lpj=8000000)
May 30 11:10:09 linus-xfs-crc kernel: x86/cpu: User Mode Instruction Prevention (UMIP) activated
May 30 11:10:09 linus-xfs-crc kernel: Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
May 30 11:10:09 linus-xfs-crc kernel: Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
May 30 11:10:09 linus-xfs-crc kernel: Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
May 30 11:10:09 linus-xfs-crc kernel: Spectre V2 : WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!
May 30 11:10:09 linus-xfs-crc kernel: Spectre V2 : Spectre BHI mitigation: SW BHB clearing on vm exit
May 30 11:10:09 linus-xfs-crc kernel: Spectre V2 : Spectre BHI mitigation: SW BHB clearing on syscall
May 30 11:10:09 linus-xfs-crc kernel: Spectre V2 : Mitigation: Enhanced / Automatic IBRS
May 30 11:10:09 linus-xfs-crc kernel: Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
May 30 11:10:09 linus-xfs-crc kernel: Spectre V2 : Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT
May 30 11:10:09 linus-xfs-crc kernel: Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
May 30 11:10:09 linus-xfs-crc kernel: Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
May 30 11:10:09 linus-xfs-crc kernel: TAA: Mitigation: TSX disabled
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x020: 'AVX-512 opmask'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x040: 'AVX-512 Hi256'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x080: 'AVX-512 ZMM_Hi256'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x200: 'Protection Keys User registers'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x20000: 'AMX Tile config'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Supporting XSAVE feature 0x40000: 'AMX Tile data'
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: xstate_offset[5]:  832, xstate_sizes[5]:   64
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: xstate_offset[6]:  896, xstate_sizes[6]:  512
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: xstate_offset[7]: 1408, xstate_sizes[7]: 1024
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: xstate_offset[9]: 2432, xstate_sizes[9]:    8
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: xstate_offset[17]: 2496, xstate_sizes[17]:   64
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: xstate_offset[18]: 2560, xstate_sizes[18]: 8192
May 30 11:10:09 linus-xfs-crc kernel: x86/fpu: Enabled xstate features 0x602e7, context size is 10752 bytes, using 'compacted' format.
May 30 11:10:09 linus-xfs-crc kernel: Freeing SMP alternatives memory: 36K
May 30 11:10:09 linus-xfs-crc kernel: pid_max: default: 32768 minimum: 301
May 30 11:10:09 linus-xfs-crc kernel: LSM: initializing lsm=capability,yama,apparmor,tomoyo
May 30 11:10:09 linus-xfs-crc kernel: Yama: becoming mindful.
May 30 11:10:09 linus-xfs-crc kernel: AppArmor: AppArmor initialized
May 30 11:10:09 linus-xfs-crc kernel: TOMOYO Linux initialized
May 30 11:10:09 linus-xfs-crc kernel: Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: Running RCU synchronous self tests
May 30 11:10:09 linus-xfs-crc kernel: Running RCU synchronous self tests
May 30 11:10:09 linus-xfs-crc kernel: smpboot: CPU0: Intel(R) Xeon(R) Gold 6438Y+ (family: 0x6, model: 0x8f, stepping: 0x8)
May 30 11:10:09 linus-xfs-crc kernel: Running RCU Tasks wait API self tests
May 30 11:10:09 linus-xfs-crc kernel: Running RCU Tasks Rude wait API self tests
May 30 11:10:09 linus-xfs-crc kernel: Running RCU Tasks Trace wait API self tests
May 30 11:10:09 linus-xfs-crc kernel: Performance Events: PEBS fmt4+-baseline, Sapphire Rapids events, full-width counters, Intel PMU driver.
May 30 11:10:09 linus-xfs-crc kernel: ... version:                2
May 30 11:10:09 linus-xfs-crc kernel: ... bit width:              48
May 30 11:10:09 linus-xfs-crc kernel: ... generic registers:      8
May 30 11:10:09 linus-xfs-crc kernel: ... value mask:             0000ffffffffffff
May 30 11:10:09 linus-xfs-crc kernel: ... max period:             00007fffffffffff
May 30 11:10:09 linus-xfs-crc kernel: ... fixed-purpose events:   3
May 30 11:10:09 linus-xfs-crc kernel: ... event mask:             00000007000000ff
May 30 11:10:09 linus-xfs-crc kernel: signal: max sigframe size: 11952
May 30 11:10:09 linus-xfs-crc kernel: Callback from call_rcu_tasks_trace() invoked.
May 30 11:10:09 linus-xfs-crc kernel: rcu: Hierarchical SRCU implementation.
May 30 11:10:09 linus-xfs-crc kernel: rcu:         Max phase no-delay instances is 1000.
May 30 11:10:09 linus-xfs-crc kernel: smp: Bringing up secondary CPUs ...
May 30 11:10:09 linus-xfs-crc kernel: smpboot: x86: Booting SMP configuration:
May 30 11:10:09 linus-xfs-crc kernel: .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
May 30 11:10:09 linus-xfs-crc kernel: smp: Brought up 1 node, 8 CPUs
May 30 11:10:09 linus-xfs-crc kernel: smpboot: Total of 8 processors activated (32000.00 BogoMIPS)
May 30 11:10:09 linus-xfs-crc kernel: devtmpfs: initialized
May 30 11:10:09 linus-xfs-crc kernel: x86/mm: Memory block size: 128MB
May 30 11:10:09 linus-xfs-crc kernel: Running RCU synchronous self tests
May 30 11:10:09 linus-xfs-crc kernel: Running RCU synchronous self tests
May 30 11:10:09 linus-xfs-crc kernel: clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
May 30 11:10:09 linus-xfs-crc kernel: futex hash table entries: 2048 (order: 6, 262144 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: pinctrl core: initialized pinctrl subsystem
May 30 11:10:09 linus-xfs-crc kernel: NET: Registered PF_NETLINK/PF_ROUTE protocol family
May 30 11:10:09 linus-xfs-crc kernel: audit: initializing netlink subsys (disabled)
May 30 11:10:09 linus-xfs-crc kernel: audit: type=2000 audit(1717092559.466:1): state=initialized audit_enabled=0 res=1
May 30 11:10:09 linus-xfs-crc kernel: thermal_sys: Registered thermal governor 'fair_share'
May 30 11:10:09 linus-xfs-crc kernel: thermal_sys: Registered thermal governor 'bang_bang'
May 30 11:10:09 linus-xfs-crc kernel: thermal_sys: Registered thermal governor 'step_wise'
May 30 11:10:09 linus-xfs-crc kernel: thermal_sys: Registered thermal governor 'user_space'
May 30 11:10:09 linus-xfs-crc kernel: cpuidle: using governor ladder
May 30 11:10:09 linus-xfs-crc kernel: cpuidle: using governor menu
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
May 30 11:10:09 linus-xfs-crc kernel: PCI: ECAM [mem 0xb0000000-0xbfffffff] (base 0xb0000000) for domain 0000 [bus 00-ff]
May 30 11:10:09 linus-xfs-crc kernel: PCI: ECAM [mem 0xb0000000-0xbfffffff] reserved as E820 entry
May 30 11:10:09 linus-xfs-crc kernel: PCI: Using configuration type 1 for base access
May 30 11:10:09 linus-xfs-crc kernel: kprobes: kprobe jump-optimization is enabled. All kprobes are optimized if possible.
May 30 11:10:09 linus-xfs-crc kernel: Callback from call_rcu_tasks_rude() invoked.
May 30 11:10:09 linus-xfs-crc kernel: HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
May 30 11:10:09 linus-xfs-crc kernel: HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
May 30 11:10:09 linus-xfs-crc kernel: HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
May 30 11:10:09 linus-xfs-crc kernel: HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
May 30 11:10:09 linus-xfs-crc kernel: Demotion targets for Node 0: null
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Added _OSI(Module Device)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Added _OSI(Processor Device)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Added _OSI(Processor Aggregator Device)
May 30 11:10:09 linus-xfs-crc kernel: Callback from call_rcu_tasks() invoked.
May 30 11:10:09 linus-xfs-crc kernel: ACPI: 1 ACPI AML tables successfully acquired and loaded
May 30 11:10:09 linus-xfs-crc kernel: ACPI: _OSC evaluation for CPUs failed, trying _PDC
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Interpreter enabled
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PM: (supports S0 S3 S4 S5)
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Using IOAPIC for interrupt routing
May 30 11:10:09 linus-xfs-crc kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
May 30 11:10:09 linus-xfs-crc kernel: PCI: Using E820 reservations for host bridge windows
May 30 11:10:09 linus-xfs-crc kernel: ACPI: Enabled 2 GPEs in block 00 to 3F
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-1f])
May 30 11:10:09 linus-xfs-crc kernel: acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
May 30 11:10:09 linus-xfs-crc kernel: acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug LTR]
May 30 11:10:09 linus-xfs-crc kernel: acpi PNP0A08:00: _OSC: OS now controls [SHPCHotplug PME AER PCIeCapability]
May 30 11:10:09 linus-xfs-crc kernel: PCI host bridge to bus 0000:00
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [mem 0x80000000-0xafffffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfc5fffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [mem 0xfce00000-0xfea0ffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [mem 0xfea14000-0xfebfffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [mem 0x382000000000-0x389000003fff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: root bus resource [bus 00-1f]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000 conventional PCI endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0: BAR 0 [mem 0xfea00000-0xfea00fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0:   bridge window [mem 0x388800000000-0x388fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1: BAR 0 [mem 0xfea01000-0xfea01fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1: PCI bridge to [bus 02]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1:   bridge window [mem 0xfe600000-0xfe7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1:   bridge window [mem 0x388000000000-0x3887ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2: BAR 0 [mem 0xfea02000-0xfea02fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2: PCI bridge to [bus 03]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2:   bridge window [mem 0xfe400000-0xfe5fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2:   bridge window [mem 0x387800000000-0x387fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3: BAR 0 [mem 0xfea03000-0xfea03fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3: PCI bridge to [bus 04]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3:   bridge window [mem 0xfe200000-0xfe3fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3:   bridge window [mem 0x387000000000-0x3877ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4: BAR 0 [mem 0xfea04000-0xfea04fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4: PCI bridge to [bus 05]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4:   bridge window [mem 0xfe000000-0xfe1fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4:   bridge window [mem 0x386800000000-0x386fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5: BAR 0 [mem 0xfea05000-0xfea05fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5: PCI bridge to [bus 06]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5:   bridge window [mem 0xfde00000-0xfdffffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5:   bridge window [mem 0x386000000000-0x3867ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6: BAR 0 [mem 0xfea06000-0xfea06fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6: PCI bridge to [bus 07]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6:   bridge window [mem 0xfdc00000-0xfddfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6:   bridge window [mem 0x385800000000-0x385fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7: BAR 0 [mem 0xfea07000-0xfea07fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7: PCI bridge to [bus 08]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7:   bridge window [mem 0xfda00000-0xfdbfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7:   bridge window [mem 0x385000000000-0x3857ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0: BAR 0 [mem 0xfea08000-0xfea08fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0: PCI bridge to [bus 09]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0:   bridge window [mem 0xfd800000-0xfd9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0:   bridge window [mem 0x384800000000-0x384fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1: BAR 0 [mem 0xfea09000-0xfea09fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1: PCI bridge to [bus 0a]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1:   bridge window [mem 0xfd600000-0xfd7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1:   bridge window [mem 0x384000000000-0x3847ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2: BAR 0 [mem 0xfea0a000-0xfea0afff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2: PCI bridge to [bus 0b]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2:   bridge window [mem 0xfd400000-0xfd5fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2:   bridge window [mem 0x383800000000-0x383fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3: BAR 0 [mem 0xfea0b000-0xfea0bfff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3: PCI bridge to [bus 0c]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3:   bridge window [mem 0xfd200000-0xfd3fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3:   bridge window [mem 0x383000000000-0x3837ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4: BAR 0 [mem 0xfea0c000-0xfea0cfff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4: PCI bridge to [bus 0d]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4:   bridge window [mem 0xfd000000-0xfd1fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4:   bridge window [mem 0x382800000000-0x382fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5: BAR 0 [mem 0xfea0d000-0xfea0dfff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5: PCI bridge to [bus 0e]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5:   bridge window [mem 0xfce00000-0xfcffffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5:   bridge window [mem 0x382000000000-0x3827ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:08.0: [1b36:000b] type 00 class 0x060000 conventional PCI endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:10.0: [1af4:1009] type 00 class 0x000200 conventional PCI endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:10.0: BAR 0 [io  0xc000-0xc03f]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:10.0: BAR 1 [mem 0xfea0e000-0xfea0efff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:10.0: BAR 4 [mem 0x389000000000-0x389000003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100 conventional PCI endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by ICH6 ACPI/GPIO/TCO
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601 conventional PCI endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:1f.2: BAR 4 [io  0xc080-0xc09f]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:1f.2: BAR 5 [mem 0xfea0f000-0xfea0ffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500 conventional PCI endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:1f.3: BAR 4 [io  0x0700-0x073f]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:01:00.0: [1af4:1041] type 00 class 0x020000 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:01:00.0: BAR 1 [mem 0xfe840000-0xfe840fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:01:00.0: BAR 4 [mem 0x388800000000-0x388800003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:01:00.0: ROM [mem 0xfe800000-0xfe83ffff pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-2] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:02:00.0: [1b36:000d] type 00 class 0x0c0330 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:02:00.0: BAR 0 [mem 0xfe600000-0xfe603fff 64bit]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1: PCI bridge to [bus 02]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-3] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:03:00.0: [1af4:1043] type 00 class 0x078000 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:03:00.0: BAR 1 [mem 0xfe400000-0xfe400fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:03:00.0: BAR 4 [mem 0x387800000000-0x387800003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2: PCI bridge to [bus 03]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-4] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:04:00.0: [1af4:1042] type 00 class 0x010000 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:04:00.0: BAR 1 [mem 0xfe200000-0xfe200fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:04:00.0: BAR 4 [mem 0x387000000000-0x387000003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3: PCI bridge to [bus 04]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-5] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:05:00.0: [1af4:1045] type 00 class 0x00ff00 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:05:00.0: BAR 4 [mem 0x386800000000-0x386800003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4: PCI bridge to [bus 05]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-6] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:06:00.0: [1af4:1044] type 00 class 0x00ff00 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:06:00.0: BAR 1 [mem 0xfde00000-0xfde00fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:06:00.0: BAR 4 [mem 0x386000000000-0x386000003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5: PCI bridge to [bus 06]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-7] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6: PCI bridge to [bus 07]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-8] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7: PCI bridge to [bus 08]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-9] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0: PCI bridge to [bus 09]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-10] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1: PCI bridge to [bus 0a]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-11] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2: PCI bridge to [bus 0b]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-12] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3: PCI bridge to [bus 0c]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-13] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4: PCI bridge to [bus 0d]
May 30 11:10:09 linus-xfs-crc kernel: acpiphp: Slot [0-14] registered
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5: PCI bridge to [bus 0e]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKA configured for IRQ 10
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKB configured for IRQ 10
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKC configured for IRQ 11
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKD configured for IRQ 11
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKE configured for IRQ 10
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKF configured for IRQ 10
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKG configured for IRQ 11
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link LNKH configured for IRQ 11
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSIA configured for IRQ 16
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSIB configured for IRQ 17
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSIC configured for IRQ 18
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSID configured for IRQ 19
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSIE configured for IRQ 20
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSIF configured for IRQ 21
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSIG configured for IRQ 22
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI: Interrupt link GSIH configured for IRQ 23
May 30 11:10:09 linus-xfs-crc kernel: ACPI: PCI Root Bridge [PC20] (domain 0000 [bus 20-24])
May 30 11:10:09 linus-xfs-crc kernel: acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
May 30 11:10:09 linus-xfs-crc kernel: acpi PNP0A08:01: _OSC: platform does not support [LTR]
May 30 11:10:09 linus-xfs-crc kernel: acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug SHPCHotplug PME AER PCIeCapability]
May 30 11:10:09 linus-xfs-crc kernel: PCI host bridge to bus 0000:20
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:20: root bus resource [mem 0xfc600000-0xfcdfffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:20: root bus resource [mem 0xfea10000-0xfea13fff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:20: root bus resource [mem 0x380000000000-0x381fffffffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:20: root bus resource [bus 20-24]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: BAR 0 [mem 0xfea10000-0xfea10fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: PCI bridge to [bus 21]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0:   bridge window [mem 0xfcc00000-0xfcdfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0:   bridge window [mem 0x381800000000-0x381fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: BAR 0 [mem 0xfea11000-0xfea11fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: PCI bridge to [bus 22]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0:   bridge window [mem 0xfca00000-0xfcbfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0:   bridge window [mem 0x381000000000-0x3817ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: BAR 0 [mem 0xfea12000-0xfea12fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: PCI bridge to [bus 23]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0:   bridge window [mem 0xfc800000-0xfc9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0:   bridge window [mem 0x380800000000-0x380fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: BAR 0 [mem 0xfea13000-0xfea13fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: PCI bridge to [bus 24]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0:   bridge window [mem 0xfc600000-0xfc7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0:   bridge window [mem 0x380000000000-0x3807ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:21:00.0: [1af4:1042] type 00 class 0x010000 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:21:00.0: BAR 1 [mem 0xfcc00000-0xfcc00fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:21:00.0: BAR 4 [mem 0x381800000000-0x381800003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: PCI bridge to [bus 21]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:22:00.0: [1af4:1042] type 00 class 0x010000 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:22:00.0: BAR 1 [mem 0xfca00000-0xfca00fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:22:00.0: BAR 4 [mem 0x381000000000-0x381000003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: PCI bridge to [bus 22]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:23:00.0: [1af4:1042] type 00 class 0x010000 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:23:00.0: BAR 1 [mem 0xfc800000-0xfc800fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:23:00.0: BAR 4 [mem 0x380800000000-0x380800003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: PCI bridge to [bus 23]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:24:00.0: [1af4:1042] type 00 class 0x010000 PCIe Endpoint
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:24:00.0: BAR 1 [mem 0xfc600000-0xfc600fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:24:00.0: BAR 4 [mem 0x380000000000-0x380000003fff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: PCI bridge to [bus 24]
May 30 11:10:09 linus-xfs-crc kernel: iommu: Default domain type: Translated
May 30 11:10:09 linus-xfs-crc kernel: iommu: DMA domain TLB invalidation policy: lazy mode
May 30 11:10:09 linus-xfs-crc kernel: pps_core: LinuxPPS API ver. 1 registered
May 30 11:10:09 linus-xfs-crc kernel: pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
May 30 11:10:09 linus-xfs-crc kernel: PTP clock support registered
May 30 11:10:09 linus-xfs-crc kernel: EDAC MC: Ver: 3.0.0
May 30 11:10:09 linus-xfs-crc kernel: PCI: Using ACPI for IRQ routing
May 30 11:10:09 linus-xfs-crc kernel: PCI: pci_cache_line_size set to 64 bytes
May 30 11:10:09 linus-xfs-crc kernel: e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
May 30 11:10:09 linus-xfs-crc kernel: e820: reserve RAM buffer [mem 0x7ffdc000-0x7fffffff]
May 30 11:10:09 linus-xfs-crc kernel: vgaarb: loaded
May 30 11:10:09 linus-xfs-crc kernel: clocksource: Switched to clocksource kvm-clock
May 30 11:10:09 linus-xfs-crc kernel: VFS: Disk quotas dquot_6.6.0
May 30 11:10:09 linus-xfs-crc kernel: VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
May 30 11:10:09 linus-xfs-crc kernel: AppArmor: AppArmor Filesystem Enabled
May 30 11:10:09 linus-xfs-crc kernel: pnp: PnP ACPI init
May 30 11:10:09 linus-xfs-crc kernel: system 00:04: [mem 0xb0000000-0xbfffffff window] has been reserved
May 30 11:10:09 linus-xfs-crc kernel: pnp: PnP ACPI: found 5 devices
May 30 11:10:09 linus-xfs-crc kernel: clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
May 30 11:10:09 linus-xfs-crc kernel: NET: Registered PF_INET protocol family
May 30 11:10:09 linus-xfs-crc kernel: IP idents hash table entries: 65536 (order: 7, 524288 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: tcp_listen_portaddr_hash hash table entries: 2048 (order: 5, 163840 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: TCP bind hash table entries: 32768 (order: 10, 5242880 bytes, vmalloc hugepage)
May 30 11:10:09 linus-xfs-crc kernel: TCP: Hash tables configured (established 32768 bind 32768)
May 30 11:10:09 linus-xfs-crc kernel: UDP hash table entries: 2048 (order: 6, 393216 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes, linear)
May 30 11:10:09 linus-xfs-crc kernel: NET: Registered PF_UNIX/PF_LOCAL protocol family
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4: bridge window [io  0x1000-0x0fff] to [bus 05] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5: bridge window [io  0x1000-0x0fff] to [bus 06] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6: bridge window [io  0x1000-0x0fff] to [bus 07] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7: bridge window [io  0x1000-0x0fff] to [bus 08] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0: bridge window [io  0x1000-0x0fff] to [bus 09] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1: bridge window [io  0x1000-0x0fff] to [bus 0a] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2: bridge window [io  0x1000-0x0fff] to [bus 0b] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3: bridge window [io  0x1000-0x0fff] to [bus 0c] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4: bridge window [io  0x1000-0x0fff] to [bus 0d] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5: bridge window [io  0x1000-0x0fff] to [bus 0e] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0: bridge window [io  0x1000-0x1fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1: bridge window [io  0x2000-0x2fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2: bridge window [io  0x3000-0x3fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3: bridge window [io  0x4000-0x4fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4: bridge window [io  0x5000-0x5fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5: bridge window [io  0x6000-0x6fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6: bridge window [io  0x7000-0x7fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7: bridge window [io  0x8000-0x8fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0: bridge window [io  0x9000-0x9fff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1: bridge window [io  0xa000-0xafff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2: bridge window [io  0xb000-0xbfff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3: bridge window [io  0xd000-0xdfff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4: bridge window [io  0xe000-0xefff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5: bridge window [io  0xf000-0xffff]: assigned
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0:   bridge window [io  0x1000-0x1fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.0:   bridge window [mem 0x388800000000-0x388fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1: PCI bridge to [bus 02]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1:   bridge window [io  0x2000-0x2fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1:   bridge window [mem 0xfe600000-0xfe7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.1:   bridge window [mem 0x388000000000-0x3887ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2: PCI bridge to [bus 03]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2:   bridge window [io  0x3000-0x3fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2:   bridge window [mem 0xfe400000-0xfe5fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.2:   bridge window [mem 0x387800000000-0x387fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3: PCI bridge to [bus 04]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3:   bridge window [io  0x4000-0x4fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3:   bridge window [mem 0xfe200000-0xfe3fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.3:   bridge window [mem 0x387000000000-0x3877ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4: PCI bridge to [bus 05]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4:   bridge window [io  0x5000-0x5fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4:   bridge window [mem 0xfe000000-0xfe1fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.4:   bridge window [mem 0x386800000000-0x386fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5: PCI bridge to [bus 06]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5:   bridge window [io  0x6000-0x6fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5:   bridge window [mem 0xfde00000-0xfdffffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.5:   bridge window [mem 0x386000000000-0x3867ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6: PCI bridge to [bus 07]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6:   bridge window [io  0x7000-0x7fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6:   bridge window [mem 0xfdc00000-0xfddfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.6:   bridge window [mem 0x385800000000-0x385fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7: PCI bridge to [bus 08]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7:   bridge window [io  0x8000-0x8fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7:   bridge window [mem 0xfda00000-0xfdbfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:01.7:   bridge window [mem 0x385000000000-0x3857ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0: PCI bridge to [bus 09]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0:   bridge window [io  0x9000-0x9fff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0:   bridge window [mem 0xfd800000-0xfd9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.0:   bridge window [mem 0x384800000000-0x384fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1: PCI bridge to [bus 0a]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1:   bridge window [io  0xa000-0xafff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1:   bridge window [mem 0xfd600000-0xfd7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.1:   bridge window [mem 0x384000000000-0x3847ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2: PCI bridge to [bus 0b]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2:   bridge window [io  0xb000-0xbfff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2:   bridge window [mem 0xfd400000-0xfd5fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.2:   bridge window [mem 0x383800000000-0x383fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3: PCI bridge to [bus 0c]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3:   bridge window [io  0xd000-0xdfff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3:   bridge window [mem 0xfd200000-0xfd3fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.3:   bridge window [mem 0x383000000000-0x3837ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4: PCI bridge to [bus 0d]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4:   bridge window [io  0xe000-0xefff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4:   bridge window [mem 0xfd000000-0xfd1fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.4:   bridge window [mem 0x382800000000-0x382fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5: PCI bridge to [bus 0e]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5:   bridge window [io  0xf000-0xffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5:   bridge window [mem 0xfce00000-0xfcffffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:00:02.5:   bridge window [mem 0x382000000000-0x3827ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 7 [mem 0x80000000-0xafffffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 8 [mem 0xc0000000-0xfc5fffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 9 [mem 0xfce00000-0xfea0ffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 10 [mem 0xfea14000-0xfebfffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:00: resource 11 [mem 0x382000000000-0x389000003fff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:01: resource 2 [mem 0x388800000000-0x388fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:02: resource 1 [mem 0xfe600000-0xfe7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:02: resource 2 [mem 0x388000000000-0x3887ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:03: resource 1 [mem 0xfe400000-0xfe5fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:03: resource 2 [mem 0x387800000000-0x387fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:04: resource 1 [mem 0xfe200000-0xfe3fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:04: resource 2 [mem 0x387000000000-0x3877ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:05: resource 1 [mem 0xfe000000-0xfe1fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:05: resource 2 [mem 0x386800000000-0x386fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:06: resource 0 [io  0x6000-0x6fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:06: resource 1 [mem 0xfde00000-0xfdffffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:06: resource 2 [mem 0x386000000000-0x3867ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:07: resource 0 [io  0x7000-0x7fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:07: resource 1 [mem 0xfdc00000-0xfddfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:07: resource 2 [mem 0x385800000000-0x385fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:08: resource 0 [io  0x8000-0x8fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:08: resource 1 [mem 0xfda00000-0xfdbfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:08: resource 2 [mem 0x385000000000-0x3857ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:09: resource 0 [io  0x9000-0x9fff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:09: resource 1 [mem 0xfd800000-0xfd9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:09: resource 2 [mem 0x384800000000-0x384fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0a: resource 0 [io  0xa000-0xafff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0a: resource 1 [mem 0xfd600000-0xfd7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0a: resource 2 [mem 0x384000000000-0x3847ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0b: resource 0 [io  0xb000-0xbfff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0b: resource 1 [mem 0xfd400000-0xfd5fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0b: resource 2 [mem 0x383800000000-0x383fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0c: resource 0 [io  0xd000-0xdfff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0c: resource 1 [mem 0xfd200000-0xfd3fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0c: resource 2 [mem 0x383000000000-0x3837ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0d: resource 0 [io  0xe000-0xefff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0d: resource 1 [mem 0xfd000000-0xfd1fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0d: resource 2 [mem 0x382800000000-0x382fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0e: resource 0 [io  0xf000-0xffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0e: resource 1 [mem 0xfce00000-0xfcffffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:0e: resource 2 [mem 0x382000000000-0x3827ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: bridge window [io  0x1000-0x0fff] to [bus 21] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: bridge window [io  0x1000-0x0fff] to [bus 22] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: bridge window [io  0x1000-0x0fff] to [bus 23] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: bridge window [io  0x1000-0x0fff] to [bus 24] add_size 1000
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: bridge window [io  size 0x1000]: can't assign; no space
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: bridge window [io  size 0x1000]: failed to assign
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0: PCI bridge to [bus 21]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0:   bridge window [mem 0xfcc00000-0xfcdfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:00.0:   bridge window [mem 0x381800000000-0x381fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0: PCI bridge to [bus 22]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0:   bridge window [mem 0xfca00000-0xfcbfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:01.0:   bridge window [mem 0x381000000000-0x3817ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0: PCI bridge to [bus 23]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0:   bridge window [mem 0xfc800000-0xfc9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:02.0:   bridge window [mem 0x380800000000-0x380fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0: PCI bridge to [bus 24]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0:   bridge window [mem 0xfc600000-0xfc7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:20:03.0:   bridge window [mem 0x380000000000-0x3807ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:20: resource 4 [mem 0xfc600000-0xfcdfffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:20: resource 5 [mem 0xfea10000-0xfea13fff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:20: resource 6 [mem 0x380000000000-0x381fffffffff window]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:21: resource 1 [mem 0xfcc00000-0xfcdfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:21: resource 2 [mem 0x381800000000-0x381fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:22: resource 1 [mem 0xfca00000-0xfcbfffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:22: resource 2 [mem 0x381000000000-0x3817ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:23: resource 1 [mem 0xfc800000-0xfc9fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:23: resource 2 [mem 0x380800000000-0x380fffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:24: resource 1 [mem 0xfc600000-0xfc7fffff]
May 30 11:10:09 linus-xfs-crc kernel: pci_bus 0000:24: resource 2 [mem 0x380000000000-0x3807ffffffff 64bit pref]
May 30 11:10:09 linus-xfs-crc kernel: ACPI: \_SB_.GSIF: Enabled at IRQ 21
May 30 11:10:09 linus-xfs-crc kernel: pci 0000:02:00.0: quirk_usb_early_handoff+0x0/0xb40 took 72801 usecs
May 30 11:10:09 linus-xfs-crc kernel: PCI: CLS 0 bytes, default 64
May 30 11:10:09 linus-xfs-crc kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
May 30 11:10:09 linus-xfs-crc kernel: software IO TLB: mapped [mem 0x000000007bfdc000-0x000000007ffdc000] (64MB)
May 30 11:10:09 linus-xfs-crc kernel: clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x39a85c9bff6, max_idle_ns: 881590591483 ns
May 30 11:10:09 linus-xfs-crc kernel: clocksource: Switched to clocksource tsc
May 30 11:10:09 linus-xfs-crc kernel: Trying to unpack rootfs image as initramfs...
May 30 11:10:09 linus-xfs-crc kernel: Initialise system trusted keyrings
May 30 11:10:09 linus-xfs-crc kernel: workingset: timestamp_bits=40 max_order=20 bucket_order=0
May 30 11:10:09 linus-xfs-crc kernel: zbud: loaded
May 30 11:10:09 linus-xfs-crc kernel: Key type asymmetric registered
May 30 11:10:09 linus-xfs-crc kernel: Asymmetric key parser 'x509' registered
May 30 11:10:09 linus-xfs-crc kernel: Freeing initrd memory: 125488K
May 30 11:10:09 linus-xfs-crc kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
May 30 11:10:09 linus-xfs-crc kernel: io scheduler mq-deadline registered
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.0: PME: Signaling with IRQ 24
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.0: AER: enabled with IRQ 24
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.1: PME: Signaling with IRQ 25
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.1: AER: enabled with IRQ 25
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.2: PME: Signaling with IRQ 26
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.2: AER: enabled with IRQ 26
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.3: PME: Signaling with IRQ 27
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.3: AER: enabled with IRQ 27
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.4: PME: Signaling with IRQ 28
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.4: AER: enabled with IRQ 28
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.5: PME: Signaling with IRQ 29
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.5: AER: enabled with IRQ 29
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.6: PME: Signaling with IRQ 30
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.6: AER: enabled with IRQ 30
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.7: PME: Signaling with IRQ 31
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:01.7: AER: enabled with IRQ 31
May 30 11:10:09 linus-xfs-crc kernel: ACPI: \_SB_.GSIG: Enabled at IRQ 22
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.0: PME: Signaling with IRQ 32
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.0: AER: enabled with IRQ 32
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.1: PME: Signaling with IRQ 33
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.1: AER: enabled with IRQ 33
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.2: PME: Signaling with IRQ 34
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.2: AER: enabled with IRQ 34
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.3: PME: Signaling with IRQ 35
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.3: AER: enabled with IRQ 35
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.4: PME: Signaling with IRQ 36
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.4: AER: enabled with IRQ 36
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.5: PME: Signaling with IRQ 37
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:00:02.5: AER: enabled with IRQ 37
May 30 11:10:09 linus-xfs-crc kernel: ACPI: \_SB_.LNKD: Enabled at IRQ 11
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:00.0: PME: Signaling with IRQ 38
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:00.0: AER: enabled with IRQ 38
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:00.0: pciehp: Slot #0 AttnBtn+ PwrCtrl+ MRL- AttnInd+ PwrInd+ HotPlug+ Surprise+ Interlock+ NoCompl- IbPresDis- LLActRep+
May 30 11:10:09 linus-xfs-crc kernel: ACPI: \_SB_.LNKA: Enabled at IRQ 10
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:01.0: PME: Signaling with IRQ 39
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:01.0: AER: enabled with IRQ 39
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:01.0: pciehp: Slot #0 AttnBtn+ PwrCtrl+ MRL- AttnInd+ PwrInd+ HotPlug+ Surprise+ Interlock+ NoCompl- IbPresDis- LLActRep+
May 30 11:10:09 linus-xfs-crc kernel: ACPI: \_SB_.LNKB: Enabled at IRQ 10
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:02.0: PME: Signaling with IRQ 40
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:02.0: AER: enabled with IRQ 40
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:02.0: pciehp: Slot #0 AttnBtn+ PwrCtrl+ MRL- AttnInd+ PwrInd+ HotPlug+ Surprise+ Interlock+ NoCompl- IbPresDis- LLActRep+
May 30 11:10:09 linus-xfs-crc kernel: ACPI: \_SB_.LNKC: Enabled at IRQ 11
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:03.0: PME: Signaling with IRQ 41
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:03.0: AER: enabled with IRQ 41
May 30 11:10:09 linus-xfs-crc kernel: pcieport 0000:20:03.0: pciehp: Slot #0 AttnBtn+ PwrCtrl+ MRL- AttnInd+ PwrInd+ HotPlug+ Surprise+ Interlock+ NoCompl- IbPresDis- LLActRep+
May 30 11:10:09 linus-xfs-crc kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
May 30 11:10:09 linus-xfs-crc kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
May 30 11:10:09 linus-xfs-crc kernel: 00:00: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
May 30 11:10:09 linus-xfs-crc kernel: Linux agpgart interface v0.103
May 30 11:10:09 linus-xfs-crc kernel: i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
May 30 11:10:09 linus-xfs-crc kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
May 30 11:10:09 linus-xfs-crc kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
May 30 11:10:09 linus-xfs-crc kernel: mousedev: PS/2 mouse device common for all mice
May 30 11:10:10 linus-xfs-crc kernel: rtc_cmos 00:03: RTC can wake from S4
May 30 11:10:10 linus-xfs-crc kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
May 30 11:10:10 linus-xfs-crc kernel: rtc_cmos 00:03: registered as rtc0
May 30 11:10:10 linus-xfs-crc kernel: rtc_cmos 00:03: setting system clock to 2024-05-30T18:09:39 UTC (1717092579)
May 30 11:10:10 linus-xfs-crc kernel: rtc_cmos 00:03: alarms up to one day, y3k, 242 bytes nvram
May 30 11:10:10 linus-xfs-crc kernel: intel_pstate: CPU model not supported
May 30 11:10:10 linus-xfs-crc kernel: ledtrig-cpu: registered to indicate activity on CPUs
May 30 11:10:10 linus-xfs-crc kernel: NET: Registered PF_INET6 protocol family
May 30 11:10:10 linus-xfs-crc kernel: Segment Routing with IPv6
May 30 11:10:10 linus-xfs-crc kernel: In-situ OAM (IOAM) with IPv6
May 30 11:10:10 linus-xfs-crc kernel: mip6: Mobile IPv6
May 30 11:10:10 linus-xfs-crc kernel: NET: Registered PF_PACKET protocol family
May 30 11:10:10 linus-xfs-crc kernel: 9pnet: Installing 9P2000 support
May 30 11:10:10 linus-xfs-crc kernel: mpls_gso: MPLS GSO support
May 30 11:10:10 linus-xfs-crc kernel: IPI shorthand broadcast: enabled
May 30 11:10:10 linus-xfs-crc kernel: sched_clock: Marking stable (19828006731, 111175665)->(20178569564, -239387168)
May 30 11:10:10 linus-xfs-crc kernel: Timer migration: 1 hierarchy levels; 8 children per group; 1 crossnode level
May 30 11:10:10 linus-xfs-crc kernel: registered taskstats version 1
May 30 11:10:10 linus-xfs-crc kernel: Loading compiled-in X.509 certificates
May 30 11:10:10 linus-xfs-crc kernel: Demotion targets for Node 0: null
May 30 11:10:10 linus-xfs-crc kernel: kmemleak: Kernel memory leak detector initialized (mem pool available: 14118)
May 30 11:10:10 linus-xfs-crc kernel: Key type .fscrypt registered
May 30 11:10:10 linus-xfs-crc kernel: Key type fscrypt-provisioning registered
May 30 11:10:10 linus-xfs-crc kernel: AppArmor: AppArmor sha256 policy hashing enabled
May 30 11:10:10 linus-xfs-crc kernel: clk: Disabling unused clocks
May 30 11:10:10 linus-xfs-crc kernel: Freeing unused kernel image (initmem) memory: 7768K
May 30 11:10:10 linus-xfs-crc kernel: Write protecting the kernel read-only data: 49152k
May 30 11:10:10 linus-xfs-crc kernel: Freeing unused kernel image (rodata/data gap) memory: 292K
May 30 11:10:10 linus-xfs-crc kernel: x86/mm: Checked W+X mappings: passed, no W+X pages found.
May 30 11:10:10 linus-xfs-crc kernel: Run /init as init process
May 30 11:10:10 linus-xfs-crc kernel:   with arguments:
May 30 11:10:10 linus-xfs-crc kernel:     /init
May 30 11:10:10 linus-xfs-crc kernel:   with environment:
May 30 11:10:10 linus-xfs-crc kernel:     HOME=/
May 30 11:10:10 linus-xfs-crc kernel:     TERM=linux
May 30 11:10:10 linus-xfs-crc kernel:     BOOT_IMAGE=/boot/vmlinuz-6.10.0-rc1
May 30 11:10:10 linus-xfs-crc kernel: input: VirtualPS/2 VMware VMMouse as /devices/platform/i8042/serio1/input/input3
May 30 11:10:10 linus-xfs-crc kernel: input: VirtualPS/2 VMware VMMouse as /devices/platform/i8042/serio1/input/input2
May 30 11:10:10 linus-xfs-crc kernel: ACPI: \_SB_.GSIE: Enabled at IRQ 20
May 30 11:10:10 linus-xfs-crc kernel: ------------[ cut here ]------------
May 30 11:10:10 linus-xfs-crc kernel: alloc_tag was not set
May 30 11:10:10 linus-xfs-crc kernel: WARNING: CPU: 1 PID: 183 at include/linux/alloc_tag.h:130 kmem_cache_free+0x55e/0x5d0
May 30 11:10:10 linus-xfs-crc kernel: Modules linked in: crc32_pclmul crc32c_intel psmouse virtio_pci(+) virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring
May 30 11:10:10 linus-xfs-crc kernel: CPU: 1 PID: 183 Comm: (udev-worker) Not tainted 6.10.0-rc1 #3
May 30 11:10:10 linus-xfs-crc kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
May 30 11:10:10 linus-xfs-crc kernel: RIP: 0010:kmem_cache_free+0x55e/0x5d0
May 30 11:10:10 linus-xfs-crc kernel: Code: 48 8b 5c 24 10 e9 1e fc ff ff 80 3d f7 e2 d4 02 00 0f 85 11 fc ff ff 48 c7 c7 1c 90 48 ac c6 05 e3 e2 d4 02 01 e8 d2 7e 79 ff <0f> 0b 49 8b 44 24 08 48 85 c0 75 a4 e9 e8 fb ff ff 48 c7 c6 40 af
May 30 11:10:10 linus-xfs-crc kernel: RSP: 0018:ffff888154209e00 EFLAGS: 00010282
May 30 11:10:10 linus-xfs-crc kernel: RAX: 0000000000000000 RBX: ffff888100c307a8 RCX: 0000000000000000
May 30 11:10:10 linus-xfs-crc kernel: RDX: 0000000000000103 RSI: 0000000000000004 RDI: 0000000000000001
May 30 11:10:10 linus-xfs-crc kernel: RBP: ffff888154209e48 R08: 0000000000000000 R09: fffffbfff58d8e58
May 30 11:10:10 linus-xfs-crc kernel: R10: 0000000000000003 R11: ffffffffac72cb50 R12: ffff888131eeb450
May 30 11:10:10 linus-xfs-crc kernel: R13: ffffea0004030c00 R14: 0000000000000188 R15: ffff888101071400
May 30 11:10:10 linus-xfs-crc kernel: FS:  00007fd944a508c0(0000) GS:ffff888154200000(0000) knlGS:0000000000000000
May 30 11:10:10 linus-xfs-crc kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 30 11:10:10 linus-xfs-crc kernel: CR2: 00007fd945236218 CR3: 000000012f7b2005 CR4: 0000000000770ef0
May 30 11:10:10 linus-xfs-crc kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 30 11:10:10 linus-xfs-crc kernel: DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
May 30 11:10:10 linus-xfs-crc kernel: PKRU: 55555554
May 30 11:10:10 linus-xfs-crc kernel: Call Trace:
May 30 11:10:10 linus-xfs-crc kernel:  <IRQ>
May 30 11:10:10 linus-xfs-crc kernel:  ? __warn+0xc8/0x2c0
May 30 11:10:10 linus-xfs-crc kernel:  ? kmem_cache_free+0x55e/0x5d0
May 30 11:10:10 linus-xfs-crc kernel:  ? report_bug+0x2e6/0x390
May 30 11:10:10 linus-xfs-crc kernel:  ? handle_bug+0x79/0xa0
May 30 11:10:10 linus-xfs-crc kernel:  ? exc_invalid_op+0x13/0x40
May 30 11:10:10 linus-xfs-crc kernel:  ? asm_exc_invalid_op+0x16/0x20
May 30 11:10:10 linus-xfs-crc kernel:  ? kmem_cache_free+0x55e/0x5d0
May 30 11:10:10 linus-xfs-crc kernel:  ? rcu_core+0x848/0x1b50
May 30 11:10:10 linus-xfs-crc kernel:  ? rcu_core+0x846/0x1b50
May 30 11:10:10 linus-xfs-crc kernel:  rcu_core+0x848/0x1b50
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx_rcu_core+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  ? ktime_get+0x6b/0x140
May 30 11:10:10 linus-xfs-crc kernel:  handle_softirqs+0x278/0x870
May 30 11:10:10 linus-xfs-crc kernel:  __irq_exit_rcu+0xa1/0x100
May 30 11:10:10 linus-xfs-crc kernel:  irq_exit_rcu+0xa/0x30
May 30 11:10:10 linus-xfs-crc kernel:  sysvec_apic_timer_interrupt+0x8f/0xb0
May 30 11:10:10 linus-xfs-crc kernel:  </IRQ>
May 30 11:10:10 linus-xfs-crc kernel:  <TASK>
May 30 11:10:10 linus-xfs-crc kernel:  asm_sysvec_apic_timer_interrupt+0x16/0x20
May 30 11:10:10 linus-xfs-crc kernel: RIP: 0010:__orc_find+0x65/0xf0
May 30 11:10:10 linus-xfs-crc kernel: Code: 89 ff 48 89 fd eb 0c 48 8d 6b 04 49 89 df 49 39 ec 72 4e 4c 89 e2 48 29 ea 48 89 d6 48 c1 ea 3f 48 c1 fe 02 48 01 f2 48 d1 fa <48> 8d 5c 95 00 48 89 da 48 c1 ea 03 0f b6 34 0a 48 89 da 83 e2 07
May 30 11:10:10 linus-xfs-crc kernel: RSP: 0018:ffff888164137998 EFLAGS: 00000203
May 30 11:10:10 linus-xfs-crc kernel: RAX: ffffffffad121f38 RBX: fffffffface8f200 RCX: dffffc0000000000
May 30 11:10:10 linus-xfs-crc kernel: RDX: 0000000000000001 RSI: 0000000000000003 RDI: fffffffface8f1f0
May 30 11:10:10 linus-xfs-crc kernel: RBP: fffffffface8f1f0 R08: ffffffffad121f6e R09: ffffffffad121662
May 30 11:10:10 linus-xfs-crc kernel: R10: ffffffffad121666 R11: 0000000000000001 R12: fffffffface8f1fc
May 30 11:10:10 linus-xfs-crc kernel: R13: ffffffffaa090b7d R14: fffffffface8f1f0 R15: fffffffface8f1f0
May 30 11:10:10 linus-xfs-crc kernel:  ? __kasan_record_aux_stack+0x8d/0xa0
May 30 11:10:10 linus-xfs-crc kernel:  unwind_next_frame+0x16f/0x1fb0
May 30 11:10:10 linus-xfs-crc kernel:  ? __kasan_record_aux_stack+0x8e/0xa0
May 30 11:10:10 linus-xfs-crc kernel:  ? __kasan_record_aux_stack+0x8e/0xa0
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx_stack_trace_consume_entry+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  arch_stack_walk+0x88/0xf0
May 30 11:10:10 linus-xfs-crc kernel:  ? __kasan_record_aux_stack+0x8e/0xa0
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx_free_object_rcu+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  stack_trace_save+0x90/0xd0
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx_stack_trace_save+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  kasan_save_stack+0x1c/0x40
May 30 11:10:10 linus-xfs-crc kernel:  ? kasan_save_stack+0x1c/0x40
May 30 11:10:10 linus-xfs-crc kernel:  ? __kasan_record_aux_stack+0x8e/0xa0
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx___lock_acquire+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx___lock_acquire+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  ? find_held_lock+0x34/0x120
May 30 11:10:10 linus-xfs-crc kernel:  ? kvm_sched_clock_read+0xd/0x20
May 30 11:10:10 linus-xfs-crc kernel:  ? local_clock_noinstr+0x9/0xc0
May 30 11:10:10 linus-xfs-crc kernel:  ? lock_release+0x3ad/0xbb0
May 30 11:10:10 linus-xfs-crc kernel:  ? lock_acquire+0x1a5/0x510
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx_lock_release+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  ? kvm_sched_clock_read+0xd/0x20
May 30 11:10:10 linus-xfs-crc kernel:  ? local_clock_noinstr+0x9/0xc0
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx_free_object_rcu+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  ? __virt_addr_valid+0x1f1/0x3d0
May 30 11:10:10 linus-xfs-crc kernel:  __kasan_record_aux_stack+0x8e/0xa0
May 30 11:10:10 linus-xfs-crc kernel:  __call_rcu_common.constprop.0+0x70/0x640
May 30 11:10:10 linus-xfs-crc kernel:  kmem_cache_free+0x3b8/0x5d0
May 30 11:10:10 linus-xfs-crc kernel:  ? do_symlinkat+0x142/0x280
May 30 11:10:10 linus-xfs-crc kernel:  do_symlinkat+0x142/0x280
May 30 11:10:10 linus-xfs-crc kernel:  ? __pfx_do_symlinkat+0x10/0x10
May 30 11:10:10 linus-xfs-crc kernel:  ? getname_flags.part.0+0x171/0x670
May 30 11:10:10 linus-xfs-crc kernel:  __x64_sys_symlinkat+0x93/0xc0
May 30 11:10:10 linus-xfs-crc kernel:  do_syscall_64+0x69/0x140
May 30 11:10:10 linus-xfs-crc kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
May 30 11:10:10 linus-xfs-crc kernel: RIP: 0033:0x7fd945155977
May 30 11:10:10 linus-xfs-crc kernel: Code: 73 01 c3 48 8b 0d 89 84 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0a 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 59 84 0d 00 f7 d8 64 89 01 48
May 30 11:10:10 linus-xfs-crc kernel: RSP: 002b:00007ffce0b82588 EFLAGS: 00000246 ORIG_RAX: 000000000000010a
May 30 11:10:10 linus-xfs-crc kernel: RAX: ffffffffffffffda RBX: 000055f6941f9db0 RCX: 00007fd945155977
May 30 11:10:10 linus-xfs-crc kernel: RDX: 000055f6941d7970 RSI: 00000000ffffff9c RDI: 000055f6941f7c60
May 30 11:10:10 linus-xfs-crc kernel: RBP: 000055f6941f8180 R08: 0000000000000007 R09: 000055f6941f8150
May 30 11:10:10 linus-xfs-crc kernel: R10: e688f42cc1051205 R11: 0000000000000246 R12: 000055f6941d7970
May 30 11:10:10 linus-xfs-crc kernel: R13: 00007ffce0b825d8 R14: 000055f6941f7c60 R15: 0000000000000000
May 30 11:10:10 linus-xfs-crc kernel:  </TASK>
May 30 11:10:10 linus-xfs-crc kernel: irq event stamp: 22040
May 30 11:10:10 linus-xfs-crc kernel: hardirqs last  enabled at (22050): [<ffffffffa995ecc5>] console_unlock+0x1d5/0x250
May 30 11:10:10 linus-xfs-crc kernel: hardirqs last disabled at (22059): [<ffffffffa995ecaa>] console_unlock+0x1ba/0x250
May 30 11:10:10 linus-xfs-crc kernel: softirqs last  enabled at (20632): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 11:10:10 linus-xfs-crc kernel: softirqs last disabled at (20941): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 11:10:10 linus-xfs-crc kernel: ---[ end trace 0000000000000000 ]---
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio3: 8/0/0 default/read/poll queues
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio3: [vda] 41943040 512-byte logical blocks (21.5 GB/20.0 GiB)
May 30 11:10:10 linus-xfs-crc kernel:  vda: vda1
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio6: 8/0/0 default/read/poll queues
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio6: [vdb] 209715200 512-byte logical blocks (107 GB/100 GiB)
May 30 11:10:10 linus-xfs-crc kernel: virtio_net virtio1 enp1s0: renamed from eth0
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio7: 8/0/0 default/read/poll queues
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio7: [vdc] 209715200 512-byte logical blocks (107 GB/100 GiB)
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio8: 8/0/0 default/read/poll queues
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio8: [vdd] 209715200 512-byte logical blocks (107 GB/100 GiB)
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio9: 8/0/0 default/read/poll queues
May 30 11:10:10 linus-xfs-crc kernel: virtio_blk virtio9: [vde] 209715200 512-byte logical blocks (107 GB/100 GiB)
May 30 11:10:10 linus-xfs-crc kernel: raid6: avx512x4 gen() 17009 MB/s
May 30 11:10:10 linus-xfs-crc kernel: raid6: avx512x2 gen() 13107 MB/s
May 30 11:10:10 linus-xfs-crc kernel: raid6: avx512x1 gen() 12548 MB/s
May 30 11:10:10 linus-xfs-crc kernel: raid6: avx2x4   gen() 15927 MB/s
May 30 11:10:10 linus-xfs-crc kernel: raid6: avx2x2   gen() 16027 MB/s
May 30 11:10:10 linus-xfs-crc kernel: raid6: avx2x1   gen() 12260 MB/s
May 30 11:10:10 linus-xfs-crc kernel: raid6: using algorithm avx512x4 gen() 17009 MB/s
May 30 11:10:10 linus-xfs-crc kernel: raid6: .... xor() 4125 MB/s, rmw enabled
May 30 11:10:10 linus-xfs-crc kernel: raid6: using avx512x2 recovery algorithm
May 30 11:10:10 linus-xfs-crc kernel: xor: automatically using best checksumming function   avx       
May 30 11:10:10 linus-xfs-crc kernel: async_tx: api initialized (async)
May 30 11:10:10 linus-xfs-crc kernel: Btrfs loaded, zoned=yes, fsverity=no
May 30 11:10:10 linus-xfs-crc kernel: EXT4-fs (vda1): mounted filesystem ddf91058-656c-4606-806a-8a4a9d31676c ro with ordered data mode. Quota mode: none.
May 30 11:10:10 linus-xfs-crc kernel: Not activating Mandatory Access Control as /sbin/tomoyo-init does not exist.
May 30 11:10:10 linus-xfs-crc systemd[1]: Inserted module 'autofs4'
May 30 11:10:10 linus-xfs-crc systemd[1]: systemd 252.22-1~deb12u1 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -BPF_FRAMEWORK -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
May 30 11:10:10 linus-xfs-crc systemd[1]: Detected virtualization kvm.
May 30 11:10:10 linus-xfs-crc systemd[1]: Detected architecture x86-64.
May 30 11:10:10 linus-xfs-crc systemd[1]: Hostname set to <linus-xfs-crc>.
May 30 11:10:10 linus-xfs-crc systemd[1]: /lib/systemd/system/systemd-journal-upload.service:30: Unknown key name 'RestartSteps' in section 'Service', ignoring.
May 30 11:10:10 linus-xfs-crc systemd[1]: /lib/systemd/system/systemd-journal-upload.service:31: Unknown key name 'RestartMaxDelaySec' in section 'Service', ignoring.
May 30 11:10:10 linus-xfs-crc systemd[1]: Queued start job for default target graphical.target.
May 30 11:10:10 linus-xfs-crc systemd[1]: Created slice system-getty.slice - Slice /system/getty.
May 30 11:10:10 linus-xfs-crc systemd[1]: Created slice system-modprobe.slice - Slice /system/modprobe.
May 30 11:10:10 linus-xfs-crc systemd[1]: Created slice system-serial\x2dgetty.slice - Slice /system/serial-getty.
May 30 11:10:10 linus-xfs-crc systemd[1]: Created slice user.slice - User and Session Slice.
May 30 11:10:10 linus-xfs-crc systemd[1]: Started systemd-ask-password-console.path - Dispatch Password Requests to Console Directory Watch.
May 30 11:10:10 linus-xfs-crc systemd[1]: Started systemd-ask-password-wall.path - Forward Password Requests to Wall Directory Watch.
May 30 11:10:10 linus-xfs-crc systemd[1]: proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats File System Automount Point was skipped because of an unmet condition check (ConditionPathExists=/proc/sys/fs/binfmt_misc).
May 30 11:10:10 linus-xfs-crc systemd[1]: Expecting device dev-disk-by\x2dlabel-data.device - /dev/disk/by-label/data...
May 30 11:10:10 linus-xfs-crc systemd[1]: Expecting device dev-disk-by\x2dlabel-sparsefiles.device - /dev/disk/by-label/sparsefiles...
May 30 11:10:10 linus-xfs-crc systemd[1]: Expecting device dev-ttyS0.device - /dev/ttyS0...
May 30 11:10:10 linus-xfs-crc systemd[1]: Reached target cryptsetup.target - Local Encrypted Volumes.
May 30 11:10:10 linus-xfs-crc systemd[1]: Reached target integritysetup.target - Local Integrity Protected Volumes.
May 30 11:10:10 linus-xfs-crc systemd[1]: Reached target paths.target - Path Units.
May 30 11:10:10 linus-xfs-crc systemd[1]: Reached target slices.target - Slice Units.
May 30 11:10:10 linus-xfs-crc systemd[1]: Reached target swap.target - Swaps.
May 30 11:10:10 linus-xfs-crc systemd[1]: Reached target veritysetup.target - Local Verity Protected Volumes.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on dm-event.socket - Device-mapper event daemon FIFOs.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on lvm2-lvmpolld.socket - LVM2 poll daemon socket.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on rpcbind.socket - RPCbind Server Activation Socket.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on systemd-fsckd.socket - fsck to fsckd communication Socket.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on systemd-initctl.socket - initctl Compatibility Named Pipe.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on systemd-journald-audit.socket - Journal Audit Socket.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on systemd-journald-dev-log.socket - Journal Socket (/dev/log).
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on systemd-journald.socket - Journal Socket.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on systemd-udevd-control.socket - udev Control Socket.
May 30 11:10:10 linus-xfs-crc systemd[1]: Listening on systemd-udevd-kernel.socket - udev Kernel Socket.
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounting dev-hugepages.mount - Huge Pages File System...
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounting dev-mqueue.mount - POSIX Message Queue File System...
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounting sys-kernel-debug.mount - Kernel Debug File System...
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounting sys-kernel-tracing.mount - Kernel Trace File System...
May 30 11:10:10 linus-xfs-crc systemd[1]: auth-rpcgss-module.service - Kernel Module supporting RPCSEC_GSS was skipped because of an unmet condition check (ConditionPathExists=/etc/krb5.keytab).
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting keyboard-setup.service - Set the console keyboard layout...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting kmod-static-nodes.service - Create List of Static Device Nodes...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting lvm2-monitor.service - Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting modprobe@configfs.service - Load Kernel Module configfs...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting modprobe@dm_mod.service - Load Kernel Module dm_mod...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting modprobe@drm.service - Load Kernel Module drm...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting modprobe@efi_pstore.service - Load Kernel Module efi_pstore...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting modprobe@fuse.service - Load Kernel Module fuse...
May 30 11:10:10 linus-xfs-crc kernel: device-mapper: uevent: version 1.0.3
May 30 11:10:10 linus-xfs-crc kernel: device-mapper: ioctl: 4.48.0-ioctl (2023-03-01) initialised: dm-devel@lists.linux.dev
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting modprobe@loop.service - Load Kernel Module loop...
May 30 11:10:10 linus-xfs-crc systemd[1]: systemd-fsck-root.service - File System Check on Root Device was skipped because of an unmet condition check (ConditionPathExists=!/run/initramfs/fsck-root).
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-journald.service - Journal Service...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-modules-load.service - Load Kernel Modules...
May 30 11:10:10 linus-xfs-crc kernel: ACPI: bus type drm_connector registered
May 30 11:10:10 linus-xfs-crc kernel: loop: module loaded
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-remount-fs.service - Remount Root and Kernel File Systems...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-udev-trigger.service - Coldplug All udev Devices...
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounted dev-hugepages.mount - Huge Pages File System.
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounted dev-mqueue.mount - POSIX Message Queue File System.
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounted sys-kernel-debug.mount - Kernel Debug File System.
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounted sys-kernel-tracing.mount - Kernel Trace File System.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished kmod-static-nodes.service - Create List of Static Device Nodes.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished lvm2-monitor.service - Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling.
May 30 11:10:10 linus-xfs-crc systemd[1]: modprobe@configfs.service: Deactivated successfully.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished modprobe@configfs.service - Load Kernel Module configfs.
May 30 11:10:10 linus-xfs-crc systemd[1]: modprobe@dm_mod.service: Deactivated successfully.
May 30 11:10:10 linus-xfs-crc kernel: EXT4-fs (vda1): re-mounted ddf91058-656c-4606-806a-8a4a9d31676c r/w. Quota mode: none.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished modprobe@dm_mod.service - Load Kernel Module dm_mod.
May 30 11:10:10 linus-xfs-crc systemd[1]: modprobe@drm.service: Deactivated successfully.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished modprobe@drm.service - Load Kernel Module drm.
May 30 11:10:10 linus-xfs-crc systemd[1]: modprobe@efi_pstore.service: Deactivated successfully.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished modprobe@efi_pstore.service - Load Kernel Module efi_pstore.
May 30 11:10:10 linus-xfs-crc systemd[1]: modprobe@fuse.service: Deactivated successfully.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished modprobe@fuse.service - Load Kernel Module fuse.
May 30 11:10:10 linus-xfs-crc systemd[1]: modprobe@loop.service: Deactivated successfully.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished modprobe@loop.service - Load Kernel Module loop.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished systemd-modules-load.service - Load Kernel Modules.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished systemd-remount-fs.service - Remount Root and Kernel File Systems.
May 30 11:10:10 linus-xfs-crc systemd[1]: sys-fs-fuse-connections.mount - FUSE Control File System was skipped because of an unmet condition check (ConditionPathExists=/sys/fs/fuse/connections).
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounting sys-kernel-config.mount - Kernel Configuration File System...
May 30 11:10:10 linus-xfs-crc systemd[1]: systemd-firstboot.service - First Boot Wizard was skipped because of an unmet condition check (ConditionFirstBoot=yes).
May 30 11:10:10 linus-xfs-crc systemd[1]: systemd-pstore.service - Platform Persistent Storage Archival was skipped because of an unmet condition check (ConditionDirectoryNotEmpty=/sys/fs/pstore).
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-random-seed.service - Load/Save Random Seed...
May 30 11:10:10 linus-xfs-crc systemd[1]: systemd-repart.service - Repartition Root Disk was skipped because no trigger condition checks were met.
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-sysctl.service - Apply Kernel Variables...
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-sysusers.service - Create System Users...
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished keyboard-setup.service - Set the console keyboard layout.
May 30 11:10:10 linus-xfs-crc systemd[1]: Mounted sys-kernel-config.mount - Kernel Configuration File System.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished systemd-random-seed.service - Load/Save Random Seed.
May 30 11:10:10 linus-xfs-crc systemd[1]: first-boot-complete.target - First Boot Complete was skipped because of an unmet condition check (ConditionFirstBoot=yes).
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished systemd-sysctl.service - Apply Kernel Variables.
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished systemd-sysusers.service - Create System Users.
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-tmpfiles-setup-dev.service - Create Static Device Nodes in /dev...
May 30 11:10:10 linus-xfs-crc systemd[1]: Finished systemd-tmpfiles-setup-dev.service - Create Static Device Nodes in /dev.
May 30 11:10:10 linus-xfs-crc systemd[1]: Reached target local-fs-pre.target - Preparation for Local File Systems.
May 30 11:10:10 linus-xfs-crc systemd[1]: Starting systemd-udevd.service - Rule-based Manager for Device Events and Files...
May 30 11:10:10 linus-xfs-crc systemd[1]: Started systemd-journald.service - Journal Service.
May 30 11:10:10 linus-xfs-crc systemd-journald[333]: Received client request to flush runtime journal.
May 30 11:10:11 linus-xfs-crc kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
May 30 11:10:11 linus-xfs-crc kernel: ACPI: button: Power Button [PWRF]
May 30 11:10:11 linus-xfs-crc kernel: BTRFS: device label data devid 1 transid 2921 /dev/vdb (254:16) scanned by mount (404)
May 30 11:10:11 linus-xfs-crc kernel: BTRFS info (device vdb): first mount of filesystem bde281fd-85b6-4fad-b99d-ad2d99cb13a6
May 30 11:10:11 linus-xfs-crc kernel: BTRFS info (device vdb): using crc32c (crc32c-intel) checksum algorithm
May 30 11:10:11 linus-xfs-crc kernel: BTRFS info (device vdb): using free-space-tree
May 30 11:10:11 linus-xfs-crc kernel: BTRFS: device label sparsefiles devid 1 transid 39271 /dev/vdc (254:32) scanned by mount (405)
May 30 11:10:11 linus-xfs-crc kernel: BTRFS info (device vdc): first mount of filesystem d6a42570-6d78-4d2d-a054-2c560f446fcf
May 30 11:10:11 linus-xfs-crc kernel: BTRFS info (device vdc): using crc32c (crc32c-intel) checksum algorithm
May 30 11:10:11 linus-xfs-crc kernel: BTRFS info (device vdc): using free-space-tree
May 30 11:10:11 linus-xfs-crc kernel: cryptd: max_cpu_qlen set to 1000
May 30 11:10:11 linus-xfs-crc kernel: input: PC Speaker as /devices/platform/pcspkr/input/input5
May 30 11:10:11 linus-xfs-crc kernel: AVX2 version of gcm_enc/dec engaged.
May 30 11:10:11 linus-xfs-crc kernel: AES CTR mode by8 optimization enabled
May 30 11:10:11 linus-xfs-crc kernel: 9p: Installing v9fs 9p2000 file system support
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.948:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="lsb_release" pid=535 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.952:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/man" pid=538 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.952:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="man_filter" pid=538 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.952:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="man_groff" pid=538 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.960:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="nvidia_modprobe" pid=536 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.960:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="nvidia_modprobe//kmod" pid=536 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.980:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=537 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.980:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=537 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.980:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=537 comm="apparmor_parser"
May 30 11:10:11 linus-xfs-crc kernel: audit: type=1400 audit(1717092611.980:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/{,usr/}sbin/dhclient" pid=537 comm="apparmor_parser"
May 30 11:10:12 linus-xfs-crc kernel: RPC: Registered named UNIX socket transport module.
May 30 11:10:12 linus-xfs-crc kernel: RPC: Registered udp transport module.
May 30 11:10:12 linus-xfs-crc kernel: RPC: Registered tcp transport module.
May 30 11:10:12 linus-xfs-crc kernel: RPC: Registered tcp-with-tls transport module.
May 30 11:10:12 linus-xfs-crc kernel: RPC: Registered tcp NFSv4.1 backchannel transport module.
May 30 14:07:06 linus-xfs-crc kernel: loop5: detected capacity change from 0 to 41943040
May 30 14:07:07 linus-xfs-crc kernel: loop6: detected capacity change from 0 to 41943040
May 30 14:07:07 linus-xfs-crc kernel: loop7: detected capacity change from 0 to 41943040
May 30 14:07:07 linus-xfs-crc kernel: loop8: detected capacity change from 0 to 41943040
May 30 14:07:08 linus-xfs-crc kernel: loop9: detected capacity change from 0 to 41943040
May 30 14:07:08 linus-xfs-crc kernel: loop10: detected capacity change from 0 to 41943040
May 30 14:07:09 linus-xfs-crc kernel: loop11: detected capacity change from 0 to 41943040
May 30 14:07:09 linus-xfs-crc kernel: loop12: detected capacity change from 0 to 41943040
May 30 14:07:09 linus-xfs-crc kernel: loop13: detected capacity change from 0 to 41943040
May 30 14:07:10 linus-xfs-crc kernel: loop14: detected capacity change from 0 to 41943040
May 30 14:07:10 linus-xfs-crc kernel: loop15: detected capacity change from 0 to 41943040
May 30 14:07:11 linus-xfs-crc kernel: loop16: detected capacity change from 0 to 41943040
May 30 14:07:17 linus-xfs-crc kernel: SGI XFS with ACLs, security attributes, realtime, scrub, repair, quota, fatal assert, debug enabled
May 30 14:07:18 linus-xfs-crc kernel: XFS (loop16): Mounting V5 Filesystem 8cda7946-0b21-4efb-94eb-0b3ab0e14ee0
May 30 14:07:18 linus-xfs-crc kernel: XFS (loop16): Ending clean mount
May 30 14:07:25 linus-xfs-crc kernel: XFS (loop16): Unmounting Filesystem 8cda7946-0b21-4efb-94eb-0b3ab0e14ee0
May 30 14:07:26 linus-xfs-crc kernel: XFS (loop16): Mounting V5 Filesystem 7c609e30-4cb1-42f8-85c6-f57f3f0e5201
May 30 14:07:26 linus-xfs-crc kernel: XFS (loop16): Ending clean mount
May 30 14:07:31 linus-xfs-crc kernel: XFS (loop5): Mounting V5 Filesystem dd4d286b-7a37-4ec7-b64a-05171bf52b2c
May 30 14:07:31 linus-xfs-crc kernel: XFS (loop5): Ending clean mount
May 30 14:07:31 linus-xfs-crc kernel: XFS (loop5): Unmounting Filesystem dd4d286b-7a37-4ec7-b64a-05171bf52b2c
May 30 14:07:31 linus-xfs-crc kernel: XFS (loop16): EXPERIMENTAL online scrub feature in use. Use at your own risk!
May 30 14:07:32 linus-xfs-crc kernel: XFS (loop16): Unmounting Filesystem 7c609e30-4cb1-42f8-85c6-f57f3f0e5201
May 30 14:07:33 linus-xfs-crc kernel: XFS (loop16): Mounting V5 Filesystem 7c609e30-4cb1-42f8-85c6-f57f3f0e5201
May 30 14:07:33 linus-xfs-crc kernel: XFS (loop16): Ending clean mount
May 30 14:07:33 linus-xfs-crc unknown: run fstests generic/531 at 2024-05-30 14:07:33
May 30 14:07:39 linus-xfs-crc kernel: XFS (loop5): Mounting V5 Filesystem 63d9d33b-e75d-4d35-be76-6df47036ee3a
May 30 14:07:39 linus-xfs-crc kernel: XFS (loop5): Ending clean mount
May 30 14:07:43 linus-xfs-crc kernel: ------------[ cut here ]------------
May 30 14:07:43 linus-xfs-crc kernel: alloc_tag was not set
May 30 14:07:43 linus-xfs-crc kernel: WARNING: CPU: 5 PID: 2338 at include/linux/alloc_tag.h:130 kmem_cache_free+0x55e/0x5d0
May 30 14:07:43 linus-xfs-crc kernel: Modules linked in: xfs nvme_fabrics nvme_core t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 kvm_intel sunrpc kvm crct10dif_pclmul ghash_clmulni_intel sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 9p aesni_intel crypto_simd cryptd pcspkr 9pnet_virtio virtio_balloon virtio_console joydev evdev button serio_raw drm loop dm_mod autofs4 ext4 crc16 mbcache jbd2 btrfs blake2b_generic efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 md_mod virtio_net net_failover failover virtio_blk dimlib crc32_pclmul crc32c_intel psmouse virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring
May 30 14:07:43 linus-xfs-crc kernel: CPU: 5 PID: 2338 Comm: t_open_tmpfiles Tainted: G        W          6.10.0-rc1 #3
May 30 14:07:43 linus-xfs-crc kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
May 30 14:07:43 linus-xfs-crc kernel: RIP: 0010:kmem_cache_free+0x55e/0x5d0
May 30 14:07:43 linus-xfs-crc kernel: Code: 48 8b 5c 24 10 e9 1e fc ff ff 80 3d f7 e2 d4 02 00 0f 85 11 fc ff ff 48 c7 c7 1c 90 48 ac c6 05 e3 e2 d4 02 01 e8 d2 7e 79 ff <0f> 0b 49 8b 44 24 08 48 85 c0 75 a4 e9 e8 fb ff ff 48 c7 c6 40 af
May 30 14:07:43 linus-xfs-crc kernel: RSP: 0018:ffff888132cdfd70 EFLAGS: 00010282
May 30 14:07:43 linus-xfs-crc kernel: RAX: 0000000000000000 RBX: ffff8881193f3300 RCX: 0000000000000000
May 30 14:07:43 linus-xfs-crc kernel: RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000001
May 30 14:07:43 linus-xfs-crc kernel: RBP: ffff888132cdfdb8 R08: 0000000000000001 R09: ffffed102aa7d729
May 30 14:07:43 linus-xfs-crc kernel: R10: ffff8881553eb94b R11: ffffffffac72cb50 R12: ffff88810fb28a30
May 30 14:07:43 linus-xfs-crc kernel: R13: ffffea000464fc00 R14: 0000000000001100 R15: ffff888101071680
May 30 14:07:43 linus-xfs-crc kernel: FS:  00007f55f960e740(0000) GS:ffff888155200000(0000) knlGS:0000000000000000
May 30 14:07:43 linus-xfs-crc kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 30 14:07:43 linus-xfs-crc kernel: CR2: 00007ffe0b954ff8 CR3: 000000012fbb8001 CR4: 0000000000770ef0
May 30 14:07:43 linus-xfs-crc kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 30 14:07:43 linus-xfs-crc kernel: DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
May 30 14:07:43 linus-xfs-crc kernel: PKRU: 55555554
May 30 14:07:43 linus-xfs-crc kernel: Call Trace:
May 30 14:07:43 linus-xfs-crc kernel:  <TASK>
May 30 14:07:43 linus-xfs-crc kernel:  ? __warn+0xc8/0x2c0
May 30 14:07:43 linus-xfs-crc kernel:  ? kmem_cache_free+0x55e/0x5d0
May 30 14:07:43 linus-xfs-crc kernel:  ? report_bug+0x2e6/0x390
May 30 14:07:43 linus-xfs-crc kernel:  ? handle_bug+0x79/0xa0
May 30 14:07:43 linus-xfs-crc kernel:  ? exc_invalid_op+0x13/0x40
May 30 14:07:43 linus-xfs-crc kernel:  ? asm_exc_invalid_op+0x16/0x20
May 30 14:07:43 linus-xfs-crc kernel:  ? kmem_cache_free+0x55e/0x5d0
May 30 14:07:43 linus-xfs-crc kernel:  ? do_sys_openat2+0x106/0x160
May 30 14:07:43 linus-xfs-crc kernel:  do_sys_openat2+0x106/0x160
May 30 14:07:43 linus-xfs-crc kernel:  ? __pfx_do_sys_openat2+0x10/0x10
May 30 14:07:43 linus-xfs-crc kernel:  __x64_sys_openat+0x11f/0x1d0
May 30 14:07:43 linus-xfs-crc kernel:  ? xfd_validate_state+0x24/0x130
May 30 14:07:43 linus-xfs-crc kernel:  ? __pfx___x64_sys_openat+0x10/0x10
May 30 14:07:43 linus-xfs-crc kernel:  ? do_syscall_64+0x2a/0x140
May 30 14:07:43 linus-xfs-crc kernel:  do_syscall_64+0x69/0x140
May 30 14:07:43 linus-xfs-crc kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
May 30 14:07:43 linus-xfs-crc kernel: RIP: 0033:0x7f55f9708f01
May 30 14:07:43 linus-xfs-crc kernel: Code: 75 57 89 f0 25 00 00 41 00 3d 00 00 41 00 74 49 80 3d ea 26 0e 00 00 74 6d 89 da 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 93 00 00 00 48 8b 54 24 28 64 48 2b 14 25
May 30 14:07:43 linus-xfs-crc kernel: RSP: 002b:00007ffc903ce6f0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
May 30 14:07:43 linus-xfs-crc kernel: RAX: ffffffffffffffda RBX: 0000000000410002 RCX: 00007f55f9708f01
May 30 14:07:43 linus-xfs-crc kernel: RDX: 0000000000410002 RSI: 000055ed78e83057 RDI: 00000000ffffff9c
May 30 14:07:43 linus-xfs-crc kernel: RBP: 000055ed78e83057 R08: 00022878ad3152b2 R09: 00007f55f9805680
May 30 14:07:43 linus-xfs-crc kernel: R10: 00000000000001a4 R11: 0000000000000202 R12: 0000000000000000
May 30 14:07:43 linus-xfs-crc kernel: R13: 00007ffc903ce8d0 R14: 000055ed78e84dd8 R15: 00007f55f9833020
May 30 14:07:43 linus-xfs-crc kernel:  </TASK>
May 30 14:07:43 linus-xfs-crc kernel: irq event stamp: 383493
May 30 14:07:43 linus-xfs-crc kernel: hardirqs last  enabled at (383503): [<ffffffffa995ecc5>] console_unlock+0x1d5/0x250
May 30 14:07:43 linus-xfs-crc kernel: hardirqs last disabled at (383540): [<ffffffffa995ecaa>] console_unlock+0x1ba/0x250
May 30 14:07:43 linus-xfs-crc kernel: softirqs last  enabled at (383536): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 14:07:43 linus-xfs-crc kernel: softirqs last disabled at (383511): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 14:07:43 linus-xfs-crc kernel: ---[ end trace 0000000000000000 ]---
May 30 14:08:11 linus-xfs-crc kernel: ------------[ cut here ]------------
May 30 14:08:11 linus-xfs-crc kernel: current->alloc_tag not set
May 30 14:08:11 linus-xfs-crc kernel: WARNING: CPU: 4 PID: 80 at include/linux/alloc_tag.h:125 post_alloc_hook+0x423/0x560
May 30 14:08:11 linus-xfs-crc kernel: Modules linked in: xfs nvme_fabrics nvme_core t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 kvm_intel sunrpc kvm crct10dif_pclmul ghash_clmulni_intel sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 9p aesni_intel crypto_simd cryptd pcspkr 9pnet_virtio virtio_balloon virtio_console joydev evdev button serio_raw drm loop dm_mod autofs4 ext4 crc16 mbcache jbd2 btrfs blake2b_generic efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 md_mod virtio_net net_failover failover virtio_blk dimlib crc32_pclmul crc32c_intel psmouse virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring
May 30 14:08:11 linus-xfs-crc kernel: CPU: 4 PID: 80 Comm: kcompactd0 Tainted: G        W          6.10.0-rc1 #3
May 30 14:08:11 linus-xfs-crc kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
May 30 14:08:11 linus-xfs-crc kernel: RIP: 0010:post_alloc_hook+0x423/0x560
May 30 14:08:11 linus-xfs-crc kernel: Code: e8 52 e6 0a 00 e9 ce fc ff ff 80 3d f5 ee d6 02 00 0f 85 67 ff ff ff 48 c7 c7 a0 77 d7 ab c6 05 e1 ee d6 02 01 e8 dd 8a 7b ff <0f> 0b e9 4d ff ff ff 49 8d 7d 04 c6 05 cb ee d6 02 01 48 b8 00 00
May 30 14:08:11 linus-xfs-crc kernel: RSP: 0018:ffff8881023e7968 EFLAGS: 00010296
May 30 14:08:11 linus-xfs-crc kernel: RAX: 0000000000000000 RBX: ffff8881006bf180 RCX: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000001
May 30 14:08:11 linus-xfs-crc kernel: RBP: 0000000000010000 R08: 0000000000000001 R09: ffffed102a9fd729
May 30 14:08:11 linus-xfs-crc kernel: R10: ffff888154feb94b R11: ffffffffac72cb50 R12: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: R13: 0000000000000000 R14: ffffffffaca707a0 R15: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: FS:  0000000000000000(0000) GS:ffff888154e00000(0000) knlGS:0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 30 14:08:11 linus-xfs-crc kernel: CR2: 000055bb2cbf3014 CR3: 0000000129ab6003 CR4: 0000000000770ef0
May 30 14:08:11 linus-xfs-crc kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
May 30 14:08:11 linus-xfs-crc kernel: PKRU: 55555554
May 30 14:08:11 linus-xfs-crc kernel: Call Trace:
May 30 14:08:11 linus-xfs-crc kernel:  <TASK>
May 30 14:08:11 linus-xfs-crc kernel:  ? __warn+0xc8/0x2c0
May 30 14:08:11 linus-xfs-crc kernel:  ? post_alloc_hook+0x423/0x560
May 30 14:08:11 linus-xfs-crc kernel:  ? report_bug+0x2e6/0x390
May 30 14:08:11 linus-xfs-crc kernel:  ? handle_bug+0x79/0xa0
May 30 14:08:11 linus-xfs-crc kernel:  ? exc_invalid_op+0x13/0x40
May 30 14:08:11 linus-xfs-crc kernel:  ? asm_exc_invalid_op+0x16/0x20
May 30 14:08:11 linus-xfs-crc kernel:  ? post_alloc_hook+0x423/0x560
May 30 14:08:11 linus-xfs-crc kernel:  ? post_alloc_hook+0x423/0x560
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_isolate_migratepages_block+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  release_free_list+0x12a/0x300
May 30 14:08:11 linus-xfs-crc kernel:  compact_zone+0x1c29/0x37a0
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_compact_zone+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ? find_held_lock+0x34/0x120
May 30 14:08:11 linus-xfs-crc kernel:  ? kcompactd+0x2d3/0x9b0
May 30 14:08:11 linus-xfs-crc kernel:  ? kcompactd+0x2d3/0x9b0
May 30 14:08:11 linus-xfs-crc kernel:  ? lock_acquired+0x22d/0xa10
May 30 14:08:11 linus-xfs-crc kernel:  compact_node+0x14d/0x230
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_compact_node+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  kcompactd+0x5c3/0x9b0
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kcompactd+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ? lockdep_hardirqs_on+0x7c/0x100
May 30 14:08:11 linus-xfs-crc kernel:  ? __kthread_parkme+0x82/0x150
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kcompactd+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  kthread+0x2ad/0x380
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kthread+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ret_from_fork+0x2d/0x70
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kthread+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ret_from_fork_asm+0x1a/0x30
May 30 14:08:11 linus-xfs-crc kernel:  </TASK>
May 30 14:08:11 linus-xfs-crc kernel: irq event stamp: 313321
May 30 14:08:11 linus-xfs-crc kernel: hardirqs last  enabled at (313333): [<ffffffffa995ecc5>] console_unlock+0x1d5/0x250
May 30 14:08:11 linus-xfs-crc kernel: hardirqs last disabled at (313342): [<ffffffffa995ecaa>] console_unlock+0x1ba/0x250
May 30 14:08:11 linus-xfs-crc kernel: softirqs last  enabled at (313366): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 14:08:11 linus-xfs-crc kernel: softirqs last disabled at (313379): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 14:08:11 linus-xfs-crc kernel: ---[ end trace 0000000000000000 ]---
May 30 14:08:11 linus-xfs-crc kernel: ------------[ cut here ]------------
May 30 14:08:11 linus-xfs-crc kernel: alloc_tag was not set
May 30 14:08:11 linus-xfs-crc kernel: WARNING: CPU: 3 PID: 80 at include/linux/alloc_tag.h:130 __free_pages+0x2e0/0x430
May 30 14:08:11 linus-xfs-crc kernel: Modules linked in: xfs nvme_fabrics nvme_core t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 kvm_intel sunrpc kvm crct10dif_pclmul ghash_clmulni_intel sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 9p aesni_intel crypto_simd cryptd pcspkr 9pnet_virtio virtio_balloon virtio_console joydev evdev button serio_raw drm loop dm_mod autofs4 ext4 crc16 mbcache jbd2 btrfs blake2b_generic efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 md_mod virtio_net net_failover failover virtio_blk dimlib crc32_pclmul crc32c_intel psmouse virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring
May 30 14:08:11 linus-xfs-crc kernel: CPU: 3 PID: 80 Comm: kcompactd0 Tainted: G        W          6.10.0-rc1 #3
May 30 14:08:11 linus-xfs-crc kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
May 30 14:08:11 linus-xfs-crc kernel: RIP: 0010:__free_pages+0x2e0/0x430
May 30 14:08:11 linus-xfs-crc kernel: Code: 31 ed 45 31 e4 e9 39 fe ff ff 80 3d 57 b3 d6 02 00 0f 85 2c fe ff ff 48 c7 c7 40 75 d7 ab c6 05 43 b3 d6 02 01 e8 40 4f 7b ff <0f> 0b 48 89 ea 48 c7 c1 a0 07 a7 ac 48 b8 00 00 00 00 00 fc ff df
May 30 14:08:11 linus-xfs-crc kernel: RSP: 0018:ffff8881023e7970 EFLAGS: 00010282
May 30 14:08:11 linus-xfs-crc kernel: RAX: 0000000000000000 RBX: ffffea0004ff8c00 RCX: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000001
May 30 14:08:11 linus-xfs-crc kernel: RBP: ffff8881006bf180 R08: 0000000000000001 R09: ffffed102aa7d729
May 30 14:08:11 linus-xfs-crc kernel: R10: ffff8881553eb94b R11: ffffffffac72cb50 R12: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: FS:  0000000000000000(0000) GS:ffff888154a00000(0000) knlGS:0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 30 14:08:11 linus-xfs-crc kernel: CR2: 000055e99a8950e0 CR3: 000000012feb2002 CR4: 0000000000770ef0
May 30 14:08:11 linus-xfs-crc kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 30 14:08:11 linus-xfs-crc kernel: DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
May 30 14:08:11 linus-xfs-crc kernel: PKRU: 55555554
May 30 14:08:11 linus-xfs-crc kernel: Call Trace:
May 30 14:08:11 linus-xfs-crc kernel:  <TASK>
May 30 14:08:11 linus-xfs-crc kernel:  ? __warn+0xc8/0x2c0
May 30 14:08:11 linus-xfs-crc kernel:  ? __free_pages+0x2e0/0x430
May 30 14:08:11 linus-xfs-crc kernel:  ? report_bug+0x2e6/0x390
May 30 14:08:11 linus-xfs-crc kernel:  ? handle_bug+0x79/0xa0
May 30 14:08:11 linus-xfs-crc kernel:  ? exc_invalid_op+0x13/0x40
May 30 14:08:11 linus-xfs-crc kernel:  ? asm_exc_invalid_op+0x16/0x20
May 30 14:08:11 linus-xfs-crc kernel:  ? __free_pages+0x2e0/0x430
May 30 14:08:11 linus-xfs-crc kernel:  release_free_list+0x135/0x300
May 30 14:08:11 linus-xfs-crc kernel:  compact_zone+0x1c29/0x37a0
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_compact_zone+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ? find_held_lock+0x34/0x120
May 30 14:08:11 linus-xfs-crc kernel:  ? kcompactd+0x2d3/0x9b0
May 30 14:08:11 linus-xfs-crc kernel:  ? kcompactd+0x2d3/0x9b0
May 30 14:08:11 linus-xfs-crc kernel:  ? lock_acquired+0x22d/0xa10
May 30 14:08:11 linus-xfs-crc kernel:  compact_node+0x14d/0x230
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_compact_node+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  kcompactd+0x5c3/0x9b0
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kcompactd+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ? lockdep_hardirqs_on+0x7c/0x100
May 30 14:08:11 linus-xfs-crc kernel:  ? __kthread_parkme+0x82/0x150
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kcompactd+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  kthread+0x2ad/0x380
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kthread+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ret_from_fork+0x2d/0x70
May 30 14:08:11 linus-xfs-crc kernel:  ? __pfx_kthread+0x10/0x10
May 30 14:08:11 linus-xfs-crc kernel:  ret_from_fork_asm+0x1a/0x30
May 30 14:08:11 linus-xfs-crc kernel:  </TASK>
May 30 14:08:11 linus-xfs-crc kernel: irq event stamp: 314741
May 30 14:08:11 linus-xfs-crc kernel: hardirqs last  enabled at (314753): [<ffffffffa995ecc5>] console_unlock+0x1d5/0x250
May 30 14:08:11 linus-xfs-crc kernel: hardirqs last disabled at (314762): [<ffffffffa995ecaa>] console_unlock+0x1ba/0x250
May 30 14:08:11 linus-xfs-crc kernel: softirqs last  enabled at (314282): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 14:08:11 linus-xfs-crc kernel: softirqs last disabled at (314277): [<ffffffffa97b62d1>] __irq_exit_rcu+0xa1/0x100
May 30 14:08:11 linus-xfs-crc kernel: ---[ end trace 0000000000000000 ]---
May 30 14:08:25 linus-xfs-crc kernel: t_open_tmpfiles invoked oom-killer: gfp_mask=0x40cc0(GFP_KERNEL|__GFP_COMP), order=1, oom_score_adj=250
May 30 14:08:25 linus-xfs-crc kernel: CPU: 7 PID: 2336 Comm: t_open_tmpfiles Tainted: G        W          6.10.0-rc1 #3
May 30 14:08:25 linus-xfs-crc kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
May 30 14:08:25 linus-xfs-crc kernel: Call Trace:
May 30 14:08:25 linus-xfs-crc kernel:  <TASK>
May 30 14:08:25 linus-xfs-crc kernel:  dump_stack_lvl+0x8d/0xb0
May 30 14:08:25 linus-xfs-crc kernel:  dump_header+0x101/0x7d0
May 30 14:08:26 linus-xfs-crc kernel:  oom_kill_process+0x209/0x810
May 30 14:08:26 linus-xfs-crc kernel:  ? oom_evaluate_task+0x347/0x570
May 30 14:08:26 linus-xfs-crc kernel:  out_of_memory+0x28f/0x1480
May 30 14:08:26 linus-xfs-crc kernel:  ? __pfx_out_of_memory+0x10/0x10
May 30 14:08:26 linus-xfs-crc kernel:  ? __pfx_mutex_trylock+0x10/0x10
May 30 14:08:26 linus-xfs-crc kernel:  ? wake_all_kswapds+0x132/0x2e0
May 30 14:08:26 linus-xfs-crc kernel:  ? fs_reclaim_acquire+0xaf/0x160
May 30 14:08:26 linus-xfs-crc kernel:  __alloc_pages_slowpath.constprop.0+0x193a/0x2160
May 30 14:08:26 linus-xfs-crc kernel:  ? __pfx___alloc_pages_slowpath.constprop.0+0x10/0x10
May 30 14:08:26 linus-xfs-crc kernel:  ? prepare_alloc_pages.constprop.0+0x174/0x550
May 30 14:08:26 linus-xfs-crc kernel:  ? find_held_lock+0x34/0x120
May 30 14:08:26 linus-xfs-crc kernel:  __alloc_pages_noprof+0x431/0x4e0
May 30 14:08:26 linus-xfs-crc kernel:  ? __pfx___alloc_pages_noprof+0x10/0x10
May 30 14:08:26 linus-xfs-crc kernel:  ? local_clock_noinstr+0x9/0xc0
May 30 14:08:26 linus-xfs-crc kernel:  ? lock_release+0x3ad/0xbb0
May 30 14:08:26 linus-xfs-crc kernel:  alloc_slab_page+0x6d/0x160
May 30 14:08:26 linus-xfs-crc kernel:  allocate_slab+0x35c/0x3a0
May 30 14:08:26 linus-xfs-crc kernel:  ___slab_alloc+0xc5a/0x1480
May 30 14:08:26 linus-xfs-crc kernel:  ? find_held_lock+0x34/0x120
May 30 14:08:26 linus-xfs-crc kernel:  ? getname_flags.part.0+0xb1/0x670
May 30 14:08:26 linus-xfs-crc kernel:  ? __pfx_lock_release+0x10/0x10
May 30 14:08:26 linus-xfs-crc kernel:  ? getname_flags.part.0+0xb1/0x670
May 30 14:08:26 linus-xfs-crc kernel:  ? __slab_alloc.isra.0+0x52/0xa0
May 30 14:08:26 linus-xfs-crc kernel:  __slab_alloc.isra.0+0x52/0xa0
May 30 14:08:26 linus-xfs-crc kernel:  ? getname_flags.part.0+0xb1/0x670
May 30 14:08:26 linus-xfs-crc kernel:  kmem_cache_alloc_noprof+0x3b6/0x430
May 30 14:08:26 linus-xfs-crc kernel:  getname_flags.part.0+0xb1/0x670
May 30 14:08:26 linus-xfs-crc kernel:  do_sys_openat2+0xd7/0x160
May 30 14:08:26 linus-xfs-crc kernel:  ? __pfx_do_sys_openat2+0x10/0x10
May 30 14:08:26 linus-xfs-crc kernel:  ? rcu_is_watching+0x11/0xb0
May 30 14:08:26 linus-xfs-crc kernel:  ? __rseq_handle_notify_resume+0xa1b/0xcf0
May 30 14:08:26 linus-xfs-crc kernel:  __x64_sys_openat+0x11f/0x1d0
May 30 14:08:26 linus-xfs-crc kernel:  ? __pfx___x64_sys_openat+0x10/0x10
May 30 14:08:26 linus-xfs-crc kernel:  ? xfd_validate_state+0x24/0x130
May 30 14:08:26 linus-xfs-crc kernel:  ? do_syscall_64+0x2a/0x140
May 30 14:08:26 linus-xfs-crc kernel:  do_syscall_64+0x69/0x140
May 30 14:08:26 linus-xfs-crc kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
May 30 14:08:26 linus-xfs-crc kernel: RIP: 0033:0x7f846e652f01
May 30 14:08:26 linus-xfs-crc kernel: Code: Unable to access opcode bytes at 0x7f846e652ed7.
May 30 14:08:26 linus-xfs-crc kernel: RSP: 002b:00007ffde7725ca0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
May 30 14:08:26 linus-xfs-crc kernel: RAX: ffffffffffffffda RBX: 0000000000410002 RCX: 00007f846e652f01
May 30 14:08:26 linus-xfs-crc kernel: RDX: 0000000000410002 RSI: 000055577646b057 RDI: 00000000ffffff9c
May 30 14:08:26 linus-xfs-crc kernel: RBP: 000055577646b057 R08: 00017160c7148268 R09: 00007f846e74f680
May 30 14:08:26 linus-xfs-crc kernel: R10: 00000000000001a4 R11: 0000000000000202 R12: 0000000000000000
May 30 14:08:26 linus-xfs-crc kernel: R13: 00007ffde7725e80 R14: 000055577646cdd8 R15: 00007f846e77d020
May 30 14:08:26 linus-xfs-crc kernel:  </TASK>
May 30 14:08:26 linus-xfs-crc kernel: Mem-Info:
May 30 14:08:26 linus-xfs-crc kernel: active_anon:5532 inactive_anon:6631 isolated_anon:0
                                       active_file:106 inactive_file:41 isolated_file:0
                                       unevictable:0 dirty:0 writeback:0
                                       slab_reclaimable:355621 slab_unreclaimable:422360
                                       mapped:0 shmem:171 pagetables:758
                                       sec_pagetables:0 bounce:0
                                       kernel_misc_reclaimable:0
                                       free:21725 free_pcp:4560 free_cma:0
May 30 14:08:26 linus-xfs-crc kernel: Node 0 active_anon:19592kB inactive_anon:29060kB active_file:196kB inactive_file:500kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:0kB dirty:0kB writeback:0kB shmem:684kB shmem_thp:0kB shmem_pmdmapped:0kB anon_thp:6144kB writeback_tmp:0kB kernel_stack:10144kB pagetables:3032kB sec_pagetables:0kB all_unreclaimable? no
May 30 14:08:26 linus-xfs-crc kernel: Node 0 DMA free:12832kB boost:0kB min:316kB low:392kB high:468kB reserved_highatomic:0KB active_anon:12kB inactive_anon:0kB active_file:76kB inactive_file:116kB unevictable:0kB writepending:100kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:48kB local_pcp:0kB free_cma:0kB
May 30 14:08:26 linus-xfs-crc kernel: lowmem_reserve[]: 0 1845 3179 0 0
May 30 14:08:26 linus-xfs-crc kernel: Node 0 DMA32 free:46472kB boost:0kB min:39032kB low:48788kB high:58544kB reserved_highatomic:0KB active_anon:2052kB inactive_anon:0kB active_file:0kB inactive_file:464kB unevictable:0kB writepending:264kB present:2080624kB managed:2015088kB mlocked:0kB bounce:0kB free_pcp:5104kB local_pcp:0kB free_cma:0kB
May 30 14:08:26 linus-xfs-crc kernel: lowmem_reserve[]: 0 0 1334 0 0
May 30 14:08:26 linus-xfs-crc kernel: Node 0 Normal free:31060kB boost:0kB min:28232kB low:35288kB high:42344kB reserved_highatomic:4096KB active_anon:31608kB inactive_anon:14980kB active_file:1540kB inactive_file:0kB unevictable:0kB writepending:0kB present:2097152kB managed:1374772kB mlocked:0kB bounce:0kB free_pcp:10524kB local_pcp:0kB free_cma:0kB
May 30 14:08:26 linus-xfs-crc kernel: lowmem_reserve[]: 0 0 0 0 0
May 30 14:08:26 linus-xfs-crc kernel: Node 0 DMA: 4*4kB (UE) 4*8kB (UME) 0*16kB 7*32kB (UM) 6*64kB (UM) 3*128kB (UM) 0*256kB 0*512kB 3*1024kB (UME) 2*2048kB (UE) 1*4096kB (M) = 12304kB
May 30 14:08:26 linus-xfs-crc kernel: Node 0 DMA32: 1188*4kB (UME) 2*8kB (UM) 2*16kB (ME) 223*32kB (UME) 32*64kB (UM) 9*128kB (U) 3*256kB (UE) 4*512kB (UME) 2*1024kB (UM) 11*2048kB (M) 0*4096kB = 42528kB
May 30 14:08:26 linus-xfs-crc kernel: Node 0 Normal: 1074*4kB (UME) 423*8kB (UME) 391*16kB (UME) 285*32kB (UMEH) 85*64kB (UMEH) 6*128kB (UME) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 29264kB
May 30 14:08:26 linus-xfs-crc kernel: Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
May 30 14:08:26 linus-xfs-crc kernel: Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
May 30 14:08:26 linus-xfs-crc kernel: 337 total pagecache pages
May 30 14:08:26 linus-xfs-crc kernel: 0 pages in swap cache
May 30 14:08:26 linus-xfs-crc kernel: Free swap  = 0kB
May 30 14:08:26 linus-xfs-crc kernel: Total swap = 0kB
May 30 14:08:26 linus-xfs-crc kernel: 1048442 pages RAM
May 30 14:08:26 linus-xfs-crc kernel: 0 pages HighMem/MovableOnly
May 30 14:08:26 linus-xfs-crc kernel: 197137 pages reserved
May 30 14:08:26 linus-xfs-crc kernel: 0 pages cma reserved
May 30 14:08:26 linus-xfs-crc kernel: 0 pages hwpoisoned
May 30 14:08:26 linus-xfs-crc kernel: Memory allocations:
May 30 14:08:26 linus-xfs-crc kernel:   3176243200   247900 mm/slub.c:2264 func:alloc_slab_page
May 30 14:08:26 linus-xfs-crc kernel:   1047212032   511334 fs/xfs/xfs_icache.c:82 [xfs] func:xfs_inode_alloc
May 30 14:08:26 linus-xfs-crc kernel:    327781760   512159 fs/file_table.c:202 func:alloc_empty_file
May 30 14:08:26 linus-xfs-crc kernel:    202167728   515734 fs/dcache.c:1624 func:__d_alloc
May 30 14:08:26 linus-xfs-crc kernel:    171806208   511328 fs/xfs/xfs_inode_item.c:838 [xfs] func:xfs_inode_item_init
May 30 14:08:26 linus-xfs-crc kernel:     69318528    28179 fs/xfs/xfs_log_priv.h:703 [xfs] func:xlog_kvmalloc
May 30 14:08:26 linus-xfs-crc kernel:     61459680   512164 security/security.c:649 func:lsm_file_alloc
May 30 14:08:26 linus-xfs-crc kernel:     32740448     8199 mm/execmem.c:31 func:__execmem_alloc
May 30 14:08:26 linus-xfs-crc kernel:     30113792     7352 fs/xfs/xfs_buf.c:398 [xfs] func:xfs_buf_alloc_pages
May 30 14:08:26 linus-xfs-crc kernel:     21667840     5290 mm/memory.c:1048 func:folio_prealloc
May 30 14:08:26 linus-xfs-crc kernel: Unreclaimable slab info:
May 30 14:08:26 linus-xfs-crc kernel: Name                      Used          Total
May 30 14:08:26 linus-xfs-crc kernel: xfs_iul_item             932KB        932KB
May 30 14:08:26 linus-xfs-crc kernel: xfs_icr                  263KB        263KB
May 30 14:08:26 linus-xfs-crc kernel: xfs_buf_item             696KB       1189KB
May 30 14:08:26 linus-xfs-crc kernel: xfs_trans               1092KB       1092KB
May 30 14:08:26 linus-xfs-crc kernel: xfs_inobt_cur           2872KB       2872KB
May 30 14:08:26 linus-xfs-crc kernel: xfs_bnobt_cur            181KB        181KB
May 30 14:08:26 linus-xfs-crc kernel: xfs_log_ticket           252KB        252KB
May 30 14:08:26 linus-xfs-crc kernel: rpc_buffers               31KB         31KB
May 30 14:08:26 linus-xfs-crc kernel: rpc_tasks                  7KB          7KB
May 30 14:08:26 linus-xfs-crc kernel: ext4_system_zone          12KB         27KB
May 30 14:08:26 linus-xfs-crc kernel: ext4_io_end_vec           31KB         31KB
May 30 14:08:26 linus-xfs-crc kernel: jbd2_inode                31KB         31KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_delayed_extent_op         75KB         75KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_delayed_ref_node        502KB        502KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_delayed_ref_head       1204KB       1204KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_delayed_node        112KB        112KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_ordered_extent        456KB        456KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_extent_map         490KB        490KB
May 30 14:08:26 linus-xfs-crc kernel: bio-344                   15KB         15KB
May 30 14:08:26 linus-xfs-crc kernel: bio-408                 1408KB       1408KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_extent_buffer        649KB        649KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_extent_state       3332KB       3332KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_free_space_bitmap        128KB        128KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_free_space         126KB        126KB
May 30 14:08:26 linus-xfs-crc kernel: btrfs_path              1470KB       1470KB
May 30 14:08:26 linus-xfs-crc kernel: bio-424                   16KB         16KB
May 30 14:08:26 linus-xfs-crc kernel: bio-528                   15KB         15KB
May 30 14:08:26 linus-xfs-crc kernel: bio-120                   47KB         47KB
May 30 14:08:26 linus-xfs-crc kernel: p9_req_t                  47KB         47KB
May 30 14:08:26 linus-xfs-crc kernel: fib6_node                  8KB          8KB
May 30 14:08:26 linus-xfs-crc kernel: ip6_dst_cache             39KB         39KB
May 30 14:08:26 linus-xfs-crc kernel: RAWv6                     63KB         63KB
May 30 14:08:26 linus-xfs-crc kernel: UDPv6                    154KB        154KB
May 30 14:08:26 linus-xfs-crc kernel: TCPv6                     91KB         91KB
May 30 14:08:26 linus-xfs-crc kernel: bio-248                   15KB         15KB
May 30 14:08:26 linus-xfs-crc kernel: mqueue_inode_cache         30KB         30KB
May 30 14:08:26 linus-xfs-crc kernel: kioctx                    31KB         31KB
May 30 14:08:26 linus-xfs-crc kernel: aio_kiocb                  7KB          7KB
May 30 14:08:26 linus-xfs-crc kernel: UNIX-STREAM              866KB        866KB
May 30 14:08:26 linus-xfs-crc kernel: UNIX                     876KB       1020KB
May 30 14:08:26 linus-xfs-crc kernel: tcp_bind2_bucket          20KB         20KB
May 30 14:08:26 linus-xfs-crc kernel: tcp_bind_bucket           12KB         12KB
May 30 14:08:26 linus-xfs-crc kernel: ip_fib_trie               20KB         20KB
May 30 14:08:26 linus-xfs-crc kernel: ip_fib_alias              19KB         19KB
May 30 14:08:26 linus-xfs-crc kernel: rtable                    64KB         64KB
May 30 14:08:26 linus-xfs-crc kernel: RAW                       60KB         60KB
May 30 14:08:26 linus-xfs-crc kernel: UDP                      223KB        223KB
May 30 14:08:26 linus-xfs-crc kernel: tw_sock_TCP                7KB          7KB
May 30 14:08:26 linus-xfs-crc kernel: request_sock_TCP          15KB         15KB
May 30 14:08:26 linus-xfs-crc kernel: TCP                      127KB        127KB
May 30 14:08:26 linus-xfs-crc kernel: hugetlbfs_inode_cache         63KB         63KB
May 30 14:08:26 linus-xfs-crc kernel: netfs_subrequest          31KB         31KB
May 30 14:08:26 linus-xfs-crc kernel: netfs_request             95KB         95KB
May 30 14:08:26 linus-xfs-crc kernel: bio-240                   15KB         15KB
May 30 14:08:26 linus-xfs-crc kernel: ep_head                   32KB         32KB
May 30 14:08:26 linus-xfs-crc kernel: eventpoll_pwq             59KB         59KB
May 30 14:08:26 linus-xfs-crc kernel: eventpoll_epi            133KB        133KB
May 30 14:08:26 linus-xfs-crc kernel: inotify_inode_mark         71KB         71KB
May 30 14:08:26 linus-xfs-crc kernel: sgpool-128               446KB        446KB
May 30 14:08:26 linus-xfs-crc kernel: sgpool-64                318KB        318KB
May 30 14:08:26 linus-xfs-crc kernel: sgpool-32                283KB        283KB
May 30 14:08:26 linus-xfs-crc kernel: sgpool-16                140KB        140KB
May 30 14:08:26 linus-xfs-crc kernel: sgpool-8                 539KB        539KB
May 30 14:08:26 linus-xfs-crc kernel: request_queue            191KB        191KB
May 30 14:08:26 linus-xfs-crc kernel: blkdev_ioc                12KB         12KB
May 30 14:08:26 linus-xfs-crc kernel: bio-184                  264KB        264KB
May 30 14:08:26 linus-xfs-crc kernel: biovec-max              7526KB       7526KB
May 30 14:08:26 linus-xfs-crc kernel: biovec-128               255KB        255KB
May 30 14:08:26 linus-xfs-crc kernel: biovec-64                535KB        567KB
May 30 14:08:26 linus-xfs-crc kernel: biovec-16                359KB        359KB
May 30 14:08:26 linus-xfs-crc kernel: bio_integrity_payload          7KB          7KB
May 30 14:08:26 linus-xfs-crc kernel: khugepaged_mm_slot         39KB         39KB
May 30 14:08:26 linus-xfs-crc kernel: uid_cache                 55KB         55KB
May 30 14:08:26 linus-xfs-crc kernel: dmaengine-unmap-2          4KB          4KB
May 30 14:08:26 linus-xfs-crc kernel: audit_buffer              15KB         15KB
May 30 14:08:26 linus-xfs-crc kernel: skbuff_small_head        395KB        458KB
May 30 14:08:26 linus-xfs-crc kernel: skbuff_fclone_cache        187KB        187KB
May 30 14:08:26 linus-xfs-crc kernel: skbuff_head_cache        240KB        359KB
May 30 14:08:26 linus-xfs-crc kernel: file_lock_cache          140KB        140KB
May 30 14:08:26 linus-xfs-crc kernel: file_lock_ctx             51KB         51KB
May 30 14:08:26 linus-xfs-crc kernel: fsnotify_mark_connector         36KB         36KB
May 30 14:08:26 linus-xfs-crc kernel: taskstats                127KB        127KB
May 30 14:08:26 linus-xfs-crc kernel: proc_dir_entry           359KB        359KB
May 30 14:08:26 linus-xfs-crc kernel: pde_opener                31KB         31KB
May 30 14:08:26 linus-xfs-crc kernel: seq_file                 142KB        174KB
May 30 14:08:26 linus-xfs-crc kernel: sigqueue                  78KB         78KB
May 30 14:08:26 linus-xfs-crc kernel: shmem_inode_cache       2188KB       2299KB
May 30 14:08:26 linus-xfs-crc kernel: kernfs_iattrs_cache         71KB         71KB
May 30 14:08:26 linus-xfs-crc kernel: kernfs_node_cache       7473KB       7528KB
May 30 14:08:26 linus-xfs-crc kernel: mnt_cache                267KB        267KB
May 30 14:08:26 linus-xfs-crc kernel: filp                  320228KB     320228KB
May 30 14:08:26 linus-xfs-crc kernel: names_cache            15215KB      15351KB
May 30 14:08:26 linus-xfs-crc kernel: net_namespace             29KB         29KB
May 30 14:08:26 linus-xfs-crc kernel: lsm_file_cache         60048KB      60048KB
May 30 14:08:26 linus-xfs-crc kernel: key_jar                  126KB        126KB
May 30 14:08:26 linus-xfs-crc kernel: uts_namespace             63KB         63KB
May 30 14:08:26 linus-xfs-crc kernel: nsproxy                   23KB         23KB
May 30 14:08:26 linus-xfs-crc kernel: vma_lock                1054KB       2045KB
May 30 14:08:26 linus-xfs-crc kernel: vm_area_struct          1101KB       2207KB
May 30 14:08:26 linus-xfs-crc kernel: fs_cache                 192KB        192KB
May 30 14:08:26 linus-xfs-crc kernel: files_cache              733KB        733KB
May 30 14:08:26 linus-xfs-crc kernel: signal_cache             934KB       1071KB
May 30 14:08:26 linus-xfs-crc kernel: sighand_cache           1153KB       1382KB
May 30 14:08:26 linus-xfs-crc kernel: task_struct             3422KB       4036KB
May 30 14:08:26 linus-xfs-crc kernel: cred                     230KB        280KB
May 30 14:08:26 linus-xfs-crc kernel: anon_vma_chain           321KB        559KB
May 30 14:08:26 linus-xfs-crc kernel: anon_vma                 517KB        937KB
May 30 14:08:26 linus-xfs-crc kernel: pid                      260KB        312KB
May 30 14:08:26 linus-xfs-crc kernel: Acpi-Operand             328KB        475KB
May 30 14:08:26 linus-xfs-crc kernel: Acpi-ParseExt             74KB         74KB
May 30 14:08:26 linus-xfs-crc kernel: Acpi-Parse               189KB        205KB
May 30 14:08:26 linus-xfs-crc kernel: Acpi-State               165KB        181KB
May 30 14:08:26 linus-xfs-crc kernel: Acpi-Namespace            44KB         44KB
May 30 14:08:26 linus-xfs-crc kernel: numa_policy                7KB          7KB
May 30 14:08:26 linus-xfs-crc kernel: perf_event                31KB         31KB
May 30 14:08:26 linus-xfs-crc kernel: trace_event_file         360KB        360KB
May 30 14:08:26 linus-xfs-crc kernel: ftrace_event_field        573KB        573KB
May 30 14:08:26 linus-xfs-crc kernel: pool_workqueue           882KB        882KB
May 30 14:08:26 linus-xfs-crc kernel: maple_node               803KB       2848KB
May 30 14:08:26 linus-xfs-crc kernel: task_group               255KB        255KB
May 30 14:08:26 linus-xfs-crc kernel: mm_struct                790KB       1110KB
May 30 14:08:26 linus-xfs-crc kernel: vmap_area                120KB        122KB
May 30 14:08:26 linus-xfs-crc kernel: page->ptl                153KB        293KB
May 30 14:08:26 linus-xfs-crc kernel: kmemleak_scan_area         82KB         87KB
May 30 14:08:26 linus-xfs-crc kernel: kmemleak_object       878221KB     879281KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-8k            416KB        416KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-4k            936KB       1088KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-2k           1348KB       1792KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-1k            848KB       1280KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-512           686KB        800KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-256           112KB        112KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-128            64KB         64KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-64             92KB         92KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-32            109KB        128KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-16             32KB         32KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-8              56KB         56KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-192            72KB         72KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-cg-96            120KB        120KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-8k             57232KB      67424KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-4k             15664KB      15904KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-2k              8340KB       8384KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-1k             39758KB      39776KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-512           107357KB     135296KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-256            18208KB      18208KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-128              713KB       1056KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-64              1360KB       1360KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-32               726KB       1340KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-16               241KB        260KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-8                147KB        152KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-192              485KB        608KB
May 30 14:08:26 linus-xfs-crc kernel: kmalloc-96               736KB        736KB
May 30 14:08:26 linus-xfs-crc kernel: kmem_cache_node           96KB         96KB
May 30 14:08:26 linus-xfs-crc kernel: kmem_cache               109KB        109KB
May 30 14:08:26 linus-xfs-crc kernel: Tasks state (memory values in pages):
May 30 14:08:26 linus-xfs-crc kernel: [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
May 30 14:08:26 linus-xfs-crc kernel: [    333]     0   333    10373      353      224      129         0   102400        0          -250 systemd-journal
May 30 14:08:26 linus-xfs-crc kernel: [    352]     0   352     6002      414      384       30         0    69632        0         -1000 systemd-udevd
May 30 14:08:26 linus-xfs-crc kernel: [    574]   103   574     1969      140       96       44         0    61440        0             0 rpcbind
May 30 14:08:26 linus-xfs-crc kernel: [    577]   997   577    22514      234      192       42         0    77824        0             0 systemd-timesyn
May 30 14:08:26 linus-xfs-crc kernel: [    583]     0   583     1467      215      160       55         0    53248        0             0 dhclient
May 30 14:08:26 linus-xfs-crc kernel: [    593]   100   593     2305      133       96       37         0    61440        0          -900 dbus-daemon
May 30 14:08:26 linus-xfs-crc kernel: [    595]     0   595    20060       64       64        0         0    73728        0             0 qemu-ga
May 30 14:08:26 linus-xfs-crc kernel: [    596]     0   596     4251      308      256       52         0    73728        0             0 systemd-logind
May 30 14:08:26 linus-xfs-crc kernel: [    648] 63150   648    33070      415      384       31         0   221184        0             0 systemd-journal
May 30 14:08:26 linus-xfs-crc kernel: [    652]     0   652     3852      366      320       46         0    77824        0         -1000 sshd
May 30 14:08:26 linus-xfs-crc kernel: [    661]     0   661     1652       46       32       14         0    53248        0             0 cron
May 30 14:08:26 linus-xfs-crc kernel: [    666]     0   666     1468       98       32       66         0    53248        0             0 agetty
May 30 14:08:26 linus-xfs-crc kernel: [    667]     0   667     1374       76       32       44         0    57344        0             0 agetty
May 30 14:08:26 linus-xfs-crc kernel: [    916]   105   916     7149     2708     2669       39         0    98304        0             0 exim4
May 30 14:08:26 linus-xfs-crc kernel: [   1039]     0  1039     4449      431      384       47         0    77824        0             0 sshd
May 30 14:08:26 linus-xfs-crc kernel: [   1042]  1000  1042     4735      395      384       11         0    77824        0           100 systemd
May 30 14:08:26 linus-xfs-crc kernel: [   1044]  1000  1044    42208      820      787       33         0    90112        0           100 (sd-pam)
May 30 14:08:26 linus-xfs-crc kernel: [   1063]  1000  1063     4489      521      451       70         0    77824        0             0 sshd
May 30 14:08:26 linus-xfs-crc kernel: [   1064]  1000  1064     2064      430      384       46         0    61440        0             0 bash
May 30 14:08:26 linus-xfs-crc kernel: [   1073]     0  1073     4449      454      384       70         0    73728        0             0 sshd
May 30 14:08:26 linus-xfs-crc kernel: [   1079]  1000  1079     4514      518      449       69         0    73728        0             0 sshd
May 30 14:08:26 linus-xfs-crc kernel: [   1080]  1000  1080     2064      450      384       66         0    61440        0             0 bash
May 30 14:08:26 linus-xfs-crc kernel: [   1089]  1000  1089     2533      112       96       16         0    65536        0             0 sudo
May 30 14:08:26 linus-xfs-crc kernel: [   1090]  1000  1090     2533      120      100       20         0    57344        0             0 sudo
May 30 14:08:26 linus-xfs-crc kernel: [   1091]     0  1091     2251      132       96       36         0    57344        0             0 su
May 30 14:08:26 linus-xfs-crc kernel: [   1093]     0  1093     2095      492      416       76         0    65536        0             0 bash
May 30 14:08:26 linus-xfs-crc kernel: [   1335]     0  1335     2788     1102     1088       14         0    65536        0          -500 check
May 30 14:08:26 linus-xfs-crc kernel: [   2102]     0  2102     1873     1000      960       40         0    61440        0           250 531
May 30 14:08:26 linus-xfs-crc kernel: [   2310]     0  2310      583        0        0        0         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2312]     0  2312      583        0        0        0         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2314]     0  2314      583        0        0        0         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2316]     0  2316      583        0        0        0         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2318]     0  2318      583        0        0        0         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2320]     0  2320      583        0        0        0         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2322]     0  2322      583       45        0       45         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2324]     0  2324      583       34        0       34         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2326]     0  2326      583        0        0        0         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2328]     0  2328      583       40        0       40         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2330]     0  2330      583        0        0        0         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2332]     0  2332      583        0        0        0         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2334]     0  2334      583       33        0       33         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2336]     0  2336      583        0        0        0         0    36864        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2338]     0  2338      583        0        0        0         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: [   2340]     0  2340      583        0        0        0         0    40960        0           250 t_open_tmpfiles
May 30 14:08:26 linus-xfs-crc kernel: oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/system.slice/fstests-generic-531.scope,task=531,pid=2102,uid=0
May 30 14:08:26 linus-xfs-crc kernel: Out of memory: Killed process 2102 (531) total-vm:7492kB, anon-rss:3840kB, file-rss:160kB, shmem-rss:0kB, UID:0 pgtables:60kB oom_score_adj:250
May 30 14:10:39 linus-xfs-crc kernel: XFS (loop16): Unmounting Filesystem 7c609e30-4cb1-42f8-85c6-f57f3f0e5201
May 30 14:10:40 linus-xfs-crc kernel: XFS (loop5): Unmounting Filesystem 63d9d33b-e75d-4d35-be76-6df47036ee3a
