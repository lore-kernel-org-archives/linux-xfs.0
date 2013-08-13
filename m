Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFB5829DFB
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 09:02:09 -0500 (CDT)
Message-ID: <520A3C5E.1030307@sgi.com>
Date: Tue, 13 Aug 2013 09:02:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 46/50] xfs: Combine CIL insert and prepare passes
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-47-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-47-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/12/13 05:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Now that all the log item preparation and formatting is done under
> the CIL lock, we can get rid of the intermediate log vector chain
> used to track items to be inserted into the CIL.
>
> We can already find all the items to be committed from the
> transaction handle, so as long as we attach the log vectors to the
> item before we insert the items into the CIL, we don't need to
> create a log vector chain to pass around.
>
> This means we can move all the item insertion code into and optimise
> it into a pair of simple passes across all the items in the
> transaction. The first pass does the formatting and accounting, the
> second inserts them all into the CIL.
>
> We keep this two pass split so that we can separate the CIL
> insertion - which must be done under the CIL spinlock - from the
> formatting. We could insert each item into the CIL with a single
> pass, but that massively increases the number of times we have to
> grab the CIL spinlock. It is much more efficient (and hence
> scalable) to do a batch operation and insert all objects in a single
> lock grab.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_log_cil.c | 227 +++++++++++++++++++++++----------------------------
>   1 file changed, 100 insertions(+), 127 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b20b157..c1a3384 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -111,6 +111,53 @@ xlog_cil_lv_item_format(
>   }
>
>   /*
> + * Prepare the log item for insertion into the CIL. Calculate the difference in
> + * log space and vectors it will consume, and if it is a new item pin it as
> + * well.
> + */
> +STATIC void
> +xfs_cil_prepare_item(
> +	struct xlog		*log,
> +	struct xfs_log_vec	*lv,
> +	struct xfs_log_vec	*old_lv,
> +	int			*diff_len,
> +	int			*diff_iovecs)
> +{
> +	/* Account for the new LV being passed in */
> +	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
> +		*diff_len += lv->lv_buf_len;
> +		*diff_iovecs += lv->lv_niovecs;
> +	}
> +
> +	/*
> +	 * If there is no old LV, this is the first time we've seen the item in
> +	 * this CIL context and so we need to pin it. If we are replacing the
> +	 * old_lv, then remove the space it accounts for and free it.
> +	 */
> +	if (!old_lv)
> +		lv->lv_item->li_ops->iop_pin(lv->lv_item);
> +	else if (old_lv != lv) {
> +		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);

This should never happen, but I liked the original if .. then here
as well as the assert...

> +
> +		*diff_len -= old_lv->lv_buf_len;
> +		*diff_iovecs -= old_lv->lv_niovecs;
> +		kmem_free(old_lv);
> +	}

... but not enough to make you repost.

Unless someone else has strong opinions, the CIL lock series (patches 
43-47) have been reviewed and tested.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
