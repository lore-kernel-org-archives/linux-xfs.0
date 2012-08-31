Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7V4PFxG091406 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 23:25:15 -0500
Received: from bosmailout12.eigbox.net (bosmailout12.eigbox.net
	[66.96.184.12]) by cuda.sgi.com with ESMTP id fw3vwvd59aaiE4Gf
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 21:26:08 -0700 (PDT)
Received: from bosmailscan02.eigbox.net ([10.20.15.2])
	by bosmailout12.eigbox.net with esmtp (Exim) id 1T7Io4-0003ZO-Ai
	for xfs@oss.sgi.com; Fri, 31 Aug 2012 00:26:08 -0400
Message-ID: <5c63bed077c12fe7f7ad64237c767101.squirrel@emailmg.netfirms.com>
In-Reply-To: <20120830225826.GG15292@dastard>
References: <0e85aee5ff82e567e872230ef416766a.squirrel@emailmg.netfirms.com>
	<20120830225826.GG15292@dastard>
Date: Fri, 31 Aug 2012 12:24:21 +0800
Subject: Re: XFS Mount Recovery Failed on Root File System After Power Outage
From: "Chin Gim Leong" <CHIN_Gim_Leong@performance-computing.net>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thanks Dave for the reply.

>> I just had a power outage and my Acer notebook computer running openSUSE
>> 11.4 x86_64 with kernel 2.6.37 stopped as a result.
>
> What mount options? What is the output of /proc/mounts? What are the
> messages in dmesg when you mount a partition?
>

The dmesg messages after the mount failure are exactly as in
/var/log/messages:

XFS: Invalid block length (0xfffffffc) given for buffer
XFS: log mount/recovery failed: error 117

The mount options I used, I do not remember the fstab options I put in for
root, but any way, whether with fstab or a manual mount, the mount fails.
The OS actually starts with a read-only mount of root file system, and the
rest of the system refuses to start of course.

I will put in an upddate to this thread after I repair the file system,
maybe tomorrow, about the mount options in fstab.

I can do a manual mount with ready only and no recovery option, and I can
traverse the directories.  In fact the /var/log/message is still there and
readable with entries up to 5 min before the power outage.

>
>> I would like to know the cause of this log recovery failure and if there
>
> You've got an old, unsupported kernel that was going through
> significant changes to the log code at the time, so it may not be
> possible to work out what the problem was. It seems likely that the
> power loss caused the disk not to write everything it should have to
> the log - laptops are not supposed to just lose power because
> they have a built in UPS (i.e. battery)....
>

My note book is connected to the mains, and there is no battery.  The Acer
user manual advises removing the battery when one is connected to the
mains, since repeated charging of battery will shorten its life span.

I have had servers and workstations with SLES 10 SP2, SLED 10 SP2, SLED
11, suffer numerous power outages in the labs (a repeated occurence
there), and never with file system error on start-up.  The LSI internal
RAID controllers disable the SAS drive caches, and the Areca RAID
controller has battery backed DRAM and disabled SATA drive cache.  But
there is one PC with five SATA WD Caviar Black 1 TB drives on the
motherboard AMD chipset with MD RAID RAID 0, and drive cache enabled.  The
XFS barrier is supposed to take care of drive cache issue, but I guess I
am unlucky this time.

Maybe disabling drive cache write-back is the solution for safety, but I
have tested numerous desktop SATA drives in the labs, there is a big big
drop in sequential write performance when the cache is set to
write-through.  There is no file system, just direct writes to the
sectors.  Hard drives seem to really need write-back for performance.

> The files in lost+found are numbered by their inode number. You need
> to look at the contents of them to determine where they came from.
>

Inode numbers are not informative, right?
Text files are readable, but binaries......, I will have no clue, and if I
delete them, who knows if I am deleting some thing really important?

Intuitively, the only files in root file system (by the way, root also
contains /boot) that are open for writing are those in logs and /tmp and
/var/tmp, I hope that is the case and I can safely discard those in
lost+found.

I also hope that the inode link clean-ups done by xfs_repair do not
actually remove any files that are really there.


GL

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
