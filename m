Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9DRG1080605 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:13:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D69819C306
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:13:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id valv3AZ9SvpjwsDP for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:13:06 -0700 (PDT)
Date: Mon, 16 Mar 2009 05:12:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] [XFS] Make inode flush at ENOSPC synchronous
Message-ID: <20090316091235.GB2636@infradead.org>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237116707-25793-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: mpatocka@redhat.com, xfs@oss.sgi.com

On Sun, Mar 15, 2009 at 10:31:44PM +1100, Dave Chinner wrote:
>  	} else {
> +		int enospc = 0;
> +		ssize_t ret2 = 0;
> +
> +write_retry:
>  		xfs_rw_enter_trace(XFS_WRITE_ENTER, xip, (void *)iovp, segs,
>  				*offset, ioflags);
> -		ret = generic_file_buffered_write(iocb, iovp, segs,
> +		ret2 = generic_file_buffered_write(iocb, iovp, segs,
>  				pos, offset, count, ret);
> +		/*
> +		 * if we just got an ENOSPC, flush the inode now we
> +		 * aren't holding any page locks and retry *once*
> +		 */
> +		if (ret2 == -ENOSPC && !enospc) {
> +			error = xfs_flush_pages(xip, 0, -1, 0, FI_NONE);
> +			if (error)
> +				goto out_unlock_internal;
> +			enospc = 1;
> +			goto write_retry;
> +		}
> +		ret = ret2;

Just use filemap_fdatawrite here directly..


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
