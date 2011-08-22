Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6m13m036655 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:48:01 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD676138883B
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:50:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9DZWtFJTlgAmmP7o for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:50:34 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:47:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix tracing builds inside the source tree
Message-ID: <20110822064758.GQ3162@dastard>
References: <20110814171300.GA25923@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814171300.GA25923@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Aug 14, 2011 at 01:13:00PM -0400, Christoph Hellwig wrote:
> The code really requires the current source directory to be in the
> header search path.  We already do this if building with an object
> tree separate from the source, but it needs to be added manually
> if building inside the source.  The cflags addition for it accidentally
> got removed when collapsing the xfs directory structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Not really necessary, but:

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
