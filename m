Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541AF397E85;
	Thu, 23 Jul 2026 21:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840752; cv=none; b=qNcQZQpiAxKS4mXbZO7+B6Gua6SDVcEu0rc6fsJuA+GyTSSiYc3w3515Wuk7aZN7i4kdZI3zt0b8e62ZoQa+8R9GdItj/XRgMLgzZ7r+QrwxQEIvnjF5rTtW9a3LQPDDoAFDK3DGiKLyAvNk8BOHPWDyfZtGxY79UfRoJbHrl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840752; c=relaxed/simple;
	bh=+Gybw79nFPLeY9sLslTIobQ2V3DMD1xR9zrPDlOTZcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0Q7Kimgcr0s2UKWud9ckUnDtfZ5MUE2r75J0IMekSSvBlb3mf0nvVan/emN89sOnVsSyLL6KS7TzgkUy8g6asHVkxGaPnWWsZ4VqEhBh4Ut8gSiRjvqL/EFs6TC4ukiiZUVwnJEWtHPZzmzFWmQ42lvaKOFbwLD6mCYWlmnT/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ljd5dKto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ljd5dKto"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E84AA1F000E9;
	Thu, 23 Jul 2026 21:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840751;
	bh=2WyMVCvleZMXxjdJYaHcaJcfFZB/0d4Wussg0F4AzO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ljd5dKto2UxJXjZLjBtSBn5pREzTQj9npV4r/abEfQp6kBHhjis4Xyfq8vH0W6j01
	 7wjMWDPlP034qvS7zYHWZCYIHYsJYJVYh/yBgrzRN+Pvdj2j+enbm0WVcLgQtUjaNP
	 wjtsZrqnvvOpYg2A08hjWFe4wEeRkuMZ235zJ+7fHHQgVcar0vrePvINLns/71zi5r
	 N7OJJgchrnRoz0iPFOsewUfzHLlyysQpz/GbfKiMAPiEN4qSaUMlGrYKG/+2dnOoEh
	 jOG3dmd5107E20xWsKwQL082qxUU3W6QVj9rQgTkuqBx7V5z1uMT4yvV+8YQ6Z5By6
	 bObVUodusAk5g==
Date: Thu, 23 Jul 2026 14:05:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <20260723210550.GJ2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-21-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:45PM +0200, Christoph Hellwig wrote:
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

Mostly looks fine, with only a couple of questions...

> ---
>  fs/xfs/xfs_file.c  |  4 +-
>  fs/xfs/xfs_ioend.c | 99 ++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_mount.h |  8 ++++
>  fs/xfs/xfs_super.c |  1 +
>  fs/xfs/xfs_sysfs.c | 65 ++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h |  1 +
>  6 files changed, 172 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index d31a1dddcdc3..04301ab977a3 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -264,10 +264,8 @@ xfs_file_dio_read(
>  	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
>  	if (ret)
>  		return ret;
> -	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
> +	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
>  		dio_ops = &xfs_dio_read_bounce_ops;
> -		dio_flags |= IOMAP_DIO_BOUNCE;
> -	}
>  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, dio_ops, dio_flags,
>  			NULL, 0);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index a095cf217863..94a81fb679ed 100644
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
> @@ -18,15 +18,97 @@
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
> +
> +	trace_xfs_bounce_reread(XFS_I(ioend->io_inode), ioend->io_offset,
> +			ioend->io_size);
> +
> +	/*
> +	 * Free the bio integrity data for the original bio, as we'll allocate
> +	 * ons for each sub-I/O, which could deadlock if we keep the original
> +	 * one around.
> +	 */
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_free(bio);
> +
> +	/*
> +	 * Reset the remaining count, iter and bdev as we submit the bio to the
> +	 * block layer again and we need a clean slate.  Switch to and end_io
> +	 * handler that simply complets the ioend, as all the verification is
> +	 * done by the end_I/O handlers for the clone bio(s).
> +	 */
> +	atomic_set(&bio->__bi_remaining, 1);
> +	bio->bi_iter = (struct bvec_iter) {
> +		.bi_sector	= ioend->io_sector,
> +		.bi_size	= ioend->io_size,
> +		.bi_bvec_done	= ioend->io_bvec_offset,
> +	};
> +	bio->bi_bdev = xfs_inode_buftarg(XFS_I(ioend->io_inode))->bt_bdev;
> +	bio->bi_end_io = xfs_end_bio_bounced;
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

