Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2FC17F5D
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 19:00:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7EB60304059
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 17:00:37 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BjNFNNor67SMPm43 for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 17:00:35 -0800 (PST)
Date: Tue, 17 Feb 2015 12:00:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 11/12] xfstests: fsx: Add fallocate insert range
	operation
Message-ID: <20150217010033.GG4251@dastard>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
	<1424101680-3301-12-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424101680-3301-12-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Feb 17, 2015 at 12:47:58AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This commit adds fallocate FALLOC_FL_INSERT_RANGE support for fsx.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  ltp/fsx.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 114 insertions(+), 10 deletions(-)
.....
> @@ -339,6 +341,14 @@ logdump(void)
>  						     lp->args[0] + lp->args[1])
>  				prt("\t******CCCC");
>  			break;
> +		case OP_INSERT_RANGE:
> +			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
> +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> +			    lp->args[1]);
> +			if (badoff >= lp->args[0] && badoff <
> +						     lp->args[0] + lp->args[1])
> +				prt("\t******CCCC");

Probably should output "*****IIII" so we can distinguish it from
collapse operations easily.

> @@ -1307,6 +1403,9 @@ usage(void)
>  #ifdef FALLOC_FL_COLLAPSE_RANGE
>  "	-C: Do not use collapse range calls\n"
>  #endif
> +#ifdef FALLOC_FL_INSERT_RANGE
> +"	-i: Do not use insert range calls\n"
> +#endif

I'd make that "-I" rather than "-i" so it matches with the "-C" of
collapse range.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
