Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfDWVPx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 17:15:53 -0400
Date: Tue, 23 Apr 2019 16:15:45 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 09/10] libxfs: fix buffer log item lifetime weirdness
Message-ID: <20190423211545.GA19757@redhat.com>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594794719.115924.7816478131558954855.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155594794719.115924.7816478131558954855.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 08:45:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfsprogs, the lifetime of xfs_buf log items doesn't match the kernel
> because we keep them around after comitting or cancelling transactions.
> This is confusing, so change the lifetime to be consistent.  Worse yet,
> if an inode cluster buffer gets bjoined to a transaction (e.g. someone
> called xfs_trans_read_buf) we'll leak it when flushing an inode core
> back to that buffer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  libxfs/trans.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index d562cdc0..22926236 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -545,6 +545,7 @@ libxfs_trans_brelse(
>  	xfs_trans_del_item(&bip->bli_item);
>  	if (bip->bli_flags & XFS_BLI_HOLD)
>  		bip->bli_flags &= ~XFS_BLI_HOLD;
> +	xfs_buf_item_put(bip);
>  	bp->b_transp = NULL;
>  	libxfs_putbuf(bp);
>  }
> @@ -904,6 +905,7 @@ buf_item_unlock(
>  
>  	hold = bip->bli_flags & XFS_BLI_HOLD;
>  	bip->bli_flags &= ~XFS_BLI_HOLD;
> +	xfs_buf_item_put(bip);
>  	if (!hold)
>  		libxfs_putbuf(bp);
>  }
> 
