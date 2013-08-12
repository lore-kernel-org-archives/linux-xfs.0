Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1CA657F8A
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E37B2304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	a00YATuL4rhZIUtv for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xr-St
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007MJ-Ry
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 10/17] xfs: swap extents operations
	for CRC filesystems
Date: Mon, 12 Aug 2013 23:20:00 +1000
Message-Id: <1376313607-28133-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-1-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

For CRC enabled filesystems, we can't just swap inode forks from one inode to
another when defragmenting a file - the blocks in the inode fork bmap btree
contain pointers back to the owner inode. Hence if we are to swap the inode
forks we have to atomically modify every block in the btree during the
transaction.

There are two approaches to doing this. Firstly, if we are doing an entire fork
swap, we could create a new transaction item type that indicates we are changing
the owner of a certain structure from one value to another, and then use ordered
buffer logging to modify all the buffers in the tree without needing to log
them. This would then require log recovery to perform the modification of the
owner information of the objects/structures in question.

This does introduce some interesting ordering details into recovery - we have to
make sure that the owner change replay occurs after the change that moves the
objects is made, not before. Hence we can't use a separate log item for this as
we have no guarantee of strict ordering between multiple items in the log due to
the relogging action of asynchronous transaction commits. Hence there is no
"generic" method we can use for changing the ownership of arbitrary metadata
structures.

For inode forks, however, there is a simple method of communicating that the
fork contents need the owner rewritten - we can pass a inode log format flag
for the fork for the transaction that does a fork swap. This flag will then
follow the inode fork through relogging actions so when the swap actually gets
replayed the ownership can be changed immediately by log recovery. So that gives
us a simple method of "whole fork" exchange between two inodes.

THis is relatively simple to implement, so it makes sense to do this as an
initial implementation to support xfs_fsr on CRC enabled filesytems in the same
manner as we do on existing filesystems.

The second approach is to implement a proper extent swap transaction which moves
an arbitrary range of a fork from one inode to another. This would need to be
done as a permenent rolling transaction that moves a fixed number of extents at
a time between the two inode forks. local/extent format implementation is
trivial - we only need to modify the inode forks and log the inodes to implement
it - but the btree implementation is much, much harder.

The first thing to note is that the two inodes that are being swapped do not
necessarily contain the same data, and hence we cannot assume that we are making
a symmetrical modification. Hence we have to involve an intermediate inode fork
to stage the movement of extents. That is, we move extents from the source to
the intermediate record, move the extents on the target to the source, and then
move the intermediate record extents to the target. Because of the nature of the
movement, we want all three movements in a single transaction but we do not want
the intermediate record to show up in any transactions.

This is made complex due to the fact that the extents being swapped might be of
different offsets and lengths, and hence the movement per transaction may
require swapping of partial extent ranges on one side where one inode has a
alarge contiguous extent and the other has lots of small extents in the same
range. This means that the number of transactions we need to do the swap is
not clearly defined before we start the operation. This is very similar to the
problem truncate has - it has to string multiple extent manipulation operations
together into a single atomic operation.

The extent freeing code does this via a pair of intent/done items that wrap the
entire operation - the EFI/EFD items. To do a co-ordinated, atomic extent swap,
we are going to need to and equivalent intent/done pair of log items to indicate
that the upcoming stream of extent manipulations need to be replayed in
completely. This is necessary as the individual extent movement transactions can
result in bmbt blocks being allocated and freed, and hence can be rolling
transacitons themselves made atomic via EFI/EFD intents in xfs_bmap_finish().
Hence, at minimum, we need to ensure that each extent that is swapped is fully
and correctly replayed and to do that we need Swap Extent Intent and Swap Extent
Done pair of log items.

Like the EFI/EFD items, however, these intents can record multiple extents to be
swapped at a time, and hence this allows us some flexibility in determining how
to batch up modifications for efficiency purposes. The ESI would record the
exact extent records being swapped between inodes and be committed, after which
we can then swap in a multi-transaction loop (to handle bmap btree
allocation/free operations during insert/remove operations) that updates the ESD
after each extent range in the ESI is swapped sucessfully.

As a result, recovery woul dbe very similiar to EFI/EFD recovery - as each ESD
is seen, it cancels the completed range of the related ESI, and when all ranges
are cancelled the ESI/ESD are removed from the reocvery list. If there are ESIs
left at the end of the recovery pass, we then need to run a loop that completes
them and so leaves the the inodes in a known correct state.

This is, overall, much more complex than what is currently needed for xfs_fsr
support, so this is more documentation of how we would implement generic ranged
extent swap support for XFS.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dfrag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dfrag.h b/fs/xfs/xfs_dfrag.h
index 20bdd93..ad688fd 100644
--- a/fs/xfs/xfs_dfrag.h
+++ b/fs/xfs/xfs_dfrag.h
@@ -19,7 +19,7 @@
 #define	__XFS_DFRAG_H__
 
 /*
- * Structure passed to xfs_swapext
+ * Structure passed to xfs_swapext, currently only supports full file
  */
 
 typedef struct xfs_swapext
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
