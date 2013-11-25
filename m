Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A8867F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 02:54:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 072B5AC025
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 00:54:19 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	N2OvaV6KD5wfhJVJ for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 00:54:18 -0800 (PST)
Date: Mon, 25 Nov 2013 19:54:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7] decouple the in-memory from the on-disk log format
Message-ID: <20131125085415.GC8803@dastard>
References: <20131123151151.716201348@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131123151151.716201348@bombadil.infradead.org>
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

On Sat, Nov 23, 2013 at 07:11:51AM -0800, Christoph Hellwig wrote:
> Since the introduction of the CIL we already have a layer of indirection
> between the physical log format and the data structure tracking the
> changes in memory.  But due to the way iop_format works we are still
> forced to keep a copy of everything that goes out to the log in memory
> even before copying it into the CIL.
> 
> The first patch in this series changes iop_format so that the log items
> are free to store their in-memory data however they want before formatting
> them into the CIL, and the other patches take advantage of that by not
> keeping most log formats in memory all the time.  Especially the EFI and
> EFD related ones at the end start to show the benefit.

OK, it makes sense from that perspective - it should reduce the
memory footprint and simplify the code, if nothing else...

> What's missing from this series are larger changes to the in-core inode
> layout.  No needing the full struct icdinode at all times will be the
> biggest benefit of this change, but it will be large enough series of it's
> own.

Can you give us an outline of where you are taking this code and
what problems you are trying to solve? I'm missing the big picture
view that is driving this work - I think I know where you are going
to take it (i.e. closer integration with the vfs struct inode to
remove a bunch of duplicate information), but I'd like to know for
sure where this is going before looking at the code in real depth...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
