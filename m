Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE3037FAD
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:16:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBAC08F8037
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:16:06 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NvW1DDBQTkSfARUM for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 02:16:04 -0700 (PDT)
Date: Tue, 6 May 2014 19:16:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fwd: New Defects reported by Coverity Scan for xfsprogs
Message-ID: <20140506091602.GL5421@dastard>
References: <5362fbfc78ad5_2dbacf387045986@209.249.196.67.mail>
	<5368A578.7070201@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5368A578.7070201@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, May 06, 2014 at 05:03:52PM +0800, Jeff Liu wrote:
> Hi Folks,
> 
> I'm not sure if someone else has also noticed the following reports from Coverity.

yup, saw it - it not a regression from a recent checkin, so it must
some new check they've added to Coverity. However, i ignored it
because it looked completely bogus....

> It seems like a false alarm, but maybe we can just remove the out0 label as below?

Yup, it must be getting confused with the assignment of *stat = 0
after checking that it is already zero...

> From: Jie Liu <jeff.liu@oracle.com>
> Subject: xfs: get rid of out0 goto label from xfs_btree_new_root
> 
> Get rid of the useless out0 goto label and return 0 directly in case
> of falling to alloate the new block.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_btree.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
> index 182bac2..f162dc9 100644
> --- a/fs/xfs/xfs_btree.c
> +++ b/fs/xfs/xfs_btree.c
> @@ -2653,8 +2653,11 @@ xfs_btree_new_root(
>  	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, stat);
>  	if (error)
>  		goto error0;
> -	if (*stat == 0)
> -		goto out0;
> +	if (*stat == 0) {
> +		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> +		return 0;
> +	}
> +
>  	XFS_BTREE_STATS_INC(cur, alloc);
>  
>  	/* Set up the new block. */
> @@ -2743,10 +2746,6 @@ xfs_btree_new_root(
>  error0:
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
>  	return error;
> -out0:
> -	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> -	*stat = 0;
> -	return 0;
>  }

Looks fine. It's not obviously a problem, so I'll queue it up for
after then 3.2.0 release.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
