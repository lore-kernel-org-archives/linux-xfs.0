Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36359 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbeIRKvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 06:51:06 -0400
Date: Tue, 18 Sep 2018 15:20:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't treat unknown di_flags[2] as corruption in
 scrub
Message-ID: <20180918052009.GG16550@dastard>
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
>  {
>  	struct xfs_mount	*mp = sc->mp;
>  
> +	/* Unknown di_flags could simply be from newer kernel */
>  	if (flags & ~XFS_DIFLAG_ANY)
> -		goto bad;
> +		xchk_ino_set_warning(sc, ino);

There's only one flag in that set, right? And we only need that flag
for a future v2 inode features we add? i.e. any new feature will be
on a v3 inode format because the v2 format is the legacy inode
format and we're not developing new features for it.

[ There's also the minor issue that the remaining flag bit in
di_flags is reserved for the "more flags" flag bit so that we know
to grab flags from some other padding in the inode we redefined to
hold more flags in the v2 inode format. But that's irrelevant now
because it's a legacy format. ]

IOWs, I think the original code here is just fine because we're not
going to add new v2 format inode features in the future.

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

This bit it fine, though :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
