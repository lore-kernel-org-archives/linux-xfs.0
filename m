Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DE897CA2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 05:28:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C1FB8F8049
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:28:03 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id i86t3xMIdWZXz9eY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:28:01 -0800 (PST)
Date: Wed, 10 Feb 2016 03:28:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: remove xfs_cancel_ioend
Message-ID: <20160210112800.GA15221@infradead.org>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455094043-9694-3-git-send-email-david@fromorbit.com>
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

> +static int
> +xfs_writepage_submit(
> +	struct xfs_ioend	*ioend,
> +	struct xfs_ioend	*iohead,
> +	struct writeback_control *wbc,
> +	int			status)
> +{
> +	struct blk_plug		plug;
> +
> +	/* Reserve log space if we might write beyond the on-disk inode size. */
> +	if (!status && ioend && ioend->io_type != XFS_IO_UNWRITTEN &&
> +	    xfs_ioend_is_append(ioend))
> +		status = xfs_setfilesize_trans_alloc(ioend);
> +
> +	if (iohead) {
> +		blk_start_plug(&plug);
> +		xfs_submit_ioend(wbc, iohead, status);
> +		blk_finish_plug(&plug);
> +	}
> +	return status;
> +}

We return the xfs_setfilesize_trans_alloc failure status here,
but none of the callers pick it up.  The way this is handled later
changes a bit, but even at the end of the series only 1 of the
three callers handles the error.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
