Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1889C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F9720716
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:33:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M/WjMpdE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbgFWCdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:33:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731312AbgFWCdA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 22:33:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2WTTZ052107;
        Tue, 23 Jun 2020 02:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PKAY1AXl2TR78yR4tDUnxEIH9yqAC4+l1+xHa/dEMvc=;
 b=M/WjMpdE9+QueKR4Wp3oykv+xGWq7q03rhArpfF0V+3zxnGnAFAYppi/fpJjODU8tQPy
 UY3CtTBhkUzkJP1K/mXTOABIjZNFH8YPaDCE7aAYEhemAbGa4R+R5LE51r20EVeEEJW+
 aQnUMY/wNZAA4q/l/PG0sL6m2aXdwNYSygqZhcoRgaTZWZ04fRQj3Of0LD5p05nu6e1D
 J3hfAbaP3F71w4QGFf6jHkp+LcqMEDA3+z68POvxtOSTNfklegqwcB/YOEns8euXOVNJ
 13uHojhDwgmnFgkSIy6/eiRErfVsjZRfnkPw+x/e7NbYv0XyQ0RFW2yGggySVufpKRo7 Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31sebbjk5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 02:32:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2S7dI004109;
        Tue, 23 Jun 2020 02:32:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31sv7r1tw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 02:32:56 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05N2WtiB006164;
        Tue, 23 Jun 2020 02:32:55 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 02:32:55 +0000
