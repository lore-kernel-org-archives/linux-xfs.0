Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACKg5bV251040 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 14:42:05 -0600
Message-ID: <50A15F97.3020901@sgi.com>
Date: Mon, 12 Nov 2012 14:44:07 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: remove xfs_wait_on_pages()
References: <1352455804-17045-1-git-send-email-david@fromorbit.com>
	<1352455804-17045-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1352455804-17045-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/09/2012 04:10 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's just a simple wrapper around a VFS function that is only called
> by another function in xfs_fs_subr.c. Remove it and call the VFS
> function directly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fs_subr.c  |   18 ++----------------
>  fs/xfs/xfs_vnodeops.h |    1 -
>  2 files changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
> index d49de3d..3365823 100644
> --- a/fs/xfs/xfs_fs_subr.c
> +++ b/fs/xfs/xfs_fs_subr.c
> @@ -62,23 +62,9 @@ xfs_flush_pages(
>  				last == -1 ? LLONG_MAX : last);
>  	if (flags & XBF_ASYNC)
>  		return ret;
> -	ret2 = xfs_wait_on_pages(ip, first, last);
> +	ret2 = -filemap_fdatawait_range(mapping, first,
> +				last == -1 ? XFS_ISIZE(ip) - 1 : last);
>  	if (!ret)
>  		ret = ret2;
>  	return ret;
>  }
> -
> -int
> -xfs_wait_on_pages(
> -	xfs_inode_t	*ip,
> -	xfs_off_t	first,
> -	xfs_off_t	last)
> -{
> -	struct address_space *mapping = VFS_I(ip)->i_mapping;
> -
> -	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
> -		return -filemap_fdatawait_range(mapping, first,
> -					last == -1 ? XFS_ISIZE(ip) - 1 : last);
> -	}
> -	return 0;
> -}
> diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
> index d48141d..c8ad48b 100644
> --- a/fs/xfs/xfs_vnodeops.h
> +++ b/fs/xfs/xfs_vnodeops.h
> @@ -52,7 +52,6 @@ int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
>  		xfs_off_t last, int fiopt);
>  int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
>  		xfs_off_t last, uint64_t flags, int fiopt);
> -int xfs_wait_on_pages(struct xfs_inode *ip, xfs_off_t first, xfs_off_t last);
>  
>  int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
>  int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
> 

Looks good!

Reviewed-by: Andrew Dahl <adahl@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
