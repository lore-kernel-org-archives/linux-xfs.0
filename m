Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RKjMEU140873 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 15:45:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 149441B9C725
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 13:45:20 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id EVn6cx1KMj3YAWLK for <xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 13:45:20 -0700 (PDT)
Message-ID: <4E08EBDF.40904@sandeen.net>
Date: Mon, 27 Jun 2011 15:45:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfstests: fix fsx fpunch test to actually test for
	fpunch
References: <1309153722-1231-1-git-send-email-david@fromorbit.com>
	<1309153722-1231-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1309153722-1231-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 6/27/11 12:48 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The operation flags parameter to fallocate is the second parameter,
> not the last. Hence the fpunch test is actually testing for falloc
> support, not fpunch. Somebody needs a brown paper bag.
> 
> Also, add a ftruncate call whenthe fpunch succeeds just in case the
> file was not already zero sized. Failing to ensure we start with a
> zero length file can cause read ops to fail size checks if they
> occur before the file is written to be the main test loop.
> 
> While there, observe the quiet flag the same as the falloc test
> does and have them both emit the warning at the same error level.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  ltp/fsx.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 0683853..a37e223 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -1243,7 +1243,7 @@ test_fallocate()
>  	if (!lite && fallocate_calls) {
>  		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
>  			if(!quiet)
> -				prt("fsx: main: filesystem does not support fallocate, disabling\n");
> +				warn("main: filesystem does not support fallocate, disabling\n");
>  			fallocate_calls = 0;
>  		} else {
>  			ftruncate(fd, 0);
> @@ -1260,13 +1260,13 @@ test_punch_hole()
>  {
>  #ifdef FALLOC_FL_PUNCH_HOLE
>  	if (!lite && punch_hole_calls) {
> -		if (fallocate(fd, 0, 0,
> -			FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE) &&
> -			errno == EOPNOTSUPP) {
> -
> -			warn("main: filesystem does not support fallocate punch hole, disabling");
> +		if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +				0, 1) && errno == EOPNOTSUPP) {
> +			if(!quiet)
> +				warn("main: filesystem does not support fallocate punch hole, disabling");
>  			punch_hole_calls = 0;
> -		}
> +		} else
> +			ftruncate(fd, 0);
>  	}
>  #else /* ! PUNCH HOLE */
>  	punch_hole_calls = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
