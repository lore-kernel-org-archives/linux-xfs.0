Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C2L9r8260005 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 21:21:10 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1671743BBE7
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 19:24:02 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id TNrQ4Sej4hKPR0Jm
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 19:24:02 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 40CA16C482
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 21:24:02 -0500 (CDT)
Message-ID: <4C3A7CC1.9030106@hardwarefreak.com>
Date: Sun, 11 Jul 2010 21:24:01 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: filesystem shrinks after using xfs_repair
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
In-Reply-To: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
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
> Hi guys,
> 
> Here are some of the log files from my XFS problem. Yes, I think this all started with a hardware failure of some sort. My storage is RAID 6, a an Astra SecureStor ES.
> 
> 
> [root@nimbus log]# more messages.1 | grep I/O
> Jul  2 17:02:30 nimbus kernel: sd 6:0:0:0: rejecting I/O to offline device
> Jul  2 17:02:30 nimbus kernel: sd 6:0:0:0: rejecting I/O to offline device
> Jul  2 17:02:30 nimbus kernel: sr 5:0:0:0: rejecting I/O to offline device

<snip>

What does the web gui log on the Astra ES tell you?

If the Astra supports syslogging (I assume it does as it is billed as
"enterprise class") you should configure that to facilitate consistent error
information gathering--i.e. grep everything from one terminal session.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
