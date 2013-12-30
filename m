Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D40E7F3F
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 09:07:25 -0600 (CST)
Message-ID: <52C18C2C.6090108@sgi.com>
Date: Mon, 30 Dec 2013 09:07:24 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: simplify xfs_ail_max
References: <52B9829A.10804@oracle.com>
In-Reply-To: <52B9829A.10804@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/24/13 06:48, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> We have already simplified xfs_ail_min() with a new list helper, i.e,
> list_first_entry_or_null(), but xfs_ail_max() still remains as same
> as there is no corresponding list helper we can use for now.  It's
> fairly easy to simulate the list behavior of getting the last item
> in the AIL, therefore we can simplify xfs_ail_max() and move it to
> the header file to make this pair of AIL routines looks symmetrical.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---

> +/*
> + * Return a pointer to the last item in the AIL.  If the AIL is empty, then
> + * return NULL.
> + */
> +static inline struct xfs_log_item *
> +xfs_ail_max(
> +	struct xfs_ail  *ailp)
> +{
> +	return list_empty(&ailp->xa_ail) ? NULL :
> +		list_last_entry(&ailp->xa_ail, struct xfs_log_item, li_ail);
> +}
> +
> +
>   static inline void
>   xfs_trans_ail_update(
>   	struct xfs_ail		*ailp,

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
