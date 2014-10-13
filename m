Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 123947F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 15:34:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B21630404E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 13:34:10 -0700 (PDT)
Received: from st11p01mm-asmtp001.mac.com (st11p01mm-asmtp001.mac.com
	[17.172.204.239]) by cuda.sgi.com with ESMTP id
	Vq7vYYYN2OxeuU4x (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 13:34:08 -0700 (PDT)
Received: from st11p01mm-spool001.mac.com ([17.172.204.246])
	by st11p01mm-asmtp001.mac.com
	(Oracle Communications Messaging Server 7u4-27.10(7.0.4.27.9) 64bit
	(built Jun
	6 2014)) with ESMTP id <0NDE00DSVH4MFV30@st11p01mm-asmtp001.mac.com>
	for xfs@oss.sgi.com; Mon, 13 Oct 2014 20:34:00 +0000 (GMT)
MIME-version: 1.0
From: Tom Mason <tom_mason@me.com>
Subject: Re: Mount: Structure needs cleaning
Date: Mon, 13 Oct 2014 20:33:57 +0000 (GMT)
Message-id: <4ddef393-ad9e-49a1-80d7-9c29bcd74c8f@me.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6488239025612151122=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============6488239025612151122==
Content-type: multipart/alternative;
 boundary="Boundary_(ID_SR8WvReHYm2n+SZJPUUEbg)"


--Boundary_(ID_SR8WvReHYm2n+SZJPUUEbg)
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: quoted-printable

=0A=0AOn Oct 13, 2014, at 11:19 AM, Emmanuel Florac <eflorac@intellique.co=
m> wrote:=0A=0A> Le Mon, 13 Oct 2014 11:05:49 +0100=0A> Tom Mason <tom_mas=
on@me.com    > =C3=A9crivait:=0A>=0A>        >      > Which means the file=
system tried to read the offset at 62GB and the=0A>        >      > underl=
ying device failed it with EIO. That's not an XFS failure.=0A>        >   =
   > What error is there in dmesg when you run that xfs_repair command?=0A=
>        >=0A>        > What's EIO?=0A>        > 'Error in dmesg' How woul=
d I report this info to you?=0A =0Ar 1=0A[    6.829125] ehci-pci 0000:00:0=
4.1: debug port 1=0A[    6.829162] ehci-pci 0000:00:04.1: cache line size =
of 256 is not supported=0A[    6.829185] ehci-pci 0000:00:04.1: irq 22, io=
 mem 0xd0489200=0A[    6.840043] ehci-pci 0000:00:04.1: USB 2.0 started, E=
HCI 1.00=0A[    6.840112] usb usb1: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0002=0A[    6.840116] usb usb1: New USB device strings: Mfr=3D=
3, Product=3D2, SerialNumber=3D1=0A[    6.840119] usb usb1: Product: EHCI =
Host Controller=0A[    6.840122] usb usb1: Manufacturer: Linux 3.13.0-32-g=
eneric ehci_hcd=0A[    6.840125] usb usb1: SerialNumber: 0000:00:04.1=0A[ =
   6.840295] hub 1-0:1.0: USB hub found=0A[    6.840307] hub 1-0:1.0: 7 po=
rts detected=0A[    6.840791] ehci-pci 0000:00:06.1: EHCI Host Controller=0A=
[    6.840799] ehci-pci 0000:00:06.1: new USB bus registered, assigned bus=
 number 2=0A[    6.840809] ehci-pci 0000:00:06.1: debug port 1=0A[    6.84=
0837] ehci-pci 0000:00:06.1: cache line size of 256 is not supported=0A[  =
  6.840855] ehci-pci 0000:00:06.1: irq 20, io mem 0xd0489100=0A[    6.8520=
97] ehci-pci 0000:00:06.1: USB 2.0 started, EHCI 1.00=0A[    6.852153] usb=
 usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002=0A[    6.85=
2156] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=
=3D1=0A[    6.852160] usb usb2: Product: EHCI Host Controller=0A[    6.852=
163] usb usb2: Manufacturer: Linux 3.13.0-32-generic ehci_hcd=0A[    6.852=
166] usb usb2: SerialNumber: 0000:00:06.1=0A[    6.852324] hub 2-0:1.0: US=
B hub found=0A[    6.852337] hub 2-0:1.0: 5 ports detected=0A[    6.852595=
] ehci-platform: EHCI generic platform driver=0A[    6.852609] ohci_hcd: U=
SB 1.1 'Open' Host Controller (OHCI) Driver=0A[    6.852611] ohci-pci: OHC=
I PCI platform driver=0A[    6.852818] ohci-pci 0000:00:04.0: OHCI PCI hos=
t controller=0A[    6.852825] ohci-pci 0000:00:04.0: new USB bus registere=
d, assigned bus number 3=0A[    6.852852] ohci-pci 0000:00:04.0: irq 23, i=
o mem 0xd0488000=0A[    6.910128] usb usb3: New USB device found, idVendor=
=3D1d6b, idProduct=3D0001=0A[    6.910132] usb usb3: New USB device string=
s: Mfr=3D3, Product=3D2, SerialNumber=3D1=0A[    6.910135] usb usb3: Produ=
ct: OHCI PCI host controller=0A[    6.910138] usb usb3: Manufacturer: Linu=
x 3.13.0-32-generic ohci_hcd=0A[    6.910141] usb usb3: SerialNumber: 0000=
:00:04.0=0A[    6.910291] hub 3-0:1.0: USB hub found=0A[    6.910304] hub =
3-0:1.0: 7 ports detected=0A[    6.910784] ohci-pci 0000:00:06.0: OHCI PCI=
 host controller=0A[    6.910792] ohci-pci 0000:00:06.0: new USB bus regis=
tered, assigned bus number 4=0A[    6.910817] ohci-pci 0000:00:06.0: irq 2=
1, io mem 0xd0487000=0A[    6.966125] usb usb4: New USB device found, idVe=
ndor=3D1d6b, idProduct=3D0001=0A[    6.966130] usb usb4: New USB device st=
rings: Mfr=3D3, Product=3D2, SerialNumber=3D1=0A[    6.966133] usb usb4: P=
roduct: OHCI PCI host controller=0A[    6.966136] usb usb4: Manufacturer: =
Linux 3.13.0-32-generic ohci_hcd=0A[    6.966139] usb usb4: SerialNumber: =
0000:00:06.0=0A[    6.966289] hub 4-0:1.0: USB hub found=0A[    6.966302] =
hub 4-0:1.0: 5 ports detected=0A[    6.966553] ohci-platform: OHCI generic=
 platform driver=0A[    6.966564] uhci_hcd: USB Universal Host Controller =
Interface driver=0A[    6.966638] i8042: PNP: No PS/2 controller found. Pr=
obing ports directly.=0A[    7.993878] i8042: No controller found=0A[    7=
.993976] mousedev: PS/2 mouse device common for all mice=0A[    7.994467] =
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0=0A[    7.994520] rtc=
_cmos 00:06: alarms up to one year, y3k, 242 bytes nvram, hpet irqs=0A[   =
 7.994609] device-mapper: uevent: version 1.0.3=0A[    7.994707] device-ma=
pper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com=0A=
[    7.994714] ledtrig-cpu: registered to indicate activity on CPUs=0A[   =
 7.994853] TCP: cubic registered=0A[    7.994990] NET: Registered protocol=
 family 10=0A[    7.995233] NET: Registered protocol family 17=0A[    7.99=
5252] Key type dns_resolver registered=0A[    7.995588] Loading compiled-i=
n X.509 certificates=0A[    7.997230] Loaded X.509 cert 'Magrathea: Glacie=
r signing key: 5e3c0f9ca6e36543535fa2bb5b709e84f16da7c7'=0A[    7.997251] =
registered taskstats version 1=0A[    8.001292] Key type trusted registere=
d=0A[    8.004490] Key type encrypted registered=0A[    8.007652] AppArmor=
: AppArmor sha1 policy hashing enabled=0A[    8.007656] IMA: No TPM chip f=
ound, activating TPM-bypass!=0A[    8.008268] regulator-dummy: disabling=0A=
[    8.008332]   Magic number: 2:86:43=0A[    8.008478] rtc_cmos 00:06: se=
tting system clock to 2014-10-13 20:01:54 UTC (1413230514)=0A[    8.009069=
] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found=0A[    8.009072] ED=
D information not available.=0A[    8.009129] PM: Hibernation image not pr=
esent or could not be loaded.=0A[    8.010552] Freeing unused kernel memor=
y: 1336K (ffffffff81d1f000 - ffffffff81e6d000)=0A[    8.010554] Write prot=
ecting the kernel read-only data: 12288k=0A[    8.012782] Freeing unused k=
ernel memory: 816K (ffff880001734000 - ffff880001800000)=0A[    8.014538] =
Freeing unused kernel memory: 696K (ffff880001b52000 - ffff880001c00000)=0A=
[    8.027129] systemd-udevd[100]: starting version 204=0A[    8.050650] f=
orcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.=0A[    =
8.050899] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 16=0A[    8.06049=
8] [drm] Initialized drm 1.1.0 20060810=0A[    8.088254] firewire_ohci 000=
0:04:00.0: irq 43 for MSI/MSI-X=0A[    8.090165] [drm] radeon kernel modes=
etting enabled.=0A[    8.090427] [drm] initializing kernel modesetting (RV=
770 0x1002:0x944A 0x106B:0x944A).=0A[    8.090442] [drm] register mmio bas=
e: 0xD0220000=0A[    8.090443] [drm] register mmio size: 65536=0A[    8.09=
0492] radeon 0000:02:00.0: Invalid ROM contents=0A[    8.091227] ATOM BIOS=
: 113=0A[    8.091254] radeon 0000:02:00.0: VRAM: 512M 0x0000000000000000 =
- 0x000000001FFFFFFF (512M used)=0A[    8.091256] radeon 0000:02:00.0: GTT=
: 1024M 0x0000000020000000 - 0x000000005FFFFFFF=0A[    8.091258] [drm] Det=
ected VRAM RAM=3D512M, BAR=3D256M=0A[    8.091259] [drm] RAM width 256bits=
 DDR=0A[    8.091404] [TTM] Zone  kernel: Available graphics memory: 40763=
28 kiB=0A[    8.091405] [TTM] Zone   dma32: Available graphics memory: 209=
7152 kiB=0A[    8.091406] [TTM] Initializing pool allocator=0A[    8.09141=
1] [TTM] Initializing DMA pool allocator=0A[    8.091427] [drm] radeon: 51=
2M of VRAM memory ready=0A[    8.091428] [drm] radeon: 1024M of GTT memory=
 ready.=0A[    8.091441] [drm] Loading RV770 Microcode=0A[    8.091512] [d=
rm] GART: num cpu pages 262144, num gpu pages 262144=0A[    8.094226] [drm=
] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=3D0=0A[  =
  8.111879] usb 1-4: new high-speed USB device number 2 using ehci-pci=0A[=
    8.111916] ssb: Found chip with id 0x4322, rev 0x01 and package 0x0A=0A=
[    8.111921] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x17, vendor 0=
x4243)=0A[    8.111927] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x10=
, vendor 0x4243)=0A[    8.111932] ssb: Core 2 found: PCI-E (cc 0x820, rev =
0x0B, vendor 0x4243)=0A[    8.111937] ssb: Core 3 found: PCI (cc 0x804, re=
v 0x0E, vendor 0x4243)=0A[    8.111942] ssb: Core 4 found: USB 2.0 Device =
(cc 0x81A, rev 0x05, vendor 0x4243)=0A[    8.111947] ssb: Core 5 found: UN=
KNOWN (cc 0x8FF, rev 0x00, vendor 0x4243)=0A[    8.111953] ssb: Core 6 fou=
nd: Internal Memory (cc 0x80E, rev 0x03, vendor 0x4243)=0A[    8.113736] [=
drm] PCIE GART of 1024M enabled (table at 0x0000000000040000).=0A[    8.11=
3775] radeon 0000:02:00.0: WB enabled=0A[    8.113778] radeon 0000:02:00.0=
: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xff=
ff88023352ec00=0A[    8.113780] radeon 0000:02:00.0: fence driver on ring =
3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff88023352ec0c=0A[    8=
.113783] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).=0A[  =
  8.113784] [drm] Driver supports precise vblank timestamp query.=0A[    8=
.113805] radeon 0000:02:00.0: irq 44 for MSI/MSI-X=0A[    8.113816] radeon=
 0000:02:00.0: radeon: using MSI.=0A[    8.113841] [drm] radeon: irq initi=
alized.=0A[    8.129822] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x73=
2 @ 1, addr 00:25:00:a5:98:42=0A[    8.129825] forcedeth 0000:00:0a.0: hig=
hdma csum pwrctl gbit lnktim msi desc-v3=0A[    8.144058] firewire_ohci 00=
00:04:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirk=
s 0x0=0A[    8.161628] [drm] ring test on 0 succeeded in 0 usecs=0A[    8.=
161806] [drm] ring test on 3 succeeded in 0 usecs=0A[    8.162282] [drm] E=
nabling audio 0 support=0A[    8.162342] [drm] ib test on ring 0 succeeded=
 in 0 usecs=0A[    8.162880] [drm] ib test on ring 3 succeeded in 0 usecs=0A=
[    8.168632] ahci 0000:00:0b.0: version 3.0=0A[    8.169043] ACPI: PCI I=
nterrupt Link [LSI0] enabled at IRQ 23=0A[    8.170020] ahci 0000:00:0b.0:=
 irq 45 for MSI/MSI-X=0A[    8.170036] ahci 0000:00:0b.0: controller can't=
 do PMP, turning off CAP_PMP=0A[    8.170104] ahci 0000:00:0b.0: AHCI 0001=
