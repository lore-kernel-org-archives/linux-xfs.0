Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59735 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753195AbeARAwM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 19:52:12 -0500
Date: Thu, 18 Jan 2018 11:52:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix non-debug build compiler warnings
Message-ID: <20180118005203.GL6304@dastard>
References: <20180117164102.GE25805@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180117164102.GE25805@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 17, 2018 at 08:41:02AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@djwong.org>
> 
> Fix compiler warning on non-debug build
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot_item.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index e564f11..51ee848 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -150,10 +150,7 @@ xfs_dquot_item_error(
>  	struct xfs_log_item	*lip,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_dquot	*dqp;
> -
> -	dqp = DQUOT_ITEM(lip)->qli_dquot;
> -	ASSERT(!completion_done(&dqp->q_flush));
> +	ASSERT(!completion_done(&DQUOT_ITEM(lip)->qli_dquot->q_flush));
>  	xfs_set_li_failed(lip, bp);

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
