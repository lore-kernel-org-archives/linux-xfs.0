Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbfCSNAS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Mar 2019 09:00:18 -0400
Date: Tue, 19 Mar 2019 09:00:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: dabtree scrub needs to range-check level
Message-ID: <20190319130015.GA23863@bfoster>
References: <20190318164215.GN4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318164215.GN4929@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 18, 2019 at 09:42:15AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure scrub's dabtree iterator function checks that we're not
> going deeper in the stack than our cursor permits.  Found by sparse.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/dabtree.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index c6ab123b6051..5c6175d074e0 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -604,6 +604,11 @@ xchk_da_btree(
>  		/* Drill another level deeper. */
>  		blkno = be32_to_cpu(key->before);
>  		level++;
> +		if (level >= XFS_DA_NODE_MAXDEPTH) {
> +			/* Too deep! */
> +			xchk_da_set_corrupt(&ds, level - 1);
> +			break;
> +		}
>  		ds.tree_level--;
>  		error = xchk_da_btree_block(&ds, level, blkno);
>  		if (error)
