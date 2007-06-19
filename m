Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 07:13:58 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5JEDpdo028017
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 07:13:53 -0700
Message-ID: <4677E496.3080506@dgreaves.com>
Date: Tue, 19 Jun 2007 15:13:42 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <4677A596.7090404@gmail.com>
In-Reply-To: <4677A596.7090404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tejun Heo <htejun@gmail.com>
Cc: David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>

Tejun Heo wrote:
> Hello,
again...

> David Greaves wrote:
>>> Good :)
>> Now, not so good :)
> 
> Oh, crap.  :-)
<grin>

>> So I hibernated last night and resumed this morning.
>> Before hibernating I froze and sync'ed. After resume I thawed it. (Sorry
>> Dave)
>>
>> Here are some photos of the screen during resume. This is not 100%
>> reproducable - it seems to occur only if the system is shutdown for
>> 30mins or so.
>>
>> Tejun, I wonder if error handling during resume is problematic? I got
>> the same errors in 2.6.21. I have never seen these (or any other libata)
>> errors other than during resume.
>>
>> http://www.dgreaves.com/pub/2.6.22-rc5-resume-failure.jpg
>> (hard to read, here's one from 2.6.21
>> http://www.dgreaves.com/pub/2.6.21-resume-failure.jpg
> 
> Your controller is repeatedly reporting PHY readiness changed exception.
>  Are you reading the system image from the device attached to the first
> SATA port?

Yes if you mean 1st as in the one after the zero-th ...

resume=/dev/sdb4
haze:~# swapon -s
Filename                                Type            Size    Used    Priority
/dev/sdb4                               partition       1004020 0       -1

dmesg snippet below...

sda is part of the /scratch xfs array though. SMART doesn't show any problems 
and of course all is well other than during a resume.

sda/b are on sata_sil (a cheap plugin pci card)

> 
>> I _think_ I've only seen the xfs problem when a resume shows these errors.
> 
> The error handling itself tries very hard to ensure that there is no
> data corruption in case of errors.  All commands which experience
> exceptions are retried but if the drive itself is doing something
> stupid, there's only so much the driver can do.
> 
> How reproducible is the problem?  Does the problem go away or occur more
> often if you change the drive you write the memory image to?

I don't think there should be activity on the sda drive during resume itself.

[I broke my / md mirror and am using some of that for swap/resume for now]

I did change the swap/resume device to sdd2 (different controller, onboard 
sata_via) and there was no EH during resume. The system seemed OK, wrote a few 
Gb of video and did a kernel compile.
I repeated this test, no EH during resume, no problems.
I even ran xfs_fsr, the defragment utility, to stress the fs.

I retain this configuration and try again tonight but it looks like there _may_ 
be a link between EH during resume and my problems...

Of course, I don't understand why it *should* EH during resume, it doesn't 
during boot or normal operation...

Any more tests you'd like me to try?

David


dmesg snippet...

sata_sil 0000:00:0a.0: version 2.2
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 16 (level, low) -> IRQ 18
scsi0 : sata_sil
PM: Adding info for No Bus:host0
scsi1 : sata_sil
PM: Adding info for No Bus:host1
ata1: SATA max UDMA/100 cmd 0xf881e080 ctl 0xf881e08a bmdma 0xf881e000 irq 0
ata2: SATA max UDMA/100 cmd 0xf881e0c0 ctl 0xf881e0ca bmdma 0xf881e008 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7: Maxtor 6B200M0, BANC1980, max UDMA/100
ata1.00: 390721968 sectors, multi 0: LBA48
ata1.00: configured for UDMA/100
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
ata2.00: ATA-6: ST3160023AS, 3.18, max UDMA/133
ata2.00: 312581808 sectors, multi 0: LBA48
ata2.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
ata2.00: configured for UDMA/100
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6B200M0   BANC PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
PM: Adding info for No Bus:target1:0:0
scsi 1:0:0:0: Direct-Access     ATA      ST3160023AS      3.18 PQ: 0 ANSI: 5
PM: Adding info for scsi:1:0:0:0
sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
