Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39678 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbeLMV34 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 16:29:56 -0500
Subject: Re: [PATCH] xfs: don't skip rtmount when there's a realtime device
References: <20181213012436.GB24487@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d33a0150-e412-5089-5c60-333b3d9ae9a1@sandeen.net>
Date: Thu, 13 Dec 2018 15:29:54 -0600
MIME-Version: 1.0
In-Reply-To: <20181213012436.GB24487@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>



On 12/12/18 7:24 PM, Darrick J. Wong wrote:
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
> 

Seems fine as far as it goes, but now we have this weird situation where for
a filesystem without the realtime feature, we'll just skip this part and
mount if sb_rbmino is NULL, but if sb_rsumino is NULL, we'll fail the iget
and fail the mount.

So while there's noting really wrong with the fix, it seems like it could all
be made a bit more consistent while you're here.  (classic move by me!) ;)

-Eric
