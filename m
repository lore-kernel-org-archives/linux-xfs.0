Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B258C7F85
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 20:06:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4026EAC001
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 18:06:15 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sZa9qo7QLecd4Pce for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 18:06:13 -0700 (PDT)
Date: Fri, 29 Aug 2014 11:05:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: xfs_bioerror can die.
Message-ID: <20140829010554.GA20518@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-6-git-send-email-david@fromorbit.com>
	<20140829002825.GE17502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140829002825.GE17502@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 05:28:25PM -0700, Christoph Hellwig wrote:
> On Fri, Aug 15, 2014 at 04:39:03PM +1000, Dave Chinner wrote:
> > Internal buffer write error handling is a mess due to the unnatural
> > split between xfs_bioerror and xfs_bioerror_relse(). The buffer
> > reference counting is also wrong for the xfs_bioerror path for
> > xfs_bwrite - it uses sync IO and so xfs_buf_ioend will release a
> > hold count that was never taken.
> 
> Which seems to be cause by patch 1 in the series, and thus the
> additional hold for the error case should be introduced there.

will fix.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
