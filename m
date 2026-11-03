Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698768;
	b=OpkokGhoLojdyJymjEOuIHJV1Dv2KFMyc6PeBU1nxnnTXcp7BZMW6c+8C7AGp2zWeiBv
	 5FsA13r4E5COSR/en0ecTxAf8CvGAHeCjgTlffs2W6eZ5gaqPF/VhOCU+2Ltitx4G7Hjo
	 sn4tV5jT+CfwdcbKyoBkazKw9s6UDK3JjrDE4jnnudnIpjRoRo2zdKmpiXKJIk4pVUY8e
	 bb4t4LfJbPiQ9vP5B+6eroHDIaTooe7/6KIN4EWMW3imcFHRGzmlj/pCe/5fb2bApxMFV
	 WlUQCxEor1GlbmkwZP+tnQmDDfuzgt+ivbkQYrkI9MD93Vj86mUpOCaefi38mwp01WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698768;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=Tsc8WvdzvQnvKwW8dRKLrSj5p8SqIaPP8sNC6YDx2JE=;
	b=LzbwC0NHqlNwXJ16rBbhRB6THPeSSQeBFdLvYJNcfGr0pCV4OAQxA1jYnkPErhh27slJ
	 6sPC9ZAFjIR/PdsZsvxL0azzrIe1OttyVLFoTlRZwgJC9QDr1VlUb37/8tmd34ebVkdb+
	 i2L9MmYEHY9MaM+TcIaEGsoJr/KFgAJv4DrDx2hIvZ9Th+7ezPgjBVAKmExDgjrQ57JoW
	 b3GfjTac9Jwlzn9eROxhTym54Soeu5S9VuxXC+/OmALCc+0kXe2UEzwSneeLCJeWWMQaR
	 f3HqygSCLJqNJ/3WXQiBoxDDn1oL556Q6PbJH8lB/ZzQLQNVgCy6A6OnlEC+Kz7Cu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=16UAmyTh;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4855B606A324;
	Tue,  3 Nov 2026 09:39:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4855B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=16UAmyTh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tsc8WvdzvQnvKwW8dRKLrSj5p8SqIaPP8sNC6YDx2JE=; b=16UAmyTh2p2R/BFDp82yhRzhqN
	q9psO2ydaXh7ytp0tIQi2WSeyEb7gHbaiwpiMGCwN0JtmCdo9yF5GUtgdTKjVIVFj4WodHUg9z3CT
	ViK53dREoD2C9VbwyzJ9+ZqYS7K0bg/9N2TnZ44SpgIqu1s4RztTGA20WvUKd7j9woWEPPIk3sJ7D
	ZzFv2xAcZROu9WwcBybKv/EmZseb67+v5bbnRY9djmqoH1cMImwknsiXhjThWzLGJ9KES1540PTY/
	/0sS1uFyGhSX9FAWZc9Bznfx9eNBhooCP9ViK1qyapv+VK68XRnAEbpyeOH0S42s0L1tPcvfOvDvB
	8Mtb5Ulw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOAzG-00000001m3I-2xTA;
	Tue, 03 Nov 2026 09:39:26 +0000
Date: Tue, 3 Nov 2026 01:39:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v18 06/15] xfs: use read ioend for fsverity data
 verification
Message-ID: <aumrzsZMTIwJDOo1@infradead.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-7-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102144147.2393369-7-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good modulo the xfs_fsverity.h issue:

Reviewed-by: Christoph Hellwig <hch@lst.de>

