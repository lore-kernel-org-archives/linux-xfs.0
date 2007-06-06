Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Jun 2007 03:39:40 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l56AdXWt012234
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2007 03:39:34 -0700
Message-ID: <46668EE0.2030509@dgreaves.com>
Date: Wed, 06 Jun 2007 11:39:28 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>
In-Reply-To: <46667160.80905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tejun Heo <htejun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Tejun Heo wrote:
> Hello,
> 
> David Greaves wrote:
>> Linus Torvalds wrote:
>>> It would be interesting to see what triggered it, since it apparently 
>>> worked before. So yes, a bisection would be great.
>> Tejun, all the problematic patches are yours - so adding you.
> 
> Ouch....
<grin> that's what everyone says!

Just to be clear. This problem is where my system won't resume after s2d unless 
I umount my xfs over raid6 filesystem.

>> given the first patch identified is
>> 9666f4009c22f6520ac3fb8a19c9e32ab973e828: "libata: reimplement suspend/resume
>> support using sdev->manage_start_stop"
>> That seems a good candidate...
> 
> 9ce3075c20d458040138690edfdf6446664ec3ee works, right?
Yes
git reset --hard ec4883b015c3212f6f6d04fb2ff45f528492f598
vi Makefile
make oldconfig
make && make install && make modules_install && update-grub
init 6

>  Can you test
> 9666f4009c22f6520ac3fb8a19c9e32ab973e828 by removing
> ata_scsi_device_suspend/resume callbacks from sata_via.c?   Just delete
> all lines referencing those two functions.  There were one or two
> fallouts from the conversion.

Yes, after I posted I realised that Andrews patch fixed the compile failure :)

git reset --hard 9666f4009c22f6520ac3fb8a19c9e32ab973e828

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 939c924..bad87b5 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -117,8 +117,6 @@ static struct scsi_host_template svia_sht = {
         .slave_destroy          = ata_scsi_slave_destroy,
         .bios_param             = ata_std_bios_param,
  #ifdef CONFIG_PM
-       .suspend                = ata_scsi_device_suspend,
-       .resume                 = ata_scsi_device_resume,
  #endif
  };

So now this compiles but it does cause the problem:

umount /huge
echo platform > /sys/power/disk
echo disk > /sys/power/state
# resumes fine

mount /huge
echo platform > /sys/power/disk
echo disk > /sys/power/state
# won't resume

FWIW, /huge is:
/dev/md0 on /huge type xfs (rw)
cu:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
md0 : active raid6 sdf1[0] sde1[1] sdd1[2] sdc1[3] sdb1[4] sda1[5] hdb1[6]
       1225557760 blocks level 6, 256k chunk, algorithm 2 [7/7] [UUUUUUU]
       bitmap: 0/234 pages [0KB], 512KB chunk

unused devices: <none>

> 
> How many drives do you have?
8 in total
2 pata : VIA vt8237
2 sata on sata_via
4 sata on sata_promise
+1 pata cdrom

   Behavior difference introduced by the
> reimplementation is serialization of resume sequence, so it takes more
> time.  My test machine had problems resuming if resume took too long
> even with the previous implementation.  It didn't matter whether the
> long resuming sequence is caused by too many controllers or explicit
> ssleep().  If time needed for resume sequence is over certain threshold,
> machine hangs while resuming.  I thought it was a BIOS glitch and didn't
> dig into it but you might be seeing the same issue.
given the mount/umount thing this sounds unlikely... but what do I know?

resume does throw up:
ATA: abnormal status 0x7F on port 0x0001b007
ATA: abnormal status 0x7F on port 0x0001b007
ATA: abnormal status 0x7F on port 0x0001a407
ATA: abnormal status 0x7F on port 0x0001a407

which I've not noticed before... oh, alright, I'll check...
reboots to 2.6.21, suspend, resume...
nope, not output on resume in 2.6.21


> Please post dmesg too.  Thanks.
> 

Here is:
  dmesg from 2.6.22-9666f4009c22f6520ac3fb8a19c9e32ab973e828 (ie with sata_via fix)
  dmesg from resume of above when /huge is unmounted
  dmesg from resume of 2.6.21

