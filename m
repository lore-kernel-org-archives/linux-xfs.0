Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o478L9gU154608 for <xfs@oss.sgi.com>; Fri, 7 May 2010 03:21:10 -0500
Received: from v007470.home.net.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id DCEB2966B54
	for <xfs@oss.sgi.com>; Fri,  7 May 2010 01:23:17 -0700 (PDT)
Received: from v007470.home.net.pl (v007470.home.net.pl [212.85.125.104]) by
	cuda.sgi.com with SMTP id 0nJcmxqblHY01vqH for
	<xfs@oss.sgi.com>; Fri, 07 May 2010 01:23:17 -0700 (PDT)
From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: posix_fallocate
Date: Fri, 7 May 2010 10:22:37 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201005071022.37863.kb@sysmikro.com.pl>
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

Hello,

I use this to preallocate large space but found an issue. Posix_fallocate 
works right with sizes like 100G, 1T and even 10T on some boxes (on some 
other can fail after e.g. 7T threshold) but if i tried e.g. 16T the user 
space process would be "R"unning forever and it is not interruptible. 
Furthermore some other not related processes like sshd, bash enter D state. 
There is nothing in kernel log.

I made so far a few logs with ftrace facility for 1G, 100G, 1T and 10T sizes. 
I noticed that for 1st three sizes the log is as long as abt 1.5M (2M peak) 
while 10T generates 94M long log. I couldn't retrieve a log for 17T case 
because "cat /sys ... /trace" enters D.

I would appreciate any help because i gave up with ftrace logs analysis. The 
xfs_vn_fallocate is covered in abt 11k lines for a 1.5M log case while there 
are abt 163k lines in 94M log. And all i could see is poss some relationship 
between time spent in xfs_vn_fallocate subfunctions vs requested space.

Box details:
16 Hitachi 2TB drives (backplane connected), dm, 1 lvm lun of 25T size,
kernel 2.6.31.5, more recent kernels neither xfs were not tested.


Regards,
Krzysztof Blaszkowski

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