.0200 32 slots 6 ports 3 Gbps 0x3 impl IDE mode=0A[    8.170107] ahci 0000=
:00:0b.0: flags: 64bit ncq sntf pm led pio slum part boh=0A[    8.170957] =
scsi0 : ahci=0A[    8.171028] scsi1 : ahci=0A[    8.171081] scsi2 : ahci=0A=
[    8.171130] scsi3 : ahci=0A[    8.171180] scsi4 : ahci=0A[    8.171235]=
 scsi5 : ahci=0A[    8.171268] ata1: SATA max UDMA/133 abar m8192@0xd04840=
00 port 0xd0484100 irq 45=0A[    8.171270] ata2: SATA max UDMA/133 abar m8=
192@0xd0484000 port 0xd0484180 irq 45=0A[    8.171271] ata3: DUMMY=0A[    =
8.171272] ata4: DUMMY=0A[    8.171273] ata5: DUMMY=0A[    8.171274] ata6: =
DUMMY=0A[    8.192095] [drm] radeon atom DIG backlight initialized=0A[    =
8.192099] [drm] Radeon Display Connectors=0A[    8.192101] [drm] Connector=
 0:=0A[    8.192103] [drm]   DP-1=0A[    8.192105] [drm]   HPD2=0A[    8.1=
92108] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6=
c=0A[    8.192110] [drm]   Encoders:=0A[    8.192112] [drm]     DFP1: INTE=
RNAL_UNIPHY=0A[    8.192114] [drm] Connector 1:=0A[    8.192116] [drm]   D=
P-2=0A[    8.192117] [drm]   HPD3=0A[    8.192120] [drm]   DDC: 0x7e20 0x7=
e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c=0A[    8.192122] [drm]   Enc=
oders:=0A[    8.192123] [drm]     DFP2: INTERNAL_UNIPHY=0A[    8.192125] [=
drm] Connector 2:=0A[    8.192127] [drm]   LVDS-1=0A[    8.192129] [drm]  =
 Encoders:=0A[    8.192130] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA=0A[    8=
.192132] [drm] Connector 3:=0A[    8.192134] [drm]   VGA-1=0A[    8.192137=
] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c=0A[=
    8.192138] [drm]   Encoders:=0A[    8.192140] [drm]     CRT1: INTERNAL_=
KLDSCP_DAC1=0A[    8.192279] [drm] Special thermal controller config=0A[  =
  8.192290] [drm] radeon: power management initialized=0A[    8.220198] ss=
b: Sonics Silicon Backplane found on PCI device 0000:03:00.0=0A[    8.2762=
86] usb 1-4: Duplicate descriptor for config 1 interface 1 altsetting 5, s=
kipping=0A[    8.276291] usb 1-4: config 1 interface 1 has no altsetting 1=
=0A[    8.277975] usb 1-4: New USB device found, idVendor=3D05ac, idProduc=
t=3D8502=0A[    8.277979] usb 1-4: New USB device strings: Mfr=3D1, Produc=
t=3D2, SerialNumber=3D3=0A[    8.277982] usb 1-4: Product: Built-in iSight=
=0A[    8.277985] usb 1-4: Manufacturer: Apple Inc.=0A[    8.277988] usb 1=
-4: SerialNumber: 8J94412442CX3E00=0A[    8.488109] ata1: SATA link up 3.0=
 Gbps (SStatus 123 SControl 300)=0A[    8.489125] ata1.00: ATA-8: Hitachi =
HDT721064SLA360, ST0KA36A, max UDMA/133=0A[    8.489129] ata1.00: 12502637=
28 sectors, multi 0: LBA48 NCQ (depth 31/32)=0A[    8.490389] ata1.00: con=
figured for UDMA/133=0A[    8.490581] scsi 0:0:0:0: Direct-Access     ATA =
     Hitachi HDT72106 ST0K PQ: 0 ANSI: 5=0A[    8.490699] sd 0:0:0:0: Atta=
ched scsi generic sg0 type 0=0A[    8.490783] sd 0:0:0:0: [sda] 1250263728=
 512-byte logical blocks: (640 GB/596 GiB)=0A[    8.490898] sd 0:0:0:0: [s=
da] Write Protect is off=0A[    8.490901] sd 0:0:0:0: [sda] Mode Sense: 00=
 3a 00 00=0A[    8.490948] sd 0:0:0:0: [sda] Write cache: enabled, read ca=
che: enabled, doesn't support DPO or FUA=0A[    8.492063] ata2: SATA link =
up 1.5 Gbps (SStatus 113 SControl 300)=0A[    8.496523] ata2.00: ATAPI: HL=
-DT-ST DVDRW  GA11N, KA16, max UDMA/133=0A[    8.502177] ata2.00: configur=
ed for UDMA/133=0A[    8.508246] scsi 1:0:0:0: CD-ROM            HL-DT-ST =
DVDRW  GA11N     KA16 PQ: 0 ANSI: 5=0A[    8.512429] sr0: scsi3-mmc drive:=
 31x/31x writer cd/rw xa/form2 cdda caddy=0A[    8.512432] cdrom: Uniform =
CD-ROM driver Revision: 3.20=0A[    8.512534] sr 1:0:0:0: Attached scsi CD=
-ROM sr0=0A[    8.512578] sr 1:0:0:0: Attached scsi generic sg1 type 5=0A[=
    8.555847]  sda: sda1 sda2 sda3 sda4=0A[    8.556239] sd 0:0:0:0: [sda]=
 Attached SCSI disk=0A[    8.644196] firewire_core 0000:04:00.0: created d=
evice fw0: GUID 002500fffea59842, S800=0A[    8.704105] usb 2-4: new high-=
speed USB device number 3 using ehci-pci=0A[    8.844637] usb 2-4: New USB=
 device found, idVendor=3D05ac, idProduct=3D1006=0A[    8.844641] usb 2-4:=
 New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3=0A[    8.8=
44645] usb 2-4: Product: Keyboard Hub=0A[    8.844648] usb 2-4: Manufactur=
er: Apple, Inc.=0A[    8.844651] usb 2-4: SerialNumber: 000000000000=0A[  =
  8.844900] hub 2-4:1.0: USB hub found=0A[    8.845009] hub 2-4:1.0: 3 por=
ts detected=0A[    8.887236] [drm] fb mappable at 0xC0241000=0A[    8.8872=
38] [drm] vram apper at 0xC0000000=0A[    8.887239] [drm] size 9216000=0A[=
    8.887240] [drm] fb depth is 24=0A[    8.887241] [drm]    pitch is 7680=
=0A[    8.887305] fbcon: radeondrmfb (fb0) is primary device=0A[    8.9371=
01] Console: switching to colour frame buffer device 240x75=0A[    8.94202=
2] radeon 0000:02:00.0: fb0: radeondrmfb frame buffer device=0A[    8.9420=
24] radeon 0000:02:00.0: registered panic notifier=0A[    8.942033] [drm] =
Initialized radeon 2.36.0 20080528 for 0000:02:00.0 on minor 0=0A[    9.14=
8130] usb 4-1: new full-speed USB device number 2 using ohci-pci=0A[    9.=
370182] usb 4-1: New USB device found, idVendor=3D0a5c, idProduct=3D4500=0A=
[    9.370187] usb 4-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0=0A[    9.370191] usb 4-1: Product: BRCM2046 Hub=0A[    9.3701=
94] usb 4-1: Manufacturer: Apple Inc.=0A[    9.373223] hub 4-1:1.0: USB hu=
b found=0A[    9.376193] hub 4-1:1.0: 3 ports detected=0A[    9.820112] us=
b 3-5: new low-speed USB device number 2 using ohci-pci=0A[   10.035180] u=
sb 3-5: New USB device found, idVendor=3D05ac, idProduct=3D8242=0A[   10.0=
35184] usb 3-5: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=
=3D0=0A[   10.035188] usb 3-5: Product: IR Receiver=0A[   10.035191] usb 3=
-5: Manufacturer: Apple Computer, Inc.=0A[   10.044975] hidraw: raw HID ev=
ents driver (C) Jiri Kosina=0A[   10.052155] usbcore: registered new inter=
face driver usbhid=0A[   10.052156] usbhid: USB HID core driver=0A[   10.1=
12160] usb 2-4.2: new low-speed USB device number 4 using ehci-pci=0A[   1=
0.211410] usb 2-4.2: New USB device found, idVendor=3D05ac, idProduct=3D02=
21=0A[   10.211414] usb 2-4.2: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0=0A[   10.211418] usb 2-4.2: Product: Apple Keyboard=0A=
[   10.211421] usb 2-4.2: Manufacturer: Apple, Inc=0A[   10.219118] input:=
 Apple, Inc Apple Keyboard as /devices/pci0000:00/0000:00:06.1/usb2/2-4/2-=
4.2/2-4.2:1.0/input/input3=0A[   10.219184] apple 0003:05AC:0221.0002: inp=
ut,hidraw0: USB HID v1.11 Keyboard [Apple, Inc Apple Keyboard] on usb-0000=
:00:06.1-4.2/input0=0A[   10.219906] input: Apple, Inc Apple Keyboard as /=
devices/pci0000:00/0000:00:06.1/usb2/2-4/2-4.2/2-4.2:1.1/input/input4=0A[ =
  10.219967] apple 0003:05AC:0221.0003: input,hidraw1: USB HID v1.11 Devic=
e [Apple, Inc Apple Keyboard] on usb-0000:00:06.1-4.2/input1=0A[   10.2881=
62] usb 2-4.3: new low-speed USB device number 5 using ehci-pci=0A[   10.3=
86637] usb 2-4.3: New USB device found, idVendor=3D05ac, idProduct=3D0304=0A=
[   10.386642] usb 2-4.3: New USB device strings: Mfr=3D1, Product=3D2, Se=
rialNumber=3D0=0A[   10.386645] usb 2-4.3: Product: Apple Optical USB Mous=
e=0A[   10.386648] usb 2-4.3: Manufacturer: Mitsumi Electric=0A[   10.3896=
28] input: Mitsumi Electric Apple Optical USB Mouse as /devices/pci0000:00=
/0000:00:06.1/usb2/2-4/2-4.3/2-4.3:1.0/input/input5=0A[   10.389708] apple=
 0003:05AC:0304.0004: input,hidraw2: USB HID v1.10 Mouse [Mitsumi Electric=
 Apple Optical USB Mouse] on usb-0000:00:06.1-4.3/input0=0A[   10.466183] =
usb 4-1.1: new full-speed USB device number 3 using ohci-pci=0A[   10.5881=
82] usb 4-1.1: New USB device found, idVendor=3D05ac, idProduct=3D8215=0A[=
   10.588187] usb 4-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3=0A[   10.588190] usb 4-1.1: Product: Bluetooth USB Host Cont=
roller=0A[   10.588193] usb 4-1.1: Manufacturer: Apple Inc.=0A[   10.58819=
6] usb 4-1.1: SerialNumber: 002500C0F736=0A[   10.665180] usb 4-1.2: new f=
ull-speed USB device number 4 using ohci-pci=0A[   10.776183] usb 4-1.2: N=
ew USB device found, idVendor=3D05ac, idProduct=3D820a=0A[   10.776188] us=
b 4-1.2: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0=0A=
[   10.788074] input: HID 05ac:820a as /devices/pci0000:00/0000:00:06.0/us=
b4/4-1/4-1.2/4-1.2:1.0/input/input6=0A[   10.788130] hid-generic 0003:05AC=
:820A.0005: input,hidraw3: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0=
000:00:06.0-1.2/input0=0A[   10.861178] usb 4-1.3: new full-speed USB devi=
ce number 5 using ohci-pci=0A[   10.972182] usb 4-1.3: New USB device foun=
d, idVendor=3D05ac, idProduct=3D820b=0A[   10.972187] usb 4-1.3: New USB d=
evice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0=0A[   10.982514] inp=
ut: HID 05ac:820b as /devices/pci0000:00/0000:00:06.0/usb4/4-1/4-1.3/4-1.3=
:1.0/input/input7=0A[   10.982589] hid-generic 0003:05AC:820B.0006: input,=
hidraw4: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:06.0-1.3/input=
0=0A[   11.867826] random: nonblocking pool is initialized=0A[   16.829248=
] ISO 9660 Extensions: Microsoft Joliet Level 3=0A[   16.832917] ISO 9660 =
Extensions: RRIP_1991A=0A[   19.402642] squashfs: version 4.0 (2009/01/31)=
 Phillip Lougher=0A[   95.404256] IPv6: ADDRCONF(NETDEV_UP): eth0: link is=
 not ready=0A[   98.480471] systemd-udevd[1054]: starting version 204=0A[ =
 107.782107] lp: driver loaded but no devices found=0A[  108.557147] ppdev=
: user-space parallel port driver=0A[  111.968587] init: cups main process=
 (1100) killed by HUP signal=0A[  111.968600] init: cups main process ende=
d, respawning=0A[  111.975115] Bluetooth: Core ver 2.17=0A[  111.975128] N=
ET: Registered protocol family 31=0A[  111.975129] Bluetooth: HCI device a=
nd connection manager initialized=0A[  111.975137] Bluetooth: HCI socket l=
ayer initialized=0A[  111.975139] Bluetooth: L2CAP socket layer initialize=
d=0A[  111.975142] Bluetooth: SCO socket layer initialized=0A[  113.413518=
] Bluetooth: RFCOMM TTY layer initialized=0A[  113.413530] Bluetooth: RFCO=
MM socket layer initialized=0A[  113.413534] Bluetooth: RFCOMM ver 1.11=0A=
[  113.875800] Bluetooth: BNEP (Ethernet Emulation) ver 1.3=0A[  113.87580=
3] Bluetooth: BNEP filters: protocol multicast=0A[  113.875812] Bluetooth:=
 BNEP socket layer initialized=0A[  114.143675] i2c i2c-7: nForce2 SMBus a=
