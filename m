Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52DCB7F5A
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 00:31:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3128D304066
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:31:25 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	A5Q40XsOk3yqcd50 for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 22:31:20 -0800 (PST)
Date: Thu, 3 Dec 2015 17:31:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/11] xfsprogs: fix possible null pointer dereference in
	xfs_iformat_extents
Message-ID: <20151203063106.GZ26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-11-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449055167-19936-11-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 04:49:26PM +0530, Vivek Trivedi wrote:
> Fix possible null pointer dereference in xfs_iformat_extents and
> xfs_iext_get_ext if fail to locate inode record.
> Reported by coverity.

ignore it. Code 
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  libxfs/xfs_inode_fork.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index e1968b4..36aa0c8 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -331,6 +331,8 @@ xfs_iformat_extents(
>  		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
>  		for (i = 0; i < nex; i++, dp++) {
>  			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
> +			if (!ep)
> +				return -EFSCORRUPTED;
>  			ep->l0 = get_unaligned_be64(&dp->l0);
>  			ep->l1 = get_unaligned_be64(&dp->l1);

Can't possibly happen, as nex is a count of the number of entries in
the extent list and so we will never overrun the list here.

> @@ -890,6 +892,8 @@ xfs_iext_get_ext(
>  		xfs_extnum_t	page_idx = idx;	/* ext index in target list */
>  
>  		erp = xfs_iext_idx_to_irec(ifp, &page_idx, &erp_idx, 0);
> +		if (!erp)
> +			return NULL;

Same again - this is guaranteed to succeed because the indexes
passed into the function are bound to within range by the caller.
The ASSERT()s at the beginning of the function enforce this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