Ahah, yes we are being mean and making userspace wait for a slow bounce
buffer workaround if they mess with us.

> +				return;
> +			}
> +		}
> +	}
>  
>  	iomap_finish_ioends(ioend, error);
>  }
> @@ -38,7 +120,18 @@ xfs_ioend_submit_read(
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
> index 66a02d1b9ad7..6f8119bd959c 100644
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
> index 8531d526fc44..7c8424185e06 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2270,6 +2270,7 @@ xfs_init_fs_context(
>  	mp->m_logbufs = -1;
>  	mp->m_logbsize = -1;
>  	mp->m_allocsize_log = 16; /* 64k */
> +	mp->m_read_bounce = XFS_READ_BOUNCE_LAZY;
>  
>  	xfs_hooks_init(&mp->m_dir_update_hooks);
>  
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index b62712187324..1e44bb8b30e8 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -392,6 +392,63 @@ const struct kobj_type xfs_stats_ktype = {
>  	.default_groups = xfs_stats_groups,
>  };
>  
> +static inline struct xfs_mount *csum_to_mp(struct kobject *kobj)
> +{
> +	return container_of(to_kobj(kobj), struct xfs_mount, m_csum_kobj);
> +}
> +
> +static ssize_t
> +read_bounce_show(
> +	struct kobject		*kobj,
> +	char			*buf)
> +{
> +	struct xfs_mount	*mp = csum_to_mp(kobj);
> +
> +	switch (READ_ONCE(mp->m_read_bounce)) {
> +	case XFS_READ_BOUNCE_NEVER:
> +		return sysfs_emit(buf, "never\n");
> +	case XFS_READ_BOUNCE_ALWAYS:
> +		return sysfs_emit(buf, "always\n");
> +	case XFS_READ_BOUNCE_LAZY:
> +		return sysfs_emit(buf, "lazy\n");
> +	default:
> +		return sysfs_emit(buf, "invalid\n");
> +	}
> +}
> +
> +static ssize_t
> +read_bounce_store(
> +	struct kobject	*kobj,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	struct xfs_mount	*mp = csum_to_mp(kobj);
> +
> +	if (!strcmp(buf, "never"))
> +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_NEVER);
> +	else if (!strcmp(buf, "always"))
> +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_ALWAYS);
> +	else if (!strcmp(buf, "lazy"))
> +		WRITE_ONCE(mp->m_read_bounce, XFS_READ_BOUNCE_LAZY);
> +	else
> +		return -EINVAL;
> +
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
> @@ -837,6 +894,12 @@ xfs_mount_sysfs_init(
>  	if (error)
>  		goto out_remove_error_dir;
>  
> +	/* .../xfs/<dev>/csum/ */
> +	error = xfs_sysfs_init(&mp->m_csum_kobj, &xfs_csum_ktype,
> +			       &mp->m_kobj, "csum");
> +	if (error)
> +		goto out_remove_error_dir;

/me wonders if this is a debugging knob and therefore should go in
debugfs?  Or is there a solid usecase for normal sysadmins to be able to
control this?

--D

> +
>  	return 0;
>  
>  out_remove_error_dir:
> @@ -855,6 +918,8 @@ xfs_mount_sysfs_del(
>  	struct xfs_error_cfg	*cfg;
>  	int			i, j;
>  
> +	xfs_sysfs_del(&mp->m_csum_kobj);
> +
>  	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
>  		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
>  			cfg = &mp->m_error_cfg[i][j];
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index aeb89ac53bf1..af44551fd305 100644
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
