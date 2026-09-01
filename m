Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CCF32E128;
	Tue,  1 Sep 2026 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300797; cv=none; b=VkhQeUTfy9DlT5KxIX/Pr4hwtfD2G2vQpC3zAYlBL2+AM+PqPTM/rIdRVo3SPQjde3VqHxGH6AqYzSef3zV0nqtyqufE6y7/OWk4l1UUQmdM7Fa0eaAuB9driiog28M1WlHIF+9pKXbPq9aA+1ifPzj5BYmC5l7wweAP5T06Low=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300797; c=relaxed/simple;
	bh=wyXXjidBpbCToh1vj3vUV1OCYL4JeiwUQh6d/BndrRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrpvUnHgfNCg8fJdxIcYondnDkZU1YQnbegHfNv7cIVSUQlHxpUym84keDtirJXlXW3qhcqsvmZ5u9OiRN5U3LnD0Iez6cMQqCAROEcKrF93994i/pVHVOfSwSJOZdkLdzu/EZzvuLVtUqsWiDwdv/6HF8XlNtsiKpd39V1GgpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A088eo3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A088eo3p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A27B91F000E9;
	Tue,  1 Sep 2026 22:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300795;
	bh=AQBcIR2ffmfFVLvGyllQQ9KmFHBHxEIx3hFxl+CoYuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A088eo3pP49T2X27tmBKhvpOBWTP9kCzVjlc8FCH2mlNSSKyrRgx3OZjDtpuSarjS
	 ZhvLlgZGTAdrWbv/7BHpqoQvO1zyQjli3lkIGO94Xey6pZ/Tu9VIUpFBWqy16/ja7C
	 km8rdxm0idzF89NcV8ITKDOl8fmwfgXF9WWNGBLjfqwP7vf/OkNypYHqvGiMpk1tmJ
	 n3zJUDoVaZ+h7N8XQ8HIU20DwSCxgoWMjEeflAwkbxnPQzuVRMElbF7hP8z2yQNlDF
	 vlToULdM/CirGy8ww1B6sL8BUmiKO7MqOrGlWalG8I8z8o7lQ4Ve2b9180vc8RG74E
	 MVgOS0Db3Ed+w==
Date: Tue, 1 Sep 2026 15:13:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 08/18] fs: add dedicated block device open helpers
 for filesystems
Message-ID: <20260901221314.GC6038@frogsfrogsfrogs>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org>

On Tue, Jun 16, 2026 at 04:08:24PM +0200, Christian Brauner wrote:
> Add fs_bdev_file_open_by_{dev,path}() and fs_bdev_file_release(). They
> open the device with fs_holder_ops and register a claim in the
> device-to-superblock table. Claims on the same (device, superblock)
> pair share one entry, so when a filesystem claims a device it already
> uses (xfs with its log on the data device), no second entry is added
> and each superblock will be acted on once.
> 
> The holder argument remains purely the block layer's exclusivity token:
> a superblock, or a file_system_type for a device shared by several
> superblocks of that type. The shared case only becomes usable once the
> fs_holder_ops callbacks resolve superblocks through the table instead
> of bdev->bd_holder.
> 
> Convert the main device, setup_bdev_super() and kill_block_super(),
> over: the open finds the entry registered by sget_fc() and claims it
> again. cramfs and romfs bypass kill_block_super() so they can handle
> MTD mounts and release the main device with a plain bdev_fput(), which
> would leave the claim behind: the (dev, sb) entry would never be
> unregistered and the passive reference it holds would keep the
> superblock alive forever. Convert their release paths in the same
> step.
> 
> The frozen-device check stays in setup_bdev_super() for the primary
> device and is added to fs_bdev_register() for new claims, i.e. every
> additional device a filesystem opens through the helpers. Only a
> (device, superblock) pair the superblock claimed earlier may be
> reopened while frozen (xfs with its log on the data device): the freeze
> already covers that superblock through the existing claim, so nothing
> escapes it. Without the setup_bdev_super() check a device frozen before
> the mount even started (dm lock_fs, loop) could be mounted and written
> to (journal replay) under an active freeze, because the primary open
> reuses the entry registered by sget_fc() and never takes the new-claim
> path.
> 
> Both checks read bd_fsfreeze_count only after the entry is published
> (by sget_fc() for the primary, by fs_bdev_register() for new claims)
> and pair with bdev_freeze() incrementing the count before walking the
> table: either the mount sees the elevated freeze count and fails with
> EBUSY, or the freeze finds the published entry and converges once
> SB_BORN is set.

