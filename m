Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbeEGWaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 18:30:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w47MM0tM131387
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:30:09 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hs4k264u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 22:30:09 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w47MU7Pl015901
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:30:07 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w47MU72w011572
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:30:07 GMT
Date: Mon, 7 May 2018 15:30:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/21] Add lock_flags to xfs_ialloc and xfs_dir_ialloc
Message-ID: <20180507223006.GH11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-15-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525627494-12873-15-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 06, 2018 at 10:24:47AM -0700, Allison Henderson wrote:
> Add lock_flags to  xfs_ialloc and xfs_dir_ialloc to control
> whick locks are released by xfs_trans_ijoin.  We will need this
> later in defered parent pointers
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c   | 17 +++++++++--------
>  fs/xfs/xfs_inode.h   |  2 +-
>  fs/xfs/xfs_qm.c      |  2 +-
>  fs/xfs/xfs_symlink.c |  2 +-
>  4 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5c291d2..2859a697 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -766,7 +766,8 @@ xfs_ialloc(
>  	dev_t		rdev,
>  	prid_t		prid,
>  	xfs_buf_t	**ialloc_context,
> -	xfs_inode_t	**ipp)
> +	xfs_inode_t	**ipp,
> +	int		lock_flags)

Wait, what?

Oh, these are the locks we want *dropped* at the first _trans_commit
after this call returns, and for xfs_create we need to retain the ilock
while we roll the transaction(s) during _defer_finish; and for
everything else (create temp file, create quota inode, and symlink??) we
want the ilock dropped as soon as the transaction commits.

I dislike having this oddly named parameter, can we amend the comment to
say that the caller is responsible for unlocking the inode manually
(i.e. we're going to xfs_trans_ijoin(tp, ip, 0)) , and then change all
the callers to do the iunlock explicitly if they need to?

--D

>  {
>  	struct xfs_mount *mp = tp->t_mountp;
>  	xfs_ino_t	ino;
> @@ -942,7 +943,7 @@ xfs_ialloc(
>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, lock_flags);
>  	xfs_trans_log_inode(tp, ip, flags);
>  
>  	/* now that we have an i_mode we can setup the inode structure */
> @@ -972,8 +973,8 @@ xfs_dir_ialloc(
>  	xfs_nlink_t	nlink,
>  	dev_t		rdev,
>  	prid_t		prid,		/* project id */
> -	xfs_inode_t	**ipp)		/* pointer to inode; it will be
> -					   locked. */
> +	xfs_inode_t	**ipp,		/* pointer to inode; it will be locked. */
> +	int		lock_flags)
>  {
>  	xfs_trans_t	*tp;
>  	xfs_inode_t	*ip;
> @@ -1001,7 +1002,7 @@ xfs_dir_ialloc(
>  	 * the inode(s) that we've just allocated.
>  	 */
>  	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
> -			&ip);
> +			&ip, lock_flags);
>  
>  	/*
>  	 * Return an error if we were unable to allocate a new inode.
> @@ -1071,7 +1072,7 @@ xfs_dir_ialloc(
>  		 * this call should always succeed.
>  		 */
>  		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
> -				  &ialloc_context, &ip);
> +				  &ialloc_context, &ip, lock_flags);
>  
>  		/*
>  		 * If we get an error at this point, return to the caller
> @@ -1210,7 +1211,7 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> -	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip, XFS_ILOCK_EXCL);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1343,7 +1344,7 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip);
> +	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip, XFS_ILOCK_EXCL);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 1eebc53..466f252 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -431,7 +431,7 @@ xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
>  
>  int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
>  			       xfs_nlink_t, dev_t, prid_t,
> -			       struct xfs_inode **);
> +			       struct xfs_inode **, int lock_flags);
>  
>  /* from xfs_file.c */
>  enum xfs_prealloc_flags {
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ec39ae2..3e68a52 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -787,7 +787,7 @@ xfs_qm_qino_alloc(
>  		return error;
>  
>  	if (need_alloc) {
> -		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip);
> +		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip, XFS_ILOCK_EXCL);
>  		if (error) {
>  			xfs_trans_cancel(tp);
>  			return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index b1d3301..ce8dbea 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -264,7 +264,7 @@ xfs_symlink(
>  	 * Allocate an inode for the symlink.
>  	 */
>  	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
> -			       prid, &ip);
> +			       prid, &ip, XFS_ILOCK_EXCL);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
