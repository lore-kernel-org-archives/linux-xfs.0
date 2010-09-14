Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EEOHPR129871 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:24:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37225DCAE3F
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:36:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DBQaK6zrifanUCGm for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:36:50 -0700 (PDT)
Date: Tue, 14 Sep 2010 10:25:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/18] xfs: metadata and buffer cache scalability
	improvements
Message-ID: <20100914142503.GA3400@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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

> 	1. work out how to efficiently support block size smaller
> 	than page size. The current code works, but uses a page per
> 	sub-apge buffer.  A set of slab caches would be perfect for
> 	this use, but I'm not sure that we are allowed to use them
> 	for IO anymore. Christoph?

Using slab pages for I/O is fine again.  Back when we used them we
couldn't get agreement from driver authors that they need to support
them, but now that ext4 has started using them they are fine..

I'm not even sure we'll need separate slab caches, the normal kmalloc
caches probably are good enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
