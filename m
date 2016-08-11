Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8F6C7CA1
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:11:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 912E4304051
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DcnKkxZslCn8EdC9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:10 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id BEFDC81254
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 17:11:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-69.bos.redhat.com [10.18.41.69])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7BHB9Ti003828
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 13:11:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/5] xfs: don't warn on buffers not being recovered due to LSN
Date: Thu, 11 Aug 2016 13:11:05 -0400
Message-Id: <1470935467-52772-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
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

The log recovery buffer validation function is invoked in cases where a
buffer update may be skipped due to LSN ordering. If the validation
function happens to come across directory conversion situations (e.g., a
dir3 block to data conversion), it may warn about seeing a buffer log
format of one type and a buffer with a magic number of another.

This warning is not valid as the buffer update is ultimately skipped.
This is indicated by a current_lsn of NULLCOMMITLSN provided by the
caller. As such, update xlog_recover_validate_buf_type() to only warn in
such cases when a buffer update is expected.

XXX: other issues here? better to not validate in such cases?

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 59 ++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 283bb7e..cc46db7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2367,6 +2367,7 @@ xlog_recover_validate_buf_type(
 	__uint32_t		magic32;
 	__uint16_t		magic16;
 	__uint16_t		magicda;
+	char			*warnmsg = NULL;
 
 	/*
 	 * We can only do post recovery validation on items on CRC enabled
@@ -2405,31 +2406,27 @@ xlog_recover_validate_buf_type(
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
 		default:
-			xfs_warn(mp, "Bad btree block magic!");
-			ASSERT(0);
+			warnmsg = "Bad btree block magic!";
 			break;
 		}
 		break;
 	case XFS_BLFT_AGF_BUF:
 		if (magic32 != XFS_AGF_MAGIC) {
-			xfs_warn(mp, "Bad AGF block magic!");
-			ASSERT(0);
+			warnmsg = "Bad AGF block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_agf_buf_ops;
 		break;
 	case XFS_BLFT_AGFL_BUF:
 		if (magic32 != XFS_AGFL_MAGIC) {
-			xfs_warn(mp, "Bad AGFL block magic!");
-			ASSERT(0);
+			warnmsg = "Bad AGFL block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_agfl_buf_ops;
 		break;
 	case XFS_BLFT_AGI_BUF:
 		if (magic32 != XFS_AGI_MAGIC) {
-			xfs_warn(mp, "Bad AGI block magic!");
-			ASSERT(0);
+			warnmsg = "Bad AGI block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_agi_buf_ops;
@@ -2439,8 +2436,7 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_GDQUOT_BUF:
 #ifdef CONFIG_XFS_QUOTA
 		if (magic16 != XFS_DQUOT_MAGIC) {
-			xfs_warn(mp, "Bad DQUOT block magic!");
-			ASSERT(0);
+			warnmsg = "Bad DQUOT block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_dquot_buf_ops;
@@ -2452,16 +2448,14 @@ xlog_recover_validate_buf_type(
 		break;
 	case XFS_BLFT_DINO_BUF:
 		if (magic16 != XFS_DINODE_MAGIC) {
-			xfs_warn(mp, "Bad INODE block magic!");
-			ASSERT(0);
+			warnmsg = "Bad INODE block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_inode_buf_ops;
 		break;
 	case XFS_BLFT_SYMLINK_BUF:
 		if (magic32 != XFS_SYMLINK_MAGIC) {
-			xfs_warn(mp, "Bad symlink block magic!");
-			ASSERT(0);
+			warnmsg = "Bad symlink block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_symlink_buf_ops;
@@ -2469,8 +2463,7 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_DIR_BLOCK_BUF:
 		if (magic32 != XFS_DIR2_BLOCK_MAGIC &&
 		    magic32 != XFS_DIR3_BLOCK_MAGIC) {
-			xfs_warn(mp, "Bad dir block magic!");
-			ASSERT(0);
+			warnmsg = "Bad dir block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_dir3_block_buf_ops;
@@ -2478,8 +2471,7 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_DIR_DATA_BUF:
 		if (magic32 != XFS_DIR2_DATA_MAGIC &&
 		    magic32 != XFS_DIR3_DATA_MAGIC) {
-			xfs_warn(mp, "Bad dir data magic!");
-			ASSERT(0);
+			warnmsg = "Bad dir data magic!";
 			break;
 		}
 		bp->b_ops = &xfs_dir3_data_buf_ops;
@@ -2487,8 +2479,7 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_DIR_FREE_BUF:
 		if (magic32 != XFS_DIR2_FREE_MAGIC &&
 		    magic32 != XFS_DIR3_FREE_MAGIC) {
-			xfs_warn(mp, "Bad dir3 free magic!");
-			ASSERT(0);
+			warnmsg = "Bad dir3 free magic!";
 			break;
 		}
 		bp->b_ops = &xfs_dir3_free_buf_ops;
@@ -2496,8 +2487,7 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_DIR_LEAF1_BUF:
 		if (magicda != XFS_DIR2_LEAF1_MAGIC &&
 		    magicda != XFS_DIR3_LEAF1_MAGIC) {
-			xfs_warn(mp, "Bad dir leaf1 magic!");
-			ASSERT(0);
+			warnmsg = "Bad dir leaf1 magic!";
 			break;
 		}
 		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
@@ -2505,8 +2495,7 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_DIR_LEAFN_BUF:
 		if (magicda != XFS_DIR2_LEAFN_MAGIC &&
 		    magicda != XFS_DIR3_LEAFN_MAGIC) {
-			xfs_warn(mp, "Bad dir leafn magic!");
-			ASSERT(0);
+			warnmsg = "Bad dir leafn magic!";
 			break;
 		}
 		bp->b_ops = &xfs_dir3_leafn_buf_ops;
@@ -2514,8 +2503,7 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_DA_NODE_BUF:
 		if (magicda != XFS_DA_NODE_MAGIC &&
 		    magicda != XFS_DA3_NODE_MAGIC) {
-			xfs_warn(mp, "Bad da node magic!");
-			ASSERT(0);
+			warnmsg = "Bad da node magic!";
 			break;
 		}
 		bp->b_ops = &xfs_da3_node_buf_ops;
@@ -2523,24 +2511,21 @@ xlog_recover_validate_buf_type(
 	case XFS_BLFT_ATTR_LEAF_BUF:
 		if (magicda != XFS_ATTR_LEAF_MAGIC &&
 		    magicda != XFS_ATTR3_LEAF_MAGIC) {
-			xfs_warn(mp, "Bad attr leaf magic!");
-			ASSERT(0);
+			warnmsg = "Bad attr leaf magic!";
 			break;
 		}
 		bp->b_ops = &xfs_attr3_leaf_buf_ops;
 		break;
 	case XFS_BLFT_ATTR_RMT_BUF:
 		if (magic32 != XFS_ATTR3_RMT_MAGIC) {
-			xfs_warn(mp, "Bad attr remote magic!");
-			ASSERT(0);
+			warnmsg = "Bad attr remote magic!";
 			break;
 		}
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 		break;
 	case XFS_BLFT_SB_BUF:
 		if (magic32 != XFS_SB_MAGIC) {
-			xfs_warn(mp, "Bad SB block magic!");
-			ASSERT(0);
+			warnmsg = "Bad SB block magic!";
 			break;
 		}
 		bp->b_ops = &xfs_sb_buf_ops;
@@ -2557,6 +2542,16 @@ xlog_recover_validate_buf_type(
 			 xfs_blft_from_flags(buf_f));
 		break;
 	}
+
+	/*
+	 * A NULL current LSN indicates the buffer update is skipped due to LSN
+	 * ordering. Don't warn in such cases, we skip the update for a reason
+	 * (it's no longer valid)!
+	 */
+	if (warnmsg && current_lsn != NULLCOMMITLSN) {
+		xfs_warn(mp, warnmsg);
+		ASSERT(0);
+	}
 }
 
 /*
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
