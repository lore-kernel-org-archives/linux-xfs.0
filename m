Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4R076sw258053 for <xfs@oss.sgi.com>; Sat, 26 May 2012 19:07:06 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1bEmEkCcgFi3uF4z for <xfs@oss.sgi.com>;
	Sat, 26 May 2012 17:07:04 -0700 (PDT)
Date: Sun, 27 May 2012 10:07:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: very slow file deletion on an SSD
Message-ID: <20120527000701.GS25351@dastard>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FC16683.9060800@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Sat, May 26, 2012 at 07:25:55PM -0400, Joe Landman wrote:
> [root@siFlash test]# ls -alF  | wc -l
> 59
> [root@siFlash test]# /usr/bin/time rm -f *
> ^C0.00user 8.46system 0:09.55elapsed 88%CPU (0avgtext+0avgdata
> 2384maxresident)k
> 25352inputs+0outputs (0major+179minor)pagefaults 0swaps

It's burning an awful lot of CPU time during this remove.

> [root@siFlash test]# ls -alF  | wc -l
> 48

So, 48 files were removed, it was basically CPU bound and one took
2.6 seconds.

So, how big are the files, and does the one that took 2.6s have tens
of thousands of extents ('xfs_bmap -vp *' will dump the extent maps
for all the files)?

if not, can you use perf top to get an ida of the CPU usage profile
duing the rm by doing:

# perf record rm -f *
.....

and capturing the profile via:

# perf report > profile.txt

And attaching te profile.txt file so we can see where all the CPU
time is being spent? You can find perf in your kernel source tree
under the tools subdir....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
