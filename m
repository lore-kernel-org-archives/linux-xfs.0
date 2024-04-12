Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71EA14D44F
	for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2024 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943598; cv=none; b=UUbGtHA+tlG1GOpELz98n/sioWgu4Qh8wgPsluByElb5W9lXMqMS75eBLO3YhFvMniJ3n3XbXEYlDnyn/diWAG0RFKdrzcDKzIEJ66qC9zGp9XD5vxeXK5warGDdKEcX/d6VM6eEAHsKantLHS0qGNG2GhK710utyCQzmb+bU3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943598; c=relaxed/simple;
	bh=a/J4C71u0M8a5MYFwNDqtVhOWtrHRYrdLPnMUa2Xbr0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUd8ujleIj9mGnSz3xcnllddaHla0ZqZd/cEANMQCaeYQ1AKziZGSWO1cBc+HIsVX9/SYtvdv5w46ijVSTruOtd2Bkb5pNL2Rwq8+sGY20nNpMOJzhMIUlnZXZI/Z86hbPj1Zr0GSGn3XoCOCwZPIRLxr/L5dn2f9GBzgCoKelg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RveCzzx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RveCzzx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F461C113CC;
	Fri, 12 Apr 2024 17:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712943598;
	bh=a/J4C71u0M8a5MYFwNDqtVhOWtrHRYrdLPnMUa2Xbr0=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=RveCzzx5rigCivWC8Vfq9hcdinEruh+3Hc8FD5BSslKmsyAeT+uX9IkEo6bzdku/8
	 sI05qIagC1XJOX13YIemsyWWlkRZL61sOcT59spKSjIoJJB8pYaQLTdQwfzelfjgAF
	 aP3pm87RkQHFiLOoZWJiAANyH08eHM1T+dWdXUL3QOrsd404e3g2+bdLB0sbcpFCDq
	 2AML5BVBrbi+7vzDXk87seKP7jbhpi3TTrw7w/+gAQ4sXWPMoZE1egJkHltqgG9Cox
	 HzqZxVfvCr8xjx7d/WGXQzF3rMGDRrN3V9xzO9wQNxzf///zXcFP+O7DmybBY6XzQA
	 Lrfi9BzdSm7DQ==
Date: Fri, 12 Apr 2024 10:39:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240412173957.GB11948@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>

