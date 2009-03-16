Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAnomX085944 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:50:09 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A3C019C76F
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:49:07 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	v2MxxlNosPjFkbFQ for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 03:49:07 -0700 (PDT)
Date: Mon, 16 Mar 2009 21:49:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] [XFS] Validate log feature fields correctly
Message-ID: <20090316104904.GK26138@disturbed>
References: <1237116342-25701-1-git-send-email-david@fromorbit.com>
	<1237116342-25701-2-git-send-email-david@fromorbit.com>
	<20090315151546.GB7145@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090315151546.GB7145@infradead.org>
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

On Sun, Mar 15, 2009 at 11:15:51AM -0400, Christoph Hellwig wrote:
> On Sun, Mar 15, 2009 at 10:25:41PM +1100, Dave Chinner wrote:
> > If the large log sector size feature bit is set in the
> > superblock by accident (say disk corruption), the then
> > fields that are now considered valid are not checked on
> > production kernels. The checks are present as ASSERT
> > statements so cause a panic on a debug kernel.
> > 
> > Change this so that the fields are validity checked if
> > the feature bit is set and abort the log mount if the
> > fields do not contain valid values.
> > 
> > Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> Looks good to me, but wouldn't be easier to rad if the various sizes
> in the error messages were reported decimal instead of in hex?

I just find large numbers easier to parse in hex, especially as
we are expecting power-of-2 type numbers to come out of this.
I'll change it....

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> >  }	/* xlog_alloc_log */
> 
> any maybe remove this comment while you're at it?

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
