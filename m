Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3B267CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 10:34:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B66CAC003
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 08:34:41 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id J6oUoECYDKXQJG33 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 08:34:39 -0700 (PDT)
Date: Wed, 3 Aug 2016 17:34:37 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: don't invalidate whole file on DAX read/write
Message-ID: <20160803153437.GC4576@quack2.suse.cz>
References: <1470181226-20935-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470181226-20935-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, xfs@oss.sgi.com

On Wed 03-08-16 09:40:26, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we do DAX IO, we try to invalidate the entire page cache held
> on the file. This is incorrect as it will trash the entire mapping
> tree that now tracks dirty state in exceptional entries in the radix
> tree slots.
> 
> What we are trying to do is remove cached pages (e.g from reads
> into holes) that sit in the radix tree over the range we are about
> to write to. Hence we should just limit the invalidation to the
> range we are about to overwrite.

The patch looks good. Just one comment below.

> 
> Reported-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index ed95e5b..e612a02 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -741,9 +741,20 @@ xfs_file_dax_write(
>  	 * page is inserted into the pagecache when we have to serve a write
>  	 * fault on a hole.  It should never be dirtied and can simply be
>  	 * dropped from the pagecache once we get real data for the page.
> +	 *
> +	 * XXX: This is racy against mmap, and there's nothing we can do about
> +	 * it. dax_do_io() should really do this invalidation internally as
> +	 * it will know if we've allocated over a holei for this specific IO and
> +	 * if so it needs to update the mapping tree and invalidate existing
> +	 * PTEs over the newly allocated range. Remove this invalidation when
> +	 * dax_do_io() is fixed up.

And would it be OK for XFS if dax_do_io() actually invalidated page cache /
PTEs under just XFS_IOLOCK_SHARED? Because currently you seem to be careful
to call invalidate_inode_pages2() only when holding the lock exclusively
and then demote it to a shared one when calling dax_do_io().

								Honza

>  	 */
>  	if (mapping->nrpages) {
> -		ret = invalidate_inode_pages2(mapping);
> +		loff_t end = iocb->ki_pos + iov_iter_count(from) - 1;
> +
> +		ret = invalidate_inode_pages2_range(mapping,
> +						    iocb->ki_pos >> PAGE_SHIFT,
> +						    end >> PAGE_SHIFT);
>  		WARN_ON_ONCE(ret);
>  	}
>  
> -- 
> 2.8.0.rc3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
