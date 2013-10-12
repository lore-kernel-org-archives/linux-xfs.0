Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2577829DFC
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 20:59:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A5CD8F808F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 18:59:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FaHGZccQvLM3qyCs for <xfs@oss.sgi.com>;
	Fri, 11 Oct 2013 18:59:06 -0700 (PDT)
Message-ID: <5258ACE9.6000401@sandeen.net>
Date: Fri, 11 Oct 2013 20:59:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/4 V2] xfs: remove newlines from strings passed to
	__xfs_printk
References: <52584C8A.1060808@redhat.com> <52584D04.3020907@sandeen.net>
In-Reply-To: <52584D04.3020907@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

__xfs_printk adds its own "\n".  Having it in the original string
leads to unintentional blank lines from these messages.

Most format strings have no newline, but a few do, leading to
i.e.:

[ 7347.119911] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
[ 7347.119911] 
[ 7347.119919] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
[ 7347.119919] 

Fix them all.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index f47e65c..e6b4202 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1482,7 +1482,7 @@ xfs_bmap_search_extents(
 		xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
 				"Access to block zero in inode %llu "
 				"start_block: %llx start_off: %llx "
-				"blkcnt: %llx extent-state: %x lastx: %x\n",
+				"blkcnt: %llx extent-state: %x lastx: %x",
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)gotp->br_startblock,
 			(unsigned long long)gotp->br_startoff,
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2634700..75e4ea7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -590,7 +590,7 @@ found:
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
 			xfs_warn(target->bt_mount,
-				"%s: failed to map pages\n", __func__);
+				"%s: failed to map pagesn", __func__);
 			xfs_buf_relse(bp);
 			return NULL;
 		}
@@ -809,7 +809,7 @@ xfs_buf_get_uncached(
 	error = _xfs_buf_map_pages(bp, 0);
 	if (unlikely(error)) {
 		xfs_warn(target->bt_mount,
-			"%s: failed to map pages\n", __func__);
+			"%s: failed to map pages", __func__);
 		goto fail_free_mem;
 	}
 
