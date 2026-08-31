Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59FE43A7FD;
	Mon, 31 Aug 2026 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198423; cv=none; b=gdhM5L82UeV4BQeQRvGjypv+7rp2T4tp3C5sd6/ql6wWrYKV4BwL93TFBc8FZhIO3WZDjxJz+Fc0XgbLWzkwiOyegx9IltvuC7c7ohA2wf4mwml2HssamOFDBG93mYeflkxfhoUMyZqHP0Dr9ZCYPnAbIJnBjgO4sc/Wx3qbYPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198423; c=relaxed/simple;
	bh=lp0pt3eQuelvap2jGRnCRKBY8VOgl+64UYLDiV/t/wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpRi6FGVFliHEmWAn5fQyPX5UXYFbMVrgNc2Wl2Ty0KvF2sOGXcIzFUYW4dfIssPeqJ+CaynpD9GGfmRtN9Gz7/y5DjddfaFn6nZJiqzYBLFfWf2+dhDbpHO83w3jElnlJZRNSy+rsjm1DGyxh3yY6qPWVGswo+dZRFMK7SEXpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CW0o5x2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CW0o5x2b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8A84F1F000E9;
	Mon, 31 Aug 2026 17:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788198421;
	bh=tjmR8mO4gXi+Ev1cLEViq07AZKKrQ3SNBP9pzU6tMBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CW0o5x2biv1aQvtppfumrefnB5TPp7HadwNcn8dYXzUTMknnIJdJaq6SGkjp+5812
	 Utm5eycdDyDIda0LFUB9UIfDfYHu+i6/grS09sga8S+cCWppp54YodvMorHozZw8lh
	 /RtsZPfxNM/hKmY4DrR16vwboYaW29BT6PCBoKrsiOTMIsvb3Wh+Ty9McNRe5qHs35
	 iKxz1GFOsXEDTnAnfqsvBYupi5+jhKFq0kHg9lGzRCIs6WZTJ/P1QVymz9nzwAvOrv
	 u8knsoz1JpVVEmaxLrw5c9kE31odMDgooH+Kk1uUIDeGAc8xGvEc4aIwVLzzAp/3D6
	 7Kf0teBElOHIg==
Date: Mon, 31 Aug 2026 10:47:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <20260831174701.GC1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-15-hch@lst.de>