dapter at 0x2140=0A[  114.143719] i2c i2c-8: nForce2 SMBus adapter at 0x21=
00=0A[  119.341861] device-mapper: multipath: version 1.6.0 loaded=0A[  12=
2.364816] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22=0A[  122.36482=
6] hda_intel: Disabling MSI=0A[  122.364850] hda-intel 0000:00:08.0: Disab=
ling 64bit DMA=0A[  122.369265] hda-intel 0000:00:08.0: Enable delay in RI=
RB handling=0A[  122.537244] cfg80211: Calling CRDA to update world regula=
tory domain=0A[  122.548169] input: Apple Computer, Inc. IR Receiver as /d=
evices/pci0000:00/0000:00:04.0/usb3/3-5/3-5:1.0/input/input8=0A[  122.5482=
67] appleir 0003:05AC:8242.0001: input,hiddev0,hidraw5: USB HID v1.11 Devi=
ce [Apple Computer, Inc. IR Receiver] on usb-0000:00:04.0-5/input0=0A[  12=
3.624345] usbcore: registered new interface driver btusb=0A[  123.641112] =
usb 4-1.2: USB disconnect, device number 4=0A[  123.788302] hda_codec: ALC=
889A: SKU not ready 0x400000f0=0A[  123.800111] usb 4-1.3: USB disconnect,=
 device number 5=0A[  123.844020] autoconfig: line_outs=3D2 (0x1a/0x18/0x0=
/0x0/0x0) type:speaker=0A[  123.844023]    speaker_outs=3D0 (0x0/0x0/0x0/0=
x0/0x0)=0A[  123.844025]    hp_outs=3D1 (0x14/0x0/0x0/0x0/0x0)=0A[  123.84=
4026]    mono: mono_out=3D0x0=0A[  123.844027]    dig-out=3D0x1e/0x0=0A[  =
123.844028]    inputs:=0A[  123.844029]      Mic=3D0x19=0A[  123.844030]  =
    Line=3D0x15=0A[  123.844031]    dig-in=3D0x1f=0A[  123.844033] realtek=
: No valid SSID, checking pincfg 0x400000f0 for NID 0x1d=0A[  123.844034] =
realtek: Enable default setup for auto mode as fallback=0A[  124.645737] L=
inux video capture interface: v2.00=0A[  125.527345] init: failsafe main p=
rocess (1316) killed by TERM signal=0A[  125.579476] input: HDA NVidia Hea=
dphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input10=0A[  125.58=
2542] input: HDA NVidia Line as /devices/pci0000:00/0000:00:08.0/sound/car=
d0/input9=0A[  125.635895] ACPI: PCI Interrupt Link [Z004] enabled at IRQ =
21=0A[  125.635914] hda-intel 0000:02:00.1: Handle VGA-switcheroo audio cl=
ient=0A[  125.635915] hda-intel 0000:02:00.1: Using LPIB position fix=0A[ =
 125.635959] snd_hda_intel 0000:02:00.1: irq 46 for MSI/MSI-X=0A[  125.649=
835] hda-intel 0000:02:00.1: Enable sync_write for stable communication=0A=
[  125.685886] applesmc: key=3D241 fan=3D3 temp=3D15 index=3D15 acc=3D0 lu=
x=3D2 kbd=3D0=0A[  126.589401] HDMI ATI/AMD: no speaker allocation for ELD=
=0A[  126.589455] input: HDA ATI HDMI HDMI/DP,pcm=3D3 as /devices/pci0000:=
00/0000:00:0c.0/0000:02:00.1/sound/card1/input11=0A[  127.755350] cfg80211=
: World regulatory domain updated:=0A[  127.755354] cfg80211:   (start_fre=
q - end_freq @ bandwidth), (max_antenna_gain, max_eirp)=0A[  127.755356] c=
fg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)=0A=
[  127.755358] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 m=
Bi, 2000 mBm)=0A[  127.755359] cfg80211:   (2474000 KHz - 2494000 KHz @ 20=
000 KHz), (300 mBi, 2000 mBm)=0A[  127.755361] cfg80211:   (5170000 KHz - =
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)=0A[  127.755362] cfg80211:  =
 (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)=0A[  127.908=
347] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8502)=0A[  127.=
913856] input: Built-in iSight as /devices/pci0000:00/0000:00:04.1/usb1/1-=
4/1-4:1.0/input/input12=0A[  127.913952] usbcore: registered new interface=
 driver uvcvideo=0A[  127.913953] USB Video Class driver (1.1.1)=0A[  129.=
566189] b43-phy0: Broadcom 4322 WLAN found (core revision 16)=0A[  129.608=
044] b43-phy0: Found PHY: Analog 8, Type 4 (N), Revision 4=0A[  129.632482=
] b43 ssb0:0: Direct firmware load failed with error -2=0A[  129.632485] b=
43 ssb0:0: Falling back to user helper=0A[  129.632529] Broadcom 43xx driv=
er loaded [ Features: PNL ]=0A[  129.633372] b43 ssb0:0: Direct firmware l=
oad failed with error -2=0A[  129.633375] b43 ssb0:0: Falling back to user=
 helper=0A[  129.634217] b43 ssb0:0: Direct firmware load failed with erro=
r -2=0A[  129.634220] b43 ssb0:0: Falling back to user helper=0A[  129.634=
711] b43 ssb0:0: Direct firmware load failed with error -2=0A[  129.634713=
] b43 ssb0:0: Falling back to user helper=0A[  129.635388] b43-phy0 ERROR:=
 Firmware file "b43/ucode16_mimo.fw" not found=0A[  129.635391] b43-phy0 E=
RROR: Firmware file "b43-open/ucode16_mimo.fw" not found=0A[  129.635393] =
b43-phy0 ERROR: You must go to http://wireless.kernel.org/en/users/Drivers=
/b43#devicefirmware and download the correct firmware for this driver vers=
ion. Please carefully read all instructions on this website.=0A[  153.4548=
44] init: alsa-restore main process (1570) terminated with status 99=0A[  =
159.859881] forcedeth 0000:00:0a.0: irq 47 for MSI/MSI-X=0A[  159.859908] =
forcedeth 0000:00:0a.0 eth0: MSI enabled=0A[  180.483909] init: plymouth-u=
pstart-bridge main process ended, respawning=0A[  180.498245] init: plymou=
th-upstart-bridge main process ended, respawning=0A[  862.456063] usb 1-3:=
 new high-speed USB device number 4 using ehci-pci=0A[  862.591595] usb 1-=
3: New USB device found, idVendor=3D1bcf, idProduct=3D0c31=0A[  862.591601=
] usb 1-3: New USB device strings: Mfr=3D2, Product=3D3, SerialNumber=3D1=0A=
[  862.591604] usb 1-3: Product: USB to Serial-ATA bridge=0A[  862.591608]=
 usb 1-3: Manufacturer: Sunplus Innovation Technology.=0A[  862.591611] us=
b 1-3: SerialNumber: FAFFFFF0FDF13FF1BF901305=0A[  864.683460] usb-storage=
 1-3:1.0: USB Mass Storage device detected=0A[  864.683638] scsi6 : usb-st=
orage 1-3:1.0=0A[  864.683708] usbcore: registered new interface driver us=
b-storage=0A[  865.690235] scsi 6:0:0:0: Direct-Access     SAMSUNG  HD103U=
J               PQ: 0 ANSI: 4=0A[  865.690464] sd 6:0:0:0: Attached scsi g=
eneric sg2 type 0=0A[  865.694619] sd 6:0:0:0: [sdb] 1953525168 512-byte l=
ogical blocks: (1.00 TB/931 GiB)=0A[  865.700970] sd 6:0:0:0: [sdb] Write =
Protect is off=0A[  865.700973] sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00=0A=
[  865.707350] sd 6:0:0:0: [sdb] No Caching mode page found=0A[  865.70735=
2] sd 6:0:0:0: [sdb] Assuming drive cache: write through=0A[  865.721592] =
sd 6:0:0:0: [sdb] No Caching mode page found=0A[  865.721595] sd 6:0:0:0: =
[sdb] Assuming drive cache: write through=0A[  865.741343]  sdb: sdb1 < > =
sdb2=0A[  865.780852] sd 6:0:0:0: [sdb] No Caching mode page found=0A[  86=
5.780855] sd 6:0:0:0: [sdb] Assuming drive cache: write through=0A[  865.7=
80857] sd 6:0:0:0: [sdb] Attached SCSI disk=0A[  869.594066] SGI XFS with =
ACLs, security attributes, realtime, large block/inode numbers, no debug e=
nabled=0A[  869.609228] XFS (sdb2): Mounting Filesystem=0A[  869.687220] X=
FS (sdb2): Internal error xlog_clear_stale_blocks(2) at line 1368 of file =
/build/buildd/linux-3.13.0/fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa07=
a8951=0A[  869.687226] CPU: 1 PID: 5635 Comm: mount Not tainted 3.13.0-32-=
generic #57-Ubuntu=0A[  869.687227] Hardware name: Apple Inc. iMac9,1/Mac-=
F2218FA9, BIOS     IM91.88Z.008D.B08.0904271717 04/27/09=0A[  869.687229] =
 00000000000045e1 ffff88021f8f5c38 ffffffff8171bcb4 ffff88020c7c7400=0A[  =
869.687232]  ffff88021f8f5c50 ffffffffa075753b ffffffffa07a8951 ffff88021f=
8f5c90=0A[  869.687234]  ffffffffa07a5cf3 ffffffffa07a538f ffff88020c7c740=
0 ffff880219400780=0A[  869.687236] Call Trace:=0A[  869.687243]  [<ffffff=
ff8171bcb4>] dump_stack+0x45/0x56=0A[  869.687269]  [<ffffffffa075753b>] x=
fs_error_report+0x3b/0x40 [xfs]=0A[  869.687287]  [<ffffffffa07a8951>] ? x=
log_find_tail+0x341/0x3d0 [xfs]=0A[  869.687302]  [<ffffffffa07a5cf3>] xlo=
g_clear_stale_blocks+0x183/0x1c0 [xfs]=0A[  869.687318]  [<ffffffffa07a538=
f>] ? xlog_bread+0x3f/0x50 [xfs]=0A[  869.687334]  [<ffffffffa07a8951>] xl=
og_find_tail+0x341/0x3d0 [xfs]=0A[  869.687350]  [<ffffffffa07aa2be>] xlog=
_recover+0x1e/0xc0 [xfs]=0A[  869.687367]  [<ffffffffa07ae8ac>] xfs_log_mo=
unt+0x1bc/0x260 [xfs]=0A[  869.687380]  [<ffffffffa0766cca>] xfs_mountfs+0=
x3aa/0x700 [xfs]=0A[  869.687392]  [<ffffffffa076a142>] xfs_fs_fill_super+=
0x2b2/0x330 [xfs]=0A[  869.687396]  [<ffffffff811c0030>] mount_bdev+0x1b0/=
0x1f0=0A[  869.687409]  [<ffffffffa0769e90>] ? xfs_parseargs+0xbd0/0xbd0 [=
xfs]=0A[  869.687422]  [<ffffffffa0768185>] xfs_fs_mount+0x15/0x20 [xfs]=0A=
[  869.687425]  [<ffffffff811c0a29>] mount_fs+0x39/0x1b0=0A[  869.687428] =
 [<ffffffff8116f260>] ? __alloc_percpu+0x10/0x20=0A[  869.687431]  [<fffff=
fff811dbcd7>] vfs_kern_mount+0x67/0x110=0A[  869.687433]  [<ffffffff811de4=
ee>] do_mount+0x23e/0xad0=0A[  869.687435]  [<ffffffff8116a28b>] ? strndup=
_user+0x4b/0xf0=0A[  869.687437]  [<ffffffff811df073>] SyS_mount+0x83/0xc0=
=0A[  869.687440]  [<ffffffff8172c87f>] tracesys+0xe1/0xe6=0A[  869.687442=
] XFS (sdb2): failed to locate log tail=0A[  869.687444] XFS (sdb2): log m=
ount/recovery failed: error 117=0A[  869.687486] XFS (sdb2): log mount fai=
led=0A[ 1404.460745] sd 6:0:0:0: [sdb] Unhandled sense code=0A[ 1404.46075=
1] sd 6:0:0:0: [sdb] =0A[ 1404.460753] Result: hostbyte=3DDID_OK driverbyt=
e=3DDRIVER_SENSE=0A[ 1404.460756] sd 6:0:0:0: [sdb] =0A[ 1404.460758] Sens=
e Key : Medium Error [current]=0A[ 1404.460763] sd 6:0:0:0: [sdb] =0A[ 140=
4.460766] Add. Sense: Unrecovered read error=0A[ 1404.460769] sd 6:0:0:0: =
[sdb] CDB:=0A[ 1404.460771] Read(10): 28 00 07 63 bf 8d 00 00 eb 00=0A[ 14=
04.460781] end_request: critical medium error, dev sdb, sector 123977613=0A=
[ 1489.507727] sd 6:0:0:0: [sdb] Unhandled sense code=0A[ 1489.507734] sd =
6:0:0:0: [sdb] =0A[ 1489.507736] Result: hostbyte=3DDID_OK driverbyte=3DDR=
IVER_SENSE=0A[ 1489.507739] sd 6:0:0:0: [sdb] =0A[ 1489.507741] Sense Key =
: Medium Error [current]=0A[ 1489.507746] sd 6:0:0:0: [sdb] =0A[ 1489.5077=
49] Add. Sense: Unrecovered read error=0A[ 1489.507752] sd 6:0:0:0: [sdb] =
CDB:=0A[ 1489.507754] Read(10): 28 00 07 63 bf 8d 00 00 eb 00=0A[ 1489.507=
769] end_request: critical medium error, dev sdb, sector 123977613=0Aroot@=
ubuntu:~#=0A=0A=0A>=0A> "Input/Output Error" . Run the "dmesg" command imm=
ediately after=0A> this error, and see what it reports last (end of comman=
d output).=0A>=0A>        >      > This asks you to post the contents of /=
proc/partitions, which is=0A>        >      > what the kernel thinks are t=
he partition sizes.=0A>        >=0A>        > How do I do this?=0A>=0A> ca=
t /proc/partitions=0A =0Aroot@ubuntu:~# cat /proc/partitions=0Amajor minor=
  #blocks  name=0A=0A   7        0     961232 loop0=0A   8        0  62513=
