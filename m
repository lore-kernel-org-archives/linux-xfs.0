Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbeJJUmC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 16:42:02 -0400
Date: Wed, 10 Oct 2018 09:19:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix use-after-free race in xfs_buf_rele
Message-ID: <20181010131949.GA53848@bfoster>
References: <20181009220044.5539-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009220044.5539-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:00:44AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When looking at a 4.18 based KASAN use after free report, I noticed
> that racing xfs_buf_rele() may race on dropping the last reference
> to the buffer and taking the buffer lock. This was the symptom
> displayed by the KASAN report, but the actual issue that was
> reported had already been fixed in 4.19-rc1 by commit e339dd8d8b04
> ("xfs: use sync buffer I/O for sync delwri queue submission").
> 

Are you saying that the KASAN report reflected the delwri queue race and
the rele() issue was discovered by inspection, or that the KASAN report
occurred with the delwri queue fix already in place? Or IOW, has this
been reproduced?

> Despite this, I think there is still an issue with xfs_buf_rele()
> in this code:
> 
> 
>         release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
>         spin_lock(&bp->b_lock);
>         if (!release) {
> .....
> 
> If two threads race on the b_lock after both dropping a reference
> and one getting dropping the last reference so release = true, we
> end up with:
> 
> 
> CPU 0				CPU 1
> atomic_dec_and_lock()
> 				atomic_dec_and_lock()
> 				spin_lock(&bp->b_lock)
> spin_lock(&bp->b_lock)
> <spins>

Ok, so CPU0 drops one ref and returns, CPU1 drops the last ref, acquires
->b_pag_lock, returns and wins the race to ->b_lock. The latter bit
basically means the final reference cleanup executes before the previous
reference drop gets to acquire ->b_lock. CPU1 releases ->b_lock and the
race is on between freeing the buffer and processing the intermediate
release.

I suppose this makes sense because ->b_pag_lock is only acquired on the
final release. Therefore, ->b_lock is the real serialization point as
far as xfs_buf_rele() is concerned.

> 				<release = true bp->b_lru_ref = 0>
> 				<remove from lists>
> 				freebuf = true
> 				spin_unlock(&bp->b_lock)
> 				xfs_buf_free(bp)
> <gets lock, reading and writing freed memory>
> <accesses freed memory>
> spin_unlock(&bp->b_lock) <reads/writes freed memory>
> 
> IOWs, we can't safely take bp->b_lock after dropping the hold
> reference because the buffer may go away at any time after we
> drop that reference. However, this can be fixed simply by taking the
> bp->b_lock before we drop the reference.
> 
> It is safe to nest the pag_buf_lock inside bp->b_lock as the
> pag_buf_lock is only used to serialise against lookup in
> xfs_buf_find() and no other locks are held over or under the
> pag_buf_lock there. Make this clear by documenting the buffer lock
> orders at the top of the file.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks reasonable enough to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 57d28dde5a78..d76116760ef6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -37,6 +37,32 @@ static kmem_zone_t *xfs_buf_zone;
>  #define xb_to_gfp(flags) \
>  	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : GFP_NOFS) | __GFP_NOWARN)
>  
> +/*
> + * Locking orders
> + *
> + * xfs_buf_ioacct_inc:
> + * xfs_buf_ioacct_dec:
> + *	b_sema (caller holds)
> + *	  b_lock
> + *
> + * xfs_buf_stale:
> + *	b_sema (caller holds)
> + *	  b_lock
> + *	    lru_lock
> + *
> + * xfs_buf_rele:
> + *	b_lock
> + *	  pag_buf_lock
> + *	    lru_lock
> + *
> + * xfs_buftarg_wait_rele
> + *	lru_lock
> + *	  b_lock (trylock due to inversion)
> + *
> + * xfs_buftarg_isolate
> + *	lru_lock
> + *	  b_lock (trylock due to inversion)
> + */
>  
>  static inline int
>  xfs_buf_is_vmapped(
> @@ -1036,8 +1062,18 @@ xfs_buf_rele(
>  
>  	ASSERT(atomic_read(&bp->b_hold) > 0);
>  
> -	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
> +	/*
> +	 * We grab the b_lock here first to serialise racing xfs_buf_rele()
> +	 * calls. The pag_buf_lock being taken on the last reference only
> +	 * serialises against racing lookups in xfs_buf_find(). IOWs, the second
> +	 * to last reference we drop here is not serialised against the last
> +	 * reference until we take bp->b_lock. Hence if we don't grab b_lock
> +	 * first, the last "release" reference can win the race to the lock and
> +	 * free the buffer before the second-to-last reference is processed,
> +	 * leading to a use-after-free scenario.
> +	 */
>  	spin_lock(&bp->b_lock);
> +	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
>  	if (!release) {
>  		/*
>  		 * Drop the in-flight state if the buffer is already on the LRU
> -- 
> 2.17.0
> 
