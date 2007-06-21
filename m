Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 23:02:07 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P61xdo025506
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 23:02:02 -0700
Message-ID: <467ABE25.7060303@dgreaves.com>
Date: Thu, 21 Jun 2007 19:06:29 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <4677A596.7090404@gmail.com> <4677E496.3080506@dgreaves.com> <4678DF56.1020903@gmail.com>
In-Reply-To: <4678DF56.1020903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tejun Heo <htejun@gmail.com>
Cc: David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>

been away, back now...

Tejun Heo wrote:
> David Greaves wrote:
>> Tejun Heo wrote:
>>> How reproducible is the problem?  Does the problem go away or occur more
>>> often if you change the drive you write the memory image to?
>> I don't think there should be activity on the sda drive during resume
>> itself.
>>
>> [I broke my / md mirror and am using some of that for swap/resume for now]
>>
>> I did change the swap/resume device to sdd2 (different controller,
>> onboard sata_via) and there was no EH during resume. The system seemed
>> OK, wrote a few Gb of video and did a kernel compile.
>> I repeated this test, no EH during resume, no problems.
>> I even ran xfs_fsr, the defragment utility, to stress the fs.
>>
>> I retain this configuration and try again tonight but it looks like
>> there _may_ be a link between EH during resume and my problems...
Having retained this new configuration for a couple of days now I haven't had 
any problems.
This is good but not really ideal since / isn't mirrored anymore :(

>> Of course, I don't understand why it *should* EH during resume, it
>> doesn't during boot or normal operation...
> 
> EH occurs during boot, suspend and resume all the time.  It just runs in
> quiet mode to avoid disturbing the users too much.  In your case, EH is
> kicking in due to actual exception conditions so it's being verbose to
> give clue about what's going on.
I was trying to say that I don't actually see any errors being handled in normal 
operation.
I'm not sure if you are saying that these PHY RDY events are normally handled 
quietly (which would explain it).


> It's really weird tho.  The PHY RDY status changed events are coming
> from the device which is NOT used while resuming
yes - but the erroring device which is not being used is on the same controller 
as the device with the in-use resume partition.

> and it's before any
> actual PM events are triggered.  Your kernel just boots, swsusp realizes
> it's resuming and tries to read memory image from the swap device.
yes

> While reading, the disk controller raises consecutive PHY readiness
> changed interrupts.  EH recovers them alright but the end result seems
> to indicate that the loaded image is corrupt.
Yes, that's consistent with what I'm seeing.

When I move the swap/resume partition to a different controller (ie when I broke 
the / mirror and used the freed space) the problem seems to go away.

I am seeing messages in dmesg though:
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ata1.00: configured for UDMA/100
ata2.00: revalidation failed (errno=-2)
ata2: failed to recover some devices, retrying in 5 secs
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)

sd 0:0:0:0: resuming
sd 0:0:0:0: [sda] Starting disk
ATA: abnormal status 0x7F on port 0x00019807
ATA: abnormal status 0x7F on port 0x00019007
ATA: abnormal status 0x7F on port 0x00019007
ATA: abnormal status 0x7F on port 0x00019807

ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ATA: abnormal status 0xD0 on port 0xf881e0c7
ata1.00: configured for UDMA/100
ata2.00: revalidation failed (errno=-2)
ata2: failed to recover some devices, retrying in 5 secs


> So, there's no device suspend/resume code involved at all.  The kernel
> just booted and is trying to read data from the drive.  Please try with
> only the first drive attached and see what happens.
That's kinda hard; swap and root are on different drives...

Does it help that although the errors above appear, the system seems OK when I 
just use the other controller?

I have to be cautious what I do with this machine as it's the wife's active 
desktop box <grin>.

David
