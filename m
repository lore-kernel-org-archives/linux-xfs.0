Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6B6UFJ6210888 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 01:30:15 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AA5A1E25AE5
	for <xfs@oss.sgi.com>; Sat, 10 Jul 2010 23:33:08 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id WkgbKUZ4C1llDsjm for
	<xfs@oss.sgi.com>; Sat, 10 Jul 2010 23:33:08 -0700 (PDT)
Received: from [128.114.125.112] (HELO ucsc.edu)
	by email-prod-out-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPS id 14986208 for xfs@oss.sgi.com;
	Sat, 10 Jul 2010 23:33:07 -0700
Received: from [98.234.26.5] (account ermorris@ucsc.edu HELO [10.0.1.3])
	by email-prod-fe-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 355178333 for xfs@oss.sgi.com;
	Sat, 10 Jul 2010 23:32:58 -0700
From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Sat, 10 Jul 2010 23:32:57 -0700
Message-Id: <84CF7106-D080-46F0-945B-5BC0DC7DBBE1@ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
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

> Eli Morris put forth on 7/9/2010 6:07 PM:
>> Hi All,
>> 
>> I've got this problem where if I run xfs_repair, my filesystem shrinks by 11 TB, from a volume size of 62 TB to 51 TB. I can grow the filesystem again with xfs_growfs, but then rerunning xfs_repair shrinks it back down again. The first time this happened was a few days ago and running xfs_repair took about 7 TB of data with it. That is, out of the 11 TB of disk space that vanished, 7 TB had data on it, and 4 TB was empty space. XFS is running on top of an LVM volume. It's on an Intel/Linux system running Centos 5 (2.6.18-128.1.14.el5). Does anyone have an idea on what would cause such a thing and what I might try to keep it from continuing to happen. I could just never run xfs_repair again, but that doesn't seem like a good thing to count on. Major bonus points if anyone has any ideas on how to get my 7 TB of data back also. It must be there somewhere and it would be very bad to lose.
>> 
>> thanks for any help and ideas. I'm just stumped right now.
> 
> It may be helpful if you can provide more history (how long has this been
> happening, recent upgrade?), the exact xfs_repair command line used, why you
> were running xfs_repair in the first place, hardware or software RAID, what
> xfsprogs version, relevant log snippets, etc.

Hi Stan,

Thanks for responding. Sure, I'll try and give more information.

I got some automated emails this Sunday about I/O errors coming from the computer (which is a Dell Poweredge 2950 w/ a connected 16 bay hardware RAID which is connected itself to 4 16 bay JBODs. The RAID controller is connected via SAS / LSI Fusion card to the Poweredge - Nimbus). It was Sunday, so I just logged in, rebooted, ran xfs_repair, then mounted the filesystem back. I tried a quick little write test, just to make sure I could write a file to it and read it back and called it a day until work the next day. When I came into work, I looked at the volume more closely and noticed that the filesystem shrank as I stated. Each of the RAID/JBODs is configured as a separate device and represents one physical volume in my LVM2 scheme, and those physical volumes are then combined into one logical volume. Then the filesystem sits on top of this. One one of the physical volumes  (PVs) - on /dev/sdc1, I noticed when I ran pvdisplay that of the 12.75 TB comprising the volume, 12.00!
  TB was being shown as 'not usable'. Usually this number is a couple of megabytes. So, after staring at this a while, I ran pvresize on that PV. The volume then listed 12.75 as usable, with a couple of megabytes not usable as one would expect. I then gave the command xfs_growfs on my filesystem and once again the file system was back to 62 TB. But it was showing the increased space as free space, instead of only 4.x TB of it as free as before all this happened. I then ran xfs_repair on this again, thinking it might find the missing data. Instead the filesystem decreased back to 51 TB. I rebooted and tried again a couple of times and the same thing happened. I'd really, really like to get that data back somehow and also to get the filesystem to where we can start using it again.

Version 2.9.4 of xfsprogs. xfs_repair line used 'xfs_repair /dev/vg1/vol5', vol5 being the LVM2 logical volume.  I spoke with tech support from my RAID vendor and he said he did not see any sign of errors with the RAID itself for what that is worth.

Nimbus is the hostname of the computer that is connected to the RAID/JBODs unit. The other computers (compute-0-XX) are only connected via NFS to the RAID/JBODs.

I've tried to provide a lot here,  but if I can provide any more information, please let me know. Thanks very much,

Eli

I'm trying to post logs, but my emails keep getting bounced. I'll see if this one makes it.
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
