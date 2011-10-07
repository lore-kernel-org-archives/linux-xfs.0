Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p972Bin6213380 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 21:11:44 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A94A14520A3
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 19:01:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2lIH0XNodt2CqPze for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 19:01:34 -0700 (PDT)
Date: Fri, 7 Oct 2011 12:54:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/9] xfs: clean up xfs_ioerror_alert
Message-ID: <20111007015441.GD3159@dastard>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210639.731475087@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111006210639.731475087@bombadil.infradead.org>
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

On Thu, Oct 06, 2011 at 05:06:14PM -0400, Christoph Hellwig wrote:
> Instead of passing the block number and mount structure explicitly
> get them off the bp and fix make the argument order more natural.
> 
> Also move it to xfs_buf.c and stop printing the device name given
> that we already get the fs name as part of xfs_alert, and we know
> what device is operates on because of the caller that gets printed.
> 

Only thing I'm wondering about is whether is should be renamed
xfs_buf_ioerror_alert(), now that it really is a xfs_buf specific
function?

Also, many of the callers could probably pass __func__ rather than a
manually set string...

Otherwise, another nice cleanup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