1864 sda=0A   8        1     204800 sda1=0A   8        2  515624992 sda2=0A=
   8        3     634772 sda3=0A   8        4  108666880 sda4=0A  11      =
  0    1004544 sr0=0A   8       16  976762584 sdb=0A   8       17         =
 1 sdb1=0A   8       18  975755970 sdb2=0Aroot@ubuntu:~#=0A=0AHi Emmanuel,=
 so that should be what you asked for? I did a reset in terminal and tried=
 the dmesg, so I hope this didn't wipe any data on the failed mount which =
I had completed before. I'm about to try mouning as read only - fingers cr=
ossed!=EF=BB=BF=0ACheers,=0ATom=0A=0A>=0A>        >      >    > Yes it's a=
 NAS drive and so I assume had some kind of proprietary=0A>        >      =
>    > OS on the other partitions (this is where i might have messed up=0A=
>        >      >    > by deleting?!) I'm pretty sure that the drive in bo=
ld below (sdc2)=0A>        >      >    > is the one I'm after which is xfs=
...=0A>        >      >=0A>        >      > Ummm, exactly what are you try=
ing to do with this drive/filesystem?=0A>        >      > What device did =
the drive come from in the first place?=0A>        >=0A>        > It's a l=
acie 'Neil poulton' network space1 1tb NAS drive (see first=0A>        > p=
aragraph of post) - it recently stopped working and was stuck in a=0A>    =
    > 'spin cycle' - it contains my music and video backups. I'm trying to=
=0A>        > recover the files...=0A>=0A> Most probably disk is badly dam=
aged, dead or dying. It's advisable to=0A> try to create an image of the d=
isk on another one, and work for this=0A> image, because this disk will pr=
obably die any time now. It's no use=0A> trying to repair a filesystem on =
a bad drive, which is the cause of the=0A> errors from the beginning.=0A>=0A=
> If all you care is to get your files back, just try to mount the volume=0A=
> in read-only, non-recovery mode :=0A>=0A> mount -o ro,norecovery /dev/sd=
c2 /tmp/mount=0A>=0A> Then proceed by copying whatever you can get. Consid=
er that any file=0A> that gives an error is lost.=0A>=0A> The other option=
 is Kroll Ontrack or similar services, of course.=0A>=0A> -- =0A> --------=
----------------------------------------------------------------=0A> Emman=
uel Florac | Direction technique=0A> | Intellique=0A> |      <eflorac@inte=
llique.com        >=0A> | +33 1 78 94 84 02=0A> --------------------------=
----------------------------------------------=0A=

--Boundary_(ID_SR8WvReHYm2n+SZJPUUEbg)
Content-type: multipart/related;
 boundary="Boundary_(ID_hAgNeBqJCRzm0dnAH0FhmQ)"; type="text/html"


--Boundary_(ID_hAgNeBqJCRzm0dnAH0FhmQ)
Content-type: text/html; charset=ISO-8859-1
Content-transfer-encoding: quoted-printable

<html><body><div><br></div><div><br>On Oct 13, 2014, at 11:19 AM, Emmanuel Florac &lt;=
eflorac@intellique.com&gt; wrote:<br><br><div><blockquote type=3D"cite"><d=
iv class=3D"msg-quote"><div class=3D"_stretch"><span style=3D"white-space:=
pre-wrap;" data-mce-style=3D"white-space: pre-wrap;">Le Mon, 13 Oct 2014 1=
1:05:49 +0100<br>Tom Mason &lt;<a href=3D"mailto:tom_mason@me.com" data-mc=
e-href=3D"mailto:tom_mason@me.com">tom_mason@me.com</a> &nbsp; &nbsp;&gt; =
=E9crivait:<br><br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&g=
t; Which means the filesystem tried to read the offset at 62GB and the<br>=
 &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&gt; underlying devic=
e failed it with EIO. That's not an XFS failure.<br> &nbsp; &nbsp; &nbsp; =
&nbsp;&gt; &nbsp; &nbsp; &nbsp;&gt; What error is there in dmesg when you =
run that xfs_repair command? <br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; <br> &nb=
sp; &nbsp; &nbsp; &nbsp;&gt; What's EIO?<br> &nbsp; &nbsp; &nbsp; &nbsp;&g=
t; 'Error in dmesg' How would I report this info to you? <br></span></div>=
</div></blockquote><span>&nbsp;</span><br><span style=3D"font-size: 10px;"=
>r 1</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.8291=
25] ehci-pci 0000:00:04.1: debug port 1</span><br><span style=3D"font-size=
: 10px;">[&nbsp;&nbsp;&nbsp; 6.829162] ehci-pci 0000:00:04.1: cache line s=
ize of 256 is not supported</span><br><span style=3D"font-size: 10px;">[&n=
bsp;&nbsp;&nbsp; 6.829185] ehci-pci 0000:00:04.1: irq 22, io mem 0xd048920=
0</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840043]=
 ehci-pci 0000:00:04.1: USB 2.0 started, EHCI 1.00</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840112] usb usb1: New USB device =
found, idVendor=3D1d6b, idProduct=3D0002</span><br><span style=3D"font-siz=
e: 10px;">[&nbsp;&nbsp;&nbsp; 6.840116] usb usb1: New USB device strings: =
Mfr=3D3, Product=3D2, SerialNumber=3D1</span><br><span style=3D"font-size:=
 10px;">[&nbsp;&nbsp;&nbsp; 6.840119] usb usb1: Product: EHCI Host Control=
ler</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.84012=
2] usb usb1: Manufacturer: Linux 3.13.0-32-generic ehci_hcd</span><br><spa=
n style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840125] usb usb1: Seria=
lNumber: 0000:00:04.1</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 6.840295] hub 1-0:1.0: USB hub found</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840307] hub 1-0:1.0: 7 ports detect=
ed</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840791=
] ehci-pci 0000:00:06.1: EHCI Host Controller</span><br><span style=3D"fon=
t-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840799] ehci-pci 0000:00:06.1: new US=
B bus registered, assigned bus number 2</span><br><span style=3D"font-size=
: 10px;">[&nbsp;&nbsp;&nbsp; 6.840809] ehci-pci 0000:00:06.1: debug port 1=
</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840837] =
ehci-pci 0000:00:06.1: cache line size of 256 is not supported</span><br><=
span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.840855] ehci-pci 000=
0:00:06.1: irq 20, io mem 0xd0489100</span><br><span style=3D"font-size: 1=
0px;">[&nbsp;&nbsp;&nbsp; 6.852097] ehci-pci 0000:00:06.1: USB 2.0 started=
, EHCI 1.00</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp;=
 6.852153] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D00=
02</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.852156=
] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1=
</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.852160] =
usb usb2: Product: EHCI Host Controller</span><br><span style=3D"font-size=
: 10px;">[&nbsp;&nbsp;&nbsp; 6.852163] usb usb2: Manufacturer: Linux 3.13.=
0-32-generic ehci_hcd</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 6.852166] usb usb2: SerialNumber: 0000:00:06.1</span><br><span =
style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.852324] hub 2-0:1.0: USB =
hub found</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6=
.852337] hub 2-0:1.0: 5 ports detected</span><br><span style=3D"font-size:=
 10px;">[&nbsp;&nbsp;&nbsp; 6.852595] ehci-platform: EHCI generic platform=
 driver</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.8=
52609] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver</span><br><s=
pan style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.852611] ohci-pci: OHC=
I PCI platform driver</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 6.852818] ohci-pci 0000:00:04.0: OHCI PCI host controller</span=
><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.852825] ohci-p=
ci 0000:00:04.0: new USB bus registered, assigned bus number 3</span><br><=
span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.852852] ohci-pci 000=
0:00:04.0: irq 23, io mem 0xd0488000</span><br><span style=3D"font-size: 1=
0px;">[&nbsp;&nbsp;&nbsp; 6.910128] usb usb3: New USB device found, idVend=
or=3D1d6b, idProduct=3D0001</span><br><span style=3D"font-size: 10px;">[&n=
bsp;&nbsp;&nbsp; 6.910132] usb usb3: New USB device strings: Mfr=3D3, Prod=
uct=3D2, SerialNumber=3D1</span><br><span style=3D"font-size: 10px;">[&nbs=
p;&nbsp;&nbsp; 6.910135] usb usb3: Product: OHCI PCI host controller</span=
><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.910138] usb us=
b3: Manufacturer: Linux 3.13.0-32-generic ohci_hcd</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.910141] usb usb3: SerialNumber: 0=
000:00:04.0</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp;=
 6.910291] hub 3-0:1.0: USB hub found</span><br><span style=3D"font-size: =
10px;">[&nbsp;&nbsp;&nbsp; 6.910304] hub 3-0:1.0: 7 ports detected</span><=
br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.910784] ohci-pci=
 0000:00:06.0: OHCI PCI host controller</span><br><span style=3D"font-size=
: 10px;">[&nbsp;&nbsp;&nbsp; 6.910792] ohci-pci 0000:00:06.0: new USB bus =
registered, assigned bus number 4</span><br><span style=3D"font-size: 10px=
;">[&nbsp;&nbsp;&nbsp; 6.910817] ohci-pci 0000:00:06.0: irq 21, io mem 0xd=
0487000</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.9=
66125] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001</=
span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.966130] us=
b usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1</sp=
an><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.966133] usb =
usb4: Product: OHCI PCI host controller</span><br><span style=3D"font-size=
: 10px;">[&nbsp;&nbsp;&nbsp; 6.966136] usb usb4: Manufacturer: Linux 3.13.=
0-32-generic ohci_hcd</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 6.966139] usb usb4: SerialNumber: 0000:00:06.0</span><br><span =
style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.966289] hub 4-0:1.0: USB =
hub found</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6=
.966302] hub 4-0:1.0: 5 ports detected</span><br><span style=3D"font-size:=
 10px;">[&nbsp;&nbsp;&nbsp; 6.966553] ohci-platform: OHCI generic platform=
 driver</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.9=
66564] uhci_hcd: USB Universal Host Controller Interface driver</span><br>=
<span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 6.966638] i8042: PNP:=
 No PS/2 controller found. Probing ports directly.</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.993878] i8042: No controller foun=
d</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.993976]=
 mousedev: PS/2 mouse device common for all mice</span><br><span style=3D"=
font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.994467] rtc_cmos 00:06: rtc core: =
registered rtc_cmos as rtc0</span><br><span style=3D"font-size: 10px;">[&n=
bsp;&nbsp;&nbsp; 7.994520] rtc_cmos 00:06: alarms up to one year, y3k, 242=
 bytes nvram, hpet irqs</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp;&nbsp; 7.994609] device-mapper: uevent: version 1.0.3</span><br><spa=
n style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.994707] device-mapper: =
ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.994714] ledtrig-c=
pu: registered to indicate activity on CPUs</span><br><span style=3D"font-=
size: 10px;">[&nbsp;&nbsp;&nbsp; 7.994853] TCP: cubic registered</span><br=
><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.994990] NET: Regis=
tered protocol family 10</span><br><span style=3D"font-size: 10px;">[&nbsp=
;&nbsp;&nbsp; 7.995233] NET: Registered protocol family 17</span><br><span=
 style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.995252] Key type dns_res=
olver registered</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&=
nbsp; 7.995588] Loading compiled-in X.509 certificates</span><br><span sty=
le=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.997230] Loaded X.509 cert 'M=
agrathea: Glacier signing key: 5e3c0f9ca6e36543535fa2bb5b709e84f16da7c7'</=
span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 7.997251] re=
gistered taskstats version 1</span><br><span style=3D"font-size: 10px;">[&=
nbsp;&nbsp;&nbsp; 8.001292] Key type trusted registered</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.004490] Key type encrypted =
registered</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; =
8.007652] AppArmor: AppArmor sha1 policy hashing enabled</span><br><span s=
tyle=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.007656] IMA: No TPM chip f=
ound, activating TPM-bypass!</span><br><span style=3D"font-size: 10px;">[&=
nbsp;&nbsp;&nbsp; 8.008268] regulator-dummy: disabling</span><br><span sty=
le=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.008332]&nbsp;&nbsp; Magic nu=
mber: 2:86:43</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbs=
p; 8.008478] rtc_cmos 00:06: setting system clock to 2014-10-13 20:01:54 U=
TC (1413230514)</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&n=
bsp; 8.009069] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found</span>=
<br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.009072] EDD inf=
ormation not available.</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp;&nbsp; 8.009129] PM: Hibernation image not present or could not be l=
oaded.</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.01=
0552] Freeing unused kernel memory: 1336K (ffffffff81d1f000 - ffffffff81e6=
d000)</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.010=
554] Write protecting the kernel read-only data: 12288k</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.012782] Freeing unused kern=
el memory: 816K (ffff880001734000 - ffff880001800000)</span><br><span styl=
e=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.014538] Freeing unused kernel=
 memory: 696K (ffff880001b52000 - ffff880001c00000)</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.027129] systemd-udevd[100]: start=
