Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042551E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713392705; cv=none; b=sYnpNWg0V2bMfrmXbeDgrTxF0SP/yJS5d2QwB0vPDl4h/veyOatY76wxiFyvrf0H3i/VP4Ezqsw7dnsYE2Xxq7h0zMolvleV+feb9grN0YlFHP5dr1EQf8oely70zVLN3e6c6PrNY550CR8GT4/CNTLCqIugDoz4XaGLmehAvo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713392705; c=relaxed/simple;
	bh=/4t19aL/BETz4Ewd8QIoykZ2LLkrD68FCDEQiD7VtKQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GM2Y1BuD4B3pFu6rtIPkZp6OQpjbLVYCe1Pt5AnvRMuvZPtSKubsLxm2KzUE3+rQICck5yPT/J3MDr8c1Gk8hpxHNINFpaijvF8++Qamo3PPvHb7FThuXbpyYQ1G9QuHulwyH9MyrblxfYObydgJ3FOjhbpbSRaMjVv17saiX+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZKJDpfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZKJDpfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AA7C072AA;
	Wed, 17 Apr 2024 22:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713392704;
	bh=/4t19aL/BETz4Ewd8QIoykZ2LLkrD68FCDEQiD7VtKQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=WZKJDpfKl5kv1lQ3ufOexaesR6klsmDZ3QbBwHIgYs0P2tlMlCtOKr5FHTONBtc/X
	 GlBWOlQubatxMC9/FEdN7h3aKtFyESDK3BkgC9D380Xg3qTx9notj1SknIj9WzxsVt
	 Ui3bJnXLZStuSwBCo/ZEHfV3wQYWWnodDUq070F+WbmrH+sP7NErjdkSMhlI2SQKug
	 C7MK0b1Uy5WtK8TxWWRKezt7yWWfUwQ2CKyErVaIBP/tWf8CB0AD0+HhxlyW3WyPCn
	 jL4WQ97lA0rwu6K7lsssbjHwqyp/dSaHZtkil53SpLUrpQ9lx2ND3NJv38Tjs+C29o
	 AqD3BDzcs2JbA==
Date: Wed, 17 Apr 2024 15:25:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com
Subject: Re: [PATCH v13.2.1 26/31] xfs: add parent pointer ioctls
Message-ID: <20240417222503.GC11948@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
 <20240417024955.GL11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417024955.GL11948@frogsfrogsfrogs>

On Tue, Apr 16, 2024 at 07:49:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This patch adds a pair of new file ioctls to retrieve the parent pointer
> of a given inode.  They both return the same results, but one operates
> on the file descriptor passed to ioctl() whereas the other allows the
> caller to specify a file handle for which the caller wants results.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> v13.2.1: dont check fsid like the other handle code, hoist iget to helper
> ---
>  fs/xfs/libxfs/xfs_fs.h     |   73 +++++++++++
>  fs/xfs/libxfs/xfs_ondisk.h |    5 +
>  fs/xfs/libxfs/xfs_parent.c |   34 +++++
>  fs/xfs/libxfs/xfs_parent.h |    5 +
>  fs/xfs/xfs_export.c        |    2 
>  fs/xfs/xfs_export.h        |    2 
>  fs/xfs/xfs_handle.c        |  298 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_handle.h        |    5 +
>  fs/xfs/xfs_ioctl.c         |    6 +
>  fs/xfs/xfs_trace.c         |    1 
>  fs/xfs/xfs_trace.h         |   92 ++++++++++++++
>  11 files changed, 521 insertions(+), 2 deletions(-)
> 

<snip>

> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index 25952ef584eee..e8cdd77d03fa8 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -156,6 +156,11 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
>  	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
>  
> +	/* parent pointer ioctls */
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);

It turns out that the i386 (or probably just 32-bit) build robots trip
over this statement, probably because of the implied padding after the
gpr_name[] flexarray.  I'll change this to:

	XFS_CHECK_OFFSET(struct xfs_getparents_rec, gpr_name,	26);

and let's see what they say.  armhf checks out locally.

--D

