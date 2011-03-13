Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2D2G0qw253313 for <xfs@oss.sgi.com>; Sat, 12 Mar 2011 20:16:05 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F0EA1380455
	for <xfs@oss.sgi.com>; Sat, 12 Mar 2011 18:18:51 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KtNwyPl9bwdwZA0r for <xfs@oss.sgi.com>;
	Sat, 12 Mar 2011 18:18:51 -0800 (PST)
Date: Sun, 13 Mar 2011 11:48:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: testcase 011 trips and ASSERT in x86_64 too
Message-ID: <20110313004810.GE15097@dastard>
References: <1299899166.32230.629.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299899166.32230.629.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Fri, Mar 11, 2011 at 07:06:06PM -0800, Chandra Seetharaman wrote:
> Hello,
> 
> A while back I reported that the test case 011 trips an ASSERT on POWER
> architecture, but not in x86_64.
> 
> I started comparing the code and quickly realized that the problem is
> _not_ arch specific, but could make the test case 011 fail, with reduced
> log on x86_64. But, I could make the POWER not fail by simply increasing
> the file system size to 100G (from 20G).
> 
> After some debug I found that I get into this racy situation when the
> free threshold drops and we flush the log buffer to the disk.
> i.e in function xlog_grant_push_ail(), if we return at
> 
>        if (free_blocks >= free_threshold)
>                 return;
> we do not get into the race that trips the ASSERT.

As i said before, the debug check is known to be racy. Having it
trigger is not necessarily a sign of a problem. I have only ever
tripped it once since the way the check operates was changed.
There's no point in spending time trying to analyse it and explain
it as we already know why and how it can trigger in a racy manner.

> Then I started comparing the behavioral difference bet the two ARCHs,
> and I found that in POWER I see more number of threads at a time (max of
> 4 threads) in the function xlog_grant_log_space(), whereas in x86_64 I
> see max of only two and mostly it is only one.
> 
> I also noted that in POWER test case 011 takes about 8 seconds whereas
> in x86_64, it takes about 165 seconds.
> 
> So, I ventured into the core of test case 011, dirstress, and found that
> simply creating 1000s of files under a directory takes very long time in
> x86_64 compare to POWER(1 min 15s Vs 2s)

On my x86-64 boxes, test 011 takes 3s with CONFIG_XFS_DEBUG=y, all
lock checking turned on, memory poisoning active, etc. With a
prodution kernel, it usually takes 1s. Even on a single SATA drive.

So, without knowing anything about your x86-64 machine, I'd say
there's something wrong with it or it's configuration. Try turning
off barriers and seeing if that makes it go faster....

> Note: Attached is the source file (stripped version of dirstress.c) for
> the program b.
> ------------------POWER----------------------------------
> root@test135 chandra]# uname -a 
> Linux test135.beaverton.ibm.com 2.6.38-rc7 #1 SMP Fri Mar 4 09:36:14 PST
> 2011 ppc64 ppc64 ppc64 GNU/Linux
> [root@test135 chandra]# grep -e xfs -e home /proc/mounts
> none /selinux selinuxfs rw,relatime 0 0
> /dev/mapper/vg_test135-lv_home /home ext4
> rw,seclabel,relatime,barrier=1,data=ordered 0 0
> /dev/sda8 /mnt/xfsMntPt xfs rw,seclabel,relatime,attr2,noquota 0 0
> [root@test135 chandra]# ###### Run test on XFS filesystem
> [root@test135 chandra]# time ./b /mnt/xfsMntPt/dir 10000 1
> i 0
> 
> real    0m2.055s
> user    0m0.011s
> sys     0m0.732s
> [root@test135 chandra]# ###### Run test of ext4 filesystem
> [root@test135 chandra]# time ./b /home/dir 10000 1
> i 0
> 
> real    0m0.355s
> user    0m0.009s
> sys     0m0.304s
> --------------------x86_64----------------------------------------
> [root@test27 chandra]# uname -a
> Linux test27 2.6.38-rc7 #4 SMP Wed Mar 9 08:37:32 PST 2011 x86_64 x86_64
> x86_64 GNU/Linux
> [root@test27 chandra]# grep -e xfs -e home /proc/mounts
> none /selinux selinuxfs rw,relatime 0 0
> /dev/sdc3 /home ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0
> /dev/sdb1 /mnt/xfsMntPt xfs rw,seclabel,relatime,attr2,noquota 0 0
> [root@test27 chandra]# ###### Run test on XFS filesystem
> [root@test27 chandra]# time ./b /mnt/xfsMntPt/dir 10000 1
> i 0
> 
> real    1m15.700s
> user    0m0.030s
> sys     0m1.679s
> [root@test27 chandra]# ###### Run test of ext4 filesystem
> [root@test27 chandra]# time ./b /home/dir 10000 1
> i 0
> 
> real    0m0.317s
> user    0m0.010s
> sys     0m0.306s
> -------------------------------------------------------------------
> 
> After quite an amount of debug I found that I can make it trip the
> ASSERT in x86_64 also, if I start sufficient of threads accessing the
> file system. Basically, "./b /mnt/xfsMntPt/dir 100 100" trips the
> ASSERT.
> 
> I have two questions:
> 
> 1. Does anybody have any explanation why x86_64 is so slow, compared
> with POWER ?
> 
> 2. Any suggestions on how to debug and fix the race condition ? 

We'll probably just change the assert to a:

#ifdef DEBUG
	WARN_ON_ONCE(assert condition)
#endif

So that it just logs the fact it was hit when we are running debug
XFS kernels.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
