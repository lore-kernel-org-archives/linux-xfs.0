Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301E4C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 03:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AACE1206C0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 03:34:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rynhart-co-nz.20150623.gappssmtp.com header.i=@rynhart-co-nz.20150623.gappssmtp.com header.b="z/3ngQnM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfKPDeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 22:34:10 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40266 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfKPDeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 22:34:10 -0500
Received: by mail-lf1-f65.google.com with SMTP id j26so9498596lfh.7
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 19:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rynhart-co-nz.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=WAlH+zfZY5WnyE3+YuHpULtafS2A8seWQmCpqwklJO4=;
        b=z/3ngQnMQoG2n4sliOzUqu+esZoDR3E+F7KwSojGThzwCgmhOvma+06MptKrImsasV
         7s5hNj21CciggSZcpoCTNvSVL5nHJbKMdd+SXc3HC7RXSe4lrg+tJ5r7o+Rk6LqBMnDk
         rDdm5o242pCT/3AWZmXAQziagCUdu0/D0FcxDsheMg6OD84yI//c8wINbpIWqNdEwT0s
         QMR3FiBw/GJ/dfgrY9IUElAV2WmrGNX0pRWzqtle4eZ35LTQU7QyLrXxHLUkh9pecvdG
         g9FDC8iZw3DA1tWzJJaoxYPHjbw5mpzAWjPZ3vY1INtJLlTjH/gMCjPucl2DBhOwpiYJ
         jFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=WAlH+zfZY5WnyE3+YuHpULtafS2A8seWQmCpqwklJO4=;
        b=Bh2o6J7iXOsCF8iohxIIhWJIrMhKVKujnxFg9ul9y7pkNiEIZRxnrwO+5EzalQqA4G
         uf/R3hsuR8JxaBfPZIhPV6L0MOFCTUyvmeMvnyy57sXXO3n+3AKyJuSXY8dzte3URS/X
         qNBcF3K7KVKJsR31bCi2DpywiZ53hWimmpnxEf1XrGDhfG6+0fs64/+nKqmXe+/NN3dq
         YxYtrKBUesmB5eN2AYe10W/MDmMcx/ZvdvdrtTmmwK32603T9Q594LS/Qu5DKiVGmxRF
         OEAURgutecGh9t++GGuzltkr03BLXDjr4DUcSKqU3mYmbduRyblFjwiJZo8gGASYcL76
         iugQ==
X-Gm-Message-State: APjAAAX52RB8rYjJiSgVpm1QHdjQmKIWOPfzIGsd6wokFfEPrTj4/AJQ
        qOOoUbKejs0luMlW+OqggibAXyaVTRSGG/HDbbulAeF4djrrVA==
X-Google-Smtp-Source: APXvYqwmJ9vMeEA1++pSuP9PPIPxAp0r32DHCu2SMZCduC9YtcohtlAflx0UbGkFz0KLw46fuAYeHhwEtKRtA+4ZWCw=
X-Received: by 2002:ac2:5f01:: with SMTP id 1mr13229309lfq.147.1573875238695;
 Fri, 15 Nov 2019 19:33:58 -0800 (PST)
MIME-Version: 1.0
From:   Patrick Rynhart <patrick@rynhart.co.nz>
Date:   Sat, 16 Nov 2019 16:33:45 +1300
Message-ID: <CAMbe+5D9cSEpR2YTWTmigi77caw93p6qR-iAYf-X_3_OJQMROw@mail.gmail.com>
Subject: Inflight Corruption of XFS filesystem on CentOS 7.7 VMs
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A small number of our CentOS VMs (about 4 out of a fleet of 200) are
experiencing ongoing, regular XFS corruption - and I'm not sure how to
troubleshoot the problem.  They are all CentOS 7.7 VMs are are using
VMWare Paravirtual SCSI.  The version of xfsprogs being used is
4.5.0-20.el7.x86_64, and the kernel is 3.10.0-1062.1.2.el7.x86_64.
The VMWare version is ESXi, 6.5.0, 14320405.

