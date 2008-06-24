Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 15:09:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5OM91cA005448
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:09:01 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 537D5275213
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:10:00 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id v94XBGzPEvQgRkFk for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:10:00 -0700 (PDT)
Date: Tue, 24 Jun 2008 15:09:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-Id: <20080624150925.765155f0.akpm@linux-foundation.org>
In-Reply-To: <20080624160056t-sato@mail.jp.nec.com>
References: <20080624160056t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Tue, 24 Jun 2008 16:00:56 +0900
Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> The timeout feature is added to freeze ioctl.  And new ioctl
> to reset the timeout period is added.
> o Freeze the filesystem
>   int ioctl(int fd, int FIFREEZE, long *timeval)
>     fd: The file descriptor of the mountpoint
>     FIFREEZE: request code for the freeze
>     timeval: the timeout period in seconds
>              If it's 0 or 1, the timeout isn't set.
>              This special case of "1" is implemented to keep
>              the compatibility with XFS applications.
>     Return value: 0 if the operation succeeds. Otherwise, -1
> 
> o Reset the timeout period
>   int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
>     fd:file descriptor of mountpoint
>     FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
>     timeval: new timeout period in seconds
>     Return value: 0 if the operation succeeds. Otherwise, -1
>     Error number: If the filesystem has already been unfrozen,
>                   errno is set to EINVAL.
> 

Please avoid the use of the term `timeval' here.  That term is closely
associated with `struct timeval', and these are not being used here.  A
better identifier would be timeout_secs - it tells the reader what it
does, and it tells the reader what units it is in.  And when it comes
to "time", it is very useful to tell people which units are being used,
because there are many different ones.

