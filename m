Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3RJfxMO228843 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 14:42:00 -0500
Date: Wed, 27 Apr 2011 15:45:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: reduce the number of pagb_lock roundtrips in
	xfs_alloc_clear_busy
Message-ID: <20110427194530.GA21479@infradead.org>
References: <20110424190613.404786382@bombadil.infradead.org>
	<20110424190657.249817918@bombadil.infradead.org>
	<1303923381.2056.58.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303923381.2056.58.camel@doink>
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

On Wed, Apr 27, 2011 at 11:56:21AM -0500, Alex Elder wrote:
> Perhaps you have other plans that make the model you
> have here more appropriate though.  Let me know
> if you intend to re-submit, otherwise I'll just take
> this version.

The discard support will call xfs_alloc_busy_clear twice for
each list, once to clear all items that don't need discarding,
and a second pass once we're done with the discards.  Keeping
the sorting separate just seems cleaner at that point.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
