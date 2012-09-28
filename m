Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S4YkVP174269 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 23:34:46 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XxnqLwKmCNRRqw1L for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 21:36:05 -0700 (PDT)
Date: Fri, 28 Sep 2012 14:36:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 068: Add mmap load
Message-ID: <20120928043602.GD25626@dastard>
References: <50651A99.1070307@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50651A99.1070307@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 27, 2012 at 10:33:45PM -0500, Eric Sandeen wrote:
> Test 068 is the go-to test for freeze deadlock coverage;
> unfortunately it only uses fsstress, which doesn't do any mmap
> IO.
> 
> Using the existing fstest binary gets us a cheap mmap exerciser
> as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I think it's fair to modify this test vs. making a new one -
> it's never passed yet, and will only start passing in kernel 3.6,
> so it shouldn't cause new test regressions to add mmap ops.
> 
> And I can verify that this finds mmap bugs; I had a backport
> which messed up ext4's freeze vs. mmap handling, and this exposes
> it.  :)
> 
> 
> diff --git a/068 b/068
> index 617420c..a0bf425 100755
> --- a/068
> +++ b/068
> @@ -90,6 +90,21 @@ touch $tmp.running
>      rmdir $STRESS_DIR
>  } &
>  
> +# start fstest -m loop in a background block; this gets us mmap coverage
> +{
> +    FSTEST_DIR="$SCRATCH_MNT/fstest_test_dir"
> +    mkdir "$FSTEST_DIR"
> +
> +    procs=2
> +    while [ -f "$tmp.running" ]
> +      do
> +      src/fstest -m -p $FSTEST_DIR  -n $procs -f 4 > /dev/null 2>&1
> +    done
> +
> +    rm -rf $FSTEST_DIR/*
> +    rmdir $FSTEST_DIR
> +} &

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
