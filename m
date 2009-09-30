Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8U0FWRb237711 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 19:15:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B0BFBA2567
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 17:16:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	5HblCmygYf9Ikqcw for <xfs@oss.sgi.com>;
	Tue, 29 Sep 2009 17:16:52 -0700 (PDT)
Date: Wed, 30 Sep 2009 10:16:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Possible small bug in xfsprogs-dev/db/metadump.c
Message-ID: <20090930001647.GI9464@discord.disaster>
References: <46b8a8850909271220w372d60c3s18a543ed00825082@mail.gmail.com>
	<20090928172137.GA21868@infradead.org>
	<46b8a8850909281036j1bdbf61h18b4134912735d92@mail.gmail.com>
	<20090929130022.GD11375@infradead.org>
	<46b8a8850909290845o22589155ud1ab403b761e734c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <46b8a8850909290845o22589155ud1ab403b761e734c@mail.gmail.com>
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
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 29, 2009 at 08:45:56AM -0700, Richard Sharpe wrote:
> However, now I understand what is going on.
> 
> Assume a free space tree with levels = 3 (from the AGF). However, not
> all leaf nodes will be at depth 3 in the tree, some will be at depth 2
> in the tree.

No, that is not possible. By definition, a consistent filesystem
image has all leaf nodes at level zero.

> However, in scanfunc_freesp we see:
> 
>         if (level == 0)
>                 return 1;
> 
>         numrecs = be16_to_cpu(block->bb_numrecs);
>         if (numrecs > mp->m_alloc_mxr[1]) {
>                 if (show_warnings)
>                         print_warning("invalid numrecs (%u) in %s block %u/%u",
>                                 numrecs, typtab[btype].name, agno, agbno);
>                 return 1;
>         }
> 
> If we hit level == 0 then we exit, however, for a leaf node that is at
> depth 2 (level 1, but bb_level == 0) we will see numrecs >
> mp->m_alloc_mxr[1] and will also skip such records (ie, will not
> recurse into them).

This sounds to me like the log has not been replayed on this
filesystem. AFAICT, when looking at a raw disk image of an XFS
filesystem, the only way to get leaf nodes at non-zero levels is to
have a dirty log. i.e. the log contains allocation/free transactions
that have resulted in a multi-level rebalance of the tree
that have not been replayed and written to disk and hence on-disk
image of the tree is unbalanced. When the log is replayed, the
on disk image will get updated and the tree will appear balanced
with all leaves at level 0.

> However, if the user does "metadump -w" they will see warnings that
> are bogus and suggests that the author was not really aware of the
> real structure of the tree.

I think he was aware of the structure. ;)

It seems to me that you are trying to use the wrong tool to walk
free space trees and interpret the number of extents.  xfs_metadump
is intended to capture the exact layout of the filesystem metadata
so that it can be reproduced exactly in a different environment. It
was not intended as a method of interpreting the potentially
inconsistent metadata that it records.

xfs_db does what you are trying to do. It already has commands that
walk the per AG free space trees and tells you the number of
extents, gives an extent size histogram, etc....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
