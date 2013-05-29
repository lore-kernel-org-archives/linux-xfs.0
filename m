Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F12329DF8
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 14:01:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9590AC00E
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 12:01:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lfzisz646uYgdFqI for
	<xfs@oss.sgi.com>; Wed, 29 May 2013 12:01:22 -0700 (PDT)
Message-ID: <51A64FD3.8000606@redhat.com>
Date: Wed, 29 May 2013 14:58:27 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/9] xfs: rework dquot CRCs
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-5-git-send-email-david@fromorbit.com>
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

On 05/27/2013 02:38 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Calculating dquot CRCs when the backing buffer is written back just
> doesn't work reliably. There are several places which manipulate
> dquots directly in the buffers, and they don't calculate CRCs
> appropriately, nor do they always set the buffer up to calculate
> CRCs appropriately.
> 
> Firstly, if we log a dquot buffer (e.g. during allocation) it gets
> logged without valid CRC, and so on recovery we end up with a dquot
> that is not valid.
> 
> Secondly, if we recover/repair a dquot, we don't have a verifier
> attached to the buffer and hence CRCs arenot calculate don the way
> down to disk.
> 
> Thirdly, calculating the CRC after we've changed the contents means
> that if we re-read the dquot from the buffer, we cannot verify the
> contents of the dquot are valid, as the CRC is invalid.
> 
> So, to avoid all the dquot CRC errors that are being detected by the
> read verifier, change to using the same model as for inodes. that
> is, dquot CRCs are calculated and written to the backing buffer at
> the time the dquot is flushed to the backing buffer. If we modify
> the dquuot directly in the backing buffer, calculate the CRC
> immediately after the modification is complete. Hence the dquot in
> the on-disk buffer should always have a valid CRC.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_dquot.c       |   37 ++++++++++++++++---------------------
>  fs/xfs/xfs_log_recover.c |   10 ++++++++++
>  fs/xfs/xfs_qm.c          |   36 ++++++++++++++++++++++++++----------
>  fs/xfs/xfs_quota.h       |    2 ++
>  4 files changed, 54 insertions(+), 31 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index f41702b..d181542 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -41,6 +41,7 @@
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> +#include "xfs_cksum.h"
>  
>  /*
>   * The global quota manager. There is only one of these for the entire
> @@ -839,7 +840,7 @@ xfs_qm_reset_dqcounts(
>  	xfs_dqid_t	id,
>  	uint		type)
>  {
> -	xfs_disk_dquot_t	*ddq;
> +	struct xfs_dqblk	*dqb;
>  	int			j;
>  
>  	trace_xfs_reset_dqcounts(bp, _RET_IP_);
> @@ -853,8 +854,12 @@ xfs_qm_reset_dqcounts(
>  	do_div(j, sizeof(xfs_dqblk_t));
>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
>  #endif
> -	ddq = bp->b_addr;
> +	dqb = bp->b_addr;
>  	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
> +		struct xfs_disk_dquot	*ddq;
> +
> +		ddq =  (struct xfs_disk_dquot *)&dqb[j];
> +
>  		/*
>  		 * Do a sanity check, and if needed, repair the dqblk. Don't
>  		 * output any warnings because it's perfectly possible to
> @@ -871,7 +876,8 @@ xfs_qm_reset_dqcounts(
>  		ddq->d_bwarns = 0;
>  		ddq->d_iwarns = 0;
>  		ddq->d_rtbwarns = 0;
> -		ddq = (xfs_disk_dquot_t *) ((xfs_dqblk_t *)ddq + 1);
> +		xfs_update_cksum((char *)&dqb[j], sizeof(struct xfs_dqblk),
> +					 XFS_DQUOT_CRC_OFF);

Nice cleanup on the cast ugliness even without the crc change. Is there
a technical reason for the unconditional crc update here beyond that
we're doing a reset? I'm wondering if there's any value in leaving those
bits untouched for a filesystem that might have never enabled crc
(quotacheck or not).

FWIW, the rest of this patch looks sane to me (I'm less familiar with
the log recovery code, but the changes seem isolated and
straightforward) and I couldn't locate anywhere else we modify the
backing buffer for the dquot.

Brian

>  	}
>  }
>  
> @@ -907,19 +913,29 @@ xfs_qm_dqiter_bufs(
>  			      XFS_FSB_TO_DADDR(mp, bno),
>  			      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
>  			      &xfs_dquot_buf_ops);
> -		if (error)
> -			break;
>  
>  		/*
> -		 * XXX(hch): need to figure out if it makes sense to validate
> -		 *	     the CRC here.
> +		 * CRC and validation errors will return a EFSCORRUPTED here. If
> +		 * this occurs, re-read without CRC validation so that we can
> +		 * repair the damage via xfs_qm_reset_dqcounts(). This process
> +		 * will leave a trace in the log indicating corruption has
> +		 * been detected.
>  		 */
> +		if (error == EFSCORRUPTED) {
> +			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> +				      XFS_FSB_TO_DADDR(mp, bno),
> +				      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> +				      NULL);
> +		}
> +
> +		if (error)
> +			break;
> +
>  		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
>  		xfs_buf_delwri_queue(bp, buffer_list);
>  		xfs_buf_relse(bp);
> -		/*
> -		 * goto the next block.
> -		 */
> +
> +		/* goto the next block. */
>  		bno++;
>  		firstid += mp->m_quotainfo->qi_dqperchunk;
>  	}
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index c61e31c..c38068f 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -87,6 +87,8 @@ typedef struct xfs_dqblk {
>  	uuid_t		  dd_uuid;	/* location information */
>  } xfs_dqblk_t;
>  
> +#define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
> +
>  /*
>   * flags for q_flags field in the dquot.
>   */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