On Mon, Nov 02, 2026 at 03:41:36PM +0100, Andrey Albershteyn wrote:
> Use read ioends for fsverity verification. Do not issue fsverity
> metadata I/O through the same workqueue due to risk of a deadlock by a
> filled workqueue.
> 
> Pass fsverity_info from iomap context down to the ioend as hashtable
> lookups are expensive.
> 
> Add a simple helper to check that this is not fsverity metadata but file
> data that needs verification.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/Makefile       |  1 +
>  fs/xfs/xfs_aops.c     | 12 ++++++----
>  fs/xfs/xfs_file.c     |  3 ++-
>  fs/xfs/xfs_fsverity.c | 46 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_fsverity.h | 40 ++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioend.c    | 53 ++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_ioend.h    |  4 +++-
>  fs/xfs/xfs_super.c    | 24 +++++++++++++++++++-
>  8 files changed, 169 insertions(+), 14 deletions(-)
>  create mode 100644 fs/xfs/xfs_fsverity.c
>  create mode 100644 fs/xfs/xfs_fsverity.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index cb7f71457ee9..9edb2850f094 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -151,6 +151,7 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
>  xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
>  xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
> +xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
>  
>  # notify failure
>  ifeq ($(CONFIG_MEMORY_FAILURE),y)
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 19640e4e3ed1..2f6e87991d83 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -611,7 +611,7 @@ xfs_bio_submit_read(
>  {
>  	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
>  			ctx->read_ctx_file_offset,
> -			iomap_ioend_flags(&iter->iomap));
> +			iomap_ioend_flags(&iter->iomap), ctx->vi);
>  	ctx->read_ctx = NULL;
>  }
>  
> @@ -623,11 +623,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
>  
>  static inline const struct iomap_read_ops *
>  xfs_get_iomap_read_ops(
> -	const struct address_space	*mapping)
> +	const struct address_space	*mapping,
> +	loff_t				pos)
>  {
>  	struct xfs_inode		*ip = XFS_I(mapping->host);
>  
> -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
> +	    xfs_fsverity_is_file_data(ip, pos))
>  		return &xfs_iomap_read_ops;
>  	return &iomap_bio_read_ops;
>  }
> @@ -639,7 +641,7 @@ xfs_vm_read_folio(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
> +	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
>  	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
>  	return 0;
>  }
> @@ -650,7 +652,7 @@ xfs_vm_readahead(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .rac = rac };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
> +	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
>  	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
>  }
>  
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f0d000272521..dbb5f8f59678 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -224,7 +224,8 @@ xfs_dio_read_bounce_submit_io(
>  	loff_t			file_offset)
>  {
>  	xfs_ioend_submit_read(iter->inode, bio, file_offset,
> -			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> +			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT,
> +			NULL);
>  }
>  
>  static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> new file mode 100644
> index 000000000000..8fc3e763c017
> --- /dev/null
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -0,0 +1,46 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 Red Hat, Inc.
> + */
> +#include "xfs_platform.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_fsverity.h"
> +#include <linux/fsverity.h>
> +#include <linux/iomap.h>
> +
> +struct kmem_cache *xfs_fsverity_ioend_cache;
> +mempool_t xfs_fsverity_ioend_pool;
> +
> +#define XFS_FSVERITY_IOEND_POOL_MIN	128
> +
> +/*
> + * Back the fsverity ioend allocations with a mempool so that read I/O
> + * completion always makes forward progress and cannot deadlock
> + */
> +int
> +xfs_fsverity_init(void)
> +{
> +	return mempool_init_slab_pool(&xfs_fsverity_ioend_pool,
> +			XFS_FSVERITY_IOEND_POOL_MIN, xfs_fsverity_ioend_cache);
> +}
> +
> +void
> +xfs_fsverity_exit(void)
> +{
> +	mempool_exit(&xfs_fsverity_ioend_pool);
> +}
> +
> +bool
> +xfs_fsverity_is_file_data(
> +	const struct xfs_inode	*ip,
> +	loff_t			offset)
> +{
> +	return fsverity_active(VFS_IC(ip)) &&
> +			offset < xfs_fsverity_metadata_offset(ip);
> +}
> diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
> new file mode 100644
> index 000000000000..44f7bc7831f2
> --- /dev/null
> +++ b/fs/xfs/xfs_fsverity.h
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 Red Hat, Inc.
> + */
> +#ifndef __XFS_FSVERITY_H__
> +#define __XFS_FSVERITY_H__
> +
> +#include "xfs_platform.h"
> +#include "xfs_verity.h"
> +#include <linux/iomap.h>
> +#include <linux/mempool.h>
> +
> +#ifdef CONFIG_FS_VERITY
> +int xfs_fsverity_init(void);
> +void xfs_fsverity_exit(void);
> +bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
> +#else
> +static inline int xfs_fsverity_init(void)
> +{
> +	return 0;
> +}
> +static inline void xfs_fsverity_exit(void)
> +{
> +}
> +static inline bool xfs_fsverity_is_file_data(const struct xfs_inode *ip,
> +					    loff_t offset)
> +{
> +	return false;
> +}
> +#endif	/* CONFIG_FS_VERITY */
> +
> +struct xfs_fsverity_ioend {
> +	struct iomap_ioend	*ioend;
> +	struct work_struct	work;
> +};
> +
> +extern struct kmem_cache *xfs_fsverity_ioend_cache;
> +extern mempool_t xfs_fsverity_ioend_pool;
> +
> +#endif	/* __XFS_FSVERITY_H__ */
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index 48becc3bf608..d30aee973a87 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -18,7 +18,26 @@
>  #include "xfs_ioend.h"
>  #include "xfs_error.h"
>  #include "xfs_errortag.h"
> +#include "xfs_fsverity.h"
>  #include <linux/bio-integrity.h>
> +#include <linux/fsverity.h>
> +
> +static void
> +xfs_end_fsverity_io_read(
> +	struct work_struct		*work)
> +{
> +	struct xfs_fsverity_ioend	*fsv_ioend =
> +			container_of(work, struct xfs_fsverity_ioend, work);
> +	struct iomap_ioend		*ioend = fsv_ioend->ioend;
> +	struct bio			*bio = &ioend->io_bio;
> +
> +	mempool_free(fsv_ioend, &xfs_fsverity_ioend_pool);
> +
> +	if (!bio->bi_status)
> +		fsverity_verify_bio(ioend->io_vi, bio);
> +
> +	iomap_finish_ioends(ioend, blk_status_to_errno(bio->bi_status));
> +}
>  
>  static void
>  xfs_dio_bounce_end_io(
> @@ -93,12 +112,14 @@ xfs_read_bounce_and_resubmit(
>  
>  static void
>  xfs_end_io_read(
> -	struct bio		*bio)
> +	struct bio			*bio)
>  {
> -	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
> -	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	int			error = blk_status_to_errno(bio->bi_status);
> +	struct iomap_ioend		*ioend = iomap_ioend_from_bio(bio);
> +	struct xfs_inode		*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount		*mp = ip->i_mount;
> +	int				error =
> +			blk_status_to_errno(bio->bi_status);
> +	struct xfs_fsverity_ioend	*fsv_ioend;
>  
>  	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY)) {
>  		error = iomap_ioend_integrity_verify(ioend);
> @@ -117,6 +138,24 @@ xfs_end_io_read(
>  		}
>  	}
>  
> +	/*
> +	 * If we have fsverity on this bio, we need to run fsverity verification
> +	 * of data folios from a separate fsverity workqueue. This is necessary
> +	 * to avoid deadlocking due to fsverity issuing more reads of fsverity
> +	 * metadata which would be processed by the same worker in the BIO
> +	 * completion workqueue.
> +	 */
> +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
> +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
> +		fsv_ioend = mempool_alloc(&xfs_fsverity_ioend_pool,
> +				GFP_NOFS);
> +		fsv_ioend->ioend = ioend;
> +		INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
> +
> +		fsverity_enqueue_verify_work(&fsv_ioend->work);
> +		return;
> +	}
> +
>  	iomap_finish_ioends(ioend, error);
>  }
>  
> @@ -125,13 +164,15 @@ xfs_ioend_submit_read(
>  	struct inode		*inode,
>  	struct bio		*bio,
>  	loff_t			file_offset,
> -	u16			ioend_flags)
> +	u16			ioend_flags,
> +	struct fsverity_info	*vi)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct iomap_ioend	*ioend;
>  
>  	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
> +	ioend->io_vi = vi;
>  	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
>  	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
>  		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
> diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
> index 7c2a1ea3e6ed..992c248a693a 100644
> --- a/fs/xfs/xfs_ioend.h
> +++ b/fs/xfs/xfs_ioend.h
> @@ -2,6 +2,8 @@
>  #ifndef __XFS_IOEND_H
>  #define __XFS_IOEND_H
>  
> +#include <linux/fsverity.h>
> +
>  /*
>   * Fast and loose check if this write could update the on-disk inode size.
>   */
> @@ -13,6 +15,6 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
>  
>  void xfs_end_bio(struct bio *bio);
>  void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
> -		loff_t file_offset, u16 ioend_flags);
> +		loff_t file_offset, u16 ioend_flags, struct fsverity_info *vi);
>  
>  #endif /* __XFS_IOEND_H */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a06132aa384..3a7d7334e9a6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2516,8 +2516,20 @@ xfs_init_caches(void)
>  	if (!xfs_parent_args_cache)
>  		goto out_destroy_xmi_cache;
>  
> +#ifdef CONFIG_FS_VERITY
> +	xfs_fsverity_ioend_cache = kmem_cache_create("xfs_fsverity_ioend",
> +					     sizeof(struct xfs_fsverity_ioend),
> +					     0, 0, NULL);
> +	if (!xfs_fsverity_ioend_cache)
> +		goto out_destroy_parent_args_cache;
> +#endif
> +
>  	return 0;
>  
> +#ifdef CONFIG_FS_VERITY
> + out_destroy_parent_args_cache:
> +	kmem_cache_destroy(xfs_parent_args_cache);
> +#endif
>   out_destroy_xmi_cache:
>  	kmem_cache_destroy(xfs_xmi_cache);
>   out_destroy_xmd_cache:
> @@ -2580,6 +2592,9 @@ xfs_destroy_caches(void)
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> +#ifdef CONFIG_FS_VERITY
> +	kmem_cache_destroy(xfs_fsverity_ioend_cache);
> +#endif
>  	kmem_cache_destroy(xfs_parent_args_cache);
>  	kmem_cache_destroy(xfs_xmd_cache);
>  	kmem_cache_destroy(xfs_xmi_cache);
> @@ -2660,10 +2675,14 @@ init_xfs_fs(void)
>  	if (error)
>  		goto out;
>  
> -	error = xfs_init_workqueues();
> +	error = xfs_fsverity_init();
>  	if (error)
>  		goto out_destroy_caches;
>  
> +	error = xfs_init_workqueues();
> +	if (error)
> +		goto out_fsverity_exit;
> +
>  	error = xfs_mru_cache_init();
>  	if (error)
>  		goto out_destroy_wq;
> @@ -2740,6 +2759,8 @@ init_xfs_fs(void)
>  	xfs_mru_cache_uninit();
>   out_destroy_wq:
>  	xfs_destroy_workqueues();
> + out_fsverity_exit:
> +	xfs_fsverity_exit();
>   out_destroy_caches:
>  	xfs_destroy_caches();
>   out:
> @@ -2763,6 +2784,7 @@ exit_xfs_fs(void)
>  	xfs_cleanup_procfs();
>  	xfs_mru_cache_uninit();
>  	xfs_destroy_workqueues();
> +	xfs_fsverity_exit();
>  	xfs_destroy_caches();
>  	xfs_uuid_table_free();
>  }
> -- 
> 2.54.0
> 
> 
---end quoted text---
