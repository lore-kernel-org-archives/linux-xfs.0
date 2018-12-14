Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbeLNQIX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 11:08:23 -0500
Date: Fri, 14 Dec 2018 10:08:16 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: require both realtime inodes to mount
Message-ID: <20181214160816.GA31145@redhat.com>
References: <20181214042932.GF24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214042932.GF24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Thu, Dec 13, 2018 at 08:29:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since mkfs always formats the filesystem with the realtime bitmap and
> summary inodes immediately after the root directory, we should expect
> that both of them are present and loadable, even if there isn't a
> realtime volume attached.  There's no reason to skip this if rbmino ==
> NULLFSINO; in fact, this causes an immediate crash if the there /is/ a
> realtime volume and someone writes to it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

>  fs/xfs/xfs_rtalloc.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index aefd63d46397..afe4d29f7ab4 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1206,13 +1206,11 @@ xfs_rtmount_inodes(
>  	xfs_sb_t	*sbp;
>  
>  	sbp = &mp->m_sb;
> -	if (sbp->sb_rbmino == NULLFSINO)
> -		return 0;
>  	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
>  	if (error)
>  		return error;
>  	ASSERT(mp->m_rbmip != NULL);
> -	ASSERT(sbp->sb_rsumino != NULLFSINO);
> +
>  	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
>  	if (error) {
>  		xfs_irele(mp->m_rbmip);