ing version 204</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&n=
bsp; 8.050650] forcedeth: Reverse Engineered nForce ethernet driver. Versi=
on 0.64.</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.=
050899] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 16</span><br><span =
style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.060498] [drm] Initialized=
 drm 1.1.0 20060810</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbs=
p;&nbsp; 8.088254] firewire_ohci 0000:04:00.0: irq 43 for MSI/MSI-X</span>=
<br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.090165] [drm] r=
adeon kernel modesetting enabled.</span><br><span style=3D"font-size: 10px=
;">[&nbsp;&nbsp;&nbsp; 8.090427] [drm] initializing kernel modesetting (RV=
770 0x1002:0x944A 0x106B:0x944A).</span><br><span style=3D"font-size: 10px=
;">[&nbsp;&nbsp;&nbsp; 8.090442] [drm] register mmio base: 0xD0220000</spa=
n><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.090443] [drm]=
 register mmio size: 65536</span><br><span style=3D"font-size: 10px;">[&nb=
sp;&nbsp;&nbsp; 8.090492] radeon 0000:02:00.0: Invalid ROM contents</span>=
<br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.091227] ATOM BI=
OS: 113</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.0=
91254] radeon 0000:02:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFF=
FFFF (512M used)</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&=
nbsp; 8.091256] radeon 0000:02:00.0: GTT: 1024M 0x0000000020000000 - 0x000=
000005FFFFFFF</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbs=
p; 8.091258] [drm] Detected VRAM RAM=3D512M, BAR=3D256M</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.091259] [drm] RAM width 256=
bits DDR</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.=
091404] [TTM] Zone&nbsp; kernel: Available graphics memory: 4076328 kiB</s=
pan><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.091405] [TT=
M] Zone&nbsp;&nbsp; dma32: Available graphics memory: 2097152 kiB</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.091406] [TTM] Ini=
tializing pool allocator</span><br><span style=3D"font-size: 10px;">[&nbsp=
;&nbsp;&nbsp; 8.091411] [TTM] Initializing DMA pool allocator</span><br><s=
pan style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.091427] [drm] radeon:=
 512M of VRAM memory ready</span><br><span style=3D"font-size: 10px;">[&nb=
sp;&nbsp;&nbsp; 8.091428] [drm] radeon: 1024M of GTT memory ready.</span><=
br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.091441] [drm] Lo=
ading RV770 Microcode</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 8.091512] [drm] GART: num cpu pages 262144, num gpu pages 26214=
4</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.094226]=
 [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=3D0<=
/span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.111879] u=
sb 1-4: new high-speed USB device number 2 using ehci-pci</span><br><span =
style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.111916] ssb: Found chip w=
ith id 0x4322, rev 0x01 and package 0x0A</span><br><span style=3D"font-siz=
e: 10px;">[&nbsp;&nbsp;&nbsp; 8.111921] ssb: Core 0 found: ChipCommon (cc =
0x800, rev 0x17, vendor 0x4243)</span><br><span style=3D"font-size: 10px;"=
>[&nbsp;&nbsp;&nbsp; 8.111927] ssb: Core 1 found: IEEE 802.11 (cc 0x812, r=
ev 0x10, vendor 0x4243)</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp;&nbsp; 8.111932] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x0B, vendo=
r 0x4243)</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8=
.111937] ssb: Core 3 found: PCI (cc 0x804, rev 0x0E, vendor 0x4243)</span>=
<br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.111942] ssb: Co=
re 4 found: USB 2.0 Device (cc 0x81A, rev 0x05, vendor 0x4243)</span><br><=
span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.111947] ssb: Core 5 =
found: UNKNOWN (cc 0x8FF, rev 0x00, vendor 0x4243)</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.111953] ssb: Core 6 found: Intern=
al Memory (cc 0x80E, rev 0x03, vendor 0x4243)</span><br><span style=3D"fon=
t-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.113736] [drm] PCIE GART of 1024M enab=
led (table at 0x0000000000040000).</span><br><span style=3D"font-size: 10p=
x;">[&nbsp;&nbsp;&nbsp; 8.113775] radeon 0000:02:00.0: WB enabled</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.113778] radeon 00=
00:02:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu=
 addr 0xffff88023352ec00</span><br><span style=3D"font-size: 10px;">[&nbsp=
;&nbsp;&nbsp; 8.113780] radeon 0000:02:00.0: fence driver on ring 3 use gp=
u addr 0x0000000020000c0c and cpu addr 0xffff88023352ec0c</span><br><span =
style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.113783] [drm] Supports vb=
lank timestamp caching Rev 2 (21.10.2013).</span><br><span style=3D"font-s=
ize: 10px;">[&nbsp;&nbsp;&nbsp; 8.113784] [drm] Driver supports precise vb=
lank timestamp query.</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 8.113805] radeon 0000:02:00.0: irq 44 for MSI/MSI-X</span><br><=
span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.113816] radeon 0000:=
02:00.0: radeon: using MSI.</span><br><span style=3D"font-size: 10px;">[&n=
bsp;&nbsp;&nbsp; 8.113841] [drm] radeon: irq initialized.</span><br><span =
style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.129822] forcedeth 0000:00=
:0a.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:25:00:a5:98:42</span><br><s=
pan style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.129825] forcedeth 000=
0:00:0a.0: highdma csum pwrctl gbit lnktim msi desc-v3</span><br><span sty=
le=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.144058] firewire_ohci 0000:0=
4:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x=
0</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.161628]=
 [drm] ring test on 0 succeeded in 0 usecs</span><br><span style=3D"font-s=
ize: 10px;">[&nbsp;&nbsp;&nbsp; 8.161806] [drm] ring test on 3 succeeded i=
n 0 usecs</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8=
.162282] [drm] Enabling audio 0 support</span><br><span style=3D"font-size=
: 10px;">[&nbsp;&nbsp;&nbsp; 8.162342] [drm] ib test on ring 0 succeeded i=
n 0 usecs</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8=
.162880] [drm] ib test on ring 3 succeeded in 0 usecs</span><br><span styl=
e=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.168632] ahci 0000:00:0b.0: ve=
rsion 3.0</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8=
.169043] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 23</span><br><span=
 style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.170020] ahci 0000:00:0b.=
0: irq 45 for MSI/MSI-X</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp;&nbsp; 8.170036] ahci 0000:00:0b.0: controller can't do PMP, turning=
 off CAP_PMP</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp=
; 8.170104] ahci 0000:00:0b.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3 =
impl IDE mode</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbs=
p; 8.170107] ahci 0000:00:0b.0: flags: 64bit ncq sntf pm led pio slum part=
 boh </span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.170=
957] scsi0 : ahci</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;=
&nbsp; 8.171028] scsi1 : ahci</span><br><span style=3D"font-size: 10px;">[=
&nbsp;&nbsp;&nbsp; 8.171081] scsi2 : ahci</span><br><span style=3D"font-si=
ze: 10px;">[&nbsp;&nbsp;&nbsp; 8.171130] scsi3 : ahci</span><br><span styl=
e=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.171180] scsi4 : ahci</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.171235] scsi5 : a=
hci</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.17126=
8] ata1: SATA max UDMA/133 abar m8192@0xd0484000 port 0xd0484100 irq 45</s=
pan><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.171270] ata=
2: SATA max UDMA/133 abar m8192@0xd0484000 port 0xd0484180 irq 45</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.171271] ata3: DUM=
MY</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.171272=
] ata4: DUMMY</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbs=
p; 8.171273] ata5: DUMMY</span><br><span style=3D"font-size: 10px;">[&nbsp=
;&nbsp;&nbsp; 8.171274] ata6: DUMMY</span><br><span style=3D"font-size: 10=
px;">[&nbsp;&nbsp;&nbsp; 8.192095] [drm] radeon atom DIG backlight initial=
ized</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.1920=
99] [drm] Radeon Display Connectors</span><br><span style=3D"font-size: 10=
px;">[&nbsp;&nbsp;&nbsp; 8.192101] [drm] Connector 0:</span><br><span styl=
e=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192103] [drm]&nbsp;&nbsp; DP-=
1</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192105]=
 [drm]&nbsp;&nbsp; HPD2</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp;&nbsp; 8.192108] [drm]&nbsp;&nbsp; DDC: 0x7e60 0x7e60 0x7e64 0x7e64 =
0x7e68 0x7e68 0x7e6c 0x7e6c</span><br><span style=3D"font-size: 10px;">[&n=
bsp;&nbsp;&nbsp; 8.192110] [drm]&nbsp;&nbsp; Encoders:</span><br><span sty=
le=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192112] [drm]&nbsp;&nbsp;&nb=
sp;&nbsp; DFP1: INTERNAL_UNIPHY</span><br><span style=3D"font-size: 10px;"=
>[&nbsp;&nbsp;&nbsp; 8.192114] [drm] Connector 1:</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192116] [drm]&nbsp;&nbsp; DP-2</s=
pan><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192117] [dr=
m]&nbsp;&nbsp; HPD3</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbs=
p;&nbsp; 8.192120] [drm]&nbsp;&nbsp; DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e=
28 0x7e28 0x7e2c 0x7e2c</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp;&nbsp; 8.192122] [drm]&nbsp;&nbsp; Encoders:</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192123] [drm]&nbsp;&nbsp;&nbsp;&n=
bsp; DFP2: INTERNAL_UNIPHY</span><br><span style=3D"font-size: 10px;">[&nb=
sp;&nbsp;&nbsp; 8.192125] [drm] Connector 2:</span><br><span style=3D"font=
-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192127] [drm]&nbsp;&nbsp; LVDS-1</span=
><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192129] [drm]&=
nbsp;&nbsp; Encoders:</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 8.192130] [drm]&nbsp;&nbsp;&nbsp;&nbsp; LCD1: INTERNAL_KLDSCP_L=
VTMA</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.1921=
32] [drm] Connector 3:</span><br><span style=3D"font-size: 10px;">[&nbsp;&=
nbsp;&nbsp; 8.192134] [drm]&nbsp;&nbsp; VGA-1</span><br><span style=3D"fon=
t-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192137] [drm]&nbsp;&nbsp; DDC: 0x7e40=
 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192138] [drm]&nbsp;&nbsp; Encoder=
s:</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192140=
] [drm]&nbsp;&nbsp;&nbsp;&nbsp; CRT1: INTERNAL_KLDSCP_DAC1</span><br><span=
 style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.192279] [drm] Special th=
ermal controller config</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp;&nbsp; 8.192290] [drm] radeon: power management initialized</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.220198] ssb: Soni=
cs Silicon Backplane found on PCI device 0000:03:00.0</span><br><span styl=
e=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.276286] usb 1-4: Duplicate de=
scriptor for config 1 interface 1 altsetting 5, skipping</span><br><span s=
tyle=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.276291] usb 1-4: config 1 =
interface 1 has no altsetting 1</span><br><span style=3D"font-size: 10px;"=
>[&nbsp;&nbsp;&nbsp; 8.277975] usb 1-4: New USB device found, idVendor=3D0=
5ac, idProduct=3D8502</span><br><span style=3D"font-size: 10px;">[&nbsp;&n=
bsp;&nbsp; 8.277979] usb 1-4: New USB device strings: Mfr=3D1, Product=3D2=
, SerialNumber=3D3</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp=
;&nbsp; 8.277982] usb 1-4: Product: Built-in iSight</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.277985] usb 1-4: Manufacturer: Ap=
ple Inc.</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.=
277988] usb 1-4: SerialNumber: 8J94412442CX3E00</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.488109] ata1: SATA link up 3.0 Gbps=
 (SStatus 123 SControl 300)</span><br><span style=3D"font-size: 10px;">[&n=
bsp;&nbsp;&nbsp; 8.489125] ata1.00: ATA-8: Hitachi HDT721064SLA360, ST0KA3=
6A, max UDMA/133</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&=
nbsp; 8.489129] ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/=
32)</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.49038=
9] ata1.00: configured for UDMA/133</span><br><span style=3D"font-size: 10=
px;">[&nbsp;&nbsp;&nbsp; 8.490581] scsi 0:0:0:0: Direct-Access&nbsp;&nbsp;=
&nbsp;&nbsp; ATA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Hitachi HDT72106 ST0K PQ: 0=
 ANSI: 5</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.=
