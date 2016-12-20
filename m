Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbcLTIUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 03:20:02 -0500
Date: Tue, 20 Dec 2016 00:20:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use the actual AG length when reserving blocks
Message-ID: <20161220082000.GA14758@infradead.org>
References: <20161217061920.GJ5357@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161217061920.GJ5357@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 16, 2016 at 10:19:20PM -0800, Darrick J. Wong wrote:
> We need to use the actual AG length when making per-AG reservations,
> since we could otherwise end up reserving more blocks out of the last
> AG than there are actual blocks.
> 
> Complained-about-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c        |    4 ++++
>  fs/xfs/libxfs/xfs_refcount_btree.c |    9 ++++++---
>  fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   14 ++++++++------
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++-
>  fs/xfs/xfs_fsops.c                 |   14 ++++++++++++++
>  6 files changed, 36 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index e5ebc37..fac3430 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -225,6 +225,7 @@ xfs_ag_resv_init(
>  {
>  	xfs_extlen_t			ask;
>  	xfs_extlen_t			used;
> +	xfs_extlen_t			reserved;
>  	int				error = 0;
>  
>  	/* Create the metadata reservation. */
> @@ -256,6 +257,9 @@ xfs_ag_resv_init(
>  			goto out;
>  	}
>  
> +	reserved = xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> +		   xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved;
> +	ASSERT(reserved <= pag->pagf_freeblks + pag->pagf_flcount);

This will create a warning for non-debug builds due to the unused
reserved variable.

> +	/* Reserve 1% of the AG or enough for 1 block per record. */
> +	*ask += pool_len = max(agblocks / 100,
> +			xfs_rmapbt_max_size(mp, agblocks));
>  	*used += tree_len;
>  
>  	return error;

pool_len is initialized but not used.

Otherwise this looks fine to me.

But while looking at this patch and my current minleft "project" I've
started to wonder how the XFS_AG_RESV_METADATA reservations are
supposed to work: they are reserved out of the fs-wide pool, but
the user of XFS_AG_RESV_METADATA really needs a block in this particular
AG.
