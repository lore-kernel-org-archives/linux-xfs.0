Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfADSbY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 13:31:24 -0500
Date: Fri, 4 Jan 2019 13:31:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: hoist inode cluster checks out of loop
Message-ID: <20190104183121.GF16751@bfoster>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
 <154630853205.14372.8548651680958822032.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630853205.14372.8548651680958822032.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Mon, Dec 31, 2018 at 06:08:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the inode cluster checks out of the inobt record check loop into
> a separate function in preparation for refactoring of that loop.  No
> functional changes here; that's in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/scrub/ialloc.c |  119 +++++++++++++++++++++++++++----------------------
>  1 file changed, 65 insertions(+), 54 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 5e593e4292b2..9af01ea0258d 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
...
> +/* Make sure the free mask is consistent with what the inodes think. */
> +STATIC int
> +xchk_iallocbt_check_freemask(
> +	struct xchk_btree		*bs,
> +	struct xfs_inobt_rec_incore	*irec)
> +{
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	xfs_agino_t			agino;
> +	int				error = 0;
> +
> +	for (agino = irec->ir_startino;
> +	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
> +	     agino += mp->m_blocks_per_cluster * mp->m_sb.sb_inopblock) {

->m_inodes_per_cluster ?

Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		error = xchk_iallocbt_check_cluster(bs, irec, agino);
> +		if (error)
> +			break;
>  	}
>  
>  	return error;
> 
