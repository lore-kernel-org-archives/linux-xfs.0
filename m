Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46080 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2S20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 14:28:26 -0400
Date: Wed, 29 May 2019 11:27:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 06/13] vfs: introduce file_modified() helper
Message-ID: <20190529182748.GF5231@magnolia>
References: <20190529174318.22424-1-amir73il@gmail.com>
 <20190529174318.22424-7-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529174318.22424-7-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, May 29, 2019 at 08:43:10PM +0300, Amir Goldstein wrote:
> The combination of file_remove_privs() and file_update_mtime() is
> quite common in filesystem ->write_iter() methods.
> 
> Modelled after the helper file_accessed(), introduce file_modified()
> and use it from generic_remap_file_range_prep().
> 
> Note that the order of calling file_remove_privs() before
> file_update_mtime() in the helper was matched to the more common order by
> filesystems and not the current order in generic_remap_file_range_prep().
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/inode.c         | 20 ++++++++++++++++++++
>  fs/read_write.c    | 21 +++------------------
>  include/linux/fs.h |  2 ++
>  3 files changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index df6542ec3b88..2885f2f2c7a5 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1899,6 +1899,26 @@ int file_update_time(struct file *file)
>  }
>  EXPORT_SYMBOL(file_update_time);
>  
> +/* Caller must hold the file's inode lock */
> +int file_modified(struct file *file)
> +{
> +	int err;
> +
> +	/*
> +	 * Clear the security bits if the process is not being run by root.
> +	 * This keeps people from modifying setuid and setgid binaries.
> +	 */
> +	err = file_remove_privs(file);
> +	if (err)
> +		return err;
> +
> +	if (likely(file->f_mode & FMODE_NOCMTIME))

I would not have thought NOCMTIME is likely?

Maybe it is for io requests coming from overlayfs, but for regular uses
I don't think that's true.

--D

> +		return 0;
> +
> +	return file_update_time(file);
> +}
> +EXPORT_SYMBOL(file_modified);
> +
>  int inode_needs_sync(struct inode *inode)
>  {
>  	if (IS_SYNC(inode))
> diff --git a/fs/read_write.c b/fs/read_write.c
> index b0fb1176b628..cec7e7b1f693 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1980,25 +1980,10 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  		return ret;
>  
>  	/* If can't alter the file contents, we're done. */
> -	if (!(remap_flags & REMAP_FILE_DEDUP)) {
> -		/* Update the timestamps, since we can alter file contents. */
> -		if (!(file_out->f_mode & FMODE_NOCMTIME)) {
> -			ret = file_update_time(file_out);
> -			if (ret)
> -				return ret;
> -		}
> +	if (!(remap_flags & REMAP_FILE_DEDUP))
> +		ret = file_modified(file_out);
>  
> -		/*
> -		 * Clear the security bits if the process is not being run by
> -		 * root.  This keeps people from modifying setuid and setgid
> -		 * binaries.
> -		 */
> -		ret = file_remove_privs(file_out);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL(generic_remap_file_range_prep);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e4d382c4342a..79ffa2958bd8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2177,6 +2177,8 @@ static inline void file_accessed(struct file *file)
>  		touch_atime(&file->f_path);
>  }
>  
> +extern int file_modified(struct file *file);
> +
>  int sync_inode(struct inode *inode, struct writeback_control *wbc);
>  int sync_inode_metadata(struct inode *inode, int wait);
>  
> -- 
> 2.17.1
> 
