Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E0hwAm107546 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 19:43:58 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7605EBAB44
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 17:43:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zzYewVUeQMmM2Rbj for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 17:43:54 -0700 (PDT)
Date: Thu, 14 Jul 2011 10:43:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Trying xfstest 075 and 112, both are failing
Message-ID: <20110714004350.GA23038@dastard>
References: <CAGpXXZLvvP+idqxCb8a5r1pkO9WhQcjVKGQeK+MGQp-dAp0Ztw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGpXXZLvvP+idqxCb8a5r1pkO9WhQcjVKGQeK+MGQp-dAp0Ztw@mail.gmail.com>
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
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 13, 2011 at 04:28:00PM -0400, Greg Freemyer wrote:
> All,
> 
> I'm trying to get xfstests running in my setup for the first time in years.
> 
> I've trying with a btrfs test partition.
> 
> ./check mostly runs, but 3 tests are failing: 075, 112, and 127
> 
> 075 and 112 look like very basic errors in the 075.out info.  Makes me
> wonder if they work for anyone with a current git pull.
> 
> ==== example failure of test 075
> # ./check 075
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 tiger3-64bit 2.6.39.2-36-default
> MKFS_OPTIONS  -- /dev/sda1
> MOUNT_OPTIONS -- /dev/sda1 /xfstests_mnt_scratch
> 
> 075 11s ... [failed, exit status 1] - output mismatch (see 075.out.bad)
> --- 075.out     2011-06-30 18:41:17.000000000 -0400
> +++ 075.out.bad 2011-07-13 16:25:55.000000000 -0400
> @@ -4,15 +4,4 @@
>  -----------------------------------------------
>  fsx.0 : -d -N numops -S 0
>  -----------------------------------------------
> -
> ------------------------------------------------
> -fsx.1 : -d -N numops -S 0 -x
> ------------------------------------------------
> -
> ------------------------------------------------
> -fsx.2 : -d -N numops -l filelen -S 0
> ------------------------------------------------
> -
> ------------------------------------------------
> -fsx.3 : -d -N numops -l filelen -S 0 -x
> ------------------------------------------------
> +    fsx (-d -N 1000 -S 0) failed, 0 - compare 075.0.{good,bad,fsxlog}
> Ran: 075
> Failures: 075
> Failed 1 of 1 tests
> ===

Nothing wrong with the test at all. That's telling you that btrfs
failed the fsx test run. i.e. that there is a problem with btrfs
that needs to be fixed.

> (by chance, I also documented what I was doing in the openSUSE wiki,
> so you can see the exact steps at;
> http://en.opensuse.org/SDB:XFStests)

You probably should be pulling the -dev versions of the trees hosted
on git.kernel.org rather than the ones from oss.sgi.com.

And you want to be running the auto test group, not all tests as
some of the tests are broken or require specific environments to run
in or take a long, long time to run. Instead, you should be using
"./check -g auto" by default.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
