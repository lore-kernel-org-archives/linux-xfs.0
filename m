Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8AJ084o160916 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 14:00:08 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01E92DB308F
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 12:12:17 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id S22TIYYv2OqFyvON
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 12:12:17 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id AFEE36C3E0
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 14:00:51 -0500 (CDT)
Message-ID: <4C8A8063.8070507@hardwarefreak.com>
Date: Fri, 10 Sep 2010 14:00:51 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS defragmentation issue
References: <4C8A4395.5070702@kickstone.com>
In-Reply-To: <4C8A4395.5070702@kickstone.com>
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

John Lister put forth on 9/10/2010 9:41 AM:
>  Hi, using ubuntu 9.04, kernel version 2.6.28-18 and xfsprog v2.10.2-1
> I'm trying to defragment a drive. If I use xfs_db to check for
> fragmentation it shows for example that a file has 20k+ fragments:
> inode 578505506 actual 23240 ideal 1
> 
> mapping the inode to the file and running xfs_frs states that the file
> is fully defragmented.
> 
> Also running xfs_frs says the drive is defragmented while xfs_db for
> example reports 300k fragments.
> 
> Which is right? and is it possible to defragment the file assuming it is
> fragmented so badly, if so how?

Try unmounting and remounting the filesystem, and see if the various
tools all report the same thing afterwards.  This solved the exact same
problem for me very recently, though I'm on kernel 2.6.34.1 and xfsprogs
2.9.8.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
