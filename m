Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34682 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755520AbeAIUqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 15:46:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09Kfh7U075088
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:03 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2fd4kxr4vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 20:46:03 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09Kk2WY003387
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:02 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09Kk0XU009471
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:00 GMT
Subject: [PATCH 1/3] xfs: change 0x%p -> %p in print messages
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Jan 2018 12:45:59 -0800
Message-ID: <151553075925.16288.12486014729801230618.stgit@magnolia>
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

Since %p prepends "0x" to the outputted string, we can drop the prefix.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |    2 +-
 fs/xfs/xfs_fsops.c            |    2 +-
 fs/xfs/xfs_inode.c            |   10 +++++-----
 fs/xfs/xfs_log.c              |    4 ++--
 fs/xfs/xfs_log_recover.c      |   24 ++++++++++++------------
 fs/xfs/xfs_trace.h            |   14 +++++++-------
 6 files changed, 28 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 915c4fe..e900dbc 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1919,7 +1919,7 @@ xfs_dir2_node_addname_int(
 					(unsigned long long)ifbno, lastfbno);
 				if (fblk) {
 					xfs_alert(mp,
-				" fblk 0x%p blkno %llu index %d magic 0x%x",
+				" fblk %p blkno %llu index %d magic 0x%x",
 						fblk,
 						(unsigned long long)fblk->blkno,
 						fblk->index,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 84d7383..cc86b2b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -878,7 +878,7 @@ xfs_do_force_shutdown(
 
 	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
 		xfs_notice(mp,
-	"%s(0x%x) called from line %d of file %s.  Return address = 0x%p",
+	"%s(0x%x) called from line %d of file %s.  Return address = %p",
 			__func__, flags, lnnum, fname, __return_address);
 	}
 	/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 663b546..e93fb88 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3529,7 +3529,7 @@ xfs_iflush_int(
 	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
 			       mp, XFS_ERRTAG_IFLUSH_1)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: Bad inode %Lu magic number 0x%x, ptr 0x%p",
+			"%s: Bad inode %Lu magic number 0x%x, ptr %p",
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
@@ -3539,7 +3539,7 @@ xfs_iflush_int(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
 		    mp, XFS_ERRTAG_IFLUSH_3)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-				"%s: Bad regular inode %Lu, ptr 0x%p",
+				"%s: Bad regular inode %Lu, ptr %p",
 				__func__, ip->i_ino, ip);
 			goto corrupt_out;
 		}
@@ -3550,7 +3550,7 @@ xfs_iflush_int(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
 		    mp, XFS_ERRTAG_IFLUSH_4)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-				"%s: Bad directory inode %Lu, ptr 0x%p",
+				"%s: Bad directory inode %Lu, ptr %p",
 				__func__, ip->i_ino, ip);
 			goto corrupt_out;
 		}
@@ -3559,7 +3559,7 @@ xfs_iflush_int(
 				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr 0x%p",
+			"total extents = %d, nblocks = %Ld, ptr %p",
 			__func__, ip->i_ino,
 			ip->i_d.di_nextents + ip->i_d.di_anextents,
 			ip->i_d.di_nblocks, ip);
@@ -3568,7 +3568,7 @@ xfs_iflush_int(
 	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: bad inode %Lu, forkoff 0x%x, ptr 0x%p",
+			"%s: bad inode %Lu, forkoff 0x%x, ptr %p",
 			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
 		goto corrupt_out;
 	}
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 047df85..922e5a9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2244,7 +2244,7 @@ xlog_write_setup_ophdr(
 		break;
 	default:
 		xfs_warn(log->l_mp,
-			"Bad XFS transaction clientid 0x%x in ticket 0x%p",
+			"Bad XFS transaction clientid 0x%x in ticket %p",
 			ophdr->oh_clientid, ticket);
 		return NULL;
 	}
