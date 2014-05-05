Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D0ED329DF8
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 15:21:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A9AAAC003
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 13:21:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QVLFD14tA6fjZ2pM for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 13:21:53 -0700 (PDT)
Date: Mon, 5 May 2014 16:21:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: pass struct da_args to xfs_attr_calc_size
Message-ID: <20140505202149.GF12448@laptop.bfoster>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<1399130415-5382-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399130415-5382-6-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, May 03, 2014 at 05:20:15PM +0200, Christoph Hellwig wrote:
> And remove a very confused comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_attr.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index 1208621..86f482e 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -162,12 +162,10 @@ xfs_attr_get(
>   */
>  STATIC int
>  xfs_attr_calc_size(
> -	struct xfs_inode 	*ip,
> -	int			namelen,
> -	int			valuelen,
> +	struct xfs_da_args	*args,
>  	int			*local)
>  {
> -	struct xfs_mount 	*mp = ip->i_mount;
> +	struct xfs_mount	*mp = args->dp->i_mount;
>  	int			size;
>  	int			nblks;
>  
> @@ -175,7 +173,7 @@ xfs_attr_calc_size(
>  	 * Determine space new attribute will use, and if it would be
>  	 * "local" or "remote" (note: local != inline).
>  	 */
> -	size = xfs_attr_leaf_newentsize(namelen, valuelen,
> +	size = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
>  					mp->m_sb.sb_blocksize, local);
>  
>  	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> @@ -189,7 +187,7 @@ xfs_attr_calc_size(
>  		 * Out of line attribute, cannot double split, but
>  		 * make room for the attribute value itself.
>  		 */
> -		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
> +		uint	dblocks = XFS_B_TO_FSB(mp, args->valuelen);
>  		nblks += dblocks;
>  		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
>  	}
> @@ -227,9 +225,7 @@ xfs_attr_set(
>  	args.firstblock = &firstblock;
>  	args.flist = &flist;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> -
> -	/* Size is now blocks for attribute data */
> -	args.total = xfs_attr_calc_size(dp, args.namelen, valuelen, &local);
> +	args.total = xfs_attr_calc_size(&args, &local);
>  
>  	error = xfs_qm_dqattach(dp, 0);
>  	if (error)
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
