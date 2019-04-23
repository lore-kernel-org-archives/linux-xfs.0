Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfDWVWr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 17:22:47 -0400
Date: Tue, 23 Apr 2019 16:22:45 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 10/10] libxfs: shorten inode item lifetime
Message-ID: <20190423212245.GB19757@redhat.com>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594795339.115924.2841573798611518042.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155594795339.115924.2841573798611518042.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 08:45:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Shorten the inode item lifetime so that we only keep them around while
> the inode is joined with a transaction.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  libxfs/rdwr.c  |    4 +---
>  libxfs/trans.c |   19 ++++++++++++++++---
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index bc2ed38c..a5efc805 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1428,9 +1428,7 @@ void
>  libxfs_irele(
>  	struct xfs_inode	*ip)
>  {
> -	if (ip->i_itemp)
> -		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
> -	ip->i_itemp = NULL;
> +	ASSERT(ip->i_itemp == NULL);
>  	libxfs_idestroy(ip);
>  	kmem_zone_free(xfs_inode_zone, ip);
>  }
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 22926236..1dcdebf3 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -785,6 +785,16 @@ _("Transaction block reservation exceeded! %u > %u\n"),
>  	tp->t_flags |= (XFS_TRANS_SB_DIRTY | XFS_TRANS_DIRTY);
>  }
>  
> +static void
> +xfs_inode_item_put(
> +	struct xfs_inode_log_item	*iip)
> +{
> +	struct xfs_inode		*ip = iip->ili_inode;
> +
> +	ip->i_itemp = NULL;
> +	kmem_zone_free(xfs_ili_zone, iip);
> +}
> +
>  
>  /*
>   * Transaction commital code follows (i.e. write to disk in libxfs)
> @@ -809,7 +819,7 @@ inode_item_done(
>  	if (!(iip->ili_fields & XFS_ILOG_ALL)) {
>  		ip->i_transp = NULL;	/* disassociate from transaction */
>  		iip->ili_flags = 0;	/* reset all flags */
> -		return;
> +		goto free;
>  	}
>  
>  	/*
> @@ -819,7 +829,7 @@ inode_item_done(
>  	if (error) {
>  		fprintf(stderr, _("%s: warning - imap_to_bp failed (%d)\n"),
>  			progname, error);
> -		return;
> +		goto free;
>  	}
>  
>  	/*
> @@ -835,7 +845,7 @@ inode_item_done(
>  		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
>  			progname, error);
>  		libxfs_putbuf(bp);
> -		return;
> +		goto free;
>  	}
>  
>  	libxfs_writebuf(bp, 0);
> @@ -843,6 +853,8 @@ inode_item_done(
>  	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
>  			ip->i_ino, bp);
>  #endif
> +free:
> +	xfs_inode_item_put(iip);
>  }
>  
>  static void
> @@ -920,6 +932,7 @@ inode_item_unlock(
>  	ip->i_transp = NULL;
>  
>  	iip->ili_flags = 0;
> +	xfs_inode_item_put(iip);
>  }
>  
>  /* Detach and unlock all of the items in a transaction */
> 
