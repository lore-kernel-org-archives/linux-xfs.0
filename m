Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 748E27F7C
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 13:45:49 -0600 (CST)
Date: Mon, 9 Dec 2013 13:45:48 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/10] xfs: remove duplicate code in
	xlog_cil_insert_format_items
Message-ID: <20131209194548.GX1935@sgi.com>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084000.123386171@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084000.123386171@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph,

On Fri, Nov 29, 2013 at 12:39:20AM -0800, Christoph Hellwig wrote:
> Share code that was previously duplicated in two branches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_cil.c |   33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5eb51fc..0a7a8ce 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -254,29 +254,22 @@ xlog_cil_insert_format_items(
>  			 */
>  			*diff_iovecs -= lv->lv_niovecs;
>  			*diff_len -= lv->lv_buf_len;
> -
> -			/* Ensure the lv is set up according to ->iop_size */
> -			lv->lv_niovecs = niovecs;
> -			lv->lv_buf = (char *)lv + buf_size - nbytes;
> -
> -			lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
> -			goto insert;
> +		} else {
> +			/* allocate new data chunk */
> +			lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
> +			lv->lv_item = lip;
> +			lv->lv_size = buf_size;
> +			if (ordered) {
> +				/* track as an ordered logvec */
> +				ASSERT(lip->li_lv == NULL);
> +				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
> +				goto insert;

It looks like lv->lv_niovecs is no longer being set in this case.  Was that intentional?

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
