Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727565AbfGEOwO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 10:52:14 -0400
Date: Fri, 5 Jul 2019 10:52:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: refactor attr scrub memory allocation function
Message-ID: <20190705145211.GF37448@bfoster>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158201810.495944.4418480612524937333.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158201810.495944.4418480612524937333.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:46:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that allocates memory buffers for the extended attribute
> scrub code into a separate function so we can reduce memory allocations
> in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/attr.c |   33 ++++++++++++++++++++++++---------
>  fs/xfs/scrub/attr.h |    2 ++
>  2 files changed, 26 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index fd16eb3fa003..c20b6da1db84 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -31,26 +31,41 @@
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/xattr.h>
>  
> -/* Set us up to scrub an inode's extended attributes. */
> +/* Allocate enough memory to hold an attr value and attr block bitmaps. */
>  int
> -xchk_setup_xattr(
> +xchk_setup_xattr_buf(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	size_t			value_size)
>  {
>  	size_t			sz;
>  
>  	/*
> -	 * Allocate the buffer without the inode lock held.  We need enough
> -	 * space to read every xattr value in the file or enough space to
> -	 * hold three copies of the xattr free space bitmap.  (Not both at
> -	 * the same time.)
> +	 * We need enough space to read an xattr value from the file or enough
> +	 * space to hold three copies of the xattr free space bitmap.  We don't
> +	 * need the buffer space for both purposes at the same time.
>  	 */
> -	sz = max_t(size_t, XATTR_SIZE_MAX, 3 * sizeof(long) *
> -			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize));
> +	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
> +	sz = max_t(size_t, sz, value_size);
> +
>  	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> +	return 0;
> +}
> +
> +/* Set us up to scrub an inode's extended attributes. */
> +int
> +xchk_setup_xattr(
> +	struct xfs_scrub	*sc,
> +	struct xfs_inode	*ip)
> +{
> +	int			error;
> +
> +	error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX);
> +	if (error)
> +		return error;
> +
>  	return xchk_setup_inode_contents(sc, ip, 0);
>  }
>  
> diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
> index 88bb5e29c60c..27e879aeaafc 100644
> --- a/fs/xfs/scrub/attr.h
> +++ b/fs/xfs/scrub/attr.h
> @@ -62,4 +62,6 @@ xchk_xattr_dstmap(
>  			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
>  }
>  
> +int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
> +
>  #endif	/* __XFS_SCRUB_ATTR_H__ */
> 
