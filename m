Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 08:20:08 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5EFK1Wt012426
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 08:20:02 -0700
Message-ID: <46715C80.7010402@dgreaves.com>
Date: Thu, 14 Jun 2007 16:19:28 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com>
In-Reply-To: <46714ECF.8080203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linus Torvalds <torvalds@linux-foundation.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>

Tejun Heo wrote:
> They're waiting for the commands they issued to complete.  ata_aux is
> trying to revalidate the scsi device after libata EH finished waking up
> the port and hibernate is trying to resume scsi disk device.  ata_aux is
> issuing either TEST UNIT READY or START STOP.  hibernate is issuing
> START STOP.
> 
> This can be caused by one of the followings.
> 
> 1. SCSI EH thread (ATA EH runs off it) for the SCSI device hasn't
> finished yet.  All commands are deferred while EH is in progress.
> 
> 2. request_queue is stuck - somehow somebody forgot to kick the queue at
> some point.
> 
> 3. command is stuck somewhere in SCSI/ATA land.
> 
> #1 doesn't seem to be the case as all scsi_eh threads seems idle.  I'm
> looking at the code but can't find anything which could cause #2 or #3.
>  Also, these code paths are traveled really frequently.
> 
> I'm also trying to reproduce the problem here with xfs over RAID-6 array
> but haven't been successful yet.
> 
> David, do you store the hibernation image on the RAID-6 array?
No, swap is on a pata disk.

>  Can you post the captured kernel log when it locks up?

Sure... this was still on the serial terminal screen from the sysrq-t trace from 
this morning:

[run hibernate script here]

swsusp: Basic memory bitmaps created
Stopping tasks ... done.
Shrinking memory... done (0 pages freed)
Freed 0 kbytes in 0.04 seconds (0.00 MB/s)
sd 5:0:0:0: [sdf] Synchronizing SCSI cache
sd 4:0:0:0: [sde] Synchronizing SCSI cache
sd 3:0:0:0: [sdd] Synchronizing SCSI cache
sd 2:0:0:0: [sdc] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Synchronizing SCSI cache
pnp: Device 00:09 disabled.
pnp: Device 00:08 activated.
pnp: Device 00:09 activated.
pnp: Failed to activate device 00:0a.
pnp: Failed to activate device 00:0b.
ATA: abnormal status 0x7F on port 0x0001a407
ATA: abnormal status 0x7F on port 0x0001a407
ATA: abnormal status 0x7F on port 0x0001b007
ATA: abnormal status 0x7F on port 0x0001b007
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: configured for UDMA/133
sd 0:0:0:0: [sda] Starting disk
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
sd 1:0:0:0: [sdb] Starting disk
sd 2:0:0:0: [sdc] Starting disk
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: configured for UDMA/133
sd 3:0:0:0: [sdd] Starting disk
sd 4:0:0:0: [sde] Starting disk
sd 5:0:0:0: [sdf] Starting disk
sd 4:0:0:0: [sde] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 5:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
Saving image data pages (36338 pages) ...  19%<6>skge eth0: Link is up at 1000 
Mbps, full duplex, flow control both
done
Wrote 145352 kbytes in 8.49 seconds (17.12 MB/s)
S|
md: stopping all md devices.
md: md0 still in use.
sd 5:0:0:0: [sdf] Synchronizing SCSI cache
sd 5:0:0:0: [sdf] Stopping disk
sd 4:0:0:0: [sde] Synchronizing SCSI cache
sd 4:0:0:0: [sde] Stopping disk
sd 3:0:0:0: [sdd] Synchronizing SCSI cache
sd 3:0:0:0: [sdd] Stopping disk
sd 2:0:0:0: [sdc] Synchronizing SCSI cache
sd 2:0:0:0: [sdc] Stopping disk
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Stopping disk
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
Shutdown: hdb
Shutdown: hda
ACPI: PCI interrupt for device 0000:00:09.0 disabled

[power off/on]

Linux version 2.6.21-g9666f400-dirty (root@cu.dgreaves.com) (gcc version 3.3.5 
(Debian 1:3.3.5-13)) #23 Wed Jun 13 22:51:26 BST 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009c400 (usable)
  BIOS-e820: 000000000009c400 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003fffc000 (usable)
  BIOS-e820: 000000003fffc000 - 000000003ffff000 (ACPI data)
  BIOS-e820: 000000003ffff000 - 0000000040000000 (ACPI NVS)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->   262140
