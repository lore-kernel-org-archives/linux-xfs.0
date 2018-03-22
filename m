Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754475AbeCVOel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:34:41 -0400
Date: Thu, 22 Mar 2018 10:34:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/9] xfs: xfs_scrub_iallocbt_xref_rmap_inodes should use
 xref_set_corrupt
Message-ID: <20180322143439.GH16617@bfoster.bfoster>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <20180322061916.GT4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180322061916.GT4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 11:19:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_scrub_iallocbt_xref_rmap_inodes we're checking inodes against
> rmap records, so we should use xfs_scrub_btree_xref_set_corrupt if we
> encounter discrepancies here so that we know that it's a cross
> referencing error, not necessarily a corruption in the inobt itself.
> 
> The userspace xfs_scrub program will try to repair outright corruptions
> in the agi/inobt prior to phase 3 so that the inode scan will proceed.
> If only a cross-referencing error is noted, the repair program defers
> the repair attempt until it can check the other space metadata at least
> once.
> 
> It is therefore essential that the inobt scrubber can correctly
> distinguish between corruptions and "unable to cross-reference something
> else with this inobt".  The same reasoning applies to "xfs: record inode
> buf errors as a xref error in inobt scrubber".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/ialloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 32e0d1a..106ca4b 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -434,7 +434,7 @@ xfs_scrub_iallocbt_xref_rmap_inodes(
>  	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
>  		return;
>  	if (blocks != inode_blocks)
> -		xfs_scrub_btree_set_corrupt(sc, sc->sa.ino_cur, 0);
> +		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
>  }
>  
>  /* Scrub the inode btrees for some AG. */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
