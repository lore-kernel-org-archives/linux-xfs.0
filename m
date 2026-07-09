Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C51928466C;
	Thu,  9 Jul 2026 07:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783581238; cv=none; b=G9LIByUI+bgCSm4G9Mv9iKVhKVCm4XTZTAfZIDyEAF4zRs5vztj0cT8yO7Jhal2wCtovJMbaEBAfrofPUvX2w1IIhQ9kZvcnp4RRSQ8S9woxMuQW1PF1MGaO7lXGGGFPhvmwPt6S31y0+dcWZb6BAbQlelCtYM30Qpv6hm+gOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783581238; c=relaxed/simple;
	bh=R8lVV5vWxQj/RmwYu2B8fvViBt/ERGXV0vxKvH55bO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NthyrG1oyXVYPC6V7EzB5qgAhvgfopInDPFql3zrOckUu5Q3MUvs2HgpEVJIISJCmVMiR9L5lfiik60B3zS0mK7lzP6XdpJGM9lLPieec+IHfPQ3ahxO6uRFZ3PxPdp1jI0weONwr/J5CPbsWSmWiT1NK62k5Xer8X5vm8CJKtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 69E5C68AFE; Thu,  9 Jul 2026 09:13:52 +0200 (CEST)
Date: Thu, 9 Jul 2026 09:13:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <20260709071352.GA20180@lst.de>
References: <20260708011843.1036846-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708011843.1036846-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Memory alignment constraints for direct io can vary depending on the
> backing storage hardware. Provide support through file_getattr to report
> the attributes necessary for applications to know how to construct valid
> read and write requests.

This probably wants to be split in one patch for the new UAPI,
one for the helper and one for each user.

And especially the UAPI one needs a much more detailed commit log
explaining it, including why this duplicates some of the informastion
already in statx and documenting the semantics for all the fields.

Andrey, is there a man page or other official documentation for
file_setattr/file_getattr?

> +/*
> + * Handle DIO alignment for block devices via fileattr.
> + */

Maybe note that this purely about the block device constraints,
and file systems may expose additional ones?

> +void bdev_fileattr(const struct inode *inode, struct file_kattr *fa)
> +{
> +	struct block_device *bdev;
> +
> +	memset(fa, 0, sizeof(*fa));
> +	fa->fsx_valid = true;
> +	fa->flags_valid = true;

Doing the basic file_kattr initialization here feels dangerous
if we want to be able to call this from file system implementations.
I'd rather leave the initialization to the caller.

> +
> +	bdev = blkdev_get_no_open(inode->i_rdev, false);
> +	if (!bdev)
> +		return;

.. and explicitly pass in the block device.  ->i_rdev always is
i_sb->s_dev, which might not be the relevant backing device, e.g. for XFS
it could be that or the block device in m_rtdev_targp.

If i_rdev is i_sb->s_dev we can just use sb->s_bdev without needing a new
open.

> +	fa->fsx_dio_mem_align = bdev_dma_alignment(bdev) + 1;
> +	fa->fsx_dio_offset_align = bdev_logical_block_size(bdev);
> +	fa->fsx_dio_read_offset_align = bdev_logical_block_size(bdev);
> +	fa->fsx_dio_virt_boundary_align = bdev_virt_boundary_alignment(bdev);
> +	fa->fsx_max_segments = bdev_max_segments(bdev);

How is the max_segments value defined in a way that is meaningful to
userspace?

> @@ -1005,6 +1006,27 @@ int ext4_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	if (ext4_has_feature_project(inode->i_sb))
>  		fa->fsx_projid = from_kprojid(&init_user_ns, ei->i_projid);
>  
> +	if (S_ISREG(inode->i_mode)) {

You'll probably want to split this into a helper to keep it easily
readable.

> +		u32 dio_align = ext4_dio_alignment(inode);
> +
> +		if (dio_align != 0) {


> +			struct block_device *bdev = inode->i_sb->s_bdev;
> +
> +			if (dio_align == 1) {
> +				fa->fsx_dio_mem_align = bdev_dma_alignment(bdev) + 1;
> +				fa->fsx_dio_offset_align = bdev_logical_block_size(bdev);
> +				fa->fsx_dio_read_offset_align = bdev_logical_block_size(bdev);
> +			} else {
> +				fa->fsx_dio_mem_align = dio_align;
> +				fa->fsx_dio_offset_align = dio_align;
> +				fa->fsx_dio_read_offset_align = dio_align;
> +			}

Call bdev_fileattr and override the relevant field as needed?

Question to the ext4 maintainers: why does ext4_dio_alignment
affect the in-memory alignment?  If it does so, it should probably
also affect the virt boundry alignment..

> +	if (S_ISREG(inode->i_mode)) {
> +		unsigned int bsize = i_blocksize(inode);
> +		struct block_device *bdev = inode->i_sb->s_bdev;
> +
> +		if (!f2fs_force_buffered_io(inode, WRITE)) {

Same comments as for ext4.  Also f2fs does support multiple devices,
but I'm not sure how data is placed on them, or if a file can be
on multiple devices.  We'll need input from the f2fs
maintainers/contributors here.

> @@ -88,8 +89,12 @@ int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	struct inode *inode = d_inode(dentry);
>  	int error;
>  
> -	if (!inode->i_op->fileattr_get)
> -		return -ENOIOCTLCMD;
> +	if (!inode->i_op->fileattr_get) {
> +		if (!S_ISBLK(inode->i_mode))
> +			return -ENOIOCTLCMD;
> +		bdev_fileattr(inode, fa);
> +		return 0;

Don't we also want to fill out the attributes for block devices
on file systems that provide a ->fileattr_get?.   Also if we fill
out something, we need the security_inode_file_getattr as well.

>  /**
> @@ -145,6 +155,8 @@ static int file_attr_to_fileattr(const struct file_attr *fattr,
>  
>  	if (fattr->fa_xflags & ~mask)
>  		return -EINVAL;
> +	if (fattr->fa_pad)
> +		return -EINVAL;

How is this related?

> +	if (whichfork == XFS_DATA_FORK && S_ISREG(VFS_I(ip)->i_mode)) {

This probably wants a separate helper.

> +		struct xfs_buftarg *target = xfs_inode_buftarg(ip);
> +		struct block_device *bdev = target->bt_bdev;

.. and if the generic helpers gets an explicitl bdev we can use it
here and just override one value for for xfs_is_cow_inode().

> +static inline unsigned int bdev_virt_boundary_alignment(struct block_device *bdev)

Overly long line.

