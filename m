Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42626 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeC0HYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 03:24:47 -0400
Date: Tue, 27 Mar 2018 08:24:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH V2] fs: don't scan the inode cache before SB_BORN is set
Message-ID: <20180327072445.GS30522@ZenIV.linux.org.uk>
References: <20180326043503.17828-1-david@fromorbit.com>
 <20180327065756.GO18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327065756.GO18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Mar 27, 2018 at 05:57:56PM +1100, Dave Chinner wrote:
>  	 */
> +	smp_rmb();
> +	if (!(sb->s_flags & SB_BORN))
> +		return 0;
> +
>  	if (sb->s_op && sb->s_op->nr_cached_objects)
>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
> @@ -1227,7 +1237,13 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
>  	sb = root->d_sb;
>  	BUG_ON(!sb);
>  	WARN_ON(!sb->s_bdi);
> +
> +	/*
> +	 * Write barrier is for super_cache_count() to ensure it does not run
> +	 * until after the superblock is fully set up.
> +	 */
>  	sb->s_flags |= SB_BORN;
> +	smp_wmb();


Umm...  OK, I'm nearly asleep right now, but... shouldn't that be

	if (check ->s_flags)
		bugger off
	smp_rmb();
	loads
vs.
	stores
	smp_wmb();
	store ->s_flags?

IOW, your barriers seem to be in the wrong places...
