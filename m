Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 11:37:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65IbgEH023424
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 11:37:42 -0700
Received: from pd2mo3so.prod.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 677DADACA10
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 11:38:43 -0700 (PDT)
Received: from pd2mo3so.prod.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by cuda.sgi.com with ESMTP id qSQy0ZrLE25xCIcy for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 11:38:43 -0700 (PDT)
Received: from pd3mr2so.prod.shaw.ca
 (pd3mr2so-qfe3.prod.shaw.ca [10.0.141.178]) by l-daemon
 (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0K3J00JW8QGJGW10@l-daemon> for xfs@oss.sgi.com; Sat,
 05 Jul 2008 12:38:43 -0600 (MDT)
Received: from pn2ml7so.prod.shaw.ca ([10.0.121.151])
 by pd3mr2so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0K3J00BIFQGHVL60@pd3mr2so.prod.shaw.ca> for
 xfs@oss.sgi.com; Sat, 05 Jul 2008 12:38:43 -0600 (MDT)
Received: from [192.168.1.113] ([70.64.130.4])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0K3J00BM5QGG4630@l-daemon> for xfs@oss.sgi.com; Sat,
 05 Jul 2008 12:38:41 -0600 (MDT)
Date: Sat, 05 Jul 2008 12:38:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-reply-to: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no>
Message-id: <486FBFAB.5050303@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
> I've read the best way to 'deal' with this issue is to turn off 
> apic/acpi etc, is there any downside to turning them off?  Particularly 
> APIC for IRQ routing?

It's not the best way to deal with it, more just a workaround, and if it 
does help it should be reported because it indicates something else is 
wrong. The main downsides to disabling APIC is that all interrupts will 
be handled by one core and you'll end up with much more IRQ sharing. 
Disabling ACPI on modern systems tends to be a bad idea, you'll get no 
multi-core support, for one.

> 
> This happens on drives on both the Intel 965 chipset motherboard ports 
> and PCI-e x1 cards, and the cables are not the issue (the cables with 12 
> other 150 raptors have no issues) (same cables I used with them)).
> 
> With NCQ on or OFF it occurs.
> 
> $ ls
> 0/  10/  12/  14/  16/  18/  2/   3/  5/  7/  9/   runtest.sh*
> 1/  11/  13/  15/  17/  19/  20/  4/  6/  8/  linux-2.6.25.10.tar
> 
> $ cat runtest.sh
> #!/bin/bash
> 
> for i in `seq 0 20`
> do
>   cd $i
>   tar xf ../linux-2.6.25.10.tar &
>   cd ..
> done
> 
> With NCQ off (earlier) (from just heavy I/O on the raid5):
> Jul  5 11:50:06 p34 kernel: [112161.433913] ata6.00: exception Emask 0x0 
> SAct
> 0x0 SErr 0x0 action 0x2 frozen
> Jul  5 11:50:06 p34 kernel: [112161.433923] ata6.00: cmd
> b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> Jul  5 11:50:06 p34 kernel: [112161.433924]          res
> 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jul  5 11:50:06 p34 kernel: [112161.433927] ata6.00: status: { DRDY }
> Jul  5 11:50:06 p34 kernel: [112161.736858] ata6: soft resetting link
> Jul  5 11:50:07 p34 kernel: [112161.889840] ata6: SATA link up 3.0 Gbps 
> (SStatus
> 123 SControl 300)
> Jul  5 11:50:07 p34 kernel: [112161.911418] ata6.00: configured for 
> UDMA/133
> Jul  5 11:50:07 p34 kernel: [112161.656792] sd 5:0:0:0: [sdf] Write 
> Protect is
> off
> Jul  5 11:50:07 p34 kernel: [112161.656797] sd 5:0:0:0: [sdf] Mode 
> Sense: 00 3a
> 00 00
> Jul  5 11:50:07 p34 kernel: [112161.659296] sd 5:0:0:0: [sdf] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> 
> With NCQ on (with the test shown above):
> [115786.990237] ata6.00: exception Emask 0x0 SAct 0x3ffff SErr 0x0 
> action 0x2 frozen
> [115786.990247] ata6.00: cmd 60/80:00:bf:07:94/00:00:10:00:00/40 tag 0 
> ncq 65536 in
> [115786.990249]          res 40/00:00:00:00:00/00:00:00:00:00/a0 Emask 
> 0x4 (timeout)
> [115786.990254] ata6.00: status: { DRDY }
> [115786.990259] ata6.00: cmd 60/88:08:b7:ee:c1/01:00:1d:00:00/40 tag 1 
> ncq 200704 in
> [115786.990261]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990265] ata6.00: status: { DRDY }
> [115786.990270] ata6.00: cmd 60/f8:10:bf:eb:c1/02:00:1d:00:00/40 tag 2 
> ncq 389120 in
> [115786.990271]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990275] ata6.00: status: { DRDY }
> [115786.990280] ata6.00: cmd 60/c0:18:3f:e8:c1/01:00:1d:00:00/40 tag 3 
> ncq 229376 in
> [115786.990282]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990286] ata6.00: status: { DRDY }
> [115786.990291] ata6.00: cmd 60/c0:20:ff:e9:c1/01:00:1d:00:00/40 tag 4 
> ncq 229376 in
> [115786.990293]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990297] ata6.00: status: { DRDY }
> [115786.990302] ata6.00: cmd 61/08:28:0f:c6:b6/00:00:1f:00:00/40 tag 5 
> ncq 4096 out
> [115786.990303]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990307] ata6.00: status: { DRDY }
> [115786.990312] ata6.00: cmd 61/10:30:df:b0:17/00:00:01:00:00/40 tag 6 
> ncq 8192 out
> [115786.990313]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990318] ata6.00: status: { DRDY }
> [115786.990323] ata6.00: cmd 61/10:38:4f:88:79/00:00:03:00:00/40 tag 7 
> ncq 8192 out
> [115786.990324]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990328] ata6.00: status: { DRDY }
> [115786.990333] ata6.00: cmd 61/10:40:3f:18:95/00:00:05:00:00/40 tag 8 
> ncq 8192 out
> [115786.990335]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990339] ata6.00: status: { DRDY }
> [115786.990344] ata6.00: cmd 61/08:48:d7:f6:a9/00:00:06:00:00/40 tag 9 
> ncq 4096 out
> [115786.990345]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990350] ata6.00: status: { DRDY }
> [115786.990355] ata6.00: cmd 61/08:50:9f:37:b7/00:00:07:00:00/40 tag 10 
> ncq 4096 out
> [115786.990356]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990360] ata6.00: status: { DRDY }
> [115786.990365] ata6.00: cmd 61/08:58:27:7c:d1/00:00:08:00:00/40 tag 11 
> ncq 4096 out
> [115786.990367]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990371] ata6.00: status: { DRDY }
> [115786.990376] ata6.00: cmd 61/08:60:97:48:46/00:00:0d:00:00/40 tag 12 
> ncq 4096 out
> [115786.990377]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990381] ata6.00: status: { DRDY }
> [115786.990386] ata6.00: cmd 61/08:68:cf:b4:68/00:00:0e:00:00/40 tag 13 
> ncq 4096 out
> [115786.990388]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990392] ata6.00: status: { DRDY }
> [115786.990397] ata6.00: cmd 61/80:70:3f:06:94/01:00:10:00:00/40 tag 14 
> ncq 196608 out
> [115786.990398]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990402] ata6.00: status: { DRDY }
> [115786.990408] ata6.00: cmd 61/08:78:7f:a4:88/00:00:11:00:00/40 tag 15 
> ncq 4096 out
> [115786.990409]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990413] ata6.00: status: { DRDY }
> [115786.990418] ata6.00: cmd 61/08:80:37:b8:d5/00:00:13:00:00/40 tag 16 
> ncq 4096 out
> [115786.990419]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990423] ata6.00: status: { DRDY }
> [115786.990428] ata6.00: cmd 61/08:88:c7:a4:8b/00:00:1d:00:00/40 tag 17 
> ncq 4096 out
> [115786.990430]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 
> 0x4 (timeout)
> [115786.990454] ata6.00: status: { DRDY }
> [115787.293177] ata6: soft resetting link
> [115787.446158] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [115788.133592] ata6.00: configured for UDMA/133
> [115788.133628] ata6: EH complete
> [115787.877547] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors 
> (300069 MB)
> [115787.877689] sd 5:0:0:0: [sdf] Write Protect is off
> [115787.877692] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> [115787.878746] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA
> 
> What is the true cause of this, is there anyway to get more information?
> 
> I will test soon with apic/acpi=off.

Can you post your dmesg from bootup with the controller/drive detection?
