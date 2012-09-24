Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8O7Ow78110848 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 02:24:58 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uK6GMnFi6Cira3LK for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 00:26:13 -0700 (PDT)
Date: Mon, 24 Sep 2012 17:26:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_space_left: head behind tail ?
Message-ID: <20120924072600.GE20960@dastard>
References: <CAJzjPKm+g9g7qQrvQr+Jy2Gjbj5NZpRY2LyfMQQCi519uqGx=g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJzjPKm+g9g7qQrvQr+Jy2Gjbj5NZpRY2LyfMQQCi519uqGx=g@mail.gmail.com>
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
To: Gregory Machin <gdm@linuxpro.co.za>
Cc: xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 04:49:43PM +1200, Gregory Machin wrote:
> Hi.
> 
> Since I started using Acronis backup software I have the following in my logs :

What kernel?

> Sep 22 18:00:16 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
> Sep 22 18:00:16 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26561024
> Sep 22 18:00:16 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26540592

20,432 bytes behind.

...
> Sep 22 18:01:03 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
> Sep 22 18:01:03 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26564096
> Sep 22 18:01:03 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26543656

And that's 20440 bytes behind. So, an 8 byte leak - sounds rather
familiar:

$ gl -n 1 3948659
commit 3948659e30808fbaa7673bbe89de2ae9769e20a7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Mar 22 05:15:11 2012 +0000

    xfs: Account log unmount transaction correctly
    
    There have been a few reports of this warning appearing recently:
    
    XFS (dm-4): xlog_space_left: head behind tail
     tail_cycle = 129, tail_bytes = 20163072
     GH   cycle = 129, GH   bytes = 20162880
    
    The common cause appears to be lots of freeze and unfreeze cycles,
    and the output from the warnings indicates that we are leaking
    around 8 bytes of log space per freeze/unfreeze cycle.
    
    When we freeze the filesystem, we write an unmount record and that
    uses xlog_write directly - a special type of transaction,
    effectively. What it doesn't do, however, is correctly account for
    the log space it uses. The unmount record writes an 8 byte structure
    with a special magic number into the log, and the space this
    consumes is not accounted for in the log ticket tracking the
    operation. Hence we leak 8 bytes every unmount record that is
    written.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>
$ git describe --contains 3948659
v3.4-rc1~55^2~3

So, fixed in 3.4.

FWIW, this commit is in the series I proposed recently for back
porting to 3.0.x stable kernel.

....

> Sep 22 20:17:54 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
                                          ^^^^
> Sep 22 20:17:54 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 489472
> Sep 22 20:17:54 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 468080
> Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
                                          ^^^^^^^^^
> detected. Unmount and run xfs_repair

Note the different device names the errors are for? So the log space
warnings are from different filesystems to the one that corruption
has been found on. IOWs, unrelated.

> I want to be sure before I start pointing fingures and asking
> questions as to why I'm seeing the first lot of logs

Acronis is freezing/thawing the filesystem to get a consistent
backup image, hence triggering the problem.

> and what else
> could have cause the 2nd ?

Don't know. There's no stack trace in the error message, so I don't
even know where it came from. have you modified the xfs_error_level
sysctl to turn off verbose reporting?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
