Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C1BD7F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 10:35:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DB2AAC003
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 08:35:08 -0700 (PDT)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
	[74.125.82.172]) by cuda.sgi.com with ESMTP id hpVFA7EReDLHaOjb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Aug 2014 08:35:00 -0700 (PDT)
Received: by mail-we0-f172.google.com with SMTP id x48so8810342wes.3
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 08:34:59 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177]) by mx.google.com with ESMTPSA id
	mw4sm45075734wic.20.2014.08.11.08.34.56 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 08:34:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 71C6B185A7D
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 17:34:54 +0200 (CEST)
Date: Mon, 11 Aug 2014 17:34:46 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <53E8D9F6.7080704@sgi.com>
Message-ID: <alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-1326823490-1407771294=:7326"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463779071-1326823490-1407771294=:7326
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



El 2014-08-11 a las 09:57 -0500, Mark Tinguely escribió:
> On 08/11/14 09:23, Carlos E. R. wrote:

> Where in the filesystem did the XFS_WANT_CORRUPTED_GOTO happen?

This time?
Did not look at the log yet. Let me see...

Here is the full log of the event. It starts prior to hibernating, all 
things nominal. And ends on shutdown (had to hit reset button, despite 
what log says). If you want to see entries prior to that, since boot, I 
can do that.


