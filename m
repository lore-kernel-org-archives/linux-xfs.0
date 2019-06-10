Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389059AbfFJTcY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 15:32:24 -0400
Date: Mon, 10 Jun 2019 15:32:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/10] xfs: clean up long conditionals in
 xfs_iwalk_ichunk_ra
Message-ID: <20190610193220.GI6473@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968501261.1657646.16272249682611768545.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968501261.1657646.16272249682611768545.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:50:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_iwalk_ichunk_ra to avoid long conditionals.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iwalk.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 9ad017ddbae7..8595258b5001 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -84,16 +84,16 @@ xfs_iwalk_ichunk_ra(
>  	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
>  
>  	blk_start_plug(&plug);
> -	for (i = 0;
> -	     i < XFS_INODES_PER_CHUNK;
> -	     i += igeo->inodes_per_cluster,
> -			agbno += igeo->blocks_per_cluster) {
> -		if (xfs_inobt_maskn(i, igeo->inodes_per_cluster) &
> -		    ~irec->ir_free) {
> +	for (i = 0; i < XFS_INODES_PER_CHUNK; i += igeo->inodes_per_cluster) {
> +		xfs_inofree_t	imask;
> +
> +		imask = xfs_inobt_maskn(i, igeo->inodes_per_cluster);
> +		if (imask & ~irec->ir_free) {
>  			xfs_btree_reada_bufs(mp, agno, agbno,
>  					igeo->blocks_per_cluster,
>  					&xfs_inode_buf_ops);
>  		}
> +		agbno += igeo->blocks_per_cluster;
>  	}
>  	blk_finish_plug(&plug);
>  }
> 
