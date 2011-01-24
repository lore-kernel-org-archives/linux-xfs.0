Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ONZEn5136993 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 17:35:14 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DADA1053904
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 15:37:36 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ysYPwBEMJcwj4pzD for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 15:37:36 -0800 (PST)
Date: Tue, 25 Jan 2011 10:37:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: limit extsize to size of AGs and/or MAXEXTLEN
Message-ID: <20110124233735.GD11040@dastard>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
	<1295411400-15614-5-git-send-email-david@fromorbit.com>
	<20110124090656.GE26744@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110124090656.GE26744@infradead.org>
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

On Mon, Jan 24, 2011 at 04:06:56AM -0500, Christoph Hellwig wrote:
> On Wed, Jan 19, 2011 at 03:29:59PM +1100, Dave Chinner wrote:
> > +		 * Also, for non-realtime files, limit the extent size hint to
> > +		 * half the size of the AGs in the filesystem so alignment
> > +		 * doesn't result in extents larger than an AG.
> 
> What do we do about the last AG, which potentionally is smaller than the
> others?

Not sure - I didn't actually consider that case because I forgot
about it.

At first glance it doesn't matter because it won't get
selected because the length of the AG is less than the requested
size unless it is the best match. If it is the best match, we can't
do extsize alignment anyway, so it's the same case as any other
allocation without a freespace extent large enough for alignment.

I'll do a bit more analysis, but I think we're OK here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
