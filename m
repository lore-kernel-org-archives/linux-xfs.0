Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6459 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdFZNkr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jun 2017 09:40:47 -0400
Date: Mon, 26 Jun 2017 15:40:24 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v7 21/22] xfs: minimal conversion to errseq_t writeback
 error reporting
Message-ID: <20170626134024.mhnzoz5mjfrzkekd@eorzea.usersys.redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
 <20170616193427.13955-22-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616193427.13955-22-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Jun 16, 2017 at 03:34:26PM -0400, Jeff Layton wrote:
> Just check and advance the data errseq_t in struct file before
> before returning from fsync on normal files. Internal filemap_*
> callers are left as-is.
> 

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5fb5a0958a14..bc3b1575e8db 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -134,7 +134,7 @@ xfs_file_fsync(
>  	struct inode		*inode = file->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	int			error = 0;
> +	int			error = 0, err2;
>  	int			log_flushed = 0;
>  	xfs_lsn_t		lsn = 0;
>  
> @@ -142,10 +142,12 @@ xfs_file_fsync(
>  
>  	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
>  	if (error)
> -		return error;
> +		goto out;
>  
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return -EIO;
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		error = -EIO;
> +		goto out;
> +	}
>  
>  	xfs_iflags_clear(ip, XFS_ITRUNCATED);
>  
> @@ -197,6 +199,11 @@ xfs_file_fsync(
>  	    mp->m_logdev_targp == mp->m_ddev_targp)
>  		xfs_blkdev_issue_flush(mp->m_ddev_targp);
>  
> +out:
> +	err2 = filemap_report_wb_err(file);
> +	if (!error)
> +		error = err2;
> +
>  	return error;
>  }
>  
> -- 
> 2.13.0
> 

-- 
Carlos
