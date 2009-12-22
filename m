Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBMF7lMF139500 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 09:07:47 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/6] XFS: Convert filestreams code to use per-ag
	get/putroutines
Date: Tue, 22 Dec 2009 09:08:13 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A68BC@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1260857477-2368-4-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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

Dave Chinner wrote:
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good.  I'll add a short one-line explanation at the
top of the patch for you.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/xfs_filestream.c |   19 ++++++++++++-------
>  fs/xfs/xfs_filestream.h |   27 ++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index a631e14..e61f2aa 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c

. . .

> @@ -173,6 +174,7 @@ _xfs_filestream_pick_ag(
>  		/* Keep track of the AG with the most free blocks. */
>  		if (pag->pagf_freeblks > maxfree) {
>  			maxfree = pag->pagf_freeblks;
> +			max_streams = atomic_read(&pag->pagf_fstrms);
>  			max_ag = ag;
>  		}
> 
> @@ -195,6 +197,8 @@ _xfs_filestream_pick_ag(
> 
>  			/* Break out, retaining the reference on the AG. */
>  			free = pag->pagf_freeblks;
> +			streams = atomic_read(&pag->pagf_fstrms);
> +			xfs_perag_put(pag);
>  			*agp = ag;
>  			break;
>  		}
> @@ -202,6 +206,7 @@ _xfs_filestream_pick_ag(
>  		/* Drop the reference on this AG, it's not usable. */
>  		xfs_filestream_put_ag(mp, ag);
>  next_ag:
> +		xfs_perag_put(pag);
>  		/* Move to the next AG, wrapping to AG 0 if necessary. */
>  		if (++ag >= mp->m_sb.sb_agcount)
>  			ag = 0;
> @@ -229,6 +234,7 @@ next_ag:
>  		if (max_ag != NULLAGNUMBER) {
>  			xfs_filestream_get_ag(mp, max_ag);
>  			TRACE_AG_PICK1(mp, max_ag, maxfree);
> +			streams = max_streams;
>  			free = maxfree;
>  			*agp = max_ag;
>  			break;
> @@ -240,8 +246,7 @@ next_ag:
>  		return 0;
>  	}
> 
> -	TRACE_AG_PICK2(mp, startag, *agp, xfs_filestream_peek_ag(mp, *agp),
> -			free, nscan, flags);
> +	TRACE_AG_PICK2(mp, startag, *agp, streams, free, nscan, flags);
> 
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
> index 4aba67c..58378b2 100644
> --- a/fs/xfs/xfs_filestream.h
> +++ b/fs/xfs/xfs_filestream.h
> @@ -79,12 +79,21 @@ extern ktrace_t *xfs_filestreams_trace_buf;
>   * the cache that reference per-ag array elements that have since been
>   * reallocated.
>   */
> +/*
> + * xfs_filestream_peek_ag is only used in tracing code
> + */
>  static inline int
>  xfs_filestream_peek_ag(
>  	xfs_mount_t	*mp,
>  	xfs_agnumber_t	agno)
>  {
> -	return atomic_read(&mp->m_perag[agno].pagf_fstrms);
> +	struct xfs_perag *pag;
> +	int		ret;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	ret = atomic_read(&pag->pagf_fstrms);
> +	xfs_perag_put(pag);
> +	return ret;
>  }
> 
>  static inline int
> @@ -92,7 +101,13 @@ xfs_filestream_get_ag(
>  	xfs_mount_t	*mp,
>  	xfs_agnumber_t	agno)
>  {
> -	return atomic_inc_return(&mp->m_perag[agno].pagf_fstrms);
> +	struct xfs_perag *pag;
> +	int		ret;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	ret = atomic_inc_return(&pag->pagf_fstrms);
> +	xfs_perag_put(pag);
> +	return ret;
>  }
> 
>  static inline int
> @@ -100,7 +115,13 @@ xfs_filestream_put_ag(
>  	xfs_mount_t	*mp,
>  	xfs_agnumber_t	agno)
>  {
> -	return atomic_dec_return(&mp->m_perag[agno].pagf_fstrms);
> +	struct xfs_perag *pag;
> +	int		ret;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	ret = atomic_dec_return(&pag->pagf_fstrms);
> +	xfs_perag_put(pag);
> +	return ret;
>  }
> 
>  /* allocation selection flags */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
