Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83F4B7F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:03:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71E6D304032
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:03:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id avz0DpXiNG9mUjnW for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 21:03:40 -0700 (PDT)
Message-ID: <54506719.5080008@sandeen.net>
Date: Tue, 28 Oct 2014 23:03:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] repair: fix XR_BLD_FREE_TRACE compilation errors
References: <1414552144-12627-1-git-send-email-david@fromorbit.com>
	<1414552144-12627-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1414552144-12627-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: bvowk@box.com

On 10/28/14 10:09 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Obviously hasn't been used for quite some time, so fix the
> build problems and make it useful again.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/phase5.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index e82eeb7..d6d3c6d 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -362,10 +362,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	extent_tree_node_t	*ext_ptr;
>  	int			level;
>  #ifdef XR_BLD_FREE_TRACE
> -	int			old_state;
> -	int			state = XR_E_BAD_STATE;
> -#endif
> -#ifdef XR_BLD_FREE_TRACE
>  	fprintf(stderr,
>  		"in init_freespace_cursor, agno = %d\n", agno);
>  #endif
> @@ -1292,8 +1288,8 @@ build_agf_agfl(xfs_mount_t	*mp,
>  	memset(agf, 0, mp->m_sb.sb_sectsize);
>  
>  #ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "agf = 0x%x, agf_buf->b_un.b_addr = 0x%x\n",
> -		(__psint_t) agf, (__psint_t) agf_buf->b_un.b_addr);
> +	fprintf(stderr, "agf = 0x%p, agf_buf->b_addr = 0x%p\n",
> +		agf, agf_buf->b_addr);
>  #endif
>  
>  	/*
> @@ -1452,7 +1448,7 @@ build_agf_agfl(xfs_mount_t	*mp,
>  	}
>  
>  #ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "wrote agf for ag %u, error = %d\n", agno, error);
> +	fprintf(stderr, "wrote agf for ag %u\n", agno);
>  #endif
>  }
>  
> @@ -1707,11 +1703,10 @@ phase5(xfs_mount_t *mp)
>  #ifdef XR_BLD_FREE_TRACE
>  	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
>  		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
> -		xfs_inobt_maxrecs(mp->m_sb.sb_blocksize, 0) / 2
> -		);
> +		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
>  	fprintf(stderr, "inobt level 0 (leaf), maxrec = %d, minrec = %d\n",
> -		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, xfs_inobt, 1),
> -		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, xfs_inobt, 1) / 2);
> +		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
> +		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
>  	fprintf(stderr, "xr inobt level 0 (leaf), maxrec = %d\n",
>  		XR_INOBT_BLOCK_MAXRECS(mp, 0));
>  	fprintf(stderr, "xr inobt level 1 (int), maxrec = %d\n",
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
