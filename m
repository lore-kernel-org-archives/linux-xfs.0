Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6FLjDHL221190 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 16:45:13 -0500
Subject: Re: [PATCH] xfsprogs: fix gcc 4.6 variable set but not used warnings
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110630202505.GA23276@infradead.org>
References: <20110630202505.GA23276@infradead.org>
Date: Fri, 15 Jul 2011 16:39:21 -0500
Message-ID: <1310765961.2921.98.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Thu, 2011-06-30 at 16:25 -0400, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This one looks good to me too.  As with the previous
one I tried it out on x86_64, i386, and ia64 to
get better coverage.  I found a few more of this
type of warning, which I'll send to you as another
patch to combine with this one.

Or, if you prefer you can take my Reviewed-by
on this and I'll do the other patch myself later.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
