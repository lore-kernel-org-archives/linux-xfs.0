Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62835C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 01:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3190661058
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 01:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhHSB7m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 21:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhHSB7m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 21:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6F760EBD;
        Thu, 19 Aug 2021 01:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629338346;
        bh=g21vDpuWGFBQnc4hJUSTMfUOd89klkl7OIShixpQGts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nQOipXsxn27PJGgtwJJH/I5dxlQYWxYbQioov3Rs228jWtTRG5Fp056qXuNIKpOTv
         U4M/W8EjqrmgSDLZgsxIF6USrFt76CacWgBvPa0CRy1pBiAqAT6QPmr5h5MZmCPXhn
         vDoTOJsS2NsDwIk5okyZf1ife4lwxD/LWgcMu61xb++ThLrAa4UdDkF3eqt+kjh7tK
         k3o+sk+zjSONjh1h/3nupsPlq/qHT8TMAT2ukhBXBuxj1p7oypDq1ZnvsBnbYIqtsJ
         53skmg8jrGUZflyED3jfnnY/3p4clNsshfKixIUrtPUQJwVnaJeiDyMzGkB+d+QTJQ
         VZOr/FwKFgExw==
Date:   Wed, 18 Aug 2021 18:59:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rename buffer cache index variable b_bn
Message-ID: <20210819015906.GJ12640@magnolia>
References: <20210819000055.149955-1-david@fromorbit.com>
 <20210819000055.149955-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819000055.149955-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 19, 2021 at 10:00:55AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To stop external users from using b_bn as the disk address of the
> buffer, rename it to b_rhash_key to indicate that it is the buffer
> cache index, not the block number of the buffer. Code that needs the
> disk address should use xfs_buf_daddr() to obtain it.
> 
> Do the rename and clean up any of the remaining internal b_bn users.
> Also clean up any remaining b_bn cruft that is now unused.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Haaaa my brain didn't fall out!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 19 +++++++++++--------
>  fs/xfs/xfs_buf.h | 18 +-----------------
>  2 files changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c1bb6e41595b..047bd6e3f389 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -251,7 +251,7 @@ _xfs_buf_alloc(
>  		return error;
>  	}
>  
> -	bp->b_bn = map[0].bm_bn;
> +	bp->b_rhash_key = map[0].bm_bn;
>  	bp->b_length = 0;
>  	for (i = 0; i < nmaps; i++) {
>  		bp->b_maps[i].bm_bn = map[i].bm_bn;
> @@ -459,7 +459,7 @@ _xfs_buf_obj_cmp(
>  	 */
>  	BUILD_BUG_ON(offsetof(struct xfs_buf_map, bm_bn) != 0);
>  
> -	if (bp->b_bn != map->bm_bn)
> +	if (bp->b_rhash_key != map->bm_bn)
>  		return 1;
>  
>  	if (unlikely(bp->b_length != map->bm_len)) {
> @@ -481,7 +481,7 @@ static const struct rhashtable_params xfs_buf_hash_params = {
>  	.min_size		= 32,	/* empty AGs have minimal footprint */
>  	.nelem_hint		= 16,
>  	.key_len		= sizeof(xfs_daddr_t),
> -	.key_offset		= offsetof(struct xfs_buf, b_bn),
> +	.key_offset		= offsetof(struct xfs_buf, b_rhash_key),
>  	.head_offset		= offsetof(struct xfs_buf, b_rhash_head),
>  	.automatic_shrinking	= true,
>  	.obj_cmpfn		= _xfs_buf_obj_cmp,
> @@ -853,7 +853,9 @@ xfs_buf_readahead_map(
>  
>  /*
>   * Read an uncached buffer from disk. Allocates and returns a locked
> - * buffer containing the disk contents or nothing.
> + * buffer containing the disk contents or nothing. Uncached buffers always have
> + * a cache index of XFS_BUF_DADDR_NULL so we can easily determine if the buffer
> + * is cached or uncached during fault diagnosis.
>   */
>  int
>  xfs_buf_read_uncached(
> @@ -875,7 +877,7 @@ xfs_buf_read_uncached(
>  
>  	/* set up the buffer for a read IO */
>  	ASSERT(bp->b_map_count == 1);
> -	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
> +	bp->b_rhash_key = XFS_BUF_DADDR_NULL;
>  	bp->b_maps[0].bm_bn = daddr;
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
> @@ -1513,7 +1515,7 @@ _xfs_buf_ioapply(
>  						   SHUTDOWN_CORRUPT_INCORE);
>  				return;
>  			}
> -		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
> +		} else if (bp->b_rhash_key != XFS_BUF_DADDR_NULL) {
>  			struct xfs_mount *mp = bp->b_mount;
>  
>  			/*
> @@ -1523,7 +1525,8 @@ _xfs_buf_ioapply(
>  			if (xfs_has_crc(mp)) {
>  				xfs_warn(mp,
>  					"%s: no buf ops on daddr 0x%llx len %d",
> -					__func__, bp->b_bn, bp->b_length);
> +					__func__, xfs_buf_daddr(bp),
> +					bp->b_length);
>  				xfs_hex_dump(bp->b_addr,
>  						XFS_CORRUPTION_DUMP_LEN);
>  				dump_stack();
> @@ -1793,7 +1796,7 @@ xfs_buftarg_drain(
>  				xfs_buf_alert_ratelimited(bp,
>  					"XFS: Corruption Alert",
>  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> -					(long long)bp->b_bn);
> +					(long long)xfs_buf_daddr(bp));
>  			}
>  			xfs_buf_rele(bp);
>  		}
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 6db2fba44b46..6b0200b8007d 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -134,11 +134,7 @@ struct xfs_buf {
>  	 */
>  	struct rhash_head	b_rhash_head;	/* pag buffer hash node */
>  
> -	/*
> -	 * b_bn is the cache index. Do not use directly, use b_maps[0].bm_bn
> -	 * for the buffer disk address instead.
> -	 */
> -	xfs_daddr_t		b_bn;
> +	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
>  	atomic_t		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
> @@ -301,18 +297,6 @@ extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
>  extern int xfs_buf_init(void);
>  extern void xfs_buf_terminate(void);
>  
> -/*
> - * These macros use the IO block map rather than b_bn. b_bn is now really
> - * just for the buffer cache index for cached buffers. As IO does not use b_bn
> - * anymore, uncached buffers do not use b_bn at all and hence must modify the IO
> - * map directly. Uncached buffers are not allowed to be discontiguous, so this
> - * is safe to do.
> - *
> - * In future, uncached buffers will pass the block number directly to the io
> - * request function and hence these macros will go away at that point.
> - */
> -#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_maps[0].bm_bn = (xfs_daddr_t)(bno))
> -
>  static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
>  {
>  	return bp->b_maps[0].bm_bn;
> -- 
> 2.31.1
> 
