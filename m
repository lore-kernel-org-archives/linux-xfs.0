Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfDWUwL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 16:52:11 -0400
Date: Tue, 23 Apr 2019 15:52:09 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 08/10] libxfs: don't touch buffer log item pointer when
 flushing inode log item
Message-ID: <20190423205209.GA19086@redhat.com>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594794076.115924.11541140246431884889.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155594794076.115924.11541140246431884889.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 08:45:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're flushing an inode log item, it is not necessary to mess with
> the inode cluster buffer's log item because the iflush code paths pass
> the inode log item directly.  The unconditional reset causes us to leak
> buffer log items.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  libxfs/trans.c |    2 --
>  libxfs/util.c  |    1 -
>  2 files changed, 3 deletions(-)
> 
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 629501f8..d562cdc0 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -826,10 +826,8 @@ inode_item_done(
>  	 * of whether the flush succeed or not. If we fail the flush, make sure
>  	 * we still release the buffer reference we currently hold.
>  	 */
> -	bp->b_log_item = iip;
>  	error = libxfs_iflush_int(ip, bp);
>  	ip->i_transp = NULL;	/* disassociate from transaction */
> -	bp->b_log_item = NULL;	/* remove log item */
>  	bp->b_transp = NULL;	/* remove xact ptr */
>  
>  	if (error) {
> diff --git a/libxfs/util.c b/libxfs/util.c
> index ea75fa20..9fe9a367 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -394,7 +394,6 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
>  	xfs_dinode_t		*dip;
>  	xfs_mount_t		*mp;
>  
> -	ASSERT(bp-b_log_item != NULL);
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  		ip->i_d.di_nextents > ip->i_df.if_ext_max);
>  	ASSERT(ip->i_d.di_version > 1);
> 
