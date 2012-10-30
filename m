Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WU061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:19 -0500
Date: Mon, 29 Oct 2012 17:51:28 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 06/25] xfs: verify AGF blocks as they are read from disk
Message-ID: <20121030005128.GH30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-7-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:33:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add an AGF block verify callback function and pass it into the
> buffer read functions. This replaces the existing verification that
> is done after the read completes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_alloc.c |   60 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 34 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 21c3db0..bd565a2 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -2091,6 +2091,39 @@ xfs_alloc_put_freelist(
>  	return 0;
>  }
>  
> +static void
> +xfs_agf_read_verify(
> +	struct xfs_buf	*bp)
> + {
> +	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	struct xfs_agf	*agf;
> +	int		agf_ok;
> +
> +	agf = XFS_BUF_TO_AGF(bp);
> +
> +	agf_ok = agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
> +		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
> +		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
> +		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
> +		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
> +		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp) &&
> +		be32_to_cpu(agf->agf_seqno) == bp->b_pag->pag_agno;
> +
> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
> +						be32_to_cpu(agf->agf_length);
> +
> +	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
> +			XFS_RANDOM_ALLOC_READ_AGF))) {
> +		XFS_CORRUPTION_ERROR("xfs_alloc_read_agf",
> +				     XFS_ERRLEVEL_LOW, mp, agf);
> +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +	}

Shouldn't this be XFS_CORRUPTION_ERROR("xfs_agf_read_verify", ...) ?

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
