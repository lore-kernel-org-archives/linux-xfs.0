Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26251 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751522AbdJCU6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:58:46 -0400
Date: Wed, 4 Oct 2017 07:58:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 2/5] fs: freeze on suspend and thaw on resume
Message-ID: <20171003205841.GN3666@dastard>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003185313.1017-3-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 11:53:10AM -0700, Luis R. Rodriguez wrote:
> This uses the existing filesystem freeze and thaw callbacks to
> freeze each filesystem on suspend/hibernation and thaw upon resume.
> 
> This is needed so that we properly really stop IO in flight without
> races after userspace has been frozen. Without this we rely on
> kthread freezing and its semantics are loose and error prone.
> For instance, even though a kthread may use try_to_freeze() and end
> up being frozen we have no way of being sure that everything that
> has been spawned asynchronously from it (such as timers) have also
> been stopped as well.
> 
> A long term advantage of also adding filesystem freeze / thawing
> supporting durign suspend / hibernation is that long term we may
> be able to eventually drop the kernel's thread freezing completely
> as it was originally added to stop disk IO in flight as we hibernate
> or suspend.
> 
> This also implies that many kthread users exist which have been
> adding freezer semantics onto its kthreads without need. These also
> will need to be reviewed later.
> 
> This is based on prior work originally by Rafael Wysocki and later by
> Jiri Kosina.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  fs/super.c             | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h     | 13 +++++++++
>  kernel/power/process.c | 14 ++++++++-
>  3 files changed, 105 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index d45e92d9a38f..ce8da8b187b1 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1572,3 +1572,82 @@ int thaw_super(struct super_block *sb)
>  	return 0;
>  }
>  EXPORT_SYMBOL(thaw_super);
> +
> +#ifdef CONFIG_PM_SLEEP
> +static bool super_allows_freeze(struct super_block *sb)
> +{
> +	return !!(sb->s_type->fs_flags & FS_FREEZE_ON_SUSPEND);
> +}

That's a completely misleading function name. All superblocks can be
frozen - freeze_super() is filesystem independent. And given that, I
don't see why these super_should_freeze() hoops need to be jumped
through...

> +
> +static bool super_should_freeze(struct super_block *sb)
> +{
> +	if (!sb->s_root)
> +		return false;
> +	if (!(sb->s_flags & MS_BORN))
> +		return false;
> +	/*
> +	 * We don't freeze virtual filesystems, we skip those filesystems with
> +	 * no backing device.
> +	 */
> +	if (sb->s_bdi == &noop_backing_dev_info)
> +		return false;
> +	/* No need to freeze read-only filesystems */
> +	if (sb->s_flags & MS_RDONLY)
> +		return false;
> +	if (!super_allows_freeze(sb))
> +		return false;
> +
> +	return true;
> +}

> +
> +int fs_suspend_freeze_sb(struct super_block *sb, void *priv)
> +{
> +	int error = 0;
> +
> +	spin_lock(&sb_lock);
> +	if (!super_should_freeze(sb))
> +		goto out;
> +
> +	up_read(&sb->s_umount);
> +	pr_info("%s (%s): freezing\n", sb->s_type->name, sb->s_id);
> +	error = freeze_super(sb);
> +	down_read(&sb->s_umount);
> +out:
> +	if (error && error != -EBUSY)
> +		pr_notice("%s (%s): Unable to freeze, error=%d",
> +			  sb->s_type->name, sb->s_id, error);
> +	spin_unlock(&sb_lock);
> +	return error;
> +}

I don't think this was ever tested.  Calling freeze_super() with a
spinlock held with through "sleeping in atomic" errors all over the
place.

Also, the s_umount lock juggling is nasty. Your new copy+pasted
iterate_supers_reverse() takes the lock in read mode, yet all the
freeze/thaw callers here want to take it in write mode. So, really,
iterate_supers_reverse() needs to be iterate_supers_reverse_excl()
and take the write lock, and freeze_super/thaw_super need to be
factored into locked and unlocked versions.

In which case, we end up with:

int fs_suspend_freeze_sb(struct super_block *sb, void *priv)
{
	return freeze_locked_super(sb);
}

int fs_suspend_thaw_sb(struct super_block *sb, void *priv)
{
	return thaw_locked_super(sb);
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
