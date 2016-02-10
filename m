Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B22837CA2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 05:31:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91F11304066
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:31:29 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nINsPc7cDzsqURRg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:31:27 -0800 (PST)
Date: Wed, 10 Feb 2016 03:31:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: Introduce writeback context for writepages
Message-ID: <20160210113126.GB15221@infradead.org>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455094043-9694-4-git-send-email-david@fromorbit.com>
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

> +	struct xfs_writepage_ctx wpc = {
> +		.io_type = XFS_IO_OVERWRITE,
> +	};
> +	int			ret;
> +
> +	ret = xfs_do_writepage(page, wbc, &wpc);
> +	return xfs_writepage_submit(&wpc, wbc, ret);
> +}
> +
> +STATIC int
>  xfs_vm_writepages(
>  	struct address_space	*mapping,
>  	struct writeback_control *wbc)
>  {
> +	struct xfs_writepage_ctx wpc = {
> +		.io_type = XFS_IO_OVERWRITE,
> +	};

Shouldn't we start out with an invalid (0) state, and just move
the actual states up to start from 1?

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
