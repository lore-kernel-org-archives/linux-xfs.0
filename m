Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48HxBvK235606 for <xfs@oss.sgi.com>; Tue, 8 May 2012 12:59:12 -0500
Date: Tue, 8 May 2012 13:02:56 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/3] xfs: limit specualtive delalloc to maxioffset
Message-ID: <20120508180256.GM16881@sgi.com>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<20120429124319.GT9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429124319.GT9541@dastard>
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

On Sun, Apr 29, 2012 at 10:43:19PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Speculative delayed allocation beyond EOF near the maximum supported
> file offset can result in creating delalloc extents beyond
> mp->m_maxioffset (8EB). These can never be trimmed during
> xfs_free_eof_blocks() because they are beyond mp->m_maxioffset, and
> that results in assert failures in xfs_fs_destroy_inode() due to
> delalloc blocks still being present. xfstests 071 exposes this
> problem.
> 
> Limit speculative delalloc to mp->m_maxioffset to avoid this
> problem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iomap.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 303c03a..4a08ea3 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -412,6 +412,15 @@ retry:
>  			return error;
>  	}
>  
> +	/*
> +	 * Make sure preallocation does not create extents beyond the range we
> +	 * actually support in this filesystem.
> +	 */
> +	if (last_fsb > XFS_B_TO_FSB(mp, mp->m_maxioffset))
> +		last_fsb = XFS_B_TO_FSB(mp, mp->m_maxioffset);
> +
> +	ASSERT(last_fsb > offset_fsb);
> +

Yeah, looks good.  xfs_iomap_prealloc_size isn't the only one who can push us
up above m_maxioffset, so this is the right place for the check.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
