Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbfBATAq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 14:00:46 -0500
Date: Fri, 1 Feb 2019 14:00:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/8] xfs: refactor AGI unlinked bucket updates
Message-ID: <20190201190042.GB31203@bfoster>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897668914.26065.4021602625860113731.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897668914.26065.4021602625860113731.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 03:18:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Split the AGI unlinked bucket updates into a separate function.  No
> functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   69 ++++++++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_trace.h |   26 ++++++++++++++++++++
>  2 files changed, 76 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 98355f5f9253..3c33136b21ef 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1880,6 +1880,46 @@ xfs_inactive(
>  	xfs_qm_dqdetach(ip);
>  }
>  
> +/*
> + * Point the AGI unlinked bucket at an inode and log the results.  The caller
> + * is responsible for validating the old value.
> + */
> +STATIC int
> +xfs_iunlink_update_bucket(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
> +	unsigned int		bucket_index,
> +	xfs_agino_t		new_agino)
> +{
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agibp);
> +	xfs_agino_t		old_value;
> +	int			offset;
> +
> +	ASSERT(new_agino == NULLAGINO ||
> +	       xfs_verify_agino(tp->t_mountp, be32_to_cpu(agi->agi_seqno),
> +				new_agino));
> +
> +	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	trace_xfs_iunlink_update_bucket(tp->t_mountp,
> +			be32_to_cpu(agi->agi_seqno), bucket_index, old_value,
> +			new_agino);
> +

Might as well pass agno as a param, particularly since the callers
already have it.

> +	/*
> +	 * We should never find the head of the list already set to the value
> +	 * passed in because either we're adding or removing ourselves from the
> +	 * head of the list.
> +	 */
> +	if (old_value == new_agino)
> +		return -EFSCORRUPTED;
> +

This seems a little weird in the NULLAGINO case. That probably should
still never happen, but doesn't seem indicative of corruption on its
own. *shrug* not a big deal.

Brian

> +	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
> +	offset = offsetof(struct xfs_agi, agi_unlinked) +
> +			(sizeof(xfs_agino_t) * bucket_index);
> +	xfs_trans_log_buf(tp, agibp, offset,
> +			(offset + sizeof(xfs_agino_t) - 1));
> +	return 0;
> +}
> +
>  /*
>   * This is called when the inode's link count goes to 0 or we are creating a
>   * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
> @@ -1958,15 +1998,10 @@ xfs_iunlink(
>  		xfs_inobp_check(mp, ibp);
>  	}
>  
> -	/*
> -	 * Point the bucket head pointer at the inode being inserted.
> -	 */
> -	ASSERT(agino != 0);
> -	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
> -	offset = offsetof(xfs_agi_t, agi_unlinked) +
> -		(sizeof(xfs_agino_t) * bucket_index);
> -	xfs_trans_log_buf(tp, agibp, offset,
> -			  (offset + sizeof(xfs_agino_t) - 1));
> +	/* Point the head of the list to point to this inode. */
> +	error = xfs_iunlink_update_bucket(tp, agibp, bucket_index, agino);
> +	if (error)
> +		goto out_unlock;
>  	pag->pagi_unlinked_count++;
>  
>  out_unlock:
> @@ -2062,16 +2097,12 @@ xfs_iunlink_remove(
>  		} else {
>  			xfs_trans_brelse(tp, ibp);
>  		}
> -		/*
> -		 * Point the bucket head pointer at the next inode.
> -		 */
> -		ASSERT(next_agino != 0);
> -		ASSERT(next_agino != agino);
> -		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
> -		offset = offsetof(xfs_agi_t, agi_unlinked) +
> -			(sizeof(xfs_agino_t) * bucket_index);
> -		xfs_trans_log_buf(tp, agibp, offset,
> -				  (offset + sizeof(xfs_agino_t) - 1));
> +
> +		/* Point the head of the list to the next unlinked inode. */
> +		error = xfs_iunlink_update_bucket(tp, agibp, bucket_index,
> +				next_agino);
> +		if (error)
> +			goto out_unlock;
>  	} else {
>  		/*
>  		 * We need to search the list for the inode being freed.
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 6fcc893dfc91..c10478e7e49a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3371,6 +3371,32 @@ DEFINE_TRANS_EVENT(xfs_trans_roll);
>  DEFINE_TRANS_EVENT(xfs_trans_add_item);
>  DEFINE_TRANS_EVENT(xfs_trans_free_items);
>  
> +TRACE_EVENT(xfs_iunlink_update_bucket,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int bucket,
> +		 xfs_agino_t old_ptr, xfs_agino_t new_ptr),
> +	TP_ARGS(mp, agno, bucket, old_ptr, new_ptr),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(unsigned int, bucket)
> +		__field(xfs_agino_t, old_ptr)
> +		__field(xfs_agino_t, new_ptr)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->bucket = bucket;
> +		__entry->old_ptr = old_ptr;
> +		__entry->new_ptr = new_ptr;
> +	),
> +	TP_printk("dev %d:%d agno %u bucket %u old 0x%x new 0x%x",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno,
> +		  __entry->bucket,
> +		  __entry->old_ptr,
> +		  __entry->new_ptr)
> +);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