@@ -3926,7 +3926,7 @@ xlog_verify_iclog(
 		}
 		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG)
 			xfs_warn(log->l_mp,
-				"%s: invalid clientid %d op 0x%p offset 0x%lx",
+				"%s: invalid clientid %d op %p offset 0x%lx",
 				__func__, clientid, ophead,
 				(unsigned long)field_offset);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7864a29..205bace 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2218,7 +2218,7 @@ xlog_recover_do_inode_buffer(
 				next_unlinked_offset - reg_buf_offset;
 		if (unlikely(*logged_nextp == 0)) {
 			xfs_alert(mp,
-		"Bad inode buffer log record (ptr = 0x%p, bp = 0x%p). "
+		"Bad inode buffer log record (ptr = %p, bp = %p). "
 		"Trying to replay bad (0) inode di_next_unlinked field.",
 				item, bp);
 			XFS_ERROR_REPORT("xlog_recover_do_inode_buf",
@@ -3049,7 +3049,7 @@ xlog_recover_inode_pass2(
 	 */
 	if (unlikely(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))) {
 		xfs_alert(mp,
-	"%s: Bad inode magic number, dip = 0x%p, dino bp = 0x%p, ino = %Ld",
+	"%s: Bad inode magic number, dip = %p, dino bp = %p, ino = %Ld",
 			__func__, dip, bp, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(1)",
 				 XFS_ERRLEVEL_LOW, mp);
@@ -3059,7 +3059,7 @@ xlog_recover_inode_pass2(
 	ldip = item->ri_buf[1].i_addr;
 	if (unlikely(ldip->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_alert(mp,
-			"%s: Bad inode log record, rec ptr 0x%p, ino %Ld",
+			"%s: Bad inode log record, rec ptr %p, ino %Ld",
 			__func__, item, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(2)",
 				 XFS_ERRLEVEL_LOW, mp);
@@ -3117,8 +3117,8 @@ xlog_recover_inode_pass2(
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
 					 XFS_ERRLEVEL_LOW, mp, ldip);
 			xfs_alert(mp,
-		"%s: Bad regular inode log record, rec ptr 0x%p, "
-		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
+		"%s: Bad regular inode log record, rec ptr %p, "
+		"ino ptr = %p, ino bp = %p, ino %Ld",
 				__func__, item, dip, bp, in_f->ilf_ino);
 			error = -EFSCORRUPTED;
 			goto out_release;
@@ -3130,8 +3130,8 @@ xlog_recover_inode_pass2(
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
 					     XFS_ERRLEVEL_LOW, mp, ldip);
 			xfs_alert(mp,
-		"%s: Bad dir inode log record, rec ptr 0x%p, "
-		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
+		"%s: Bad dir inode log record, rec ptr %p, "
+		"ino ptr = %p, ino bp = %p, ino %Ld",
 				__func__, item, dip, bp, in_f->ilf_ino);
 			error = -EFSCORRUPTED;
 			goto out_release;
@@ -3141,8 +3141,8 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
-	"dino bp 0x%p, ino %Ld, total extents = %d, nblocks = %Ld",
+	"%s: Bad inode log record, rec ptr %p, dino ptr %p, "
+	"dino bp %p, ino %Ld, total extents = %d, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
 			ldip->di_nextents + ldip->di_anextents,
 			ldip->di_nblocks);
@@ -3153,8 +3153,8 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
 				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
-	"dino bp 0x%p, ino %Ld, forkoff 0x%x", __func__,
+	"%s: Bad inode log record, rec ptr %p, dino ptr %p, "
+	"dino bp %p, ino %Ld, forkoff 0x%x", __func__,
 			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
 		error = -EFSCORRUPTED;
 		goto out_release;
@@ -3164,7 +3164,7 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
-			"%s: Bad inode log record length %d, rec ptr 0x%p",
+			"%s: Bad inode log record length %d, rec ptr %p",
 			__func__, item->ri_buf[1].i_len, item);
 		error = -EFSCORRUPTED;
 		goto out_release;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b6251f8..560545f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -72,7 +72,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 		__entry->flags = ctx->flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "alist 0x%p size %u count %u firstu %u flags %d %s",
+		  "alist %p size %u count %u firstu %u flags %d %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		   __entry->ino,
 		   __entry->hashval,
@@ -200,7 +200,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		__entry->bt_before = be32_to_cpu(btree->before);
 	),
 	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
-		  "alist 0x%p size %u count %u firstu %u flags %d %s "
+		  "alist %p size %u count %u firstu %u flags %d %s "
 		  "node hashval %u, node before %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		   __entry->ino,
@@ -251,7 +251,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->bmap_state = state;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx state %s cur 0x%p/%d "
+	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
 		  "offset %lld block %lld count %lld flag %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -460,7 +460,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 	),
 	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
 		  "lock %d flags %s recur %d refcount %d bliflags %s "
-		  "lidesc 0x%p liflags %s",
+		  "lidesc %p liflags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->buf_bno,
 		  __entry->buf_len,
@@ -1028,7 +1028,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
 		__entry->flags = lip->li_flags;
 		__entry->lsn = lip->li_lsn;
 	),
-	TP_printk("dev %d:%d lip 0x%p lsn %d/%d type %s flags %s",
+	TP_printk("dev %d:%d lip %p lsn %d/%d type %s flags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->lip,
 		  CYCLE_LSN(__entry->lsn), BLOCK_LSN(__entry->lsn),
@@ -1082,7 +1082,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
 		__entry->old_lsn = old_lsn;
 		__entry->new_lsn = new_lsn;
 	),
-	TP_printk("dev %d:%d lip 0x%p old lsn %d/%d new lsn %d/%d type %s flags %s",
+	TP_printk("dev %d:%d lip %p old lsn %d/%d new lsn %d/%d type %s flags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->lip,
 		  CYCLE_LSN(__entry->old_lsn), BLOCK_LSN(__entry->old_lsn),
@@ -2014,7 +2014,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
 		__entry->count = item->ri_cnt;
 		__entry->total = item->ri_total;
 	),
-	TP_printk("dev %d:%d tid 0x%x lsn 0x%llx, pass %d, item 0x%p, "
+	TP_printk("dev %d:%d tid 0x%x lsn 0x%llx, pass %d, item %p, "
 		  "item type %s item region count/total %d/%d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->tid,

