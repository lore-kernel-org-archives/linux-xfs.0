Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IGrcrY222693
	for <linux-xfs@oss.sgi.com>; Fri, 18 May 2012 11:53:39 -0500
Message-ID: <4FB67EA5.20609@canonical.com>
Date: Fri, 18 May 2012 11:53:57 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<loom.20120510T180646-433@post.gmane.org>
	<20120516184231.GK16099@sgi.com> <4FB565C6.8080303@canonical.com>
In-Reply-To: <4FB565C6.8080303@canonical.com>
Content-Type: multipart/mixed; boundary="------------010207090103050302080902"
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-xfs@oss.sgi.com, tinguely@sgi.com

This is a multi-part message in MIME format.
--------------010207090103050302080902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/17/2012 03:55 PM, Chris J Arges wrote:
> On 05/16/2012 01:42 PM, Ben Myers wrote:
>> Hey Chris,
>>
>> On Thu, May 10, 2012 at 04:11:27PM +0000, Chris J Arges wrote:
>>> <snip>
>>>> Canonical attached them to the bug report that they filed yesterday:
>>>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=922
>>>>
>>>> ...Juerg
>>>>
>>>
>>> Hello,
>>> I am able to reproduce this bug with the instructions posted in this bug. Let me 
>>> know what I can do to help.
>>
>> The bug shows:
>>
>> |This has been tested on the following kernels which all exhibit the same
>> |failures:
>> |- 3.2.0-24 (Ubuntu Precise)
>> |- 3.4.0-rc4
>> |- 3.0.29
>> |- 3.1.10
>> |- 3.2.15
>> |- 3.3.2
>>
>> Can you find an older kernel that isn't broken?
>>
> Tested with Ubuntu Lucid 2.6.32-38-generic #38 (upstream 2.6.32.52), so
> far I am able to run the test for 5 hours, which on the same machine I
> have typically been able to reproduce in 2 hours. Will continue to run
> this, and on another system to verify.
> 

Tested with  Ubuntu Lucid 2.6.32-38-generic #38 (upstream 2.6.32.52).
This also fails, attaching the dmesg output as the backtrace looks
similar. Let me know if you'd like me to try any other versions.

The first test I did with lucid, it ran for 7 hours, and I stopped the
test. This morning I re-ran and it failed within 10 minutes. I guess I
got lucky the second time.

> --chris
> 
>> -Ben
>>
> 


--------------010207090103050302080902
Content-Type: text/plain; charset=UTF-8;
 name="lucid-2.6.32-xfs-hang.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lucid-2.6.32-xfs-hang.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-38-generic (buildd@allspice) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #83-Ubuntu SMP Wed Jan 4 11:12:07 UTC 2012 (Ubuntu 2.6.32-38.83-generic 2.6.32.52+drm33.21)
