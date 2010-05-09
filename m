Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49FXRsl229004 for <xfs@oss.sgi.com>; Sun, 9 May 2010 10:33:27 -0500
Received: from smtp.stepping-stone.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC1EB1206662
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 08:35:38 -0700 (PDT)
Received: from smtp.stepping-stone.ch (smtp.stepping-stone.ch
	[194.176.109.228]) by cuda.sgi.com with ESMTP id
	DT0nneJ3aJUauj7V for <xfs@oss.sgi.com>;
	Sun, 09 May 2010 08:35:38 -0700 (PDT)
Received: from localhost (mail-scanner-01.int.stepping-stone.ch [10.17.98.47])
	by smtp.stepping-stone.ch (Postfix) with ESMTP id CA70D4003CF
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 17:35:37 +0200 (CEST)
Received: from smtp.stepping-stone.ch ([10.17.98.46])
	by localhost (mail-scanner-01.int.stepping-stone.ch [10.17.98.47])
	(amavisd-new, port 10024)
	with LMTP id UTGyaxnZuxlH for <xfs@oss.sgi.com>;
	Sun,  9 May 2010 17:35:34 +0200 (CEST)
Received: from [192.168.1.4] (84-73-140-121.dclient.hispeed.ch [84.73.140.121])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	by smtp.stepping-stone.ch (Postfix) with ESMTPSA id AA2C24003D5
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 17:35:34 +0200 (CEST)
Message-ID: <4BE6D63F.3070404@purplehaze.ch>
Date: Sun, 09 May 2010 17:35:27 +0200
From: Christian Affolter <christian.affolter@purplehaze.ch>
MIME-Version: 1.0
Subject: Re: failed to read root inode
References: <4BE55A63.8070203@purplehaze.ch>
	<4BE5EB5D.5020702@hardwarefreak.com>
In-Reply-To: <4BE5EB5D.5020702@hardwarefreak.com>
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

Hi

>> After a disk crash within a hardware RAID-6 controller and kernel
>> freeze, I'm unable to mount an XFS filesystem on top of an EVMS volume:
> 
> What storage management operation(s) were you performing when this crash
> occurred?  Were you adding, deleting, shrinking, or growing an EVMS volume
> when the "crash" occurred, or was the system just sitting idle with no load
> when the crash occurred?

No, there were no storage management operations in progress while the
system crashed. It's a NFS file server with random read and write
operations.


> Why did the "crash" of a single disk in a hardware RAID6 cause a kernel
> freeze?  What is your definition of "disk crash"?  A single physical disk
> failure should not have caused this under any circumstances.  The RAID card
> should have handled a single disk failure transparently.

That's a good question ;) Honestly I don't know how this could happen,
all I saw were a bunch of errors from the RAID controller driver. In the
past two other disks failed and the controller reported each failure
correctly and started to rebuild the array automatically by using the
hot-spare disk. So it did its job two times correctly.
[...]

kernel: arcmsr0: abort device command of scsi id = 1 lun = 0
kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
kernel: arcmsr0: abort device command of scsi id = 2 lun = 0
kernel: arcmsr0: ccb ='0xffff8100bf819080'
isr got aborted command
kernel: arcmsr0: isr get an illegal ccb command
      done acb = '0xffff81013ec245c8'ccb = '0xffff8100bf819080' ccbacb =
'0xffff81013ec245c8' startdone = 0x0 ccboutstandingcount = 0
kernel: arcmsr0: abort device command of scsi id = 2 lun = 0
kernel: arcmsr0: abort device command of scsi id = 4 lun = 0
kernel: arcmsr0: ccb ='0xffff8100bf814640'
isr got aborted command
kernel: arcmsr0: isr get an illegal ccb command
      done acb = '0xffff81013ec245c8'ccb = '0xffff8100bf814640' ccbacb =
'0xffff81013ec245c8' startdone = 0x0 ccboutstandingcount = 13
kernel: sd 0:0:4:0: [sdd] Result: hostbyte=DID_ABORT
driverbyte=DRIVER_OK,SUGGEST_OK
kernel: end_request: I/O error, dev sdd, sector 1897479440
kernel: Device dm-79, XFS metadata write error block 0x1813c0 in dm-79
kernel: Device dm-65, XFS metadata write error block 0x2c1a0 in dm-65
kernel: xfs_force_shutdown(dm-65,0x1) called from line 1093 of file
fs/xfs/xfs_buf_item.c.  Return address = 0xffffffff80374359
kernel: Filesystem "dm-65": I/O Error Detected.  Shutting down
filesystem: dm-65
kernel: Please umount the filesystem, and rectify the problem(s)
kernel: xfs_force_shutdown(dm-65,0x1) called from line 420 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff803a9529

[...]

Afterwards most of the volumes where shutdown and after a couple of
hours the kernel freezes with a kernel panic (which I can't remember as
I had no serial console attached).



> Exactly which make/model is the RAID card? 

Areca Technology Corp. ARC-1160 16-Port PCI-X to SATA RAID Controller
Firmware Version   : V1.42 2006-10-13


> What is the status of each of the remaining disks attached to the card as reported by its BIOS?

After the hard reset, one disk was reported as 'faild' and the rebuild
started.


> What is the status of the RAID6 volume as reported by the RAID card BIOS?

By now, the rebuild finished, therefor the volume is in normal
non-degraded state.


> What is the status of each of your EVMS volumes as reported by the EVMS UI?

They're all active. Do you need more informations here? There are
approximately 45 active volumes on this server.


> I'm asking all of these questions because it seems rather clear that the
> root cause of your problem lies at a layer well below the XFS filesystem.

Yes, I never blamed XFS for being the cause of the problem.


> You have two layers of physical disk abstraction below XFS:  a hardware
> RAID6 and a software logical volume manager.  You've apparently suffered a
> storage system hardware failure, according to your description.  You haven't
> given any details of the current status of the hardware RAID, or of the
> logical volumes, merely that XFS is having problems.  I think a "Well duh!"
> is in order.
> 
> Please provide _detailed_ information from the RAID card BIOS and the EVMS
> UI.  Even if the problem isn't XFS related I for one would be glad to assist
> you in getting this fixed.  Right now we don't have enough information.  At
> least I don't.


Thanks for your help
Christian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
