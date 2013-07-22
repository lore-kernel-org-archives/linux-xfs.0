Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2D1D7F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 05:18:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 91B648F804C
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 03:18:35 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ojg2dR1aeiuDqy7H for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 03:18:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V1DCC-0003XB-9P
	for xfs@oss.sgi.com; Mon, 22 Jul 2013 20:18:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V1DCC-0003Oy-89
	for xfs@oss.sgi.com; Mon, 22 Jul 2013 20:18:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: di_flushiter considered harmful
Date: Mon, 22 Jul 2013 20:18:24 +1000
Message-Id: <1374488304-13044-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_dinode.h      |  3 +++
 fs/xfs/xfs_inode.c       | 18 +++++++++++++-----
 fs/xfs/xfs_log_recover.c | 13 +++++++++++--
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index 07d735a..e5869b5 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b78481f..651ace5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -896,7 +896,6 @@ xfs_dinode_to_disk(
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
-	to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
 	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
 	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
@@ -924,6 +923,9 @@ xfs_dinode_to_disk(
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_flushiter = 0;
+	} else {
+		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
 }
 
@@ -2882,12 +2884,18 @@ xfs_iflush_int(
 			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
 		goto corrupt_out;
 	}
+
 	/*
-	 * bump the flush iteration count, used to detect flushes which
-	 * postdate a log record during recovery. This is redundant as we now
-	 * log every change and hence this can't happen. Still, it doesn't hurt.
+	 * Inode item log recovery for v1/v2 inodes are dependent on the
+	 * di_flushiter count for correct sequencing. We bump the flush
+	 * iteration count so we can detect flushes which postdate a log record
+	 * during recovery. This is redundant as we now log every change and
+	 * hence this can't happen but we need to still do it to ensure
+	 * backwards compatibility with old kernels that predate logging all
+	 * inode changes.
 	 */
-	ip->i_d.di_flushiter++;
+	if (ip->i_d.di_version < 3)
+		ip->i_d.di_flushiter++;
 
 	/*
 	 * Copy the dirty parts of the inode into the on-disk
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6fcc910a..7681b19 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2592,8 +2592,16 @@ xlog_recover_inode_pass2(
 		goto error;
 	}
 
-	/* Skip replay when the on disk inode is newer than the log one */
-	if (dicp->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
+	/*
+	 * di_flushiter is only valid for v1/2 inodes. All changes for v3 inodes
+	 * are transactional and if ordering is necessary we can determine that
+	 * more accurately by the LSN field in the V3 inode core. Don't trust
+	 * the inode versions we might be changing them here - use the
+	 * superblock flag to determine whether we need to look at di_flushiter
+	 * to skip replay when the on disk inode is newer than the log one
+	 */
+	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
+	    dicp->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
 		 * than smaller numbers
@@ -2608,6 +2616,7 @@ xlog_recover_inode_pass2(
 			goto error;
 		}
 	}
+
 	/* Take the opportunity to reset the flush iteration count */
 	dicp->di_flushiter = 0;
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
