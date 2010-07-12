Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C6aTnq010386 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 01:36:29 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B0AE14B8B2D
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 23:45:20 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id WiolzsnkjEx4hrcI for
	<xfs@oss.sgi.com>; Sun, 11 Jul 2010 23:45:20 -0700 (PDT)
Received: from [128.114.125.112] (HELO ucsc.edu)
	by email-prod-out-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPS id 15033788 for xfs@oss.sgi.com;
	Sun, 11 Jul 2010 23:39:22 -0700
Received: from [98.234.26.5] (account ermorris@ucsc.edu HELO [10.0.1.3])
	by email-prod-fe-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 355261899 for xfs@oss.sgi.com;
	Sun, 11 Jul 2010 23:39:16 -0700
From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Sun, 11 Jul 2010 23:39:16 -0700
Message-Id: <F412D2F0-EA77-4AA7-97EA-9125964F1A32@ucsc.edu>
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

Eli Morris put forth on 7/11/2010 8:10 PM:
>Hi guys,
>
>Here are some of the log files from my XFS problem. Yes, I think this all 
>started with a hardware failure of some sort. My storage is RAID 6, a an 
>Astra SecureStor ES.
>
>
> [root@nimbus log]# more messages.1 | grep I/O
>Jul  2 17:02:30 nimbus kernel: sd 6:0:0:0: rejecting I/O to offline device
>Jul  2 17:02:30 nimbus kernel: sd 6:0:0:0: rejecting I/O to offline device
>Jul  2 17:02:30 nimbus kernel: sr 5:0:0:0: rejecting I/O to offline device

<snip>

What does the web gui log on the Astra ES tell you?

If the Astra supports syslogging (I assume it does as it is billed as
"enterprise class") you should configure that to facilitate consistent error
information gathering--i.e. grep everything from one terminal session.

-- 
Stan

Hi,
After I got into work on Tues, I looked at the log files from the web interface for the Astra RAID controller. I also contacted support and sent them a system report, which contains the logs as well as information about the system. Neither he, nor I, saw any problems in the log files. The support person said he could not find any problems with the units. The only thing he mentioned was that I should turn off the SMART daemon, because it does not work with RAID units. I'll note also that since the day when the I/O errors occurred, I have not seen any additional errors from the units, although that may be because we are not reading or writing to them for obvious reasons.
If it turns out we can not recover the lost amount of data, I still would need to get the remaining filesystem stable, so we can restore what we can from backup and get going again. And I'm really wondering why if I grow the filesystem back to the size of the LVM logical volume, when I run xfs_repair, it shrinks back down again. For all I know, that always happens, when one runs xfs_repair on a just expanded file system. I'll check into the syslogging capability of the Astra, but as of now, I have to look at its separate log files from the web gui.

thanks,
Eli




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