Hmm.  I /think/ this might be causing regressions in xfs/006,
generic/311, and xfs/264 on XFS realtime filesystems.  Each test fails
with a mount failure due to a busy device:

 --- /run/fstests/bin/tests/xfs/006.out	2025-07-15 14:41:40.170403463 -0700
 +++ /run/fstests/logs/xfs/006.out.bad	2026-08-31 12:25:01.790239078 -0700
 @@ -6,3 +6,7 @@ error/metadata/EIO/max_retries=-1
  error/metadata/EIO/retry_timeout_seconds=-1
  error/metadata/ENOSPC/max_retries=-1
  error/metadata/ENOSPC/retry_timeout_seconds=-1
 +mount: /mnt/s: /dev/mapper/error-test.006 already mounted or mount point busy.
 +       dmesg(1) may have more information after failed mount system call.
 +umount.nfs: remote share not in 'host:dir' format
 +umount.nfs: /mnt/s: not mounted

I'm not sure what's going on here, but dmesg has this to say:

XFS (dm-0): Invalid device [/dev/mapper/error-rttest.006], error=-16

So my guess is that the SCRATCH_RT volume isn't getting unfrozen
properly?

--D

> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/cramfs/inode.c        |   2 +-
>  fs/romfs/super.c         |   2 +-
>  fs/super.c               | 154 ++++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/fs/super.h |   7 +++
>  4 files changed, 155 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> index 4edbfccd0bbe..d4cd03f4f60d 100644
> --- a/fs/cramfs/inode.c
> +++ b/fs/cramfs/inode.c
> @@ -504,7 +504,7 @@ static void cramfs_kill_sb(struct super_block *sb)
>  		sb->s_mtd = NULL;
>  	} else if (IS_ENABLED(CONFIG_CRAMFS_BLOCKDEV) && sb->s_bdev) {
>  		sync_blockdev(sb->s_bdev);
> -		bdev_fput(sb->s_bdev_file);
> +		fs_bdev_file_release(sb->s_bdev_file, sb);
>  	}
>  	kfree(sbi);
>  }
> diff --git a/fs/romfs/super.c b/fs/romfs/super.c
> index ac55193bf398..43eb897197c0 100644
> --- a/fs/romfs/super.c
> +++ b/fs/romfs/super.c
> @@ -587,7 +587,7 @@ static void romfs_kill_sb(struct super_block *sb)
>  #ifdef CONFIG_ROMFS_ON_BLOCK
>  	if (sb->s_bdev) {
>  		sync_blockdev(sb->s_bdev);
> -		bdev_fput(sb->s_bdev_file);
> +		fs_bdev_file_release(sb->s_bdev_file, sb);
>  	}
>  #endif
>  }
> diff --git a/fs/super.c b/fs/super.c
> index ff5e305d0ab4..3d166c7f578a 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1633,6 +1633,145 @@ const struct blk_holder_ops fs_holder_ops = {
>  };
>  EXPORT_SYMBOL_GPL(fs_holder_ops);
>  
> +static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
> +{
> +	struct super_dev *it;
> +	struct rhlist_head *list, *pos;
> +
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "suspicious super_dev_lookup() usage");
> +	VFS_WARN_ON_ONCE(!dev);
> +	VFS_WARN_ON_ONCE(!sb);
> +
> +	list = rhltable_lookup(&super_dev_table, &dev, super_dev_params);
> +	rhl_for_each_entry_rcu(it, pos, list, sd_node) {
> +		if (it->sd_sb == sb)
> +			return it;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
> +{
> +	struct super_dev *sb_dev __free(kfree) = NULL;
> +	dev_t dev = file_bdev(bdev_file)->bd_dev;
> +	int err;
> +
> +	scoped_guard(rcu) {
> +		sb_dev = super_dev_lookup(dev, sb);
> +		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
> +			retain_and_null_ptr(sb_dev);
> +			return 0;
> +		}
> +	}
> +
> +	sb_dev = super_dev_alloc(dev, sb);
> +	if (!sb_dev)
> +		return -ENOMEM;
> +
> +	err = super_dev_insert(sb_dev);
> +	if (err)
> +		return err;
> +
> +	/* Publish the entry before reading the count; pairs with bdev_freeze(). */
> +	smp_mb();
> +	if (atomic_read(&file_bdev(bdev_file)->bd_fsfreeze_count) > 0) {
> +		err = -EBUSY;
> +		super_dev_put(sb_dev);
> +	}
> +
> +	retain_and_null_ptr(sb_dev);
> +	return err;
> +}
> +
> +/**
> + * fs_bdev_file_open_by_dev - claim a block device on behalf of a superblock
> + * @dev: block device number
> + * @mode: open mode
> + * @holder: block-layer exclusivity token (a superblock, or the file_system_type
> + *          when the device may be shared by several superblocks of that type)
> + * @sb: superblock to drive fs_holder_ops events for
> + *
> + * Open @dev with &fs_holder_ops and register that @sb uses it, so device
> + * removal/sync/freeze/thaw are propagated to @sb (and any other superblock
> + * sharing @dev).  Must be paired with fs_bdev_file_release().
> + *
> + * Return: an opened block-device file or an ERR_PTR().
> + */
> +struct file *fs_bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
> +				      struct super_block *sb)
> +{
> +	struct file *bdev_file;
> +	int err;
> +
> +	bdev_file = bdev_file_open_by_dev(dev, mode, holder, &fs_holder_ops);
> +	if (IS_ERR(bdev_file))
> +		return bdev_file;
> +
> +	err = fs_bdev_register(bdev_file, sb);
> +	if (err) {
> +		bdev_fput(bdev_file);
> +		return ERR_PTR(err);
> +	}
> +	return bdev_file;
> +}
> +EXPORT_SYMBOL_GPL(fs_bdev_file_open_by_dev);
> +
> +/**
> + * fs_bdev_file_open_by_path - claim a block device on behalf of a superblock
> + * @path: path to the block device
> + * @mode: open mode
> + * @holder: block-layer exclusivity token (a superblock, or the file_system_type
> + *          when the device may be shared by several superblocks of that type)
> + * @sb: superblock to drive fs_holder_ops events for
> + *
> + * Open the block device at @path with &fs_holder_ops and register that @sb
> + * uses it, so device removal/sync/freeze/thaw are propagated to @sb (and any
> + * other superblock sharing the device).  Must be paired with
> + * fs_bdev_file_release().
> + *
> + * Return: an opened block-device file or an ERR_PTR().
> + */
> +struct file *fs_bdev_file_open_by_path(const char *path, blk_mode_t mode,
> +				       void *holder, struct super_block *sb)
> +{
> +	struct file *bdev_file;
> +	int err;
> +
> +	bdev_file = bdev_file_open_by_path(path, mode, holder, &fs_holder_ops);
> +	if (IS_ERR(bdev_file))
> +		return bdev_file;
> +
> +	err = fs_bdev_register(bdev_file, sb);
> +	if (err) {
> +		bdev_fput(bdev_file);
> +		return ERR_PTR(err);
> +	}
> +	return bdev_file;
> +}
> +EXPORT_SYMBOL_GPL(fs_bdev_file_open_by_path);
> +
> +/**
> + * fs_bdev_file_release - release a block device claimed for a superblock
> + * @bdev_file: file returned by fs_bdev_file_open_by_{dev,path}()
> + * @sb: superblock the device was claimed for
> + *
> + * Drop one claim on the {dev, @sb} entry; the last claim unregisters it (a
> + * pinning cursor defers the actual unlink).  Then close the block device.
> + */
> +void fs_bdev_file_release(struct file *bdev_file, struct super_block *sb)
> +{
> +	dev_t dev = file_bdev(bdev_file)->bd_dev;
> +	struct super_dev *sb_dev;
> +
> +	rcu_read_lock();
> +	sb_dev = super_dev_lookup(dev, sb);
> +	rcu_read_unlock();
> +	super_dev_put(sb_dev);
> +	bdev_fput(bdev_file);
> +}
> +EXPORT_SYMBOL_GPL(fs_bdev_file_release);
> +
>  int setup_bdev_super(struct super_block *sb, int sb_flags,
>  		struct fs_context *fc)
>  {
> @@ -1640,7 +1779,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  	struct file *bdev_file;
>  	struct block_device *bdev;
>  
> -	bdev_file = bdev_file_open_by_dev(sb->s_dev, mode, sb, &fs_holder_ops);
> +	bdev_file = fs_bdev_file_open_by_dev(sb->s_dev, mode, sb, sb);
>  	if (IS_ERR(bdev_file)) {
>  		if (fc)
>  			errorf(fc, "%s: Can't open blockdev", fc->source);
> @@ -1654,20 +1793,19 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  	 * writable from userspace even for a read-only block device.
>  	 */
>  	if ((mode & BLK_OPEN_WRITE) && bdev_read_only(bdev)) {
> -		bdev_fput(bdev_file);
> +		fs_bdev_file_release(bdev_file, sb);
>  		return -EACCES;
>  	}
>  
> -	/*
> -	 * It is enough to check bdev was not frozen before we set
> -	 * s_bdev as freezing will wait until SB_BORN is set.
> -	 */
> +	/* The sget_fc() entry is already published; pairs with bdev_freeze(). */
> +	smp_mb();
>  	if (atomic_read(&bdev->bd_fsfreeze_count) > 0) {
>  		if (fc)
>  			warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
> -		bdev_fput(bdev_file);
> +		fs_bdev_file_release(bdev_file, sb);
>  		return -EBUSY;
>  	}
> +
>  	spin_lock(&sb_lock);
>  	sb->s_bdev_file = bdev_file;
>  	sb->s_bdev = bdev;
> @@ -1756,7 +1894,7 @@ void kill_block_super(struct super_block *sb)
>  	generic_shutdown_super(sb);
>  	if (bdev) {
>  		sync_blockdev(bdev);
> -		bdev_fput(sb->s_bdev_file);
> +		fs_bdev_file_release(sb->s_bdev_file, sb);
>  	}
>  }
>  
> diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
> index f21ffbb6dea5..721d842e3b24 100644
> --- a/include/linux/fs/super.h
> +++ b/include/linux/fs/super.h
> @@ -235,4 +235,11 @@ int freeze_super(struct super_block *super, enum freeze_holder who,
>  int thaw_super(struct super_block *super, enum freeze_holder who,
>  	       const void *freeze_owner);
>  
> +struct file;
> +struct file *fs_bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
> +				      struct super_block *sb);
> +struct file *fs_bdev_file_open_by_path(const char *path, blk_mode_t mode,
> +				       void *holder, struct super_block *sb);
> +void fs_bdev_file_release(struct file *bdev_file, struct super_block *sb);
> +
>  #endif /* _LINUX_FS_SUPER_H */
> 
> -- 
> 2.47.3
> 
> 
