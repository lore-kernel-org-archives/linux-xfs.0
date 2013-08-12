Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 15D217F89
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 058F78F8059
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BHMyBkxO0586hqh1 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xm-QX
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007Lz-PX
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 06/17] xfs: partial inode chunk
	allocation
Date: Mon, 12 Aug 2013 23:19:56 +1000
Message-Id: <1376313607-28133-7-git-send-email-david@fromorbit.com>
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

When a filesystem ages or when certain workloads dominate the storage capacity
of the filesystem, it can become difficult to find contiguous free space in the
filesystem and hence inode allocation can fail long before the filesystem is out
of space.

To avoid this problem, we need to be able to use smaller extents in the
filesystem to hold inodes than the size needed to hold a full chunk. To enable
this, we need to keep track of the region of the inode chunk that has actually
been allocated in the inode allocation record itself. The inobt record contains
a free inode count field that uses 32 bits of space, but has a maximum possible
value of 64. Hence there are many bitsin the field that we can repurpose for
a "allocated regions" mask.

To simplify the implementation and checking of the field, split the 32 bit field
into an 8 bite count variable in the same location as the existing count (i.e.
the LSB of the 32 bit variable, remembering that XFS big endian on disk), an 8
bit pad field and a 16 bit mask field that contains the allocated extent
tracking.

As we have 16 bits in the mask, each bit represents 4 inodes and hence that
defines the minimum allocation size we can support. In all cases, this will
limit the largest contiguous allocation required to 2 blocks for a new as the
minimum filesystem block size is limited by mkfs to being twice the inode size.
In most common configurations, a single block will contain more than 4
inodes and so this isn't a major limitation at all.

Hence during extent allocation for the inode chunk, if we cannot find an aligned
and contiguous extent, we can settle for something that is as large as possible
and mask off the region that we weren't able to allocate. When freeing the
chunk, we'll also know what extent we need to free. And for untrusted inode
number lookup, we can determine if the inode number falls into the invalid part
of the chunk.

Further, to avoid needing to do multiple extent allocations for "sparse" inode
chunks, if we allocate an extent that overlaps an existing partial inode chunk,
we can simply update the mask and free count to indicate that there are multiple
valid extents in the chunk. This gives us a potential route for partial inode
chunks to be made whole via ongoing filesystem modification or a forced scan
once space has been made available.

To make this as close to transparent as possible, use a value of 0 to indicate
that there are valid inodes in this location, and a value of 1 to indicate that
it is an invalid region. This means that the filesystem will be backwards
compatible with existing kernels and userspace up until the first partial chunk
is allocated. At that point, we need to set an incompatible feature flag as
older kernels and userspace are unable to interpret the value in the "free
inodes" field correctly. This also means that if we scan the inode btrees and
determine that there are no partial inode chunks, we can remove the feature
bit...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ialloc_btree.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index 3ac36b76..75ee794 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -48,7 +48,9 @@ static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
  */
 typedef struct xfs_inobt_rec {
 	__be32		ir_startino;	/* starting inode number */
-	__be32		ir_freecount;	/* count of free inodes (set bits) */
+	__be16		ir_alloc_mask;
+	__u8		ir_pad;
+	__u8		ir_freecount;
 	__be64		ir_free;	/* free inode mask */
 } xfs_inobt_rec_t;
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
