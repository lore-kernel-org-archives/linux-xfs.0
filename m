Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o828fOtB194677 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 03:41:24 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67F1215DEB4C
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 01:52:40 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 2cVOErU4t7f43x4X
	for <xfs@oss.sgi.com>; Thu, 02 Sep 2010 01:52:40 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id E2DC16C004
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 03:41:59 -0500 (CDT)
Message-ID: <4C7F6357.7010007@hardwarefreak.com>
Date: Thu, 02 Sep 2010 03:41:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
References: <201009010130.41500@zmi.at>
	<20100901000631.GO705@dastard>	<201009010222.57350@zmi.at>
	<20100901031954.GP705@dastard>	<4C7DD99F.7000401@hardwarefreak.com>
	<20100901064439.GR705@dastard>	<4C7F3823.1040404@hardwarefreak.com>
	<20100902070108.GY705@dastard>
In-Reply-To: <20100902070108.GY705@dastard>
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

Dave Chinner put forth on 9/2/2010 2:01 AM:

> No, that's definitely not the case. A different kernel in the 
> same 8p VM, 12x2TB SAS storage, w/ 4 threads, mount options "logbsize=262144"
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      0       800000            0      39554.2          7590355
> 
> 4 threads with mount options "logbsize=262144,delaylog"
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>      0       800000            0      67269.7          5697246

What happens when you bump each of these to 8 threads, 1 per core?  If
the test consumes all cpus/cores, what instrumentation are you viewing
that tells you the cpu utilization _isn't_ due to memory b/w starvation?

A modern 64 bit 2 GHz core from AMD or Intel has an L1 instruction issue
rate of 8 bytes/cycle * 2,000 MHz = 16,000 MB/s = 16 GB/s per core.  An
8 core machine would therefore have an instruction issue rate of 8 * 16
GB/s = 128 GB/s.  A modern dual socket system is going to top out at
24-48 GB/s, well short of the instruction issue rate.  Now, this doesn't
even take the b/w of data load/store operations into account, but I'm
guessing the data size per directory operation is smaller than the total
instruction sequence, which operates on the same variable(s).

So, if the CPUs are pegging, and we're not running out of memory b/w,
then this would lead me to believe that the hot kernel code, core
fs_mark code and the filesystem data are fully, or near fully, contained
in level 2 and 3 CPU caches.  Is this correct, more or less?

> You are free to choose to believe I don't know I'm doing - if you
> can get XFS to perform better, then I'll happily take the patches ;)

Not at all.  I have near total faith in you Dave.  I just like to play
Monday morning quarterback now and then.  It allows me to show my
knuckles drag the ground, and you an opportunity to educate me, and
others, so we can one day walk upright when discussing XFS. ;)

> Did that a long time ago - it's in the archives a few months back.

I'll have to dig around.  I've never even looked for the archives for
this list.  It's hopefully mirrored in the usual places.

Out of curiosity, have you ever run into memory b/w starvation before
peaking all CPUs while running this test?  I could see that maybe
occurring with dual 1GHz+ P3 class systems with their smallish caches
and lowly single channel PC100, back before the switch to DDR memory,
but those machines were probably gone before XFS was open sourced, IIRC,
so you may not have had the pleasure (if you could call it that).

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
