Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728283AbfABJvD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jan 2019 04:51:03 -0500
Subject: Re: [PATCH 07/12] xfs: refactor eofblocks inode match code
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
 <154630905381.16693.3528654270887956753.stgit@magnolia>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c645b822-405e-cc3a-15e1-62a099e300b2@suse.com>
Date: Wed, 2 Jan 2019 11:50:58 +0200
MIME-Version: 1.0
In-Reply-To: <154630905381.16693.3528654270887956753.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 1.01.19 г. 4:17 ч., Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the code that determines if an inode matches an eofblocks
> structure into a helper, since we already use it twice and we're about
> to use it a third time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c |  146 ++++++++++++++++++++++++++-------------------------
>  1 file changed, 74 insertions(+), 72 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7e031eb6f048..c1b457ba1b7b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -27,6 +27,76 @@
>  #include <linux/freezer.h>
>  #include <linux/iversion.h>
>  
> +STATIC int
> +xfs_inode_match_id(

This is a predicate so make it bool

> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
> +{
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
> +	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
> +		return 0;
> +
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
> +	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
> +		return 0;
> +
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> +	    xfs_get_projid(ip) != eofb->eof_prid)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/*
> + * A union-based inode filtering algorithm. Process the inode if any of the
> + * criteria match. This is for global/internal scans only.
> + */
> +STATIC int

ditto

> +xfs_inode_match_id_union(
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
> +{
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
> +	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
> +		return 1;
> +
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
> +	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
> +		return 1;
> +
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> +	    xfs_get_projid(ip) == eofb->eof_prid)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/* Does this inode match the given parameters? */
> +STATIC bool
> +xfs_inode_matches_eofb(
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
> +{
> +	int			match;
> +
> +	if (!eofb)
> +		return true;
> +
> +	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> +		match = xfs_inode_match_id_union(ip, eofb);
> +	else
> +		match = xfs_inode_match_id(ip, eofb);
> +	if (!match)
> +		return false;
> +
> +	/* skip the inode if the file size is too small */
> +	if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> +	    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -1424,50 +1494,6 @@ xfs_reclaim_inodes_count(
>  	return reclaimable;
>  }
>  
> -STATIC int
> -xfs_inode_match_id(
> -	struct xfs_inode	*ip,
> -	struct xfs_eofblocks	*eofb)
> -{
> -	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
> -	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
> -		return 0;
> -
> -	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
> -	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
> -		return 0;
> -
> -	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    xfs_get_projid(ip) != eofb->eof_prid)
> -		return 0;
> -
> -	return 1;
> -}
> -
> -/*
> - * A union-based inode filtering algorithm. Process the inode if any of the
> - * criteria match. This is for global/internal scans only.
> - */
> -STATIC int
> -xfs_inode_match_id_union(
> -	struct xfs_inode	*ip,
> -	struct xfs_eofblocks	*eofb)
> -{
> -	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
> -	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
> -		return 1;
> -
> -	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
> -	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
> -		return 1;
> -
> -	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    xfs_get_projid(ip) == eofb->eof_prid)
> -		return 1;
> -
> -	return 0;
> -}
> -
>  STATIC int
>  xfs_inode_free_eofblocks(
>  	struct xfs_inode	*ip,
> @@ -1476,7 +1502,6 @@ xfs_inode_free_eofblocks(
>  {
>  	int ret = 0;
>  	struct xfs_eofblocks *eofb = args;
> -	int match;
>  
>  	if (!xfs_can_free_eofblocks(ip, false)) {
>  		/* inode could be preallocated or append-only */
> @@ -1493,19 +1518,8 @@ xfs_inode_free_eofblocks(
>  	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
>  		return 0;
>  
> -	if (eofb) {
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> -			match = xfs_inode_match_id_union(ip, eofb);
> -		else
> -			match = xfs_inode_match_id(ip, eofb);
> -		if (!match)
> -			return 0;
> -
> -		/* skip the inode if the file size is too small */
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> -		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> -			return 0;
> -	}
> +	if (!xfs_inode_matches_eofb(ip, eofb))
> +		return 0;
>  
>  	/*
>  	 * If the caller is waiting, return -EAGAIN to keep the background
> @@ -1766,25 +1780,13 @@ xfs_inode_free_cowblocks(
>  {
>  	struct xfs_eofblocks	*eofb = args;
>  	uint			lock_mode = 0;
> -	int			match;
>  	int			ret = 0;
>  
>  	if (!xfs_prep_free_cowblocks(ip))
>  		return 0;
>  
> -	if (eofb) {
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> -			match = xfs_inode_match_id_union(ip, eofb);
> -		else
> -			match = xfs_inode_match_id(ip, eofb);
> -		if (!match)
> -			return 0;
> -
> -		/* skip the inode if the file size is too small */
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> -		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> -			return 0;
> -	}
> +	if (!xfs_inode_matches_eofb(ip, eofb))
> +		return 0;
>  
>  	/*
>  	 * Free the CoW blocks.  We don't need to lock the inode if we're in
> 
> 
