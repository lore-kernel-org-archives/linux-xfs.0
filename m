Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2G6FAxV002764 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 01:15:11 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IyliHPKXCeujJFvx for <xfs@oss.sgi.com>;
	Thu, 15 Mar 2012 23:15:08 -0700 (PDT)
Date: Fri, 16 Mar 2012 17:15:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: repeatable attribute corruption
Message-ID: <20120316061504.GP5091@dastard>
References: <1331589615.25204.35.camel@montana.filmlight.ltd.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331589615.25204.35.camel@montana.filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On Mon, Mar 12, 2012 at 10:00:15PM +0000, Roger Willcocks wrote:
> Hi folks,
> 
> On stock CentOS kernels from 5.5 (earliest I tried) through to the
> latest 6.2 kernel (as of five days ago) 2.6.32-220.7.1.el6.x86_64 I can
> repeatedly create a silent on-disk corruption. This typically shows up
> later as:
> 
> XFS internal error xfs_da_do_buf(1) at line 2020 of
> file /usr/src/redhat/BUILD/kernel-2.6.18/linux-2.6.18.x86_64/fs/xfs/xfs_da_btree.c
> 
> (or line 2112 of the same file).
> 
> The 'before' metadump is a bit big to attach to an email (~600k) so
> here's a download link valid for 30 days -
> 
> http://private.filmlight.ltd.uk/c4c864ecca4ac13b/xfs_attrib_crash.taz
> 
> - this is a gzip-compressed tar file containing 
> 
> -rw-r--r--.  1 root root   10885632 Mar 12 18:02 xfs_metadump_hda6
> -rw-r--r--.  1 root root       3558 Mar 12 18:15 zap.txt
> 
> The metadump expands to about 5GB. xfs_repair believes it to be clean.
> I've not obfuscated the dump; it was originally a copy of the linux
> header directory from the 5.5 kernel.
> 
> 'zap.txt' simply overwrites a single existing extended (directory)
> attribute with a slightly longer value. So, steps to repeat:
> 
> # xfs_mdrestore xfs_metadump_hda6 xfs.img 
> # mkdir /mnt/disk1
> # mount -o loop xfs.img /mnt/disk1
> # setfattr --restore=zap.txt
> # umount /mnt/disk1
> # xfs_repair -n xfs.img
> ...
> bad sibling back pointer for block 4 in attribute fork for inode 131
> problem with attribute contents in inode 131
> would clear attr fork
> bad nblocks 8 for inode 131, would reset to 3
> bad anextents 4 for inode 131, would reset to 0

OK, I think I have a handle on this now. It is a nasty corner case,
and I'll try to explain it (later most of this will end up in the
commit message).

What we have is the initial condition of a node format attribute
btree with two leaves at index 1 and 2. Call them L1 and L2.  The
leaf L1 is completely full, there is not a single byte of free space
in it. L2 is mostly empty.  The attribute being replaced - call it X
- is the last attribute in L1.

The way an attribute replace is executed is that the replacement
attribute - call it Y - is first inserted into the tree, but has an
INCOMPLETE flag set on it so that list traversals ignore it. Once
this transaction is committed, a second transaction it run to
atomically mark Y as COMPLETE and X as INCOMPLETE, so that a
traversal will now find Y and skip X. Once that transaction is
committed, attribute X is then removed.

So, the initial condition is:

     +--------+     +--------+
     |   L1   |     |   L2   |
     | fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |
     | fsp: 0 |     | fsp: N |
     |--------|     |--------|
     | attr A |     | attr 1 |
     |--------|     |--------|
     | attr B |     | attr 2 |
     |--------|     |--------|
     ..........     ..........
     |--------|     |--------|
     | attr X |     | attr n |
     +--------+     +--------+


So now we go to replace X, and see that L1:fsp = 0 - it is full so
we can't insert Y in the same leaf. So we record the the location of
attribute X so we can track it for later use, then we split L1 into
L1 and L3 and reblance across the two leafs. We end with:


     +--------+     +--------+     +--------+
     |   L1   |     |   L3   |     |   L2   |
     | fwd: 3 |---->| fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |<----| bwd: 3 |
     | fsp: M |     | fsp: J |     | fsp: N |
     |--------|     |--------|     |--------|
     | attr A |     | attr X |     | attr 1 |
     |--------|     +--------+     |--------|
     | attr B |                    | attr 2 |
     |--------|                    |--------|
     ..........                    ..........
     |--------|                    |--------|
     | attr W |                    | attr n |
     +--------+                    +--------+


And we track that the original attribute is now at L3:0.

We then try to insert Y into L1 again, and find that there isn't
enough room because the new attribute is larger than the old one.
Hence we have to split again to make room for Y. We end up with
this:


     +--------+     +--------+     +--------+     +--------+
     |   L1   |     |   L4   |     |   L3   |     |   L2   |
     | fwd: 4 |---->| fwd: 3 |---->| fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |<----| bwd: 4 |<----| bwd: 3 |
     | fsp: M |     | fsp: J |     | fsp: J |     | fsp: N |
     |--------|     |--------|     |--------|     |--------|
     | attr A |     | attr Y |     | attr X |     | attr 1 |
     |--------|     + INCOMP +     +--------+     |--------|
     | attr B |     +--------+                    | attr 2 |
     |--------|                                   |--------|
     ..........                                   ..........
     |--------|                                   |--------|
     | attr W |                                   | attr n |
     +--------+                                   +--------+

And now we have the new (incomplete) attribute @ L4:0, and the
original attribute at L3:0. At this point, the first transaction is
committed, and we move to the flipping of the flags.

This is where we are supposed to end up with this:

     +--------+     +--------+     +--------+     +--------+
     |   L1   |     |   L4   |     |   L3   |     |   L2   |
     | fwd: 4 |---->| fwd: 3 |---->| fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |<----| bwd: 4 |<----| bwd: 3 |
     | fsp: M |     | fsp: J |     | fsp: J |     | fsp: N |
     |--------|     |--------|     |--------|     |--------|
     | attr A |     | attr Y |     | attr X |     | attr 1 |
     |--------|     +--------+     + INCOMP +     |--------|
     | attr B |                    +--------+     | attr 2 |
     |--------|                                   |--------|
     ..........                                   ..........
     |--------|                                   |--------|
     | attr W |                                   | attr n |
     +--------+                                   +--------+

But that doesn't happen properly - the attribute tracking indexes
are not pointing to the right locations, and so we modify random
attributes. We then try to remove attribute X, which then involves
leaf joins, and things then go pear-shaped because the in-memory
state is corrupt, resulting in the breakage we see on disk.

This double split on insertion is indeed a rare corner case becase
growing attributes is not a common operation, and it's even less
common that the attribute being grown is the last attribute in a
full leaf.

The root of the problem is the handling of this corner case - the
initial rebalance moves the entry that is being replaced to a new
block, and the tracking code gets this wrong - it no longer points
to the attribute that will be replaced. That's where it starts going
wrong, but the code that does this tracking is exceedinly twisty and
I don't yet fully understand all the cases it handles. Hence I can
fix this specific problem, but I'm currently causing regressions in
other cases.

I think the first thing I have to do is clean up the tracking code
to use descriptive variables names because it is all to easy to
confuse what "index/blkno" and "index2/blkno2" are actually holding
and that makes it much harder to understand the code.

But, that can wait: it is Beer O'Clock on a hot friday afternoon, so
I'm going take the dog for a walk and then go down to the pub....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
