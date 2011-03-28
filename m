Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SC4EYe165388 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 07:04:16 -0500
Date: Mon, 28 Mar 2011 08:07:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: optimize AGFL refills
Message-ID: <20110328120722.GA18346@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.280301318@bombadil.infradead.org>
	<1300833051.2875.275.camel@doink>
	<20110323121613.GA468@infradead.org>
	<1301086981.2537.687.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301086981.2537.687.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> The reason it was not obvious is because the case you're
> treating is specifically when moving extents (blocks,
> really) between the free list and the free btrees, in
> xfs_alloc_fix_freelist().  You still need to force it
> out when allocating and freeing "actually used" blocks,
> which could also be considered "moving blocks from/to
> the AGFL."

I've updated the comment to make that more clear.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
