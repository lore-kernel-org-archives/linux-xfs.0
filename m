Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48HMQUB224435 for <xfs@oss.sgi.com>; Tue, 8 May 2012 12:22:27 -0500
Date: Tue, 8 May 2012 12:26:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/3] xfs: don't assert on delalloc regions beyond EOF
Message-ID: <20120508172612.GL16881@sgi.com>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<20120429111617.GS9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429111617.GS9541@dastard>
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

On Sun, Apr 29, 2012 at 09:16:17PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we are doing speculative delayed allocation beyond EOF,
> conversion of the region allocated beyond EOF is dependent on the
> largest free space extent available. If the largest free extent is
> smaller than the delalloc range, then after allocation we leave
> a delalloc extent that starts beyond EOF. This extent cannot *ever*
> be converted by flushing data, and so will remain there until either
> the EOF moves into the extent or it is truncated away.
> 
> Hence if xfs_getbmap() runs on such an inode and is asked to return
> extents beyond EOF, it will assert fail on this extent even though
> there is nothing xfs_getbmap() can do to convert it to a real
> extent. Hence we should simply report these delalloc extents rather
> than assert that there should be none.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 26ab256..478bce9 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -5620,8 +5620,20 @@ xfs_getbmap(
>  				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
>  			out[cur_ext].bmv_unused1 = 0;
>  			out[cur_ext].bmv_unused2 = 0;
> -			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
> -			      (map[i].br_startblock != DELAYSTARTBLOCK));
> +
> +			/*
> +			 * delayed allocation extents that start beyond EOF can
> +			 * occur due to speculative EOF allocation when the
> +			 * delalloc extent is larger than the largest freespace
> +			 * extent at conversion time. These extents cannot be
> +			 * converted by data writeback, so can exist here even
> +			 * if we are not supposed to be finding delalloc
> +			 * extents.
> +			 */
> +			if (map[i].br_startblock == DELAYSTARTBLOCK &&
> +			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
> +				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
> +

Looks fine.  This assert will no longer kick off for delay extents after eof,
but will still catch any within the file.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
