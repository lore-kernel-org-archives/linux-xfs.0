Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E9C529E22
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 607B48F8033
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	w1lQxjMxUd1TAZFv for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:30 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007dZ-IN
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003vZ-HF
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 50/55] xfs: di_flushiter considered harmful
Date: Thu,  5 Sep 2013 08:05:54 +1000
Message-Id: <1378332359-14737-51-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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

When we made all inode updates transactional, we no longer needed
the log recovery detection for inodes being newer on disk than the
transaction being replayed - it was redundant as replay of the log
would always result in the latest version of the inode woul dbe on
disk. It was redundant, but left in place because it wasn't
considered to be a problem.

However, with the new "don't read inodes on create" optimisation,
flushiter has come back to bite us. Essentially, the optimisation
made always initialises flushiter to zero in the create transaction,
and so if we then crash and run recovery and the inode already on
disk has a non-zero flushiter it will skip recovery of that inode.
As a result, log recovery does the wrong thing and we end up with a
corrupt filesystem.

Because we have to support old kernel to new kernl upgrades, we
can't just get rid of the flushiter support in log recovery as we
might be upgrading from a kernel that doesn't have fully transaction
inode updates.  Unfortunately, for v4 superblocks there is no way to
guarantee that log recovery knows about this fact.

We cannot add a new inode format flag to say it's a "special inode
create" because it won't be understood by older kernels and so
recovery could do the wrong thing on downgrade. We cannot specially
detect the combination of zero mode/non-zero flushiter on disk to
non-zero mode, zero flushiter in the log item during recovery
because wrapping of the flushiter can result in false detection.

Hence that makes this "don't use flushiter" optimisation limited to
a disk format that guarantees that we don't need it. And that means
the only fix here is to limit the "no read IO on create"
optimisation to version 5 superblocks....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_dinode.h   | 3 +++
 libxfs/xfs_inode_buf.c | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
index 07d735a..e5869b5 100644
--- a/include/xfs_dinode.h
+++ b/include/xfs_dinode.h
@@ -39,6 +39,9 @@ typedef struct xfs_timestamp {
  * There is a very similar struct icdinode in xfs_inode which matches the
  * layout of the first 96 bytes of this structure, but is kept in native
  * format instead of big endian.
+ *
+ * Note: di_flushiter is only used by v1/2 inodes - it's effectively a zeroed
+ * padding field for v3 inodes.
  */
 typedef struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 3c811f5..6205318 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -213,7 +213,6 @@ xfs_dinode_to_disk(
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
-	to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
 	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
 	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
@@ -241,6 +240,9 @@ xfs_dinode_to_disk(
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		platform_uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_flushiter = 0;
+	} else {
+		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
 }
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
