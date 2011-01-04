Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p040DFD9145891 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 18:13:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52A1B23064A
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 16:15:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	3rZIo0oVfOoO6ltC for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 16:15:20 -0800 (PST)
Date: Tue, 4 Jan 2011 11:15:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add FITRIM support
Message-ID: <20110104001518.GG15179@dastard>
References: <20110102072202.GA26488@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110102072202.GA26488@infradead.org>
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

On Sun, Jan 02, 2011 at 02:22:02AM -0500, Christoph Hellwig wrote:
> Allow manual discards from userspace using the FITRIM ioctl.  This is not
> intended to be run during normal workloads, as the freepsace btree walks
> can cause large performance degradation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
> 
> V1 -> V2
>  
>  - added __user annotations as noted by Alex
>  - removed non-blocking agf read as noted by Alex
>  - update range->len as noted by Alex
> 
> This does not implement the by-bno search or lock break suggestions from
> Dave.  Given that the 2.6.38 window is about to close those seem a bit
> risky to me.  I'll look into these later.

Ok, seemms like a good way to proceed.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