> +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_by_handle,	64);
> +
>  	/*
>  	 * The v5 superblock format extended several v4 header structures with
>  	 * additional data. While new fields are only accessible on v5
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index fdf643bfde4df..504de1ef33876 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -257,3 +257,37 @@ xfs_parent_replacename(
>  	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REPLACE);
>  	return 0;
>  }
> +
> +/*
> + * Extract parent pointer information from any parent pointer xattr into
> + * @parent_ino/gen.  The last two parameters can be NULL pointers.
> + *
> + * Returns 0 if this is not a parent pointer xattr at all; or -EFSCORRUPTED for
> + * garbage.
> + */
> +int
> +xfs_parent_from_attr(
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
> +	ASSERT(attr_flags & XFS_ATTR_PARENT);
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
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> index 768633b313671..d7ab09e738ad4 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -91,4 +91,9 @@ int xfs_parent_replacename(struct xfs_trans *tp,
>  		struct xfs_inode *new_dp, const struct xfs_name *new_name,
>  		struct xfs_inode *child);
>  
> +int xfs_parent_from_attr(struct xfs_mount *mp, unsigned int attr_flags,
> +		const unsigned char *name, unsigned int namelen,
> +		const void *value, unsigned int valuelen,
> +		xfs_ino_t *parent_ino, uint32_t *parent_gen);
> +
>  #endif /* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 4b03221351c0f..201489d3de089 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -102,7 +102,7 @@ xfs_fs_encode_fh(
>  	return fileid_type;
>  }
>  
> -STATIC struct inode *
> +struct inode *
>  xfs_nfs_get_inode(
>  	struct super_block	*sb,
>  	u64			ino,
> diff --git a/fs/xfs/xfs_export.h b/fs/xfs/xfs_export.h
> index 64471a3ddb04d..3cd85e8901a5f 100644
> --- a/fs/xfs/xfs_export.h
> +++ b/fs/xfs/xfs_export.h
> @@ -57,4 +57,6 @@ struct xfs_fid64 {
>  /* This flag goes on the wire.  Don't play with it. */
>  #define XFS_FILEID_TYPE_64FLAG	0x80	/* NFS fileid has 64bit inodes */
>  
> +struct inode *xfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen);
> +
>  #endif	/* __XFS_EXPORT_H__ */
> diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
> index b9f4d9860682a..c8785ed595434 100644
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
> @@ -178,6 +179,30 @@ xfs_khandle_to_dentry(
>  			xfs_handle_acceptable, NULL);
>  }
>  
> +/* Convert handle already copied to kernel space into an xfs_inode. */
> +static struct xfs_inode *
> +xfs_khandle_to_inode(
> +	struct file		*file,
> +	struct xfs_handle	*handle)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(file));
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct inode		*inode;
> +
> +	if (!S_ISDIR(VFS_I(ip)->i_mode))
> +		return ERR_PTR(-ENOTDIR);
> +
> +	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
> +		return ERR_PTR(-EINVAL);
> +
> +	inode = xfs_nfs_get_inode(mp->m_super, handle->ha_fid.fid_ino,
> +			handle->ha_fid.fid_gen);
> +	if (IS_ERR(inode))
> +		return ERR_CAST(inode);
> +
> +	return XFS_I(inode);
> +}
> +
>  /*
>   * Convert userspace handle data into a dentry.
>   */
> @@ -652,3 +677,276 @@ xfs_attrmulti_by_handle(
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
> +			sizeof(uint64_t));
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
> +	unsigned short			reclen =
> +		xfs_getparents_rec_sizeof(namelen);
> +	xfs_ino_t			ino;
> +	uint32_t			gen;
> +	int				error;
> +
> +	if (!(flags & XFS_ATTR_PARENT))
> +		return;
> +
> +	error = xfs_parent_from_attr(mp, flags, name, namelen, value, valuelen,
> +			&ino, &gen);
> +	if (error) {
> +		xfs_inode_mark_sick(ip, XFS_SICK_INO_PARENT);
> +		context->seen_enough = -EFSCORRUPTED;
> +		return;
> +	}
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
> +	if (gp->gp_reserved)
> +		return -EINVAL;
> +
> +	bufsize = round_down(gp->gp_bufsize, sizeof(uint64_t));
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
> +	struct xfs_handle		*handle = &kreq->gph_handle;
> +	int				error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +	if (!xfs_has_parent(mp))
> +		return -EOPNOTSUPP;
> +	if (copy_from_user(kreq, ureq, sizeof(*kreq)))
> +		return -EFAULT;
> +
> +	/*
> +	 * We don't use exportfs_decode_fh because it does too much work here.
> +	 * If the handle refers to a directory, the exportfs code will walk
> +	 * upwards through the directory tree to connect the dentries to the
> +	 * root directory dentry.  For GETPARENTS we don't care about that
> +	 * because we're not actually going to open a file descriptor; we only
> +	 * want to open an inode and read its parent pointers.
> +	 *
> +	 * Note that xfs_scrub uses GETPARENTS to log that it will try to fix a
> +	 * corrupted file's metadata.  For this usecase we would really rather
> +	 * userspace single-step the path reconstruction to avoid loops or
> +	 * other strange things if the directory tree is corrupt.
> +	 */
> +	gpx.ip = xfs_khandle_to_inode(file, handle);
> +	if (IS_ERR(gpx.ip))
> +		return PTR_ERR(gpx.ip);
> +
> +	error = xfs_getparents(&gpx);
> +	if (error)
> +		goto out_rele;
> +
> +	if (copy_to_user(ureq, kreq, sizeof(*kreq)))
> +		error = -EFAULT;
> +
> +out_rele:
> +	xfs_irele(gpx.ip);
> +	return error;
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
> index 062869a38aa83..6055053a8f6b2 100644
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
> @@ -1424,7 +1425,10 @@ xfs_file_ioctl(
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
> index fdded7c248143..11a56b6f27662 100644
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
> @@ -5153,6 +5156,95 @@ TRACE_EVENT(xfs_exchmaps_delta_nextents,
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
