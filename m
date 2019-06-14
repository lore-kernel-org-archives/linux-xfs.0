Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfFNOEy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:04:54 -0400
Date: Fri, 14 Jun 2019 10:04:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/14] xfs: refactor iwalk code to handle walking inobt
 records
Message-ID: <20190614140451.GC26586@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032212280.3774243.2412398404922269104.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032212280.3774243.2412398404922269104.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:48:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_iwalk_ag_start and xfs_iwalk_ag so that the bits that are
> particular to bulkstat (trimming the start irec, starting inode
> readahead, and skipping empty groups) can be controlled via flags in the
> iwag structure.
> 
> This enables us to add a new function to walk all inobt records which
> will be used for the new INUMBERS implementation in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iwalk.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_iwalk.h |   12 ++++++++
>  2 files changed, 84 insertions(+), 3 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> index 9e762e31dadc..97c1120d4237 100644
> --- a/fs/xfs/xfs_iwalk.h
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -16,4 +16,16 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
>  int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
>  		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
>  
> +/* Walk all inode btree records in the filesystem starting from @startino. */
> +typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> +				 xfs_agnumber_t agno,
> +				 const struct xfs_inobt_rec_incore *irec,
> +				 void *data);
> +/* Return value (for xfs_inobt_walk_fn) that aborts the walk immediately. */
> +#define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
> +

Similar comment here around the need for a special case abort error. I
assume we could just use IWALK_ABORT. That aside this all looks pretty
good to me. Thanks for the cleanup:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
> +		xfs_ino_t startino, xfs_inobt_walk_fn inobt_walk_fn,
> +		unsigned int max_prefetch, void *data);
> +
>  #endif /* __XFS_IWALK_H__ */
> 
