Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13B237F72
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C456AC003
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:56:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fIAsr235xm3U2t2K for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:56:07 -0700 (PDT)
Date: Fri, 29 Aug 2014 10:55:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate
	functionality
Message-ID: <20140829005543.GZ20518@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-3-git-send-email-david@fromorbit.com>
	<20140829002209.GB17502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140829002209.GB17502@infradead.org>
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

On Thu, Aug 28, 2014 at 05:22:09PM -0700, Christoph Hellwig wrote:
> >  STATIC void
> 
> needs the static removed as pointed out by Brian.
> > -	bool			read = !!(bp->b_flags & XBF_READ);
> > +	bool		read = !!(bp->b_flags & XBF_READ);
> 
> We don't really need the double negation here.

Good point. I'll fix it.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
