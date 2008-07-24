Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 00:05:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O74u0U018766
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:04:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C62AE91DD3
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:06:07 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id DKzixzD7XmRGm6Bt for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:06:07 -0700 (PDT)
Date: Thu, 24 Jul 2008 17:05:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] kill struct xfs_mount_args
Message-ID: <20080724070541.GT6761@disturbed>
References: <20080525190741.GB13372@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525190741.GB13372@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, May 25, 2008 at 09:07:41PM +0200, Christoph Hellwig wrote:
> No need to parse the mount option into a structure before applying it
> to struct xfs_mount.
> 
> The content of xfs_start_flags gets merged into xfs_parseargs.  Calls
> inbetween don't care and can use mount members instead of the args
> struct.
> 
> This patch uncovered that the mount option for shared filesystems wasn't
> ever exposed on Linux.  The code to handle it is #if 0'ed in this patch
> pending a decision on this feature.  I'll send a writeup about it to
> the list soon.

Overall is good - cleans up a lot of mess, but a couple of things
need fixing:

> @@ -228,7 +231,9 @@ xfs_parseargs(
>  					this_char);
>  				return EINVAL;
>  			}
> -			strncpy(args->mtpt, value, MAXNAMELEN);
> +			*mtpt = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
> +			if (!*mtpt)
> +				return ENOMEM;

It's a double ptr that dup'd the mtpt= value to successfully.
we check we have a string, but it still count be a null string.

> -	if ((args->flags & XFSMNT_DMAPI) && *args->mtpt == '\0') {
> +	if ((mp->m_flags & XFS_MOUNT_DMAPI) && !mtpt) {

Which means that check is not doing the same thing. Did you mean
to check it was not a null string like the original code
(i.e !**mtpt)?

Also, a comment needs to be made in the function header that mtpt
needs to be freed by the caller.

> @@ -131,9 +130,11 @@ static struct xfs_qmops xfs_qmcore_stub 
>  };
>  
>  int
> -xfs_qmops_get(struct xfs_mount *mp, struct xfs_mount_args *args)
> +xfs_qmops_get(struct xfs_mount *mp)
>  {
> -	if (args->flags & (XFSMNT_UQUOTA | XFSMNT_PQUOTA | XFSMNT_GQUOTA)) {
> +	if (mp->m_qflags & (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +			    XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> +			    XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) {
>  		struct xfs_qmops *ops;
>  
>  		ops = symbol_get(xfs_qmcore_xfs);

I think *QUOTA_ACTIVE implies *QUOTA_ACCT. i.e. the quota can't
be active if we are not accounting it. Hence I think this can
be simplified to :

	if (XFS_IS_QUOTA_RUNNING(mp)) {

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