<3.6> 2014-08-11 05:15:01 Telcontar systemd 1 - -  Starting Session 556 of user news.
<3.6> 2014-08-11 05:18:01 Telcontar systemd 1 - -  Starting Session 557 of user news.
<3.6> 2014-08-11 05:20:01 Telcontar systemd 1 - -  Starting Session 558 of user cer.
<3.4> 2014-08-11 05:22:25 Telcontar pm-utils - - -  Hibernating the system now (04)...
<3.5> 2014-08-11 05:22:25 Telcontar pm-utils - - -  There appears not be any pending nntp post to be sent. I just checked :-)
<1.5> 2014-08-11 05:22:25 Telcontar network 5840 - -  redirecting to "systemctl --signal=9 kill network.service"
<3.5> 2014-08-11 05:22:25 Telcontar systemd 1 - -  network@eth0.service: main process exited, code=killed, status=9/KILL
<3.6> 2014-08-11 05:22:25 Telcontar systemd 1 - -  Stopping LSB: Network time protocol daemon (ntpd)...
<3.6> 2014-08-11 05:22:25 Telcontar ntp 5867 - -  Shutting down network time protocol daemon (NTPD)..done
<3.6> 2014-08-11 05:22:25 Telcontar systemd 1 - -  Stopped LSB: Network time protocol daemon (ntpd).
<3.4> 2014-08-11 05:22:25 Telcontar pm-utils - - -  Hibernating (95)...
<0.7> 2014-08-11 05:22:30 Telcontar kernel - - - [73220.857511] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
<0.7> 2014-08-11 05:22:30 Telcontar kernel - - - [73220.857516] PM: Marking nosave pages: [mem 0xbff90000-0xffffffff]
<0.7> 2014-08-11 05:22:30 Telcontar kernel - - - [73220.858132] PM: Basic memory bitmaps created
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73221.946553] Syncing filesystems ... done.
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73222.682396] Freezing user space processes ... (elapsed 0.002 seconds) done.
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73222.685031] PM: Preallocating image memory... done (allocated 1140745 pages)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.046524] PM: Allocated 4562980 kbytes in 5.36 seconds (851.30 MB/s)
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.046645] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.048553] Suspending console(s) (use no_console_suspend to debug)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.049663] serial 00:05: disabled
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.260091] PM: freeze of devices complete after 211.420 msecs
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.260391] PM: late freeze of devices complete after 0.298 msecs
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.260939] PM: noirq freeze of devices complete after 0.545 msecs
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.260940] Disabling non-boot CPUs ...
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.262294] smpboot: CPU 1 is now offline
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.264134] smpboot: CPU 2 is now offline
<0.5> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.265056] Broke affinity for irq 16
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.266103] smpboot: CPU 3 is now offline
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.266614] PM: Creating hibernation image:
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.267097] PM: Need to copy 920142 pages
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.267097] PM: Normal pages needed: 920142 + 1024, available pages: 1176633
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.267097] microcode: CPU0 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.267097] Enabling non-boot CPUs ...
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.267097] smpboot: Booting Node 0 Processor 1 APIC 0x1
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.280111] microcode: CPU1 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.280300] CPU1 is up
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.280425] smpboot: Booting Node 0 Processor 2 APIC 0x2
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.293688] microcode: CPU2 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.293828] CPU2 is up
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.293918] smpboot: Booting Node 0 Processor 3 APIC 0x3
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.307216] microcode: CPU3 sig=0x1067a, pf=0x10, revision=0xa0b
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.307358] CPU3 is up
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.335219] PM: noirq restore of devices complete after 22.779 msecs
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.335354] PM: early restore of devices complete after 0.110 msecs
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508789] uhci_hcd 0000:00:1a.0: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508809] usb usb3: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508819] uhci_hcd 0000:00:1a.1: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508836] usb usb4: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508844] uhci_hcd 0000:00:1a.2: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508861] usb usb5: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508871] ehci-pci 0000:00:1a.7: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.508889] usb usb1: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510138] uhci_hcd 0000:00:1d.0: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510159] usb usb6: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510168] uhci_hcd 0000:00:1d.1: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510187] usb usb7: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510196] uhci_hcd 0000:00:1d.2: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510215] usb usb8: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510225] ehci-pci 0000:00:1d.7: setting latency timer to 64
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.510235] usb usb2: root hub lost power or was reset
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.512778] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.512784] pci 0000:00:1e.0: setting latency timer to 64
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.512879] ata_piix 0000:00:1f.2: setting latency timer to 64
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.512934] ata_piix 0000:00:1f.5: setting latency timer to 64
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.514123] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611029] pciehp 0000:00:1c.3:pcie04: Device 0000:05:00.0 already exists at 0000:05:00, cannot hot-add
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611032] pciehp 0000:00:1c.0:pcie04: Device 0000:02:00.0 already exists at 0000:02:00, cannot hot-add
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611035] pciehp 0000:00:1c.2:pcie04: Device 0000:04:00.0 already exists at 0000:04:00, cannot hot-add
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611036] pciehp 0000:00:1c.3:pcie04: Cannot add device at 0000:05:00
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611037] pciehp 0000:00:1c.0:pcie04: Cannot add device at 0000:02:00
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611039] pciehp 0000:00:1c.2:pcie04: Cannot add device at 0000:04:00
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611061] pciehp 0000:00:1c.4:pcie04: Device 0000:06:00.0 already exists at 0000:06:00, cannot hot-add
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611062] pciehp 0000:00:1c.4:pcie04: Cannot add device at 0000:06:00
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611086] pciehp 0000:00:1c.5:pcie04: Device 0000:07:00.0 already exists at 0000:07:00, cannot hot-add
<0.3> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611087] pciehp 0000:00:1c.5:pcie04: Cannot add device at 0000:07:00
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611172] pata_jmicron 0000:05:00.1: setting latency timer to 64
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.611249] pata_jmicron 0000:04:00.1: setting latency timer to 64
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.614064] serial 00:05: activated
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.775267] r8169 0000:06:00.0 eth0: link down
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.837013] ata11: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.837220] r8169 0000:07:00.0 eth1: link down
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.916030] ata2: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.916069] ata1: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.920031] ata4: SATA link down (SStatus 0 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.930018] usb 1-2: reset high-speed USB device number 3 using ehci-pci
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.988036] ata12: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.991149] ata12.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.991151] ata12.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.991152] ata12.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73228.997133] ata12.00: configured for UDMA/100
<0.5> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.069020] firewire_core 0000:08:02.0: rediscovered device fw0
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.074017] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.076182] ata3.00: configured for UDMA/133
<0.5> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.076210] sd 2:0:0:0: [sda] Starting disk
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.146014] usb 2-5: reset high-speed USB device number 2 using ehci-pci
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.284050] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.284060] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.284167] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.284177] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287190] ata9.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287191] ata9.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287241] ata10.01: ACPI cmd ef/03:45:00:00:00:b0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287242] ata10.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered out
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287362] ata9.01: ACPI cmd c6/00:10:00:00:00:b0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287364] ata9.01: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287457] ata10.01: ACPI cmd c6/00:10:00:00:00:b0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.287459] ata10.01: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293185] ata10.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293186] ata10.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293236] ata9.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293237] ata9.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293378] ata10.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293379] ata10.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293443] ata9.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.293445] ata9.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.302319] ata9.00: configured for UDMA/133
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.308304] ata9.01: configured for UDMA/133
<0.5> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.308337] sd 8:0:0:0: [sdb] Starting disk
<0.5> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.308338] sd 8:0:1:0: [sdc] Starting disk
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.318322] ata10.00: configured for UDMA/133
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.324321] ata10.01: configured for UDMA/133
<0.5> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.324351] sd 9:0:1:0: [sde] Starting disk
<0.5> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.324352] sd 9:0:0:0: [sdd] Starting disk
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73229.512018] usb 3-1: reset low-speed USB device number 2 using uhci_hcd
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73230.057013] usb 8-2: reset low-speed USB device number 2 using uhci_hcd
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73230.408094] usb 2-5.4: reset high-speed USB device number 4 using ehci-pci
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73230.798419] r8169 0000:06:00.0 eth0: link up
<0.6> 2014-08-11 15:17:18 Telcontar kernel - - - [73231.245103] PM: restore of devices complete after 2736.365 msecs
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73231.514298] Restarting kernel threads ... done.
<0.4> 2014-08-11 15:17:18 Telcontar kernel - - - [73231.518736] Restarting tasks ... done.
<0.7> 2014-08-11 15:17:18 Telcontar kernel - - - [73231.562307] PM: Basic memory bitmaps freed
<3.4> 2014-08-11 15:17:19 Telcontar rtkit-daemon 4535 - -  The canary thread is apparently starving. Taking action.
<3.6> 2014-08-11 15:17:19 Telcontar rtkit-daemon 4535 - -  Demoting known real-time threads.
<3.5> 2014-08-11 15:17:19 Telcontar rtkit-daemon 4535 - -  Successfully demoted thread 4541 of process 4534 (/usr/bin/pulseaudio).
<3.5> 2014-08-11 15:17:19 Telcontar rtkit-daemon 4535 - -  Successfully demoted thread 4540 of process 4534 (/usr/bin/pulseaudio).
<3.5> 2014-08-11 15:17:19 Telcontar rtkit-daemon 4535 - -  Successfully demoted thread 4534 of process 4534 (/usr/bin/pulseaudio).
<3.5> 2014-08-11 15:17:19 Telcontar rtkit-daemon 4535 - -  Demoted 3 threads.
<0.1> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.439809] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.1
<0.1> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.439809].
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440155] CPU: 0 PID: 6255 Comm: kworker/0:7 Tainted: P           O 3.11.10-17-desktop #1
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440322] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440361] Workqueue: xfs-eofblocks/sdd5 xfs_eofblocks_worker [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440364]  0000000000000001 ffffffff815a0402 000000000010c9d3 ffffffffa0c38996
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440365]  ffff880211412b00 ffff88023448dd80 ffff88023fb95cb0 0000000000000001
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440366]  0000000000000000 0000000100000000 0000000000000000 0000000000000001
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440367] Call Trace:
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440377]  [<ffffffff81004a28>] dump_trace+0x88/0x310
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440380]  [<ffffffff81004d80>] show_stack_log_lvl+0xd0/0x1d0
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440382]  [<ffffffff810061bc>] show_stack+0x1c/0x50
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440385]  [<ffffffff815a0402>] dump_stack+0x50/0x89
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440399]  [<ffffffffa0c38996>] xfs_free_ag_extent+0x226/0x860 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440442]  [<ffffffffa0c39fe9>] xfs_free_extent+0xb9/0xf0 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440484]  [<ffffffffa0c4c39e>] xfs_bmap_finish+0x11e/0x170 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440534]  [<ffffffffa0c6b4c0>] xfs_itruncate_extents+0x190/0x340 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440597]  [<ffffffffa0c33633>] xfs_free_eofblocks+0x1e3/0x260 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440633]  [<ffffffffa0c291ef>] xfs_inode_free_eofblocks+0x6f/0x150 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440662]  [<ffffffffa0c27f82>] xfs_inode_ag_walk.isra.10+0x1c2/0x310 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440690]  [<ffffffffa0c28a8e>] xfs_inode_ag_iterator_tag+0x6e/0xb0 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440718]  [<ffffffffa0c28d82>] xfs_eofblocks_worker+0x12/0x20 [xfs]
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440737]  [<ffffffff8106ac78>] process_one_work+0x168/0x490
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440739]  [<ffffffff8106b914>] worker_thread+0x114/0x3a0
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440742]  [<ffffffff81071c3f>] kthread+0xaf/0xc0
<0.4> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440746]  [<ffffffff815adfbc>] ret_from_fork+0x7c/0xb0
<0.5> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.440751] XFS (sdd5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-
<0.1> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.498979] XFS (sdd5): Corruption of in-memory data detected.  Shutting down filesystem
<0.1> 2014-08-11 15:17:22 Telcontar kernel - - - [73235.499136] XFS (sdd5): Please umount the filesystem and rectify the problem(s)
<3.6> 2014-08-11 15:17:22 Telcontar systemd 1 - -  Time has been changed
<3.6> 2014-08-11 15:17:27 Telcontar acpid - - -  1 client rule loaded
<3.4> 2014-08-11 15:17:29 Telcontar pm-utils - - -  Thawing (95)...
<3.5> 2014-08-11 15:17:30 Telcontar dbus 1020 - -  [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
<3.6> 2014-08-11 15:17:30 Telcontar systemd 1 - -  Starting LSB: Network time protocol daemon (ntpd)...
<0.4> 2014-08-11 15:17:30 Telcontar kernel - - - [73244.256012] XFS (sdd5): xfs_log_force: error 5 returned.
<3.5> 2014-08-11 15:17:31 Telcontar dbus 1020 - -  [system] Activated service 'org.freedesktop.PackageKit' failed: Cannot launch daemon, file not found or permissions invalid
<1.5> 2014-08-11 15:17:31 Telcontar network 6315 - -  redirecting to "systemctl  restart network.service"
<3.6> 2014-08-11 15:17:32 Telcontar systemd 1 - -  Stopping ifup managed network interface eth1...
<3.6> 2014-08-11 15:17:32 Telcontar systemd 1 - -  Stopping ifup managed network interface eth0...
<3.6> 2014-08-11 15:17:32 Telcontar systemd 1 - -  Stopping LSB: Configure network interfaces and set up routing...
<3.6> 2014-08-11 15:17:32 Telcontar systemd 1 - -  Starting LSB: Configure network interfaces and set up routing...
<3.6> 2014-08-11 15:17:32 Telcontar ifdown 6352 - -  touch: cannot touch ‘/dev/.sysconfig/network/tmp/if-eth0.6352’: No such file or directory
<3.6> 2014-08-11 15:17:32 Telcontar ifdown 6352 - -  scripts/functions: line 1221: /dev/.sysconfig/network/tmp/if-eth0.6352.tmp: No such file or directory
<3.6> 2014-08-11 15:17:32 Telcontar ifdown 6352 - -  scripts/functions: line 1239: /dev/.sysconfig/network/tmp/if-eth0.6352.tmp: No such file or directory
<3.6> 2014-08-11 15:17:32 Telcontar ifdown 6352 - -  cat: /dev/.sysconfig/network/tmp/if-eth0.6352: No such file or directory
<3.6> 2014-08-11 15:17:34 Telcontar ntp 6314 - -  11 Aug 15:17:34 sntp[6505]: Started sntp
<3.6> 2014-08-11 15:17:34 Telcontar ifdown 6352 - -  eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-08-11 15:17:34 Telcontar ifdown 6352 - -      eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<3.6> 2014-08-11 15:17:34 Telcontar ifdown 6351 - -  eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-08-11 15:17:34 Telcontar ifdown 6351 - -      eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<3.6> 2014-08-11 15:17:34 Telcontar network 6384 - -  Setting up network interfaces:
<3.6> 2014-08-11 15:17:34 Telcontar network 6384 - -  lo
<1.5> 2014-08-11 15:17:34 Telcontar ifup 6924 - -      lo
<1.5> 2014-08-11 15:17:35 Telcontar ifup 6924 - -      lo
<1.5> 2014-08-11 15:17:35 Telcontar ifup 6924 - -  IP address: 127.0.0.1/8
<3.6> 2014-08-11 15:17:35 Telcontar network 6384 - -  lo        IP address: 127.0.0.1/8
<1.5> 2014-08-11 15:17:35 Telcontar ifup 6924 - -.
<16.3> 2014-08-11 15:17:38 Telcontar dhcpcd 7162 - -  eth1: dhcpcd not running
<16.6> 2014-08-11 15:17:38 Telcontar dhcpcd 7162 - -  eth1: exiting
<3.5> 2014-08-11 15:17:38 Telcontar systemd 1 - -  Unit network@eth0.service entered failed state.
<3.6> 2014-08-11 15:17:38 Telcontar systemd 1 - -  Starting ifup managed network interface eth0...
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Interface eth0.IPv6 no longer relevant for mDNS.
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Leaving mDNS multicast group on interface eth0.IPv6 with address fc00::14.
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Interface eth0.IPv4 no longer relevant for mDNS.
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Leaving mDNS multicast group on interface eth0.IPv4 with address 192.168.1.14.
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Withdrawing address record for fc00::14 on eth0.
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Withdrawing address record for 192.168.1.14 on eth0.
<3.6> 2014-08-11 15:17:38 Telcontar ifup 7226 - -  eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-08-11 15:17:38 Telcontar ifup 7226 - -      eth0      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<0.6> 2014-08-11 15:17:38 Telcontar kernel - - - [73251.792336] r8169 0000:06:00.0 eth0: link down
<0.6> 2014-08-11 15:17:38 Telcontar kernel - - - [73251.792353] r8169 0000:06:00.0 eth0: link down
<0.6> 2014-08-11 15:17:38 Telcontar kernel - - - [73251.792366] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Joining mDNS multicast group on interface eth0.IPv4 with address 192.168.1.14.
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  New relevant interface eth0.IPv4 for mDNS.
<3.6> 2014-08-11 15:17:38 Telcontar avahi-daemon 1007 - -  Registering new address record for 192.168.1.14 on eth0.IPv4.
<3.6> 2014-08-11 15:17:39 Telcontar systemd 1 - -  Starting ifup managed network interface eth1...
<3.6> 2014-08-11 15:17:39 Telcontar ifplugd(eth1) 7541 - -  ifplugd 0.28 initializing.
<0.6> 2014-08-11 15:17:39 Telcontar kernel - - - [73252.646313] r8169 0000:07:00.0 eth1: link down
<0.6> 2014-08-11 15:17:39 Telcontar kernel - - - [73252.646341] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
<3.6> 2014-08-11 15:17:39 Telcontar ifplugd(eth1) 7541 - -  Using interface eth1/00:21:85:16:2D:0C with driver <r8169> (version: 2.3LK-NAPI)
<3.6> 2014-08-11 15:17:39 Telcontar ifplugd(eth1) 7541 - -  Using detection mode: SIOCETHTOOL
<3.6> 2014-08-11 15:17:39 Telcontar ifplugd(eth1) 7541 - -  Initialization complete, link beat not detected.
<1.5> 2014-08-11 15:17:39 Telcontar ifup 7521 - -      eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<1.5> 2014-08-11 15:17:39 Telcontar ifup 7521 - -      eth1      is controlled by ifplugd
<3.6> 2014-08-11 15:17:39 Telcontar ifup 7521 - -  eth1      device: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
<3.6> 2014-08-11 15:17:39 Telcontar ifup 7521 - -  eth1      is controlled by ifplugd
<3.6> 2014-08-11 15:17:39 Telcontar systemd 1 - -  Started ifup managed network interface eth1.
<0.6> 2014-08-11 15:17:40 Telcontar kernel - - - [73253.958299] r8169 0000:06:00.0 eth0: link up
<0.6> 2014-08-11 15:17:40 Telcontar kernel - - - [73253.958306] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<3.6> 2014-08-11 15:17:41 Telcontar avahi-daemon 1007 - -  Joining mDNS multicast group on interface eth0.IPv6 with address fe80::221:85ff:fe16:2d0b.
<3.6> 2014-08-11 15:17:41 Telcontar avahi-daemon 1007 - -  New relevant interface eth0.IPv6 for mDNS.
<3.6> 2014-08-11 15:17:41 Telcontar avahi-daemon 1007 - -  Registering new address record for fe80::221:85ff:fe16:2d0b on eth0.*.
<3.6> 2014-08-11 15:17:42 Telcontar avahi-daemon 1007 - -  Leaving mDNS multicast group on interface eth0.IPv6 with address fe80::221:85ff:fe16:2d0b.
<3.6> 2014-08-11 15:17:42 Telcontar avahi-daemon 1007 - -  Joining mDNS multicast group on interface eth0.IPv6 with address fc00::14.
<3.6> 2014-08-11 15:17:42 Telcontar avahi-daemon 1007 - -  Registering new address record for fc00::14 on eth0.*.
<3.6> 2014-08-11 15:17:42 Telcontar avahi-daemon 1007 - -  Withdrawing address record for fe80::221:85ff:fe16:2d0b on eth0.
<3.6> 2014-08-11 15:17:44 Telcontar ntp 6314 - -  11 Aug 15:17:44 sntp[6505]: Received no useable packet from 192.168.1.15!
<3.6> 2014-08-11 15:17:44 Telcontar ntp 6314 - -  11 Aug 15:17:44 sntp[7926]: Started sntp
<3.6> 2014-08-11 15:17:44 Telcontar systemd 1 - -  Time has been changed
<3.6> 2014-08-11 15:17:44 Telcontar ntp 6314 - -  2014-08-11 15:17:44.656291 (-0100) -0.112718 +/- 0.037338 secs
<3.6> 2014-08-11 15:17:44 Telcontar ntp 6314 - -  2014-08-11 15:17:44.604369 (-0100) +0.0081 +/- 0.069473 secs
<3.6> 2014-08-11 15:17:44 Telcontar ntp 6314 - -  Time synchronized with  0.pool.ntp.org
<4.6> 2014-08-11 15:17:45 Telcontar SuSEfirewall2 - - -  Setting up rules from /etc/sysconfig/SuSEfirewall2 ...
<4.6> 2014-08-11 15:17:45 Telcontar SuSEfirewall2 - - -  using default zone 'ext' for interface eth1
<4.6> 2014-08-11 15:17:45 Telcontar SuSEfirewall2 - - -  Firewall customary rules loaded from /etc/sysconfig/scripts/SuSEfirewall2-custom
<3.5> 2014-08-11 15:17:45 Telcontar ntpd 7991 - -  ntpd 4.2.6p5@1.2349-o Tue Jul 22 08:26:41 UTC 2014 (1)
<3.6> 2014-08-11 15:17:45 Telcontar ntp 6314 - -  Starting network time protocol daemon (NTPD)..done
<3.6> 2014-08-11 15:17:44 Telcontar systemd 1 - -  Time has been changed
<3.6> 2014-08-11 15:17:45 Telcontar systemd 1 - -  Started LSB: Network time protocol daemon (ntpd).
<3.5> 2014-08-11 15:17:45 Telcontar ntpd 8017 - -  proto: precision = 1.613 usec
<3.7> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  ntp_io: estimated max descriptors: 1024, initial socket boundary: 16
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listen and drop on 0 v4wildcard 0.0.0.0 UDP 123
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listen and drop on 1 v6wildcard :: UDP 123
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listen normally on 2 lo 127.0.0.1 UDP 123
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listen normally on 3 eth0 192.168.1.14 UDP 123
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listen normally on 4 lo ::1 UDP 123
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listen normally on 5 eth0 fe80::221:85ff:fe16:2d0b UDP 123
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listen normally on 6 eth0 fc00::14 UDP 123
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  peers refreshed
<3.6> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  Listening on routing socket on fd #23 for interface updates
<3.5> 2014-08-11 15:17:46 Telcontar ntpd 8017 - -  logging to file /var/log/ntp
<4.6> 2014-08-11 15:17:48 Telcontar SuSEfirewall2 - - -  Firewall rules successfully set
<3.6> 2014-08-11 15:17:48 Telcontar avahi-autoipd(eth0) 8434 - -  Found user 'avahi-autoipd' (UID 495) and group 'avahi-autoipd' (GID 491).
<3.6> 2014-08-11 15:17:48 Telcontar avahi-autoipd(eth0) 8434 - -  Successfully called chroot().
<3.6> 2014-08-11 15:17:48 Telcontar avahi-autoipd(eth0) 8434 - -  Successfully dropped root privileges.
<3.6> 2014-08-11 15:17:48 Telcontar avahi-autoipd(eth0) 8434 - -  Starting with address 169.254.3.89
<3.6> 2014-08-11 15:17:48 Telcontar avahi-autoipd(eth0) 8434 - -  Routable address already assigned, sleeping.
<3.6> 2014-08-11 15:17:50 Telcontar systemd 1 - -  Started ifup managed network interface eth0.
<3.6> 2014-08-11 15:17:50 Telcontar systemd 1 - -  Started ifup managed network interface eth1.
<3.6> 2014-08-11 15:17:50 Telcontar network 6384 - -  ..done..done..done    ppp0      Startmode is 'manual' -> skipping
<1.5> 2014-08-11 15:17:50 Telcontar ifup 8500 - -      ppp0      Startmode is 'manual' -> skipping
<3.6> 2014-08-11 15:17:50 Telcontar network 6384 - -  ..skippedSetting up service network  .  .  .  .  .  .  .  .  .  .  .  .  ...done
<3.6> 2014-08-11 15:17:50 Telcontar systemd 1 - -  Started LSB: Configure network interfaces and set up routing.
<3.4> 2014-08-11 15:17:52 Telcontar pm-utils - - -  Thawing the system now (04)...
<0.6> 2014-08-11 15:17:55 Telcontar kernel - - - [73268.481672] Chrome_ChildThr[5680]: segfault at 0 ip 00007ffcedf71598 sp 00007ffce1821410 error 6 in libmozalloc.so[7ffcedf7
<0.4> 2014-08-11 15:18:00 Telcontar kernel - - - [73274.336014] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:18:01 Telcontar systemd 1 - -  Starting Session 559 of user news.
<3.4> 2014-08-11 15:18:16 Telcontar router - - -  (Thawing 04) Logging the current IP= 79.159.63.177
<0.4> 2014-08-11 15:18:31 Telcontar kernel - - - [73304.416012] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:19:01 Telcontar kernel - - - [73334.496014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:19:31 Telcontar kernel - - - [73364.576016] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:20:01 Telcontar kernel - - - [73394.656015] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:20:01 Telcontar systemd 1 - -  Starting Session 560 of user cer.
<0.4> 2014-08-11 15:20:31 Telcontar kernel - - - [73424.736049] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:21:01 Telcontar kernel - - - [73454.816016] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:21:31 Telcontar kernel - - - [73484.896015] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:22:01 Telcontar kernel - - - [73514.976016] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:22:31 Telcontar kernel - - - [73545.056018] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:23:01 Telcontar systemd 1 - -  Starting Session 561 of user news.
<0.4> 2014-08-11 15:23:01 Telcontar kernel - - - [73575.136025] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:23:31 Telcontar kernel - - - [73605.216014] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:23:52 Telcontar smartd 1013 - -  Device: /dev/sdb [SAT], Temperature changed -5 Celsius to 33 Celsius (Min/Max 19/38)
<0.4> 2014-08-11 15:24:01 Telcontar kernel - - - [73635.296078] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:24:32 Telcontar kernel - - - [73665.376020] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:25:01 Telcontar systemd 1 - -  Starting Session 562 of user news.
<0.4> 2014-08-11 15:25:02 Telcontar kernel - - - [73695.456011] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:25:32 Telcontar kernel - - - [73725.536015] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:26:02 Telcontar kernel - - - [73755.616017] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:26:32 Telcontar kernel - - - [73785.696017] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:27:02 Telcontar kernel - - - [73815.776016] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:27:32 Telcontar kernel - - - [73845.856021] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:28:01 Telcontar systemd 1 - -  Starting Session 563 of user news.
<0.4> 2014-08-11 15:28:02 Telcontar kernel - - - [73875.936014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:28:32 Telcontar kernel - - - [73906.016015] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:29:02 Telcontar kernel - - - [73936.096017] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:29:32 Telcontar kernel - - - [73966.176012] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:30:01 Telcontar systemd 1 - -  Starting Session 564 of user root.
<3.6> 2014-08-11 15:30:01 Telcontar systemd 1 - -  Starting Session 565 of user cer.
<1.6> 2014-08-11 15:30:01 Telcontar run-crons 8974 - -  suse.de-snapper: OK
<4.5> 2014-08-11 15:30:01 Telcontar su - - -  (to root) root on (null)
<10.3> 2014-08-11 15:30:01 Telcontar su - - -  pam_systemd(su-l:session): pam_putenv: delete non-existent entry; XDG_RUNTIME_DIR
<0.4> 2014-08-11 15:30:02 Telcontar kernel - - - [73996.256010] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:30:32 Telcontar kernel - - - [74026.336013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:31:03 Telcontar kernel - - - [74056.416012] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:31:33 Telcontar kernel - - - [74086.496011] XFS (sdd5): xfs_log_force: error 5 returned.
<4.5> 2014-08-11 15:31:59 Telcontar gnome-keyring-daemon 4381 - -  Gkm: couldn't stat directory: /home/cer/.gnome2/keyrings: Input/output error
<4.4> 2014-08-11 15:32:00 Telcontar gnome-keyring-daemon 4381 - -  GLib-GObject: invalid unclassed pointer in cast to 'GkmObject'
<4.3> 2014-08-11 15:32:00 Telcontar gnome-keyring-daemon 4381 - -  Gkm: gkm_object_expose_full: assertion 'GKM_IS_OBJECT (self)' failed
<4.5> 2014-08-11 15:32:00 Telcontar gnome-keyring-daemon 4381 - -  Gkm: couldn't stat directory: /home/cer/.gnome2/keyrings: Input/output error
<4.5> 2014-08-11 15:32:00 Telcontar gnome-keyring-daemon 4381 - -  Gkm: couldn't stat directory: /home/cer/.gnome2/keyrings: Input/output error
<4.4> 2014-08-11 15:32:00 Telcontar gnome-keyring-daemon 4381 - -  Gkm: couldn't create temporary file for: /home/cer/.gnome2/keyrings/login.keyring: Input/output error
<4.4> 2014-08-11 15:32:00 Telcontar gnome-keyring-daemon 4381 - -  couldn't create login keyring: An error occurred on the device
<10.3> 2014-08-11 15:32:00 Telcontar unix2_chkpwd - - -  gkr-pam: the password for the login keyring was invalid.
<0.4> 2014-08-11 15:32:03 Telcontar kernel - - - [74116.576018] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:32:33 Telcontar kernel - - - [74146.656011] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:33:01 Telcontar systemd 1 - -  Starting Session 566 of user news.
<0.4> 2014-08-11 15:33:03 Telcontar kernel - - - [74176.736068] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:33:33 Telcontar kernel - - - [74206.816012] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:34:03 Telcontar kernel - - - [74236.896017] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:34:33 Telcontar kernel - - - [74266.976014] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:35:01 Telcontar systemd 1 - -  Starting Session 567 of user news.
<0.4> 2014-08-11 15:35:03 Telcontar kernel - - - [74297.056012] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:35:33 Telcontar kernel - - - [74327.136015] XFS (sdd5): xfs_log_force: error 5 returned.
<1.6> 2014-08-11 15:35:56 Telcontar run-crons 8974 - -  leafnode: OK
<3.6> 2014-08-11 15:35:56 Telcontar systemd 1 - -  Reloading System Logging Service.
<3.6> 2014-08-11 15:35:57 Telcontar systemd 1 - -  Reloaded System Logging Service.
<5.6> 2014-08-11 15:35:57 Telcontar rsyslogd - - -  [origin software="rsyslogd" swVersion="7.4.7" x-pid="1081" x-info="http://www.rsyslog.com"] rsyslogd was HUPed
<3.6> 2014-08-11 15:36:02 Telcontar systemd 1 - -  Reloading System Logging Service.
<3.6> 2014-08-11 15:36:02 Telcontar systemd 1 - -  Reloaded System Logging Service.
<0.4> 2014-08-11 15:36:03 Telcontar kernel - - - [74357.216013] XFS (sdd5): xfs_log_force: error 5 returned.
<1.6> 2014-08-11 15:36:06 Telcontar run-crons 8974 - -  logrotate: OK
<3.2> 2014-08-11 15:36:06 Telcontar mdadm 9290 - -  DegradedArray event detected on md device /dev/md0
<1.6> 2014-08-11 15:36:06 Telcontar run-crons 8974 - -  mdadm: OK
<4.5> 2014-08-11 15:36:06 Telcontar su - - -  (to root) root on (null)
<1.4> 2014-08-11 15:36:25 Telcontar run-crons 8974 - -  mlocate.cron returned 143
<1.6> 2014-08-11 15:36:25 Telcontar run-crons 8974 - -  packagekit-background.cron: OK
<1.6> 2014-08-11 15:36:26 Telcontar run-crons 8974 - -  suse-clean_catman: OK
<0.4> 2014-08-11 15:36:33 Telcontar kernel - - - [74387.296018] XFS (sdd5): xfs_log_force: error 5 returned.
<1.6> 2014-08-11 15:36:41 Telcontar run-crons 8974 - -  suse-do_mandb: OK
<1.6> 2014-08-11 15:36:57 Telcontar run-crons 8974 - -  suse-texlive: OK
<1.6> 2014-08-11 15:36:57 Telcontar run-crons 8974 - -  suse.cron-sa-update: OK
<1.6> 2014-08-11 15:36:58 Telcontar run-crons 8974 - -  suse.de-backup-rc.config: OK
<0.4> 2014-08-11 15:37:04 Telcontar kernel - - - [74417.376010] XFS (sdd5): xfs_log_force: error 5 returned.
<1.6> 2014-08-11 15:37:34 Telcontar run-crons 8974 - -  suse.de-backup-rpmdb: OK
<0.4> 2014-08-11 15:37:34 Telcontar kernel - - - [74447.456013] XFS (sdd5): xfs_log_force: error 5 returned.
<1.6> 2014-08-11 15:37:34 Telcontar run-crons 8974 - -  suse.de-check-battery: OK
<1.6> 2014-08-11 15:37:34 Telcontar run-crons 8974 - -  suse.de-cron-local: OK
<1.6> 2014-08-11 15:37:34 Telcontar run-crons 8974 - -  suse.de-faxcron: OK
<1.6> 2014-08-11 15:37:34 Telcontar run-crons 8974 - -  suse.de-snapper: OK
<3.6> 2014-08-11 15:38:01 Telcontar systemd 1 - -  Starting Session 568 of user news.
<0.4> 2014-08-11 15:38:04 Telcontar kernel - - - [74477.536013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:38:34 Telcontar kernel - - - [74507.616019] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:39:04 Telcontar kernel - - - [74537.696013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:39:34 Telcontar kernel - - - [74567.776014] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:40:01 Telcontar systemd 1 - -  Starting Session 569 of user cer.
<0.4> 2014-08-11 15:40:04 Telcontar kernel - - - [74597.856013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:40:34 Telcontar kernel - - - [74627.936021] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:41:04 Telcontar kernel - - - [74658.016012] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:41:34 Telcontar kernel - - - [74688.096019] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:42:04 Telcontar kernel - - - [74718.176018] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:42:34 Telcontar kernel - - - [74748.256017] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:43:01 Telcontar systemd 1 - -  Starting Session 570 of user news.
<0.4> 2014-08-11 15:43:04 Telcontar kernel - - - [74778.336012] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:43:35 Telcontar kernel - - - [74808.416013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:44:05 Telcontar kernel - - - [74838.496014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:44:35 Telcontar kernel - - - [74868.576013] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:45:01 Telcontar systemd 1 - -  Starting Session 571 of user root.
<3.6> 2014-08-11 15:45:01 Telcontar systemd 1 - -  Starting Session 572 of user news.
<0.4> 2014-08-11 15:45:05 Telcontar kernel - - - [74898.656019] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:45:35 Telcontar kernel - - - [74928.736017] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:46:05 Telcontar kernel - - - [74958.816015] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:46:35 Telcontar kernel - - - [74988.896026] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:47:05 Telcontar kernel - - - [75018.976014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:47:35 Telcontar kernel - - - [75049.056013] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:48:01 Telcontar systemd 1 - -  Starting Session 573 of user news.
<0.4> 2014-08-11 15:48:05 Telcontar kernel - - - [75079.136016] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:48:35 Telcontar kernel - - - [75109.216014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:49:05 Telcontar kernel - - - [75139.296014] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:49:36 Telcontar kernel - - - [75169.376013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:50:06 Telcontar kernel - - - [75199.456012] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:50:36 Telcontar kernel - - - [75229.536011] XFS (sdd5): xfs_log_force: error 5 returned.
<0.4> 2014-08-11 15:51:06 Telcontar kernel - - - [75259.616013] XFS (sdd5): xfs_log_force: error 5 returned.
<0.6> 2014-08-11 15:51:09 Telcontar kernel - - - [75262.721354] xfce4-session[4520]: segfault at 8 ip 00000000004164dc sp 00007fffdc291dc0 error 4 in xfce4-session[400000+2b00
<4.6> 2014-08-11 15:51:18 Telcontar systemd-logind 1021 - -  Removed session 8.
<10.5> 2014-08-11 15:51:18 Telcontar polkitd 4314 - -  Unregistered Authentication Agent for unix-session:10 (system bus name :1.69, object path /org/gnome/PolicyKit1/Authenti
<0.7> 2014-08-11 15:51:28 Telcontar kernel - - - [75282.132776] nvidia 0000:01:00.0: irq 48 for MSI/MSI-X
<3.6> 2014-08-11 15:51:29 Telcontar acpid - - -  1 client rule loaded
<4.6> 2014-08-11 15:51:30 Telcontar systemd-logind 1021 - -  Removed session 10.
<0.6> 2014-08-11 15:51:30 Telcontar kernel - - - [75284.176020] usb 1-6: new high-speed USB device number 4 using ehci-pci
<3.6> 2014-08-11 15:51:30 Telcontar systemd 1 - -  Starting Session 574 of user lightdm.
<4.6> 2014-08-11 15:51:30 Telcontar systemd-logind 1021 - -  New session 574 of user lightdm.
<4.6> 2014-08-11 15:51:30 Telcontar systemd-logind 1021 - -  Linked /tmp/.X11-unix/X0 to /run/user/127/X11-display.
<0.6> 2014-08-11 15:51:30 Telcontar kernel - - - [75284.291822] usb 1-6: New USB device found, idVendor=8564, idProduct=1000
<0.6> 2014-08-11 15:51:30 Telcontar kernel - - - [75284.291825] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<0.6> 2014-08-11 15:51:30 Telcontar kernel - - - [75284.291828] usb 1-6: Product: Mass Storage Device
<0.6> 2014-08-11 15:51:30 Telcontar kernel - - - [75284.291829] usb 1-6: Manufacturer: JetFlash
<0.6> 2014-08-11 15:51:30 Telcontar kernel - - - [75284.291831] usb 1-6: SerialNumber: 346YLQ4L0G5H8S2F
<1.6> 2014-08-11 15:51:31 Telcontar mtp-probe - - -  checking bus 1, device 4: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-6"
<1.6> 2014-08-11 15:51:31 Telcontar mtp-probe - - -  bus: 1, device: 4 was not an MTP device
<0.6> 2014-08-11 15:51:31 Telcontar kernel - - - [75284.667399] usb-storage 1-6:1.0: USB Mass Storage device detected
<0.6> 2014-08-11 15:51:31 Telcontar kernel - - - [75284.667502] scsi12 : usb-storage 1-6:1.0
<0.6> 2014-08-11 15:51:31 Telcontar kernel - - - [75284.667606] usbcore: registered new interface driver usb-storage
<0.5> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.794904] scsi 12:0:0:0: Direct-Access     JetFlash Transcend 4GB    1100 PQ: 0 ANSI: 4
<0.6> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.794976] scsi 12:0:0:0: alua: supports implicit and explicit TPGS
<0.6> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.796262] scsi 12:0:0:0: alua: No target port descriptors found
<0.3> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.796265] scsi 12:0:0:0: alua: not attached
<0.5> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.796396] sd 12:0:0:0: Attached scsi generic sg6 type 0
<0.5> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.796888] sd 12:0:0:0: [sdf] 7913472 512-byte logical blocks: (4.05 GB/3.77 GiB)
<0.5> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.797634] sd 12:0:0:0: [sdf] Write Protect is off
<0.7> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.797637] sd 12:0:0:0: [sdf] Mode Sense: 43 00 00 00
<0.3> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.798386] sd 12:0:0:0: [sdf] No Caching mode page found
<0.3> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.798388] sd 12:0:0:0: [sdf] Assuming drive cache: write through
<0.3> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.801508] sd 12:0:0:0: [sdf] No Caching mode page found
<0.3> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.801511] sd 12:0:0:0: [sdf] Assuming drive cache: write through
<0.6> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.802147]  sdf: sdf1 sdf2 sdf3
<0.3> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.805642] sd 12:0:0:0: [sdf] No Caching mode page found
<0.3> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.805645] sd 12:0:0:0: [sdf] Assuming drive cache: write through
<0.5> 2014-08-11 15:51:32 Telcontar kernel - - - [75285.805648] sd 12:0:0:0: [sdf] Attached SCSI removable disk
<0.4> 2014-08-11 15:51:36 Telcontar kernel - - - [75289.696019] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:51:41 Telcontar systemd 1 - -  Starting Getty on tty2...
<3.6> 2014-08-11 15:51:41 Telcontar systemd 1 - -  Started Getty on tty2.
<3.6> 2014-08-11 15:51:42 Telcontar systemd 1 - -  Starting Getty on tty3...
<3.6> 2014-08-11 15:51:42 Telcontar systemd 1 - -  Started Getty on tty3.
<3.6> 2014-08-11 15:51:43 Telcontar systemd 1 - -  Starting Getty on tty6...
<3.6> 2014-08-11 15:51:43 Telcontar systemd 1 - -  Started Getty on tty6.
<3.6> 2014-08-11 15:51:44 Telcontar systemd 1 - -  Starting Getty on tty5...
<3.6> 2014-08-11 15:51:44 Telcontar systemd 1 - -  Started Getty on tty5.
<3.6> 2014-08-11 15:51:45 Telcontar systemd 1 - -  Starting Getty on tty4...
<3.6> 2014-08-11 15:51:45 Telcontar systemd 1 - -  Started Getty on tty4.
<0.4> 2014-08-11 15:52:06 Telcontar kernel - - - [75319.776023] XFS (sdd5): xfs_log_force: error 5 returned.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Unmounting /data/raid...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Unmounting /data/cripta...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping /sys/devices/virtual/block/dm-0.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  message repeated 5 times: [ Stopping /sys/devices/virtual/block/dm-0.]
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping Session 574 of user lightdm.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopped Session 574 of user lightdm.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping Session 7 of user root.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopped Session 7 of user root.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping user-0.slice.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Removed slice user-0.slice.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping Stop Read-Ahead Data Collection 10s After Completed Startup.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopped Stop Read-Ahead Data Collection 10s After Completed Startup.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping User Manager for 1000...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping User Manager for 9...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping User Manager for 127...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping CUPS Printing Service...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping ifup managed network interface eth1...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping ifup managed network interface eth0...
<3.6> 2014-08-11 15:17:44 Telcontar systemd 4377 - -  message repeated 14 times: [ Time has been changed]
<3.3> 2014-08-11 15:52:08 Telcontar systemd 4377 - -  Failed to enqueue exit.target job: Unit exit.target failed to load: Input/output error.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping Graphical Interface.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopped target Graphical Interface.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping LSB: X Display Manager...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping helloworld.service...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopped helloworld.service.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping Multi-User System.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopped target Multi-User System.
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping LSB: virus scanner daemon...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping LSB: Start the hddtemp daemon...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping LSB: mdadmd daemon monitoring MD devices...
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping LSB: This services starts and stops the USB Arbitrator....
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping LSB: Supports the direct execution of binary formats....
<3.6> 2014-08-11 15:52:08 Telcontar systemd 1 - -  Stopping LSB: irqbalance daemon providing irq balancing on MP-machines...
<3.6> 2014-08-11 15:52:09 Telcontar systemd 1 - -  Stopping LSB: Set up analog joysticks...
<0.4> 2014-08-11 15:52:10 Telcontar kernel - - - [75323.547122] nfsd: last server has exited, flushing export cache
<5.6> 2014-08-11 15:36:02 Telcontar rsyslogd - - -  [origin software="rsyslogd" swVersion="7.4.7" x-pid="1081" x-info="http://www.rsyslog.com"] rsyslogd was HUPed
<5.6> 2014-08-11 15:52:11 Telcontar rsyslogd - - -  [origin software="rsyslogd" swVersion="7.4.7" x-pid="1081" x-info="http://www.rsyslog.com"] exiting on signal 15.
2014-08-11 15:52:12+02:00 - Halting the system now  =========================================== uptime:  15:52pm  up 1 day 20:54,  1 user,  load average: 5.94, 2.47, 1.22



> I am interested in the metadata dump.

Ok, sure, no problem. I'm working on that, but I need to have lunch first ;-)


> Also, some one hit back to back duplicate block allocation 
> XFS_WANT_CORRUPTED_GOTO bugs, you may want to do a metadata dump before and 
> after the xfs_repair in case you hit it again soon.

I already have a metadata dump, and I have not attempted to repair yet 
(I'm doing a full dd copy of partition, and it is 400 Gigs). I will obtain 
another metadadump after repair, and I can upload both to google drive.

But first I need sustenance :-)

(At least this time I do not have any pressing thing to do on the 
computer...)

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF0EAREIAAYFAlPo4p4ACgkQja8UbcUWM1wGAADxAVuTUPkxG+LO29VzehJ8cSPV
uItG/Puu2KbqUeCyXwD/cgu/+F7vhEeU9WEbNP5eifhmyu0T3ByDMtuKp55Rj7A=
=CgSx
-----END PGP SIGNATURE-----
---1463779071-1326823490-1407771294=:7326
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-1326823490-1407771294=:7326--
