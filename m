Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33344 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfDWR4b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 13:56:31 -0400
Subject: Re: [PATCH 08/10] libxfs: don't touch buffer log item pointer when
 flushing inode log item
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594794076.115924.11541140246431884889.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bcb9af40-88a6-3cf1-d629-65eaf407f851@sandeen.net>
Date: Tue, 23 Apr 2019 12:56:27 -0500
MIME-Version: 1.0
In-Reply-To: <155594794076.115924.11541140246431884889.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 4/22/19 10:45 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're flushing an inode log item, it is not necessary to mess with
> the inode cluster buffer's log item because the iflush code paths pass
> the inode log item directly.  The unconditional reset causes us to leak
> buffer log items.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

Weird, digging WAY back into history, I can't figure out why this was ever done.

Given that nothing ever retrieves b_log_item as an inode log item,
this seems clearly wrong, so, ok, sure!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
