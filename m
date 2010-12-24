Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBO5DCpm066373 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 23:13:13 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D2B61A32E30
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 21:15:10 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id zoO9lZQiVgBTpYSs
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 21:15:10 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 86D8A6C14F
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 23:15:10 -0600 (CST)
Message-ID: <4D142C5E.2020004@hardwarefreak.com>
Date: Thu, 23 Dec 2010 23:15:10 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101223165532.GA23813@peter.simplex.ro>	<4D13A30A.3090600@hardwarefreak.com>	<20101223211650.GA19694@peter.simplex.ro>
	<4D13EF3B.2050401@hardwarefreak.com>
In-Reply-To: <4D13EF3B.2050401@hardwarefreak.com>
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

Stan Hoeppner put forth on 12/23/2010 6:54 PM:

> http://www.mjmwired.net/kernel/Documentation/filesystems/xfs.txt
> 
> fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
> 	The interval at which the xfssyncd thread flushes metadata
> 	out to disk.  This thread will flush log activity out, and
> 	do some processing on unlinked inodes.
>
> Maybe related or also worth mentioning:
> 
> fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)
> 	The age at which xfsbufd flushes dirty metadata buffers to disk.

These can be found in /proc/sys/fs/xfs and you'd simply

~$ echo 720000 > /proc/sys/fs/xfs/xfssyncd_centisecs

to get the maximum 12 minute interval.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
