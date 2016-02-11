Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69C827CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 14:14:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BC1F30405F
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 12:14:58 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6sxEjHNgvnIhZjiB for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 12:14:55 -0800 (PST)
Date: Fri, 12 Feb 2016 07:12:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/8 v4] xfs: get rid of xfs_cluster_write
Message-ID: <20160211201238.GG19486@dastard>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<20160210182538.GA7481@infradead.org>
	<20160210212550.GM14668@dastard>
	<20160211151301.GA13515@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211151301.GA13515@infradead.org>
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

On Thu, Feb 11, 2016 at 07:13:01AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 11, 2016 at 08:25:51AM +1100, Dave Chinner wrote:
> > I really like the idea, especially how using a bioset encapsulates
> > the ioend and binds the life cycle to the bio. It also removes a
> > heap of code, too.
> > 
> > We really do need some form of chaining here, though. If we don't,
> > then we'll be doing unwritten extent of set file size transactions
> > for ever 1MB bio completion instead of once for however large
> > writepages can build an ioend.
> > 
> > I think this is definitely worth pursuing - are you going to get any
> > time to work on this in the next couple of months, Christoph (i.e.
> > to target the 4.7 merge window)?
> 
> Yes, I've just started working on this and would love to get it off
> my table ASAP.  I was doing this ontop of your initial writeback
> changes, so let me know if I should go back to that version, or
> you think the last two patches will be ready in time as well?

Keep my extra two patches in your series. I'm going to try to spend
the rest of this cycle (for the 4.6 merge window) on Darrick's
reflink patchset, but I can carry whatever patches you finish off
until the appropriate time to merge them is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
