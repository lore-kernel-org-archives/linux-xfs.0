Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730408AbfAKPLI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 10:11:08 -0500
Date: Fri, 11 Jan 2019 10:11:06 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: check attribute name validity
Message-ID: <20190111151105.GD30640@bfoster>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
 <154697979588.2839.8961664194626235093.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154697979588.2839.8961664194626235093.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Jan 08, 2019 at 12:36:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check extended attribute entry names for invalid characters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c |   17 +++++++++++++++++
>  fs/xfs/libxfs/xfs_attr.h |    2 +-
>  fs/xfs/scrub/attr.c      |    6 ++++++
>  3 files changed, 24 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 844ed87b1900..2dd9ee2a2e08 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1336,3 +1336,20 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	xfs_da_state_free(state);
>  	return retval;
>  }
> +
> +/* Returns true if the attribute entry name is valid. */
> +bool
> +xfs_attr_namecheck(
> +	const void	*name,
> +	size_t		length)
> +{
> +	/*
> +	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
> +	 * out, so use >= for the length check.
> +	 */
> +	if (length >= MAXNAMELEN)
> +		return false;
> +
> +	/* There shouldn't be any nulls here */
> +	return !memchr(name, 0, length);
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index bdf52a333f3f..2297d8467666 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -145,6 +145,6 @@ int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
> -
> +bool xfs_attr_namecheck(const void *name, size_t length);
>  
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 9960bc5b5d76..dce74ec57038 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -93,6 +93,12 @@ xchk_xattr_listent(
>  		return;
>  	}
>  
> +	/* Does this name make sense? */
> +	if (!xfs_attr_namecheck(name, namelen)) {
> +		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
> +		return;
> +	}
> +
>  	args.flags = ATTR_KERNOTIME;
>  	if (flags & XFS_ATTR_ROOT)
>  		args.flags |= ATTR_ROOT;
> 
