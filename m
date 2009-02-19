Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1JJODZP124536 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 13:24:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 171A3196AD4A
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 11:23:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZVHOMx0EyUyGHhLd for
	<xfs@oss.sgi.com>; Thu, 19 Feb 2009 11:23:40 -0800 (PST)
Date: Thu, 19 Feb 2009 14:23:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, needs a new owner] XFS multi-buftarg
Message-ID: <20090219192340.GA13964@infradead.org>
References: <4993A012.5060008@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4993A012.5060008@sgi.com>
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
To: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 12, 2009 at 03:05:38PM +1100, Mark Goodwin wrote:
>
> Series of 10 patches, originally by Dave Chinner. This series
> is unfinished, or needs forward porting to top-of-tree at the
> very least. The feature implements some allocator/layout optimizations
> by grouping AGs based on concat units, I think ;-)
>
> 02/10 xfs-factor-pag-freelist-check-2

This one is an independent cleanup.  It looks good to me and passes
XFSQA.  Dave, can you submit this one for 2.6.30?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
