Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8Bfwck096782 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 05:41:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EEC71C227F0
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 03:43:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3VN0b4xYF3y7ScIu for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 03:43:25 -0800 (PST)
Date: Mon, 8 Nov 2010 06:43:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/16] xfs: dynamic speculative EOF preallocation
Message-ID: <20101108114325.GA19289@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-5-git-send-email-david@fromorbit.com>
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

> For default settings, ???e size and the initial extents is determined

weird character.

> The allocsize mount option still controls the minimum preallocation size, so
> the smallest extent size can stil be bound in situations where this behaviour
> is not sufficient.

Do we also need a way to keep an upper boundary?  Think lots of slowly
growing log files on a filesystem not having tons of free space.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
