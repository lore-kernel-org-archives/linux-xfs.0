Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52084 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753160AbdATT0O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jan 2017 14:26:14 -0500
Subject: Re: [PATCH] xfs: do not call xfs_buf_hash_destroy on a NULL pag
References: <20170120142642.21698-1-colin.king@canonical.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <113b0890-ef1f-0a27-34c1-95785a4d1d17@sandeen.net>
Date: Fri, 20 Jan 2017 13:26:12 -0600
MIME-Version: 1.0
In-Reply-To: <20170120142642.21698-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 1/20/17 8:26 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> If pag cannot be allocated, the current error exit path will trip
> a null pointer deference error when calling xfs_buf_hash_destroy
> with a null pag.  Fix this by adding a new error exit lable and
> jumping to this, avoiding the hash destroy and unnecessary kmem_free
> on pag.
> 
> Fixes CoverityScan CID#1397628 ("Dereference after null check")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Hm, I think this leaves the code with issues.

> ---
>  fs/xfs/xfs_mount.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9b9540d..4e66cd19 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -207,7 +207,7 @@ xfs_initialize_perag(
>  
>  		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
>  		if (!pag)
> -			goto out_unwind;
> +			goto out_unwind_pags;

So let's say we got to index == 3 at the top of the loop, and
this fails.

We succeeded in initializing 0, 1, and 2, but 3 failed.

So we go to out_unwind_pags with index == 3...

>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
>  		spin_lock_init(&pag->pag_ici_lock);
> @@ -242,6 +242,7 @@ xfs_initialize_perag(
>  out_unwind:
>  	xfs_buf_hash_destroy(pag);
>  	kmem_free(pag);
> +out_unwind_pags:

... where index == 3, and:

>  	for (; index > first_initialised; index--) {
>  		pag = radix_tree_delete(&mp->m_perag_tree, index);

this should fail, because it never got inserted, and...

>  		xfs_buf_hash_destroy(pag);

this still tries to destroy a NULL pag, no?

There also seems to be an existing issue w/the code where ag 0 is
never torn down in the error case, because first_initialized doesn't
stay set to 0:

                if (!first_initialised)
                        first_initialised = index;

And we don't even tear down ag 1, because:

>  	for (; index > first_initialised; index--) {
>  		pag = radix_tree_delete(&mp->m_perag_tree, index);

when the loop reaches the first initialized AG, it stops.

So we seem to always leak at least 2 if we managed to get far enough
to initialize them.

-Eric

> 