When the fault happens - the VMs will go into single user mode with
the following text displayed on the console:

sd 0:0:0:0: [sda] Assuming drive cache: write through
XFS (dm-0): Internal error XFS_WANT_CORRUPTED_GOTO at line 1664 of
file fs/xfs/libxfs
/xfs_alloc.c. Caller xfs_free_extent+0xaa/0x140 [xfs]
XFS (dm-0): Internal error xfs_trans_cancel at line 984 of file
fs/xfs/xfs_trans.c.
Caller xfs_efi_recover+0x17d/0x1a0 [xfs]
XFS (dm-0): Corruption of in-memory data detected. Shutting down filesystem
XFS (dm-0): Please umount the filesystem and rectify the problem(s)
XFS (dm-0): Failed to recover intents

Generating =E2=80=9C/run/initramfs/rdsosreport.txt=E2=80=9D
Entering emergency mode. Exit the shell to continue.
Type =E2=80=9C journalctl=E2=80=9D to view system logs.

You might want to save "/run/initramfs/rdsosreport.txt=E2=80=9D to a USB st=
ick or /boot
after mounting them and attach it to a bug report.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

The actions we are currently taking is to boot off a CentOS DVD (in
rescue mode) and running an XFS Repair.  Obviously this isn't a good
long-term solution :-)

I am wondering if I could please have some help troubleshooting this
problem.  I'm new to XFS but have managed to look at a few similar
bug/fault reports and have compiled some diagnostic information which
may be helpful below.

For an affected VM, this is the output of xfs_info:

# xfs_info /
meta-data=3D/dev/mapper/cl_tur--cmsadm1-root isize=3D512    agcount=3D4,
agsize=3D3276800 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D13107200, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal               bsize=3D4096   blocks=3D6400, version=3D=
2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Additionally:

# blockdev --getsz  --getsize64 --getss --getpbsz  --getiomin
--getioopt /dev/mapper/cl_tur--cmsadm1-root
104857600
53687091200
512
512
512
0

The full output of lspci -vvv also follows below.

Thank you all in advance,

Patrick Rynhart

# lspci -vvv
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX
Host bridge (rev 01)
Subsystem: VMware Virtual Machine Chipset
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP
bridge (rev 01) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: fff00000-000fffff
Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B+
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 08)
Subsystem: VMware Virtual Machine Chipset
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev
01) (prog-if 8a [ISA Compatibility mode controller, supports both
channels switched to PCI native mode, supports bus mastering])
Subsystem: VMware Virtual Machine Chipset
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64
Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=3D8=
]
Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=3D8=
]
Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
Region 4: I/O ports at 1060 [size=3D16]
Kernel driver in use: ata_piix
Kernel modules: ata_piix, pata_acpi, ata_generic

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 08)
Subsystem: VMware Virtual Machine Chipset
Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin ? routed to IRQ 9
Kernel modules: i2c_piix4

00:07.7 System peripheral: VMware Virtual Machine Communication
Interface (rev 10)
Subsystem: VMware Virtual Machine Communication Interface
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (1500ns min, 63750ns max)
Interrupt: pin A routed to IRQ 16
Region 0: I/O ports at 1080 [size=3D64]
Region 1: Memory at febfe000 (64-bit, non-prefetchable) [size=3D8K]
Capabilities: [40] MSI: Enable- Count=3D1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [58] MSI-X: Enable+ Count=3D2 Masked-
Vector table: BAR=3D1 offset=3D00000000
PBA: BAR=3D1 offset=3D00001000
Kernel driver in use: vmw_vmci
Kernel modules: vmw_vmci

00:0f.0 VGA compatible controller: VMware SVGA II Adapter (prog-if 00
[VGA controller])
Subsystem: VMware SVGA II Adapter
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 16
Region 0: I/O ports at 1070 [size=3D16]
Region 1: Memory at e8000000 (32-bit, prefetchable) [size=3D128M]
Region 2: Memory at fe000000 (32-bit, non-prefetchable) [size=3D8M]
[virtual] Expansion ROM at c0600000 [disabled] [size=3D32K]
Capabilities: [40] Vendor Specific Information: Len=3D00 <?>
Capabilities: [44] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: vmwgfx
Kernel modules: vmwgfx

