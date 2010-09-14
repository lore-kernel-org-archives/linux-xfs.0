Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8E4h3I9107172 for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 23:43:04 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C3F26EF17
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 21:43:51 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id vAKcCIchpnF3sZFy for
	<xfs@oss.sgi.com>; Mon, 13 Sep 2010 21:43:51 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OvNN1-0001Ur-Ie
	for xfs@oss.sgi.com; Mon, 13 Sep 2010 21:43:51 -0700
Message-ID: <29705181.post@talk.nabble.com>
Date: Mon, 13 Sep 2010 21:43:51 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: Re: XFS Filesystem not mounting
In-Reply-To: <20100914012151.GF411@dastard>
MIME-Version: 1.0
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
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


Dave,

> There's a good chance your storage is in a bad state. Can you send the
> output
> of "echo w > /proc/sysrq-trigger" when the system is hung?

I issued your command this after running 'mount /dev/sdd1 /data'

dmesg outputs:
XFS mounting filesystem sdd1
Starting XFS recovery on filesystem: sdd1 (logdev: internal)
SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem Nice
powerOff showPc unRaw Sync showTasks Unmount 


Not much... nothing on the command line appears.

>From ps ax, here are my dead processes:

 1909 ?        S<     0:04 [xfslogd/0]
 1910 ?        S<     0:39 [xfsdatad/0]
10044 tty1     D+     0:00 mount /dev/sdd1 /data/
10045 ?        S<     0:00 [xfsbufd]


Thanks again so very much!

-Cheers, Peter.
-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29705181.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
