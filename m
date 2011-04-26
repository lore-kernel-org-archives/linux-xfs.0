Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QNuxht188263 for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 18:57:00 -0500
Received: from edge20.ethz.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98D6F133290F
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 17:00:30 -0700 (PDT)
Received: from edge20.ethz.ch (edge20.ethz.ch [82.130.99.26]) by cuda.sgi.com
	with ESMTP id pCrOk8tV9OisFaUO for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2011 17:00:30 -0700 (PDT)
Message-ID: <4DB75C6D.1080901@inf.ethz.ch>
Date: Wed, 27 Apr 2011 01:59:41 +0200
From: Benjamin Schindler <bschindler@inf.ethz.ch>
MIME-Version: 1.0
Subject: Re: xfs performance problem
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
In-Reply-To: <4DB74331.3030804@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Hi

I thought I would do a real measurement to have some numbers.
On my raid-1 ext3, extracting a kernel archive:

benjamin@metis ~/software $ time tar xfj
/usr/portage/distfiles/linux-2.6.38.tar.bz2

real    0m21.769s
user    0m13.905s
sys     0m1.751s

On my root xfs

root@metis ~ $ time tar xfj /usr/portage/distfiles/linux-2.6.38.tar.bz2

real    2m20.522s
user    0m16.051s
sys     0m3.147s

This is of course with delaylog enabled. I don't think a difference  of
a factor 7 is normal, given that writing to a raid-0 (xfs numbers) is
supposed to be faster than writing to raid-1 (ext3 numbers)

Cheers
Benjamin


On 27.04.2011 00:12, Stan Hoeppner wrote:
> Benjamin Schindler put forth on 4/26/2011 2:44 PM:
>> Hi
>>
>> Since upgrading to newer kernels I have serious problems with xfs
>> performance on my root fs.
>> It runs on a software raid 0 with 2 disks. On the same two disks, there
>> are two more partitions running a software raid-1 with ext3. On the ext3
>> system, I have no issue, so I assume the drives are fine.
>> But on the xfs filesystem, extracting a linux kernel archive takes 5
>> minutes or more, running ldconfig similarily long. The harddrives are
>> sata-2.
>> I'm running gentoo linux with kernel 2.6.38-gentoo-r1. I'm attaching the
>> kernel config but I guess more info is needed - just let me know what is
>> needed.
> 
> The kernel config isn't the problem.  You haven't enabled the delayed
> logging feature.  Add 'delaylog' to your fstab mount options for XFS
> devices, remount (or reboot if necessary) and it should decrease the run
> time of kernel tar extractions between 10x and 100x.
> 
> Also, slap yourself in the forehead at least 3 times for running your
> root filesystem on RAID 0.  That's akin to riding a motorcycle, naked,
> in a blizzard, down a steep, winding, ice covered mountain road with no
> guard rails and a 3000 ft drop. ;)
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
