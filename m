Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF6XjkZ177419
	for <linux-xfs@oss.sgi.com>; Wed, 15 Dec 2010 00:33:45 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38A411CC890C
	for <linux-xfs@oss.sgi.com>; Tue, 14 Dec 2010 22:35:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	jYwr0BxLiPUek3GE for <linux-xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 22:35:37 -0800 (PST)
Date: Wed, 15 Dec 2010 17:35:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101215063534.GF9925@dastard>
References: <1292203957-15819-1-git-send-email-david@fromorbit.com>
	<1292203957-15819-3-git-send-email-david@fromorbit.com>
	<20101214211801.GH2161@linux.vnet.ibm.com>
	<20101214230047.GC16267@dastard>
	<20101215010536.GT2161@linux.vnet.ibm.com>
	<loom.20101215T041848-135@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20101215T041848-135@post.gmane.org>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-xfs@oss.sgi.com

On Wed, Dec 15, 2010 at 03:30:43AM +0000, Nick Piggin wrote:
> In this case, if you can observe something that has happened after the
> inode is removed from the tree (ie. i_ino has changed), then you should
> not find it in the tree after a subsequent lookup (no synchronize_rcu
> required, just appropriate locking or barriers).

Ok, that's what I thought was supposed to be the case. Thanks
for confirming that, Nick.

> BTW. I wondered if you can also do the radix_tree tag lookup for reclaim
> under RCU?

It's currently under the ->pag_ici_lock using a
radix_tree_gang_lookup_tag, though I think this was a mismerge bug
from an earlier version.

I intended it to be under RCU as the "inode OK for reclaim"
validation checks won't touch an inode that already has XFS_IRECLAIM
already set (i.e. already under reclaim or freed), so the
reliability of tag lookups is not a big deal.

The lookup probably needs to check if XFS_IRECLAIMABLE is set
(rather than asserting it is set) to avoid so as to only reclaim
inodes that are really in the reclaimable state. Note that
->i_flags_lock controls all the state changes, so it should provide
the necessary item memory barriers to ensure that only reclaimable
inodes are found for reclaim.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
