Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GH4SMF261748 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 12:04:28 -0500
Date: Fri, 16 Apr 2010 13:06:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: avoid repeated pointer dereferences
Message-ID: <20100416170624.GB2729@infradead.org>
References: <1271355450.2680.91.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271355450.2680.91.camel@doink>
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
Cc: xfs@oss.sgi.com

On Thu, Apr 15, 2010 at 01:17:30PM -0500, Alex Elder wrote:
> In xlog_find_cycle_start() use a local variable for some repeated
> operations rather than constantly accessing the memory location
> whose address is passed in.
> 
> (This version drops an assertion that a pointer is non-null.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

I'm not entirely convinced about the need for this, but it at least
looks correct, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
