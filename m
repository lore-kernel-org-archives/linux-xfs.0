Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdFFTEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2017 15:04:11 -0400
Date: Tue, 06 Jun 2017 15:04:08 -0400 (EDT)
Message-Id: <20170606.150408.1629203951871477326.davem@davemloft.net>
Subject: Re: crypto: Work around deallocated stack frame reference gcc bug
 on sparc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170602.112854.571030442583332811.davem@davemloft.net>
References: <20170602.112854.571030442583332811.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, matorola@gmail.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 02 Jun 2017 11:28:54 -0400 (EDT)

> 
> On sparc, if we have an alloca() like situation, as is the case with
> SHASH_DESC_ON_STACK(), we can end up referencing deallocated stack
> memory.  The result can be that the value is clobbered if a trap
> or interrupt arrives at just the right instruction.
> 
> It only occurs if the function ends returning a value from that
> alloca() area and that value can be placed into the return value
> register using a single instruction.
> 
> For example, in lib/libcrc32c.c:crc32c() we end up with a return
> sequence like:
> 
>         return  %i7+8
>          lduw   [%o5+16], %o0   ! MEM[(u32 *)__shash_desc.1_10 + 16B],
> 
> %o5 holds the base of the on-stack area allocated for the shash
> descriptor.  But the return released the stack frame and the
> register window.
> 
> So if an intererupt arrives between 'return' and 'lduw', then
> the value read at %o5+16 can be corrupted.
> 
> Add a data compiler barrier to work around this problem.  This is
> exactly what the gcc fix will end up doing as well, and it absolutely
> should not change the code generated for other cpus (unless gcc
> on them has the same bug :-)
> 
> With crucial insight from Eric Sandeen.
> 
> Reported-by: Anatoly Pugachev <matorola@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Herbert, please take a look at this and push via your crypto tree
and submit to -stable if you don't have any objections.

Thanks!

> ---
> 
> See the thread anchored at:
> 
> 	http://marc.info/?l=linux-sparc&m=149623182616944&w=2
> 
> for discussion, it has a reproducer module.  The problem was
> first noticed as occaisional XFS checksum corruptions.
> 
> Herbert, I don't expect you to like this but it is the best we can do
> I think.  It should not pessimize code on other architectures at all.
> I will work on fixing the gcc bug but it's been around forever and all
> versions are effected.
> 
> I noticed while working on this that at least btrfs duplicates the
> facilities provided by lib/libcrc32c.c and therefore should probably
> be converted over to straight crc32c() calls if possible.
> 
> Thanks!
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
> index ecdba2f..1ac5b85 100644
> --- a/drivers/infiniband/sw/rxe/rxe.h
> +++ b/drivers/infiniband/sw/rxe/rxe.h
> @@ -68,6 +68,7 @@
>  static inline u32 rxe_crc32(struct rxe_dev *rxe,
>  			    u32 crc, void *next, size_t len)
>  {
> +	u32 retval;
>  	int err;
>  
>  	SHASH_DESC_ON_STACK(shash, rxe->tfm);
> @@ -81,7 +82,9 @@ static inline u32 rxe_crc32(struct rxe_dev *rxe,
>  		return crc32_le(crc, next, len);
>  	}
>  
> -	return *(u32 *)shash_desc_ctx(shash);
> +	retval = *(u32 *)shash_desc_ctx(shash);
> +	barrier_data(shash_desc_ctx(shash));
> +	return retval;
>  }
>  
>  int rxe_set_mtu(struct rxe_dev *rxe, unsigned int dev_mtu);
> diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
> index a97fdc1..baacc18 100644
> --- a/fs/btrfs/hash.c
> +++ b/fs/btrfs/hash.c
> @@ -38,6 +38,7 @@ u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
>  {
>  	SHASH_DESC_ON_STACK(shash, tfm);
>  	u32 *ctx = (u32 *)shash_desc_ctx(shash);
> +	u32 retval;
>  	int err;
>  
>  	shash->tfm = tfm;
> @@ -47,5 +48,7 @@ u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
>  	err = crypto_shash_update(shash, address, length);
>  	BUG_ON(err);
>  
> -	return *ctx;
> +	retval = *ctx;
> +	barrier_data(ctx);
> +	return retval;
>  }
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 2185c7a..fd2e651 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1078,6 +1078,7 @@ static inline u32 f2fs_crc32(struct f2fs_sb_info *sbi, const void *address,
>  {
>  	SHASH_DESC_ON_STACK(shash, sbi->s_chksum_driver);
>  	u32 *ctx = (u32 *)shash_desc_ctx(shash);
> +	u32 retval;
>  	int err;
>  
>  	shash->tfm = sbi->s_chksum_driver;
> @@ -1087,7 +1088,9 @@ static inline u32 f2fs_crc32(struct f2fs_sb_info *sbi, const void *address,
>  	err = crypto_shash_update(shash, address, length);
>  	BUG_ON(err);
>  
> -	return *ctx;
> +	retval = *ctx;
> +	barrier_data(ctx);
> +	return retval;
>  }
>  
>  static inline bool f2fs_crc_valid(struct f2fs_sb_info *sbi, __u32 blk_crc,
> diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
> index 74a54b7..9f79547 100644
> --- a/lib/libcrc32c.c
> +++ b/lib/libcrc32c.c
> @@ -43,7 +43,7 @@ static struct crypto_shash *tfm;
>  u32 crc32c(u32 crc, const void *address, unsigned int length)
>  {
>  	SHASH_DESC_ON_STACK(shash, tfm);
> -	u32 *ctx = (u32 *)shash_desc_ctx(shash);
> +	u32 ret, *ctx = (u32 *)shash_desc_ctx(shash);
>  	int err;
>  
>  	shash->tfm = tfm;
> @@ -53,7 +53,9 @@ u32 crc32c(u32 crc, const void *address, unsigned int length)
>  	err = crypto_shash_update(shash, address, length);
>  	BUG_ON(err);
>  
> -	return *ctx;
> +	ret = *ctx;
> +	barrier_data(ctx);
> +	return ret;
>  }
>  
>  EXPORT_SYMBOL(crc32c);
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
