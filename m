Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 896887CA7
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 00:23:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E2EEAC001
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 22:23:29 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id opuXSBUBPokupGw6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 22:23:26 -0700 (PDT)
Subject: Re: Internal error xfs_trans_cancel
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
	<20160601071047.GJ12670@dastard>
	<e80cee4f-1789-5418-ffa8-7551138bda0a@monom.org>
	<0644b434-6cea-4188-9702-469c26d191b8@monom.org>
	<20160602002653.GL12670@dastard>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <af997005-e144-5509-885c-a688562ea3ec@monom.org>
Date: Thu, 2 Jun 2016 07:23:24 +0200
MIME-Version: 1.0
In-Reply-To: <20160602002653.GL12670@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

> posix03 and posix04 just emit error messages:
> 
> posix04 -n 40 -l 100
> posix04: invalid option -- 'l'
> posix04: Usage: posix04 [-i iterations] [-n nr_children] [-s] <filename>
> .....

I screwed that this up. I have patched my version of lockperf to make
all test using the same options names. Though forgot to send those
patches. Will do now.

In this case you can use use '-i' instead of '-l'.

> So I changed them to run "-i $l" instead, and that has a somewhat
> undesired effect:
> 
> static void
> kill_children()
> {
>         siginfo_t       infop;
> 
>         signal(SIGINT, SIG_IGN);
>>>>>>   kill(0, SIGINT);
>         while (waitid(P_ALL, 0, &infop, WEXITED) != -1);
> }
> 
> Yeah, it sends a SIGINT to everything with a process group id. It
> kills the parent shell:

Ah that rings a bell. I tuned the parameters so that I did not run into
this problem. I'll do patch for this one. It's pretty annoying.

> $ ./run-lockperf-tests.sh /mnt/scratch/
> pid 9597's current affinity list: 0-15
> pid 9597's new affinity list: 0,4,8,12
> sh: 1: cannot create /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor: Directory nonexistent
> posix01 -n 8 -l 100
> posix02 -n 8 -l 100
> posix03 -n 8 -i 100
> 
> $
> 
> So, I've just removed those tests from your script. I'll see if I
> have any luck with reproducing the problem now.

I was able to reproduce it again with the same steps.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
