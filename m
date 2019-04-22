Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55554 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbfDVTpz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Apr 2019 15:45:55 -0400
Subject: Re: [PATCH 04/10] libxfs: retain ifork_ops when flushing inode
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594791533.115924.7540619376750686973.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <792d8254-9901-5260-a948-1a0466223d90@sandeen.net>
Date: Mon, 22 Apr 2019 14:45:53 -0500
MIME-Version: 1.0
In-Reply-To: <155594791533.115924.7540619376750686973.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Arkadiusz Miskiewicz <arekm@maven.pl>

On 4/22/19 10:45 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Retain the ifork ops used to validate the inode so that we can use the
> same one to iflush it.  xfs_repair phase 6 can use multiple transactions
> to fix various inode problems, which means that the inode might not be
> fully fixed when each transaction commits.
> 
> This can be a particular problem if there's a shortform directory with
> both invalid directory entries and incorrect i8count.  Phase 3 will set
> the parent inode to "0" to signal to phase 6 that it needs to reset the
> parent and i8count, but phase 6 starts a transaction to junk the bad
> entries which fail to commit because the parent is invalid:
> 
> fixing i8count in inode 69022994673
> Invalid inode number 0x0
> xfs_dir_ino_validate: XFS_ERROR_REPORT
> Metadata corruption detected at 0x464eb0, inode 0x10121750f1 data fork
> xfs_repair: warning - iflush_int failed (-117)
> 
> And thus the inode fixes never get written out.
> 
> Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I might have combined this with the next patch, but I guess
I can see the rationale either way.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/xfs_inode.h |    1 +
>  libxfs/rdwr.c       |    1 +
>  libxfs/util.c       |    2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 79ec3a2d..e1e8b430 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -51,6 +51,7 @@ typedef struct xfs_inode {
>  
>  	xfs_fsize_t		i_size;		/* in-memory size */
>  	const struct xfs_dir_ops *d_ops;	/* directory ops vector */
> +	struct xfs_ifork_ops	*i_fork_ops;	/* fork verifiers */
>  	struct inode		i_vnode;
>  } xfs_inode_t;
>  
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index a00360e7..69d5abb2 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1391,6 +1391,7 @@ libxfs_iget(
>  		return error;
>  	}
>  
> +	ip->i_fork_ops = ifork_ops;
>  	if (!libxfs_inode_verify_forks(ip, ifork_ops)) {
>  		libxfs_irele(ip);
>  		return -EFSCORRUPTED;
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 4ac151e6..2e3b9d51 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -422,7 +422,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
>  		VFS_I(ip)->i_version++;
>  
>  	/* Check the inline fork data before we write out. */
> -	if (!libxfs_inode_verify_forks(ip, &xfs_default_ifork_ops))
> +	if (!libxfs_inode_verify_forks(ip, ip->i_fork_ops))
>  		return -EFSCORRUPTED;
>  
>  	/*
> 
