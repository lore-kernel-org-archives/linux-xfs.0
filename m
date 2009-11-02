Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2NL07Z102378 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 17:21:00 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: use WRITE_SYNC_PLUG for synchronous writeout
Date: Mon, 2 Nov 2009 17:20:44 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE5E@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091030090915.GA23188@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> The VM and I/O schedulers now expect us to use WRITE_SYNC_PLUG for synchronous
> writeout. Right now I can't see any changes in performance numbers with this,
> but we're getting some beating for not using it, and the knowledge defintively
> could help the block code to make better decisions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-10-24 10:08:36.622254197 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-10-24 10:18:27.803006347 +0200
> @@ -412,8 +412,9 @@ xfs_end_bio(
> 
>  STATIC void
>  xfs_submit_ioend_bio(
> -	xfs_ioend_t	*ioend,
> -	struct bio	*bio)
> +	struct writeback_control *wbc,
> +	xfs_ioend_t		*ioend,
> +	struct bio		*bio)
>  {
>  	atomic_inc(&ioend->io_remaining);
>  	bio->bi_private = ioend;
> @@ -426,7 +427,8 @@ xfs_submit_ioend_bio(
>  	if (xfs_ioend_new_eof(ioend))
>  		xfs_mark_inode_dirty_sync(XFS_I(ioend->io_inode));
> 
> -	submit_bio(WRITE, bio);
> +	submit_bio(wbc->sync_mode == WB_SYNC_ALL ?
> +		   WRITE_SYNC_PLUG : WRITE, bio);
>  	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
>  	bio_put(bio);
>  }
> @@ -505,6 +507,7 @@ static inline int bio_add_buffer(struct
>   */
>  STATIC void
>  xfs_submit_ioend(
> +	struct writeback_control *wbc,
>  	xfs_ioend_t		*ioend)
>  {
>  	xfs_ioend_t		*head = ioend;
> @@ -533,19 +536,19 @@ xfs_submit_ioend(
>   retry:
>  				bio = xfs_alloc_ioend_bio(bh);
>  			} else if (bh->b_blocknr != lastblock + 1) {
> -				xfs_submit_ioend_bio(ioend, bio);
> +				xfs_submit_ioend_bio(wbc, ioend, bio);
>  				goto retry;
>  			}
> 
>  			if (bio_add_buffer(bio, bh) != bh->b_size) {
> -				xfs_submit_ioend_bio(ioend, bio);
> +				xfs_submit_ioend_bio(wbc, ioend, bio);
>  				goto retry;
>  			}
> 
>  			lastblock = bh->b_blocknr;
>  		}
>  		if (bio)
> -			xfs_submit_ioend_bio(ioend, bio);
> +			xfs_submit_ioend_bio(wbc, ioend, bio);
>  		xfs_finish_ioend(ioend, 0);
>  	} while ((ioend = next) != NULL);
>  }
> @@ -1198,7 +1201,7 @@ xfs_page_state_convert(
>  	}
> 
>  	if (iohead)
> -		xfs_submit_ioend(iohead);
> +		xfs_submit_ioend(wbc, iohead);
> 
>  	return page_dirty;
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
