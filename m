Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7VJWe5K220262 for <xfs@oss.sgi.com>; Fri, 31 Aug 2012 14:32:40 -0500
Received: from nm23-vm4.bullet.mail.sg3.yahoo.com
	(nm23-vm4.bullet.mail.sg3.yahoo.com [106.10.151.67]) by
	cuda.sgi.com with SMTP id mXrjsXC2ByZzwGhS for
	<xfs@oss.sgi.com>; Thu, 30 Aug 2012 05:08:05 -0700 (PDT)
Message-ID: <1346328484.91944.YahooMailClassic@web192201.mail.sg3.yahoo.com>
Date: Thu, 30 Aug 2012 20:08:04 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: XFS Mount Recovery Failed on Root File System After Power Outage
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


I just had a power outage and my Acer notebook computer running openSUSE 11.4 x86_64 with kernel 2.6.37 stopped as a result.

After I reset the circuit breaker I was unable to boot the OS.

I booted up the openSUSE 11.4 rescue disk (installation media).  I ran the S.M.A.R.T. short self-test with smartctl on the W.D. Caviar Black 320 GB drive and there were no errors.  The S.M.A.R.T. parameters all look OK.  I have not run the long self test though.

I am able to mount the /home to /mnt on the rescue session and I see no error in /var/log/messages.

I then tried again to mount the root file system to /mnt.  

Aug 30 14:21:59 Rescue kernel: [  811.166914] XFS mounting filesystem sdb2
Aug 30 14:21:59 Rescue kernel: [  811.212169] Starting XFS recovery on filesystem: sdb2 (logdev: internal)
Aug 30 14:21:59 Rescue kernel: [  811.334157] XFS: Invalid block length (0xfffffffc) given for buffer
Aug 30 14:21:59 Rescue kernel: [  811.334175] XFS: log mount/recovery failed: error 117
Aug 30 14:21:59 Rescue kernel: [  811.334230] XFS: log mount failed

XFS Check will not run since log recovery mount has not been done.

What is the cause of the recovery failure and what is the recommended course of action?

The XFS Check and XFS Repair versions on the rescue disk are 3.1.4.  Are they sufficient to do any repair?

If I need a newer version of XFS Check and XFS Repair I will need to think of something since there is no compiler on the Rescue system and my openSUSE 11.4 desktop is down with hardware failure.

Thank you for your assistance.



GL

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
