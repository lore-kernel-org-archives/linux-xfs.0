Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BEEE07CAE
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 19:27:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83C038F8039
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 17:27:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZTo72DUYMpcdgzzm for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2016 17:27:10 -0700 (PDT)
Date: Thu, 2 Jun 2016 10:26:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Internal error xfs_trans_cancel
Message-ID: <20160602002653.GL12670@dastard>
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
	<20160601071047.GJ12670@dastard>
	<e80cee4f-1789-5418-ffa8-7551138bda0a@monom.org>
	<0644b434-6cea-4188-9702-469c26d191b8@monom.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0644b434-6cea-4188-9702-469c26d191b8@monom.org>
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
To: Daniel Wagner <wagi@monom.org>
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jun 01, 2016 at 04:13:10PM +0200, Daniel Wagner wrote:
> >> Anything in the log before this?
> > 
> > Just the usual stuff, as I remember. Sorry, I haven't copied the whole log.
> 
> Just triggered it again. My steps for it are:
> 
> - run all lockperf test
> 
>   git://git.samba.org/jlayton/lockperf.git
> 
>   via my test script:
>  
> #!/bin/sh
>
> run_tests () {
.....
> for c in `seq 8 32 128`; do
>     for l in `seq 100 100 500`; do
>         time run_tests "posix01 -n $c -l $l "     $DIR/posix01-$c-$l.data
>         time run_tests "posix02 -n $c -l $l "     $DIR/posix02-$c-$l.data
>         time run_tests "posix03 -n $c -l $l "     $DIR/posix03-$c-$l.data
>         time run_tests "posix04 -n $c -l $l "     $DIR/posix04-$c-$l.data

posix03 and posix04 just emit error messages:

posix04 -n 40 -l 100
posix04: invalid option -- 'l'
posix04: Usage: posix04 [-i iterations] [-n nr_children] [-s] <filename>
.....


So I changed them to run "-i $l" instead, and that has a somewhat
undesired effect:

static void
kill_children()
{
        siginfo_t       infop;

        signal(SIGINT, SIG_IGN);
>>>>>   kill(0, SIGINT);
        while (waitid(P_ALL, 0, &infop, WEXITED) != -1);
}

Yeah, it sends a SIGINT to everything with a process group id. It
kills the parent shell:

$ ./run-lockperf-tests.sh /mnt/scratch/
pid 9597's current affinity list: 0-15
pid 9597's new affinity list: 0,4,8,12
sh: 1: cannot create /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor: Directory nonexistent
posix01 -n 8 -l 100
posix02 -n 8 -l 100
posix03 -n 8 -i 100

$

So, I've just removed those tests from your script. I'll see if I
have any luck with reproducing the problem now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