490699] sd 0:0:0:0: Attached scsi generic sg0 type 0</span><br><span style=
=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.490783] sd 0:0:0:0: [sda] 1250=
263728 512-byte logical blocks: (640 GB/596 GiB)</span><br><span style=3D"=
font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.490898] sd 0:0:0:0: [sda] Write Pr=
otect is off</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp=
; 8.490901] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00</span><br><span styl=
e=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.490948] sd 0:0:0:0: [sda] Wri=
te cache: enabled, read cache: enabled, doesn't support DPO or FUA</span><=
br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.492063] ata2: SA=
TA link up 1.5 Gbps (SStatus 113 SControl 300)</span><br><span style=3D"fo=
nt-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.496523] ata2.00: ATAPI: HL-DT-ST DVD=
RW&nbsp; GA11N, KA16, max UDMA/133</span><br><span style=3D"font-size: 10p=
x;">[&nbsp;&nbsp;&nbsp; 8.502177] ata2.00: configured for UDMA/133</span><=
br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.508246] scsi 1:0=
:0:0: CD-ROM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; HL-DT-ST DVDRW&nbsp; GA11N&nbsp;&nbsp;&nbsp;&nbsp; KA16 PQ: 0 ANSI: 5=
</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.512429] =
sr0: scsi3-mmc drive: 31x/31x writer cd/rw xa/form2 cdda caddy</span><br><=
span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.512432] cdrom: Unifo=
rm CD-ROM driver Revision: 3.20</span><br><span style=3D"font-size: 10px;"=
>[&nbsp;&nbsp;&nbsp; 8.512534] sr 1:0:0:0: Attached scsi CD-ROM sr0</span>=
<br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.512578] sr 1:0:=
0:0: Attached scsi generic sg1 type 5</span><br><span style=3D"font-size: =
10px;">[&nbsp;&nbsp;&nbsp; 8.555847]&nbsp; sda: sda1 sda2 sda3 sda4</span>=
<br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.556239] sd 0:0:=
0:0: [sda] Attached SCSI disk</span><br><span style=3D"font-size: 10px;">[=
&nbsp;&nbsp;&nbsp; 8.644196] firewire_core 0000:04:00.0: created device fw=
0: GUID 002500fffea59842, S800</span><br><span style=3D"font-size: 10px;">=
[&nbsp;&nbsp;&nbsp; 8.704105] usb 2-4: new high-speed USB device number 3 =
using ehci-pci</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nb=
sp; 8.844637] usb 2-4: New USB device found, idVendor=3D05ac, idProduct=3D=
1006</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.8446=
41] usb 2-4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D=
3</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.844645]=
 usb 2-4: Product: Keyboard Hub</span><br><span style=3D"font-size: 10px;"=
>[&nbsp;&nbsp;&nbsp; 8.844648] usb 2-4: Manufacturer: Apple, Inc.</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.844651] usb 2-4: =
SerialNumber: 000000000000</span><br><span style=3D"font-size: 10px;">[&nb=
sp;&nbsp;&nbsp; 8.844900] hub 2-4:1.0: USB hub found</span><br><span style=
=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.845009] hub 2-4:1.0: 3 ports d=
etected</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.8=
87236] [drm] fb mappable at 0xC0241000</span><br><span style=3D"font-size:=
 10px;">[&nbsp;&nbsp;&nbsp; 8.887238] [drm] vram apper at 0xC0000000</span=
><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.887239] [drm] =
size 9216000</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp=
; 8.887240] [drm] fb depth is 24</span><br><span style=3D"font-size: 10px;=
">[&nbsp;&nbsp;&nbsp; 8.887241] [drm]&nbsp;&nbsp;&nbsp; pitch is 7680</spa=
n><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.887305] fbcon=
: radeondrmfb (fb0) is primary device</span><br><span style=3D"font-size: =
10px;">[&nbsp;&nbsp;&nbsp; 8.937101] Console: switching to colour frame bu=
ffer device 240x75</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp=
;&nbsp; 8.942022] radeon 0000:02:00.0: fb0: radeondrmfb frame buffer devic=
e</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.942024]=
 radeon 0000:02:00.0: registered panic notifier</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp;&nbsp;&nbsp; 8.942033] [drm] Initialized radeon 2.=
36.0 20080528 for 0000:02:00.0 on minor 0</span><br><span style=3D"font-si=
ze: 10px;">[&nbsp;&nbsp;&nbsp; 9.148130] usb 4-1: new full-speed USB devic=
e number 2 using ohci-pci</span><br><span style=3D"font-size: 10px;">[&nbs=
p;&nbsp;&nbsp; 9.370182] usb 4-1: New USB device found, idVendor=3D0a5c, i=
dProduct=3D4500</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&n=
bsp; 9.370187] usb 4-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp=
; 9.370191] usb 4-1: Product: BRCM2046 Hub</span><br><span style=3D"font-s=
ize: 10px;">[&nbsp;&nbsp;&nbsp; 9.370194] usb 4-1: Manufacturer: Apple Inc=
.</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 9.373223]=
 hub 4-1:1.0: USB hub found</span><br><span style=3D"font-size: 10px;">[&n=
bsp;&nbsp;&nbsp; 9.376193] hub 4-1:1.0: 3 ports detected</span><br><span s=
tyle=3D"font-size: 10px;">[&nbsp;&nbsp;&nbsp; 9.820112] usb 3-5: new low-s=
peed USB device number 2 using ohci-pci</span><br><span style=3D"font-size=
: 10px;">[&nbsp;&nbsp; 10.035180] usb 3-5: New USB device found, idVendor=3D=
05ac, idProduct=3D8242</span><br><span style=3D"font-size: 10px;">[&nbsp;&=
nbsp; 10.035184] usb 3-5: New USB device strings: Mfr=3D1, Product=3D2, Se=
rialNumber=3D0</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10=
.035188] usb 3-5: Product: IR Receiver</span><br><span style=3D"font-size:=
 10px;">[&nbsp;&nbsp; 10.035191] usb 3-5: Manufacturer: Apple Computer, In=
c.</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.044975] hid=
raw: raw HID events driver (C) Jiri Kosina</span><br><span style=3D"font-s=
ize: 10px;">[&nbsp;&nbsp; 10.052155] usbcore: registered new interface dri=
ver usbhid</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.052=
156] usbhid: USB HID core driver</span><br><span style=3D"font-size: 10px;=
">[&nbsp;&nbsp; 10.112160] usb 2-4.2: new low-speed USB device number 4 us=
ing ehci-pci</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.2=
11410] usb 2-4.2: New USB device found, idVendor=3D05ac, idProduct=3D0221<=
/span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.211414] usb 2-=
4.2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0</span>=
<br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.211418] usb 2-4.2: P=
roduct: Apple Keyboard</span><br><span style=3D"font-size: 10px;">[&nbsp;&=
nbsp; 10.211421] usb 2-4.2: Manufacturer: Apple, Inc</span><br><span style=
=3D"font-size: 10px;">[&nbsp;&nbsp; 10.219118] input: Apple, Inc Apple Key=
board as /devices/pci0000:00/0000:00:06.1/usb2/2-4/2-4.2/2-4.2:1.0/input/i=
nput3</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.219184] =
apple 0003:05AC:0221.0002: input,hidraw0: USB HID v1.11 Keyboard [Apple, I=
nc Apple Keyboard] on usb-0000:00:06.1-4.2/input0</span><br><span style=3D=
"font-size: 10px;">[&nbsp;&nbsp; 10.219906] input: Apple, Inc Apple Keyboa=
rd as /devices/pci0000:00/0000:00:06.1/usb2/2-4/2-4.2/2-4.2:1.1/input/inpu=
t4</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.219967] app=
le 0003:05AC:0221.0003: input,hidraw1: USB HID v1.11 Device [Apple, Inc Ap=
ple Keyboard] on usb-0000:00:06.1-4.2/input1</span><br><span style=3D"font=
-size: 10px;">[&nbsp;&nbsp; 10.288162] usb 2-4.3: new low-speed USB device=
 number 5 using ehci-pci</span><br><span style=3D"font-size: 10px;">[&nbsp=
;&nbsp; 10.386637] usb 2-4.3: New USB device found, idVendor=3D05ac, idPro=
duct=3D0304</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.38=
6642] usb 2-4.3: New USB device strings: Mfr=3D1, Product=3D2, SerialNumbe=
r=3D0</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.386645] =
usb 2-4.3: Product: Apple Optical USB Mouse</span><br><span style=3D"font-=
size: 10px;">[&nbsp;&nbsp; 10.386648] usb 2-4.3: Manufacturer: Mitsumi Ele=
ctric</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.389628] =
input: Mitsumi Electric Apple Optical USB Mouse as /devices/pci0000:00/000=
0:00:06.1/usb2/2-4/2-4.3/2-4.3:1.0/input/input5</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp;&nbsp; 10.389708] apple 0003:05AC:0304.0004: input=
,hidraw2: USB HID v1.10 Mouse [Mitsumi Electric Apple Optical USB Mouse] o=
n usb-0000:00:06.1-4.3/input0</span><br><span style=3D"font-size: 10px;">[=
&nbsp;&nbsp; 10.466183] usb 4-1.1: new full-speed USB device number 3 usin=
g ohci-pci</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.588=
182] usb 4-1.1: New USB device found, idVendor=3D05ac, idProduct=3D8215</s=
pan><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.588187] usb 4-1.=
1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.588190] usb 4-1.1: Pro=
duct: Bluetooth USB Host Controller</span><br><span style=3D"font-size: 10=
px;">[&nbsp;&nbsp; 10.588193] usb 4-1.1: Manufacturer: Apple Inc.</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.588196] usb 4-1.1: Ser=
ialNumber: 002500C0F736</span><br><span style=3D"font-size: 10px;">[&nbsp;=
&nbsp; 10.665180] usb 4-1.2: new full-speed USB device number 4 using ohci=
-pci</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.776183] u=
sb 4-1.2: New USB device found, idVendor=3D05ac, idProduct=3D820a</span><b=
r><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.776188] usb 4-1.2: New=
 USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0</span><br><spa=
n style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.788074] input: HID 05ac:820a=
 as /devices/pci0000:00/0000:00:06.0/usb4/4-1/4-1.2/4-1.2:1.0/input/input6=
</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.788130] hid-g=
eneric 0003:05AC:820A.0005: input,hidraw3: USB HID v1.11 Keyboard [HID 05a=
c:820a] on usb-0000:00:06.0-1.2/input0</span><br><span style=3D"font-size:=
 10px;">[&nbsp;&nbsp; 10.861178] usb 4-1.3: new full-speed USB device numb=
er 5 using ohci-pci</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbs=
p; 10.972182] usb 4-1.3: New USB device found, idVendor=3D05ac, idProduct=3D=
820b</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.972187] u=
sb 4-1.3: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0</=
span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.982514] input: =
HID 05ac:820b as /devices/pci0000:00/0000:00:06.0/usb4/4-1/4-1.3/4-1.3:1.0=
/input/input7</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 10.=
982589] hid-generic 0003:05AC:820B.0006: input,hidraw4: USB HID v1.11 Mous=
e [HID 05ac:820b] on usb-0000:00:06.0-1.3/input0</span><br><span style=3D"=
font-size: 10px;">[&nbsp;&nbsp; 11.867826] random: nonblocking pool is ini=
tialized</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 16.82924=
8] ISO 9660 Extensions: Microsoft Joliet Level 3</span><br><span style=3D"=
font-size: 10px;">[&nbsp;&nbsp; 16.832917] ISO 9660 Extensions: RRIP_1991A=
</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; 19.402642] squas=
hfs: version 4.0 (2009/01/31) Phillip Lougher</span><br><span style=3D"fon=
t-size: 10px;">[&nbsp;&nbsp; 95.404256] IPv6: ADDRCONF(NETDEV_UP): eth0: l=
ink is not ready</span><br><span style=3D"font-size: 10px;">[&nbsp;&nbsp; =
98.480471] systemd-udevd[1054]: starting version 204</span><br><span style=
=3D"font-size: 10px;">[&nbsp; 107.782107] lp: driver loaded but no devices=
 found</span><br><span style=3D"font-size: 10px;">[&nbsp; 108.557147] ppde=
v: user-space parallel port driver</span><br><span style=3D"font-size: 10p=
x;">[&nbsp; 111.968587] init: cups main process (1100) killed by HUP signa=
l</span><br><span style=3D"font-size: 10px;">[&nbsp; 111.968600] init: cup=
s main process ended, respawning</span><br><span style=3D"font-size: 10px;=
">[&nbsp; 111.975115] Bluetooth: Core ver 2.17</span><br><span style=3D"fo=
nt-size: 10px;">[&nbsp; 111.975128] NET: Registered protocol family 31</sp=
an><br><span style=3D"font-size: 10px;">[&nbsp; 111.975129] Bluetooth: HCI=
 device and connection manager initialized</span><br><span style=3D"font-s=
ize: 10px;">[&nbsp; 111.975137] Bluetooth: HCI socket layer initialized</s=
pan><br><span style=3D"font-size: 10px;">[&nbsp; 111.975139] Bluetooth: L2=
CAP socket layer initialized</span><br><span style=3D"font-size: 10px;">[&=
nbsp; 111.975142] Bluetooth: SCO socket layer initialized</span><br><span =
style=3D"font-size: 10px;">[&nbsp; 113.413518] Bluetooth: RFCOMM TTY layer=
 initialized</span><br><span style=3D"font-size: 10px;">[&nbsp; 113.413530=
] Bluetooth: RFCOMM socket layer initialized</span><br><span style=3D"font=
-size: 10px;">[&nbsp; 113.413534] Bluetooth: RFCOMM ver 1.11</span><br><sp=
an style=3D"font-size: 10px;">[&nbsp; 113.875800] Bluetooth: BNEP (Etherne=
t Emulation) ver 1.3</span><br><span style=3D"font-size: 10px;">[&nbsp; 11=
3.875803] Bluetooth: BNEP filters: protocol multicast</span><br><span styl=
e=3D"font-size: 10px;">[&nbsp; 113.875812] Bluetooth: BNEP socket layer in=
itialized</span><br><span style=3D"font-size: 10px;">[&nbsp; 114.143675] i=
2c i2c-7: nForce2 SMBus adapter at 0x2140</span><br><span style=3D"font-si=
ze: 10px;">[&nbsp; 114.143719] i2c i2c-8: nForce2 SMBus adapter at 0x2100<=
/span><br><span style=3D"font-size: 10px;">[&nbsp; 119.341861] device-mapp=
er: multipath: version 1.6.0 loaded</span><br><span style=3D"font-size: 10=
px;">[&nbsp; 122.364816] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22=
</span><br><span style=3D"font-size: 10px;">[&nbsp; 122.364826] hda_intel:=
 Disabling MSI</span><br><span style=3D"font-size: 10px;">[&nbsp; 122.3648=
50] hda-intel 0000:00:08.0: Disabling 64bit DMA</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp; 122.369265] hda-intel 0000:00:08.0: Enable delay =
in RIRB handling</span><br><span style=3D"font-size: 10px;">[&nbsp; 122.53=
7244] cfg80211: Calling CRDA to update world regulatory domain</span><br><=
span style=3D"font-size: 10px;">[&nbsp; 122.548169] input: Apple Computer,=
 Inc. IR Receiver as /devices/pci0000:00/0000:00:04.0/usb3/3-5/3-5:1.0/inp=
