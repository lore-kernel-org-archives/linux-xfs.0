Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 180847F51
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 13:22:07 -0500 (CDT)
Date: Tue, 30 Apr 2013 13:22:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/4] xfs: Teach dquot recovery about CONFIG_XFS_QUOTA
Message-ID: <20130430182203.GK29359@sgi.com>
References: <1367321976-18268-1-git-send-email-david@fromorbit.com>
	<1367321976-18268-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367321976-18268-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 30, 2013 at 09:39:33PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fix a build error when CONFIG_XFS_QUOTA=n:
> 
> fs/built-in.o: In function `xlog_recovery_validate_buf_type':
> /home/dave/src/build/x86-64/xfsdev/fs/xfs/xfs_log_recover.c:1948: undefined
> reference to `xfs_dquot_buf_ops'
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied fine this time.  Must have been a PEBKAC.

Reviewed-by: Ben Myers <bpm@sgi.com>



> ---
>  fs/xfs/xfs_log_recover.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 35ac504..ecaa4d4 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1940,12 +1940,18 @@ xlog_recovery_validate_buf_type(
>  	case XFS_BLFT_UDQUOT_BUF:
>  	case XFS_BLFT_PDQUOT_BUF:
>  	case XFS_BLFT_GDQUOT_BUF:
> +#ifdef CONFIG_XFS_QUOTA
>  		if (magic16 != XFS_DQUOT_MAGIC) {
>  			xfs_warn(mp, "Bad DQUOT block magic!");
>  			ASSERT(0);
>  			break;
>  		}
>  		bp->b_ops = &xfs_dquot_buf_ops;
> +#else
> +		xfs_alert(mp,
> +	"Trying to recover dquots without QUOTA support built in!");
> +		ASSERT(0);

Maybe it makes sense for recovery to fail in that case.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
