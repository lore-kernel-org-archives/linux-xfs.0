Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41FF87F58
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 19:03:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12F26304039
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 17:03:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wdzuoEwEFqmtVwTO for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 17:03:14 -0800 (PST)
Date: Thu, 13 Feb 2014 12:03:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Limits on agi->agi_level (and other btree depths?)
Message-ID: <20140213010308.GH13997@dastard>
References: <52FC09AB.3030209@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FC09AB.3030209@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 12, 2014 at 05:54:19PM -0600, Eric Sandeen wrote:
> If agi->agi_level exceeds XFS_BTREE_MAXLEVELS (8), bad things
> happen.  For example in xfs_inobt_init_cursor() we read it
> directly off disk into a btree cursor:
> 
> xfs_inobt_init_cursor()
> 	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
> 
> and then when it's time to tear it down we'll index into bc_bufs[]
> buy whatever it said:
> 
> xfs_btree_del_cursor()
>         for (i = 0; i < cur->bc_nlevels; i++) {
>                 if (cur->bc_bufs[i])
>                         xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
> 
> but bc_bufs[] in the xfs_btree_cur is of fixed size:
> 
>         struct xfs_buf  *bc_bufs[XFS_BTREE_MAXLEVELS];  /* buf ptr per level */
> 
> where
> 
> #define XFS_BTREE_MAXLEVELS     8       /* max of all btrees */
> 
> (which means this limits any btree depth, not just agi, right...)
> 
> ...
> So I ran across this on an intentionally corrupted image, but I
> don't know what stops us from going past XFS_BTREE_MAXLEVELS in
> normal operations (unless we just hit filesystem limits before
> then?)

Right, we hit filesystem limits before we get deeper than 8 levels.

For an AGI btree, ptr/key pairs in a node use 8 bytes, while records
use 16 bytes. Hence worst case is a 512 byte blocksize filesystem
where we get roughly 30 records/leaf and 60 ptr/key pairs per node.

So, the number of extents we can reference at different levels are:

level	number
0	30
1	60 * 30
2	60^2 * 30
....
n	60^n * 30

In 1TB AG, worst case freespace is alternate single block freespace,
so that's 1TB/blocksize/2 = (2^31*2^9) / 2^9 / 2^1 = 2^30 extent
records for a 512 byte blocksize filesystem.

2^30  :  1,073,741,824 records
n = 5 :	23,328,000,000 records

So the maximum possible number of levels for an AGI btree is 6 (5
node levels + leaf level). The AGF btrees are the same (32 bit
key/ptrs, 16 byte records)

The AGF freespace trees are more dense - the records are only 8
bytes so there's 60/leaf. It still needs 6 levels though.

For the extent btree (bmbt) it can index 54 bits of file offset, so
worst case is single block fragments so 2^54 extents. Records are 16
bytes, key and pointers are 8 bytes each. Hence 30/30 are the
numbers for a 512 byte block size fs. At level n, the extents are
30^n * 30 = 30^(n+1). So, solving 2^54 <= 30^(n+1) gives n = 11.

So in theory we could overflow XFS_BTREE_MAXLEVELS here, but in
practice this worst case requires 30^8 extents in memory, and that
requires this much RAM:

	656,100,000,000 * sizeof(struct xfs_bmbt_irec) bytes
	= 656,100,000,000 * 32 bytes
	~= 19TiB

And requires reading in from disk 512 bytes at a time.  Nothing in
XFS^WLinux scales to indexing 19TiB of extent metadata with any
efficiency in this manner. And let's face it, if you have a 300TiB
file in single 512 byte block fragments, you've got bigger problems.
The least of which being that you should be using a larger block
size...

Back in reality, if we take a 4k block size, the bmbt tree has a
240/240 breakdown, which means that the equation is actually 2^54 <=
240^(n+1), and in that case n = 6, so we don't overflow
XFS_BTREE_MAXLEVELS at all for the normal mkfs cases.

> i.e. xfs_btree_new_root() does:
> 
>         /* Set the root in the holding structure  increasing the level by 1. */
>         cur->bc_ops->set_root(cur, &lptr, 1);
> 

> and ->set_root / xfs_inobt_set_root() will happily increase
> agi_level; I don't see anything limiting it to
> XFS_BTREE_MAXLEVELS.

Physical limits of the AGI due to the 1TB size of the AG.

> I guess XFS_BTREE_MAXLEVELS is just an arbitrary in-memory limit,
> not a limit of the underlying disk structures, but as it stands,
> we should be sure that we don't exceed it, right?

If you really want to enforce XFS_BTREE_MAXLEVELS, add checks
into xfs_alloc_compute_maxlevels(), xfs_ialloc_compute_maxlevels()
and xfs_bmap_compute_maxlevels() to constrain the limits in the
struct xfs_mount and validate the on-disk values based on the
values in the struct xfs_mount.

> I was going to put that limit into xfs_agi_verify, but realized
> that I wasn't sure if we could actually exceed that depth in
> normal operations.
> 
> (cue dchinner working out that 9 levels is 59 bazillion jillion
> items, and will never be hit?)

Yep, done that ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