ut/input8</span><br><span style=3D"font-size: 10px;">[&nbsp; 122.548267] a=
ppleir 0003:05AC:8242.0001: input,hiddev0,hidraw5: USB HID v1.11 Device [A=
pple Computer, Inc. IR Receiver] on usb-0000:00:04.0-5/input0</span><br><s=
pan style=3D"font-size: 10px;">[&nbsp; 123.624345] usbcore: registered new=
 interface driver btusb</span><br><span style=3D"font-size: 10px;">[&nbsp;=
 123.641112] usb 4-1.2: USB disconnect, device number 4</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp; 123.788302] hda_codec: ALC889A: SKU not r=
eady 0x400000f0</span><br><span style=3D"font-size: 10px;">[&nbsp; 123.800=
111] usb 4-1.3: USB disconnect, device number 5</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp; 123.844020] autoconfig: line_outs=3D2 (0x1a/0x18/=
0x0/0x0/0x0) type:speaker</span><br><span style=3D"font-size: 10px;">[&nbs=
p; 123.844023]&nbsp;&nbsp;&nbsp; speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x0)</s=
pan><br><span style=3D"font-size: 10px;">[&nbsp; 123.844025]&nbsp;&nbsp;&n=
bsp; hp_outs=3D1 (0x14/0x0/0x0/0x0/0x0)</span><br><span style=3D"font-size=
: 10px;">[&nbsp; 123.844026]&nbsp;&nbsp;&nbsp; mono: mono_out=3D0x0</span>=
<br><span style=3D"font-size: 10px;">[&nbsp; 123.844027]&nbsp;&nbsp;&nbsp;=
 dig-out=3D0x1e/0x0</span><br><span style=3D"font-size: 10px;">[&nbsp; 123=
.844028]&nbsp;&nbsp;&nbsp; inputs:</span><br><span style=3D"font-size: 10p=
x;">[&nbsp; 123.844029]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Mic=3D0x19</span><br=
><span style=3D"font-size: 10px;">[&nbsp; 123.844030]&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; Line=3D0x15</span><br><span style=3D"font-size: 10px;">[&nbsp; 1=
23.844031]&nbsp;&nbsp;&nbsp; dig-in=3D0x1f</span><br><span style=3D"font-s=
ize: 10px;">[&nbsp; 123.844033] realtek: No valid SSID, checking pincfg 0x=
400000f0 for NID 0x1d</span><br><span style=3D"font-size: 10px;">[&nbsp; 1=
23.844034] realtek: Enable default setup for auto mode as fallback</span><=
br><span style=3D"font-size: 10px;">[&nbsp; 124.645737] Linux video captur=
e interface: v2.00</span><br><span style=3D"font-size: 10px;">[&nbsp; 125.=
527345] init: failsafe main process (1316) killed by TERM signal</span><br=
><span style=3D"font-size: 10px;">[&nbsp; 125.579476] input: HDA NVidia He=
adphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input10</span><br>=
<span style=3D"font-size: 10px;">[&nbsp; 125.582542] input: HDA NVidia Lin=
e as /devices/pci0000:00/0000:00:08.0/sound/card0/input9</span><br><span s=
tyle=3D"font-size: 10px;">[&nbsp; 125.635895] ACPI: PCI Interrupt Link [Z0=
04] enabled at IRQ 21</span><br><span style=3D"font-size: 10px;">[&nbsp; 1=
25.635914] hda-intel 0000:02:00.1: Handle VGA-switcheroo audio client</spa=
n><br><span style=3D"font-size: 10px;">[&nbsp; 125.635915] hda-intel 0000:=
02:00.1: Using LPIB position fix</span><br><span style=3D"font-size: 10px;=
">[&nbsp; 125.635959] snd_hda_intel 0000:02:00.1: irq 46 for MSI/MSI-X</sp=
an><br><span style=3D"font-size: 10px;">[&nbsp; 125.649835] hda-intel 0000=
:02:00.1: Enable sync_write for stable communication</span><br><span style=
=3D"font-size: 10px;">[&nbsp; 125.685886] applesmc: key=3D241 fan=3D3 temp=
=3D15 index=3D15 acc=3D0 lux=3D2 kbd=3D0</span><br><span style=3D"font-siz=
e: 10px;">[&nbsp; 126.589401] HDMI ATI/AMD: no speaker allocation for ELD<=
/span><br><span style=3D"font-size: 10px;">[&nbsp; 126.589455] input: HDA =
ATI HDMI HDMI/DP,pcm=3D3 as /devices/pci0000:00/0000:00:0c.0/0000:02:00.1/=
sound/card1/input11</span><br><span style=3D"font-size: 10px;">[&nbsp; 127=
.755350] cfg80211: World regulatory domain updated:</span><br><span style=3D=
"font-size: 10px;">[&nbsp; 127.755354] cfg80211:&nbsp;&nbsp; (start_freq -=
 end_freq @ bandwidth), (max_antenna_gain, max_eirp)</span><br><span style=
=3D"font-size: 10px;">[&nbsp; 127.755356] cfg80211:&nbsp;&nbsp; (2402000 K=
Hz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)</span><br><span style=3D=
"font-size: 10px;">[&nbsp; 127.755358] cfg80211:&nbsp;&nbsp; (2457000 KHz =
- 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp; 127.755359] cfg80211:&nbsp;&nbsp; (2474000 KHz - =
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)</span><br><span style=3D"fon=
t-size: 10px;">[&nbsp; 127.755361] cfg80211:&nbsp;&nbsp; (5170000 KHz - 52=
50000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)</span><br><span style=3D"font-=
size: 10px;">[&nbsp; 127.755362] cfg80211:&nbsp;&nbsp; (5735000 KHz - 5835=
000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)</span><br><span style=3D"font-si=
ze: 10px;">[&nbsp; 127.908347] uvcvideo: Found UVC 1.00 device Built-in iS=
ight (05ac:8502)</span><br><span style=3D"font-size: 10px;">[&nbsp; 127.91=
3856] input: Built-in iSight as /devices/pci0000:00/0000:00:04.1/usb1/1-4/=
1-4:1.0/input/input12</span><br><span style=3D"font-size: 10px;">[&nbsp; 1=
27.913952] usbcore: registered new interface driver uvcvideo</span><br><sp=
an style=3D"font-size: 10px;">[&nbsp; 127.913953] USB Video Class driver (=
1.1.1)</span><br><span style=3D"font-size: 10px;">[&nbsp; 129.566189] b43-=
phy0: Broadcom 4322 WLAN found (core revision 16)</span><br><span style=3D=
"font-size: 10px;">[&nbsp; 129.608044] b43-phy0: Found PHY: Analog 8, Type=
 4 (N), Revision 4</span><br><span style=3D"font-size: 10px;">[&nbsp; 129.=
632482] b43 ssb0:0: Direct firmware load failed with error -2</span><br><s=
pan style=3D"font-size: 10px;">[&nbsp; 129.632485] b43 ssb0:0: Falling bac=
k to user helper</span><br><span style=3D"font-size: 10px;">[&nbsp; 129.63=
2529] Broadcom 43xx driver loaded [ Features: PNL ]</span><br><span style=3D=
"font-size: 10px;">[&nbsp; 129.633372] b43 ssb0:0: Direct firmware load fa=
iled with error -2</span><br><span style=3D"font-size: 10px;">[&nbsp; 129.=
633375] b43 ssb0:0: Falling back to user helper</span><br><span style=3D"f=
ont-size: 10px;">[&nbsp; 129.634217] b43 ssb0:0: Direct firmware load fail=
ed with error -2</span><br><span style=3D"font-size: 10px;">[&nbsp; 129.63=
4220] b43 ssb0:0: Falling back to user helper</span><br><span style=3D"fon=
t-size: 10px;">[&nbsp; 129.634711] b43 ssb0:0: Direct firmware load failed=
 with error -2</span><br><span style=3D"font-size: 10px;">[&nbsp; 129.6347=
13] b43 ssb0:0: Falling back to user helper</span><br><span style=3D"font-=
size: 10px;">[&nbsp; 129.635388] b43-phy0 ERROR: Firmware file "b43/ucode1=
6_mimo.fw" not found</span><br><span style=3D"font-size: 10px;">[&nbsp; 12=
9.635391] b43-phy0 ERROR: Firmware file "b43-open/ucode16_mimo.fw" not fou=
nd</span><br><span style=3D"font-size: 10px;">[&nbsp; 129.635393] b43-phy0=
 ERROR: You must go to http://wireless.kernel.org/en/users/Drivers/b43#dev=
icefirmware and download the correct firmware for this driver version. Ple=
ase carefully read all instructions on this website.</span><br><span style=
=3D"font-size: 10px;">[&nbsp; 153.454844] init: alsa-restore main process =
(1570) terminated with status 99</span><br><span style=3D"font-size: 10px;=
">[&nbsp; 159.859881] forcedeth 0000:00:0a.0: irq 47 for MSI/MSI-X</span><=
br><span style=3D"font-size: 10px;">[&nbsp; 159.859908] forcedeth 0000:00:=
0a.0 eth0: MSI enabled</span><br><span style=3D"font-size: 10px;">[&nbsp; =
180.483909] init: plymouth-upstart-bridge main process ended, respawning</=
span><br><span style=3D"font-size: 10px;">[&nbsp; 180.498245] init: plymou=
th-upstart-bridge main process ended, respawning</span><br><span style=3D"=
font-size: 10px;">[&nbsp; 862.456063] usb 1-3: new high-speed USB device n=
umber 4 using ehci-pci</span><br><span style=3D"font-size: 10px;">[&nbsp; =
862.591595] usb 1-3: New USB device found, idVendor=3D1bcf, idProduct=3D0c=
31</span><br><span style=3D"font-size: 10px;">[&nbsp; 862.591601] usb 1-3:=
 New USB device strings: Mfr=3D2, Product=3D3, SerialNumber=3D1</span><br>=
<span style=3D"font-size: 10px;">[&nbsp; 862.591604] usb 1-3: Product: USB=
 to Serial-ATA bridge</span><br><span style=3D"font-size: 10px;">[&nbsp; 8=
62.591608] usb 1-3: Manufacturer: Sunplus Innovation Technology.</span><br=
><span style=3D"font-size: 10px;">[&nbsp; 862.591611] usb 1-3: SerialNumbe=
r: FAFFFFF0FDF13FF1BF901305</span><br><span style=3D"font-size: 10px;">[&n=
bsp; 864.683460] usb-storage 1-3:1.0: USB Mass Storage device detected</sp=
an><br><span style=3D"font-size: 10px;">[&nbsp; 864.683638] scsi6 : usb-st=
orage 1-3:1.0</span><br><span style=3D"font-size: 10px;">[&nbsp; 864.68370=
8] usbcore: registered new interface driver usb-storage</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp; 865.690235] scsi 6:0:0:0: Direct-Access&n=
bsp;&nbsp;&nbsp;&nbsp; SAMSUNG&nbsp; HD103UJ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PQ: 0 ANSI: 4</span=
><br><span style=3D"font-size: 10px;">[&nbsp; 865.690464] sd 6:0:0:0: Atta=
ched scsi generic sg2 type 0</span><br><span style=3D"font-size: 10px;">[&=
nbsp; 865.694619] sd 6:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1=
.00 TB/931 GiB)</span><br><span style=3D"font-size: 10px;">[&nbsp; 865.700=
970] sd 6:0:0:0: [sdb] Write Protect is off</span><br><span style=3D"font-=
size: 10px;">[&nbsp; 865.700973] sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00=
</span><br><span style=3D"font-size: 10px;">[&nbsp; 865.707350] sd 6:0:0:0=
: [sdb] No Caching mode page found</span><br><span style=3D"font-size: 10p=
x;">[&nbsp; 865.707352] sd 6:0:0:0: [sdb] Assuming drive cache: write thro=
ugh</span><br><span style=3D"font-size: 10px;">[&nbsp; 865.721592] sd 6:0:=
0:0: [sdb] No Caching mode page found</span><br><span style=3D"font-size: =
10px;">[&nbsp; 865.721595] sd 6:0:0:0: [sdb] Assuming drive cache: write t=
hrough</span><br><span style=3D"font-size: 10px;">[&nbsp; 865.741343]&nbsp=
; sdb: sdb1 &lt; &gt; sdb2</span><br><span style=3D"font-size: 10px;">[&nb=
sp; 865.780852] sd 6:0:0:0: [sdb] No Caching mode page found</span><br><sp=
an style=3D"font-size: 10px;">[&nbsp; 865.780855] sd 6:0:0:0: [sdb] Assumi=
ng drive cache: write through</span><br><span style=3D"font-size: 10px;">[=
&nbsp; 865.780857] sd 6:0:0:0: [sdb] Attached SCSI disk</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp; 869.594066] SGI XFS with ACLs, security a=
ttributes, realtime, large block/inode numbers, no debug enabled</span><br=
><span style=3D"font-size: 10px;">[&nbsp; 869.609228] XFS (sdb2): Mounting=
 Filesystem</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.687220]=
 XFS (sdb2): Internal error xlog_clear_stale_blocks(2) at line 1368 of fil=
