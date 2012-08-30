Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UE98e3212876 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 09:09:09 -0500
Received: from bosmailout15.eigbox.net (bosmailout15.eigbox.net
	[66.96.190.15]) by cuda.sgi.com with ESMTP id tzGtIjSj4Xr27ftk
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 07:10:00 -0700 (PDT)
Received: from bosmailscan16.eigbox.net ([10.20.15.16])
	by bosmailout15.eigbox.net with esmtp (Exim) id 1T75RY-0006gr-7U
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 10:10:00 -0400
Received: from bosimpout01.eigbox.net ([10.20.55.1])
	by bosmailscan16.eigbox.net with esmtp (Exim) id 1T75RX-0004aV-Nd
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 10:09:59 -0400
Received: from [127.0.0.1] (helo=emailmg.netfirms.com)
	by boswebmail02.eigbox.net with esmtp (Exim) id 1T75QE-00010J-1K
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 10:08:38 -0400
Message-ID: <0e85aee5ff82e567e872230ef416766a.squirrel@emailmg.netfirms.com>
Date: Thu, 30 Aug 2012 22:08:38 +0800
Subject: XFS Mount Recovery Failed on Root File System After Power Outage
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
To: xfs@oss.sgi.com

Hi


I apologize first if this message appears a number of times, but my two
yahoo email accounts do not seem to be able to deliver to the mailing list
from afternoon till now and I have to use this account.

I just had a power outage and my Acer notebook computer running openSUSE
11.4 x86_64 with kernel 2.6.37 stopped as a result.

After I reset the circuit breaker I was unable to boot the OS.

I booted up the openSUSE 11.4 rescue disk (installation media).  I ran the
S.M.A.R.T. short self-test with smartctl on the W.D. Caviar Black 320 GB
drive and there were no errors.  The S.M.A.R.T. parameters all look OK.  I
have not run the long self test though.

I am able to mount the /home to /mnt on the rescue session and I see no
error in /var/log/messages.

I then tried again to mount the root file system to /mnt.

Aug 30 14:21:59 Rescue kernel: [  811.166914] XFS mounting filesystem sdb2
Aug 30 14:21:59 Rescue kernel: [  811.212169] Starting XFS recovery on
filesystem: sdb2 (logdev: internal)
Aug 30 14:21:59 Rescue kernel: [  811.334157] XFS: Invalid block length
(0xfffffffc) given for buffer
Aug 30 14:21:59 Rescue kernel: [  811.334175] XFS: log mount/recovery
failed: error 117
Aug 30 14:21:59 Rescue kernel: [  811.334230] XFS: log mount failed

XFS Check will not run since log recovery mount has not been done.

What is the cause of the recovery failure and what is the recommended
course of action?

I have tried the metadump and restore, then do a xfs_repair -L on the
metadump image, with xfs_repair version 3.1.8.  The repair is successful
and there are also some files copied to lost+found.

I would like to know the cause of this log recovery failure and if there
is another alternative to xfs_repair -L, since I do not really know what
files I would lose with the inodes being changed, and also I do not know
what the files in lost+found are.

Thank you for your assistance.



GL



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
