Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB8MCJ3W149194 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 16:12:19 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D066C1CA7F4F
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 14:14:07 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 99wgGwIGgL6qbMh5
	for <xfs@oss.sgi.com>; Wed, 08 Dec 2010 14:14:07 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id D2A6C6C174
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 16:14:05 -0600 (CST)
Message-ID: <4D00032D.4040000@hardwarefreak.com>
Date: Wed, 08 Dec 2010 16:14:05 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs tuning for a 830 GB partition (mkfs.xfs options)
References: <AANLkTimkZB20eqywSPvwh00gcXWcr4_Eqm5u40P6RqaJ@mail.gmail.com>
In-Reply-To: <AANLkTimkZB20eqywSPvwh00gcXWcr4_Eqm5u40P6RqaJ@mail.gmail.com>
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

Abel Coto put forth on 12/8/2010 1:32 PM:
> I want to create a 830 GB partition, to mount as /home in my Centos 5.4
> workstation.
> 
> Actually i have /home not mounted ,so i would have to create the new
> partition in the lvm,format it and use rsync to copy /home directory to it.
> 
> for a 830 GB partition that i will use to save my data in general and also
> 3d / CG projects and renders once finished them what agcount value should be
> used. I have read that mkfs default option creates 1 allocation group each
> 4G , so i understand that for a 830 GB partition agcount should be 208.
> 
> It is this correct ?

No that's not correct.

> so i would use for format the partition
> 
> mkfs.xfs -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=208 -L
> VolumeName <dev>

Do not do this!  If this filesystem will reside on a single physical
disk, format the partition using the XFS defaults.  agcount, and most of
the other options, exists for optimizing parallel performance on striped
RAID or SSD storage systems that have lots of IOPS performance.  These
options are _not_ for use on single disk drives.

AG count is related to number of spindles and/or IOPs throughput, not
the size of the partition.  The mkfs.xfs default for a single drive
filesystem is 4 AGs.  If you specify a value greater than 4 your
performance will suffer.  If you specify 208 AGs it may likely be little
faster than a floppy disk drive.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
