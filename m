Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfADSa6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 13:30:58 -0500
Date: Fri, 4 Jan 2019 13:30:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/8] xfs: never try to scrub more than 64 inodes per
 inobt record
Message-ID: <20190104183055.GC16751@bfoster>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
 <154630851366.14372.14057534574140159776.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630851366.14372.14057534574140159776.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:08:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we never check more than XFS_INODES_PER_CHUNK inodes for any
> given inobt record since there can be more than one inobt record mapped
> to an inode cluster.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/ialloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 882dc56c5c21..fd431682db0b 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -203,7 +203,8 @@ xchk_iallocbt_check_freemask(
>  	int				error = 0;
>  
>  	/* Make sure the freemask matches the inode records. */
> -	nr_inodes = mp->m_inodes_per_cluster;
> +	nr_inodes = min_t(unsigned int, XFS_INODES_PER_CHUNK,
> +			mp->m_inodes_per_cluster);
>  

I'm wondering why we wouldn't also use nr_inodes in the loop immediately
below instead of ->m_inodes_per_cluster, but it looks like this all
changes in the following patches.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	for (agino = irec->ir_startino;
>  	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
> 
