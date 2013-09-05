Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 419847F5F
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 22:25:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 198808F8039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 20:25:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sboc3tUIQaHTfsgA for
	<xfs@oss.sgi.com>; Wed, 04 Sep 2013 20:25:05 -0700 (PDT)
Date: Wed, 4 Sep 2013 23:24:54 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: potential argument order bug in
	fs/xfs/xfs_dir2_node.c:xfs_dir2_leafn_unbalance
Message-ID: <20130905032454.GA13451@redhat.com>
References: <20130905023818.GA10694@redhat.com>
	<20130905031128.GZ23571@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130905031128.GZ23571@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 01:11:28PM +1000, Dave Chinner wrote:
 > On Wed, Sep 04, 2013 at 10:38:18PM -0400, Dave Jones wrote:
 > > I'm picking through some of the bugs in coverity's database,
 > > and I came across this one, which I'm unsure of..
 > > 
 > > In xfs_dir2_leafn_unbalance we have this code..
 > > 
 > > 1583         if (xfs_dir2_leafn_order(save_blk->bp, drop_blk->bp))
 > > 1584                 xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
 > > 1585                                         save_blk->bp, &savehdr, sents, 0,
 > > 1586                                         drophdr.count);
 > > 1587         else
 > > 1588                 xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
 > > 1589                                         save_blk->bp, &savehdr, sents,
 > > 1590                                         savehdr.count, drophdr.count);
 > > 
 > > The issue that coverity picked up in both cases, is that 'sents' and 'dents' are in
 > > a different order to how the xfs_dir3_leafn_moveents function expects them.
 > 
 > What does "order" mean to coverity? Is it really complaining about
 > function parameters being ordered (src, dst) rather than (dst, src)?
 > Or is it detecting that we are passing parameters names (dxxx, sxxx)
 > into a function that declares those parameters (syyy, dyyy) and it
 > throws based on that?

Yeah, the latter. It's done it to quite a few parts of the kernel.
In most cases I've looked through so far, it's not a problem, but there have
been 1-2 real bugs.

 > In more detail, the function prototype is effectively
 > xfs_dir3_leafn_moveents(source, destination, count), and so in both
 > cases here objects are being moved from the block being dropped
 > (freed) to the block being saved (merged block).

Ok, thanks for looking it over anyway.
I've marked it as being intentional in their db, so it shouldn't show up in future.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
