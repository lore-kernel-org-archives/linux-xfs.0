Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o48Mnk5n204129 for <xfs@oss.sgi.com>; Sat, 8 May 2010 17:49:46 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AE4631FDE9
	for <xfs@oss.sgi.com>; Sat,  8 May 2010 15:51:57 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 9Fu6EhN7nq3APVF5
	for <xfs@oss.sgi.com>; Sat, 08 May 2010 15:51:57 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 2CA876C074
	for <xfs@oss.sgi.com>; Sat,  8 May 2010 17:51:57 -0500 (CDT)
Message-ID: <4BE5EB5D.5020702@hardwarefreak.com>
Date: Sat, 08 May 2010 17:53:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: failed to read root inode
References: <4BE55A63.8070203@purplehaze.ch>
In-Reply-To: <4BE55A63.8070203@purplehaze.ch>
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

Christian Affolter put forth on 5/8/2010 7:34 AM:
> Hi
> 
> After a disk crash within a hardware RAID-6 controller and kernel
> freeze, I'm unable to mount an XFS filesystem on top of an EVMS volume:

What storage management operation(s) were you performing when this crash
occurred?  Were you adding, deleting, shrinking, or growing an EVMS volume
when the "crash" occurred, or was the system just sitting idle with no load
when the crash occurred?

Why did the "crash" of a single disk in a hardware RAID6 cause a kernel
freeze?  What is your definition of "disk crash"?  A single physical disk
failure should not have caused this under any circumstances.  The RAID card
should have handled a single disk failure transparently.

Exactly which make/model is the RAID card?  What is the status of each of
the remaining disks attached to the card as reported by its BIOS?  What is
the status of the RAID6 volume as reported by the RAID card BIOS?  What is
the status of each of your EVMS volumes as reported by the EVMS UI?

I'm asking all of these questions because it seems rather clear that the
root cause of your problem lies at a layer well below the XFS filesystem.

You have two layers of physical disk abstraction below XFS:  a hardware
RAID6 and a software logical volume manager.  You've apparently suffered a
storage system hardware failure, according to your description.  You haven't
given any details of the current status of the hardware RAID, or of the
logical volumes, merely that XFS is having problems.  I think a "Well duh!"
is in order.

Please provide _detailed_ information from the RAID card BIOS and the EVMS
UI.  Even if the problem isn't XFS related I for one would be glad to assist
you in getting this fixed.  Right now we don't have enough information.  At
least I don't.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
