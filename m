Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35161 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752490AbeAZJGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 04:06:53 -0500
Date: Fri, 26 Jan 2018 01:06:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: reflink should break pnfs leases before
 sharing blocks
Message-ID: <20180126090652.GA29115@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676028366.12349.7219306586282315379.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676028366.12349.7219306586282315379.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:18:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Before we share blocks between files, we need to break the pnfs leases
> on the layout before we start slicing and dicing the block map.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 47aea2e..f89a725 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1245,6 +1245,50 @@ xfs_reflink_remap_blocks(
>  }
>  
>  /*
> + * Grab the exclusive iolock for a data copy from src to dest, making
> + * sure to abide vfs locking order (lowest pointer value goes first) and
> + * breaking the pnfs layout leases on dest before proceeding.  The loop
> + * is needed because we cannot call the blocking break_layout() with the
> + * src iolock held, and therefore have to back out both locks.
> + */
> +static int
> +xfs_iolock_two_inodes_and_break_layout(
> +	struct inode		*src,
> +	struct inode		*dest)
> +{
> +	bool			src_first = src < dest;
> +	bool			src_last = src > dest;

I find the double predicates here highly confusing.

Also the code doesn't seem to handle the src == dest case as
far as I can tell.

> +retry:
> +	if (src_first) {
> +		inode_lock(src);
> +		inode_lock_nested(dest, I_MUTEX_NONDIR2);
> +	} else {
> +		inode_lock(dest);
> +	}

Shouldn't this be replaced by a call to lock_two_nondirectories?
Even if that holds both locks over the noon-blocking break_layout
it makes things a lot simpler and only does an additional rountrip
for the layouts outstanding slow path.

> +	error = break_layout(dest, false);
> +	if (error == -EWOULDBLOCK) {
> +		inode_unlock(dest);
> +		if (src_first)
> +			inode_unlock(src);

unlock_two_nondirectories?

> +		error = break_layout(dest, true);
> +		if (error)
> +			return error;
> +		goto retry;
> +	} else if (error) {

no need for an else after a goto.

> +		inode_unlock(dest);
> +		if (src_first)
> +			inode_unlock(src);

unlock_two_nondirectories?

Also seems like this could be simplified to:

	if (error) {
		unlock_two_nondirectories()
		if (error == -EWOULDBLOCK)
			goto retry;
		return error;
	}

So I guess the whole thing could simply become something like:

retry:
	lock_two_nondirectories(src, dest);
	error = break_layout(dest, false);
	if (error) {
		unlock_two_nondirectories(src, dest);
		if (error == -EWOULDBLOCK)
			goto retry;
		return error;
	}

and could probably just be inlined into the caller..
