Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 13:19:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LKIs6h019576
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 13:18:54 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64802F9D862
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 13:20:14 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id W2XFXplkzFyCvIOH for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 13:20:14 -0700 (PDT)
Date: Thu, 21 Aug 2008 13:20:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-Id: <20080821132006.9949101c.akpm@linux-foundation.org>
In-Reply-To: <20080818212856t-sato@mail.jp.nec.com>
References: <20080818212856t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>

On Mon, 18 Aug 2008 21:28:56 +0900
Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> The timeout feature is added to freeze ioctl.  And new ioctl
> to reset the timeout period is added.
> o Freeze the filesystem
>   int ioctl(int fd, int FIFREEZE, long *timeout_sec)
>     fd: The file descriptor of the mountpoint
>     FIFREEZE: request code for the freeze
>     timeout_sec: the timeout period in seconds
>              If it's 0 or 1, the timeout isn't set.
>              This special case of "1" is implemented to keep
>              the compatibility with XFS applications.
>     Return value: 0 if the operation succeeds. Otherwise, -1
> 
> o Reset the timeout period
>   int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeout_sec)
>     fd:file descriptor of mountpoint
>     FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
>     timeout_sec: new timeout period in seconds
>     Return value: 0 if the operation succeeds. Otherwise, -1
>     Error number: If the filesystem has already been unfrozen,
>                   errno is set to EINVAL.

I don't think the changelogs actually explained why this feature is
being added?

Which userspace tools are expected to send these ioctls?  Something in
util-linux?  dm-utils?  Are patches to those packages planned?

>
> ...
>
>  /*
> + * ioctl_freeze_reset_timeout - Reset timeout for freeze.
> + *
> + * @filp:       target file
> + * @argp:       timeout value(sec)
> + *
> + * Reset timeout for freeze.
> + */
> +static int
> +ioctl_freeze_reset_timeout(struct file *filp, int __user *argp)
> +{
> +	int timeout_sec;
> +	unsigned int timeout_msec;
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +	struct block_device *bdev = sb->s_bdev;
> +	int error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* If a regular file or a directory isn't specified, return EINVAL. */
> +	if (bdev == NULL)
> +		return -EINVAL;
> +
> +	/* arg(sec) to tick value */
> +	error = get_user(timeout_sec, argp);
> +	if (error)
> +		return error;
> +
> +	if (timeout_sec <= 0 || timeout_sec > UINT_MAX/1000)
> +		return -EINVAL;
> +
> +	timeout_msec = timeout_sec * 1000;
> +
> +	down(&bdev->bd_freeze_sem);
> +	if (!bdev->bd_freeze_count) {
> +		up(&bdev->bd_freeze_sem);
> +		return -EINVAL;
> +	}
> +	/* setup unfreeze timer */
> +	add_freeze_timeout(bdev, timeout_msec);
> +	up(&bdev->bd_freeze_sem);
> +
> +	return 0;
> +}

This duplicates quite a bit of code from ioctl_freeze().  Can this be
cleaned up?


> +/*
>   * When you add any new common ioctls to the switches above and below
>   * please update compat_sys_ioctl() too.
>   *
> @@ -235,13 +302,17 @@ int do_vfs_ioctl(struct file *filp, unsi
>  		break;
>  
>  	case FIFREEZE:
> -		error = ioctl_freeze(filp);
> +		error = ioctl_freeze(filp, argp);
>  		break;
>  
>  	case FITHAW:
>  		error = ioctl_thaw(filp);
>  		break;
>  
> +	case FIFREEZE_RESET_TIMEOUT:
> +		error = ioctl_freeze_reset_timeout(filp, argp);
> +		break;
> +
>  	default:
>  		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
>  			error = file_ioctl(filp, cmd, arg);
>
> ...
>
>  EXPORT_SYMBOL_GPL(kern_mount_data);
> +
> +/*
> + * freeze_timeout - Thaw the filesystem.
> + *
> + * @work:	work queue (delayed_work.work)
> + *
> + * Called by the delayed work when elapsing the timeout period.
> + * Thaw the filesystem.
> + */
> +void freeze_timeout(struct work_struct *work)
> +{
> +	struct block_device *bd = container_of(work,
> +			struct block_device, bd_freeze_timeout.work);
> +	struct super_block *sb = get_super(bd);
> +
> +	thaw_bdev(bd, sb);
> +
> +	if (sb)
> +		drop_super(sb);
> +}
> +EXPORT_SYMBOL_GPL(freeze_timeout);

I can't see why this was exported.

> +/*
> + * add_freeze_timeout - Add timeout for freeze.
> + *
> + * @bdev:		block device struct
> + * @timeout_msec:	timeout period
> + *
> + * Add the delayed work for freeze timeout to the delayed work queue.
> + */
> +void add_freeze_timeout(struct block_device *bdev, unsigned int timeout_msec)
> +{
> +	s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
> +
> +	/* Set delayed work queue */
> +	cancel_delayed_work_sync(&bdev->bd_freeze_timeout);
> +	schedule_delayed_work(&bdev->bd_freeze_timeout, timeout_jiffies);
> +}

I don't particularly like the names of these new global symbols.  The
kernel already has a "freezer" thing, part of power-management. 
Introducing another one is a bit confusing.

otoh, freezer seems to have consistently used "freezer", so the 'r'
arguable saves us.

Still, I'd have thought that "fsfreeze" would have been a clearer, more
specific identifier for the whole project.

> +/*
> + * del_freeze_timeout - Delete timeout for freeze.
> + *
> + * @bdev:	block device struct
> + *
> + * Delete the delayed work for freeze timeout from the delayed work queue.
> + */
> +void del_freeze_timeout(struct block_device *bdev)
> +{
> +	/*
> +	 * It's possible that the delayed work task (freeze_timeout()) calls
> +	 * del_freeze_timeout().  If the delayed work task calls
> +	 * cancel_delayed_work_sync((), the deadlock will occur.
> +	 * So we need this check (delayed_work_pending()).
> +	 */
> +	if (delayed_work_pending(&bdev->bd_freeze_timeout))
> +		cancel_delayed_work_sync(&bdev->bd_freeze_timeout);
> +}

So if the calling task is keventd via run_workqueue() then
delayed_work_pending() should return false due to run_workqueue()
ordering, so we avoid the deadlock.

Seems a bit racy if some other process starts the delayed-work while
this function is running but I guess the new semaphore prevents that.

Perhaps cancel_delayed_work_sync() shouldn't hang up if called from the
work handler?