[    0.000000] Command line: noprompt cdrom-detect/try-usb=true file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.lz quiet splash -- BOOT_IMAGE=/casper/vmlinuz 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000da99f000 (usable)
[    0.000000]  BIOS-e820: 00000000da99f000 - 00000000dae9f000 (reserved)
[    0.000000]  BIOS-e820: 00000000dae9f000 - 00000000daf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000daf9f000 - 00000000dafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dafff000 - 00000000db000000 (usable)
[    0.000000]  BIOS-e820: 00000000db000000 - 00000000dfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd20000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021e600000 (usable)
[    0.000000]  BIOS-e820: 000000021e600000 - 000000021e800000 (reserved)
[    0.000000] DMI 2.6 present.
[    0.000000] last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21F000000 mask FFF000000 uncachable
[    0.000000]   9 base 21E800000 mask FFF800000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009d800 (usable)
[    0.000000]  modified: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  modified: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  modified: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  modified: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  modified: 0000000040200000 - 00000000da99f000 (usable)
[    0.000000]  modified: 00000000da99f000 - 00000000dae9f000 (reserved)
[    0.000000]  modified: 00000000dae9f000 - 00000000daf9f000 (ACPI NVS)
[    0.000000]  modified: 00000000daf9f000 - 00000000dafff000 (ACPI data)
[    0.000000]  modified: 00000000dafff000 - 00000000db000000 (usable)
[    0.000000]  modified: 00000000db000000 - 00000000dfa00000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  modified: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffd20000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000021e600000 (usable)
[    0.000000]  modified: 000000021e600000 - 000000021e800000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000db000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 00db000000 page 2M
[    0.000000] kernel direct mapping tables up to db000000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-000000021e600000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0100000000 - 021e600000 page 2M
[    0.000000] kernel direct mapping tables up to 21e600000 @ b000-15000
[    0.000000] RAMDISK: 1f690000 - 1fffe884
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe120 000AC (v01 LENOVO TP-8D    00001250 PTEC 00000002)
[    0.000000] ACPI: FACP 00000000dafe7000 000F4 (v04 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafea000 0F6A7 (v01 LENOVO TP-8D    00001250 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf2d000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 LENOVO TP-8D    00001250 PTEC 00000001)
[    0.000000] ACPI: SSDT 00000000daffc000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 007D1 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe6000 00038 (v01 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe5000 00098 (v01 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe4000 0003C (v01 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe3000 00052 (v01 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafe9000 000A5 (v32 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: TCPA 00000000dafe2000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000dafe1000 00A27 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafe0000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafdf000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafde000 0003E (v01 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafdd000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 00000000dafdc000 00292 (v01 LENOVO TP-8D    00001250 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000021e600000
[    0.000000] Bootmem setup node 0 0000000000000000-000000021e600000
[    0.000000]   NODE_DATA [0000000000010000 - 0000000000014fff]
[    0.000000]   bootmap [0000000000015000 -  0000000000058cbf] pages 44
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 021e600000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001a35ac4]    TEXT DATA BSS ==> [0001000000 - 0001a35ac4]
[    0.000000]   #3 [001f690000 - 001fffe884]          RAMDISK ==> [001f690000 - 001fffe884]
[    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
[    0.000000]   #5 [0001a36000 - 0001a360ed]              BRK ==> [0001a36000 - 0001a360ed]
[    0.000000]   #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #7 [000000b000 - 0000010000]          PGTABLE ==> [000000b000 - 0000010000]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff88002c600000-ffff8800337fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021e600
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000da99f
[    0.000000]     0: 0x000dafff -> 0x000db000
[    0.000000]     0: 0x00100000 -> 0x0021e600
[    0.000000] On node 0 totalpages: 2067256
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 109 pages reserved
[    0.000000]   DMA zone: 3827 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 875992 pages, LIFO batch:31
[    0.000000]   Normal zone: 16037 pages used for memmap
[    0.000000]   Normal zone: 1156955 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000da99f000 - 00000000dae9f000
[    0.000000] PM: Registered nosave memory: 00000000dae9f000 - 00000000daf9f000
[    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
[    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
[    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
[    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd20000
[    0.000000] PM: Registered nosave memory: 00000000ffd20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dfa00000 (gap: dfa00000:18600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff88002c200000 s91608 r8192 d23080 u262144
[    0.000000] pcpu-alloc: s91608 r8192 d23080 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2036774
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: noprompt cdrom-detect/try-usb=true file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.lz quiet splash -- BOOT_IMAGE=/casper/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880024000000 - ffff880028000000
[    0.000000] software IO TLB at phys 0x24000000 - 0x28000000
[    0.000000] Memory: 8064904k/8886272k available (5436k kernel code, 617248k absent, 204120k reserved, 2982k data, 884k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 83886080 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2491.853 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4983.70 BogoMIPS (lpj=24918530)
[    0.000017] Security Framework initialized
[    0.000028] AppArmor: AppArmor initialized
[    0.000595] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002213] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002888] Mount-cache hash table entries: 256
[    0.002970] Initializing cgroup subsys ns
[    0.002973] Initializing cgroup subsys cpuacct
[    0.002975] Initializing cgroup subsys memory
[    0.002979] Initializing cgroup subsys devices
[    0.002981] Initializing cgroup subsys freezer
[    0.002983] Initializing cgroup subsys net_cls
[    0.002997] CPU: Physical Processor ID: 0
[    0.002998] CPU: Processor Core ID: 0
[    0.003002] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003003] CPU: L2 cache: 256K
[    0.003004] CPU: L3 cache: 3072K
[    0.003007] CPU 0/0x0 -> Node 0
[    0.003009] mce: CPU supports 7 MCE banks
[    0.003019] CPU0: Thermal monitoring enabled (TM1)
[    0.003021] CPU 0 MCA banks CMCI:0 CMCI:1 CMCI:3 CMCI:5 CMCI:6
[    0.003030] using mwait in idle threads.
[    0.003031] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.003035] ... version:                3
[    0.003036] ... bit width:              48
[    0.003037] ... generic registers:      4
[    0.003038] ... value mask:             0000ffffffffffff
[    0.003040] ... max period:             000000007fffffff
[    0.003041] ... fixed-purpose events:   3
[    0.003042] ... event mask:             000000070000000f
[    0.005291] ACPI: Core revision 20090903
[    0.023306] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.023309] ftrace: allocating 22567 entries in 89 pages
[    0.031442] Not enabling x2apic, Intr-remapping init failed.
[    0.031445] Setting APIC routing to flat
[    0.031789] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.131568] CPU0: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.247700] Booting processor 1 APIC 0x1 ip 0x6000
[    0.258022] Initializing CPU#1
[    0.407246] CPU: Physical Processor ID: 0
[    0.407248] CPU: Processor Core ID: 0
[    0.407250] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.407252] CPU: L2 cache: 256K
[    0.407253] CPU: L3 cache: 3072K
[    0.407256] CPU 1/0x1 -> Node 0
[    0.407268] CPU1: Thermal monitoring enabled (TM1)
[    0.407270] CPU 1 MCA banks SHD:0 SHD:1 SHD:3 SHD:5 SHD:6
[    0.407348] CPU1: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.407357] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.427385] Booting processor 2 APIC 0x2 ip 0x6000
[    0.437684] Initializing CPU#2
[    0.586837] CPU: Physical Processor ID: 0
[    0.586838] CPU: Processor Core ID: 1
[    0.586840] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.586842] CPU: L2 cache: 256K
[    0.586842] CPU: L3 cache: 3072K
[    0.586844] CPU 2/0x2 -> Node 0
[    0.586855] CPU2: Thermal monitoring enabled (TM1)
[    0.586857] CPU 2 MCA banks CMCI:0 CMCI:1 CMCI:3 SHD:5 SHD:6
[    0.586914] CPU2: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.586921] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.606946] Booting processor 3 APIC 0x3 ip 0x6000
[    0.617245] Initializing CPU#3
[    0.766427] CPU: Physical Processor ID: 0
[    0.766428] CPU: Processor Core ID: 1
[    0.766430] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.766431] CPU: L2 cache: 256K
[    0.766432] CPU: L3 cache: 3072K
[    0.766434] CPU 3/0x3 -> Node 0
[    0.766444] CPU3: Thermal monitoring enabled (TM1)
[    0.766446] CPU 3 MCA banks SHD:0 SHD:1 SHD:3 SHD:5 SHD:6
[    0.766469] CPU3: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.766476] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.786448] Brought up 4 CPUs
[    0.786449] Total of 4 processors activated (19935.08 BogoMIPS).
[    0.788648] CPU0 attaching sched-domain:
[    0.788651]  domain 0: span 0-1 level SIBLING
[    0.788653]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[    0.788657]   domain 1: span 0-3 level MC
[    0.788658]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[    0.788664] CPU1 attaching sched-domain:
[    0.788665]  domain 0: span 0-1 level SIBLING
[    0.788666]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[    0.788670]   domain 1: span 0-3 level MC
[    0.788671]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[    0.788674] CPU2 attaching sched-domain:
[    0.788676]  domain 0: span 2-3 level SIBLING
[    0.788677]   groups: 2 (cpu_power = 589) 3 (cpu_power = 589)
[    0.788680]   domain 1: span 0-3 level MC
[    0.788681]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[    0.788685] CPU3 attaching sched-domain:
[    0.788686]  domain 0: span 2-3 level SIBLING
[    0.788687]   groups: 3 (cpu_power = 589) 2 (cpu_power = 589)
[    0.788690]   domain 1: span 0-3 level MC
[    0.788692]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[    0.788883] devtmpfs: initialized
[    0.789117] regulator: core version 0.5
[    0.789141] Time: 16:40:10  Date: 05/18/12
[    0.789171] NET: Registered protocol family 16
[    0.789240] Trying to unpack rootfs image as initramfs...
[    0.789252] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.789254] ACPI: bus type pci registered
[    0.789472] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.789474] PCI: MCFG area at f8000000 reserved in E820
[    0.791029] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.791030] PCI: Using configuration type 1 for base access
[    0.791609] bio: create slab <bio-0> at 0
[    0.792672] ACPI: EC: EC description table is found, configuring boot EC
[    0.798776] ACPI: BIOS _OSI(Linux) query ignored
[    0.802120] ACPI: Interpreter enabled
[    0.802123] ACPI: (supports S0 S3 S4 S5)
[    0.802144] ACPI: Using IOAPIC for interrupt routing
[    0.808802] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.808966] ACPI: Power Resource [PUBS] (on)
[    0.810841] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.811028] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.811095] pci 0000:00:02.0: reg 10 64bit mmio: [0xf0000000-0xf03fffff]
[    0.811100] pci 0000:00:02.0: reg 18 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.811103] pci 0000:00:02.0: reg 20 io port: [0x5000-0x503f]
[    0.811176] pci 0000:00:16.0: reg 10 64bit mmio: [0xf2525000-0xf252500f]
[    0.811222] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.811226] pci 0000:00:16.0: PME# disabled
[    0.811277] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2500000-0xf251ffff]
[    0.811283] pci 0000:00:19.0: reg 14 32bit mmio: [0xf252b000-0xf252bfff]
[    0.811289] pci 0000:00:19.0: reg 18 io port: [0x5080-0x509f]
[    0.811327] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.811331] pci 0000:00:19.0: PME# disabled
[    0.811378] pci 0000:00:1a.0: reg 10 32bit mmio: [0xf252a000-0xf252a3ff]
[    0.811431] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.811435] pci 0000:00:1a.0: PME# disabled
[    0.811475] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2520000-0xf2523fff]
[    0.811516] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.811520] pci 0000:00:1b.0: PME# disabled
[    0.811587] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.811591] pci 0000:00:1c.0: PME# disabled
[    0.811659] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.811663] pci 0000:00:1c.1: PME# disabled
[    0.811733] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.811736] pci 0000:00:1c.3: PME# disabled
[    0.811839] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.811842] pci 0000:00:1c.4: PME# disabled
[    0.811904] pci 0000:00:1d.0: reg 10 32bit mmio: [0xf2529000-0xf25293ff]
[    0.811956] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.811960] pci 0000:00:1d.0: PME# disabled
[    0.812094] pci 0000:00:1f.2: reg 10 io port: [0x50a8-0x50af]
[    0.812100] pci 0000:00:1f.2: reg 14 io port: [0x50bc-0x50bf]
[    0.812106] pci 0000:00:1f.2: reg 18 io port: [0x50a0-0x50a7]
[    0.812111] pci 0000:00:1f.2: reg 1c io port: [0x50b8-0x50bb]
[    0.812117] pci 0000:00:1f.2: reg 20 io port: [0x5060-0x507f]
[    0.812123] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2528000-0xf25287ff]
[    0.812152] pci 0000:00:1f.2: PME# supported from D3hot
[    0.812156] pci 0000:00:1f.2: PME# disabled
[    0.812184] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2524000-0xf25240ff]
[    0.812197] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.812359] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2400000-0xf2401fff]
[    0.812486] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.812493] pci 0000:03:00.0: PME# disabled
[    0.812562] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2400000-0xf24fffff]
[    0.812605] pci 0000:00:1c.3: bridge io port: [0x4000-0x4fff]
[    0.812609] pci 0000:00:1c.3: bridge 32bit mmio: [0xf1c00000-0xf23fffff]
[    0.812615] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf0400000-0xf0bfffff]
[    0.812837] pci 0000:0d:00.0: reg 10 32bit mmio: [0xf1400000-0xf14000ff]
[    0.812953] pci 0000:0d:00.0: supports D1 D2
[    0.812954] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.812960] pci 0000:0d:00.0: PME# disabled
[    0.813039] pci 0000:00:1c.4: bridge io port: [0x3000-0x3fff]
[    0.813043] pci 0000:00:1c.4: bridge 32bit mmio: [0xf1400000-0xf1bfffff]
[    0.813052] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xf0c00000-0xf13fffff]
[    0.813077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.813199] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.813255] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.813309] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.813372] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.816139] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.816293] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    0.816447] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.816596] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.816743] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.816880] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.817026] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.817173] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.817270] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.817276] vgaarb: loaded
[    0.817351] SCSI subsystem initialized
[    0.817434] libata version 3.00 loaded.
[    0.817490] usbcore: registered new interface driver usbfs
[    0.817497] usbcore: registered new interface driver hub
[    0.817517] usbcore: registered new device driver usb
[    0.817633] ACPI: WMI: Mapper loaded
[    0.817634] PCI: Using ACPI for IRQ routing
[    0.818034] NetLabel: Initializing
[    0.818035] NetLabel:  domain hash size = 128
[    0.818036] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.818045] NetLabel:  unlabeled traffic allowed by default
[    0.818079] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.818084] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.820093] Switching to clocksource tsc
[    2.689543] AppArmor: AppArmor Filesystem Enabled
[    2.689555] pnp: PnP ACPI init
[    2.689567] ACPI: bus type pnp registered
[    2.691958] pnp: PnP ACPI: found 11 devices
[    2.691961] ACPI: ACPI bus type pnp unregistered
[    2.691976] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    2.691978] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    2.691980] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    2.691982] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    2.691984] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    2.691985] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    2.691987] system 00:00: iomem range 0xd4000-0xd7fff has been reserved
[    2.691992] system 00:00: iomem range 0xd8000-0xdbfff has been reserved
[    2.691994] system 00:00: iomem range 0xdc000-0xdffff has been reserved
[    2.691996] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    2.691998] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    2.691999] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    2.692001] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    2.692003] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    2.692005] system 00:00: iomem range 0x100000-0xdf9fffff could not be reserved
[    2.692008] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    2.692010] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    2.692018] system 00:02: ioport range 0x400-0x47f has been reserved
[    2.692020] system 00:02: ioport range 0x500-0x57f has been reserved
[    2.692022] system 00:02: ioport range 0x800-0x80f has been reserved
[    2.692024] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    2.692026] system 00:02: ioport range 0x1600-0x167f has been reserved
[    2.692028] system 00:02: iomem range 0xf8000000-0xfbffffff has been reserved
[    2.692030] system 00:02: iomem range 0x0-0xfff could not be reserved
[    2.692052] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    2.692054] system 00:02: iomem range 0xfed10000-0xfed13fff has been reserved
[    2.692056] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    2.692059] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    2.692061] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    2.696756] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    2.696758] pci 0000:00:1c.0:   IO window: disabled
[    2.696763] pci 0000:00:1c.0:   MEM window: disabled
[    2.696767] pci 0000:00:1c.0:   PREFETCH window: disabled
[    2.696774] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    2.696775] pci 0000:00:1c.1:   IO window: disabled
[    2.696780] pci 0000:00:1c.1:   MEM window: 0xf2400000-0xf24fffff
[    2.696784] pci 0000:00:1c.1:   PREFETCH window: disabled
[    2.696790] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    2.696793] pci 0000:00:1c.3:   IO window: 0x4000-0x4fff
[    2.696798] pci 0000:00:1c.3:   MEM window: 0xf1c00000-0xf23fffff
[    2.696803] pci 0000:00:1c.3:   PREFETCH window: 0x000000f0400000-0x000000f0bfffff
[    2.696809] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
[    2.696813] pci 0000:00:1c.4:   IO window: 0x3000-0x3fff
[    2.696819] pci 0000:00:1c.4:   MEM window: 0xf1400000-0xf1bfffff
[    2.696824] pci 0000:00:1c.4:   PREFETCH window: 0x000000f0c00000-0x000000f13fffff
[    2.696844]   alloc irq_desc for 16 on node -1
[    2.696846]   alloc kstat_irqs on node -1
[    2.696852] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.696859] pci 0000:00:1c.0: setting latency timer to 64
[    2.696868]   alloc irq_desc for 17 on node -1
[    2.696870]   alloc kstat_irqs on node -1
[    2.696872] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.696876] pci 0000:00:1c.1: setting latency timer to 64
[    2.696885]   alloc irq_desc for 19 on node -1
[    2.696886]   alloc kstat_irqs on node -1
[    2.696888] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.696892] pci 0000:00:1c.3: setting latency timer to 64
[    2.696903] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.696908] pci 0000:00:1c.4: setting latency timer to 64
[    2.696912] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.696914] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    2.696916] pci_bus 0000:03: resource 1 mem: [0xf2400000-0xf24fffff]
[    2.696918] pci_bus 0000:05: resource 0 io:  [0x4000-0x4fff]
[    2.696919] pci_bus 0000:05: resource 1 mem: [0xf1c00000-0xf23fffff]
[    2.696921] pci_bus 0000:05: resource 2 pref mem [0xf0400000-0xf0bfffff]
[    2.696923] pci_bus 0000:0d: resource 0 io:  [0x3000-0x3fff]
[    2.696924] pci_bus 0000:0d: resource 1 mem: [0xf1400000-0xf1bfffff]
[    2.696926] pci_bus 0000:0d: resource 2 pref mem [0xf0c00000-0xf13fffff]
[    2.696951] NET: Registered protocol family 2
[    2.697145] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    2.698847] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.700221] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.700376] TCP: Hash tables configured (established 524288 bind 65536)
[    2.700378] TCP reno registered
[    2.700452] NET: Registered protocol family 1
[    2.700464] pci 0000:00:02.0: Boot video device
[    2.700752] Scanning for low memory corruption every 60 seconds
[    2.700847] audit: initializing netlink socket (disabled)
[    2.700854] type=2000 audit(1337359212.553:1): initialized
[    2.707785] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.708756] VFS: Disk quotas dquot_6.5.2
[    2.708794] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.709181] fuse init (API version 7.13)
[    2.709235] msgmni has been set to 15751
[    2.709399] alg: No test for stdrng (krng)
[    2.709436] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.709438] io scheduler noop registered
[    2.709439] io scheduler anticipatory registered
[    2.709440] io scheduler deadline registered
[    2.709481] io scheduler cfq registered (default)
[    2.709587]   alloc irq_desc for 24 on node -1
[    2.709589]   alloc kstat_irqs on node -1
[    2.709599] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    2.709609] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.709708]   alloc irq_desc for 25 on node -1
[    2.709709]   alloc kstat_irqs on node -1
[    2.709716] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    2.709724] pcieport 0000:00:1c.1: setting latency timer to 64
[    2.709821]   alloc irq_desc for 26 on node -1
[    2.709822]   alloc kstat_irqs on node -1
[    2.709829] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    2.709837] pcieport 0000:00:1c.3: setting latency timer to 64
[    2.709968]   alloc irq_desc for 27 on node -1
[    2.709970]   alloc kstat_irqs on node -1
[    2.709979] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    2.709990] pcieport 0000:00:1c.4: setting latency timer to 64
[    2.710079] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.710092] Firmware did not grant requested _OSC control
[    2.710111] Firmware did not grant requested _OSC control
[    2.710134] Firmware did not grant requested _OSC control
[    2.710149] Firmware did not grant requested _OSC control
[    2.710163] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.710355] ACPI: AC Adapter [AC] (on-line)
[    2.710408] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    2.710569] ACPI: Lid Switch [LID]
[    2.710596] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    2.710600] ACPI: Sleep Button [SLPB]
[    2.710634] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.710636] ACPI: Power Button [PWRF]
[    2.711402] ACPI: SSDT 00000000dae8c018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    2.712328] processor LNXCPU:00: registered as cooling_device0
[    2.712749] ACPI: SSDT 00000000dae8da98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    2.713173] ACPI: SSDT 00000000dae8bd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    2.714024] processor LNXCPU:01: registered as cooling_device1
[    2.974193] processor LNXCPU:02: registered as cooling_device2
[    2.975242] processor LNXCPU:03: registered as cooling_device3
[    2.977488] Freeing initrd memory: 9658k freed
[    2.979467] thermal LNXTHERM:01: registered as thermal_zone0
[    2.979474] ACPI: Thermal Zone [THM0] (64 C)
[    2.981085] Linux agpgart interface v0.103
[    2.981107] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.982442] brd: module loaded
[    2.982881] loop: module loaded
[    2.982960] input: Macintosh mouse button emulation as /devices/virtual/input/input3
[    2.983444] Fixed MDIO Bus: probed
[    2.983512] PPP generic driver version 2.4.2
[    2.983533] tun: Universal TUN/TAP device driver, 1.6
[    2.983534] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.983631] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.984871] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    2.986671] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    2.986679] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.986714] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.986736] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.986792] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.986821] ehci_hcd 0000:00:1a.0: debug port 2
[    2.990694] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
[    2.990707] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf252a000
[    2.994328] ACPI: Battery Slot [BAT0] (battery present)
[    3.007668] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.007819] usb usb1: configuration #1 chosen from 1 choice
[    3.007838] hub 1-0:1.0: USB hub found
[    3.007844] hub 1-0:1.0: 3 ports detected
[    3.008079] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.008241] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.008247]   alloc irq_desc for 23 on node -1
[    3.008249]   alloc kstat_irqs on node -1
[    3.008253] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.008263] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.008266] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.008291] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.008314] ehci_hcd 0000:00:1d.0: debug port 2
[    3.012191] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
[    3.012201] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf2529000
[    3.027616] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.027761] usb usb2: configuration #1 chosen from 1 choice
[    3.027777] hub 2-0:1.0: USB hub found
[    3.027781] hub 2-0:1.0: 3 ports detected
[    3.027815] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.027823] uhci_hcd: USB Universal Host Controller Interface driver
[    3.027865] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.031439] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.031444] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.031512] mice: PS/2 mouse device common for all mice
[    3.031586] rtc_cmos 00:07: RTC can wake from S4
[    3.031612] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.031639] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.031715] device-mapper: uevent: version 1.0.3
[    3.031779] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    3.031845] device-mapper: multipath: version 1.1.0 loaded
[    3.031847] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.032059] cpuidle: using governor ladder
[    3.032169] cpuidle: using governor menu
[    3.032378] TCP cubic registered
[    3.032476] NET: Registered protocol family 10
[    3.032920] NET: Registered protocol family 17
[    3.035676] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    3.040284] PM: Resume from disk failed.
[    3.040292] registered taskstats version 1
[    3.040711]   Magic number: 12:176:692
[    3.040792] rtc_cmos 00:07: setting system clock to 2012-05-18 16:40:13 UTC (1337359213)
[    3.040794] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.040795] EDD information not available.
[    3.040858] Freeing unused kernel memory: 884k freed
[    3.040957] Write protecting the kernel read-only data: 7716k
[    3.052794] udev: starting version 151
[    3.064733] vga16fb: initializing
[    3.064736] vga16fb: mapped to 0xffff8800000a0000
[    3.064779] fb0: VGA16 VGA frame buffer device
[    3.069101] ahci 0000:00:1f.2: version 3.0
[    3.069118] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.069163]   alloc irq_desc for 28 on node -1
[    3.069165]   alloc kstat_irqs on node -1
[    3.069175] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    3.069203] ahci: SSS flag set, parallel bus scan disabled
[    3.087539] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
[    3.087543] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    3.087549] ahci 0000:00:1f.2: setting latency timer to 64
[    3.128065] scsi0 : ahci
[    3.128162] scsi1 : ahci
[    3.128215] scsi2 : ahci
[    3.128267] scsi3 : ahci
[    3.128317] scsi4 : ahci
[    3.128363] scsi5 : ahci
[    3.129401] ata1: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528100 irq 28
[    3.129404] ata2: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528180 irq 28
[    3.129405] ata3: DUMMY
[    3.129406] ata4: DUMMY
[    3.129408] ata5: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528300 irq 28
[    3.129409] ata6: DUMMY
[    3.161700] Console: switching to colour frame buffer device 80x30
[    3.327618] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    3.477234] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.477242] usb 1-1: configuration #1 chosen from 1 choice
[    3.477334] hub 1-1:1.0: USB hub found
[    3.477468] hub 1-1:1.0: 6 ports detected
[    3.478134] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.478137] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.478139] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.479017] ata1.00: ATA-8: HITACHI HTS723232A7A364, EC2ZB70R, max UDMA/100
[    3.479026] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.480131] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.480139] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.480146] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.480995] ata1.00: configured for UDMA/100
[    3.506732] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72323 EC2Z PQ: 0 ANSI: 5
[    3.506855] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.506877] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    3.506916] sd 0:0:0:0: [sda] Write Protect is off
[    3.506918] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.506930] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.507003]  sda:
[    3.606332] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.756652] usb 2-1: configuration #1 chosen from 1 choice
[    3.756855] hub 2-1:1.0: USB hub found
[    3.756921] hub 2-1:1.0: 8 ports detected
[    3.835931] usb 1-1.3: new full speed USB device using ehci_hcd and address 3
[    3.835972]  sda1 sda2 < sda5 > sda3
[    3.860292] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.875737] ata2: SATA link down (SStatus 0 SControl 300)
[    3.956971] usb 1-1.3: configuration #1 chosen from 1 choice
[    4.045430] usb 1-1.6: new high speed USB device using ehci_hcd and address 4
[    4.171817] usb 1-1.6: configuration #1 chosen from 1 choice
[    4.244894] ata5: SATA link down (SStatus 0 SControl 300)
[    4.245135] usb 2-1.2: new high speed USB device using ehci_hcd and address 3
[    4.366453] usb 2-1.2: configuration #1 chosen from 1 choice
[    4.370262] Initializing USB Mass Storage driver...
[    4.370442] scsi6 : SCSI emulation for USB Mass Storage devices
[    4.370545] usb-storage: device found at 3
[    4.370546] usb-storage: waiting for device to settle before scanning
[    4.370553] usbcore: registered new interface driver usb-storage
[    4.370555] USB Mass Storage support registered.
[    4.727336] xor: automatically using best checksumming function: generic_sse
[    4.774230]    generic_sse: 14178.800 MB/sec
[    4.774232] xor: using function: generic_sse (14178.800 MB/sec)
[    4.775554] device-mapper: dm-raid45: initialized v0.2594b
[    4.989448] EXT4-fs (sda1): mounted filesystem with ordered data mode
[    9.353456] usb-storage: device scan complete
[    9.353975] scsi 6:0:0:0: Direct-Access     Real-Way RW8021 PENDRIVE  1.0  PQ: 0 ANSI: 2
[    9.354686] sd 6:0:0:0: Attached scsi generic sg1 type 0
[    9.355404] sd 6:0:0:0: [sdb] 2004992 512-byte logical blocks: (1.02 GB/979 MiB)
[    9.356006] sd 6:0:0:0: [sdb] Write Protect is off
[    9.356013] sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[    9.356018] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    9.358354] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    9.358362]  sdb: sdb1
[    9.361517] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    9.361529] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    9.757460] aufs 2-standalone.tree-20091207
[    9.766680] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   17.825928] udev: starting version 151
[   18.125424] cfg80211: Calling CRDA to update world regulatory domain
[   18.209240] Linux video capture interface: v2.00
[   18.274884] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b217)
[   18.275312] Non-volatile memory driver v1.3
[   18.276577] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input5
[   18.276616] usbcore: registered new interface driver uvcvideo
[   18.276618] USB Video Class driver (v0.1.0)
[   18.332858] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27k
[   18.332860] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   18.332905] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   18.332913] iwlagn 0000:03:00.0: setting latency timer to 64
[   18.332954] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 1000 Series BGN REV=0x6C
[   18.340168] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[   18.341325] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   18.341328] thinkpad_acpi: http://ibm-acpi.sf.net/
[   18.341329] thinkpad_acpi: ThinkPad BIOS 8DET55WW (1.25 ), EC unknown
[   18.341331] thinkpad_acpi: Lenovo ThinkPad X220, model 42872WU
[   18.341920] thinkpad_acpi: radio switch found; radios are enabled
[   18.342176] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[   18.342457] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   18.342459] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   18.350832] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[   18.351738] Registered led device: tpacpi::thinklight
[   18.351849] Registered led device: tpacpi::power
[   18.352149] Registered led device: tpacpi::standby
[   18.352268] Registered led device: tpacpi::thinkvantage
[   18.352544] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   18.353091] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   18.357607] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[   18.366035] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
[   18.366089]   alloc irq_desc for 29 on node -1
[   18.366091]   alloc kstat_irqs on node -1
[   18.366107] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[   18.385167] cfg80211: World regulatory domain updated:
[   18.385170] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   18.385173] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   18.385175] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   18.385177] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   18.385179] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   18.385181] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   18.421475] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   18.479524] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-1000-3.ucode
[   18.533209] iwlagn 0000:03:00.0: loaded firmware version 128.50.3.1
[   18.614789]   alloc irq_desc for 22 on node -1
[   18.614792]   alloc kstat_irqs on node -1
[   18.614798] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   18.614849] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   18.626989] Registered led device: iwl-phy0::radio
[   18.627041] Registered led device: iwl-phy0::assoc
[   18.627055] Registered led device: iwl-phy0::RX
[   18.627081] Registered led device: iwl-phy0::TX
[   18.652850] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   18.757860] lp: driver loaded but no devices found
[   18.769510] ppdev: user-space parallel port driver
[   18.801947] Unable to query Synaptics hardware.
[   18.831644] usb 1-1.4: new full speed USB device using ehci_hcd and address 5
[   18.946926] usb 1-1.4: configuration #1 chosen from 1 choice
[   18.972175] Bluetooth: Core ver 2.15
[   18.972229] NET: Registered protocol family 31
[   18.972231] Bluetooth: HCI device and connection manager initialized
[   18.972233] Bluetooth: HCI socket layer initialized
[   18.988322] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   18.988773] usbcore: registered new interface driver btusb
[   19.044668] Bluetooth: L2CAP ver 2.14
[   19.044670] Bluetooth: L2CAP socket layer initialized
[   19.104588] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   19.104590] Bluetooth: BNEP filters: protocol multicast
[   19.153873] Bridge firewalling registered
[   19.170539] Bluetooth: SCO (Voice Link) ver 0.6
[   19.170541] Bluetooth: SCO socket layer initialized
[   19.245834] Bluetooth: RFCOMM TTY layer initialized
[   19.245839] Bluetooth: RFCOMM socket layer initialized
[   19.245840] Bluetooth: RFCOMM ver 1.11
[   19.351209] CPU0 attaching NULL sched-domain.
[   19.351214] CPU1 attaching NULL sched-domain.
[   19.351217] CPU2 attaching NULL sched-domain.
[   19.351219] CPU3 attaching NULL sched-domain.
[   19.376986] input: PS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   19.422107] CPU0 attaching sched-domain:
[   19.422110]  domain 0: span 0-1 level SIBLING
[   19.422112]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   19.422115]   domain 1: span 0-3 level MC
[   19.422116]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   19.422120] CPU1 attaching sched-domain:
[   19.422121]  domain 0: span 0-1 level SIBLING
[   19.422123]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   19.422125]   domain 1: span 0-3 level MC
[   19.422126]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   19.422130] CPU2 attaching sched-domain:
[   19.422131]  domain 0: span 2-3 level SIBLING
[   19.422132]   groups: 2 (cpu_power = 589) 3 (cpu_power = 589)
[   19.422134]   domain 1: span 0-3 level MC
[   19.422135]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   19.422138] CPU3 attaching sched-domain:
[   19.422139]  domain 0: span 2-3 level SIBLING
[   19.422140]   groups: 3 (cpu_power = 589) 2 (cpu_power = 589)
[   19.422143]   domain 1: span 0-3 level MC
[   19.422144]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   19.422403] CPU0 attaching NULL sched-domain.
[   19.422405] CPU1 attaching NULL sched-domain.
[   19.422406] CPU2 attaching NULL sched-domain.
[   19.422407] CPU3 attaching NULL sched-domain.
[   19.471883] CPU0 attaching sched-domain:
[   19.471886]  domain 0: span 0-1 level SIBLING
[   19.471889]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   19.471894]   domain 1: span 0-3 level MC
[   19.471896]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   19.471902] CPU1 attaching sched-domain:
[   19.471904]  domain 0: span 0-1 level SIBLING
[   19.471906]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   19.471911]   domain 1: span 0-3 level MC
[   19.471912]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   19.471918] CPU2 attaching sched-domain:
[   19.471919]  domain 0: span 2-3 level SIBLING
[   19.471921]   groups: 2 (cpu_power = 589) 3 (cpu_power = 589)
[   19.471926]   domain 1: span 0-3 level MC
[   19.471928]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   19.471933] CPU3 attaching sched-domain:
[   19.471934]  domain 0: span 2-3 level SIBLING
[   19.471936]   groups: 3 (cpu_power = 589) 2 (cpu_power = 589)
[   19.471941]   domain 1: span 0-3 level MC
[   19.471942]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   23.838033] CPU0 attaching NULL sched-domain.
[   23.838036] CPU1 attaching NULL sched-domain.
[   23.838037] CPU2 attaching NULL sched-domain.
[   23.838039] CPU3 attaching NULL sched-domain.
[   23.890608] CPU0 attaching sched-domain:
[   23.890611]  domain 0: span 0-1 level SIBLING
[   23.890613]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   23.890616]   domain 1: span 0-3 level MC
[   23.890617]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   23.890622] CPU1 attaching sched-domain:
[   23.890623]  domain 0: span 0-1 level SIBLING
[   23.890624]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   23.890627]   domain 1: span 0-3 level MC
[   23.890628]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   23.890631] CPU2 attaching sched-domain:
[   23.890632]  domain 0: span 2-3 level SIBLING
[   23.890633]   groups: 2 (cpu_power = 589) 3 (cpu_power = 589)
[   23.890636]   domain 1: span 0-3 level MC
[   23.890637]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   23.890640] CPU3 attaching sched-domain:
[   23.890641]  domain 0: span 2-3 level SIBLING
[   23.890642]   groups: 3 (cpu_power = 589) 2 (cpu_power = 589)
[   23.890645]   domain 1: span 0-3 level MC
[   23.890646]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   23.890907] CPU0 attaching NULL sched-domain.
[   23.890909] CPU1 attaching NULL sched-domain.
[   23.890910] CPU2 attaching NULL sched-domain.
[   23.890911] CPU3 attaching NULL sched-domain.
[   23.950560] CPU0 attaching sched-domain:
[   23.950564]  domain 0: span 0-1 level SIBLING
[   23.950567]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   23.950572]   domain 1: span 0-3 level MC
[   23.950574]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   23.950581] CPU1 attaching sched-domain:
[   23.950583]  domain 0: span 0-1 level SIBLING
[   23.950585]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   23.950589]   domain 1: span 0-3 level MC
[   23.950591]    groups: 0-1 (cpu_power = 1178) 2-3 (cpu_power = 1178)
[   23.950597] CPU2 attaching sched-domain:
[   23.950598]  domain 0: span 2-3 level SIBLING
[   23.950600]   groups: 2 (cpu_power = 589) 3 (cpu_power = 589)
[   23.950605]   domain 1: span 0-3 level MC
[   23.950607]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   23.950612] CPU3 attaching sched-domain:
[   23.950614]  domain 0: span 2-3 level SIBLING
[   23.950616]   groups: 3 (cpu_power = 589) 2 (cpu_power = 589)
[   23.950620]   domain 1: span 0-3 level MC
[   23.950622]    groups: 2-3 (cpu_power = 1178) 0-1 (cpu_power = 1178)
[   71.172915] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   71.173819] SGI XFS Quota Management subsystem
[   71.241675] XFS mounting filesystem sda3
[   71.602949] Ending clean XFS mount for filesystem: sda3
[  242.149938] INFO: task copy-files:3386 blocked for more than 120 seconds.
[  242.149946] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.149951] copy-files    D 0000000000000000     0  3386   3337 0x00000000
[  242.149961]  ffff880214b17c88 0000000000000086 0000000000015c00 0000000000015c00
[  242.149970]  ffff880208e43198 ffff880214b17fd8 0000000000015c00 ffff880208e42de0
[  242.149978]  0000000000015c00 ffff880214b17fd8 0000000000015c00 ffff880208e43198
[  242.149986] Call Trace:
[  242.150027]  [<ffffffffa034d103>] xlog_grant_log_space+0x173/0x3f0 [xfs]
[  242.150055]  [<ffffffffa035fa4a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
[  242.150066]  [<ffffffff8105cd70>] ? default_wake_function+0x0/0x20
[  242.150095]  [<ffffffffa034d454>] xfs_log_reserve+0xd4/0xe0 [xfs]
[  242.150124]  [<ffffffffa0357b20>] xfs_trans_reserve+0xa0/0x210 [xfs]
[  242.150151]  [<ffffffffa035ca45>] xfs_free_eofblocks+0x185/0x2a0 [xfs]
[  242.150179]  [<ffffffffa035d578>] xfs_release+0x128/0x1f0 [xfs]
[  242.150207]  [<ffffffffa0364f35>] xfs_file_release+0x15/0x20 [xfs]
[  242.150217]  [<ffffffff81145ea5>] __fput+0xf5/0x210
[  242.150225]  [<ffffffff81145fe5>] fput+0x25/0x30
[  242.150232]  [<ffffffff8114210d>] filp_close+0x5d/0x90
[  242.150239]  [<ffffffff811421f7>] sys_close+0xb7/0x120
[  242.150249]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.150255] INFO: task copy-files:3387 blocked for more than 120 seconds.
[  242.150259] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.150263] copy-files    D 0000000000000000     0  3387   3337 0x00000000
[  242.150271]  ffff8802149cbd38 0000000000000086 0000000000015c00 0000000000015c00
[  242.150279]  ffff880208e44888 ffff8802149cbfd8 0000000000015c00 ffff880208e444d0
[  242.150286]  0000000000015c00 ffff8802149cbfd8 0000000000015c00 ffff880208e44888
[  242.150293] Call Trace:
[  242.150304]  [<ffffffff81546477>] __mutex_lock_slowpath+0xf7/0x180
[  242.150313]  [<ffffffff81145c1a>] ? get_empty_filp+0x7a/0x170
[  242.150321]  [<ffffffff8154635b>] mutex_lock+0x2b/0x50
[  242.150329]  [<ffffffff81152d49>] do_filp_open+0x3d9/0xba0
[  242.150336]  [<ffffffff81148b74>] ? cp_new_stat+0xe4/0x100
[  242.150345]  [<ffffffff8115e7fa>] ? alloc_fd+0x10a/0x150
[  242.150352]  [<ffffffff811422c9>] do_sys_open+0x69/0x170
[  242.150359]  [<ffffffff81142410>] sys_open+0x20/0x30
[  242.150367]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.150373] INFO: task copy-files:3390 blocked for more than 120 seconds.
[  242.150377] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.150381] copy-files    D 0000000000000000     0  3390   3337 0x00000000
[  242.150388]  ffff880212051c88 0000000000000086 0000000000015c00 0000000000015c00
[  242.150395]  ffff8801ed7903b8 ffff880212051fd8 0000000000015c00 ffff8801ed790000
[  242.150403]  0000000000015c00 ffff880212051fd8 0000000000015c00 ffff8801ed7903b8
[  242.150410] Call Trace:
[  242.150438]  [<ffffffffa034d103>] xlog_grant_log_space+0x173/0x3f0 [xfs]
[  242.150465]  [<ffffffffa035fa4a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
[  242.150472]  [<ffffffff8105cd70>] ? default_wake_function+0x0/0x20
[  242.150500]  [<ffffffffa034d454>] xfs_log_reserve+0xd4/0xe0 [xfs]
[  242.150529]  [<ffffffffa0357b20>] xfs_trans_reserve+0xa0/0x210 [xfs]
[  242.150556]  [<ffffffffa035ca45>] xfs_free_eofblocks+0x185/0x2a0 [xfs]
[  242.150583]  [<ffffffffa035d578>] xfs_release+0x128/0x1f0 [xfs]
[  242.150610]  [<ffffffffa0364f35>] xfs_file_release+0x15/0x20 [xfs]
[  242.150618]  [<ffffffff81145ea5>] __fput+0xf5/0x210
[  242.150626]  [<ffffffff81145fe5>] fput+0x25/0x30
[  242.150632]  [<ffffffff8114210d>] filp_close+0x5d/0x90
[  242.150639]  [<ffffffff811421f7>] sys_close+0xb7/0x120
[  242.150647]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.150653] INFO: task copy-files:3391 blocked for more than 120 seconds.
[  242.150657] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.150661] copy-files    D 00000000ffffffff     0  3391   3337 0x00000000
[  242.150668]  ffff880208eafd38 0000000000000086 0000000000015c00 0000000000015c00
[  242.150675]  ffff8802103ec888 ffff880208eaffd8 0000000000015c00 ffff8802103ec4d0
[  242.150683]  0000000000015c00 ffff880208eaffd8 0000000000015c00 ffff8802103ec888
[  242.150690] Call Trace:
[  242.150699]  [<ffffffff81546477>] __mutex_lock_slowpath+0xf7/0x180
[  242.150707]  [<ffffffff81145c1a>] ? get_empty_filp+0x7a/0x170
[  242.150715]  [<ffffffff8154635b>] mutex_lock+0x2b/0x50
[  242.150723]  [<ffffffff81152d49>] do_filp_open+0x3d9/0xba0
[  242.150729]  [<ffffffff81148b74>] ? cp_new_stat+0xe4/0x100
[  242.150737]  [<ffffffff8115e7fa>] ? alloc_fd+0x10a/0x150
[  242.150744]  [<ffffffff811422c9>] do_sys_open+0x69/0x170
[  242.150751]  [<ffffffff81142410>] sys_open+0x20/0x30
[  242.150759]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.150765] INFO: task copy-files:3394 blocked for more than 120 seconds.
[  242.150768] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.150773] copy-files    D ffff8801f2b08f10     0  3394   3337 0x00000000
[  242.150780]  ffff8801ed697d38 0000000000000086 0000000000015c00 0000000000015c00
[  242.150787]  ffff88021402c888 ffff8801ed697fd8 0000000000015c00 ffff88021402c4d0
[  242.150794]  0000000000015c00 ffff8801ed697fd8 0000000000015c00 ffff88021402c888
[  242.150801] Call Trace:
[  242.150809]  [<ffffffff81546477>] __mutex_lock_slowpath+0xf7/0x180
[  242.150818]  [<ffffffff8154635b>] mutex_lock+0x2b/0x50
[  242.150825]  [<ffffffff81152d49>] do_filp_open+0x3d9/0xba0
[  242.150831]  [<ffffffff81148b74>] ? cp_new_stat+0xe4/0x100
[  242.150839]  [<ffffffff8115e7fa>] ? alloc_fd+0x10a/0x150
[  242.150846]  [<ffffffff811422c9>] do_sys_open+0x69/0x170
[  242.150853]  [<ffffffff81142410>] sys_open+0x20/0x30
[  242.150861]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.150866] INFO: task copy-files:3395 blocked for more than 120 seconds.
[  242.150870] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.150874] copy-files    D 0000000000000000     0  3395   3337 0x00000000
[  242.150881]  ffff8801ed68f7a8 0000000000000086 0000000000015c00 0000000000015c00
[  242.150888]  ffff880214b44888 ffff8801ed68ffd8 0000000000015c00 ffff880214b444d0
[  242.150895]  0000000000015c00 ffff8801ed68ffd8 0000000000015c00 ffff880214b44888
[  242.150902] Call Trace:
[  242.150930]  [<ffffffffa034d103>] xlog_grant_log_space+0x173/0x3f0 [xfs]
[  242.150957]  [<ffffffffa035fa4a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
[  242.150963]  [<ffffffff8105cd70>] ? default_wake_function+0x0/0x20
[  242.150991]  [<ffffffffa034d454>] xfs_log_reserve+0xd4/0xe0 [xfs]
[  242.151019]  [<ffffffffa0357b20>] xfs_trans_reserve+0xa0/0x210 [xfs]
[  242.151048]  [<ffffffffa0357e8f>] ? xfs_trans_alloc+0x9f/0xb0 [xfs]
[  242.151077]  [<ffffffffa03472cc>] xfs_iomap_write_allocate+0x25c/0x3c0 [xfs]
[  242.151107]  [<ffffffffa0358929>] ? xfs_trans_unlocked_item+0x39/0x60 [xfs]
[  242.151136]  [<ffffffffa0347f8b>] xfs_iomap+0x2ab/0x2e0 [xfs]
[  242.151163]  [<ffffffffa036067d>] xfs_map_blocks+0x2d/0x40 [xfs]
[  242.151190]  [<ffffffffa0361a7a>] xfs_page_state_convert+0x3da/0x720 [xfs]
[  242.151200]  [<ffffffff812b9f05>] ? radix_tree_gang_lookup_tag_slot+0x95/0xe0
[  242.151209]  [<ffffffff810f4581>] ? generic_perform_write+0x161/0x1d0
[  242.151235]  [<ffffffffa0361f2a>] xfs_vm_writepage+0x7a/0x130 [xfs]
[  242.151244]  [<ffffffff8110e0f5>] ? __dec_zone_page_state+0x35/0x40
[  242.151253]  [<ffffffff810fcf07>] __writepage+0x17/0x40
[  242.151259]  [<ffffffff810fe08f>] write_cache_pages+0x1df/0x3e0
[  242.151268]  [<ffffffff810fcef0>] ? __writepage+0x0/0x40
[  242.151275]  [<ffffffff810fe2b4>] generic_writepages+0x24/0x30
[  242.151301]  [<ffffffffa0360d1d>] xfs_vm_writepages+0x5d/0x80 [xfs]
[  242.151307]  [<ffffffff810fe2e1>] do_writepages+0x21/0x40
[  242.151315]  [<ffffffff810f556b>] __filemap_fdatawrite_range+0x5b/0x60
[  242.151323]  [<ffffffff810f589f>] filemap_fdatawrite+0x1f/0x30
[  242.151349]  [<ffffffffa0365199>] xfs_flush_pages+0xa9/0xc0 [xfs]
[  242.151375]  [<ffffffffa035d5cf>] xfs_release+0x17f/0x1f0 [xfs]
[  242.151401]  [<ffffffffa0364f35>] xfs_file_release+0x15/0x20 [xfs]
[  242.151410]  [<ffffffff81145ea5>] __fput+0xf5/0x210
[  242.151417]  [<ffffffff81145fe5>] fput+0x25/0x30
[  242.151424]  [<ffffffff8114210d>] filp_close+0x5d/0x90
[  242.151431]  [<ffffffff811421f7>] sys_close+0xb7/0x120
[  242.151439]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.151445] INFO: task copy-files:3398 blocked for more than 120 seconds.
[  242.151449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.151453] copy-files    D 0000000000000000     0  3398   3337 0x00000000
[  242.151460]  ffff8801ed4adc88 0000000000000086 0000000000015c00 0000000000015c00
[  242.151467]  ffff8802105b9aa8 ffff8801ed4adfd8 0000000000015c00 ffff8802105b96f0
[  242.151474]  0000000000015c00 ffff8801ed4adfd8 0000000000015c00 ffff8802105b9aa8
[  242.151481] Call Trace:
[  242.151509]  [<ffffffffa034d103>] xlog_grant_log_space+0x173/0x3f0 [xfs]
[  242.151535]  [<ffffffffa035fa4a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
[  242.151542]  [<ffffffff8105cd70>] ? default_wake_function+0x0/0x20
[  242.151570]  [<ffffffffa034d454>] xfs_log_reserve+0xd4/0xe0 [xfs]
[  242.151599]  [<ffffffffa0357b20>] xfs_trans_reserve+0xa0/0x210 [xfs]
[  242.151625]  [<ffffffffa035ca45>] xfs_free_eofblocks+0x185/0x2a0 [xfs]
[  242.151652]  [<ffffffffa035d578>] xfs_release+0x128/0x1f0 [xfs]
[  242.151679]  [<ffffffffa0364f35>] xfs_file_release+0x15/0x20 [xfs]
[  242.151687]  [<ffffffff81145ea5>] __fput+0xf5/0x210
[  242.151694]  [<ffffffff81145fe5>] fput+0x25/0x30
[  242.151701]  [<ffffffff8114210d>] filp_close+0x5d/0x90
[  242.151728]  [<ffffffff811421f7>] sys_close+0xb7/0x120
[  242.151737]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.151743] INFO: task copy-files:3399 blocked for more than 120 seconds.
[  242.151746] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.151751] copy-files    D 0000000000000000     0  3399   3337 0x00000000
[  242.151758]  ffff8802149afd38 0000000000000086 0000000000015c00 0000000000015c00
[  242.151765]  ffff8802105bb198 ffff8802149affd8 0000000000015c00 ffff8802105bade0
[  242.151776]  0000000000015c00 ffff8802149affd8 0000000000015c00 ffff8802105bb198
[  242.151794] Call Trace:
[  242.151806]  [<ffffffff81546477>] __mutex_lock_slowpath+0xf7/0x180
[  242.151818]  [<ffffffff81145c1a>] ? get_empty_filp+0x7a/0x170
[  242.151831]  [<ffffffff8154635b>] mutex_lock+0x2b/0x50
[  242.151843]  [<ffffffff81152d49>] do_filp_open+0x3d9/0xba0
[  242.151853]  [<ffffffff81148b74>] ? cp_new_stat+0xe4/0x100
[  242.151866]  [<ffffffff8115e7fa>] ? alloc_fd+0x10a/0x150
[  242.151878]  [<ffffffff811422c9>] do_sys_open+0x69/0x170
[  242.151890]  [<ffffffff81142410>] sys_open+0x20/0x30
[  242.151902]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.151912] INFO: task copy-files:3401 blocked for more than 120 seconds.
[  242.151919] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.151928] copy-files    D 0000000000000001     0  3401   3337 0x00000008
[  242.151942]  ffff8801ed4efcf8 0000000000000086 0000000000015c00 0000000000015c00
[  242.151960]  ffff8802105bdf78 ffff8801ed4effd8 0000000000015c00 ffff8802105bdbc0
[  242.151978]  0000000000015c00 ffff8801ed4effd8 0000000000015c00 ffff8802105bdf78
[  242.151995] Call Trace:
[  242.152006]  [<ffffffff81546477>] __mutex_lock_slowpath+0xf7/0x180
[  242.152019]  [<ffffffff8154635b>] mutex_lock+0x2b/0x50
[  242.152030]  [<ffffffff8114e923>] lock_rename+0xd3/0xe0
[  242.152043]  [<ffffffff81151d13>] sys_renameat+0x113/0x280
[  242.152055]  [<ffffffff81155280>] ? filldir+0x0/0xe0
[  242.152069]  [<ffffffff81145fe5>] ? fput+0x25/0x30
[  242.152080]  [<ffffffff8114210d>] ? filp_close+0x5d/0x90
[  242.152092]  [<ffffffff81151e9b>] sys_rename+0x1b/0x20
[  242.152104]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
[  242.152113] INFO: task copy-files:3402 blocked for more than 120 seconds.
[  242.152121] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.152129] copy-files    D 0000000000000000     0  3402   3337 0x00000000
[  242.152143]  ffff880208e09c88 0000000000000086 0000000000015c00 0000000000015c00
[  242.152161]  ffff8801ed6b03b8 ffff880208e09fd8 0000000000015c00 ffff8801ed6b0000
[  242.152178]  0000000000015c00 ffff880208e09fd8 0000000000015c00 ffff8801ed6b03b8
[  242.152196] Call Trace:
[  242.152227]  [<ffffffffa034d103>] xlog_grant_log_space+0x173/0x3f0 [xfs]
[  242.152258]  [<ffffffffa035fa4a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
[  242.152270]  [<ffffffff8105cd70>] ? default_wake_function+0x0/0x20
[  242.152302]  [<ffffffffa034d454>] xfs_log_reserve+0xd4/0xe0 [xfs]
[  242.152335]  [<ffffffffa0357b20>] xfs_trans_reserve+0xa0/0x210 [xfs]
[  242.152367]  [<ffffffffa035ca45>] xfs_free_eofblocks+0x185/0x2a0 [xfs]
[  242.152398]  [<ffffffffa035d578>] xfs_release+0x128/0x1f0 [xfs]
[  242.152429]  [<ffffffffa0364f35>] xfs_file_release+0x15/0x20 [xfs]
[  242.152442]  [<ffffffff81145ea5>] __fput+0xf5/0x210
[  242.152454]  [<ffffffff81145fe5>] fput+0x25/0x30
[  242.152464]  [<ffffffff8114210d>] filp_close+0x5d/0x90
[  242.152475]  [<ffffffff811421f7>] sys_close+0xb7/0x120
[  242.152488]  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b

--------------010207090103050302080902
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------010207090103050302080902--