@@ -1618,7 +1618,7 @@ xfs_setsize_buftarg_flags(
 		bdevname(btp->bt_bdev, name);
 
 		xfs_warn(btp->bt_mount,
-			"Cannot set_blocksize to %u on device %s\n",
+			"Cannot set_blocksize to %u on device %s",
 			sectorsize, name);
 		return EINVAL;
 	}
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 4c3dba7..34df052 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1101,7 +1101,7 @@ xfs_dir2_leafn_rebalance(
 		state->inleaf = 1;
 		blk2->index = 0;
 		xfs_alert(args->dp->i_mount,
-	"%s: picked the wrong leaf? reverting original leaf: blk1->index %d\n",
+	"%s: picked the wrong leaf? reverting original leaf: blk1->index %d",
 			__func__, blk1->index);
 	}
 }
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 1123d93..40f2985 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -159,7 +159,7 @@ xfs_error_report(
 {
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
-		"Internal error %s at line %d of file %s.  Caller 0x%p\n",
+		"Internal error %s at line %d of file %s.  Caller 0x%p",
 			    tag, linenum, filename, ra);
 
 		xfs_stack_trace();
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8d4d49b..43e31b0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -110,7 +110,7 @@ xfs_alert_fsblock_zero(
 	xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
 			"Access to block zero in inode %llu "
 			"start_block: %llx start_off: %llx "
-			"blkcnt: %llx extent-state: %x\n",
+			"blkcnt: %llx extent-state: %x",
 		(unsigned long long)ip->i_ino,
 		(unsigned long long)imap->br_startblock,
 		(unsigned long long)imap->br_startoff,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2dea10..ea02b48 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1979,7 +1979,7 @@ xlog_print_tic_res(
 
 	for (i = 0; i < ticket->t_res_num; i++) {
 		uint r_type = ticket->t_res_arr[i].r_type;
-		xfs_warn(mp, "region[%u]: %s - %u bytes\n", i,
+		xfs_warn(mp, "region[%u]: %s - %u bytes", i,
 			    ((r_type <= 0 || r_type > XLOG_REG_TYPE_MAX) ?
 			    "bad-rtype" : res_type_str[r_type-1]),
 			    ticket->t_res_arr[i].r_len);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3979749..e7ca48e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -305,9 +305,9 @@ xlog_header_check_dump(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	xfs_debug(mp, "%s:  SB : uuid = %pU, fmt = %d\n",
+	xfs_debug(mp, "%s:  SB : uuid = %pU, fmt = %d",
 		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
-	xfs_debug(mp, "    log : uuid = %pU, fmt = %d\n",
+	xfs_debug(mp, "    log : uuid = %pU, fmt = %d",
 		&head->h_fs_uuid, be32_to_cpu(head->h_fmt));
 }
 #else
@@ -4077,7 +4077,7 @@ xlog_unpack_data_crc(
 	if (crc != rhead->h_crc) {
 		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
 			xfs_alert(log->l_mp,
-		"log record CRC mismatch: found 0x%x, expected 0x%x.\n",
+		"log record CRC mismatch: found 0x%x, expected 0x%x.",
 					le32_to_cpu(rhead->h_crc),
 					le32_to_cpu(crc));
 			xfs_hex_dump(dp, 32);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 8174aad..fb67091 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -287,7 +287,7 @@ xfs_qm_scall_trunc_qfiles(
 	int		error = 0, error2 = 0;
 
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
-		xfs_debug(mp, "%s: flags=%x m_qflags=%x\n",
+		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
 			__func__, flags, mp->m_qflags);
 		return XFS_ERROR(EINVAL);
 	}
@@ -325,7 +325,7 @@ xfs_qm_scall_quotaon(
 	sbflags = 0;
 
 	if (flags == 0) {
-		xfs_debug(mp, "%s: zero flags, m_qflags=%x\n",
+		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
 			__func__, mp->m_qflags);
 		return XFS_ERROR(EINVAL);
 	}
@@ -348,7 +348,7 @@ xfs_qm_scall_quotaon(
 	     (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
 	     (flags & XFS_PQUOTA_ENFD))) {
 		xfs_debug(mp,
-			"%s: Can't enforce without acct, flags=%x sbflags=%x\n",
+			"%s: Can't enforce without acct, flags=%x sbflags=%x",
 			__func__, flags, mp->m_sb.sb_qflags);
 		return XFS_ERROR(EINVAL);
 	}
@@ -648,7 +648,7 @@ xfs_qm_scall_setqlim(
 			q->qi_bsoftlimit = soft;
 		}
 	} else {
-		xfs_debug(mp, "blkhard %Ld < blksoft %Ld\n", hard, soft);
+		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
 	}
 	hard = (newlim->d_fieldmask & FS_DQ_RTBHARD) ?
 		(xfs_qcnt_t) XFS_BB_TO_FSB(mp, newlim->d_rtb_hardlimit) :
@@ -664,7 +664,7 @@ xfs_qm_scall_setqlim(
 			q->qi_rtbsoftlimit = soft;
 		}
 	} else {
-		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld\n", hard, soft);
+		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
 	}
 
 	hard = (newlim->d_fieldmask & FS_DQ_IHARD) ?
@@ -681,7 +681,7 @@ xfs_qm_scall_setqlim(
 			q->qi_isoftlimit = soft;
 		}
 	} else {
-		xfs_debug(mp, "ihard %Ld < isoft %Ld\n", hard, soft);
+		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index a5b59d9..a89d0bc 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -249,13 +249,13 @@ xfs_mount_validate_sb(
 	if (xfs_sb_version_has_pquotino(sbp)) {
 		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
 			xfs_notice(mp,
-			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
+			   "Version 5 of Super block has XFS_OQUOTA bits.");
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
-"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
+"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.");
 			return XFS_ERROR(EFSCORRUPTED);
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 15188cc..77093de 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1246,7 +1246,7 @@ xfs_fs_remount(
 			 */
 #if 0
 			xfs_info(mp,
-		"mount option \"%s\" not supported for remount\n", p);
+		"mount option \"%s\" not supported for remount", p);
 			return -EINVAL;
 #else
 			break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
