Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbfFXQWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 12:22:25 -0400
Date: Mon, 24 Jun 2019 09:22:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: implement cgroup aware writeback
Message-ID: <20190624162215.GS5387@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
 <20190624134315.21307-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134315.21307-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Mon, Jun 24, 2019 at 03:43:15PM +0200, Christoph Hellwig wrote:
> Link every newly allocated writeback bio to cgroup pointed to by the
> writeback control structure, and charge every byte written back to it.
> 
> Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Was this tested by running shared/011?  Or did it involve other checks?

As I mentioned in the thread about shared/011, I think the test needs a
better way of figuring out if the filesystem under test actually
supports cgroup writeback so we don't cause failures that then have to
be put on a known-issue list for an old kernel.

FWIW that test looks like it only is testing the accounting, so that
might be as easy as trying a write and seeing if the numbers jump.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  | 4 +++-
>  fs/xfs/xfs_super.c | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9cceb90e77c5..73c291aeae17 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -700,6 +700,7 @@ xfs_alloc_ioend(
>  	bio->bi_iter.bi_sector = sector;
>  	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
>  	bio->bi_write_hint = inode->i_write_hint;
> +	wbc_init_bio(wbc, bio);
>  
>  	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
>  	INIT_LIST_HEAD(&ioend->io_list);
> @@ -727,7 +728,7 @@ xfs_chain_bio(
>  	struct bio *new;
>  
>  	new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
> -	bio_copy_dev(new, prev);
> +	bio_copy_dev(new, prev);/* also copies over blkcg information */
>  	new->bi_iter.bi_sector = bio_end_sector(prev);
>  	new->bi_opf = prev->bi_opf;
>  	new->bi_write_hint = prev->bi_write_hint;
> @@ -782,6 +783,7 @@ xfs_add_to_ioend(
>  	}
>  
>  	wpc->ioend->io_size += len;
> +	wbc_account_io(wbc, page, len);
>  }
>  
>  STATIC void
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 594c119824cc..ee0df8f611ff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1685,6 +1685,8 @@ xfs_fs_fill_super(
>  	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
>  	sb->s_max_links = XFS_MAXLINK;
>  	sb->s_time_gran = 1;
> +	sb->s_iflags |= SB_I_CGROUPWB;
> +
>  	set_posix_acl_flag(sb);
>  
>  	/* version 5 superblocks support inode version counters. */
> -- 
> 2.20.1
> 
