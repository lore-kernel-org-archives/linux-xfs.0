Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B6297F5E
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 22:11:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B02F8F8040
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 20:11:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GQlPKBEDpq8aJD2n for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 20:11:36 -0700 (PDT)
Date: Thu, 5 Sep 2013 13:11:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: potential argument order bug in
	fs/xfs/xfs_dir2_node.c:xfs_dir2_leafn_unbalance
Message-ID: <20130905031128.GZ23571@dastard>
References: <20130905023818.GA10694@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130905023818.GA10694@redhat.com>
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
To: Dave Jones <davej@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 04, 2013 at 10:38:18PM -0400, Dave Jones wrote:
> I'm picking through some of the bugs in coverity's database,
> and I came across this one, which I'm unsure of..
> 
> In xfs_dir2_leafn_unbalance we have this code..
> 
> 1583         if (xfs_dir2_leafn_order(save_blk->bp, drop_blk->bp))
> 1584                 xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
> 1585                                         save_blk->bp, &savehdr, sents, 0,
> 1586                                         drophdr.count);
> 1587         else
> 1588                 xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
> 1589                                         save_blk->bp, &savehdr, sents,
> 1590                                         savehdr.count, drophdr.count);
> 
> The issue that coverity picked up in both cases, is that 'sents' and 'dents' are in
> a different order to how the xfs_dir3_leafn_moveents function expects them.

What does "order" mean to coverity? Is it really complaining about
function parameters being ordered (src, dst) rather than (dst, src)?
Or is it detecting that we are passing parameters names (dxxx, sxxx)
into a function that declares those parameters (syyy, dyyy) and it
throws based on that?

In more detail, the function prototype is effectively
xfs_dir3_leafn_moveents(source, destination, count), and so in both
cases here objects are being moved from the block being dropped
(freed) to the block being saved (merged block).

What the xfs_dir2_leafn_order() call tells us is whether the objects
in the drop block get inserted into the save block before or after
the objects in the save block. i.e. if we are merging from the left
or right sibling....

So I don't see that there's a problem here.

> Is this intentional ? If so I'll mark it as such in their db.

The code looks fine to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
