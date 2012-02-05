Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q156DeC8013390 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 00:13:40 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id TcOKCXp6Y261DuCK for <xfs@oss.sgi.com>;
	Sat, 04 Feb 2012 22:13:38 -0800 (PST)
Message-ID: <4F2E1E12.2030308@sandeen.net>
Date: Sun, 05 Feb 2012 00:13:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/8] vfs: Protect write paths by sb_start_write -
	sb_end_write
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-3-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-3-git-send-email-jack@suse.cz>
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
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 1/20/12 2:34 PM, Jan Kara wrote:
> There are three entry points which dirty pages in a filesystem.  mmap (handled
> by block_page_mkwrite()), buffered write (handled by
> __generic_file_aio_write()), and truncate (it can dirty last partial page -
> handled inside each filesystem separately). Protect these places with
> sb_start_write() and sb_end_write().

The protection for truncate got lost since the first patchset, was that
on purpose?

-Eric

> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c  |   22 ++++------------------
>  mm/filemap.c |    3 ++-
>  2 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 19d8eb7..550714d 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2338,8 +2338,8 @@ EXPORT_SYMBOL(block_commit_write);
>   * beyond EOF, then the page is guaranteed safe against truncation until we
>   * unlock the page.
>   *
> - * Direct callers of this function should call vfs_check_frozen() so that page
> - * fault does not busyloop until the fs is thawed.
> + * Direct callers of this function should protect against filesystem freezing
> + * using sb_start_write() - sb_end_write() functions.
>   */
>  int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  			 get_block_t get_block)
> @@ -2371,18 +2371,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  
>  	if (unlikely(ret < 0))
>  		goto out_unlock;
> -	/*
> -	 * Freezing in progress? We check after the page is marked dirty and
> -	 * with page lock held so if the test here fails, we are sure freezing
> -	 * code will wait during syncing until the page fault is done - at that
> -	 * point page will be dirty and unlocked so freezing code will write it
> -	 * and writeprotect it again.
> -	 */
>  	set_page_dirty(page);
> -	if (inode->i_sb->s_frozen != SB_UNFROZEN) {
> -		ret = -EAGAIN;
> -		goto out_unlock;
> -	}
>  	wait_on_page_writeback(page);
>  	return 0;
>  out_unlock:
> @@ -2397,12 +2386,9 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	int ret;
>  	struct super_block *sb = vma->vm_file->f_path.dentry->d_inode->i_sb;
>  
> -	/*
> -	 * This check is racy but catches the common case. The check in
> -	 * __block_page_mkwrite() is reliable.
> -	 */
> -	vfs_check_frozen(sb, SB_FREEZE_WRITE);
> +	sb_start_write(sb, SB_FREEZE_WRITE);
>  	ret = __block_page_mkwrite(vma, vmf, get_block);
> +	sb_end_write(sb, SB_FREEZE_WRITE);
>  	return block_page_mkwrite_return(ret);
>  }
>  EXPORT_SYMBOL(block_page_mkwrite);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c0018f2..471b9ae 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2529,7 +2529,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  	count = ocount;
>  	pos = *ppos;
>  
> -	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
>  
>  	/* We can write back this queue in page reclaim */
>  	current->backing_dev_info = mapping->backing_dev_info;
> @@ -2601,6 +2601,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				pos, ppos, count, written);
>  	}
>  out:
> +	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
>  	current->backing_dev_info = NULL;
>  	return written ? written : err;
>  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
