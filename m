Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752692AbdDDH65 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 03:58:57 -0400
Date: Tue, 4 Apr 2017 09:58:53 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Message-ID: <20170404075853.GB28522@quack2.suse.cz>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403185307.6243-7-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Mon 03-04-17 13:53:05, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Return EAGAIN if any of the following checks fail for direct I/O:
>  + i_rwsem is lockable
>  + Writing beyond end of file (will trigger allocation)
>  + Blocks are not allocated at the write location

Patches seem to be missing your Signed-off-by tag...

> @@ -235,9 +237,21 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  
>  	iocb->private = &overwrite;
>  	/* Check whether we do a DIO overwrite or not */
> -	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
> -	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
> -		overwrite = 1;
> +	if (o_direct && !unaligned_aio) {
> +		struct ext4_map_blocks map;
> +		if (ext4_blocks_mapped(inode, iocb->ki_pos,
> +				      iov_iter_count(from), &map)) {
> +	 		/* To exclude unwritten extents, we need to check
> +			 * m_flags.
> +			 */
> +			if (ext4_should_dioread_nolock(inode) &&
> +			    (map.m_flags & EXT4_MAP_MAPPED))
> +				overwrite = 1;
> +		} else if (iocb->ki_flags & IOCB_NOWAIT) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +	}

Actually, overwriting unwritten extents is relatively complex in ext4 as
well. In particular we need to start a transaction and split out the
written part of the extent. So I don't think we can easily support this
without blocking. As a result I'd keep the condition for IOCB_NOWAIT the
same as for overwrite IO.

> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -117,7 +117,7 @@ static struct file_system_type ext2_fs_type = {
>  	.name		= "ext2",
>  	.mount		= ext4_mount,
>  	.kill_sb	= kill_block_super,
> -	.fs_flags	= FS_REQUIRES_DEV,
> +	.fs_flags	= FS_REQUIRES_DEV | FS_NOWAIT,

FS_NOWAIT looks a bit too generic given these are filesystem feature flags.
Can we call it FS_NOWAIT_IO?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
