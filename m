Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2F2OBTl101096 for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 21:24:22 -0500
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAC8F1DEA33D
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 19:26:55 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id fYY1TRUVkNOcu66n for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2011 19:26:55 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2F2BbYs006326
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 20:11:37 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p2F2Qm2L111406 for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 20:26:48 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p2F2Qle6015920
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 20:26:48 -0600
Subject: Re: testcase 011 trips and ASSERT in x86_64 too
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110313004810.GE15097@dastard>
References: <1299899166.32230.629.camel@chandra-lucid.beaverton.ibm.com>
	<20110313004810.GE15097@dastard>
Date: Mon, 14 Mar 2011 19:29:32 -0700
Message-ID: <1300156172.32230.670.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Sun, 2011-03-13 at 11:48 +1100, Dave Chinner wrote:

Thanks for your response, Dave.

<snip>
> As i said before, the debug check is known to be racy. Having it
> trigger is not necessarily a sign of a problem. I have only ever
> tripped it once since the way the check operates was changed.
> There's no point in spending time trying to analyse it and explain
> it as we already know why and how it can trigger in a racy manner.

Oh, may be I misunderstood. In your earlier reply you mentioned that you
wanted to know if the problem is consistently reproducible. Since it
was, I went on to debug the problem. 

If it is not an issue, it will be a good idea to reduce that ASSERT to
WARN_ON_ONCE() as you mentioned.

> 
> > Then I started comparing the behavioral difference bet the two ARCHs,
> > and I found that in POWER I see more number of threads at a time (max of
> > 4 threads) in the function xlog_grant_log_space(), whereas in x86_64 I
> > see max of only two and mostly it is only one.
> > 
> > I also noted that in POWER test case 011 takes about 8 seconds whereas
> > in x86_64, it takes about 165 seconds.
> > 
> > So, I ventured into the core of test case 011, dirstress, and found that
> > simply creating 1000s of files under a directory takes very long time in
> > x86_64 compare to POWER(1 min 15s Vs 2s)
> 
> On my x86-64 boxes, test 011 takes 3s with CONFIG_XFS_DEBUG=y, all
> lock checking turned on, memory poisoning active, etc. With a
> prodution kernel, it usually takes 1s. Even on a single SATA drive.
> 
> So, without knowing anything about your x86-64 machine, I'd say
> there's something wrong with it or it's configuration. Try turning
> off barriers and seeing if that makes it go faster....

Slowness happened in two x86_64 blades. 

In the blade where the storage is a SSD device, nobarrier helped
drastically.
==========
[root@test27 chandra]# mount -o nobarrier /dev/disk/by-id/wwn-0x5000a7203002f7e4-part1 /mnt/xfsMntPt/
[root@test27 chandra]# time ./b /mnt/xfsMntPt/d1/ 10000 1
i 0

real	0m1.983s
user	0m0.026s
sys	0m1.365s
===================

Whereas, in the blade where the storage is a SAN disk, it didn't help
much. Note that I verified the disk is performing fine by using a ext4
filesystem.
===================
[root@test65 chandra]# mount /dev/sdb1 /mnt/xfs
[root@test65 chandra]# mount /dev/sdb2 /mnt/ext4
[root@test65 chandra]# tail -2 /proc/mounts 
/dev/sdb1 /mnt/xfs xfs rw,seclabel,relatime,attr2,noquota 0 0
/dev/sdb2 /mnt/ext4 ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0
[root@test65 chandra]# time ./b /mnt/ext4/d1 10000 1
i 0

real    0m0.332s
user    0m0.006s
sys     0m0.264s
[root@test65 chandra]# time ./b /mnt/xfs/d1 10000 1
i 0

real    1m35.620s
user    0m0.012s
sys     0m0.735s
[root@test65 chandra]# mount -o nobarrier /dev/sdb1 /mnt/xfs
[root@test65 chandra]# tail -2 /proc/mounts
/dev/sdb2 /mnt/ext4 ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0
/dev/sdb1 /mnt/xfs xfs rw,seclabel,relatime,attr2,nobarrier,noquota 0 0
[root@test65 chandra]# time ./b /mnt/xfs/d1 10000 1
i 0

real    1m6.772s
user    0m0.011s
sys     0m0.739s
========================

What else could affect the behavior like this ?

Also, note that in power I get the fast performace with barrier on.

Thanks,

chandra

<snip>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