Date:   Mon, 22 Jun 2020 19:32:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/30] xfs: mark inode buffers in cache
Message-ID: <20200623023254.GB7606@magnolia>
References: <20200622081605.1818434-1-david@fromorbit.com>
 <20200622081605.1818434-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622081605.1818434-5-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=1 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=1 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230017
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 06:15:39PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
> 
> While this is largely a refactor of existing functionality, we
> broaden the scope of the flag to beyond where inodes are explicitly
> attached because future changes need to know what type of log items
> are attached to the buffer. Adding this buffer flag may invoke the
> inode iodone callback in cases where it wouldn't have been
> previously, but this is not a functional change because the callback
> is identical to the normal buffer write iodone callback when inodes
> are not attached.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks like a pretty straightforward removal of indirect iodone calls,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c       | 21 ++++++++++++++++-----
>  fs/xfs/xfs_buf.h       | 38 +++++++++++++++++++++++++-------------
>  fs/xfs/xfs_buf_item.c  | 42 +++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_buf_item.h  |  1 +
>  fs/xfs/xfs_inode.c     |  2 +-
>  fs/xfs/xfs_trans_buf.c |  3 +++
>  6 files changed, 77 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 20b748f7e186..ae0c923574df 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,8 @@
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  
> @@ -1202,12 +1204,21 @@ xfs_buf_ioend(
>  		bp->b_flags |= XBF_DONE;
>  	}
>  
> -	if (bp->b_iodone)
> +	if (read)
> +		goto out_finish;
> +
> +	if (bp->b_flags & _XBF_INODES) {
> +		xfs_buf_inode_iodone(bp);
> +		return;
> +	}
> +
> +	if (bp->b_iodone) {
>  		(*(bp->b_iodone))(bp);
> -	else if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_relse(bp);
> -	else
> -		complete(&bp->b_iowait);
> +		return;
> +	}
> +
> +out_finish:
> +	xfs_buf_ioend_finish(bp);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 050c53b739e2..2400cb90a04c 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -30,15 +30,18 @@
>  #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
>  #define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
>  
> -/* flags used only as arguments to access routines */
> -#define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
> -#define XBF_UNMAPPED	 (1 << 17)/* do not map the buffer */
> +/* buffer type flags for write callbacks */
> +#define _XBF_INODES	 (1 << 16)/* inode buffer */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
>  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
>  
> +/* flags used only as arguments to access routines */
> +#define XBF_TRYLOCK	 (1 << 30)/* lock requested, but do not wait */
> +#define XBF_UNMAPPED	 (1 << 31)/* do not map the buffer */
> +
>  typedef unsigned int xfs_buf_flags_t;
>  
>  #define XFS_BUF_FLAGS \
> @@ -50,12 +53,13 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
> -	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
> -	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
> +	{ _XBF_INODES,		"INODES" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
> -	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
> -
> +	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> +	/* The following interface flags should never be set */ \
> +	{ XBF_TRYLOCK,		"TRYLOCK" }, \
> +	{ XBF_UNMAPPED,		"UNMAPPED" }
>  
>  /*
>   * Internal state flags.
> @@ -257,9 +261,23 @@ extern void xfs_buf_unlock(xfs_buf_t *);
>  #define xfs_buf_islocked(bp) \
>  	((bp)->b_sema.count <= 0)
>  
> +static inline void xfs_buf_relse(xfs_buf_t *bp)
> +{
> +	xfs_buf_unlock(bp);
> +	xfs_buf_rele(bp);
> +}
> +
>  /* Buffer Read and Write Routines */
>  extern int xfs_bwrite(struct xfs_buf *bp);
>  extern void xfs_buf_ioend(struct xfs_buf *bp);
> +static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
> +{
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_relse(bp);
> +	else
> +		complete(&bp->b_iowait);
> +}
> +
>  extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  		xfs_failaddr_t failaddr);
>  #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
> @@ -324,12 +342,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
>  	return atomic_read(&bp->b_pin_count);
>  }
>  
> -static inline void xfs_buf_relse(xfs_buf_t *bp)
> -{
> -	xfs_buf_unlock(bp);
> -	xfs_buf_rele(bp);
> -}
> -
>  static inline int
>  xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  {
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 9e75e8d6042e..8659cf4282a6 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1158,20 +1158,15 @@ xfs_buf_iodone_callback_error(
>  	return false;
>  }
>  
> -/*
> - * This is the iodone() function for buffers which have had callbacks attached
> - * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
> - * callback list, mark the buffer as having no more callbacks and then push the
> - * buffer through IO completion processing.
> - */
> -void
> -xfs_buf_iodone_callbacks(
> +static void
> +xfs_buf_run_callbacks(
>  	struct xfs_buf		*bp)
>  {
> +
>  	/*
> -	 * If there is an error, process it. Some errors require us
> -	 * to run callbacks after failure processing is done so we
> -	 * detect that and take appropriate action.
> +	 * If there is an error, process it. Some errors require us to run
> +	 * callbacks after failure processing is done so we detect that and take
> +	 * appropriate action.
>  	 */
>  	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
>  		return;
> @@ -1188,9 +1183,34 @@ xfs_buf_iodone_callbacks(
>  	bp->b_log_item = NULL;
>  	list_del_init(&bp->b_li_list);
>  	bp->b_iodone = NULL;
> +}
> +
> +/*
> + * This is the iodone() function for buffers which have had callbacks attached
> + * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
> + * callback list, mark the buffer as having no more callbacks and then push the
> + * buffer through IO completion processing.
> + */
> +void
> +xfs_buf_iodone_callbacks(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_run_callbacks(bp);
>  	xfs_buf_ioend(bp);
>  }
>  
> +/*
> + * Inode buffer iodone callback function.
> + */
> +void
> +xfs_buf_inode_iodone(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_run_callbacks(bp);
> +	xfs_buf_ioend_finish(bp);
> +}
> +
> +
>  /*
>   * This is the iodone() function for buffers which have been
>   * logged.  It is called when they are eventually flushed out.
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index c9c57e2da932..a342933ad9b8 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -59,6 +59,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      struct xfs_log_item *);
>  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
> +void	xfs_buf_inode_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
>  extern kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e2296f0b7f11..b0760a900e11 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3862,13 +3862,13 @@ xfs_iflush_int(
>  	 * completion on the buffer to remove the inode from the AIL and release
>  	 * the flush lock.
>  	 */
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
>  
>  	/* generate the checksum. */
>  	xfs_dinode_calc_crc(mp, dip);
>  
>  	ASSERT(!list_empty(&bp->b_li_list));
> -	ASSERT(bp->b_iodone != NULL);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 08174ffa2118..552d0869aa0f 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -626,6 +626,7 @@ xfs_trans_inode_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_INODE_BUF;
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> @@ -651,6 +652,7 @@ xfs_trans_stale_inode_buf(
>  
>  	bip->bli_flags |= XFS_BLI_STALE_INODE;
>  	bip->bli_item.li_cb = xfs_buf_iodone;
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> @@ -675,6 +677,7 @@ xfs_trans_inode_alloc_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 
