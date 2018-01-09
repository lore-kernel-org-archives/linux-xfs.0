Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34806 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755295AbeAIUqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 15:46:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09KfgUv075078
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:14 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2fd4kxr4vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 20:46:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09KkCUP004088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:13 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09KkCPG020365
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:12 GMT
Subject: [PATCH 3/3] xfs: use %px for data pointers when debugging
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Jan 2018 12:46:11 -0800
Message-ID: <151553077155.16288.9554063846414673501.stgit@magnolia>
In-Reply-To: <151553075309.16288.5030700495895866371.stgit@magnolia>
References: <151553075309.16288.5030700495895866371.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Starting with commit 57e734423ad ("vsprintf: refactor %pK code out of
pointer"), the behavior of the raw '%p' printk format specifier was
changed to print a 32-bit hash of the pointer value to avoid leaking
kernel pointers into dmesg.  For most situations that's good.

This is /undesirable/ behavior when we're trying to debug XFS, however,
so define a PTR_FMT that prints the actual pointer when we're in debug
mode.

Note that %p for tracepoints still prints the raw pointer, so in the
long run we could consider rewriting some of these messages as
tracepoints.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |    2 +-
 fs/xfs/xfs_aops.c             |    2 +-
 fs/xfs/xfs_dquot_item.c       |    2 +-
 fs/xfs/xfs_fsops.c            |    2 +-
 fs/xfs/xfs_inode.c            |   10 +++++-----
 fs/xfs/xfs_linux.h            |    6 ++++++
 fs/xfs/xfs_log.c              |    4 ++--
 fs/xfs/xfs_log_recover.c      |   24 ++++++++++++------------
 fs/xfs/xfs_qm.c               |    4 ++--
 9 files changed, 31 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index e900dbc..bb893ae 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1919,7 +1919,7 @@ xfs_dir2_node_addname_int(
 					(unsigned long long)ifbno, lastfbno);
 				if (fblk) {
 					xfs_alert(mp,
-				" fblk %p blkno %llu index %d magic 0x%x",
+				" fblk "PTR_FMT" blkno %llu index %d magic 0x%x",
 						fblk,
 						(unsigned long long)fblk->blkno,
 						fblk->index,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4fc526a..2e094c7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -791,7 +791,7 @@ xfs_aops_discard_page(
 		goto out_invalidate;
 
 	xfs_alert(ip->i_mount,
-		"page discard on page %p, inode 0x%llx, offset %llu.",
+		"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
 			page, ip->i_ino, offset);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 664dea1..e564f11 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -212,7 +212,7 @@ xfs_qm_dquot_logitem_push(
 
 	error = xfs_qm_dqflush(dqp, &bp);
 	if (error) {
-		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
+		xfs_warn(dqp->q_mount, "%s: push error %d on dqp "PTR_FMT,
 			__func__, error, dqp);
 	} else {
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cc86b2b..8b45456 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -878,7 +878,7 @@ xfs_do_force_shutdown(
 
 	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
 		xfs_notice(mp,
-	"%s(0x%x) called from line %d of file %s.  Return address = %p",
+	"%s(0x%x) called from line %d of file %s.  Return address = "PTR_FMT,
 			__func__, flags, lnnum, fname, __return_address);
 	}
 	/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 29c47da..c9e40d4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3529,7 +3529,7 @@ xfs_iflush_int(
 	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
 			       mp, XFS_ERRTAG_IFLUSH_1)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: Bad inode %Lu magic number 0x%x, ptr %p",
+			"%s: Bad inode %Lu magic number 0x%x, ptr "PTR_FMT,
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
@@ -3539,7 +3539,7 @@ xfs_iflush_int(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
 		    mp, XFS_ERRTAG_IFLUSH_3)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-				"%s: Bad regular inode %Lu, ptr %p",
+				"%s: Bad regular inode %Lu, ptr "PTR_FMT,
 				__func__, ip->i_ino, ip);
 			goto corrupt_out;
 		}
@@ -3550,7 +3550,7 @@ xfs_iflush_int(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
 		    mp, XFS_ERRTAG_IFLUSH_4)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-				"%s: Bad directory inode %Lu, ptr %p",
+				"%s: Bad directory inode %Lu, ptr "PTR_FMT,
 				__func__, ip->i_ino, ip);
 			goto corrupt_out;
 		}
@@ -3559,7 +3559,7 @@ xfs_iflush_int(
 				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr %p",
+			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_d.di_nextents + ip->i_d.di_anextents,
 			ip->i_d.di_nblocks, ip);
@@ -3568,7 +3568,7 @@ xfs_iflush_int(
 	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: bad inode %Lu, forkoff 0x%x, ptr %p",
+			"%s: bad inode %Lu, forkoff 0x%x, ptr "PTR_FMT,
 			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
 		goto corrupt_out;
 	}
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index fd03780..0949bab 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -291,4 +291,10 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 #define XFS_IS_REALTIME_MOUNT(mp) (0)
 #endif
 
+#ifdef DEBUG
+# define PTR_FMT "%px"
+#else
+# define PTR_FMT "%p"
+#endif
+
 #endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 922e5a9..c1f266c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2244,7 +2244,7 @@ xlog_write_setup_ophdr(
 		break;
 	default:
 		xfs_warn(log->l_mp,
-			"Bad XFS transaction clientid 0x%x in ticket %p",
+			"Bad XFS transaction clientid 0x%x in ticket "PTR_FMT,
 			ophdr->oh_clientid, ticket);
 		return NULL;
 	}
@@ -3926,7 +3926,7 @@ xlog_verify_iclog(
 		}
 		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG)
 			xfs_warn(log->l_mp,
-				"%s: invalid clientid %d op %p offset 0x%lx",
+				"%s: invalid clientid %d op "PTR_FMT" offset 0x%lx",
 				__func__, clientid, ophead,
 				(unsigned long)field_offset);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 205bace..d864380 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2218,7 +2218,7 @@ xlog_recover_do_inode_buffer(
 				next_unlinked_offset - reg_buf_offset;
 		if (unlikely(*logged_nextp == 0)) {
 			xfs_alert(mp,
-		"Bad inode buffer log record (ptr = %p, bp = %p). "
+		"Bad inode buffer log record (ptr = "PTR_FMT", bp = "PTR_FMT"). "
 		"Trying to replay bad (0) inode di_next_unlinked field.",
 				item, bp);
 			XFS_ERROR_REPORT("xlog_recover_do_inode_buf",
@@ -3049,7 +3049,7 @@ xlog_recover_inode_pass2(
 	 */
 	if (unlikely(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))) {
 		xfs_alert(mp,
-	"%s: Bad inode magic number, dip = %p, dino bp = %p, ino = %Ld",
+	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %Ld",
 			__func__, dip, bp, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(1)",
 				 XFS_ERRLEVEL_LOW, mp);
@@ -3059,7 +3059,7 @@ xlog_recover_inode_pass2(
 	ldip = item->ri_buf[1].i_addr;
 	if (unlikely(ldip->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_alert(mp,
-			"%s: Bad inode log record, rec ptr %p, ino %Ld",
+			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %Ld",
 			__func__, item, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(2)",
 				 XFS_ERRLEVEL_LOW, mp);
@@ -3117,8 +3117,8 @@ xlog_recover_inode_pass2(
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
 					 XFS_ERRLEVEL_LOW, mp, ldip);
 			xfs_alert(mp,
-		"%s: Bad regular inode log record, rec ptr %p, "
-		"ino ptr = %p, ino bp = %p, ino %Ld",
+		"%s: Bad regular inode log record, rec ptr "PTR_FMT", "
+		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
 				__func__, item, dip, bp, in_f->ilf_ino);
 			error = -EFSCORRUPTED;
 			goto out_release;
@@ -3130,8 +3130,8 @@ xlog_recover_inode_pass2(
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
 					     XFS_ERRLEVEL_LOW, mp, ldip);
 			xfs_alert(mp,
-		"%s: Bad dir inode log record, rec ptr %p, "
-		"ino ptr = %p, ino bp = %p, ino %Ld",
+		"%s: Bad dir inode log record, rec ptr "PTR_FMT", "
+		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
 				__func__, item, dip, bp, in_f->ilf_ino);
 			error = -EFSCORRUPTED;
 			goto out_release;
@@ -3141,8 +3141,8 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr %p, dino ptr %p, "
-	"dino bp %p, ino %Ld, total extents = %d, nblocks = %Ld",
+	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
+	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
 			ldip->di_nextents + ldip->di_anextents,
 			ldip->di_nblocks);
@@ -3153,8 +3153,8 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
 				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr %p, dino ptr %p, "
-	"dino bp %p, ino %Ld, forkoff 0x%x", __func__,
+	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
+	"dino bp "PTR_FMT", ino %Ld, forkoff 0x%x", __func__,
 			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
 		error = -EFSCORRUPTED;
 		goto out_release;
@@ -3164,7 +3164,7 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
-			"%s: Bad inode log record length %d, rec ptr %p",
+			"%s: Bad inode log record length %d, rec ptr "PTR_FMT,
 			__func__, item->ri_buf[1].i_len, item);
 		error = -EFSCORRUPTED;
 		goto out_release;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6b9f44d..5b848f4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -162,7 +162,7 @@ xfs_qm_dqpurge(
 		 */
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (error) {
-			xfs_warn(mp, "%s: dquot %p flush failed",
+			xfs_warn(mp, "%s: dquot "PTR_FMT" flush failed",
 				__func__, dqp);
 		} else {
 			error = xfs_bwrite(bp);
@@ -480,7 +480,7 @@ xfs_qm_dquot_isolate(
 
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (error) {
-			xfs_warn(dqp->q_mount, "%s: dquot %p flush failed",
+			xfs_warn(dqp->q_mount, "%s: dquot "PTR_FMT" flush failed",
 				 __func__, dqp);
 			goto out_unlock_dirty;
 		}

