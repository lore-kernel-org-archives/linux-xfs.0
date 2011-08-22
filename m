Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7MET4Vl071578 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 09:29:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87707FDD0A
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 07:29:03 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	K4IFkXjn19P0C34e for <xfs@oss.sgi.com>;
	Mon, 22 Aug 2011 07:29:03 -0700 (PDT)
Date: Mon, 22 Aug 2011 10:29:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: reduce ioend latency
Message-ID: <20110822142902.GC24433@infradead.org>
References: <20110814222412.359079843@bombadil.infradead.org>
	<20110814222518.001177781@bombadil.infradead.org>
	<20110822064345.GM3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110822064345.GM3162@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Aug 22, 2011 at 04:43:45PM +1000, Dave Chinner wrote:
> That's similar to a check I added in a previous patch series to
> avoid taking the ILOCK in IO completion if it wasn't necessary. THis
> just checks earlier to avoid the workqueue switch, so it definitely
> better than what I did.

Yes, that's where it came from.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
