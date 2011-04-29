Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T1m4en033810 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 20:48:04 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C355D41F203
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:51:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bmY1WTi4L2qAXiUL for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 18:51:36 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1QFcri-0003Z9-5t
	for xfs@oss.sgi.com; Fri, 29 Apr 2011 11:51:30 +1000
Date: Fri, 29 Apr 2011 11:51:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: obey minleft values during extent allocation
	correctly.
Message-ID: <20110429015130.GB13542@dastard>
References: <1303378468-14163-1-git-send-email-david@fromorbit.com>
	<1303378468-14163-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303378468-14163-5-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

ping?

On Thu, Apr 21, 2011 at 07:34:28PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When allocating an extent that is long enough to consume the
> remaining free space in an AG, we need to ensure that the allocation
> leaves enough space in the AG for any subsequent bmap btree blocks
> that are needed to track the new extent. These have to be allocated
> in the same AG as we only reserve enough blocks in an allocation
> transaction for modification of the freespace trees in a single AG.
> 
> xfs_alloc_fix_minleft() has been considering blocks on the AGFL as
> free blocks available for extent and bmbt block allocation, which is
> not correct - blocks on the AGFL are there exclusively for the use
> of the free space btrees. As a result, when minleft is less than the
> number of blocks on the AGFL, xfs_alloc_fix_minleft() does not trim
> the given extent to leave minleft blocks available for bmbt
> allocation, and hence we can fail allocation during bmbt record
> insertion.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_alloc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 27d64d7..8946464 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -280,7 +280,6 @@ xfs_alloc_fix_minleft(
>  		return 1;
>  	agf = XFS_BUF_TO_AGF(args->agbp);
>  	diff = be32_to_cpu(agf->agf_freeblks)
> -		+ be32_to_cpu(agf->agf_flcount)
>  		- args->len - args->minleft;
>  	if (diff >= 0)
>  		return 1;
> -- 
> 1.7.4.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
