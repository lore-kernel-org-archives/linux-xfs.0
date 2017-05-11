Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59075 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754803AbdEKHmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 03:42:19 -0400
Date: Thu, 11 May 2017 00:42:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] nowait aio: Introduce RWF_NOWAIT
Message-ID: <20170511074218.GB15626@infradead.org>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
 <20170509122219.31756-3-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509122219.31756-3-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue, May 09, 2017 at 07:22:13AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This flag informs kernel to bail out if an AIO request will block
> for reasons such as file allocations, or a writeback triggered,
> or would block while allocating requests while performing
> direct I/O.
> 
> Unfortunately, aio_flags is not checked for validity, which would
> break existing applications which have it set to anything besides zero
> or IOCB_FLAG_RESFD. So, we are using aio_reserved1 and renaming it
> to aio_rw_flags.
> 
> RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.
> 
> The check for -EOPNOTSUPP is placed in generic_file_write_iter(). This
> is called by most filesystems, either through fsops.write_iter() or through
> the function defined by write_iter(). If not, we perform the check defined
> by .write_iter() which is called for direct IO specifically.
> 
> Filesystems xfs, btrfs and ext4 would be supported in the following patches.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/9p/vfs_file.c        | 3 +++
>  fs/aio.c                | 6 ++++++
>  fs/ceph/file.c          | 3 +++
>  fs/cifs/file.c          | 3 +++
>  fs/fuse/file.c          | 3 +++
>  fs/nfs/direct.c         | 3 +++
>  fs/ocfs2/file.c         | 3 +++
>  include/linux/fs.h      | 5 ++++-
>  include/uapi/linux/fs.h | 1 +
>  mm/filemap.c            | 3 +++
>  10 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 3de3b4a89d89..403681db7723 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -411,6 +411,9 @@ v9fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	loff_t origin;
>  	int err = 0;
>  
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		return -EOPNOTSUPP;
> +
>  	retval = generic_write_checks(iocb, from);
>  	if (retval <= 0)
>  		return retval;
> diff --git a/fs/aio.c b/fs/aio.c
> index 020fa0045e3c..ea9f8581d902 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1592,6 +1592,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  		goto out_put_req;
>  	}
>  
> +	if ((req->common.ki_flags & IOCB_NOWAIT) &&
> +		!(req->common.ki_flags & IOCB_DIRECT)) {

Weird indentation.  Either align after the opening if brace:

	if ((req->common.ki_flags & IOCB_NOWAIT) &&
	    !(req->common.ki_flags & IOCB_DIRECT)) {

or using two tabs:

	if ((req->common.ki_flags & IOCB_NOWAIT) &&
			!(req->common.ki_flags & IOCB_DIRECT)) {

if the first version looks confusing, but never using the same
indentation level as the following code.

Except for that the patch looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
