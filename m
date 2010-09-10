Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8AMJDSV168494 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 17:19:13 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2A98DB363E
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 15:31:23 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sdXf92myuZKURjyJ
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 15:31:23 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 10BF46C052
	for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 17:19:55 -0500 (CDT)
Message-ID: <4C8AAF0A.6010701@hardwarefreak.com>
Date: Fri, 10 Sep 2010 17:19:54 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS over LVM over md RAID
References: <4C89668E.6010800@sauce.co.nz>
	<20100910013026.GA24409@dastard>	<4C899816.6030506@sauce.co.nz>
	<4C8A3F8F.4000704@sandeen.net> <4C8AA62A.9020704@sauce.co.nz>
In-Reply-To: <4C8AA62A.9020704@sauce.co.nz>
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

Richard Scobie put forth on 9/10/2010 4:42 PM:

> In the future this lv will be grown in multiples of  256K chunk, 16
> drive RAID6 arrays, so am I correct in thinking that the sunit/swidth
> parameter can stay the same as it is expanded?

What is the reasoning behind adding so many terabytes under a single
filesystem?

Do you _need_ all of it under a single mount point?  If not, or even if
you do, for many reasons, it may very well be better to put a single
filesystem directly on each RAID6 array without using LVM in the middle
and simply mount each filesystem at a different point, say:

/data
/data/array1
/data/array2
/data/array3
/data/array4

This method can minimize damage and downtime when an entire array is
knocked offline.  We just had a post yesterday where a SATA cable was
kicked loose and took 5 drives down of a 15 drive md RAID6 set, killing
the entire filesystem.  If that OP had setup 3x5 drive arrays with 3
filesystems, the system could have continued to run in a degraded
fashion, depending on his application data layout across the
filesystems.  If done properly, you lose an app or two, not all of them.

This method also eliminates xfs_growfs performance issues such as what
you're describing because you're never changing the filesystem layout
when adding new arrays to the system.

In summary, every layer of complexity added to the storage stack
increases the probability of failure.  As my grandmother was fond of
saying, "Don't put all of your eggs in one basket."  It was salient
advice on the farm 80 years ago, and it's salient advice today with high
technology.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
