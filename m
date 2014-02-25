Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 256797F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:32:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 026E5304077
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:32:02 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jhwNGlOACxmXRue0 for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 12:32:01 -0800 (PST)
Date: Wed, 26 Feb 2014 07:31:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfstests: Add fallocate zero range operation to fsx
Message-ID: <20140225203158.GB13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-4-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355728-12056-4-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 08:15:26PM +0100, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

commit message?

>  #define OP_CLOSEOPEN	100
> @@ -142,6 +144,7 @@ int	seed = 1;			/* -S flag */
>  int     mapped_writes = 1;              /* -W flag disables */
>  int     fallocate_calls = 1;            /* -F flag disables */
>  int     punch_hole_calls = 1;           /* -H flag disables */
> +int     zero_range_calls = 1;           /* -E flag disables */

'-E' doesn't make much sense - '-z' would be better....

>  int 	mapped_reads = 1;		/* -R flag disables it */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */
> @@ -320,6 +323,14 @@ logdump(void)
>  						     lp->args[0] + lp->args[1])
>  				prt("\t******PPPP");
>  			break;
> +		case OP_ZERO_RANGE:
> +			prt("ZERO    0x%x thru 0x%x\t(0x%x bytes)",
> +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> +			    lp->args[1]);
> +			if (badoff >= lp->args[0] && badoff <
> +						     lp->args[0] + lp->args[1])
> +				prt("\t******ZZZZ");
> +			break;
>  		case OP_SKIPPED:
>  			prt("SKIPPED (no operation)");
>  			break;
> @@ -882,6 +893,64 @@ do_punch_hole(unsigned offset, unsigned length)
>  }
>  #endif
>  
> +#ifdef FALLOC_FL_ZERO_RANGE
> +void
> +do_zero_range(unsigned offset, unsigned length)
> +{
> +	unsigned end_offset;
> +	int max_offset = 0;
> +	int max_len = 0;
> +	int mode = FALLOC_FL_ZERO_RANGE;

This is just a copy of the hole punch code with a different mode,
OP and s/punch/zero/g. Please factor.

......
> +void
> +test_zero_range()
> +{
> +#ifdef FALLOC_FL_ZERO_RANGE
> +	if (!lite && zero_range_calls) {
> +		if (fallocate(fd, FALLOC_FL_ZERO_RANGE,
> +				0, 1) && errno == EOPNOTSUPP) {
> +			if(!quiet)
> +				warn("main: filesystem does not support fallocate zero range, disabling");
> +			zero_range_calls = 0;
> +		} else
> +			ftruncate(fd, 0);
> +	}
> +#else /* ! ZERO RANGE */
> +	zero_range_calls = 0;
> +#endif
> +}

Third copy of this test code for fallocate. Please factor.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
