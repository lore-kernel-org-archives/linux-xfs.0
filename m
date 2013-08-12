Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F4F47F87
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09B44AC008
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LiUuGx75ulYrhA3F for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xl-Ps
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007Lu-Ot
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 05/17] xfs: introduce a free inode
	allocation btree
Date: Mon, 12 Aug 2013 23:19:55 +1000
Message-Id: <1376313607-28133-6-git-send-email-david@fromorbit.com>
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

One of the biggest problems with inode allocation performance right
now is that searching for a free inode requires an exhaustive scan
of the inode btree to find a record with a free inode in it. IOWs,
the inode btree indexes inode chunks, not free inodes.

To speed up the search for a free inode, introduce a new per-AG
btree rooted in the AGI that tracks records with free inodes in
them. This requires an inode chunk allocation to insert a record
into two AGI btrees - one for the allocated inode chunk, and one
for the free inodes record.

When we allocate a free inode, we now will need to modify two
records - one in each tree - and potentially remove a record from
the free inode btree. That is, if a record has no free inodes, then
it is removed from the btree. This means we have to ensure that the
transaction reservation for a free inode modification has enough
space in it for a inode btree merge.

Finally, it means that freeing an inode can insert a record into the
free inode btree. This can cause a split of the tree and hence we
need to ensure that the transaction reservation takes this into
account.

This structure means that the free inode btree only tracks inode
chunks with free inodes in them and hence will always provide
extremely fast lookup of the closest free inode to the allocation
target. When the free inode btree exists, we will no longer use the
allocated inode chunk btree for allocation lookups - only the free
inode btree will be used.

This functionality requires that we use a read-only compatible
feature flag - older kernels can still read the filesystem structure
just fine, but they aren't allowed to modify it as that will result
in the new free inode btree not being updated correctly.

Another advantage of the second btree is that we now have some
redundant metadata pointing to inode chunks. it's not complete, but
it certainly will help determining if an inode is supposed to be
free or not when corruptions occur. i.e. it is no longer a single
bit of data in a single btree record.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index eb25689..1a97646 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -166,6 +166,9 @@ typedef struct xfs_agi {
 	__be32		agi_pad32;
 	__be64		agi_lsn;	/* last write sequence */
 
+	__be32		agi_free_root;
+	__be32		agi_free_level;
+
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