early_node_map[1] active PFN ranges
     0:        0 ->   262140
DMI 2.3 present.
ACPI: RSDP 000F62A0, 0014 (r0 ASUS  )
ACPI: RSDT 3FFFC000, 0030 (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: FACP 3FFFC0B2, 0074 (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: DSDT 3FFFC126, 2C4F (r1   ASUS A7V600       1000 MSFT  100000B)
ACPI: FACS 3FFFF000, 0040
ACPI: BOOT 3FFFC030, 0028 (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: APIC 3FFFC058, 005A (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:10 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists.  Total pages: 260093
Kernel command line: root=/dev/hda2 ro log_buf_len=128k console=tty0 
console=ttyS0,115200
log_buf_len: 131072
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1999.872 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1034872k/1048560k available (2459k kernel code, 13036k reserved, 915k 
data, 196k init, 131056k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc044e000 - 0xc047f000   ( 196 kB)
       .data : 0xc0366dc7 - 0xc044bb90   ( 915 kB)
       .text : 0xc0100000 - 0xc0366dc7   (2459 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4003.08 BogoMIPS (lpj=8006174)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(TM) MP stepping 00
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf1970, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: enabled onboard AC97/MC97 devices
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 *6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12) *15, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x3fffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:02: ioport range 0xe400-0xe47f has been reserved
pnp: 00:02: ioport range 0xe800-0xe81f has been reserved
pnp: 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
pnp: 00:02: iomem range 0xffb80000-0xffbfffff has been reserved
pnp: 00:0d: ioport range 0x290-0x297 has been reserved
pnp: 00:0d: ioport range 0x370-0x375 has been reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x3a set to 0x1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
SGI XFS with ACLs, no debug enabled
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: Bypassing VIA 8237 APIC De-Assert Message
atyfb: using auxiliary register aperture
atyfb: 3D RAGE II+ (Mach64 GU) [0x4755 rev 0x9a]
atyfb: Mach64 BIOS is located at c0000, mapped at c00c0000.
atyfb: BIOS frequency table:
atyfb: PCLK_min_freq 926, PCLK_max_freq 22216, ref_freq 1432, ref_divider 33
atyfb: MCLK_pwd 4200, MCLK_max_freq 6000, XCLK_max_freq 6000, SCLK_freq 5000
atyfb: 4M EDO, 14.31818 MHz XTAL, 222 MHz PLL, 60 Mhz MCLK, 60 MHz XCLK
Console: switching to colour frame buffer device 80x30
atyfb: fb0: ATY Mach64 frame buffer device on PCI
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PCI: Enabling device 0000:00:09.0 (0014 -> 0017)
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 18 (level, low) -> IRQ 16
skge 1.11 addr 0xf6000000 irq 16 chip Yukon rev 1
skge eth0: addr 00:0c:6e:f6:47:ee
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:0f.1
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 17
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
     ide0: BM-DMA at 0x9000-0x9007, BIOS settings: hda:DMA, hdb:DMA
     ide1: BM-DMA at 0x9008-0x900f, BIOS settings: hdc:pio, hdd:DMA
Switched to high resolution mode on CPU 0
hda: ST320420A, ATA DISK drive
hdb: Maxtor 5A300J0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdd: PLEXTOR CD-R PX-W2410A, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 39851760 sectors (20404 MB) w/2048KiB Cache, CHS=39535/16/63, UDMA(66)
hda: cache flushes not supported
  hda: hda1 hda2 hda3
hdb: max request size: 512KiB
hdb: 585940320 sectors (300001 MB) w/2048KiB Cache, CHS=36473/255/63, UDMA(133)
hdb: cache flushes supported
  hdb: hdb1 hdb2
hdd: ATAPI 40X CD-ROM CD-R/RW drive, 4096kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 16 (level, low) -> IRQ 18
scsi0 : sata_promise
scsi1 : sata_promise
scsi2 : sata_promise
scsi3 : sata_promise
ata1: SATA max UDMA/133 cmd 0xf880a200 ctl 0xf880a238 bmdma 0x00000000 irq 0
ata2: SATA max UDMA/133 cmd 0xf880a280 ctl 0xf880a2b8 bmdma 0x00000000 irq 0
ata3: SATA max UDMA/133 cmd 0xf880a300 ctl 0xf880a338 bmdma 0x00000000 irq 0
ata4: SATA max UDMA/133 cmd 0xf880a380 ctl 0xf880a3b8 bmdma 0x00000000 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata1.00: ATA-7: Maxtor 6B250S0, BANC19J0, max UDMA/133
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata2.00: ATA-7: Maxtor 7Y250M0, YAR51EW0, max UDMA/133
ata2.00: 490234752 sectors, multi 0: LBA48
ata2.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata2.00: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata3.00: ATA-7: Maxtor 7Y250M0, YAR51EW0, max UDMA/133
ata3.00: 490234752 sectors, multi 0: LBA48
ata3.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata4.00: ATA-7: Maxtor 6B250S0, BANC1980, max UDMA/133
ata4.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata4.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6B250S0   BANC PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 7Y250M0   YAR5 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 7Y250M0   YAR5 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 2:0:0:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6B250S0   BANC PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 3:0:0:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 17
sata_via 0000:00:0f.0: routed to hard irq line 0
scsi4 : sata_via
scsi5 : sata_via
ata5: SATA max UDMA/133 cmd 0x0001b000 ctl 0x0001a802 bmdma 0x00019800 irq 0
ata6: SATA max UDMA/133 cmd 0x0001a400 ctl 0x0001a002 bmdma 0x00019808 irq 0
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0x0001b007
ATA: abnormal status 0x7F on port 0x0001b007
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: ATA-7: Maxtor 7B250S0, BANC1980, max UDMA/133
ata5.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: configured for UDMA/133
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0x0001a407
ATA: abnormal status 0x7F on port 0x0001a407
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: ATA-7: ST3400620AS, 3.AAK, max UDMA/133
ata6.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 7B250S0   BANC PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 4:0:0:0: [sde] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sde: sde1
sd 4:0:0:0: [sde] Attached SCSI disk
scsi 5:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
sd 5:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 5:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdf: sdf1 sdf2
sd 5:0:0:0: [sdf] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
raid6: int32x1    636 MB/s
raid6: int32x2    787 MB/s
raid6: int32x4    627 MB/s
raid6: int32x8    606 MB/s
raid6: mmxx1     1583 MB/s
raid6: mmxx2     2557 MB/s
raid6: sse1x1    1592 MB/s
raid6: sse1x2    2631 MB/s
raid6: using algorithm sse1x2 (2631 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  4289.000 MB/sec
raid5: using function: pIII_sse (4289.000 MB/sec)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
TCP cubic registered
Using IPI Shortcut mode
swsusp: Basic memory bitmaps created
Stopping tasks ... <6>input: ImPS/2 Logitech Wheel Mouse as /class/input/input3
done.
Loading image data pages (36338 pages) ... done
Read 145352 kbytes in 8.34 seconds (17.42 MB/s)
sd 5:0:0:0: [sdf] Synchronizing SCSI cache
sd 4:0:0:0: [sde] Synchronizing SCSI cache
sd 3:0:0:0: [sdd] Synchronizing SCSI cache
sd 2:0:0:0: [sdc] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Synchronizing SCSI cache
pnp: Device 00:09 disabled.
pnp: Device 00:08 activated.
pnp: Device 00:09 activated.
pnp: Failed to activate device 00:0a.
pnp: Failed to activate device 00:0b.
sd 0:0:0:0: [sda] Starting disk
sd 1:0:0:0: [sdb] Starting disk
sd 2:0:0:0: [sdc] Starting disk
sd 3:0:0:0: [sdd] Starting disk
sd 4:0:0:0: [sde] Starting disk
ATA: abnormal status 0x7F on port 0x0001b007
ATA: abnormal status 0x7F on port 0x0001b007
ATA: abnormal status 0x7F on port 0x0001a407
ATA: abnormal status 0x7F on port 0x0001a407
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: configured for UDMA/133
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: configured for UDMA/133
Clocksource tsc unstable (delta = 4327743507262 ns)
Time: acpi_pm clocksource has been installed.
skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
