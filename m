Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 12:27:44 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65JRYuE031188
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 12:27:34 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 236161878321
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 12:28:34 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id JHKEBWJ8ZodB5L63 for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 12:28:34 -0700 (PDT)
Date: Sat, 5 Jul 2008 15:28:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <486FBFAB.5050303@shaw.ca>
Message-ID: <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Sat, 5 Jul 2008, Robert Hancock wrote:

> Justin Piszcz wrote:
>> I've read the best way to 'deal' with this issue is to turn off apic/acpi 
>> etc, is there any downside to turning them off?  Particularly APIC for IRQ 
>> routing?
>
> It's not the best way to deal with it, more just a workaround, and if it does 
> help it should be reported because it indicates something else is wrong. The 
> main downsides to disabling APIC is that all interrupts will be handled by 
> one core and you'll end up with much more IRQ sharing. Disabling ACPI on 
> modern systems tends to be a bad idea, you'll get no multi-core support, for 
> one.
>
>> [115787.446158] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [115788.133592] ata6.00: configured for UDMA/133
>> [115788.133628] ata6: EH complete
>> [115787.877547] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors 
>> (300069 MB)
>> [115787.877689] sd 5:0:0:0: [sdf] Write Protect is off
>> [115787.877692] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
>> [115787.878746] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
>> enabled, doesn't support DPO or FUA
>> 
>> What is the true cause of this, is there anyway to get more information?
>> 
>> I will test soon with apic/acpi=off.
>
> Can you post your dmesg from bootup with the controller/drive detection?

Below:

