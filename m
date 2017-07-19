Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753873AbdGSNUE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jul 2017 09:20:04 -0400
Date: Wed, 19 Jul 2017 09:20:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: check _btree_check_block value
Message-ID: <20170719132002.GA54534@bfoster.bfoster>
References: <150040225662.1216.16823172616535217786.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150040225662.1216.16823172616535217786.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 11:24:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the _btree_check_block return value for the firstrec and lastrec
> functions, since we have the ability to signal that the repositioning
> did not succeed.
> 
> Fixes-coverity-id: 114067
> Fixes-coverity-id: 114068
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 4da85ff..e0bcc4a 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -728,7 +728,8 @@ xfs_btree_firstrec(
>  	 * Get the block pointer for this level.
>  	 */
>  	block = xfs_btree_get_block(cur, level, &bp);
> -	xfs_btree_check_block(cur, block, level, bp);
> +	if (xfs_btree_check_block(cur, block, level, bp))
> +		return 0;
>  	/*
>  	 * It's empty, there is no such record.
>  	 */
> @@ -757,7 +758,8 @@ xfs_btree_lastrec(
>  	 * Get the block pointer for this level.
>  	 */
>  	block = xfs_btree_get_block(cur, level, &bp);
> -	xfs_btree_check_block(cur, block, level, bp);
> +	if (xfs_btree_check_block(cur, block, level, bp))
> +		return 0;
>  	/*
>  	 * It's empty, there is no such record.
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
