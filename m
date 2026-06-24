Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9103DD53B;
	Wed, 24 Jun 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782323659; cv=none; b=ovim6x9vrJx4syt4N0pfaUbBzuh/aSvJqG5wFKzKk8JL6VweyM38+8eNXBc0ykBfqgFHwO2lkpU2VxEZ04iM7EpGla+alewMp1C4kuAk2BwlwfIO30GoBHBEv5lgSPpaJU+cmybNrq5tBMYWwwP0Y0DVL1imQ7mxBfJ9KFllzdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782323659; c=relaxed/simple;
	bh=Ei0aoxqHXsqgximkJIsLmwPY89BVcMh4q8r0iMz7bU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIvZyOG/rAuE51nMcHc5IgXYAoNGC5rCEFhJpo0TfTO1rUrWQRcE/THdma/MEy+NkzVWHIUp1phNu2+/yNb7omgmmczUvd6zRm7l4meb9UjsssKVyBsZ38FF42dECjE/a22nOqYaBqIxEeCuyybpIlsgPuM90FpO0qS900idmk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohfBN4CZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohfBN4CZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 45C4B1F000E9;
	Wed, 24 Jun 2026 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782323658;
	bh=n2E8Koujq0uvPGlna4mr7jMR9YCJEf6gPjQNGHvZ2Xo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ohfBN4CZZ+vdeOflw8EvU1hiNw7Nq80ZI6Zr27sQqO5v8JF7ljFlttrPJC1sI5V/N
	 0zSO9m3aJYF+OYHHOgJVoU/sFRfwrs57uyo3jWjdYtWVA7J0RZDzkqD+RNB746PVoV
	 gfADQGfGId9SX4S1M4EgpByHV3jDu57fG/RWw2HRXjHnfG88CbLSg1bSQg3gIdgHDt
	 FXBy+ovvi91tczo0SiyacfoLP6MhlbuwJdrmDN7+b5zyIcw27QgL/Iizbs11DMIIn6
	 JmsmUQGUUx/poPPzQu+y/eSgjIgeucDjs/jOr6H7PZsqVBTMC1m9EOtnMSNdh6E0Cw
	 h5Z9XbPkv00ug==
Date: Wed, 24 Jun 2026 10:54:17 -0700
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
Subject: Re: [PATCH RFC v2 17/18] fs: look up the superblock via the device
 table in user_get_super()
Message-ID: <20260624175417.GU6078@frogsfrogsfrogs>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>

On Tue, Jun 16, 2026 at 04:08:33PM +0200, Christian Brauner wrote:
> user_get_super() still finds the superblock for a device number by
> walking the global super_blocks list under sb_lock. Every superblock is
> registered in the device table under its s_dev since sget_fc() inserts
> it there, including superblocks on anonymous devices, so use the table
> instead.
> 
> The refcount-pinning cursor helpers super_dev_{get,first,next}() only
> touch table state and do not depend on CONFIG_BLOCK, so drop the
> CONFIG_BLOCK guard around them: their new caller serves anonymous
> devices as well (ustat() on e.g. tmpfs) and is built without
> CONFIG_BLOCK. The guard falls in this patch rather than separately
> since without this caller the helpers would be unused without
> CONFIG_BLOCK.
> 
> The pinned entry holds a passive reference on the superblock so
> super_lock() can be called directly; once the superblock is locked grab
> a passive reference for the caller before dropping the pin.
> 
> The device table contains more than the old walk could find: a
> superblock is also registered for every additional device it claims
> (the xfs log and realtime devices, btrfs member devices, the ext4
> external journal, erofs blob devices). Don't filter those out:
> specifying any device a filesystem uses now resolves to that
> filesystem, so ustat() and quotactl() work on e.g. the xfs log device
> or a btrfs member device (the latter used to fail outright as btrfs
> superblocks carry an anonymous s_dev that never matches a member
> device). When several superblocks share a device (erofs blob devices)
> the first live superblock wins.

Does erofs have a means to find the other superblocks that share a
device given a notification coming in on one of them?  As hch says, it
feels weird to have a lookup mechanism when there's also an upcall
mechanism.

<shrug> I've been on vacation for a while so maybe I missed that there's
another use for the bdev->sb lookup?  There are 1600 more emails for me
to go through... :P

--D

> 
> The cursor also keeps scanning past dying superblocks where the old
> walk gave up after the first s_dev match, so a mount racing with the
> unmount of the same device (or with the reuse of a recycled anonymous
> dev_t) finds the live superblock where the old walk could spuriously
> return NULL.
> 
> This removes the last s_dev-keyed walk of the super_blocks list and
> takes ustat() and quotactl()'s block device lookup off sb_lock
> entirely.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/super.c | 28 ++++++++--------------------
>  1 file changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 2d0a07861bfc..93f24aea75c4 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -501,7 +501,6 @@ static int super_dev_register(struct super_block *sb)
>  	return err;
>  }
>  
> -#ifdef CONFIG_BLOCK
>  static struct super_dev *super_dev_get(struct rhlist_head *pos)
>  {
>  	struct super_dev *sb_dev;
> @@ -535,7 +534,6 @@ static struct super_dev *super_dev_next(struct super_dev *prev)
>  	super_dev_put(prev);
>  	return sb_dev;
>  }
> -#endif
>  
>  static void kill_super_notify(struct super_block *sb)
>  {
> @@ -1044,29 +1042,19 @@ EXPORT_SYMBOL(iterate_supers_type);
>  
>  struct super_block *user_get_super(dev_t dev, bool excl)
>  {
> -	struct super_block *sb;
> -
> -	spin_lock(&sb_lock);
> -	list_for_each_entry(sb, &super_blocks, s_list) {
> -		bool locked;
> +	struct super_dev *sb_dev;
>  
> -		if (sb->s_dev != dev)
> -			continue;
> +	for (sb_dev = super_dev_first(dev); sb_dev; sb_dev = super_dev_next(sb_dev)) {
> +		struct super_block *sb = sb_dev->sd_sb;
>  
> -		if (!refcount_inc_not_zero(&sb->s_passive))
> +		if (!super_lock(sb, excl))
>  			continue;
>  
> -		spin_unlock(&sb_lock);
> -
> -		locked = super_lock(sb, excl);
> -		if (locked)
> -			return sb;
> -
> -		put_super(sb);
> -		spin_lock(&sb_lock);
> -		break;
> +		/* The pinned entry holds a passive reference, take our own. */
> +		refcount_inc(&sb->s_passive);
> +		super_dev_put(sb_dev);
> +		return sb;
>  	}
> -	spin_unlock(&sb_lock);
>  	return NULL;
>  }
>  
> 
> -- 
> 2.47.3
> 
> 
