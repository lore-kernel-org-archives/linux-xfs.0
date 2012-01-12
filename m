Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CJu4VD016113 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 13:56:04 -0600
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id XXnU4Q9FjeRxN3k6 for
	<xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:56:03 -0800 (PST)
Subject: Re: [PATCH 2/4] vfs: Protect write paths by sb_start_write -
	sb_end_write
Mime-Version: 1.0 (Apple Message framework v1084)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1326331253-6497-3-git-send-email-jack@suse.cz>
Date: Thu, 12 Jan 2012 12:56:01 -0700
Message-Id: <FA7A1011-4312-4050-8AD5-C6060CFF3A55@dilger.ca>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<1326331253-6497-3-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 2012-01-11, at 6:20 PM, Jan Kara wrote:
> There are three entry points which dirty pages in a filesystem.  mmap (handled
> by block_page_mkwrite()), buffered write (handled by
> __generic_file_aio_write()), and truncate (it can dirty last partial page -
> handled by do_truncate()). Protect these places with sb_start_write() and
> sb_end_write().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> fs/buffer.c  |   18 ++----------------
> fs/open.c    |    6 ++++++
> mm/filemap.c |    3 ++-
> 3 files changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 19d8eb7..8519405 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2371,18 +2371,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,

The comment for __block_page_mkwrite() needs to be updated to reference
sb_start_write() and sb_end_write() instead of vfs_check_frozen().

Cheers, Andreas

> 	if (unlikely(ret < 0))
> 		goto out_unlock;
> -	/*
> -	 * Freezing in progress? We check after the page is marked dirty and
> -	 * with page lock held so if the test here fails, we are sure freezing
> -	 * code will wait during syncing until the page fault is done - at that
> -	 * point page will be dirty and unlocked so freezing code will write it
> -	 * and writeprotect it again.
> -	 */
> 	set_page_dirty(page);
> -	if (inode->i_sb->s_frozen != SB_UNFROZEN) {
> -		ret = -EAGAIN;
> -		goto out_unlock;
> -	}
> 	wait_on_page_writeback(page);
> 	return 0;
> out_unlock:
> @@ -2397,12 +2386,9 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> 	int ret;
> 	struct super_block *sb = vma->vm_file->f_path.dentry->d_inode->i_sb;
> 
> -	/*
> -	 * This check is racy but catches the common case. The check in
> -	 * __block_page_mkwrite() is reliable.
> -	 */
> -	vfs_check_frozen(sb, SB_FREEZE_WRITE);
> +	sb_start_write(sb);
> 	ret = __block_page_mkwrite(vma, vmf, get_block);
> +	sb_end_write(sb);
> 	return block_page_mkwrite_return(ret);
> }
> EXPORT_SYMBOL(block_page_mkwrite);
> diff --git a/fs/open.c b/fs/open.c
> index 22c41b5..ee17c90 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -55,8 +55,14 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
> 	if (ret)
> 		newattrs.ia_valid |= ret | ATTR_FORCE;
> 
> +	/*
> +	 * Truncate can dirty last partial page so we need protection against
> +	 * filesystem freezing.
> +	 */
> 	mutex_lock(&dentry->d_inode->i_mutex);
> +	sb_start_write(dentry->d_sb);
> 	ret = notify_change(dentry, &newattrs);
> +	sb_end_write(dentry->d_sb);
> 	mutex_unlock(&dentry->d_inode->i_mutex);
> 	return ret;
> }
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c0018f2..6566c73 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2529,7 +2529,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> 	count = ocount;
> 	pos = *ppos;
> 
> -	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> +	sb_start_write(inode->i_sb);
> 
> 	/* We can write back this queue in page reclaim */
> 	current->backing_dev_info = mapping->backing_dev_info;
> @@ -2601,6 +2601,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> 				pos, ppos, count, written);
> 	}
> out:
> +	sb_end_write(inode->i_sb);
> 	current->backing_dev_info = NULL;
> 	return written ? written : err;
> }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
