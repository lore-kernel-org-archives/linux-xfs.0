Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753237AbeDSMz5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 08:55:57 -0400
Date: Thu, 19 Apr 2018 08:55:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/11] xfs: btree scrub should check minrecs
Message-ID: <20180419125555.GC25844@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401923232.11465.11554889141647009009.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401923232.11465.11554889141647009009.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 07:40:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Strengthen the btree block header checks to detect the number of records
> being less than the btree type's minimum record count.  Certain blocks
> are allowed to violate this constraint -- specifically any btree block
> at the top of the tree can have fewer than minrecs records.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/btree.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index ea972da..2d29dce 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -455,6 +455,44 @@ xfs_scrub_btree_check_owner(
>  }
>  
>  /*
> + * Check that this btree block has at least minrecs records or is one of the
> + * special blocks that don't require that.
> + */
> +STATIC void
> +xfs_scrub_btree_check_minrecs(
> +	struct xfs_scrub_btree	*bs,
> +	int			level,
> +	struct xfs_btree_block	*block)
> +{
> +	unsigned int		numrecs;
> +	int			ok_level;
> +
> +	numrecs = be16_to_cpu(block->bb_numrecs);
> +
> +	/* More records than minrecs means the block is ok. */
> +	if (numrecs >= bs->cur->bc_ops->get_minrecs(bs->cur, level))
> +		return;
> +
> +	/*
> +	 * Certain btree blocks /can/ have fewer than minrecs records.  Any
> +	 * level greater than or equal to the level of the highest dedicated
> +	 * btree block are allowed to violate this constraint.
> +	 *
> +	 * For a btree rooted in a block, the btree root can have fewer than
> +	 * minrecs records.  If the btree is rooted in an inode and does not
> +	 * store records in the root, the direct children of the root and the
> +	 * root itself can have fewer than minrecs records.
> +	 */
> +	ok_level = bs->cur->bc_nlevels - 1;
> +	if (bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> +		ok_level--;
> +	if (level >= ok_level)
> +		return;
> +
> +	xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
> +}
> +
> +/*
>   * Grab and scrub a btree block given a btree pointer.  Returns block
>   * and buffer pointers (if applicable) if they're ok to use.
>   */
> @@ -491,6 +529,8 @@ xfs_scrub_btree_get_block(
>  	if (*pbp)
>  		xfs_scrub_buffer_recheck(bs->sc, *pbp);
>  
> +	xfs_scrub_btree_check_minrecs(bs, level, *pblock);
> +
>  	/*
>  	 * Check the block's owner; this function absorbs error codes
>  	 * for us.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
