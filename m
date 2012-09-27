Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8R0I3nB013312 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 19:18:03 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xZOoBJBJTizmyo2Z for <xfs@oss.sgi.com>;
	Wed, 26 Sep 2012 17:19:21 -0700 (PDT)
Date: Thu, 27 Sep 2012 10:19:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfstest: allow fsstress to use load factor where
	appropriate
Message-ID: <20120927001919.GD15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
	<1348496601-32637-3-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348496601-32637-3-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de, xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 06:23:18PM +0400, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  017 |    5 ++++-
>  068 |    4 ++--
>  070 |    4 +++-
>  076 |    5 ++++-
>  083 |    4 ++--
>  087 |   10 ++++++----
>  104 |    4 ++--
>  114 |    5 +++--
>  167 |    4 ++--
>  232 |    5 +++--
>  233 |    5 +++--
>  269 |    7 ++++---
>  270 |    7 ++++---
>  276 |   11 ++++++-----
>  14 files changed, 48 insertions(+), 32 deletions(-)
> 
> diff --git a/017 b/017
> index 9ca0e72..8d35ee8 100755
> --- a/017
> +++ b/017
> @@ -67,7 +67,10 @@ echo "*** test"
>  for l in 0 1 2 3 4
>  do
>          echo "    *** test $l"
> -        $FSSTRESS_PROG -d $SCRATCH_MNT -n 1000 $FSSTRESS_AVOID >>$seq.full
> +	NUM=$((1000 * TIME_FACTOR))

$TIME_FACTOR, perhaps?

> +	CPU=$((1 * LOAD_FACTOR))
> +        $FSSTRESS_PROG -d $SCRATCH_MNT -n $NUM -p $CPU \
> +	    $FSSTRESS_AVOID >>$seq.full

I'd much prefer a wrapper around fsstress than have to code this
into every test. Something like:

run_fstress()
{
	args=""

	while [ $# -gt 0 ]; do
		case "$1" in
		-n) args="$args $1 $(($2 * $TIME_FACTOR))"; shift ;;
		-p) args="$args $1 $(($2 * $LOAD_FACTOR))"; shift ;;
		*) args="$args $1" ;;
		esac

		shift
	done

	$FSSTRESS_PROG $args
}

And so all you need to do is something like:

$ sed -i 's/\$FSSTRESS_PROG/run_fsstress/' [0-9][0-9][0-9]

To convert all tests that use fsstress to do this.

You might also want to do this for the tests that run dirstress as
well, and create a "stress" group so that you can run just
the stress tests easily....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
