Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 16:21:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65NLJ8O018830
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 16:21:19 -0700
Received: from pd2mo1so-dmz.prod.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CF1312DD0E5
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 16:22:22 -0700 (PDT)
Received: from pd2mo1so-dmz.prod.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by cuda.sgi.com with ESMTP id 3XqyaK7ST6Sj1tuT for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 16:22:22 -0700 (PDT)
Message-ID: <48700228.7060904@shaw.ca>
Date: Sat, 05 Jul 2008 17:22:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
MIME-Version: 1.0
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
>> Can you post your dmesg from bootup with the controller/drive detection?
> 
> Below:
> 
> [    0.889917] ahci 0000:00:1f.2: version 3.0
> [    0.889931] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, 
> low) -> IRQ 19
> [    1.890735] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 
> 0x3f impl SATA mode
> [    1.890845] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum 
> part [    1.890940] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [    1.891185] scsi0 : ahci
> [    1.891310] scsi1 : ahci
> [    1.891419] scsi2 : ahci
> [    1.891527] scsi3 : ahci
> [    1.891806] scsi4 : ahci
> [    1.892805] scsi5 : ahci
> [    1.893844] ata1: SATA max UDMA/133 abar m2048@0xe0625000 port 
> 0xe0625100 irq 378
> [    1.894714] ata2: SATA max UDMA/133 abar m2048@0xe0625000 port 
> 0xe0625180 irq 378
> [    1.895713] ata3: SATA max UDMA/133 abar m2048@0xe0625000 port 
> 0xe0625200 irq 378
> [    1.896713] ata4: SATA max UDMA/133 abar m2048@0xe0625000 port 
> 0xe0625280 irq 378
> [    1.897723] ata5: SATA max UDMA/133 abar m2048@0xe0625000 port 
> 0xe0625300 irq 378
> [    1.898713] ata6: SATA max UDMA/133 abar m2048@0xe0625000 port 
> 0xe0625380 irq 378
> [    2.356649] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.673654] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    2.674595] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.679961] ata1.00: configured for UDMA/133
> [    2.836575] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.155395] ata2.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    3.155521] ata2.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    3.161112] ata2.00: configured for UDMA/133
> [    3.322501] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.633983] ata3.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    3.634449] ata3.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    3.640394] ata3.00: configured for UDMA/133
> [    3.806428] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.112403] ata4.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    4.113376] ata4.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.119137] ata4.00: configured for UDMA/133
> [    4.397339] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.591563] ata5.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    4.592303] ata5.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.598246] ata5.00: configured for UDMA/133
> [    4.881265] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    5.069692] ata6.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max 
> UDMA/133
> [    5.070230] ata6.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    5.076402] ata6.00: configured for UDMA/133

So you've got 6 drives in the machine. Intel chipsets normally seem 
pretty robust with AHCI.

> [107360.796671] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 
> 0x2 frozen
> [107360.796680] ata4.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [107360.796681]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [107360.796685] ata4.00: status: { DRDY }
> [107361.099615] ata4: soft resetting link
> [107361.252599] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [107361.273562] ata4.00: configured for UDMA/133
> [107361.273604] ata4: EH complete
> [107361.018520] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors 
> (300069 MB)
> [107361.018683] sd 3:0:0:0: [sdd] Write Protect is off
> [107361.018687] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [107361.040887] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA

Are you certain that your machine has enough power to run all those 
drives properly? We've seen in a number of cases that power fluctuations 
or noise can cause these kinds of errors.