00:11.0 PCI bridge: VMware PCI bridge (rev 02) (prog-if 01 [Subtractive dec=
ode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 32 bytes
Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D68
I/O behind bridge: 00002000-00003fff
Memory behind bridge: fd500000-fdffffff
Prefetchable memory behind bridge: 00000000e7b00000-00000000e7ffffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI bridge

00:15.0 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 24
Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
I/O behind bridge: 00004000-00004fff
Memory behind bridge: fd400000-fd4fffff
Prefetchable memory behind bridge: 00000000c0000000-00000000c01fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #160, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4041
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:15.1 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 25
Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0
I/O behind bridge: 00008000-00008fff
Memory behind bridge: fd000000-fd0fffff
Prefetchable memory behind bridge: 00000000e7900000-00000000e79fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #161, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4051
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:15.2 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 26
Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D0
I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: fcc00000-fccfffff
Prefetchable memory behind bridge: 00000000e7500000-00000000e75fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #162, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4061
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:15.3 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 27
Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc800000-fc8fffff
Prefetchable memory behind bridge: 00000000e7100000-00000000e71fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #163, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4071
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:15.4 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 28
Bus: primary=3D00, secondary=3D07, subordinate=3D07, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc400000-fc4fffff
Prefetchable memory behind bridge: 00000000e6d00000-00000000e6dfffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #164, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4081
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:15.5 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 29
Bus: primary=3D00, secondary=3D08, subordinate=3D08, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc000000-fc0fffff
Prefetchable memory behind bridge: 00000000e6900000-00000000e69fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #165, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4091
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:15.6 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 30
Bus: primary=3D00, secondary=3D09, subordinate=3D09, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fbc00000-fbcfffff
Prefetchable memory behind bridge: 00000000e6500000-00000000e65fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #166, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40a1
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:15.7 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 31
Bus: primary=3D00, secondary=3D0a, subordinate=3D0a, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fb800000-fb8fffff
Prefetchable memory behind bridge: 00000000e6100000-00000000e61fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #167, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40b1
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.0 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 32
Bus: primary=3D00, secondary=3D0b, subordinate=3D0b, sec-latency=3D0
I/O behind bridge: 00005000-00005fff
Memory behind bridge: fd300000-fd3fffff
Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #192, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40c1
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.1 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 33
Bus: primary=3D00, secondary=3D0c, subordinate=3D0c, sec-latency=3D0
I/O behind bridge: 00009000-00009fff
Memory behind bridge: fcf00000-fcffffff
Prefetchable memory behind bridge: 00000000e7800000-00000000e78fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #193, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40d1
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.2 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 34
Bus: primary=3D00, secondary=3D0d, subordinate=3D0d, sec-latency=3D0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: fcb00000-fcbfffff
Prefetchable memory behind bridge: 00000000e7400000-00000000e74fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #194, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40e1
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.3 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 35
Bus: primary=3D00, secondary=3D0e, subordinate=3D0e, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc700000-fc7fffff
Prefetchable memory behind bridge: 00000000e7000000-00000000e70fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #195, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4022
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.4 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 36
Bus: primary=3D00, secondary=3D0f, subordinate=3D0f, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc300000-fc3fffff
Prefetchable memory behind bridge: 00000000e6c00000-00000000e6cfffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #196, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4042
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.5 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 37
Bus: primary=3D00, secondary=3D10, subordinate=3D10, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fbf00000-fbffffff
Prefetchable memory behind bridge: 00000000e6800000-00000000e68fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #197, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4052
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.6 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 38
Bus: primary=3D00, secondary=3D11, subordinate=3D11, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fbb00000-fbbfffff
Prefetchable memory behind bridge: 00000000e6400000-00000000e64fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #198, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4062
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:16.7 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 39
Bus: primary=3D00, secondary=3D12, subordinate=3D12, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fb700000-fb7fffff
Prefetchable memory behind bridge: 00000000e6000000-00000000e60fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #199, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4072
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.0 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 40
Bus: primary=3D00, secondary=3D13, subordinate=3D13, sec-latency=3D0
I/O behind bridge: 00006000-00006fff
Memory behind bridge: fd200000-fd2fffff
Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #224, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4082
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.1 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 41
Bus: primary=3D00, secondary=3D14, subordinate=3D14, sec-latency=3D0
I/O behind bridge: 0000a000-0000afff
Memory behind bridge: fce00000-fcefffff
Prefetchable memory behind bridge: 00000000e7700000-00000000e77fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #225, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4092
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.2 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 42
Bus: primary=3D00, secondary=3D15, subordinate=3D15, sec-latency=3D0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: fca00000-fcafffff
Prefetchable memory behind bridge: 00000000e7300000-00000000e73fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #226, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40a2
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.3 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 43
Bus: primary=3D00, secondary=3D16, subordinate=3D16, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc600000-fc6fffff
Prefetchable memory behind bridge: 00000000e6f00000-00000000e6ffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #227, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40b2
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.4 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 44
Bus: primary=3D00, secondary=3D17, subordinate=3D17, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc200000-fc2fffff
Prefetchable memory behind bridge: 00000000e6b00000-00000000e6bfffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #228, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40c2
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.5 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 45
Bus: primary=3D00, secondary=3D18, subordinate=3D18, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fbe00000-fbefffff
Prefetchable memory behind bridge: 00000000e6700000-00000000e67fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #229, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40d2
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.6 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 46
Bus: primary=3D00, secondary=3D19, subordinate=3D19, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fba00000-fbafffff
Prefetchable memory behind bridge: 00000000e6300000-00000000e63fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #230, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40e2
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:17.7 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 47
Bus: primary=3D00, secondary=3D1a, subordinate=3D1a, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fb600000-fb6fffff
Prefetchable memory behind bridge: 00000000e5f00000-00000000e5ffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #231, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4023
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.0 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 48
Bus: primary=3D00, secondary=3D1b, subordinate=3D1b, sec-latency=3D0
I/O behind bridge: 00007000-00007fff
Memory behind bridge: fd100000-fd1fffff
Prefetchable memory behind bridge: 00000000e7a00000-00000000e7afffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #256, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4043
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.1 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 49
Bus: primary=3D00, secondary=3D1c, subordinate=3D1c, sec-latency=3D0
I/O behind bridge: 0000b000-0000bfff
Memory behind bridge: fcd00000-fcdfffff
Prefetchable memory behind bridge: 00000000e7600000-00000000e76fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #257, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4053
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.2 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 50
Bus: primary=3D00, secondary=3D1d, subordinate=3D1d, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc900000-fc9fffff
Prefetchable memory behind bridge: 00000000e7200000-00000000e72fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #258, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4063
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.3 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 51
Bus: primary=3D00, secondary=3D1e, subordinate=3D1e, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc500000-fc5fffff
Prefetchable memory behind bridge: 00000000e6e00000-00000000e6efffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #259, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4073
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.4 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 52
Bus: primary=3D00, secondary=3D1f, subordinate=3D1f, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fc100000-fc1fffff
Prefetchable memory behind bridge: 00000000e6a00000-00000000e6afffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #260, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4083
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.5 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 53
Bus: primary=3D00, secondary=3D20, subordinate=3D20, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fbd00000-fbdfffff
Prefetchable memory behind bridge: 00000000e6600000-00000000e66fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #261, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 4093
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.6 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 54
Bus: primary=3D00, secondary=3D21, subordinate=3D21, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fb900000-fb9fffff
Prefetchable memory behind bridge: 00000000e6200000-00000000e62fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #262, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40a3
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

00:18.7 PCI bridge: VMware PCI Express Root Port (rev 01) (prog-if 00
[Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin ? routed to IRQ 55
Bus: primary=3D00, secondary=3D22, subordinate=3D22, sec-latency=3D0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fb500000-fb5fffff
Prefetchable memory behind bridge: 00000000e5e00000-00000000e5efffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: VMware PCI Express Root Port
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [50] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #263, PowerLimit 240.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
Control: AttnInd Unknown, PwrInd Unknown, Power+ Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [8c] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
Address: 00000000fee00000  Data: 40b3
Masking: 00000000  Pending: 00000000
Kernel driver in use: pcieport

02:01.0 SATA controller: VMware SATA AHCI controller (prog-if 01 [AHCI 1.0]=
)
Subsystem: VMware SATA AHCI controller
Physical Slot: 33
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64
Interrupt: pin A routed to IRQ 67
Region 5: Memory at fd5ff000 (32-bit, non-prefetchable) [size=3D4K]
[virtual] Expansion ROM at fd500000 [disabled] [size=3D64K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3cold-=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [48] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
Address: 00000000fee06000  Data: 4045
Capabilities: [60] SATA HBA v1.0 InCfgSpace
Capabilities: [70] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ahci
Kernel modules: ahci

03:00.0 Ethernet controller: VMware VMXNET3 Ethernet Controller (rev 01)
Subsystem: VMware VMXNET3 Ethernet Controller
Physical Slot: 160
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at fd4fc000 (32-bit, non-prefetchable) [size=3D4K]
Region 1: Memory at fd4fd000 (32-bit, non-prefetchable) [size=3D4K]
Region 2: Memory at fd4fe000 (32-bit, non-prefetchable) [size=3D8K]
Region 3: I/O ports at 4000 [size=3D16]
[virtual] Expansion ROM at fd400000 [disabled] [size=3D64K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [48] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset- SlotPowerLimit 0.000W
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [84] MSI: Enable- Count=3D1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [9c] MSI-X: Enable+ Count=3D25 Masked-
Vector table: BAR=3D2 offset=3D00000000
PBA: BAR=3D2 offset=3D00001000
Capabilities: [100 v1] Device Serial Number ff-56-50-00-e7-60-9a-fe
Kernel driver in use: vmxnet3
Kernel modules: vmxnet3

0b:00.0 Ethernet controller: VMware VMXNET3 Ethernet Controller (rev 01)
Subsystem: VMware VMXNET3 Ethernet Controller
Physical Slot: 192
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 19
Region 0: Memory at fd3fc000 (32-bit, non-prefetchable) [size=3D4K]
Region 1: Memory at fd3fd000 (32-bit, non-prefetchable) [size=3D4K]
Region 2: Memory at fd3fe000 (32-bit, non-prefetchable) [size=3D8K]
Region 3: I/O ports at 5000 [size=3D16]
[virtual] Expansion ROM at fd300000 [disabled] [size=3D64K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [48] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset- SlotPowerLimit 0.000W
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [84] MSI: Enable- Count=3D1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [9c] MSI-X: Enable+ Count=3D25 Masked-
Vector table: BAR=3D2 offset=3D00000000
PBA: BAR=3D2 offset=3D00001000
Capabilities: [100 v1] Device Serial Number ff-56-50-00-5d-05-9a-fe
Kernel driver in use: vmxnet3
Kernel modules: vmxnet3

13:00.0 Serial Attached SCSI controller: VMware PVSCSI SCSI Controller (rev=
 02)
Subsystem: VMware PVSCSI SCSI Controller
Physical Slot: 224
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Region 0: I/O ports at 6000 [size=3D8]
Region 1: Memory at fd2f8000 (64-bit, non-prefetchable) [size=3D32K]
[virtual] Expansion ROM at fd200000 [disabled] [size=3D64K]
Capabilities: [40] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset+ SlotPowerLimit 0.000W
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x32, ASPM L0s, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x32, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
 Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [7c] MSI: Enable- Count=3D1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [94] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+=
)
Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
Capabilities: [9c] MSI-X: Enable+ Count=3D24 Masked-
Vector table: BAR=3D1 offset=3D00006000
PBA: BAR=3D1 offset=3D00007000
Capabilities: [100 v1] Device Serial Number bc-a4-28-20-50-05-05-60
Kernel driver in use: vmw_pvscsi
Kernel modules: vmw_pvscsi
