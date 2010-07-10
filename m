Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6A8DY9B156731 for <xfs@oss.sgi.com>; Sat, 10 Jul 2010 03:13:34 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCA5C439EDF
	for <xfs@oss.sgi.com>; Sat, 10 Jul 2010 01:16:27 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Bi5eAwrVnLyWu4HJ
	for <xfs@oss.sgi.com>; Sat, 10 Jul 2010 01:16:27 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id D88026C3EC
	for <xfs@oss.sgi.com>; Sat, 10 Jul 2010 03:16:26 -0500 (CDT)
Message-ID: <4C382C5A.2050107@hardwarefreak.com>
Date: Sat, 10 Jul 2010 03:16:26 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: filesystem shrinks after using xfs_repair
References: <F2D7937E-43FC-47F4-B041-B9C5C2CBCCD4@ucsc.edu>
In-Reply-To: <F2D7937E-43FC-47F4-B041-B9C5C2CBCCD4@ucsc.edu>
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

Eli Morris put forth on 7/9/2010 6:07 PM:
> Hi All,
> 
> I've got this problem where if I run xfs_repair, my filesystem shrinks by 11 TB, from a volume size of 62 TB to 51 TB. I can grow the filesystem again with xfs_growfs, but then rerunning xfs_repair shrinks it back down again. The first time this happened was a few days ago and running xfs_repair took about 7 TB of data with it. That is, out of the 11 TB of disk space that vanished, 7 TB had data on it, and 4 TB was empty space. XFS is running on top of an LVM volume. It's on an Intel/Linux system running Centos 5 (2.6.18-128.1.14.el5). Does anyone have an idea on what would cause such a thing and what I might try to keep it from continuing to happen. I could just never run xfs_repair again, but that doesn't seem like a good thing to count on. Major bonus points if anyone has any ideas on how to get my 7 TB of data back also. It must be there somewhere and it would be very bad to lose.
> 
> thanks for any help and ideas. I'm just stumped right now.

It may be helpful if you can provide more history (how long has this been
happening, recent upgrade?), the exact xfs_repair command line used, why you
were running xfs_repair in the first place, hardware or software RAID, what
xfsprogs version, relevant log snippets, etc.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
