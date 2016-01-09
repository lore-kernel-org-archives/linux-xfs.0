Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A7D967F52
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 15:29:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44022AC001
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 13:29:21 -0800 (PST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id l3707KRV1NWAeWxj
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Jan 2016 13:29:18 -0800 (PST)
Received: by mail-wm0-f43.google.com with SMTP id b14so217592601wmb.1
	for <xfs@oss.sgi.com>; Sat, 09 Jan 2016 13:29:18 -0800 (PST)
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] XFS: fix typos
Date: Sat,  9 Jan 2016 22:29:05 +0100
Message-Id: <1452374945-560-1-git-send-email-andrea.gelmini@gelma.net>
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
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, darrick.wong@oracle.com

It cleanely applies to Linus' master:
751e5f5c753e8d447bcf89f9e96b9616ac081628

and XFS for-next branch:
4922be51ef1a95ca6a38694cf0cde5dd0308a24e

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

---
 fs/xfs/libxfs/xfs_btree.c      | 4 ++--
 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 fs/xfs/xfs_bmap_util.c         | 2 +-
 fs/xfs/xfs_icache.c            | 2 +-
 fs/xfs/xfs_ioctl32.c           | 2 +-
 fs/xfs/xfs_log.c               | 2 +-
 fs/xfs/xfs_log_cil.c           | 2 +-
 fs/xfs/xfs_log_priv.h          | 2 +-
 fs/xfs/xfs_super.c             | 2 +-
 fs/xfs/xfs_trans_ail.c         | 2 +-
 fs/xfs/xfs_trans_priv.h        | 2 +-
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index af1bbee..2423337 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -222,7 +222,7 @@ xfs_btree_check_ptr(
  * Calculate CRC on the whole btree block and stuff it into the
  * long-form btree header.
  *
- * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
+ * Prior to calculating the CRC, pull the LSN out of the buffer log item and put
  * it into the buffer so recovery knows what the last modification was that made
  * it to disk.
  */
@@ -260,7 +260,7 @@ xfs_btree_lblock_verify_crc(
  * Calculate CRC on the whole btree block and stuff it into the
  * short-form btree header.
  *
- * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
+ * Prior to calculating the CRC, pull the LSN out of the buffer log item and put
  * it into the buffer so recovery knows what the last modification was that made
  * it to disk.
  */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 68cb1e7..14258f3 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -666,7 +666,7 @@ xfs_calc_attrsetm_reservation(
  * Since the runtime attribute transaction space is dependent on the total
  * blocks needed for the 1st bmap, here we calculate out the space unit for
  * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by:
+ * to the attribute extent length in blocks by:
  *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
  */
 STATIC uint
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dbae649..1163cfb 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -741,7 +741,7 @@ xfs_getbmap(
 }
 
 /*
- * dead simple method of punching delalyed allocation blocks from a range in
+ * dead simple method of punching delayed allocation blocks from a range in
  * the inode. Walks a block at a time so will be slow, but is only executed in
  * rare error cases so the overhead is not critical. This will always punch out
  * both the start and end blocks, even if the ranges only partially overlap
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d7a490f..ee1e0c5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -403,7 +403,7 @@ xfs_iget(
 	 * xfs_reclaim_inode() uses the ILOCK to ensure an inode
 	 * doesn't get freed while it's being referenced during a
 	 * radix tree traversal here.  It assumes this function
-	 * aqcuires only the ILOCK (and therefore it has no need to
+	 * acquires only the ILOCK (and therefore it has no need to
 	 * involve the IOLOCK in this synchronization).
 	 */
 	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 1a05d8a..0978ec7 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -618,7 +618,7 @@ xfs_file_compat_ioctl(
 		return error;
 	}
 #endif
-	/* long changes size, but xfs only copiese out 32 bits */
+	/* long changes size, but xfs only copies out 32 bits */
 	case XFS_IOC_GETXFLAGS_32:
 	case XFS_IOC_SETXFLAGS_32:
 	case XFS_IOC_GETVERSION_32:
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f52c72a..8d7685d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1835,7 +1835,7 @@ xlog_sync(
 		iclog->ic_bwritecnt = 1;
 	}
 
-	/* calculcate the checksum */
+	/* calculate the checksum */
 	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
 					    iclog->ic_datap, size);
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4e76493..1b10909 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -144,7 +144,7 @@ xfs_cil_prepare_item(
  * regions into the flat buffer. We can do this because we still have to do a
  * formatting step to write the regions into the iclog buffer.  Writing the
  * ophdrs during the iclog write means that we can support splitting large
- * regions across iclog boundares without needing a change in the format of the
+ * regions across iclog boundaries without needing a change in the format of the
  * item/region encapsulation.
  *
  * Hence what we need to do now is change the rewrite the vector array to point
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8daba74..fb97fac 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -341,7 +341,7 @@ struct xfs_cil {
 #define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
 
 /*
- * ticket grant locks, queues and accounting have their own cachlines
+ * ticket grant locks, queues and accounting have their own cachelines
  * as these are quite hot and can be operated on concurrently.
  */
 struct xlog_grant_head {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36bd882..02141da 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -645,7 +645,7 @@ xfs_set_inode64(struct xfs_mount *mp, xfs_agnumber_t agcount)
 	/* There is no need for lock protection on m_flags,
 	 * the rw_semaphore of the VFS superblock is locked
 	 * during mount/umount/remount operations, so this is
-	 * enough to avoid concurency on the m_flags field
+	 * enough to avoid concurrency on the m_flags field
 	 */
 	mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
 			 XFS_MOUNT_SMALL_INUMS);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index aa67339..f0525d4 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -547,7 +547,7 @@ xfsaild(
  * The push is run asynchronously in a workqueue, which means the caller needs
  * to handle waiting on the async flush for space to become available.
  * We don't want to interrupt any push that is in progress, hence we only queue
- * work if we set the pushing bit approriately.
+ * work if we set the pushing bit appropriately.
  *
  * We do this unlocked - we only need to know whether there is anything in the
  * AIL at the time we are called. We don't need to access the contents of
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 49931b7..2fc9b33 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -39,7 +39,7 @@ void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
  * AIL traversal cursor.
  *
  * Rather than using a generation number for detecting changes in the ail, use
- * a cursor that is protected by the ail lock. The aild cursor exists in the
+ * a cursor that is protected by the ail lock. The ail cursor exists in the
  * struct xfs_ail, but other traversals can declare it on the stack and link it
  * to the ail list.
  *
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