On Tue, Apr 09, 2024 at 06:00:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This patch adds a pair of new file ioctls to retrieve the parent pointer
> of a given inode.  They both return the same results, but one operates
> on the file descriptor passed to ioctl() whereas the other allows the
> caller to specify a file handle for which the caller wants results.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> [djwong: adjust to new ondisk format, split ioctls]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_fs.h     |   73 ++++++++++++
>  fs/xfs/libxfs/xfs_ondisk.h |    5 +
>  fs/xfs/libxfs/xfs_parent.c |   35 ++++++
>  fs/xfs/libxfs/xfs_parent.h |    5 +
>  fs/xfs/xfs_handle.c        |  259 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_handle.h        |    5 +
>  fs/xfs/xfs_ioctl.c         |    6 +
>  fs/xfs/xfs_trace.c         |    1 
>  fs/xfs/xfs_trace.h         |   92 ++++++++++++++++
>  9 files changed, 480 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 51aa4774f57a2..fa28c18e521bf 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -840,6 +840,77 @@ struct xfs_commit_range {
>  					 XFS_EXCHANGE_RANGE_DRY_RUN | \
>  					 XFS_EXCHANGE_RANGE_FILE1_WRITTEN)
>  
> +/* Iterating parent pointers of files. */
> +
> +/* target was the root directory */
> +#define XFS_GETPARENTS_OFLAG_ROOT	(1U << 0)
> +
> +/* Cursor is done iterating pptrs */
> +#define XFS_GETPARENTS_OFLAG_DONE	(1U << 1)
> +
> +#define XFS_GETPARENTS_OFLAGS_ALL	(XFS_GETPARENTS_OFLAG_ROOT | \
> +					 XFS_GETPARENTS_OFLAG_DONE)
> +
> +#define XFS_GETPARENTS_IFLAGS_ALL	(0)
> +
> +struct xfs_getparents_rec {
> +	struct xfs_handle	gpr_parent; /* Handle to parent */
> +	__u16			gpr_reclen; /* Length of entire record */
> +	char			gpr_name[]; /* Null-terminated filename */
> +} __packed;
> +
> +/* Iterate through this file's directory parent pointers */
> +struct xfs_getparents {
> +	/*
> +	 * Structure to track progress in iterating the parent pointers.
> +	 * Must be initialized to zeroes before the first ioctl call, and
> +	 * not touched by callers after that.
> +	 */
> +	struct xfs_attrlist_cursor	gp_cursor;
> +
> +	/* Input flags: XFS_GETPARENTS_IFLAG* */
> +	__u16				gp_iflags;
> +
> +	/* Output flags: XFS_GETPARENTS_OFLAG* */
> +	__u16				gp_oflags;
> +
> +	/* Size of the gp_buffer in bytes */
> +	__u32				gp_bufsize;
> +
> +	/* Must be set to zero */
> +	__u64				__pad;
> +
> +	/* Pointer to a buffer in which to place xfs_getparents_rec */
> +	__u64				gp_buffer;
> +};
> +
> +static inline struct xfs_getparents_rec *
> +xfs_getparents_first_rec(struct xfs_getparents *gp)
> +{
> +	return (struct xfs_getparents_rec *)(uintptr_t)gp->gp_buffer;
> +}
> +
> +static inline struct xfs_getparents_rec *
> +xfs_getparents_next_rec(struct xfs_getparents *gp,
> +			struct xfs_getparents_rec *gpr)
> +{
> +	char *next = ((char *)gpr + gpr->gpr_reclen);
> +	char *end = (char *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
> +
> +	if (next >= end)
> +		return NULL;
> +
> +	return (struct xfs_getparents_rec *)next;
> +}
> +
> +/* Iterate through this file handle's directory parent pointers. */
> +struct xfs_getparents_by_handle {
> +	/* Handle to file whose parents we want. */
> +	struct xfs_handle		gph_handle;
> +
> +	struct xfs_getparents		gph_request;
> +};
> +
>  /*
>   * ioctl commands that are used by Linux filesystems
>   */
> @@ -875,6 +946,8 @@ struct xfs_commit_range {
>  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
>  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
>  #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
> +#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
> +#define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
>  
>  /*
>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index 25952ef584eee..34c972113d997 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -156,6 +156,11 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
>  	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
>  
> +	/* parent pointer ioctls */
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	26);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_by_handle,	64);
> +
>  	/*
>  	 * The v5 superblock format extended several v4 header structures with
>  	 * additional data. While new fields are only accessible on v5
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index 86c808157294e..db8cfad0b968e 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -259,3 +259,38 @@ xfs_parent_replacename(
>  	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_REPLACE);
>  	return 0;
>  }
> +
> +/*
> + * Extract parent pointer information from any xattr into @parent_ino/gen.
> + * The last two parameters can be NULL pointers.
> + *
> + * Returns 1 if this is a valid parent pointer; 0 if this is not a parent
> + * pointer xattr at all; or -EFSCORRUPTED for garbage.
> + */
> +int
> +xfs_parent_from_xattr(
> +	struct xfs_mount	*mp,
> +	unsigned int		attr_flags,
> +	const unsigned char	*name,
> +	unsigned int		namelen,
> +	const void		*value,
> +	unsigned int		valuelen,
> +	xfs_ino_t		*parent_ino,
> +	uint32_t		*parent_gen)
> +{
> +	const struct xfs_parent_rec	*rec = value;
> +
> +	if (!(attr_flags & XFS_ATTR_PARENT))
> +		return 0;
> +
> +	if (!xfs_parent_namecheck(attr_flags, name, namelen))
> +		return -EFSCORRUPTED;
> +	if (!xfs_parent_valuecheck(mp, value, valuelen))
> +		return -EFSCORRUPTED;
> +
> +	if (parent_ino)
> +		*parent_ino = be64_to_cpu(rec->p_ino);
> +	if (parent_gen)
> +		*parent_gen = be32_to_cpu(rec->p_gen);
> +	return 1;
> +}
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> index 768633b313671..3003ab496f854 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -91,4 +91,9 @@ int xfs_parent_replacename(struct xfs_trans *tp,
>  		struct xfs_inode *new_dp, const struct xfs_name *new_name,
>  		struct xfs_inode *child);
>  
> +int xfs_parent_from_xattr(struct xfs_mount *mp, unsigned int attr_flags,
> +		const unsigned char *name, unsigned int namelen,
> +		const void *value, unsigned int valuelen,
> +		xfs_ino_t *parent_ino, uint32_t *parent_gen);
> +
>  #endif /* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
> index abeca486a2c91..833b0d7d8bea1 100644
> --- a/fs/xfs/xfs_handle.c
> +++ b/fs/xfs/xfs_handle.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> + * Copyright (c) 2022-2024 Oracle.
>   * All rights reserved.
>   */
>  #include "xfs.h"
> @@ -645,3 +646,261 @@ xfs_attrmulti_by_handle(
>  	dput(dentry);
>  	return error;
>  }
> +
> +struct xfs_getparents_ctx {
> +	struct xfs_attr_list_context	context;
> +	struct xfs_getparents_by_handle	gph;
> +
> +	/* File to target */
> +	struct xfs_inode		*ip;
> +
> +	/* Internal buffer where we format records */
> +	void				*krecords;
> +
> +	/* Last record filled out */
> +	struct xfs_getparents_rec	*lastrec;
> +
> +	unsigned int			count;
> +};
> +
> +static inline unsigned int
> +xfs_getparents_rec_sizeof(
> +	unsigned int		namelen)
> +{
> +	return round_up(sizeof(struct xfs_getparents_rec) + namelen + 1,
> +			sizeof(uint32_t));
> +}
> +
> +static void
> +xfs_getparents_put_listent(
> +	struct xfs_attr_list_context	*context,
> +	int				flags,
> +	unsigned char			*name,
> +	int				namelen,
> +	void				*value,
> +	int				valuelen)
> +{
> +	struct xfs_getparents_ctx	*gpx =
> +		container_of(context, struct xfs_getparents_ctx, context);
> +	struct xfs_inode		*ip = context->dp;
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_getparents		*gp = &gpx->gph.gph_request;
> +	struct xfs_getparents_rec	*gpr = gpx->krecords + context->firstu;
> +	unsigned short			reclen = xfs_getparents_rec_sizeof(namelen);
> +	xfs_ino_t			ino;
> +	uint32_t			gen;
> +	int				ret;
> +
> +	ret = xfs_parent_from_xattr(mp, flags, name, namelen, value, valuelen,
> +			&ino, &gen);
> +	if (ret < 0) {
> +		xfs_inode_mark_sick(ip, XFS_SICK_INO_PARENT);
> +		context->seen_enough = -EFSCORRUPTED;
> +		return;
> +	}
> +	if (ret != 1)
> +		return;
> +
> +	/*
> +	 * We found a parent pointer, but we've filled up the buffer.  Signal
> +	 * to the caller that we did /not/ reach the end of the parent pointer
> +	 * recordset.
> +	 */
> +	if (context->firstu > context->bufsize - reclen) {
> +		context->seen_enough = 1;
> +		return;
> +	}
> +
> +	/* Format the parent pointer directly into the caller buffer. */
> +	gpr->gpr_reclen = reclen;
> +	xfs_filehandle_init(mp, ino, gen, &gpr->gpr_parent);
> +	memcpy(gpr->gpr_name, name, namelen);
> +	gpr->gpr_name[namelen] = 0;
> +
> +	trace_xfs_getparents_put_listent(ip, gp, context, gpr);
> +
> +	context->firstu += reclen;
> +	gpx->count++;
> +	gpx->lastrec = gpr;
> +}
> +
> +/* Expand the last record to fill the rest of the caller's buffer. */
> +static inline void
> +xfs_getparents_expand_lastrec(
> +	struct xfs_getparents_ctx	*gpx)
> +{
> +	struct xfs_getparents		*gp = &gpx->gph.gph_request;
> +	struct xfs_getparents_rec	*gpr = gpx->lastrec;
> +
> +	if (!gpx->lastrec)
> +		gpr = gpx->krecords;
> +
> +	gpr->gpr_reclen = gp->gp_bufsize - ((void *)gpr - gpx->krecords);
> +
> +	trace_xfs_getparents_expand_lastrec(gpx->ip, gp, &gpx->context, gpr);
> +}
> +
> +static inline void __user *u64_to_uptr(u64 val)
> +{
> +	return (void __user *)(uintptr_t)val;
> +}
> +
> +/* Retrieve the parent pointers for a given inode. */
> +STATIC int
> +xfs_getparents(
> +	struct xfs_getparents_ctx	*gpx)
> +{
> +	struct xfs_getparents		*gp = &gpx->gph.gph_request;
> +	struct xfs_inode		*ip = gpx->ip;
> +	struct xfs_mount		*mp = ip->i_mount;
> +	size_t				bufsize;
> +	int				error;
> +
> +	/* Check size of buffer requested by user */
> +	if (gp->gp_bufsize > XFS_XATTR_LIST_MAX)
> +		return -ENOMEM;
> +	if (gp->gp_bufsize < xfs_getparents_rec_sizeof(1))
> +		return -EINVAL;
> +
> +	if (gp->gp_iflags & ~XFS_GETPARENTS_IFLAGS_ALL)
> +		return -EINVAL;
> +	if (gp->__pad)
> +		return -EINVAL;
> +
> +	bufsize = round_down(gp->gp_bufsize, sizeof(uint32_t));
> +	gpx->krecords = kvzalloc(bufsize, GFP_KERNEL);
> +	if (!gpx->krecords) {
> +		bufsize = min(bufsize, PAGE_SIZE);
> +		gpx->krecords = kvzalloc(bufsize, GFP_KERNEL);
> +		if (!gpx->krecords)
> +			return -ENOMEM;
> +	}
> +
> +	gpx->context.dp = ip;
> +	gpx->context.resynch = 1;
> +	gpx->context.put_listent = xfs_getparents_put_listent;
> +	gpx->context.bufsize = bufsize;
> +	/* firstu is used to track the bytes filled in the buffer */
> +	gpx->context.firstu = 0;
> +
> +	/* Copy the cursor provided by caller */
> +	memcpy(&gpx->context.cursor, &gp->gp_cursor,
> +			sizeof(struct xfs_attrlist_cursor));
> +	gpx->count = 0;
> +	gp->gp_oflags = 0;
> +
> +	trace_xfs_getparents_begin(ip, gp, &gpx->context.cursor);
> +
> +	error = xfs_attr_list(&gpx->context);
> +	if (error)
> +		goto out_free_buf;
> +	if (gpx->context.seen_enough < 0) {
> +		error = gpx->context.seen_enough;
> +		goto out_free_buf;
> +	}
> +	xfs_getparents_expand_lastrec(gpx);
> +
> +	/* Update the caller with the current cursor position */
> +	memcpy(&gp->gp_cursor, &gpx->context.cursor,
> +			sizeof(struct xfs_attrlist_cursor));
> +
> +	/* Is this the root directory? */
> +	if (ip->i_ino == mp->m_sb.sb_rootino)
> +		gp->gp_oflags |= XFS_GETPARENTS_OFLAG_ROOT;
> +
> +	if (gpx->context.seen_enough == 0) {
> +		/*
> +		 * If we did not run out of buffer space, then we reached the
> +		 * end of the pptr recordset, so set the DONE flag.
> +		 */
> +		gp->gp_oflags |= XFS_GETPARENTS_OFLAG_DONE;
> +	} else if (gpx->count == 0) {
> +		/*
> +		 * If we ran out of buffer space before copying any parent
> +		 * pointers at all, the caller's buffer was too short.  Tell
> +		 * userspace that, erm, the message is too long.
> +		 */
> +		error = -EMSGSIZE;
> +		goto out_free_buf;
> +	}
> +
> +	trace_xfs_getparents_end(ip, gp, &gpx->context.cursor);
> +
> +	ASSERT(gpx->context.firstu <= gpx->gph.gph_request.gp_bufsize);
> +
> +	/* Copy the records to userspace. */
> +	if (copy_to_user(u64_to_uptr(gpx->gph.gph_request.gp_buffer),
> +				gpx->krecords, gpx->context.firstu))
> +		error = -EFAULT;
> +
> +out_free_buf:
> +	kvfree(gpx->krecords);
> +	gpx->krecords = NULL;
> +	return error;
> +}
> +
> +/* Retrieve the parents of this file and pass them back to userspace. */
> +int
> +xfs_ioc_getparents(
> +	struct file			*file,
> +	struct xfs_getparents __user	*ureq)
> +{
> +	struct xfs_getparents_ctx	gpx = {
> +		.ip			= XFS_I(file_inode(file)),
> +	};
> +	struct xfs_getparents		*kreq = &gpx.gph.gph_request;
> +	struct xfs_mount		*mp = gpx.ip->i_mount;
> +	int				error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +	if (!xfs_has_parent(mp))
> +		return -EOPNOTSUPP;
> +	if (copy_from_user(kreq, ureq, sizeof(*kreq)))
> +		return -EFAULT;
> +
> +	error = xfs_getparents(&gpx);
> +	if (error)
> +		return error;
> +
> +	if (copy_to_user(ureq, kreq, sizeof(*kreq)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/* Retrieve the parents of this file handle and pass them back to userspace. */
> +int
> +xfs_ioc_getparents_by_handle(
> +	struct file			*file,
> +	struct xfs_getparents_by_handle __user	*ureq)
> +{
> +	struct xfs_getparents_ctx	gpx = { };
> +	struct xfs_inode		*ip = XFS_I(file_inode(file));
> +	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_getparents_by_handle	*kreq = &gpx.gph;
> +	struct dentry			*dentry;
> +	int				error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +	if (!xfs_has_parent(mp))
> +		return -EOPNOTSUPP;
> +	if (copy_from_user(kreq, ureq, sizeof(*kreq)))
> +		return -EFAULT;
> +
> +	dentry = xfs_khandle_to_dentry(file, &kreq->gph_handle);

I noticed a couple of things while doing more testing here -- first,
xfs_khandle_to_dentry doesn't check that the handle fsid actually
matches this filesystem, and AFAICT *nothing* actually checks that.
So I guess that's a longstanding weakness of handle validation, and we
probably haven't gotten any reports because what's the chance that
you'll get lucky with an ino/gen from a different filesystem?

(Pretty good what with golden images proliferating, I'd say...)

The second thing is that exportfs_decode_fh does too much work here --
if the handle references a directory, it'll walk up the directory tree
to the root to try to reconnect the dentry paths.  For GETPARENTS we
don't care about that since we're not doing anything with dentries.
Walking upwards in the directory tree is extra work that doesn't change
the results.

Worse yet, if there's a loop in in the directory tree due to dotdot
damage or whatnot, this can livelock the system.  This is unfortunate
for xfs_scrub because it'll use GETPARENTS to try to report the path of
a file that it wants to repair ... but it might not have checked those
parents.  So I really don't want GETPARENTS to be creating a bunch of
dentries and reconnecting paths and whatnot.

What we really want, I think, is some basic handle validation and then a
call to something like xfs_nfs_get_inode.


	if (!S_ISDIR(VFS_I(ip)->i_mode))
		return -ENOTDIR;

	if (memcmp(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid)))
		return -ESTALE;

	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
		return -EINVAL;

	inode = xfs_nfs_get_inode(mp->m_super, handle->ha_fid.fid_ino,
			handle->ha_fid.fid_gen);
	if (IS_ERR(inode))
		return PTR_ERR(inode);

	gpx.ip = XFS_I(inode);
	error = xfs_getparents(&gpx);

And yes, I'll add a big comment explaining why we don't use the regular
handle functions here.

--D

> +	if (IS_ERR(dentry))
> +		return PTR_ERR(dentry);
> +
> +	gpx.ip = XFS_I(dentry->d_inode);
> +	error = xfs_getparents(&gpx);
> +	dput(dentry);
> +	if (error)
> +		return error;
> +
> +	if (copy_to_user(ureq, kreq, sizeof(*kreq)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/xfs_handle.h b/fs/xfs/xfs_handle.h
> index e39eaf4689da9..6799a86d8565c 100644
> --- a/fs/xfs/xfs_handle.h
> +++ b/fs/xfs/xfs_handle.h
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> + * Copyright (c) 2022-2024 Oracle.
>   * All rights reserved.
>   */
>  #ifndef	__XFS_HANDLE_H__
> @@ -25,4 +26,8 @@ int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
>  struct dentry *xfs_handle_to_dentry(struct file *parfilp, void __user *uhandle,
>  		u32 hlen);
>  
> +int xfs_ioc_getparents(struct file *file, struct xfs_getparents __user *arg);
> +int xfs_ioc_getparents_by_handle(struct file *file,
> +		struct xfs_getparents_by_handle __user *arg);
> +
>  #endif	/* __XFS_HANDLE_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 7b347cdd28785..c7a15b5f33aa4 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -35,6 +35,7 @@
>  #include "xfs_health.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ioctl.h"
> +#include "xfs_xattr.h"
>  #include "xfs_rtbitmap.h"
>  #include "xfs_file.h"
>  #include "xfs_exchrange.h"
> @@ -1542,7 +1543,10 @@ xfs_file_ioctl(
>  
>  	case XFS_IOC_FSGETXATTRA:
>  		return xfs_ioc_fsgetxattra(ip, arg);
> -
> +	case XFS_IOC_GETPARENTS:
> +		return xfs_ioc_getparents(filp, arg);
> +	case XFS_IOC_GETPARENTS_BY_HANDLE:
> +		return xfs_ioc_getparents_by_handle(filp, arg);
>  	case XFS_IOC_GETBMAP:
>  	case XFS_IOC_GETBMAPA:
>  	case XFS_IOC_GETBMAPX:
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index cf92a3bd56c79..9c7fbaae2717d 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -41,6 +41,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_exchmaps.h"
>  #include "xfs_exchrange.h"
> +#include "xfs_parent.h"
>  
>  /*
>   * We include this last to have the helpers above available for the trace
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index e6cbdffb14f64..4438b62a8c562 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -87,6 +87,9 @@ struct xfs_bmap_intent;
>  struct xfs_exchmaps_intent;
>  struct xfs_exchmaps_req;
>  struct xfs_exchrange;
> +struct xfs_getparents;
> +struct xfs_parent_irec;
> +struct xfs_attrlist_cursor_kern;
>  
>  #define XFS_ATTR_FILTER_FLAGS \
>  	{ XFS_ATTR_ROOT,	"ROOT" }, \
> @@ -5158,6 +5161,95 @@ TRACE_EVENT(xfs_exchmaps_delta_nextents,
>  		  __entry->d_nexts1, __entry->d_nexts2)
>  );
>  
> +DECLARE_EVENT_CLASS(xfs_getparents_rec_class,
> +	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
> +		 const struct xfs_attr_list_context *context,
> +	         const struct xfs_getparents_rec *pptr),
> +	TP_ARGS(ip, ppi, context, pptr),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_ino_t, ino)
> +		__field(unsigned int, firstu)
> +		__field(unsigned short, reclen)
> +		__field(unsigned int, bufsize)
> +		__field(xfs_ino_t, parent_ino)
> +		__field(unsigned int, parent_gen)
> +		__string(name, pptr->gpr_name)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = ip->i_mount->m_super->s_dev;
> +		__entry->ino = ip->i_ino;
> +		__entry->firstu = context->firstu;
> +		__entry->reclen = pptr->gpr_reclen;
> +		__entry->bufsize = ppi->gp_bufsize;
> +		__entry->parent_ino = pptr->gpr_parent.ha_fid.fid_ino;
> +		__entry->parent_gen = pptr->gpr_parent.ha_fid.fid_gen;
> +		__assign_str(name, pptr->gpr_name);
> +	),
> +	TP_printk("dev %d:%d ino 0x%llx firstu %u reclen %u bufsize %u parent_ino 0x%llx parent_gen 0x%x name '%s'",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino,
> +		  __entry->firstu,
> +		  __entry->reclen,
> +		  __entry->bufsize,
> +		  __entry->parent_ino,
> +		  __entry->parent_gen,
> +		  __get_str(name))
> +)
> +#define DEFINE_XFS_GETPARENTS_REC_EVENT(name) \
> +DEFINE_EVENT(xfs_getparents_rec_class, name, \
> +	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi, \
> +		 const struct xfs_attr_list_context *context, \
> +	         const struct xfs_getparents_rec *pptr), \
> +	TP_ARGS(ip, ppi, context, pptr))
> +DEFINE_XFS_GETPARENTS_REC_EVENT(xfs_getparents_put_listent);
> +DEFINE_XFS_GETPARENTS_REC_EVENT(xfs_getparents_expand_lastrec);
> +
> +DECLARE_EVENT_CLASS(xfs_getparents_class,
> +	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
> +		 const struct xfs_attrlist_cursor_kern *cur),
> +	TP_ARGS(ip, ppi, cur),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_ino_t, ino)
> +		__field(unsigned short, iflags)
> +		__field(unsigned short, oflags)
> +		__field(unsigned int, bufsize)
> +		__field(unsigned int, hashval)
> +		__field(unsigned int, blkno)
> +		__field(unsigned int, offset)
> +		__field(int, initted)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = ip->i_mount->m_super->s_dev;
> +		__entry->ino = ip->i_ino;
> +		__entry->iflags = ppi->gp_iflags;
> +		__entry->oflags = ppi->gp_oflags;
> +		__entry->bufsize = ppi->gp_bufsize;
> +		__entry->hashval = cur->hashval;
> +		__entry->blkno = cur->blkno;
> +		__entry->offset = cur->offset;
> +		__entry->initted = cur->initted;
> +	),
> +	TP_printk("dev %d:%d ino 0x%llx iflags 0x%x oflags 0x%x bufsize %u cur_init? %d hashval 0x%x blkno %u offset %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino,
> +		  __entry->iflags,
> +		  __entry->oflags,
> +		  __entry->bufsize,
> +		  __entry->initted,
> +		  __entry->hashval,
> +		  __entry->blkno,
> +		  __entry->offset)
> +)
> +#define DEFINE_XFS_GETPARENTS_EVENT(name) \
> +DEFINE_EVENT(xfs_getparents_class, name, \
> +	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi, \
> +		 const struct xfs_attrlist_cursor_kern *cur), \
> +	TP_ARGS(ip, ppi, cur))
> +DEFINE_XFS_GETPARENTS_EVENT(xfs_getparents_begin);
> +DEFINE_XFS_GETPARENTS_EVENT(xfs_getparents_end);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
> 
