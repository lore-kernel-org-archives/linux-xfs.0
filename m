Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9ehSq082213 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:41:03 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9532319BDCA
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:40:21 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	IL8m4gSCV3I3HwhF for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 02:40:21 -0700 (PDT)
Date: Mon, 16 Mar 2009 20:40:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] [XFS] introduce a AG inode tree walker
Message-ID: <20090316094019.GD26138@disturbed>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
	<20090316075338.GA19858@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316075338.GA19858@infradead.org>
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

On Mon, Mar 16, 2009 at 03:53:38AM -0400, Christoph Hellwig wrote:
> On Sun, Mar 15, 2009 at 10:46:37PM +1100, Dave Chinner wrote:
> > This series splits up the sync and reclaim code into three
> > separate actions. The first is the tree walker, the second is
> > the inode validation and the third is the operation to execute
> > on the inode.
> > 
> > This allows us to somewhat abstract the radix tree away from the
> > act of walking the cached inodes and puts in place mechanisms that
> > can be extended for bulk inode cache lookups.
> > 
> > This also splits the inode writeback into separate data and metadata
> > sync operations and optimises them a little......
> 
> Just did a quick XFSQA run with your whole patch series applied and
> I get this oops in 001:

I haven't seen that - it runs through a UML test run just fine.
I'll see if I can reproduce it...

If you drop the last patch (the iterator patch) does it work
ok?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
