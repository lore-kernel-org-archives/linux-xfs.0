Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33935 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbeCWOiA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Mar 2018 10:38:00 -0400
Date: Fri, 23 Mar 2018 10:37:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20180323143740.GD22357@bfoster.bfoster>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shaohua Li <shli@kernel.org>
Cc: linux-xfs@vger.kernel.org, Kernel-team@fb.com, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

On Thu, Mar 22, 2018 at 02:11:45PM -0700, Shaohua Li wrote:
> From: Shaohua Li <shli@fb.com>
> 
> Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> writeback support). Tested with a fio test, verified writeback is
> throttled against cgroup io.max write bandwidth, also verified moving
> the fio test to another cgroup and the writeback is throttled against
> new cgroup setting.
> 
> This only controls the file data write for cgroup. For metadata, since
> xfs dispatches the metadata write in specific threads, it's possible low
> prio app's metadata could harm high prio app's metadata. A while back,
> Tejun has a patch to force metadata belonging to root cgroup for btrfs.
> I had a similiar patch for xfs too. But Since Tejun's patch isn't in
> upstream, I'll delay post the xfs patch.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  fs/xfs/xfs_aops.c  | 13 +++++++++++--
>  fs/xfs/xfs_super.c |  1 +
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 19eadc8..5f70584 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -589,7 +589,8 @@ xfs_alloc_ioend(
>  	struct inode		*inode,
>  	unsigned int		type,
>  	xfs_off_t		offset,
> -	struct buffer_head	*bh)
> +	struct buffer_head	*bh,
> +	struct writeback_control *wbc)
>  {
>  	struct xfs_ioend	*ioend;
>  	struct bio		*bio;
> @@ -606,6 +607,8 @@ xfs_alloc_ioend(
>  	INIT_WORK(&ioend->io_work, xfs_end_io);
>  	ioend->io_append_trans = NULL;
>  	ioend->io_bio = bio;
> +	/* attach new bio to its cgroup */
> +	wbc_init_bio(wbc, bio);

Just a nit, but can we move the wbc_init_bio() calls to earlier in the
function where we setup/init the bio? (Same comment for
xfs_chain_bio()). Otherwise this looks fine to me and passes the posted
xfstests test.

Brian

>  	return ioend;
>  }
>  
> @@ -633,6 +636,8 @@ xfs_chain_bio(
>  	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
>  	submit_bio(ioend->io_bio);
>  	ioend->io_bio = new;
> +	/* attach new bio to its cgroup */
> +	wbc_init_bio(wbc, new);
>  }
>  
>  /*
> @@ -656,7 +661,8 @@ xfs_add_to_ioend(
>  	    offset != wpc->ioend->io_offset + wpc->ioend->io_size) {
>  		if (wpc->ioend)
>  			list_add(&wpc->ioend->io_list, iolist);
> -		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh);
> +		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset,
> +					     bh, wbc);
>  	}
>  
>  	/*
> @@ -666,6 +672,9 @@ xfs_add_to_ioend(
>  	while (xfs_bio_add_buffer(wpc->ioend->io_bio, bh) != bh->b_size)
>  		xfs_chain_bio(wpc->ioend, wbc, bh);
>  
> +	/* Charge write size to its cgroup for cgroup switching track */
> +	wbc_account_io(wbc, bh->b_page, bh->b_size);
> +
>  	wpc->ioend->io_size += bh->b_size;
>  	wpc->last_block = bh->b_blocknr;
>  	xfs_start_buffer_writeback(bh);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 951271f..95c2d3d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1666,6 +1666,7 @@ xfs_fs_fill_super(
>  	sb->s_max_links = XFS_MAXLINK;
>  	sb->s_time_gran = 1;
>  	set_posix_acl_flag(sb);
> +	sb->s_iflags |= SB_I_CGROUPWB;
>  
>  	/* version 5 superblocks support inode version counters. */
>  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