Linux version 2.6.21-TejunTst2-g9666f400-dirty (root@cu.dgreaves.com) (gcc 
version 3.3.5 (Debian 1:3.3.5-13)) #13 Wed Jun 6 10:16:03 BST 2007
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
Entering add_active_range(0, 0, 262140) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->   262140
early_node_map[1] active PFN ranges
     0:        0 ->   262140
On node 0 totalpages: 262140
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 255 pages used for memmap
   HighMem zone: 32509 pages, LIFO batch:7
DMI 2.3 present.
ACPI: RSDP 000F62A0, 0014 (r0 ASUS  )
ACPI: RSDT 3FFFC000, 0030 (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: FACP 3FFFC0B2, 0074 (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: DSDT 3FFFC126, 2C4F (r1   ASUS A7V600       1000 MSFT  100000B)
ACPI: FACS 3FFFF000, 0040
ACPI: BOOT 3FFFC030, 0028 (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: APIC 3FFFC058, 005A (r1 ASUS   A7V600   42302E31 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:10 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists.  Total pages: 260093
Kernel command line: root=/dev/hda2 ro log_buf_len=128k
log_buf_len: 131072
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1999.872 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1034940k/1048560k available (2426k kernel code, 12968k reserved, 888k 
data, 188k init, 131056k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc0440000 - 0xc046f000   ( 188 kB)
       .data : 0xc035e9ef - 0xc043cb90   ( 888 kB)
       .text : 0xc0100000 - 0xc035e9ef   (2426 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4003.08 BogoMIPS (lpj=8006169)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff c1cbfbff 00000000 00000000 00000000 
00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 0383fbff c1cbfbff 00000000 00000420 00000000 
00000000 00000000
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
PCI: Probing PCI hardware (bus 00)
PCI: enabled onboard AC97/MC97 devices
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
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
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0A03
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid PNP0F03
pnp: ACPI device : hid PNPB02F
pnp: ACPI device : hid PNP0C02
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.20 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:00' and the driver 'system'
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x3fffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: match found with the PnP device '00:02' and the driver 'system'
pnp: 00:02: ioport range 0xe400-0xe47f has been reserved
pnp: 00:02: ioport range 0xe800-0xe81f has been reserved
pnp: 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
pnp: 00:02: iomem range 0xffb80000-0xffbfffff has been reserved
pnp: match found with the PnP device '00:03' and the driver 'system'
pnp: match found with the PnP device '00:0d' and the driver 'system'
pnp: 00:0d: ioport range 0x290-0x297 has been reserved
pnp: 00:0d: ioport range 0x370-0x375 has been reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
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
Boot video device is 0000:00:0a.0
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
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:0f.1
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 16
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
     ide0: BM-DMA at 0x9000-0x9007, BIOS settings: hda:DMA, hdb:DMA
     ide1: BM-DMA at 0x9008-0x900f, BIOS settings: hdc:pio, hdd:DMA
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hda: ST320420A, ATA DISK drive
hdb: Maxtor 5A300J0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
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
sata_promise 0000:00:0d.0: version 2.07
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 16 (level, low) -> IRQ 17
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
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 7Y250M0   YAR5 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 7Y250M0   YAR5 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 2:0:0:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6B250S0   BANC PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 3:0:0:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
sata_via 0000:00:0f.0: version 2.1
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 16
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
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 4:0:0:0: [sde] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sde: sde1
sd 4:0:0:0: [sde] Attached SCSI disk
scsi 5:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
sd 5:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 5:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdf: sdf1 sdf2
sd 5:0:0:0: [sdf] Attached SCSI disk
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0b' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
raid6: int32x1    806 MB/s
raid6: int32x2   1097 MB/s
raid6: int32x4    694 MB/s
raid6: int32x8    648 MB/s
raid6: mmxx1     1683 MB/s
raid6: mmxx2     3028 MB/s
raid6: sse1x1    1622 MB/s
raid6: sse1x2    2655 MB/s
raid6: using algorithm sse1x2 (2655 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  4201.000 MB/sec
raid5: using function: pIII_sse (4201.000 MB/sec)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
TCP cubic registered
Using IPI Shortcut mode
input: ImPS/2 Logitech Wheel Mouse as /class/input/input3
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdf1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md:  adding hdb1 ...
md: created md0
md: bind<hdb1>
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: running: <sdf1><sde1><sdd1><sdc1><sdb1><sda1><hdb1>
raid5: device sdf1 operational as raid disk 0
raid5: device sde1 operational as raid disk 1
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 4
raid5: device sda1 operational as raid disk 5
raid5: device hdb1 operational as raid disk 6
raid5: allocated 7316kB for md0
raid5: raid level 6 set md0 active with 7 out of 7 devices, algorithm 2
RAID5 conf printout:
  --- rd:7 wd:7
  disk 0, o:1, dev:sdf1
  disk 1, o:1, dev:sde1
  disk 2, o:1, dev:sdd1
  disk 3, o:1, dev:sdc1
  disk 4, o:1, dev:sdb1
  disk 5, o:1, dev:sda1
  disk 6, o:1, dev:hdb1
md0: bitmap initialized from disk: read 15/15 pages, set 2 bits, status: 0
created bitmap (234 pages) for device md0
md: ... autorun DONE.
Filesystem "hda2": Disabling barriers, not supported by the underlying device
XFS mounting filesystem hda2
Ending clean XFS mount for filesystem: hda2
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 188k freed
NET: Registered protocol family 1
PCI: Enabling device 0000:00:09.0 (0014 -> 0017)
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 18 (level, low) -> IRQ 18
skge 1.11 addr 0xf6000000 irq 18 chip Yukon rev 1
skge eth0: addr 00:0c:6e:f6:47:ee
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 19
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 19, io base 0x00008800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 19
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 19, io base 0x00008400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
sk98lin: driver has been replaced by the skge driver and is scheduled for removal
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 19
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 19, io base 0x00008000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 19
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.3: irq 19, io base 0x00007800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
vt596_smbus 0000:00:11.0: VT596_smba = 0xE800
i2c-adapter i2c-0: adapter [SMBus Via Pro adapter at e800] registered
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 19
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:10.4: irq 19, io mem 0xf4000000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:11.5 to 64
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
codec_read: codec 0 is not valid [0xfe0000]
Adding 522100k swap on /dev/hda3.  Priority:-1 extents:1 across:522100k
Filesystem "hda2": Disabling barriers, not supported by the underlying device
i2c-core: driver [eeprom] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
i2c-adapter i2c-0: Transaction (pre): STS=42 CNT=14 CMD=00 ADD=a0 DAT=11,00
i2c-adapter i2c-0: SMBus busy (0x42). Resetting...
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=a0 DAT=11,00
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=a0 DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=a0 DAT=11,00
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0050
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x51
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=a2 DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=a2 DAT=11,00
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x52
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=a4 DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=a4 DAT=11,00
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=a4 DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=a4 DAT=11,00
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0052
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x53
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=a6 DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=a6 DAT=11,00
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x54
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=a8 DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=a8 DAT=11,00
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x55
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=aa DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=aa DAT=11,00
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x56
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=ac DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=ac DAT=11,00
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x57
i2c-adapter i2c-0: Transaction (pre): STS=40 CNT=00 CMD=00 ADD=ae DAT=11,00
i2c-adapter i2c-0: Transaction (post): STS=00 CNT=00 CMD=00 ADD=ae DAT=11,00
i2c-adapter i2c-9191: ISA main adapter registered
it87: Found IT8712F chip at 0x290, revision 5
i2c-adapter i2c-9191: Driver it87-isa registered
i2c-adapter i2c-9191: client [it8712] registered with bus id 9191-0290
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Filesystem "md0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md0
Ending clean XFS mount for filesystem: md0
XFS mounting filesystem hdb2
Ending clean XFS mount for filesystem: hdb2
skge eth0: enabling interface
skge eth0: Link is up at 1000 Mbps, full duplex, flow control both

[I umount /dev/md0 here and then suspend2disk/resume]


swsusp: Basic memory bitmaps created
Stopping tasks ... done.
Shrinking memory... done (0 pages freed)
Freed 0 kbytes in 0.03 seconds (0.00 MB/s)
Suspending console(s)
sd 5:0:0:0: [sdf] Synchronizing SCSI cache
sd 4:0:0:0: [sde] Synchronizing SCSI cache
sd 3:0:0:0: [sdd] Synchronizing SCSI cache
sd 2:0:0:0: [sdc] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI: PCI interrupt for device 0000:00:11.5 disabled
ACPI: PCI interrupt for device 0000:00:10.4 disabled
ACPI: PCI interrupt for device 0000:00:10.3 disabled
ACPI: PCI interrupt for device 0000:00:10.2 disabled
ACPI: PCI interrupt for device 0000:00:10.1 disabled
ACPI: PCI interrupt for device 0000:00:10.0 disabled
ACPI: PCI interrupt for device 0000:00:0f.0 disabled
skge eth0: disabling interface
swsusp: critical section:
swsusp: Need to copy 34443 pages
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
PCI: Setting latency timer of device 0000:00:01.0 to 64
PM: Writing back config space on device 0000:00:09.0 at offset 1 (was 2b00014, 
writing 2b00017)
skge eth0: enabling interface
Clocksource tsc unstable (delta = 4327744420428 ns)
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 16 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:00:0f.0 at offset 1 (was 2900003, 
writing 2900007)
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 16
Time: acpi_pm clocksource has been installed.
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 19
usb usb1: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 19
usb usb2: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 19
usb usb3: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 19
usb usb4: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 19
PM: Writing back config space on device 0000:00:10.4 at offset 3 (was 802008, 
writing 802010)
usb usb5: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:11.5 to 64
pnp: Res cnt 3
pnp: res cnt 3
pnp: Encode io
pnp: Encode io
pnp: Encode irq
pnp: Failed to activate device 00:0a.
pnp: Res cnt 1
pnp: res cnt 1
pnp: Encode irq
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
sd 4:0:0:0: [sde] 490234752 512-byte hardware sectors (251000 MB)
sd 5:0:0:0: [sdf] Starting disk
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: configured for UDMA/133
sd 5:0:0:0: [sdf] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
Restarting tasks ... done.
swsusp: Basic memory bitmaps freed
skge eth0: Link is up at 1000 Mbps, full duplex, flow control both


[following is the dmesg of 2.6.21 post resume]

Stopping tasks ... done.
Shrinking memory... done (0 pages freed)
Freed 0 kbytes in 0.03 seconds (0.00 MB/s)
Suspending console(s)
ACPI: PCI interrupt for device 0000:00:11.5 disabled
ACPI: PCI interrupt for device 0000:00:10.4 disabled
ACPI: PCI interrupt for device 0000:00:10.3 disabled
ACPI: PCI interrupt for device 0000:00:10.2 disabled
ACPI: PCI interrupt for device 0000:00:10.1 disabled
ACPI: PCI interrupt for device 0000:00:10.0 disabled
skge eth0: disabling interface
swsusp: critical section:
swsusp: Need to copy 34078 pages
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
PCI: Setting latency timer of device 0000:00:01.0 to 64
Clocksource tsc unstable (delta = 4337118157984 ns)
Time: acpi_pm clocksource has been installed.
PM: Writing back config space on device 0000:00:09.0 at offset 1 (was 2b00014, 
writing 2b00017)
skge eth0: enabling interface
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 16 (level, low) -> IRQ 17
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 19
usb usb1: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 19
usb usb2: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 19
usb usb3: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 19
usb usb4: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 19
PM: Writing back config space on device 0000:00:10.4 at offset 3 (was 802008, 
writing 802010)
usb usb5: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:11.5 to 64
pnp: Res cnt 3
pnp: res cnt 3
pnp: Encode io
pnp: Encode io
pnp: Encode irq
pnp: Failed to activate device 00:0a.
pnp: Res cnt 1
pnp: res cnt 1
pnp: Encode irq
pnp: Failed to activate device 00:0b.
logips2pp: Detected unknown logitech mouse model 1
Restarting tasks ... done.
skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
