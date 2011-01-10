Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AJMWaY033531 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 13:22:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA7951D1F425
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:24:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id j0AdyGiJd59g7E5N for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:24:44 -0800 (PST)
Date: Mon, 10 Jan 2011 14:24:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20110110192444.GG25029@infradead.org>
References: <1294399825-1157-1-git-send-email-david@fromorbit.com>
	<1294399825-1157-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294399825-1157-6-git-send-email-david@fromorbit.com>
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

> +	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|*iolock);

care to use normal spaces before/after operators? (also in a few other
places)

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