On Mon, Aug 31, 2026 at 09:40:02AM +0300, Christoph Hellwig wrote:
> Currently direct I/O reads always bounce buffer the I/O to deal with
> the case where userspace is modifying the buffer in-flight while
> reading data into it.
> 
> This is a very expensive countermeasure for something no sane application
> should do, so try to avoid it by reading without a bounce buffer first,
> and retrying the read on a checksum failure.  This avoids the cost of
> bounce buffering for sanely behave applications.  For the rare case of
> an application regularly modifying in-flight buffers, allow forcing the
> always bounce buffer behavior through sysfs.  And now that we have that
> knob, allow disabling read-side bounce buffering entirely for those who
> live fast and dangerous.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me now.  That sysfs_match_string macro is pretty neat.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c  |   3 +-
>  fs/xfs/xfs_ioend.c | 102 +++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_mount.h |   8 ++++
>  fs/xfs/xfs_super.c |   1 +
>  fs/xfs/xfs_sysfs.c |  76 +++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h |   1 +
>  6 files changed, 186 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 766c4d2055c1..daa6a854dd5f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -270,8 +270,7 @@ xfs_file_dio_read(
>  		return ret;
>  	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
>  		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
> -				&xfs_dio_read_bounce_ops, IOMAP_DIO_BOUNCE,
> -				NULL, 0);
> +				&xfs_dio_read_bounce_ops, 0, NULL, 0);
>  	} else {
>  		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin);
>  		if (ret == -ENOTBLK)
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index a095cf217863..c21cbd7b0a6d 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright (c) 2016-2025 Christoph Hellwig.
> + * Copyright (c) 2016-2026 Christoph Hellwig.
>   * All Rights Reserved.
>   */
>  #include "xfs_platform.h"
> @@ -18,15 +18,100 @@
>  #include "xfs_ioend.h"
>  #include <linux/bio-integrity.h>
>  
> +static void
> +xfs_end_bio_bounced(
> +	struct bio		*bio)
> +{
> +	iomap_finish_ioends(iomap_ioend_from_bio(bio),
> +			blk_status_to_errno(bio->bi_status));
> +}
> +
> +static void
> +xfs_dio_bounce_end_io(
> +	struct bio		*bio)
> +{
> +	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
> +	int			error = blk_status_to_errno(bio->bi_status);
> +	struct bio		*orig_bio = bio->bi_private;
> +
> +	if ((ioend->io_flags & IOMAP_IOEND_INTEGRITY) && !bio->bi_status)
> +		error = iomap_ioend_integrity_verify(ioend);
> +	iomap_bounce_read_end_io(ioend, orig_bio, error);
> +}
> +
> +static void
> +xfs_bounce_submit_ioend(
> +	struct iomap_ioend	*ioend)
> +{
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_alloc(&ioend->io_bio);
> +	ioend->io_bio.bi_end_io = xfs_dio_bounce_end_io;
> +	bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
> +	submit_bio(&ioend->io_bio);
> +}
> +
> +static void
> +xfs_read_bounce_and_resubmit(
> +	struct iomap_ioend	*ioend)
> +{
> +	struct bio		*bio = &ioend->io_bio;
> +	unsigned short		vcnt = bio->bi_vcnt;
> +	void			*private = bio->bi_private;
> +
> +	trace_xfs_bounce_reread(XFS_I(ioend->io_inode), ioend->io_offset,
> +			ioend->io_size);
> +
> +	/*
> +	 * Free the bio integrity data for the original bio, as we'll allocate
> +	 * ons for each sub-I/O, which could deadlock if we keep the original
> +	 * one around.
> +	 */
> +	if (bio_integrity(bio))
> +		fs_bio_integrity_free(bio);
> +
> +	/*
> +	 * Reset the bio to submit the bio to the block layer again.  Switch to
> +	 * an end_io handler that simply complets the ioend, as all verification
> +	 * is done by the end_I/O handlers for the clone bio(s).
> +	 */
> +	bio_reset(bio, xfs_inode_buftarg(XFS_I(ioend->io_inode))->bt_bdev,
> +			bio->bi_opf);
> +	bio->bi_vcnt = vcnt;
> +	bio->bi_private = private;
> +	bio->bi_end_io = xfs_end_bio_bounced;
> +	bio->bi_iter = (struct bvec_iter) {
> +		.bi_sector	= ioend->io_sector,
> +		.bi_size	= ioend->io_size,
> +		.bi_offset	= ioend->io_bvec_offset,
> +	};
> +	iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
> +			xfs_bounce_submit_ioend);
> +}
> +
>  static void
>  xfs_end_io_read(
>  	struct bio		*bio)
>  {
>  	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
>  	int			error = blk_status_to_errno(bio->bi_status);
>  
> -	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY))
> +	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY)) {
>  		error = iomap_ioend_integrity_verify(ioend);
> +		if ((ioend->io_flags & IOMAP_IOEND_DIRECT) &&
> +		    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_LAZY) {
> +			/*
> +			 * We only really need to retry for guard tag errors,
> +			 * but right now we can't distinguish them from other
> +			 * (i.e, reftag) errors.
> +			 */
> +			if (error) {
> +				xfs_read_bounce_and_resubmit(ioend);
> +				return;
> +			}
> +		}
> +	}
>  
>  	iomap_finish_ioends(ioend, error);
>  }
> @@ -38,7 +123,18 @@ xfs_ioend_submit_read(
>  	loff_t			file_offset,
>  	u16			ioend_flags)
>  {
> -	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct iomap_ioend	*ioend;
> +
> +	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
> +	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
> +	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
> +		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
> +				xfs_bounce_submit_ioend);
> +		return;
> +	}
> +
>  	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
>  		fs_bio_integrity_alloc(bio);
>  	bio->bi_end_io = xfs_end_io_read;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 216a38a354e7..894ff2f4ecbd 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -142,6 +142,12 @@ struct xfs_freecounter {
>  	uint64_t		res_saved;
>  };
>  
> +enum xfs_read_bounce {
> +	XFS_READ_BOUNCE_NEVER,
> +	XFS_READ_BOUNCE_ALWAYS,
> +	XFS_READ_BOUNCE_LAZY,
> +};
> +
>  /*
>   * The struct xfsmount layout is optimised to separate read-mostly variables
>   * from variables that are frequently modified. We put the read-mostly variables
> @@ -177,6 +183,7 @@ typedef struct xfs_mount {
>  	struct workqueue_struct	*m_sync_workqueue;
>  	struct workqueue_struct *m_blockgc_wq;
>  	struct workqueue_struct *m_inodegc_wq;
> +	enum xfs_read_bounce	m_read_bounce;
>  
>  	int			m_bsize;	/* fs logical block size */
>  	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
> @@ -291,6 +298,7 @@ typedef struct xfs_mount {
>  	struct xfs_zone_info	*m_zone_info;	/* zone allocator information */
>  	struct dentry		*m_debugfs;	/* debugfs parent */
>  	struct xfs_kobj		m_kobj;
> +	struct xfs_kobj		m_csum_kobj;
>  	struct xfs_kobj		m_error_kobj;
>  	struct xfs_kobj		m_error_meta_kobj;
>  	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b24db75eaedc..fce1d2905c94 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2317,6 +2317,7 @@ xfs_init_fs_context(
>  	mp->m_logbufs = -1;
>  	mp->m_logbsize = -1;
>  	mp->m_allocsize_log = 16; /* 64k */
> +	mp->m_read_bounce = XFS_READ_BOUNCE_LAZY;
>  
>  	xfs_hooks_init(&mp->m_dir_update_hooks);
>  
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index b62712187324..2e969e8f279f 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -392,6 +392,57 @@ const struct kobj_type xfs_stats_ktype = {
>  	.default_groups = xfs_stats_groups,
>  };
>  
> +static inline struct xfs_mount *csum_to_mp(struct kobject *kobj)
> +{
> +	return container_of(to_kobj(kobj), struct xfs_mount, m_csum_kobj);
> +}
> +
> +static const char * const bounce_modes[] = {
> +	[XFS_READ_BOUNCE_NEVER]		= "never",
> +	[XFS_READ_BOUNCE_ALWAYS]	= "always",
> +	[XFS_READ_BOUNCE_LAZY]		= "lazy",
> +};
> +
> +static ssize_t
> +read_bounce_show(
> +	struct kobject		*kobj,
> +	char			*buf)
> +{
> +	struct xfs_mount	*mp = csum_to_mp(kobj);
> +
> +	return sysfs_emit(buf, "%s\n",
> +			bounce_modes[READ_ONCE(mp->m_read_bounce)]);
> +}
> +
> +static ssize_t
> +read_bounce_store(
> +	struct kobject		*kobj,
> +	const char		*buf,
> +	size_t			count)
> +{
> +	struct xfs_mount	*mp = csum_to_mp(kobj);
> +	int			ret;
> +
> +	ret = sysfs_match_string(bounce_modes, buf);
> +	if (ret < 0)
> +		return ret;
> +	WRITE_ONCE(mp->m_read_bounce, ret);
> +	return count;
> +}
> +XFS_SYSFS_ATTR_RW(read_bounce);
> +
> +static struct attribute *xfs_csum_attrs[] = {
> +	ATTR_LIST(read_bounce),
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(xfs_csum);
> +
> +static const struct kobj_type xfs_csum_ktype = {
> +	.release = xfs_sysfs_release,
> +	.sysfs_ops = &xfs_sysfs_ops,
> +	.default_groups = xfs_csum_groups,
> +};
> +
>  /* xlog */
>  
>  static inline struct xlog *
> @@ -797,6 +848,18 @@ xfs_zoned_sysfs_del(struct xfs_mount *mp)
>  		xfs_sysfs_del(&mp->m_zoned_kobj);
>  }
>  
> +static bool
> +xfs_has_read_bounce(
> +	struct xfs_mount	*mp)
> +{
> +	if (bdev_has_integrity_csum(mp->m_ddev_targp->bt_bdev))
> +		return true;
> +	if (mp->m_rtdev_targp &&
> +	    bdev_has_integrity_csum(mp->m_rtdev_targp->bt_bdev))
> +		return true;
> +	return false;
> +}
> +
>  int
>  xfs_mount_sysfs_init(
>  	struct xfs_mount	*mp)
> @@ -837,8 +900,18 @@ xfs_mount_sysfs_init(
>  	if (error)
>  		goto out_remove_error_dir;
>  
> +	if (xfs_has_read_bounce(mp)) {
> +		/* .../xfs/<dev>/csum/ */
> +		error = xfs_sysfs_init(&mp->m_csum_kobj, &xfs_csum_ktype,
> +				       &mp->m_kobj, "csum");
> +		if (error)
> +			goto out_remove_error_metadata_dir;
> +	}
> +
>  	return 0;
>  
> +out_remove_error_metadata_dir:
> +	xfs_sysfs_del(&mp->m_error_meta_kobj);
>  out_remove_error_dir:
>  	xfs_sysfs_del(&mp->m_error_kobj);
>  out_remove_stats_dir:
> @@ -855,6 +928,9 @@ xfs_mount_sysfs_del(
>  	struct xfs_error_cfg	*cfg;
>  	int			i, j;
>  
> +	if (xfs_has_read_bounce(mp))
> +		xfs_sysfs_del(&mp->m_csum_kobj);
> +
>  	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
>  		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
>  			cfg = &mp->m_error_cfg[i][j];
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f333c938fbd9..2af9a1429ae9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1896,6 +1896,7 @@ DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
>  DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
>  DEFINE_SIMPLE_IO_EVENT(xfs_file_splice_read);
>  DEFINE_SIMPLE_IO_EVENT(xfs_zoned_map_blocks);
> +DEFINE_SIMPLE_IO_EVENT(xfs_bounce_reread);
>  
>  DECLARE_EVENT_CLASS(xfs_itrunc_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
> -- 
> 2.53.0
> 
> 
