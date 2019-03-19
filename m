Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfCSNAy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Mar 2019 09:00:54 -0400
Date: Tue, 19 Mar 2019 09:00:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix btree scrub checking with regards to
 root-in-inode
Message-ID: <20190319130051.GB23863@bfoster>
References: <20190318164336.GO4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318164336.GO4929@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 18, 2019 at 09:43:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_btree_check_owner, we can be passed a null buffer pointer.  This
> should only happen for the root of a root-in-inode btree type, but we
> should program defensively in case the btree cursor state ever gets
> screwed up and we get a null buffer anyway.
> 
> Coverity-id: 1438713
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/btree.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 6271a277eabe..cf4046c9e250 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -481,8 +481,17 @@ xchk_btree_check_owner(
>  	struct xfs_btree_cur	*cur = bs->cur;
>  	struct check_owner	*co;
>  
> -	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
> +	/*
> +	 * In theory, xfs_btree_get_block should only give us a null buffer
> +	 * pointer for the root of a root-in-inode btree type, but we need
> +	 * to check defensively here in case the cursor state is also screwed
> +	 * up.
> +	 */
> +	if (bp == NULL) {
> +		if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
> +			xchk_btree_set_corrupt(bs->sc, bs->cur, level);
>  		return 0;
> +	}
>  
>  	/*
>  	 * We want to cross-reference each btree block with the bnobt
