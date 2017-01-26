Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59440 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbdAZSRe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 13:17:34 -0500
Subject: Re: [PATCH v3] xfs: do not call xfs_buf_hash_destroy on a NULL pag
References: <20170120142642.21698-1-colin.king@canonical.com>
 <20170125190443.20929-1-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2be6ef17-9664-fdfc-49d0-eebca1b14be5@sandeen.net>
Date: Thu, 26 Jan 2017 11:58:37 -0600
MIME-Version: 1.0
In-Reply-To: <20170125190443.20929-1-billodo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

On 1/25/17 1:04 PM, Bill O'Donnell wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> If pag cannot be allocated, the current error exit path will trip
> a null pointer deference error when calling xfs_buf_hash_destroy
> with a null pag.  Fix this by adding a new error exit lable and
> jumping to this, avoiding the hash destroy and unnecessary kmem_free
> on pag.

There are enough other changes that it probably needs a more accurate
commit log and subject, and TBH probably switch Colin to reported-by.
 
> Fixes CoverityScan CID#1397628 ("Dereference after null check")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> ------------
> v2: correct error exit in xfs_initialize_perag() to properly unwind
>     pags if error encountered.
> 
> v3: correction to error case: ensure previous valid pags not torn
>     down and only new initialized pags are torn down.

patch changelog goes under the "---" below, it shouldn't be part of the
commitlog, FYI.

> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_mount.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9b9540d..afc49ac 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -188,8 +188,10 @@ xfs_initialize_perag(
>  {
>  	xfs_agnumber_t	index;
>  	xfs_agnumber_t	first_initialised = 0;
> +	xfs_agnumber_t	next_agindex = 0;
>  	xfs_perag_t	*pag;
>  	int		error = -ENOMEM;
> +	int		i;
>  
>  	/*
>  	 * Walk the current per-ag tree so we don't try to initialise AGs
> @@ -200,14 +202,15 @@ xfs_initialize_perag(
>  		pag = xfs_perag_get(mp, index);
>  		if (pag) {
>  			xfs_perag_put(pag);
> +			next_agindex = index + 1;

a little odd to keep incrementing next_agindex when we really
only care that it's nonzero, right?

>  			continue;
>  		}
> -		if (!first_initialised)
> +		if (!first_initialised && (next_agindex > 0))
>  			first_initialised = index; 

ok, so we deem this index as first_initialized, but:

>  		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
>  		if (!pag)
> -			goto out_unwind;
> +			goto out_unwind_pags;

...then it could fail.  Which is why the unwind loop at the end still
needs to check for (this) null pag, and skip if so.  In fact if you
ever get to that loop, I think it's guaranteed that the first time
through will find the null pag for this index and skip it.

It'd be a little nicer to move the first_initialized assignment down,
after it's actually /been/ allocated and initialized.

This patch also leaves this in place:

                if (xfs_buf_hash_init(pag))
                        goto out_unwind;
...
out_unwind:
        xfs_buf_hash_destroy(pag);
        kmem_free(pag);

so isn't this doing buf_hash_destroy on something that has failed to
init in the first place?  I have no idea if that's safe, but best to
just be clean about it.

In the big picture, there are 3 things happening in this loop that may
need to be unwound for this and/or prior pags on an error:

1) pag memory allocation
2) xfs_buf_hash_init
3) radix_tree_insert

For any given iteration through the loop, any of the above which succeed
must be unwound for /this/ pag, and then all prior initialized pags must
be unwound.  So I'd expect something like this, though please check the
details and adjust labels to your preference.  :)

	bool first_init_done = false;

        for (index = 0; index < agcount; index++) {
		if (pag exists)
			continue;

		allocate(pag)
		if (failure)
			goto unwind_prior_pags;

		xfs_buf_hash_init(pag)
		if (failure)
			goto free_pag;

		radix_tree_insert(pag)
		if (failure)
			goto hash_destroy;

		/* this pag is fully initialized now */
		if (!first_init_done) {
			first_initialized = index;
			first_init_done = true;
		}
	}

	/* unwind this pag on init failures */
hash_destroy:
	xfs_buf_hash_destroy(pag);
free_pag:
	kmem_free(pag);
unwind_prior_pags:
	/* back up to previous fully initialized pag and unwind it+prior */
	index--;
	for (; index >= first_initialised; index--) 
		pag = radix_tree_delete(index)
		xfs_buf_hash_destroy(pag)
		kmem_free(pag)


>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
>  		spin_lock_init(&pag->pag_ici_lock);
> @@ -242,8 +245,11 @@ xfs_initialize_perag(
>  out_unwind:
>  	xfs_buf_hash_destroy(pag);
>  	kmem_free(pag);
> -	for (; index > first_initialised; index--) {
> -		pag = radix_tree_delete(&mp->m_perag_tree, index);
> +out_unwind_pags:
> +	for (i = index; i >= first_initialised; i--) {
> +		pag = radix_tree_delete(&mp->m_perag_tree, (xfs_agnumber_t)i);

(don't make i an int if it's really supposed to be an xfs_agnumber_t,
which is unsigned)

-Eric

> +		if (!pag)
> +			continue;
>  		xfs_buf_hash_destroy(pag);
>  		kmem_free(pag);
>  	}
> 
