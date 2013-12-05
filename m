Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B3087F6D
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 15:17:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 141AD30408E
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 13:17:43 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RBHCmnyHaCSHSeu7 for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 13:17:41 -0800 (PST)
Date: Fri, 6 Dec 2013 08:17:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: use xfs_ilock_map_shared in xfs_attr_get
Message-ID: <20131205211738.GH29897@dastard>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.679310054@bombadil.infradead.org>
	<20131205205910.GD29897@dastard>
	<20131205210159.GA30318@infradead.org>
	<20131205210557.GF29897@dastard>
	<20131205211055.GA3209@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205211055.GA3209@infradead.org>
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

On Thu, Dec 05, 2013 at 01:10:55PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2013 at 08:05:57AM +1100, Dave Chinner wrote:
> > > Haven't really done an in-depth audit, mostly just looking at
> > > where the asserts kick in..
> > 
> > Right - I just did a scan with cscope on the users of
> > XFS_ILOCK_SHARED, and those two were the only ones that stuck out
> > that weren't handled correctly....
> 
> With MAXPATHLEN at 1024 a symlink is at max 2 extents and thus never in
> btree format, so I don't think we'll need it in readlink.  The attr
> cases look real, though.

True, because the data fork will always have space for 3 extents
(#define MINDBTPTRS      3) and so it won't go out of line
regardless of the attribute fork.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
