Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A32837F6D
	for <xfs@oss.sgi.com>; Mon,  8 Apr 2013 16:30:55 -0500 (CDT)
Message-ID: <5163370E.6090804@sgi.com>
Date: Mon, 08 Apr 2013 16:30:54 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH]xfs: Remove the obsolete XLOG_CIL_HARD_SPACE_LIMIT() macros
References: <515CFD42.70109@oracle.com>
In-Reply-To: <515CFD42.70109@oracle.com>
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

On 04/03/13 23:10, Jeff Liu wrote:
> There is no more users of this Macro, so it's time to kill it dead.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---
>   fs/xfs/xfs_log_priv.h |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 16d8d12..b9ea262 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -468,7 +468,6 @@ struct xfs_cil {
>    * threshold, yet give us plenty of space for aggregation on large logs.
>    */
>   #define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize>>  3)
> -#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize>>  4))
>
>   /*
>    * ticket grant locks, queues and accounting have their own cachlines

Removed in commit:

commit 4c2d542f2e786537db33b613d5199dc6d69a96da
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Apr 23 17:54:32 2012 +1000

     xfs: Do background CIL flushes via a workqueue

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