e /build/buildd/linux-3.13.0/fs/xfs/xfs_log_recover.c.&nbsp; Caller 0xffff=
ffffa07a8951</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.687226=
] CPU: 1 PID: 5635 Comm: mount Not tainted 3.13.0-32-generic #57-Ubuntu</s=
pan><br><span style=3D"font-size: 10px;">[&nbsp; 869.687227] Hardware name=
: Apple Inc. iMac9,1/Mac-F2218FA9, BIOS&nbsp;&nbsp;&nbsp;&nbsp; IM91.88Z.0=
08D.B08.0904271717 04/27/09</span><br><span style=3D"font-size: 10px;">[&n=
bsp; 869.687229]&nbsp; 00000000000045e1 ffff88021f8f5c38 ffffffff8171bcb4 =
ffff88020c7c7400</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.68=
7232]&nbsp; ffff88021f8f5c50 ffffffffa075753b ffffffffa07a8951 ffff88021f8=
f5c90</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.687234]&nbsp;=
 ffffffffa07a5cf3 ffffffffa07a538f ffff88020c7c7400 ffff880219400780</span=
><br><span style=3D"font-size: 10px;">[&nbsp; 869.687236] Call Trace:</spa=
n><br><span style=3D"font-size: 10px;">[&nbsp; 869.687243]&nbsp; [&lt;ffff=
ffff8171bcb4&gt;] dump_stack+0x45/0x56</span><br><span style=3D"font-size:=
 10px;">[&nbsp; 869.687269]&nbsp; [&lt;ffffffffa075753b&gt;] xfs_error_rep=
ort+0x3b/0x40 [xfs]</span><br><span style=3D"font-size: 10px;">[&nbsp; 869=
.687287]&nbsp; [&lt;ffffffffa07a8951&gt;] ? xlog_find_tail+0x341/0x3d0 [xf=
s]</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.687302]&nbsp; [&=
lt;ffffffffa07a5cf3&gt;] xlog_clear_stale_blocks+0x183/0x1c0 [xfs]</span><=
br><span style=3D"font-size: 10px;">[&nbsp; 869.687318]&nbsp; [&lt;fffffff=
fa07a538f&gt;] ? xlog_bread+0x3f/0x50 [xfs]</span><br><span style=3D"font-=
size: 10px;">[&nbsp; 869.687334]&nbsp; [&lt;ffffffffa07a8951&gt;] xlog_fin=
d_tail+0x341/0x3d0 [xfs]</span><br><span style=3D"font-size: 10px;">[&nbsp=
; 869.687350]&nbsp; [&lt;ffffffffa07aa2be&gt;] xlog_recover+0x1e/0xc0 [xfs=
]</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.687367]&nbsp; [&l=
t;ffffffffa07ae8ac&gt;] xfs_log_mount+0x1bc/0x260 [xfs]</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp; 869.687380]&nbsp; [&lt;ffffffffa0766cca&g=
t;] xfs_mountfs+0x3aa/0x700 [xfs]</span><br><span style=3D"font-size: 10px=
;">[&nbsp; 869.687392]&nbsp; [&lt;ffffffffa076a142&gt;] xfs_fs_fill_super+=
0x2b2/0x330 [xfs]</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.6=
87396]&nbsp; [&lt;ffffffff811c0030&gt;] mount_bdev+0x1b0/0x1f0</span><br><=
span style=3D"font-size: 10px;">[&nbsp; 869.687409]&nbsp; [&lt;ffffffffa07=
69e90&gt;] ? xfs_parseargs+0xbd0/0xbd0 [xfs]</span><br><span style=3D"font=
-size: 10px;">[&nbsp; 869.687422]&nbsp; [&lt;ffffffffa0768185&gt;] xfs_fs_=
mount+0x15/0x20 [xfs]</span><br><span style=3D"font-size: 10px;">[&nbsp; 8=
69.687425]&nbsp; [&lt;ffffffff811c0a29&gt;] mount_fs+0x39/0x1b0</span><br>=
<span style=3D"font-size: 10px;">[&nbsp; 869.687428]&nbsp; [&lt;ffffffff81=
16f260&gt;] ? __alloc_percpu+0x10/0x20</span><br><span style=3D"font-size:=
 10px;">[&nbsp; 869.687431]&nbsp; [&lt;ffffffff811dbcd7&gt;] vfs_kern_moun=
t+0x67/0x110</span><br><span style=3D"font-size: 10px;">[&nbsp; 869.687433=
]&nbsp; [&lt;ffffffff811de4ee&gt;] do_mount+0x23e/0xad0</span><br><span st=
yle=3D"font-size: 10px;">[&nbsp; 869.687435]&nbsp; [&lt;ffffffff8116a28b&g=
t;] ? strndup_user+0x4b/0xf0</span><br><span style=3D"font-size: 10px;">[&=
nbsp; 869.687437]&nbsp; [&lt;ffffffff811df073&gt;] SyS_mount+0x83/0xc0</sp=
an><br><span style=3D"font-size: 10px;">[&nbsp; 869.687440]&nbsp; [&lt;fff=
fffff8172c87f&gt;] tracesys+0xe1/0xe6</span><br><span style=3D"font-size: =
10px;">[&nbsp; 869.687442] XFS (sdb2): failed to locate log tail</span><br=
><span style=3D"font-size: 10px;">[&nbsp; 869.687444] XFS (sdb2): log moun=
t/recovery failed: error 117</span><br><span style=3D"font-size: 10px;">[&=
nbsp; 869.687486] XFS (sdb2): log mount failed</span><br><span style=3D"fo=
nt-size: 10px;">[ 1404.460745] sd 6:0:0:0: [sdb] Unhandled sense code</spa=
n><br><span style=3D"font-size: 10px;">[ 1404.460751] sd 6:0:0:0: [sdb]&nb=
sp; </span><br><span style=3D"font-size: 10px;">[ 1404.460753] Result: hos=
tbyte=3DDID_OK driverbyte=3DDRIVER_SENSE</span><br><span style=3D"font-siz=
e: 10px;">[ 1404.460756] sd 6:0:0:0: [sdb]&nbsp; </span><br><span style=3D=
"font-size: 10px;">[ 1404.460758] Sense Key : Medium Error [current] </spa=
n><br><span style=3D"font-size: 10px;">[ 1404.460763] sd 6:0:0:0: [sdb]&nb=
sp; </span><br><span style=3D"font-size: 10px;">[ 1404.460766] Add. Sense:=
 Unrecovered read error</span><br><span style=3D"font-size: 10px;">[ 1404.=
460769] sd 6:0:0:0: [sdb] CDB: </span><br><span style=3D"font-size: 10px;"=
>[ 1404.460771] Read(10): 28 00 07 63 bf 8d 00 00 eb 00</span><br><span st=
yle=3D"font-size: 10px;">[ 1404.460781] end_request: critical medium error=
, dev sdb, sector 123977613</span><br><span style=3D"font-size: 10px;">[ 1=
489.507727] sd 6:0:0:0: [sdb] Unhandled sense code</span><br><span style=3D=
"font-size: 10px;">[ 1489.507734] sd 6:0:0:0: [sdb]&nbsp; </span><br><span=
 style=3D"font-size: 10px;">[ 1489.507736] Result: hostbyte=3DDID_OK drive=
rbyte=3DDRIVER_SENSE</span><br><span style=3D"font-size: 10px;">[ 1489.507=
739] sd 6:0:0:0: [sdb]&nbsp; </span><br><span style=3D"font-size: 10px;">[=
 1489.507741] Sense Key : Medium Error [current] </span><br><span style=3D=
"font-size: 10px;">[ 1489.507746] sd 6:0:0:0: [sdb]&nbsp; </span><br><span=
 style=3D"font-size: 10px;">[ 1489.507749] Add. Sense: Unrecovered read er=
ror</span><br><span style=3D"font-size: 10px;">[ 1489.507752] sd 6:0:0:0: =
[sdb] CDB: </span><br><span style=3D"font-size: 10px;">[ 1489.507754] Read=
(10): 28 00 07 63 bf 8d 00 00 eb 00</span><br><span style=3D"font-size: 10=
px;">[ 1489.507769] end_request: critical medium error, dev sdb, sector 12=
3977613</span><br><span style=3D"font-size: 10px;">root@ubuntu:~#</span> <=
br><br><br><br><blockquote type=3D"cite"><div class=3D"msg-quote"><div cla=
ss=3D"_stretch"><span style=3D"white-space:pre-wrap;" data-mce-style=3D"wh=
ite-space: pre-wrap;"><br>"Input/Output Error" . Run the "dmesg" command i=
mmediately after<br>this error, and see what it reports last (end of comma=
nd output).<br><br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&g=
t; This asks you to post the contents of /proc/partitions, which is<br> &n=
bsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&gt; what the kernel thi=
nks are the partition sizes. <br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; <br> &nb=
sp; &nbsp; &nbsp; &nbsp;&gt; How do I do this?<br><br>cat /proc/partitions=
<br></span></div></div></blockquote><span>&nbsp;</span><br><span style=3D"=
font-size: 10px;">root@ubuntu:~# cat /proc/partitions</span><br><span styl=
e=3D"font-size: 10px;">major minor&nbsp; #blocks&nbsp; name</span><br><br>=
<span style=3D"font-size: 10px;">&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 961232 loop0</span><br><span sty=
le=3D"font-size: 10px;">&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; 0&nbsp; 625131864 sda</span><br><span style=3D"font-size: 10px;">&n=
bsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;=
&nbsp; 204800 sda1</span><br><span style=3D"font-size: 10px;">&nbsp;&nbsp;=
 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 515624992 sda2</span>=
<br><span style=3D"font-size: 10px;">&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp;&nbsp;&nbsp; 634772 sda3</span><br><span =
style=3D"font-size: 10px;">&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; 4&nbsp; 108666880 sda4</span><br><span style=3D"font-size: 10px;=
">&nbsp; 11&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; =
1004544 sr0</span><br><span style=3D"font-size: 10px;">&nbsp;&nbsp; 8&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp; 976762584 sdb</span><br><span sty=
le=3D"font-size: 10px;">&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 17&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 sdb1</span><br=
><span style=3D"font-size: 10px;">&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; 18&nbsp; 975755970 sdb2</span><br><span style=3D"font-size: 10p=
x;">root@ubuntu:~#</span> <br><br>Hi Emmanuel, so that should be what you =
asked for? I did a reset in terminal and tried the dmesg, so I hope this d=
idn't wipe any data on the failed mount which I had completed before. I'm =
about to try mouning as read only - fingers crossed!<br>Cheers,<br>Tom<br>=
<br><br><blockquote type=3D"cite"><div class=3D"msg-quote"><div class=3D"_=
stretch"><span style=3D"white-space:pre-wrap;" data-mce-style=3D"white-spa=
ce: pre-wrap;"><br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&g=
t; &nbsp; &nbsp;&gt; Yes it's a NAS drive and so I assume had some kind of=
 proprietary<br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&gt; =
&nbsp; &nbsp;&gt; OS on the other partitions (this is where i might have m=
essed up<br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&gt; &nbs=
p; &nbsp;&gt; by deleting?!) I'm pretty sure that the drive in bold below =
(sdc2)<br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp;&gt; &nbsp;=
 &nbsp;&gt; is the one I'm after which is xfs... <br> &nbsp; &nbsp; &nbsp;=
 &nbsp;&gt; &nbsp; &nbsp; &nbsp;&gt; <br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; =
&nbsp; &nbsp; &nbsp;&gt; Ummm, exactly what are you trying to do with this=
 drive/filesystem?<br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; &nbsp; &nbsp; &nbsp=
;&gt; What device did the drive come from in the first place? <br> &nbsp; =
&nbsp; &nbsp; &nbsp;&gt; <br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; It's a lacie=
 'Neil poulton' network space1 1tb NAS drive (see first<br> &nbsp; &nbsp; =
&nbsp; &nbsp;&gt; paragraph of post) - it recently stopped working and was=
 stuck in a<br> &nbsp; &nbsp; &nbsp; &nbsp;&gt; 'spin cycle' - it contains=
 my music and video backups. I'm trying to<br> &nbsp; &nbsp; &nbsp; &nbsp;=
&gt; recover the files...<br><br>Most probably disk is badly damaged, dead=
 or dying. It's advisable to<br>try to create an image of the disk on anot=
her one, and work for this<br>image, because this disk will probably die a=
ny time now. It's no use<br>trying to repair a filesystem on a bad drive, =
which is the cause of the<br>errors from the beginning. <br><br>If all you=
 care is to get your files back, just try to mount the volume<br>in read-o=
nly, non-recovery mode :<br><br>mount -o ro,norecovery /dev/sdc2 /tmp/moun=
t<br><br>Then proceed by copying whatever you can get. Consider that any f=
ile<br>that gives an error is lost.<br><br>The other option is Kroll Ontra=
ck or similar services, of course.<br><br>-- <br>-------------------------=
-----------------------------------------------<br>Emmanuel Florac | Direc=
tion technique<br> | Intellique<br> | &nbsp; &nbsp; &nbsp;&lt;<a href=3D"m=
ailto:eflorac@intellique.com" data-mce-href=3D"mailto:eflorac@intellique.c=
om">eflorac@intellique.com</a> &nbsp; &nbsp; &nbsp; &nbsp;&gt;<br> | +33 1=
 78 94 84 02<br>----------------------------------------------------------=
--------------<br></span></div></div></blockquote></div></div></body></html>=

--Boundary_(ID_hAgNeBqJCRzm0dnAH0FhmQ)--

--Boundary_(ID_SR8WvReHYm2n+SZJPUUEbg)--


--===============6488239025612151122==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6488239025612151122==--
