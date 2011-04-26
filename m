Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QM8VxT184731 for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 17:08:31 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54A89153D66F
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 15:12:02 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id cBDEtylKWO6pSnnt
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 15:12:02 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 196A36C032
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 17:12:02 -0500 (CDT)
Message-ID: <4DB74331.3030804@hardwarefreak.com>
Date: Tue, 26 Apr 2011 17:12:01 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs performance problem
References: <4DB72084.8020205@inf.ethz.ch>
In-Reply-To: <4DB72084.8020205@inf.ethz.ch>
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

Benjamin Schindler put forth on 4/26/2011 2:44 PM:
> Hi
> 
> Since upgrading to newer kernels I have serious problems with xfs
> performance on my root fs.
> It runs on a software raid 0 with 2 disks. On the same two disks, there
> are two more partitions running a software raid-1 with ext3. On the ext3
> system, I have no issue, so I assume the drives are fine.
> But on the xfs filesystem, extracting a linux kernel archive takes 5
> minutes or more, running ldconfig similarily long. The harddrives are
> sata-2.
> I'm running gentoo linux with kernel 2.6.38-gentoo-r1. I'm attaching the
> kernel config but I guess more info is needed - just let me know what is
> needed.

The kernel config isn't the problem.  You haven't enabled the delayed
logging feature.  Add 'delaylog' to your fstab mount options for XFS
devices, remount (or reboot if necessary) and it should decrease the run
time of kernel tar extractions between 10x and 100x.

Also, slap yourself in the forehead at least 3 times for running your
root filesystem on RAID 0.  That's akin to riding a motorcycle, naked,
in a blizzard, down a steep, winding, ice covered mountain road with no
guard rails and a 3000 ft drop. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