[    0.000000] Linux version 2.6.25.10 (root@p34.internal.lan) (gcc version 4.3.1 (Debian 4.3.1-2) ) #1 SMP Thu Jul 3 04:57:42 EDT 2008
[    0.000000] Command line: auto BOOT_IMAGE=2.6.25.10-1 ro root=902
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf58f000 (usable)
[    0.000000]  BIOS-e820: 00000000cf58f000 - 00000000cf59c000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf59c000 - 00000000cf639000 (usable)
[    0.000000]  BIOS-e820: 00000000cf639000 - 00000000cf694000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf694000 - 00000000cf697000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf697000 - 00000000cf6ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf6ef000 - 00000000cf6f1000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 (usable)
[    0.000000]  BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
[    0.000000]  BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 143) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849295) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 849308, 849465) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 849649, 849650) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 849663, 849664) 4 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 2277376) 5 entries of 256 used
[    0.000000] end_pfn_map = 2277376
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT CF6FD038, 0050 (r1 INTEL  DG965WH       6CA       1000013)
[    0.000000] ACPI: FACP CF6FC000, 0074 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: DSDT CF6F7000, 442C (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: FACS CF697000, 0040
[    0.000000] ACPI: APIC CF6F6000, 0078 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: WDDT CF6F5000, 0040 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: MCFG CF6F4000, 003C (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: ASF! CF6F3000, 00A6 (r32 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: HPET CF6F2000, 0038 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF6F0000, 020C (r1 INTEL     CpuPm      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF6EF000, 0175 (r1 INTEL   Cpu0Ist      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF696000, 0175 (r1 INTEL   Cpu1Ist      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF695000, 0175 (r1 INTEL   Cpu2Ist      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF694000, 0175 (r1 INTEL   Cpu3Ist      6CA MSFT  1000013)
[    0.000000] Entering add_active_range(0, 0, 143) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849295) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 849308, 849465) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 849649, 849650) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 849663, 849664) 4 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 2277376) 5 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-7c93a7] TEXT DATA BSS
[    0.000000] early res: 3 [9a400-a03ff] EBDA
[    0.000000] early res: 4 [8000-11fff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
[    0.000000]  [ffffe20004400000-ffffe200045fffff] PMD ->ffff810009a00000 on node 0
[    0.000000]  [ffffe20004600000-ffffe200047fffff] PMD ->ffff810009e00000 on node 0
[    0.000000]  [ffffe20004800000-ffffe200049fffff] PMD ->ffff81000a200000 on node 0
[    0.000000]  [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff81000a600000 on node 0
[    0.000000]  [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff81000aa00000 on node 0
[    0.000000]  [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff81000ae00000 on node 0
[    0.000000]  [ffffe20005000000-ffffe200051fffff] PMD ->ffff81000b200000 on node 0
[    0.000000]  [ffffe20005200000-ffffe200053fffff] PMD ->ffff81000b600000 on node 0
[    0.000000]  [ffffe20005400000-ffffe200055fffff] PMD ->ffff81000ba00000 on node 0
[    0.000000]  [ffffe20005600000-ffffe200057fffff] PMD ->ffff81000be00000 on node 0
[    0.000000]  [ffffe20005800000-ffffe200059fffff] PMD ->ffff81000c200000 on node 0
[    0.000000]  [ffffe20005a00000-ffffe20005bfffff] PMD ->ffff81000c600000 on node 0
[    0.000000]  [ffffe20005c00000-ffffe20005dfffff] PMD ->ffff81000ca00000 on node 0
[    0.000000]  [ffffe20005e00000-ffffe20005ffffff] PMD ->ffff81000ce00000 on node 0
[    0.000000]  [ffffe20006000000-ffffe200061fffff] PMD ->ffff81000d200000 on node 0
[    0.000000]  [ffffe20006200000-ffffe200063fffff] PMD ->ffff81000d600000 on node 0
[    0.000000]  [ffffe20006400000-ffffe200065fffff] PMD ->ffff81000da00000 on node 0
[    0.000000]  [ffffe20006600000-ffffe200067fffff] PMD ->ffff81000de00000 on node 0
[    0.000000]  [ffffe20006800000-ffffe200069fffff] PMD ->ffff81000e200000 on node 0
[    0.000000]  [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff81000e600000 on node 0
[    0.000000]  [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff81000ea00000 on node 0
[    0.000000]  [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff81000ee00000 on node 0
[    0.000000]  [ffffe20007000000-ffffe200071fffff] PMD ->ffff81000f200000 on node 0
[    0.000000]  [ffffe20007200000-ffffe200073fffff] PMD ->ffff81000f600000 on node 0
[    0.000000]  [ffffe20007400000-ffffe200075fffff] PMD ->ffff81000fa00000 on node 0
[    0.000000]  [ffffe20007600000-ffffe200077fffff] PMD ->ffff81000fe00000 on node 0
[    0.000000]  [ffffe20007800000-ffffe200079fffff] PMD ->ffff810010200000 on node 0
[    0.000000]  [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff810010600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  2277376
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0:        0 ->      143
[    0.000000]     0:      256 ->   849295
[    0.000000]     0:   849308 ->   849465
[    0.000000]     0:   849649 ->   849650
[    0.000000]     0:   849663 ->   849664
[    0.000000]     0:  1048576 ->  2277376
[    0.000000] On node 0 totalpages: 2078141
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1502 pages reserved
[    0.000000]   DMA zone: 2425 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 831078 pages, LIFO batch:31
[    0.000000]   Normal zone: 16800 pages used for memmap
[    0.000000]   Normal zone: 1212000 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d2000000 (gap: d0000000:20000000)
[    0.000000] PERCPU: Allocating 21960 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2045503
[    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.25.10-1 ro root=902
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] time.c: Detected 2397.601 MHz processor.
[    0.000017] Console: colour dummy device 80x25
[    0.000020] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Checking aperture...
[    0.000999] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000999] Placing software IO TLB between 0x11433000 - 0x15433000
[    0.000999] Memory: 8100044k/9109504k available (3999k kernel code, 211796k reserved, 1251k data, 256k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] hpet clockevent registered
[    0.059992] Calibrating delay using timer specific routine.. 4797.82 BogoMIPS (lpj=2398913)
[    0.060037] Mount-cache hash table entries: 256
[    0.060140] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.060143] CPU: L2 cache: 4096K
[    0.060146] CPU: Physical Processor ID: 0
[    0.060148] CPU: Processor Core ID: 0
[    0.060155] CPU0: Thermal monitoring enabled (TM2)
[    0.060157] using mwait in idle threads.
[    0.060165] Freeing SMP alternatives: 35k freed
[    0.060183] ACPI: Core revision 20070126
[    0.077084] Using local APIC timer interrupts.
[    0.077989] APIC timer calibration result 16649993
[    0.077990] Detected 16.649 MHz APIC timer.
[    0.078079] Booting processor 1/4 APIC 0x2
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4794.99 BogoMIPS (lpj=2397499)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.149473] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.150050] Booting processor 2/4 APIC 0x1
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4795.02 BogoMIPS (lpj=2397514)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] CPU2: Thermal monitoring enabled (TM2)
[    0.000999] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.221461] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.222057] Booting processor 3/4 APIC 0x3
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 4794.98 BogoMIPS (lpj=2397491)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 3
[    0.000999] CPU3: Thermal monitoring enabled (TM2)
[    0.000999] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.293467] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.293961] Brought up 4 CPUs
[    0.294306] net_namespace: 880 bytes
[    0.294415] xor: automatically using best checksumming function: generic_sse
[    0.298955]    generic_sse:  8536.000 MB/sec
[    0.298957] xor: using function: generic_sse (8536.000 MB/sec)
[    0.299014] NET: Registered protocol family 16
[    0.299181] No dock devices found.
[    0.299286] ACPI: bus type pci registered
[    0.303042] PCI: Using MMCONFIG at f0000000 - f7ffffff
[    0.303044] PCI: Using configuration type 1
[    0.306292] ACPI: EC: Look up EC in DSDT
[    0.308191] ACPI: Interpreter enabled
[    0.308194] ACPI: (supports S0 S5)
[    0.308211] ACPI: Using IOAPIC for interrupt routing
[    0.312322] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.313000] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.313005] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.313823] PCI: Transparent bridge - 0000:00:1e.0
[    0.313853] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.314182] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.314416] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.314506] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.314596] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.314685] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.314774] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.319373] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.319459] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.319555] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.319639] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.319722] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[    0.319804] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.319887] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.319951] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.320223] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.320284] pnp: PnP ACPI init
[    0.320293] ACPI: bus type pnp registered
[    0.323494] pnp: PnP ACPI: found 11 devices
[    0.323498] ACPI: ACPI bus type pnp unregistered
[    0.323753] SCSI subsystem initialized
[    0.323851] libata version 3.00 loaded.
[    0.323950] usbcore: registered new interface driver usbfs
[    0.323960] usbcore: registered new interface driver hub
[    0.324020] usbcore: registered new device driver usb
[    0.324274] PCI: Using ACPI for IRQ routing
[    0.324277] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.328963] PCI-GART: No AMD northbridge found.
[    0.328970] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.328976] hpet0: 3 64-bit timers, 14318180 Hz
[    0.332963] system 00:01: iomem range 0xf0000000-0xf7ffffff could not be reserved
[    0.332969] system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[    0.332974] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.332978] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.332983] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.332987] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.332991] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.332996] system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
[    0.333000] system 00:01: iomem range 0xc0000-0xdffff has been reserved
[    0.333004] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[    0.333014] system 00:06: ioport range 0x500-0x53f has been reserved
[    0.333018] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.333022] system 00:06: ioport range 0x360-0x361 has been reserved
[    0.333026] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.333686] PCI: Bridge: 0000:00:1c.0
[    0.333689]   IO window: disabled.
[    0.333693]   MEM window: disabled.
[    0.333696]   PREFETCH window: disabled.
[    0.333701] PCI: Bridge: 0000:00:1c.1
[    0.333703]   IO window: 5000-5fff
[    0.333708]   MEM window: 0xe0400000-0xe04fffff
[    0.333711]   PREFETCH window: disabled.
[    0.333716] PCI: Bridge: 0000:00:1c.2
[    0.333719]   IO window: 4000-4fff
[    0.333723]   MEM window: 0xe0300000-0xe03fffff
[    0.333727]   PREFETCH window: 0x00000000e0700000-0x00000000e07fffff
[    0.333732] PCI: Bridge: 0000:00:1c.3
[    0.333735]   IO window: 3000-3fff
[    0.333739]   MEM window: 0xe0200000-0xe02fffff
[    0.333742]   PREFETCH window: 0x00000000e0800000-0x00000000e08fffff
[    0.333748] PCI: Bridge: 0000:00:1c.4
[    0.333750]   IO window: 2000-2fff
[    0.333754]   MEM window: 0xe0100000-0xe01fffff
[    0.333758]   PREFETCH window: 0x00000000e0900000-0x00000000e09fffff
[    0.333764] PCI: Bridge: 0000:00:1e.0
[    0.333766]   IO window: 1000-1fff
[    0.333770]   MEM window: 0xe0000000-0xe00fffff
[    0.333774]   PREFETCH window: 0x00000000e0a00000-0x00000000e0afffff
[    0.333794] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.333800] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.333814] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.333820] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.333833] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.333839] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.333872] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.333878] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.333891] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
[    0.333896] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.333904] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.333949] NET: Registered protocol family 2
[    0.345005] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.345590] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.347184] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.347731] TCP: Hash tables configured (established 262144 bind 65536)
[    0.347735] TCP reno registered
[    0.056035] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.056134] SGI XFS with large block/inode numbers, no debug enabled
[    0.056622] async_tx: api initialized (sync-only)
[    0.056625] io scheduler noop registered
[    0.056649] io scheduler cfq registered (default)
[    0.056657] pci 0000:00:02.0: Boot video device
[    0.056993] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.057019] assign_interrupt_mode Found MSI capability
[    0.057048] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.057106] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.057152] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.057246] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.057276] assign_interrupt_mode Found MSI capability
[    0.057308] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.057348] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.057386] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.057468] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.057498] assign_interrupt_mode Found MSI capability
[    0.057530] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.057570] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.057607] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.057712] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.057737] assign_interrupt_mode Found MSI capability
[    0.057763] Allocate Port Service[0000:00:1c.3:pcie00]
[    0.057815] Allocate Port Service[0000:00:1c.3:pcie02]
[    0.057861] Allocate Port Service[0000:00:1c.3:pcie03]
[    0.057957] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.057986] assign_interrupt_mode Found MSI capability
[    0.057991] Allocate Port Service[0000:00:1c.4:pcie00]
[    0.057991] Allocate Port Service[0000:00:1c.4:pcie02]
[    0.058031] Allocate Port Service[0000:00:1c.4:pcie03]
[    0.058403] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20008100000, using 2560k, total 7616k
[    0.058407] vesafb: mode is 1280x1024x8, linelength=1280, pages=4
[    0.058409] vesafb: scrolling: redraw
[    0.058412] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[    0.069212] Console: switching to colour frame buffer device 160x64
[    0.079909] fb0: VESA VGA frame buffer device
[    0.080054] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.080170] ACPI: Power Button (FF) [PWRF]
[    0.080298] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.080417] ACPI: Sleep Button (CM) [SLPB]
[    0.090085] Real Time Clock Driver v1.12ac
[    0.090232] hpet_resources: 0xfed00000 is busy
[    0.090273] Linux agpgart interface v0.103
[    0.090341] agpgart: Detected an Intel 965G Chipset.
[    0.091700] agpgart: Detected 7676K stolen memory.
[    0.104465] agpgart: AGP aperture is 256M @ 0xd0000000
[    0.104650] [drm] Initialized drm 1.1.0 20060810
[    0.104735] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.104840] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.104982] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.105433] loop: module loaded
[    0.105552] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[    0.105640] Copyright (c) 1999-2006 Intel Corporation.
[    0.105738] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21
[    0.388945] Switched to high resolution mode on CPU 1
[    0.208970] Switched to high resolution mode on CPU 3
[    0.296959] Switched to high resolution mode on CPU 2
[    0.500925] Switched to high resolution mode on CPU 0
[    0.353439] e1000: 0000:06:00.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:29:37:db
[    0.379214] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    0.379323] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    0.641506] e1000: 0000:06:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:0e:0c:00:cd:b1
[    0.789084] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    0.789212] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[    0.789288] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[    0.789393] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[    0.789502] PCI: Setting latency timer of device 0000:00:19.0 to 64
[    0.889198] eth2: (PCI Express:2.5GB/s:Width x1) 00:19:d1:6e:9d:43
[    0.889282] eth2: Intel(R) PRO/1000 Network Connection
[    0.889371] eth2: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[    0.889485] console [netcon0] enabled
[    0.889555] netconsole: network logging started
[    0.889660] Driver 'sd' needs updating - please use bus_type methods
[    0.889819] Driver 'sr' needs updating - please use bus_type methods
[    0.889917] ahci 0000:00:1f.2: version 3.0
[    0.889931] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
[    1.890735] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.890845] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part 
[    1.890940] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    1.891185] scsi0 : ahci
[    1.891310] scsi1 : ahci
[    1.891419] scsi2 : ahci
[    1.891527] scsi3 : ahci
[    1.891806] scsi4 : ahci
[    1.892805] scsi5 : ahci
[    1.893844] ata1: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625100 irq 378
[    1.894714] ata2: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625180 irq 378
[    1.895713] ata3: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625200 irq 378
[    1.896713] ata4: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625280 irq 378
[    1.897723] ata5: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625300 irq 378
[    1.898713] ata6: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625380 irq 378
[    2.356649] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.673654] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    2.674595] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.679961] ata1.00: configured for UDMA/133
[    2.836575] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.155395] ata2.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    3.155521] ata2.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.161112] ata2.00: configured for UDMA/133
[    3.322501] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.633983] ata3.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    3.634449] ata3.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.640394] ata3.00: configured for UDMA/133
[    3.806428] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.112403] ata4.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    4.113376] ata4.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.119137] ata4.00: configured for UDMA/133
[    4.397339] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.591563] ata5.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    4.592303] ata5.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.598246] ata5.00: configured for UDMA/133
[    4.881265] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.069692] ata6.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    5.070230] ata6.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.076402] ata6.00: configured for UDMA/133
[    4.805409] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.806411] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[    4.808276] sd 0:0:0:0: [sda] Write Protect is off
[    4.809270] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.809285] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.810314] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[    4.811277] sd 0:0:0:0: [sda] Write Protect is off
[    4.812269] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.812284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.813271]  sda: sda1 sda2 sda3
[    5.107470] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.108393] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.109362] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[    5.110233] sd 1:0:0:0: [sdb] Write Protect is off
[    5.111224] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.111239] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.112256] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[    5.113230] sd 1:0:0:0: [sdb] Write Protect is off
[    5.114223] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.114238] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.115223]  sdb: sdb1 sdb2 sdb3
[    5.183395] sd 1:0:0:0: [sdb] Attached SCSI disk
[    5.184338] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.185346] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    5.186220] sd 2:0:0:0: [sdc] Write Protect is off
[    5.187213] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.187227] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.188239] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    5.189219] sd 2:0:0:0: [sdc] Write Protect is off
[    5.190212] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.190226] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.191212]  sdc: sdc1
[    5.196323] sd 2:0:0:0: [sdc] Attached SCSI disk
[    5.197334] scsi 3:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.198338] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[    5.199218] sd 3:0:0:0: [sdd] Write Protect is off
[    5.200211] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.200225] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.201238] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[    5.202217] sd 3:0:0:0: [sdd] Write Protect is off
[    5.203210] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.203224] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.204210]  sdd: sdd1
[    5.210279] sd 3:0:0:0: [sdd] Attached SCSI disk
[    5.211333] scsi 4:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.212335] sd 4:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
[    5.213216] sd 4:0:0:0: [sde] Write Protect is off
[    5.214209] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    5.214223] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.215236] sd 4:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
[    5.216215] sd 4:0:0:0: [sde] Write Protect is off
[    5.217208] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    5.217222] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.218208]  sde: sde1
[    5.226329] sd 4:0:0:0: [sde] Attached SCSI disk
[    5.227335] scsi 5:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.228332] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 MB)
[    5.229214] sd 5:0:0:0: [sdf] Write Protect is off
[    5.230206] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    5.230221] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.231234] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 MB)
[    5.232213] sd 5:0:0:0: [sdf] Write Protect is off
[    5.233205] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    5.233220] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.234205]  sdf: sdf1
[    5.240317] sd 5:0:0:0: [sdf] Attached SCSI disk
[    5.241403] sata_sil24 0000:03:00.0: version 1.1
[    5.241433] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[    5.242246] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    5.243248] scsi6 : sata_sil24
[    5.245287] scsi7 : sata_sil24
[    5.247256] ata7: SATA max UDMA/100 host m128@0xe0304000 port 0xe0300000 irq 18
[    5.248205] ata8: SATA max UDMA/100 host m128@0xe0304000 port 0xe0302000 irq 18
[    7.228923] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    7.400910] ata7.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    7.401876] ata7.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    7.407950] ata7.00: configured for UDMA/100
[    9.394593] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    9.561003] ata8.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    9.561548] ata8.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.567892] ata8.00: configured for UDMA/100
[    9.568598] scsi 6:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    9.569683] sd 6:0:0:0: [sdg] 586072368 512-byte hardware sectors (300069 MB)
[    9.570561] sd 6:0:0:0: [sdg] Write Protect is off
[    9.571546] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    9.572553] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.573575] sd 6:0:0:0: [sdg] 586072368 512-byte hardware sectors (300069 MB)
[    9.574553] sd 6:0:0:0: [sdg] Write Protect is off
[    9.575545] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    9.575560] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.576546]  sdg: sdg1
[    9.609654] sd 6:0:0:0: [sdg] Attached SCSI disk
[    9.610670] scsi 7:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    9.611677] sd 7:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
[    9.612547] sd 7:0:0:0: [sdh] Write Protect is off
[    9.613540] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    9.613554] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.614566] sd 7:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
[    9.615546] sd 7:0:0:0: [sdh] Write Protect is off
[    9.616539] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    9.616553] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.617539]  sdh: sdh1
[    9.620650] sd 7:0:0:0: [sdh] Attached SCSI disk
[    9.621631] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[    9.622573] PCI: Setting latency timer of device 0000:04:00.0 to 64
[    9.622685] scsi8 : sata_sil24
[    9.623643] scsi9 : sata_sil24
[    9.624621] ata9: SATA max UDMA/100 host m128@0xe0204000 port 0xe0200000 irq 19
[    9.625539] ata10: SATA max UDMA/100 host m128@0xe0204000 port 0xe0202000 irq 19
[   11.684245] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   11.780237] ata9.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   11.781210] ata9.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   11.789115] ata9.00: configured for UDMA/100
[   13.852915] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   13.937011] ata10.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   13.938882] ata10.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   13.945218] ata10.00: configured for UDMA/100
[   13.945947] scsi 8:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   13.947020] sd 8:0:0:0: [sdi] 586072368 512-byte hardware sectors (300069 MB)
[   13.947889] sd 8:0:0:0: [sdi] Write Protect is off
[   13.948881] sd 8:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   13.948895] sd 8:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.949909] sd 8:0:0:0: [sdi] 586072368 512-byte hardware sectors (300069 MB)
[   13.950887] sd 8:0:0:0: [sdi] Write Protect is off
[   13.951880] sd 8:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   13.951894] sd 8:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.952880]  sdi: sdi1
[   13.988990] sd 8:0:0:0: [sdi] Attached SCSI disk
[   13.990005] scsi 9:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   13.991004] sd 9:0:0:0: [sdj] 586072368 512-byte hardware sectors (300069 MB)
[   13.991881] sd 9:0:0:0: [sdj] Write Protect is off
[   13.992874] sd 9:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   13.992889] sd 9:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.993901] sd 9:0:0:0: [sdj] 586072368 512-byte hardware sectors (300069 MB)
[   13.994881] sd 9:0:0:0: [sdj] Write Protect is off
[   13.995873] sd 9:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   13.995887] sd 9:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.996873]  sdj: sdj1
[   14.003988] sd 9:0:0:0: [sdj] Attached SCSI disk
[   14.004964] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   14.006907] PCI: Setting latency timer of device 0000:05:00.0 to 64
[   14.007021] scsi10 : sata_sil24
[   14.007976] scsi11 : sata_sil24
[   14.008943] ata11: SATA max UDMA/100 host m128@0xe0104000 port 0xe0100000 irq 16
[   14.009873] ata12: SATA max UDMA/100 host m128@0xe0104000 port 0xe0102000 irq 16
[   16.144568] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   16.161178] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   16.161544] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   16.167968] ata11.00: configured for UDMA/100
[   18.309238] ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   18.319689] ata12.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   18.320216] ata12.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   18.326309] ata12.00: configured for UDMA/100
[   18.327263] scsi 10:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   18.328352] sd 10:0:0:0: [sdk] 586072368 512-byte hardware sectors (300069 MB)
[   18.329222] sd 10:0:0:0: [sdk] Write Protect is off
[   18.330215] sd 10:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   18.330229] sd 10:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.331252] sd 10:0:0:0: [sdk] 586072368 512-byte hardware sectors (300069 MB)
[   18.332221] sd 10:0:0:0: [sdk] Write Protect is off
[   18.333214] sd 10:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   18.333228] sd 10:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.334214]  sdk: sdk1
[   18.368324] sd 10:0:0:0: [sdk] Attached SCSI disk
[   18.369335] scsi 11:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   18.370336] sd 11:0:0:0: [sdl] 586072368 512-byte hardware sectors (300069 MB)
[   18.371216] sd 11:0:0:0: [sdl] Write Protect is off
[   18.372208] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   18.372223] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.373235] sd 11:0:0:0: [sdl] 586072368 512-byte hardware sectors (300069 MB)
[   18.374215] sd 11:0:0:0: [sdl] Write Protect is off
[   18.375207] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   18.375222] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.376207]  sdl: sdl1
[   18.380321] sd 11:0:0:0: [sdl] Attached SCSI disk
[   18.381333] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   18.382224] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   18.382298] scsi12 : pata_marvell
[   18.383309] scsi13 : pata_marvell
[   18.384281] ata13: PATA max UDMA/100 cmd 0x5018 ctl 0x5024 bmdma 0x5000 irq 17
[   18.385206] ata14: DUMMY
[   18.466560] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
[   18.772535] ata13.00: ATAPI: _NEC DVD_RW ND-3520A, 1.04, max UDMA/33
[   18.930500] ata13.00: configured for UDMA/33
[   18.861800] scsi 12:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520A  1.04 PQ: 0 ANSI: 5
[   18.865373] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   18.866133] Uniform CD-ROM driver Revision: 3.20
[   18.867235] sr 12:0:0:0: Attached scsi CD-ROM sr0
[   18.867611] ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[   18.918810] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0084000-e00847ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   18.919278] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[   18.920130] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   18.920143] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   18.921206] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   18.926036] ehci_hcd 0000:00:1a.7: debug port 1
[   18.926127] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   18.926131] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0625c00
[   18.937125] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   18.938335] usb usb1: configuration #1 chosen from 1 choice
[   18.939201] hub 1-0:1.0: USB hub found
[   18.940135] hub 1-0:1.0: 4 ports detected
[   19.042249] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[   19.043110] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   19.043113] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   19.044174] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   19.049012] ehci_hcd 0000:00:1d.7: debug port 1
[   19.049108] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   19.049114] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0625800
[   19.060107] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   19.062156] usb usb2: configuration #1 chosen from 1 choice
[   19.063169] hub 2-0:1.0: USB hub found
[   19.064106] hub 2-0:1.0: 6 ports detected
[   19.166238] USB Universal Host Controller Interface driver v3.0
[   19.168113] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.169090] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   19.169092] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   19.170155] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   19.171104] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
[   19.172265] usb usb3: configuration #1 chosen from 1 choice
[   19.173151] hub 3-0:1.0: USB hub found
[   19.174089] hub 3-0:1.0: 2 ports detected
[   19.276199] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[   19.277073] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   19.277076] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   19.278138] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   19.279091] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0
[   19.280226] usb usb4: configuration #1 chosen from 1 choice
[   19.281135] hub 4-0:1.0: USB hub found
[   19.282073] hub 4-0:1.0: 2 ports detected
[   19.464056] hub 2-0:1.0: unable to enumerate USB device on port 1
[   19.384175] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[   19.385057] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   19.385059] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   19.386124] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   19.387070] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080
[   19.388214] usb usb5: configuration #1 chosen from 1 choice
[   19.389120] hub 5-0:1.0: USB hub found
[   19.390056] hub 5-0:1.0: 2 ports detected
[   19.672020] hub 2-0:1.0: unable to enumerate USB device on port 4
[   19.492163] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   19.493040] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   19.493043] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   19.494105] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   19.495056] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060
[   19.497094] usb usb6: configuration #1 chosen from 1 choice
[   19.498103] hub 6-0:1.0: USB hub found
[   19.499040] hub 6-0:1.0: 2 ports detected
[   19.601147] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   19.602024] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   19.602026] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   19.603090] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   19.605028] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
[   19.606177] usb usb7: configuration #1 chosen from 1 choice
[   19.607085] hub 7-0:1.0: USB hub found
[   19.608023] hub 7-0:1.0: 2 ports detected
[   19.893981] usb 5-1: new low speed USB device using uhci_hcd and address 2
[   19.710157] Initializing USB Mass Storage driver...
[   19.827405] usb 5-1: configuration #1 chosen from 1 choice
[   20.023123] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090270001c5be9f]
[   20.036960] usb 6-2: new full speed USB device using uhci_hcd and address 2
[   20.196959] usb 6-2: configuration #1 chosen from 1 choice
[   20.203891] hub 6-2:1.0: USB hub found
[   20.204409] hub 6-2:1.0: 3 ports detected
[   20.488800] usb 6-2.1: new full speed USB device using uhci_hcd and address 3
[   20.614902] usb 6-2.1: configuration #1 chosen from 1 choice
[   20.801753] usb 6-2.2: new low speed USB device using uhci_hcd and address 4
[   20.921856] usb 6-2.2: configuration #1 chosen from 1 choice
[   20.928781] usbcore: registered new interface driver usb-storage
[   20.928826] USB Mass Storage support registered.
[   20.930025] PNP: No PS/2 controller found. Probing ports directly.
[   20.933984] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.934820] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.935892] mice: PS/2 mouse device common for all mice
[   21.267717] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   21.347193] coretemp coretemp.0: Using relative temperature scale!
[   21.347866] coretemp coretemp.1: Using relative temperature scale!
[   21.348895] coretemp coretemp.2: Using relative temperature scale!
[   21.349863] coretemp coretemp.3: Using relative temperature scale!
[   21.351816] md: raid0 personality registered for level 0
[   21.352755] md: raid1 personality registered for level 1
[   21.370766] raid6: int64x1   2277 MB/s
[   21.388751] raid6: int64x2   3000 MB/s
[   21.406758] raid6: int64x4   2789 MB/s
[   21.424753] raid6: int64x8   2089 MB/s
[   21.442750] raid6: sse2x1    3730 MB/s
[   21.460752] raid6: sse2x2    4285 MB/s
[   21.478742] raid6: sse2x4    6664 MB/s
[   21.479735] raid6: using algorithm sse2x4 (6664 MB/s)
[   21.480736] md: raid6 personality registered for level 6
[   21.481735] md: raid5 personality registered for level 5
[   21.482735] md: raid4 personality registered for level 4
[   21.483797] usbcore: registered new interface driver hiddev
[   21.880059] hiddev96: USB HID v1.00 Device [        UPS] on usb-0000:00:1d.0-1
[   21.883920] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2.1/6-2.1:1.0/input/input3
[   21.888678] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.1-2.1
[   21.895665] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2.1/6-2.1:1.1/input/input4
[   21.899676] input: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.1-2.1
[   21.913811] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2.2/6-2.2:1.0/input/input5
[   21.918715] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.1-2.2
[   21.919727] usbcore: registered new interface driver usbhid
[   21.920680] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   21.921741] Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
[   21.923773] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   21.924681] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   21.962235] ALSA device list:
[   21.962662]   #0: HDA Intel at 0xe0620000 irq 22
[   21.963692] u32 classifier
[   21.964661]     Actions configured 
[   21.965716] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   21.967776] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.968682] TCP cubic registered
[   21.969680] NET: Registered protocol family 1
[   21.970670] NET: Registered protocol family 17
[   21.971846] RPC: Registered udp transport module.
[   21.972661] RPC: Registered tcp transport module.
[   21.974046] md: Autodetecting RAID arrays.
[   22.130876] md: Scanned 16 and added 16 devices.
[   22.131636] md: autorun ...
[   22.132636] md: considering sdl1 ...
[   22.133639] md:  adding sdl1 ...
[   22.134638] md:  adding sdk1 ...
[   22.135638] md:  adding sdj1 ...
[   22.137637] md:  adding sdi1 ...
[   22.138637] md:  adding sdh1 ...
[   22.139637] md:  adding sdg1 ...
[   22.140637] md:  adding sdf1 ...
[   22.141637] md:  adding sde1 ...
[   22.142637] md:  adding sdd1 ...
[   22.143636] md:  adding sdc1 ...
[   22.144636] md: sdb3 has different UUID to sdl1
[   22.145635] md: sdb2 has different UUID to sdl1
[   22.146635] md: sdb1 has different UUID to sdl1
[   22.147635] md: sda3 has different UUID to sdl1
[   22.148634] md: sda2 has different UUID to sdl1
[   22.149634] md: sda1 has different UUID to sdl1
[   22.151643] md: created md3
[   22.152633] md: bind<sdc1>
[   22.153639] md: bind<sdd1>
[   22.154640] md: bind<sde1>
[   22.155638] md: bind<sdf1>
[   22.156639] md: bind<sdg1>
[   22.157638] md: bind<sdh1>
[   22.158638] md: bind<sdi1>
[   22.159637] md: bind<sdj1>
[   22.160638] md: bind<sdk1>
[   22.161638] md: bind<sdl1>
[   22.162637] md: running: <sdl1><sdk1><sdj1><sdi1><sdh1><sdg1><sdf1><sde1><sdd1><sdc1>
[   22.163652] md: kicking non-fresh sdd1 from array!
[   22.164633] md: unbind<sdd1>
[   22.165633] md: export_rdev(sdd1)
[   22.166637] raid5: device sdl1 operational as raid disk 9
[   22.167631] raid5: device sdk1 operational as raid disk 8
[   22.168631] raid5: device sdj1 operational as raid disk 7
[   22.169630] raid5: device sdi1 operational as raid disk 6
[   22.170630] raid5: device sdh1 operational as raid disk 5
[   22.171630] raid5: device sdg1 operational as raid disk 4
[   22.172630] raid5: device sdf1 operational as raid disk 3
[   22.173630] raid5: device sde1 operational as raid disk 2
[   22.174630] raid5: device sdc1 operational as raid disk 0
[   22.176994] raid5: allocated 10574kB for md3
[   22.177629] raid5: raid level 5 set md3 active with 9 out of 10 devices, algorithm 2
[   22.178629] RAID5 conf printout:
[   22.179629]  --- rd:10 wd:9
[   22.180651]  disk 0, o:1, dev:sdc1
[   22.181629]  disk 2, o:1, dev:sde1
[   22.182629]  disk 3, o:1, dev:sdf1
[   22.183628]  disk 4, o:1, dev:sdg1
[   22.184628]  disk 5, o:1, dev:sdh1
[   22.185628]  disk 6, o:1, dev:sdi1
[   22.186628]  disk 7, o:1, dev:sdj1
[   22.187628]  disk 8, o:1, dev:sdk1
[   22.187629]  disk 9, o:1, dev:sdl1
[   22.190980] md: considering sdb3 ...
[   22.191631] md:  adding sdb3 ...
[   22.192628] md: sdb2 has different UUID to sdb3
[   22.193628] md: sdb1 has different UUID to sdb3
[   22.194629] md:  adding sda3 ...
[   22.195628] md: sda2 has different UUID to sdb3
[   22.196627] md: sda1 has different UUID to sdb3
[   22.197712] md: created md2
[   22.198626] md: bind<sda3>
[   22.199632] md: bind<sdb3>
[   22.200631] md: running: <sdb3><sda3>
[   22.201702] raid1: raid set md2 active with 2 out of 2 mirrors
[   22.202691] md: considering sdb2 ...
[   22.203628] md:  adding sdb2 ...
[   22.204626] md: sdb1 has different UUID to sdb2
[   22.205627] md:  adding sda2 ...
[   22.206626] md: sda1 has different UUID to sdb2
[   22.207703] md: created md1
[   22.208625] md: bind<sda2>
[   22.209630] md: bind<sdb2>
[   22.210629] md: running: <sdb2><sda2>
[   22.212700] raid1: raid set md1 active with 2 out of 2 mirrors
[   22.213690] md: considering sdb1 ...
[   22.214626] md:  adding sdb1 ...
[   22.215626] md:  adding sda1 ...
[   22.216624] md: created md0
[   22.217623] md: bind<sda1>
[   22.218630] md: bind<sdb1>
[   22.219629] md: running: <sdb1><sda1>
[   22.220700] raid1: raid set md0 active with 2 out of 2 mirrors
[   22.221690] md: ... autorun DONE.
[   22.259336] UDF-fs: No VRS found
[   22.259957] Filesystem "md2": Disabling barriers, not supported by the underlying device
[   22.260618] XFS: correcting sb_features alignment problem
[   22.272582] XFS mounting filesystem md2
[   22.377567] Ending clean XFS mount for filesystem: md2
[   22.377598] VFS: Mounted root (xfs filesystem) readonly.
[   22.377609] Freeing unused kernel memory: 256k freed
[   24.720255] Adding 16787768k swap on /dev/md0.  Priority:-1 extents:1 across:16787768k
[   24.824654] Filesystem "md2": Disabling barriers, not supported by the underlying device
[   26.944903] kjournald starting.  Commit interval 5 seconds
[   26.518955] EXT3 FS on md1, internal journal
[   26.518959] EXT3-fs: mounted filesystem with ordered data mode.
[   26.519307] Filesystem "md3": Disabling barriers, not supported by the underlying device
[   26.519447] XFS mounting filesystem md3
[   26.683692] Ending clean XFS mount for filesystem: md3
[   28.560034] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   28.734046] e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   30.053502] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   33.513766] warning: `named' uses 32-bit capabilities (legacy support in use)
[  185.127945] md: bind<sdd1>
[  185.150226] RAID5 conf printout:
[  185.150230]  --- rd:10 wd:9
[  185.150232]  disk 0, o:1, dev:sdc1
[  185.150235]  disk 1, o:1, dev:sdd1
[  185.150238]  disk 2, o:1, dev:sde1
[  185.150241]  disk 3, o:1, dev:sdf1
[  185.150244]  disk 4, o:1, dev:sdg1
[  185.150247]  disk 5, o:1, dev:sdh1
[  185.150250]  disk 6, o:1, dev:sdi1
[  185.150253]  disk 7, o:1, dev:sdj1
[  185.150256]  disk 8, o:1, dev:sdk1
[  185.150258]  disk 9, o:1, dev:sdl1
[  185.053336] md: recovery of RAID array md3
[  185.053361] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  185.053362] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[  185.053371] md: using 128k window, over a total of 293032960 blocks.
[ 5832.879634] md: md3: recovery done.
[ 5833.870866] RAID5 conf printout:
[ 5833.870875]  --- rd:10 wd:10
[ 5833.870878]  disk 0, o:1, dev:sdc1
[ 5833.870882]  disk 1, o:1, dev:sdd1
[ 5833.870885]  disk 2, o:1, dev:sde1
[ 5833.870888]  disk 3, o:1, dev:sdf1
[ 5833.870891]  disk 4, o:1, dev:sdg1
[ 5833.870893]  disk 5, o:1, dev:sdh1
[ 5833.870896]  disk 6, o:1, dev:sdi1
[ 5833.870909]  disk 7, o:1, dev:sdj1
[ 5833.870911]  disk 8, o:1, dev:sdk1
[ 5833.870913]  disk 9, o:1, dev:sdl1
[55164.325258] md: data-check of RAID array md0
[55164.325266] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[55164.325268] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[55164.325271] md: using 128k window, over a total of 16787776 blocks.
[55165.960235] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[55166.383909] md: delaying data-check of md2 until md0 has finished (they share one or more physical units)
[55166.964687] md: delaying data-check of md1 until md2 has finished (they share one or more physical units)
[55167.386914] md: data-check of RAID array md3
[55167.386919] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[55167.386921] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[55167.386928] md: using 128k window, over a total of 293032960 blocks.
[55315.529779] md: md0: data-check done.
[55315.445302] md: delaying data-check of md1 until md2 has finished (they share one or more physical units)
[55315.445319] md: data-check of RAID array md2
[55315.445321] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[55315.445322] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[55315.445327] md: using 128k window, over a total of 276109056 blocks.
[55315.556313] RAID1 conf printout:
[55315.556321]  --- wd:2 rd:2
[55315.556322]  disk 0, wo:0, o:1, dev:sda1
[55315.556324]  disk 1, wo:0, o:1, dev:sdb1
[58682.444937] md: md2: data-check done.
[58682.365721] md: data-check of RAID array md1
[58682.365729] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[58682.365730] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[58682.365734] md: using 128k window, over a total of 136448 blocks.
[58682.485403] RAID1 conf printout:
[58682.485408]  --- wd:2 rd:2
[58682.485420]  disk 0, wo:0, o:1, dev:sda3
[58682.485422]  disk 1, wo:0, o:1, dev:sdb3
[58683.793698] md: md1: data-check done.
[58683.831793] RAID1 conf printout:
[58683.831798]  --- wd:2 rd:2
[58683.831800]  disk 0, wo:0, o:1, dev:sda2
[58683.831801]  disk 1, wo:0, o:1, dev:sdb2
[61891.936511] md: md3: data-check done.
[61893.152803] RAID5 conf printout:
[61893.152812]  --- rd:10 wd:10
[61893.152815]  disk 0, o:1, dev:sdc1
[61893.152817]  disk 1, o:1, dev:sdd1
[61893.152819]  disk 2, o:1, dev:sde1
[61893.152821]  disk 3, o:1, dev:sdf1
[61893.152822]  disk 4, o:1, dev:sdg1
[61893.152824]  disk 5, o:1, dev:sdh1
[61893.152826]  disk 6, o:1, dev:sdi1
[61893.152827]  disk 7, o:1, dev:sdj1
[61893.152829]  disk 8, o:1, dev:sdk1
[61893.152831]  disk 9, o:1, dev:sdl1
[86349.168562] kvm: emulating exchange as write
[87546.433705] apic write: bad size=1 fee00030
[87546.433814] Ignoring de-assert INIT to vcpu 0
[89725.513763] handle_exception: unexpected, vectoring info 0x80000306 intr info 0x80000b0d
[89725.514930] pending exception: not handled yet
[89725.517367] pending exception: not handled yet
[107360.796671] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[107360.796680] ata4.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[107360.796681]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[107360.796685] ata4.00: status: { DRDY }
[107361.099615] ata4: soft resetting link
[107361.252599] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[107361.273562] ata4.00: configured for UDMA/133
[107361.273604] ata4: EH complete
[107361.018520] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[107361.018683] sd 3:0:0:0: [sdd] Write Protect is off
[107361.018687] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[107361.040887] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
