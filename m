Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35252 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbeFELMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 07:12:53 -0400
Received: by mail-wr0-f195.google.com with SMTP id l10-v6so1972426wrn.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jun 2018 04:12:52 -0700 (PDT)
Date: Tue, 5 Jun 2018 13:12:49 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 6/6] xfs: push corruption -> ESTALE conversion to
 xfs_nfs_get_inode()
Message-ID: <20180605111249.rkz35is3hdspu3mw@odin.usersys.redhat.com>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605062423.4877-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 04:24:23PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In xfs_imap_to_bp(), we convert a -EFSCORRUPTED error to -EINVAL if
> we are doing an untrusted lookup. This is done because we need
> failed filehandle lookups to report -ESTALE to the caller, and it
> does this by converting -EINVAL and -ENOENT errors to -ESTALE.
> 
> The squashing of EFSCORRUPTED in imap_to_bp makes it impossible for
> for xfs_iget(UNTRUSTED) callers to determine the difference between
> "inode does not exist" and "corruption detected during lookup". We
> realy need that distinction in places calling xfS_iget(UNTRUSTED),
> so move the filehandle error case handling all the way out to
> xfs_nfs_get_inode() where it is needed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  fs/xfs/libxfs/xfs_inode_buf.c |  5 -----
>  fs/xfs/xfs_export.c           | 15 ++++++++++++---
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index ea64be7cbd98..0a22c39325cd 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -189,11 +189,6 @@ xfs_imap_to_bp(
>  			ASSERT(buf_flags & XBF_TRYLOCK);
>  			return error;
>  		}
> -
> -		if (error == -EFSCORRUPTED &&
> -		    (iget_flags & XFS_IGET_UNTRUSTED))
> -			return -EINVAL;
> -
>  		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
>  			__func__, error);
>  		return error;
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 7af7d6faa709..3cf4682e2510 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -128,15 +128,24 @@ xfs_nfs_get_inode(
>  	 */
>  	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
>  	if (error) {
> +
>  		/*
>  		 * EINVAL means the inode cluster doesn't exist anymore.
> -		 * This implies the filehandle is stale, so we should
> -		 * translate it here.
> +		 * EFSCORRUPTED means the metadata pointing to the inode cluster
> +		 * or the inode cluster itself is corrupt.  This implies the
> +		 * filehandle is stale, so we should translate it here.
>  		 * We don't use ESTALE directly down the chain to not
>  		 * confuse applications using bulkstat that expect EINVAL.
>  		 */
> -		if (error == -EINVAL || error == -ENOENT)
> +		switch (error) {
> +		case -EINVAL:
> +		case -ENOENT:
> +		case -EFSCORRUPTED:
>  			error = -ESTALE;
> +			break;
> +		default:
> +			break;
> +		}
>  		return ERR_PTR(error);
>  	}
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
