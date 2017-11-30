Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753234AbdK3Q5L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 11:57:11 -0500
Date: Thu, 30 Nov 2017 17:57:07 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/11] fs: add iterate_supers_excl() and
 iterate_supers_reverse_excl()
Message-ID: <20171130165707.GD28180@quack2.suse.cz>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129232356.28296-6-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 29-11-17 15:23:50, Luis R. Rodriguez wrote:
> There are use cases where we wish to traverse the superblock list
> but also capture errors, and in which case we want to avoid having
> our callers issue a lock themselves since we can do the locking for
> the callers. Provide a iterate_supers_excl() which calls a function
> with the write lock held. If an error occurs we capture it and
> propagate it.
> 
> Likewise there are use cases where we wish to traverse the superblock
> list but in reverse order. The new iterate_supers_reverse_excl() helpers
> does this but also also captures any errors encountered.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/super.c         | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |  2 ++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/fs/super.c b/fs/super.c
> index a63513d187e8..885711c1d35b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -605,6 +605,97 @@ void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
>  	spin_unlock(&sb_lock);
>  }
>  
> +/**
> + *	iterate_supers_excl - exclusively call func for all active superblocks
> + *	@f: function to call
> + *	@arg: argument to pass to it
> + *
> + *	Scans the superblock list and calls given function, passing it
> + *	locked superblock and given argument. Returns 0 unless an error
> + *	occurred on calling the function on any superblock.
> + */
> +int iterate_supers_excl(int (*f)(struct super_block *, void *), void *arg)
> +{
> +	struct super_block *sb, *p = NULL;
> +	int error = 0;
> +
> +	spin_lock(&sb_lock);
> +	list_for_each_entry(sb, &super_blocks, s_list) {
> +		if (hlist_unhashed(&sb->s_instances))
> +			continue;
> +		sb->s_count++;
> +		spin_unlock(&sb_lock);
> +
> +		down_write(&sb->s_umount);
> +		if (sb->s_root && (sb->s_flags & SB_BORN)) {
> +			error = f(sb, arg);
> +			if (error) {
> +				up_write(&sb->s_umount);
> +				spin_lock(&sb_lock);
> +				__put_super(sb);
> +				break;
> +			}
> +		}
> +		up_write(&sb->s_umount);
> +
> +		spin_lock(&sb_lock);
> +		if (p)
> +			__put_super(p);
> +		p = sb;
> +	}
> +	if (p)
> +		__put_super(p);
> +	spin_unlock(&sb_lock);
> +
> +	return error;
> +}
> +
> +/**
> + *	iterate_supers_reverse_excl - exclusively calls func in reverse order
> + *	@f: function to call
> + *	@arg: argument to pass to it
> + *
> + *	Scans the superblock list and calls given function, passing it
> + *	locked superblock and given argument, in reverse order, and holding
> + *	the s_umount write lock. Returns if an error occurred.
> + */
> +int iterate_supers_reverse_excl(int (*f)(struct super_block *, void *),
> +					 void *arg)
> +{
> +	struct super_block *sb, *p = NULL;
> +	int error = 0;
> +
> +	spin_lock(&sb_lock);
> +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> +		if (hlist_unhashed(&sb->s_instances))
> +			continue;
> +		sb->s_count++;
> +		spin_unlock(&sb_lock);
> +
> +		down_write(&sb->s_umount);
> +		if (sb->s_root && (sb->s_flags & SB_BORN)) {
> +			error = f(sb, arg);
> +			if (error) {
> +				up_write(&sb->s_umount);
> +				spin_lock(&sb_lock);
> +				__put_super(sb);
> +				break;
> +			}
> +		}
> +		up_write(&sb->s_umount);
> +
> +		spin_lock(&sb_lock);
> +		if (p)
> +			__put_super(p);
> +		p = sb;
> +	}
> +	if (p)
> +		__put_super(p);
> +	spin_unlock(&sb_lock);
> +
> +	return error;
> +}
> +
>  /**
>   *	iterate_supers_type - call function for superblocks of given type
>   *	@type: fs type
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 107725b20fad..fe90b6542697 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3164,6 +3164,8 @@ extern struct super_block *get_active_super(struct block_device *bdev);
>  extern void drop_super(struct super_block *sb);
>  extern void drop_super_exclusive(struct super_block *sb);
>  extern void iterate_supers(void (*)(struct super_block *, void *), void *);
> +extern int iterate_supers_excl(int (*f)(struct super_block *, void *), void *arg);
> +extern int iterate_supers_reverse_excl(int (*)(struct super_block *, void *), void *);
>  extern void iterate_supers_type(struct file_system_type *,
>  			        void (*)(struct super_block *, void *), void *);
>  
> -- 
> 2.15.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
