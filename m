Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55188 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbeJJU63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 16:58:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id r63-v6so5523565wma.4
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 06:36:15 -0700 (PDT)
Date: Wed, 10 Oct 2018 15:36:11 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: fix use-after-free race in xfs_buf_rele
Message-ID: <20181010133611.j4yuyyqbj2fbv3lc@odin.usersys.redhat.com>
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


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>



> ---
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

-- 
Carlos
