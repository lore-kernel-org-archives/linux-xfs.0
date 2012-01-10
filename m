Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AM2xGR100020 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 16:02:59 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fEDksgByFhPbZcgG for <xfs@oss.sgi.com>;
	Tue, 10 Jan 2012 14:02:45 -0800 (PST)
Date: Wed, 11 Jan 2012 09:02:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 273: Create lost+found to pass _check_scratch_fs
Message-ID: <20120110220242.GB24410@dastard>
References: <1326213469-22687-1-git-send-email-guaneryu@gmail.com>
	<1326213469-22687-2-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326213469-22687-2-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 11, 2012 at 12:37:49AM +0800, Eryu Guan wrote:
> fsck.extN will complain lost+found is missing and fail 273.
> So create lost+found explicitly after removing everything in
> $SCRATCH_MNT.

I'd consider that a bug in e2fsck. Other filesystems handle missing
lost+found directories without failing, but then again it's only
these new tests that do this so fixing the tests is probably the
right thing to do here.

> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  273 |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/273 b/273
> index 2965132..9ecb2d3 100755
> --- a/273
> +++ b/273
> @@ -36,6 +36,7 @@ _cleanup()
>  {
>  	cd /
>  	rm -rf $SCRATCH_MNT/* $tmp.*
> +	mkdir -p $SCRATCH_MNT/lost+found
>  	_scratch_unmount
>  }

We shouldn't be removing files from the scratch device  in the
_cleanup function - if the test exits or fails, we need the corpse
to be intact for debugging. Remving $SCRATCH_MNT/* from the rm
command is what should be done here.

>  
> @@ -107,6 +108,7 @@ _do_workload()
>  	_pid=1
>  	
>  	rm -rf $SCRATCH_MNT/*
> +	mkdir -p $SCRATCH_MNT/lost+found

And rather than doing this, the test should put all it's files in a
known location on the $SCRATCH_MNT and just remove that. e.g:

WORK_DIR="$SCRATCH_MNT/$seq"

....

	rm -rf $WORKDIR

....

The same fixes are required for 274 and 275 as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
