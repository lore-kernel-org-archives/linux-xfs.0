Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R3C0sJ016200 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 21:12:00 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id bCfjbrewYHnMo2Ea (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Feb 2012 19:11:59 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S1r0I-0004sr-J7
	for xfs@oss.sgi.com; Sun, 26 Feb 2012 19:11:58 -0800
Message-ID: <33397518.post@talk.nabble.com>
Date: Sun, 26 Feb 2012 19:11:58 -0800 (PST)
From: MikeJeezy <forums@mgaccess.net>
Subject: Re: mount: Structure needs cleaning
In-Reply-To: <20120227004902.GQ3592@dastard>
MIME-Version: 1.0
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
	<33393429.post@talk.nabble.com> <20120227004902.GQ3592@dastard>
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




>The only reason for running xfs-repair -L is if you cannot mount the
>filesystem to replay the log. i.e. on a shutdown like this, the
>usual process is:

Right, when I tried to mount the volume it said "Structure needs cleaning"

>You can only find out by looking at what the output of xfs_repair
>told you about trashing inodes/directories.

Is this only output to the screen or to a log somewhere?

> On 02/26/2012 11:07am, Stan Hoeppner wrote: 
>Are those other VMs using XFS filesystems? 

What kernel version are you running?  

2.6.18-274.18.1.el5

>Are you using LVM under XFS?  

No

>What fstab mount options?  

/dev/sdd1               /mnt/ob1               xfs     defaults        0 0
/dev/sde1               /mnt/ob2               xfs     defaults        0 0

>Does your SAN array have battery backed write cache?  

This one does not currently, but I have ordered BBWC for it.

>Are the individual drive caches in the underlying array disabled? 

Write cache: enabled
Read ahead: enabled

-- 
View this message in context: http://old.nabble.com/mount%3A-Structure-needs-cleaning-tp33393100p33397518.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
