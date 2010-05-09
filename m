Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49HTZ35231388 for <xfs@oss.sgi.com>; Sun, 9 May 2010 12:29:36 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC1F41287E71
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 10:32:01 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 799963EXAcfKOdgB
	for <xfs@oss.sgi.com>; Sun, 09 May 2010 10:32:01 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 31E976C32E
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 12:31:46 -0500 (CDT)
Message-ID: <4BE6F22F.5090603@hardwarefreak.com>
Date: Sun, 09 May 2010 12:34:39 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: failed to read root inode
References: <4BE55A63.8070203@purplehaze.ch>	<4BE5EB5D.5020702@hardwarefreak.com>
	<4BE6D63F.3070404@purplehaze.ch>
In-Reply-To: <4BE6D63F.3070404@purplehaze.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Christian Affolter put forth on 5/9/2010 10:35 AM:

> That's a good question ;) Honestly I don't know how this could happen,
> all I saw were a bunch of errors from the RAID controller driver. In the
> past two other disks failed and the controller reported each failure
> correctly and started to rebuild the array automatically by using the
> hot-spare disk. So it did its job two times correctly.
> [...]
> 
> kernel: arcmsr0: abort device command of scsi id = 1 lun = 0
> kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
> kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
> kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
> kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
> kernel: arcmsr0: abort device command of scsi id = 2 lun = 0
> kernel: arcmsr0: ccb ='0xffff8100bf819080'

Ok, that's not good.  Looks like the Areca driver is showing communication
failure with 3 physical drives simultaneously.  Can't be a drive problem.

I just read through about 20 Google hits, and it seems this Areca issue is
pretty common.  One OP said he had a defective card.  The rest all report
the same or similar errors, across many Areca models, using many different
drives, under moderate to high I/O load, under multiple *nix OSes, usually
lots of small file copies is the trigger.  I've read plenty of less than
flattering things about Areca RAID cards in the past.  This is just more of
the same.

>From everything I've read on this, the problem is either:

A.  A defective Areca card
B.  Firmware issue (card and/or drives)
C.  Driver issue
D.  More than one of the above

> Areca Technology Corp. ARC-1160 16-Port PCI-X to SATA RAID Controller
> Firmware Version   : V1.42 2006-10-13

That's a 16 port card.  How many total drives do you have connected?

Are they all the same model/firmware rev?  If different models, do you at
least have identical models in each RAID pack? Mixing different
brands/models/firmware revs within a RAID pack is always a very bad idea.
In fact, using anything but identical drives/firmware on a single controller
card is a bad idea.  Some cards are more finicky than others, but almost all
of them will have problems of one kind or another with a mixed bag 'o
drives.  They can have problems with all identical drives if the drive
firmware isn't to the card firmware's liking (see below).

> After the hard reset, one disk was reported as 'faild' and the rebuild
> started.

Unfortunately the errors reported weren't indicative of a bad drive, but
multiple bad drives.  None of the drives are bad.  The
controller/firmware/driver have a problem, or have a problem with the
drive(s) firmware.  The Areca firmware marked one drive as bad because the
logic says something besides the card/firmware/driver _must_ be bad.  So, it
marked one of the drives as bad and started rebuilding it.

Back in the late '90s I had Mylex DAC960 cards doing exactly the same thing
due to a problem with firmware on the Seagate ST118202 Cheetah drives.  The
DAC960 would just kick a drive offline willy nilly.  This was with 8
identical firmware drives in RAID5 arrays on a single SCSI channel.  Was
really annoying.  I was at customer sites twice weekly replacing and
rebuilding drives until Seagate finally admitted the firmware bug and
advance shipped us 50 new 3 series Cheetah drives.  That was really fun
replacing drives one by one and rebuilding the arrays after each drive swap.
 We lost a lot of labor $$ over that and had some less than happy customers.
 Once all the drives were replaced with the 3 series, we never had another
problem with any of those arrays.  I'm still surprised I was able to rebuild
the arrays without issues after adding each new drive, which was a slightly
different size with a different firmware.  I was just sure the rebuilds
would puke.  I got lucky.  These systems were in production, thus the reason
we didn't restore from tape, which would have saved a lot of time.

>> What is the status of the RAID6 volume as reported by the RAID card BIOS?
> 
> By now, the rebuild finished, therefor the volume is in normal
> non-degraded state.

That's good.

>> What is the status of each of your EVMS volumes as reported by the EVMS UI?
> 
> They're all active. Do you need more informations here? There are
> approximately 45 active volumes on this server.

No.  Just wanted to know if they're all reported as healthy.

>> I'm asking all of these questions because it seems rather clear that the
>> root cause of your problem lies at a layer well below the XFS filesystem.
> 
> Yes, I never blamed XFS for being the cause of the problem.

I should have worded that differently.  I didn't mean to imply that you were
blaming XFS.  I meant that I wanted to help you figure out the root cause
which wasn't XFS.

>> You have two layers of physical disk abstraction below XFS:  a hardware
>> RAID6 and a software logical volume manager.  You've apparently suffered a
>> storage system hardware failure, according to your description.  You haven't
>> given any details of the current status of the hardware RAID, or of the
>> logical volumes, merely that XFS is having problems.  I think a "Well duh!"
>> is in order.
>>
>> Please provide _detailed_ information from the RAID card BIOS and the EVMS
>> UI.  Even if the problem isn't XFS related I for one would be glad to assist
>> you in getting this fixed.  Right now we don't have enough information.  At
>> least I don't.

On second read, this looks rather preachy and antagonistic.  I truly did not
intend that tone.  Please accept my apology if this came across that way.  I
think I was starting to get frustrated because I wanted to troubleshoot this
further but didn't feel I had enough info.  Again, this was less than
professional, and I apologize.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
