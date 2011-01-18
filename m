Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ICX26F127877 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 06:33:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 512D5271203
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 04:35:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3EsF0jBmTNE1XdRF for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 04:35:19 -0800 (PST)
Date: Tue, 18 Jan 2011 07:35:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: fix log ticket leak on forced shutdown.
Message-ID: <20110118123516.GA12516@infradead.org>
References: <1295010430-12495-1-git-send-email-david@fromorbit.com>
	<1295010430-12495-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295010430-12495-2-git-send-email-david@fromorbit.com>
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

> By inspection, the leak occurs when xlog_write() returns and error
> and we jump to the abort path without dropping the reference on the
> active ticket.

Indeed,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
