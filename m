Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99Jbgk5093292 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 14:37:42 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gQhrAZIMz1EzYCrM for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 12:39:11 -0700 (PDT)
Date: Wed, 10 Oct 2012 06:39:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
Message-ID: <20121009193908.GI23644@dastard>
References: <1349784945-28399-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349784945-28399-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 09, 2012 at 02:15:45PM +0200, Lukas Czerner wrote:
> Currently if len argument in xfs_ioc_trim() is smaller than one BB
> (basic block) the 'end' variable underflow. Avoid that by bailing out if
> len is smaller than BB.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/xfs/xfs_discard.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 69cf4fc..54dc58a 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -183,8 +183,12 @@ xfs_ioc_trim(
>  	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
>  		return -XFS_ERROR(EINVAL);
>  
> +	end = BTOBBT(range.len);
> +	if (0 == end)
> +		goto out;

Uggh. "if (end == 0)", please.
> +
>  	start = BTOBB(range.start);
> -	end = start + BTOBBT(range.len) - 1;
> +	end += start - 1;

Better would be to check if end <= start. That way it also catches
start+len overflows.


>  	minlen = BTOBB(max_t(u64, granularity, range.minlen));
>  
>  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> @@ -203,6 +207,7 @@ xfs_ioc_trim(
>  	if (last_error)
>  		return last_error;
>  
> +out:
>  	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
>  	if (copy_to_user(urange, &range, sizeof(range)))
>  		return -XFS_ERROR(EFAULT);

I think it should return EINVAL, not silently do nothing. If the
user application uses a loop that increments start/len based on the
returned amount of blocks trimmed, returning zero could send it into
an endless loop.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
