Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF83cAF182974
	for <linux-xfs@oss.sgi.com>; Wed, 15 Dec 2010 02:03:38 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 036381CC8FBF
	for <linux-xfs@oss.sgi.com>; Wed, 15 Dec 2010 00:05:30 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hl9NZe9x6DOYAbbL for <linux-xfs@oss.sgi.com>;
	Wed, 15 Dec 2010 00:05:30 -0800 (PST)
Date: Wed, 15 Dec 2010 19:05:25 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH 2/3] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101215080525.GA4199@amd>
References: <1292203957-15819-1-git-send-email-david@fromorbit.com>
	<1292203957-15819-3-git-send-email-david@fromorbit.com>
	<20101214211801.GH2161@linux.vnet.ibm.com>
	<20101214230047.GC16267@dastard>
	<20101215010536.GT2161@linux.vnet.ibm.com>
	<loom.20101215T041848-135@post.gmane.org>
	<20101215063534.GF9925@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101215063534.GF9925@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Nick Piggin <npiggin@kernel.dk>

On Wed, Dec 15, 2010 at 05:35:34PM +1100, Dave Chinner wrote:
> On Wed, Dec 15, 2010 at 03:30:43AM +0000, Nick Piggin wrote:
> > In this case, if you can observe something that has happened after the
> > inode is removed from the tree (ie. i_ino has changed), then you should
> > not find it in the tree after a subsequent lookup (no synchronize_rcu
> > required, just appropriate locking or barriers).
> 
> Ok, that's what I thought was supposed to be the case. Thanks
> for confirming that, Nick.
> 
> > BTW. I wondered if you can also do the radix_tree tag lookup for reclaim
> > under RCU?
> 
> It's currently under the ->pag_ici_lock using a
> radix_tree_gang_lookup_tag, though I think this was a mismerge bug
> from an earlier version.
> 
> I intended it to be under RCU as the "inode OK for reclaim"
> validation checks won't touch an inode that already has XFS_IRECLAIM
> already set (i.e. already under reclaim or freed), so the
> reliability of tag lookups is not a big deal.

That would be nice, a while back I was seeing lock contention in
reclaim there, and tried some hacks to improve it, but this should
solve it properly.

The tag lookups should be reliable too -- we use them in pagecache
dirty writeout. Basically same causality rules: if we observe (given
the required barriers or locks) an event we know to have happened after
the tag was set and before it is cleared, then the tag lookup should
find the item.


> The lookup probably needs to check if XFS_IRECLAIMABLE is set
> (rather than asserting it is set) to avoid so as to only reclaim
> inodes that are really in the reclaimable state. Note that
> ->i_flags_lock controls all the state changes, so it should provide
> the necessary item memory barriers to ensure that only reclaimable
> inodes are found for reclaim.

If you are checking and clearing those flags under lock, then I
think everything will be fine.

lock()
set deleted flag
unlock()
delete from radix tree

versus
look up from radix tree
lock()
check deleted flag...

Then at this point we would know that if the deleted flag is not set,
then the item can not have been deleted from the radix tree by the
1st sequence.

The stores that delete the item from the radix tree may be visible
before the deleted flag is visible (due to release-barrier ordering),
but that's not a problem here.

Thanks,
Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
