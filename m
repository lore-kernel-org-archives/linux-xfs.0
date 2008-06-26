Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 01:23:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q8Nch9007927
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 01:23:38 -0700
Date: Thu, 26 Jun 2008 04:24:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Move attr log alloc size calculator to another
	function.
Message-ID: <20080626082438.GB23954@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214196150-5427-2-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com, Niv Sardi <xaiki@debian.org>

On Mon, Jun 23, 2008 at 02:42:27PM +1000, Niv Sardi wrote:
> From: Niv Sardi <xaiki@debian.org>
> 
> We will need that to be able to calculate the size of log we need for
> a specific attr (for parent pointers in create). We need the local so
> that we can fail if we run into ENOSPC when trying to alloc blocks
> 
> Signed-off-by: Niv Sardi <xaiki@sgi.com>
> ---
>  fs/xfs/xfs_attr.c |   78 +++++++++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_attr.h |    2 +-
>  2 files changed, 47 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index e58f321..0d19e90 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -185,6 +185,43 @@ xfs_attr_get(
>  }
>  
>  int
> +xfs_attr_calc_size(

should be marked STATIC, and a little comment describing what
the function does would help, too.

> +	xfs_inode_t	*ip,

please use struct xfs_inode instead of the typedef for new code.

> +	int		namelen,
> +	int		valuelen,
> +	int		*local)
> +{
> +	xfs_mount_t	*mp = ip->i_mount;

Same here, should be struct xfs_mount

> +	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> +	if (*local) {
> +		if (size > (mp->m_sb.sb_blocksize >> 1)) {
> +			/* Double split possible */
> +			nblks <<= 1;
> +		}

The comment cold be a little more verbose, and using a *= 2 would
be more descriptive (the compiler will optimize it to a shift anyway)

> -	if ((error = xfs_trans_reserve(args.trans, (uint) nblks,
> -				      XFS_ATTRSET_LOG_RES(mp, nblks),
> -				      0, XFS_TRANS_PERM_LOG_RES,
> -				      XFS_ATTRSET_LOG_COUNT))) {
> +	if ((error = xfs_trans_reserve(args.trans, (uint) args.total,
> +				       XFS_ATTRSET_LOG_RES(mp, args.total),
> +				       0, XFS_TRANS_PERM_LOG_RES,
> +				       XFS_ATTRSET_LOG_COUNT))) {

When you touch this anyway please rewrite it to the canonical form:

	error = xfs_trans_reserve(args.trans, args.total,
			XFS_ATTRSET_LOG_RES(mp, args.total), 0,
			XFS_TRANS_PERM_LOG_RES, XFS_ATTRSET_LOG_COUNT);
	if (error) {

With these little tidyups this looks good enough as a cleanup that can
go in anytime.