>
> ...
>
> --- linux-2.6.26-rc7-xfs/fs/buffer.c	2008-06-23 11:55:15.000000000 +0900
> +++ linux-2.6.26-rc7-timeout/fs/buffer.c	2008-06-23 11:56:47.000000000 +0900
> @@ -190,14 +190,17 @@ int fsync_bdev(struct block_device *bdev
>  
>  /**
>   * freeze_bdev  --  lock a filesystem and force it into a consistent state
> - * @bdev:	blockdevice to lock
> + * @bdev:              blockdevice to lock
> + * @timeout_msec:      timeout period
>   *
>   * This takes the block device bd_mount_sem to make sure no new mounts
>   * happen on bdev until thaw_bdev() is called.
>   * If a superblock is found on this device, we take the s_umount semaphore
>   * on it to make sure nobody unmounts until the snapshot creation is done.
> + * If timeout_msec is bigger than 0, this registers the delayed work for
> + * timeout of the freeze feature.
>   */
> -struct super_block *freeze_bdev(struct block_device *bdev)
> +struct super_block *freeze_bdev(struct block_device *bdev, long timeout_msec)

timeout_msec is good.

>  {
>  	struct super_block *sb;
>  
> @@ -234,6 +237,10 @@ struct super_block *freeze_bdev(struct b
>  	}
>  
>  	sync_blockdev(bdev);
> +	/* Setup unfreeze timer. */
> +	if (timeout_msec > 0)
> +		add_freeze_timeout(bdev, timeout_msec);
> +
>  	clear_bit(BD_FREEZE_OP, &bdev->bd_state);
>  
>  	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
> @@ -258,6 +265,9 @@ int thaw_bdev(struct block_device *bdev,
>  		return 0;
>  	}
>  
> +	/* Delete unfreeze timer. */
> +	del_freeze_timeout(bdev);
> +
>  	if (sb) {
>  		BUG_ON(sb->s_bdev != bdev);
>  
> diff -uprN -X linux-2.6.26-rc7.org/Documentation/dontdiff linux-2.6.26-rc7-xfs/fs/ioctl.c linux-2.6.26-rc7-timeout/fs/io
> ctl.c
> --- linux-2.6.26-rc7-xfs/fs/ioctl.c	2008-06-23 11:55:15.000000000 +0900
> +++ linux-2.6.26-rc7-timeout/fs/ioctl.c	2008-06-23 11:56:47.000000000 +0900
> @@ -145,12 +145,16 @@ static int ioctl_fioasync(unsigned int f
>   * ioctl_freeze - Freeze the filesystem.
>   *
>   * @filp:	target file
> + * @argp:       timeout value(sec)
>   *
>   * Call freeze_bdev() to freeze the filesystem.
>   */
> -static int ioctl_freeze(struct file *filp)
> +static int ioctl_freeze(struct file *filp, unsigned long arg)
>  {
> +	long timeout_sec;
> +	long timeout_msec;
>  	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +	int error;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -159,8 +163,27 @@ static int ioctl_freeze(struct file *fil
>  	if (sb->s_op->write_super_lockfs == NULL)
>  		return -EOPNOTSUPP;
>  
> +	/* arg(sec) to tick value. */
> +	error = get_user(timeout_sec, (long __user *) arg);

uh-oh, compat problems.

A 32-bit application running under a 32-bit kernel will need to provide
a 32-bit quantity.

A 32-bit application running under a 64-bit kernel will need to provide
a 64-bit quantity.

I suggest that you go through the entire patch and redo this part of
the kernel ABI in terms of __u32, and avoid any mention of "long" in
the kernel<->userspace interface.

> +	if (error != 0)
> +		return error;
> +	/*
> +	 * If 1 is specified as the timeout period,
> +	 * it will be changed into 0 to keep the compatibility
> +	 * of XFS application(xfs_freeze).
> +	 */
> +	if (timeout_sec < 0)
> +		return -EINVAL;
> +	else if (timeout_sec < 2)
> +		timeout_sec = 0;

The `else' is unneeded.

It would be clearer to code this all as:

	if (timeout_sec < 0)
		return -EINVAL;

	if (timeout_sec == 1) {
		/*
		 * If 1 is specified as the timeout period it is changed into 0
		 * to retain compatibility with XFS's xfs_freeze.
		 */
		timeout_sec = 0;
	}
		
	
> +	timeout_msec = timeout_sec * 1000;
> +	/* overflow case */
> +	if (timeout_msec < 0)
> +		return -EINVAL;
> +
>  	/* Freeze */
> -	sb = freeze_bdev(sb->s_bdev);
> +	sb = freeze_bdev(sb->s_bdev, timeout_msec);
>  	if (IS_ERR(sb))
>  		return PTR_ERR(sb);
>  	return 0;
> @@ -185,6 +208,51 @@ static int ioctl_thaw(struct file *filp)
>  }
>  
>  /*
> + * ioctl_freeze_reset_timeout - Reset timeout for freeze.
> + *
> + * @filp:       target file
> + * @argp:       timeout value(sec)
> + *
> + * Rest timeout for freeze.

typo

> + */
> +static int
> +ioctl_freeze_reset_timeout(struct file *filp, unsigned long arg)
> +{
> +	long timeout_sec;
> +	long timeout_msec;
> +	struct super_block *sb
> +			= filp->f_path.dentry->d_inode->i_sb;

Unneeded linebreak there.

> +	int error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* arg(sec) to tick value */
> +	error = get_user(timeout_sec, (long __user *) arg);

compat issues.

> +	if (error)
> +		return error;
> +	timeout_msec = timeout_sec * 1000;
> +	if (timeout_msec < 0)
> +		return -EINVAL;

um, OK, but timeout_msec could have overflowed during the
multiplication and could be complete garbage.  I guess it doesn't
matter much, but a cleaner approach might be:

	if (timeout_sec > LONG_MAX/1000)
		return -EINVAL;

or something like that.

But otoh, why do the multiplication at all?  If we're able to handle
the timeout down to the millisecond level, why not offer that
resolution to userspace?  Offer the increased time granularity to the
application?

> +	if (sb) {

Can this happen?

> +		if (test_and_set_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state))
> +			return -EBUSY;
> +		if (sb->s_frozen == SB_UNFROZEN) {
> +			clear_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state);
> +			return -EINVAL;
> +		}
> +		/* setup unfreeze timer */
> +		if (timeout_msec > 0)

What does this test do?  afacit it's special-casing the timeout_secs==0
case.  Was this feature documented?  What does it do?

> +			add_freeze_timeout(sb->s_bdev,
> +					timeout_msec);
> +		clear_bit(BD_FREEZE_OP, &sb->s_bdev->bd_state);
> +	}
> +
> +	return 0;
> +}
> +
>
> ...
>
> +void add_freeze_timeout(struct block_device *bdev, long timeout_msec)
> +{
> +	s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
> +
> +	/* Set delayed work queue */
> +	cancel_delayed_work(&bdev->bd_freeze_timeout);

Should this have used cancel_delayed_work_sync()?

> +	schedule_delayed_work(&bdev->bd_freeze_timeout, timeout_jiffies);
> +}
> +
> +/*
> + * del_freeze_timeout - Delete timeout for freeze.
> + *
> + * @bdev:	block device struct
> + *
> + * Delete the delayed work for freeze timeout from the delayed work queue.
> + */
> +void del_freeze_timeout(struct block_device *bdev)
> +{
> +	if (delayed_work_pending(&bdev->bd_freeze_timeout))

Is this test needed?

> +		cancel_delayed_work(&bdev->bd_freeze_timeout);

cancel_delayed_work_sync()?

> +}
> diff -uprN -X linux-2.6.26-rc7.org/Documentation/dontdiff linux-2.6.26-rc7-xfs/fs/xfs/xfs_fsops.c linux-2.6.26-rc7-timeo
> ut/fs/xfs/xfs_fsops.c
> --- linux-2.6.26-rc7-xfs/fs/xfs/xfs_fsops.c	2008-06-23 11:55:15.000000000 +0900
> +++ linux-2.6.26-rc7-timeout/fs/xfs/xfs_fsops.c	2008-06-23 11:56:47.000000000 +0900
> @@ -619,7 +619,7 @@ xfs_fs_goingdown(
>  {
>  	switch (inflags) {
>  	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
> -		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
> +		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);

Using NULL here is clearer and will, I expect, avoid a sparse warning.

>
> ...
>
