Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BBYVUb161426 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 05:34:31 -0600
Date: Wed, 11 Jan 2012 06:34:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] xfs: serialise unaligned direct IOs
Message-ID: <20120111113428.GA14423@infradead.org>
References: <1325845990-5664-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1325845990-5664-1-git-send-email-amit.sahrawat83@gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>, linux kernel <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

> +	/*
> +	 * In most cases the direct IO writes will be done with IOLOCK_SHARED
> +	 * allowing them to be done in parallel with reads and other direct IO
> +	 * writes. However,if the IO is not aligned to filesystem blocks, the
> +	 * direct IO layer needs to do sub-block zeroing and that requires
> +	 * serialisation against other direct IOs to the same block. In this
> +	 * case we need to serialise the submission of the unaligned IOs so
> +	 * that we don't get racing block zeroing in the dio layer.
> +	 * To avoid the problem with aio, we also need to wait for outstanding
> +	 * IOs to complete so that unwritten extent conversion is completed
> +	 * before we try to map the overlapping block. This is currently
> +	 * implemented by hitting it with a big hammer (i.e. xfs_ioend_wait()).
> +	 */
> +

This comment is lacking one level of indentation, that's because the old
kernel is missing the split of xfs_file_aio_write that reduces one level
of indentation.

Otherwise the backport looks fine, please send it to
stable@vger.kernel.org, with a [PATCH 0/0] coverletter stating it's for
2.6.35-stable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
