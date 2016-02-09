Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B9B829DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 07:49:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE007AC006
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 05:49:33 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JBJRXIH3VwaMDQKf (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 05:49:31 -0800 (PST)
Date: Tue, 9 Feb 2016 05:49:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: don't chain ioends during writepage submission
Message-ID: <20160209134930.GD13357@infradead.org>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454910258-7578-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> +STATIC struct xfs_ioend *
>  xfs_add_to_ioend(
>  	struct inode		*inode,
>  	struct buffer_head	*bh,
>  	xfs_off_t		offset,
>  	struct xfs_writepage_ctx *wpc)
>  {
> +	struct xfs_ioend	*ioend_to_submit = NULL;

Maybe just

	struct xfs_ioend	*prev = NULL;

to be a little less verbose?

> @@ -738,29 +726,22 @@ xfs_writepage_submit(
>  	struct writeback_control *wbc,
>  	int			status)
>  {
> -	struct blk_plug		plug;
> -
> -	/* Reserve log space if we might write beyond the on-disk inode size. */
> -	if (!status && wpc->ioend && wpc->ioend->io_type != XFS_IO_UNWRITTEN &&
> -	    xfs_ioend_is_append(wpc->ioend))
> -		status = xfs_setfilesize_trans_alloc(wpc->ioend);
> -
> -	if (wpc->iohead) {
> -		blk_start_plug(&plug);
> -		xfs_submit_ioend(wbc, wpc->iohead, status);
> -		blk_finish_plug(&plug);
> -	}
> +	if (wpc->ioend)
> +		xfs_submit_ioend(wbc, wpc->ioend, status);
>  	return status;
>  }

With this change xfs_writepage_submit is rather pointless, I'd
rather open code it in the callers.

> +			ioend = xfs_add_to_ioend(inode, bh, offset, wpc);
> +			if (ioend) {
> +				ioend->io_list = NULL;
> +				if (!ioend_to_submit)
> +					ioend_to_submit = ioend;
> +				else
> +					ioend_tail->io_list = ioend;
> +				ioend_tail = ioend;
> +			}

Just using a list_head for this is a lot easier to read and less
error prone at the cost of a single additional pointer in the ioend.

> +	while (ioend_to_submit) {
> +		struct xfs_ioend *next = ioend_to_submit->io_list;
> +
> +		ioend_to_submit->io_list = NULL;
> +		xfs_submit_ioend(wbc, ioend_to_submit, 0);
> +		ioend_to_submit = next;
> +	}
>  	return 0;
>  
>  out_error:
> @@ -853,9 +848,16 @@ out_error:
>  	 * ioend, then we can't touch it here and need to rely on IO submission
>  	 * to unlock it.
>  	 */
> -	if (count)
> +	if (count) {
>  		xfs_start_page_writeback(page, 0, count);
> -	else {
> +		while (ioend_to_submit) {
> +			struct xfs_ioend *next = ioend_to_submit->io_list;
> +
> +			ioend_to_submit->io_list = NULL;
> +			xfs_submit_ioend(wbc, ioend_to_submit, 0);
> +			ioend_to_submit = next;
> +		}

I think this code cold be consolidated:

	ASSERT(wpc->ioend || !count);
out:
	if (count) {
		xfs_start_page_writeback(page, !error, count);
		while (ioend_to_submit) {
			struct xfs_ioend *next = ioend_to_submit->io_list;

			ioend_to_submit->io_list = NULL;
			xfs_submit_ioend(wbc, ioend_to_submit, 0);
			ioend_to_submit = next;
		}
	} else {
  		xfs_aops_discard_page(page);
  		ClearPageUptodate(page);
  		unlock_page(page);
  	}

	return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
