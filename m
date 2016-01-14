Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0258E7F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:32:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D820D8F8040
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 09:32:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lYrmHsHFGLEMK4qo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 09:32:18 -0800 (PST)
Date: Thu, 14 Jan 2016 12:32:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: handle errors from ->free_blocks in
	xfs_btree_kill_iroot
Message-ID: <20160114173214.GA11448@bfoster.bfoster>
References: <1452707454-15229-1-git-send-email-hch@lst.de>
	<1452707454-15229-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452707454-15229-2-git-send-email-hch@lst.de>
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

On Wed, Jan 13, 2016 at 06:50:52PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index a0eb18c..3143577 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -3209,6 +3209,7 @@ xfs_btree_kill_iroot(
>  	int			level;
>  	int			index;
>  	int			numrecs;
> +	int			error;
>  #ifdef DEBUG
>  	union xfs_btree_ptr	ptr;
>  	int			i;
> @@ -3272,8 +3273,6 @@ xfs_btree_kill_iroot(
>  	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
>  #ifdef DEBUG
>  	for (i = 0; i < numrecs; i++) {
> -		int		error;
> -
>  		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
>  		if (error) {
>  			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> @@ -3283,7 +3282,11 @@ xfs_btree_kill_iroot(
>  #endif
>  	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
>  
> -	cur->bc_ops->free_block(cur, cbp);
> +	error = cur->bc_ops->free_block(cur, cbp);
> +	if (error) {
> +		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> +		return error;
> +	}
>  	XFS_BTREE_STATS_INC(cur, free);
>  
>  	cur->bc_bufs[level - 1] = NULL;
> -- 
> 1.9.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
