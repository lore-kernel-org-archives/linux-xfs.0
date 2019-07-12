Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfGLRvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jul 2019 13:51:00 -0400
Date: Fri, 12 Jul 2019 10:50:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] fs: Export generic_fadvise()
Message-ID: <20190712175052.GZ1404256@magnolia>
References: <20190711140012.1671-1-jack@suse.cz>
 <20190711140012.1671-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711140012.1671-3-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Boaz Harrosh <boaz@plexistor.com>, stable@vger.kernel.org

On Thu, Jul 11, 2019 at 04:00:11PM +0200, Jan Kara wrote:
> Filesystems will need to call this function from their fadvise handlers.
> 
> CC: stable@vger.kernel.org # Needed by "xfs: Fix stale data exposure when
> 					readahead races with hole punch"
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/linux/fs.h | 2 ++
>  mm/fadvise.c       | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f7fdfe93e25d..2666862ff00d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3536,6 +3536,8 @@ extern void inode_nohighmem(struct inode *inode);
>  /* mm/fadvise.c */
>  extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
>  		       int advice);
> +extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
> +			   int advice);
>  
>  #if defined(CONFIG_IO_URING)
>  extern struct sock *io_uring_get_socket(struct file *file);
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index 467bcd032037..4f17c83db575 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -27,8 +27,7 @@
>   * deactivate the pages and clear PG_Referenced.
>   */
>  
> -static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
> -			   int advice)
> +int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  {
>  	struct inode *inode;
>  	struct address_space *mapping;
> @@ -178,6 +177,7 @@ static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL(generic_fadvise);
>  
>  int vfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  {
> -- 
> 2.16.4
> 
