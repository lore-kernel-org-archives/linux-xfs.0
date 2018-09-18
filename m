Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbeIRTs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 15:48:29 -0400
Date: Tue, 18 Sep 2018 07:15:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs: don't treat unknown di_flags2 as corruption in
 scrub
Message-ID: <20180918141535.GD20086@magnolia>
References: <be811b64-5630-e9eb-313f-3aa1f809ba79@redhat.com>
 <dc7b97b4-c238-5bd5-77ce-8283f22cde98@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc7b97b4-c238-5bd5-77ce-8283f22cde98@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 18, 2018 at 08:50:14AM -0500, Eric Sandeen wrote:
> xchk_inode_flags2() currently treats any di_flags2 values that the
> running kernel doesn't recognize as corruption, and calls
> xchk_ino_set_corrupt() if they are set.  However, it's entirely possible
> that these flags were set in some newer kernel and are quite valid,
> but ignored in this kernel.
> 
> (Validators don't care one bit about unknown di_flags2.)
> 
> Call xchk_ino_set_warning instead, because this may or may not actually
> indicate a problem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: continue to treat unknown di_flag value as corruption, and add
>     comments about how the last di_flag bit cannot be used.
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 059bc44c27e8..afbe336600e1 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1016,6 +1016,8 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG_EXTSZINHERIT_BIT 12	/* inherit inode extent size */
>  #define XFS_DIFLAG_NODEFRAG_BIT     13	/* do not reorganize/defragment */
>  #define XFS_DIFLAG_FILESTREAM_BIT   14  /* use filestream allocator */
> +/* Do not use bit 15, di_flags is legacy and unchanging now */
> +
>  #define XFS_DIFLAG_REALTIME      (1 << XFS_DIFLAG_REALTIME_BIT)
>  #define XFS_DIFLAG_PREALLOC      (1 << XFS_DIFLAG_PREALLOC_BIT)
>  #define XFS_DIFLAG_NEWRTBM       (1 << XFS_DIFLAG_NEWRTBM_BIT)
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 5b3b177c0fc9..8fb29540af45 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -126,6 +126,7 @@ xchk_inode_flags(
>  {
>  	struct xfs_mount	*mp = sc->mp;
>  
> +	/* di_flags are all taken, last bit cannot be used */
>  	if (flags & ~XFS_DIFLAG_ANY)
>  		goto bad;
>  
> @@ -172,8 +173,9 @@ xchk_inode_flags2(
>  {
>  	struct xfs_mount	*mp = sc->mp;
>  
> +	/* Unknown di_flags2 could be from a future kernel */
>  	if (flags2 & ~XFS_DIFLAG2_ANY)
> -		goto bad;
> +		xchk_ino_set_warning(sc, ino);
>  
>  	/* reflink flag requires reflink feature */
>  	if ((flags2 & XFS_DIFLAG2_REFLINK) &&
> 
