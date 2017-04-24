Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46771 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1171358AbdDXPqZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 11:46:25 -0400
Date: Mon, 24 Apr 2017 17:46:13 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 04/20] fs: check for writeback errors after syncing
 out buffers in generic_file_fsync
Message-ID: <20170424154613.GG23988@quack2.suse.cz>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-5-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-5-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

On Mon 24-04-17 09:22:43, Jeff Layton wrote:
> ext2 currently does a test+clear of the AS_EIO flag, which is
> is problematic for some coming changes.
> 
> What we really need to do instead is call filemap_check_errors
> in __generic_file_fsync after syncing out the buffers. That
> will be sufficient for this case, and help other callers detect
> these errors properly as well.
> 
> With that, we don't need to twiddle it in ext2.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext2/file.c | 2 +-
>  fs/libfs.c     | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index b21891a6bfca..ed00e7ae0ef3 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -177,7 +177,7 @@ int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
>  
>  	ret = generic_file_fsync(file, start, end, datasync);
> -	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
> +	if (ret == -EIO) {
>  		/* We don't really know where the IO error happened... */
>  		ext2_error(sb, __func__,
>  			   "detected IO error when writing metadata buffers");
> diff --git a/fs/libfs.c b/fs/libfs.c
> index a8b62e5d43a9..12a48ee442d3 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -991,7 +991,8 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
>  
>  out:
>  	inode_unlock(inode);
> -	return ret;
> +	err = filemap_check_errors(inode->i_mapping);
> +	return ret ? : err;
>  }
>  EXPORT_SYMBOL(__generic_file_fsync);
>  
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
