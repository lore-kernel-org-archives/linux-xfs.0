Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TLHj9c184114 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 16:17:45 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ir8dGkUCf9JEVLjd for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 14:17:44 -0700 (PDT)
Date: Fri, 30 Mar 2012 08:17:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: check for buffer errors before waiting
Message-ID: <20120329211741.GE692@dastard>
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-2-git-send-email-david@fromorbit.com>
	<20120329191203.GB8622@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120329191203.GB8622@infradead.org>
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

On Thu, Mar 29, 2012 at 03:12:03PM -0400, Christoph Hellwig wrote:
> The actual fix looks good:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But shou;dn't we move the setting of b_error to zero into common buffer
> code instead of adding it to the callers?

We generally do - in xfs_buf_iodone_callbacks() - which covers
pretty much all cached buffer IO.

However, for uncached buffers, it is only zeroed in xfs_buf_alloc().
For single use buffers, this is fine, but for multiple use buffers
like the log uses during recovery for log IO, it doesn't get reset
anywhere because the buffer doesn't go anywhere near common buffer
code between IOs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
