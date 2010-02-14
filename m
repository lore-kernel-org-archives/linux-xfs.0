Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1EMFn52001337 for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 16:15:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87E581CF513
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 14:17:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	miLHqAE49NexPITS for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2010 14:17:05 -0800 (PST)
Date: Mon, 15 Feb 2010 09:17:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix dquota trace format
Message-ID: <20100214221702.GC28392@discord.disaster>
References: <20100214220144.GA10548@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100214220144.GA10548@infradead.org>
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

On Sun, Feb 14, 2010 at 05:01:45PM -0500, Christoph Hellwig wrote:
> 
> The be32_to_cpu in the TP_printk output breaks automatic parsing of
> the trace format by the trace-cmd tools, so we have to move it into
> the TP_assign block.  While we're at it also fix the format for the
> quota limits to more regular and easier parseable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
