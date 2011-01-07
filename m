Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p078uLTb018557 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 02:56:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 258631D15BA4
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 00:58:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NuivW3pPSKS8xMhG for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 00:58:31 -0800 (PST)
Date: Fri, 7 Jan 2011 03:58:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20110107085830.GC10829@infradead.org>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294116518-14908-6-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

> +This also clearly indicates that XFS
> + * does not fall back to buffered IO in the direct IO write path.

I don't think this comment belongs into the function header.  It's
already present in the right place anyway, so it can just be removed.

> +	xfs_buftarg_t		*target = XFS_IS_REALTIME_INODE(ip) ?
> +					mp->m_rtdev_targp : mp->m_ddev_targp;

struct xfs_buftarg, please.

> +	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
> +	ret = generic_file_direct_write(iocb, iovp,
> +			&nr_segs, pos, &iocb->ki_pos, count, ocount);
> +
> +	/* No fallback to buffered IO on errors for XFS. */
> +	return ret;

I'd add an

	ASSERT(ret < 0 || ret == count);

here to make sure we don't get problems due to changes in the core
direct I/O code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
