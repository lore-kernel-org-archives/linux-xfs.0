Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbeLMTGj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 14:06:39 -0500
Date: Thu, 13 Dec 2018 13:06:36 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: don't skip rtmount when there's a realtime device
Message-ID: <20181213190636.GA27992@redhat.com>
References: <20181213012436.GB24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213012436.GB24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 12, 2018 at 05:24:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't ever skip the realtime bitmap / summary inode initialization if
> there's a realtime device attached, because we'd rather fail the mount
> if iget declines to retrieve a NULL inode pointer.  Right now, if
> someone sets rbmino to NULLFSINO on a rt-capable filesystem, mounts it,
> and writes a file to the rt device, we'll blow up.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Makes sense.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

>  fs/xfs/xfs_rtalloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index aefd63d46397..18ad31ded0bf 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1206,7 +1206,8 @@ xfs_rtmount_inodes(
>  	xfs_sb_t	*sbp;
>  
>  	sbp = &mp->m_sb;
> -	if (sbp->sb_rbmino == NULLFSINO)
> +	if (!xfs_sb_version_hasrealtime(&mp->m_sb) &&
> +	    sbp->sb_rbmino == NULLFSINO)
>  		return 0;
>  	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
>  	if (error)
