Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbeIRItW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 04:49:22 -0400
Date: Mon, 17 Sep 2018 20:18:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't treat unknown di_flags[2] as corruption in
 scrub
Message-ID: <20180918031840.GC20086@magnolia>
References: <be811b64-5630-e9eb-313f-3aa1f809ba79@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be811b64-5630-e9eb-313f-3aa1f809ba79@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Sep 17, 2018 at 09:41:35PM -0500, Eric Sandeen wrote:
> xchk_inode_flags[2]() currently treats any di_flags[2] values that the
> running kernel doesn't recognize as corruption, and calls
> xchk_ino_set_corrupt() if they are set.  However, it's entirely possible
> that these flags were set in some newer kernel and are quite valid,
> but ignored in this kernel.
> 
> (Validators don't care one bit about unknown di_flags[2].)
> 
> Call xchk_ino_set_warning instead, because this may or may not actually
> indicate a problem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 5b3b177..e53ed83 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -126,8 +126,9 @@

Would be nice to know which function this is, but it otherwise seems
fine to me:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  {
>  	struct xfs_mount	*mp = sc->mp;
>  
> +	/* Unknown di_flags could simply be from newer kernel */
>  	if (flags & ~XFS_DIFLAG_ANY)
> -		goto bad;
> +		xchk_ino_set_warning(sc, ino);
>  
>  	/* rt flags require rt device */
>  	if ((flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) &&
> @@ -172,8 +173,9 @@
>  {
>  	struct xfs_mount	*mp = sc->mp;
>  
> +	/* Unknown di_flags2 could simply be from newer kernel */
>  	if (flags2 & ~XFS_DIFLAG2_ANY)
> -		goto bad;
> +		xchk_ino_set_warning(sc, ino);
>  
>  	/* reflink flag requires reflink feature */
>  	if ((flags2 & XFS_DIFLAG2_REFLINK) &&
> 
