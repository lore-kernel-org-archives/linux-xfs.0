Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388475AbfGWPLR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 11:11:17 -0400
Date: Tue, 23 Jul 2019 08:11:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723151102.GA1561054@magnolia>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723150017.31891-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 05:00:17PM +0200, Carlos Maiolino wrote:
> xfs_extent_busy_clear_one() calls kmem_free() with the pag spinlock
> locked.

Er, what problem does this solve?  Does holding on to the pag spinlock
too long while memory freeing causes everything else to stall?  When is
memory freeing slow enough to cause a noticeable impact?

> Fix this by adding a new temporary list, and, make
> xfs_extent_busy_clear_one() to move the extent_busy items to this new
> list, instead of freeing them.
> 
> Free the objects in the temporary list after we drop the pagb_lock
> 
> Reported-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_extent_busy.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 0ed68379e551..0a7dcf03340b 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -523,7 +523,8 @@ STATIC void
>  xfs_extent_busy_clear_one(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	struct xfs_extent_busy	*busyp)
> +	struct xfs_extent_busy	*busyp,
> +	struct list_head	*list)
>  {
>  	if (busyp->length) {
>  		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
> @@ -531,8 +532,7 @@ xfs_extent_busy_clear_one(
>  		rb_erase(&busyp->rb_node, &pag->pagb_tree);
>  	}
>  
> -	list_del_init(&busyp->list);
> -	kmem_free(busyp);
> +	list_move(&busyp->list, list);
>  }
>  
>  static void
> @@ -565,6 +565,7 @@ xfs_extent_busy_clear(
>  	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = NULLAGNUMBER;
>  	bool			wakeup = false;
> +	LIST_HEAD(busy_list);
>  
>  	list_for_each_entry_safe(busyp, n, list, list) {
>  		if (busyp->agno != agno) {
> @@ -580,13 +581,18 @@ xfs_extent_busy_clear(
>  		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
>  			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
>  		} else {
> -			xfs_extent_busy_clear_one(mp, pag, busyp);
> +			xfs_extent_busy_clear_one(mp, pag, busyp, &busy_list);

...and why not just put the busyp on the busy_list here so you don't
have to pass the list_head pointer around?

--D

>  			wakeup = true;
>  		}
>  	}
>  
>  	if (pag)
>  		xfs_extent_busy_put_pag(pag, wakeup);
> +
> +	list_for_each_entry_safe(busyp, n, &busy_list, list) {
> +		list_del_init(&busyp->list);
> +		kmem_free(busyp);
> +	}
>  }
>  
>  /*
> -- 
> 2.20.1
> 
