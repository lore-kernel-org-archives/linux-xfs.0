Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCB1F7F83
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 21:28:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4738FAC004
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 19:28:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	STMqIS0hu9PWRnBH for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 19:28:25 -0700 (PDT)
Date: Tue, 20 Aug 2013 12:28:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/5] fs: Add inode_update_time_writable
Message-ID: <20130820022822.GD6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
	<a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>

On Fri, Aug 16, 2013 at 04:22:09PM -0700, Andy Lutomirski wrote:
> This is like file_update_time, except that it acts on a struct inode *
> instead of a struct file *.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  fs/inode.c         | 72 ++++++++++++++++++++++++++++++++++++++++++------------
>  include/linux/fs.h |  1 +
>  2 files changed, 58 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index d6dfb09..bc90c12 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1637,6 +1637,34 @@ int file_remove_suid(struct file *file)
>  }
>  EXPORT_SYMBOL(file_remove_suid);
>  
> +/*
> + * This does the work that's common to file_update_time and
> + * inode_update_time.
> + */
> +static int prepare_update_cmtime(struct inode *inode, struct timespec *now)
> +{
> +	int sync_it;
> +
> +	/* First try to exhaust all avenues to not sync */
> +	if (IS_NOCMTIME(inode))
> +		return 0;
> +
> +	*now = current_fs_time(inode->i_sb);
> +	if (!timespec_equal(&inode->i_mtime, now))
> +		sync_it = S_MTIME;
> +
> +	if (!timespec_equal(&inode->i_ctime, now))
> +		sync_it |= S_CTIME;
> +
> +	if (IS_I_VERSION(inode))
> +		sync_it |= S_VERSION;
> +
> +	if (!sync_it)
> +		return 0;
> +
> +	return sync_it;
> +}
> +
>  /**
>   *	file_update_time	-	update mtime and ctime time
>   *	@file: file accessed
> @@ -1654,23 +1682,9 @@ int file_update_time(struct file *file)
>  {
>  	struct inode *inode = file_inode(file);
>  	struct timespec now;
> -	int sync_it = 0;
> +	int sync_it = prepare_update_cmtime(inode, &now);
>  	int ret;
>  
> -	/* First try to exhaust all avenues to not sync */
> -	if (IS_NOCMTIME(inode))
> -		return 0;
> -
> -	now = current_fs_time(inode->i_sb);
> -	if (!timespec_equal(&inode->i_mtime, &now))
> -		sync_it = S_MTIME;
> -
> -	if (!timespec_equal(&inode->i_ctime, &now))
> -		sync_it |= S_CTIME;
> -
> -	if (IS_I_VERSION(inode))
> -		sync_it |= S_VERSION;
> -
>  	if (!sync_it)
>  		return 0;
>  
> @@ -1685,6 +1699,34 @@ int file_update_time(struct file *file)
>  }
>  EXPORT_SYMBOL(file_update_time);
>  
> +/**
> + *	inode_update_time_writable	-	update mtime and ctime time
> + *	@inode: inode accessed
> + *
> + *	This is like file_update_time, but it assumes the mnt is writable
> + *	and takes an inode parameter instead.  (We need to assume the mnt
> + *	was writable because inodes aren't associated with any particular
> + *	mnt.
> + */
> +
> +int inode_update_time_writable(struct inode *inode)
> +{
> +	struct timespec now;
> +	int sync_it = prepare_update_cmtime(inode, &now);
> +	int ret;
> +
> +	if (!sync_it)
> +		return 0;
> +
> +	/* sb_start_pagefault and update_time can both sleep. */
> +	sb_start_pagefault(inode->i_sb);
> +	ret = update_time(inode, &now, sync_it);
> +	sb_end_pagefault(inode->i_sb);

This gets called from the writeback path - you can't use
sb_start_pagefault/sb_end_pagefault in that path.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
