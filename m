Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B390C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 417FE215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XR9vMIMe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCKArX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:47:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33508 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKArX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:47:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0fbAF112414
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GbQk6KKMNWFfcGs+T7ODk6D40cq4oNcnjbc5NX6VdKs=;
 b=XR9vMIMez3Emy8BUDMy91zyqEX2+pikQ6WQWjW7sP5xYlplZg99Ufgl+xJGg0PKeSP1U
 sgcxeQGK1K9R6dKeNBt3R20yk3Y0c25iD1Zgq+rxZoPiD+wJP1/RaunlKPkq1bPjkY9n
 KR5MMWmn2iqybeN4NKjAk6e9EZGWehRNfYLMmKzjCdb4DEaElysOzexe76CCSelPw3Qs
 AqF1hHMYW8EMzIYsiqc+eS5OcW3MdUfkWBZBAFiVuSWy8NfCqMHUm/Y9JbSUU+nGs7p0
 j1Sj7H+vCsukxfuOPnttzGGK2THoblPox/u6ZTelMkslEcWWnJHSdQLPT5nR8X+L92hb ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ym31ugq4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0ccnO088399
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yp8pv5bw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02B0lK7f014411
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:47:20 -0700
Subject: [PATCH 1/7] xfs: add a function to deal with corrupt buffers
 post-verifiers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:47:19 -0700
Message-ID: <158388763904.939165.1796274155705134706.stgit@magnolia>
In-Reply-To: <158388763282.939165.6485358230553665775.stgit@magnolia>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=1 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a helper function to get rid of buffers that we have decided are
corrupt after the verifiers have run.  This function is intended to
handle metadata checks that can't happen in the verifiers, such as
inter-block relationship checking.  Note that we now mark the buffer
stale so that it will not end up on any LRU and will be purged on
release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c     |    2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |    6 +++---
 fs/xfs/libxfs/xfs_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_da_btree.c  |   10 +++++-----
 fs/xfs/libxfs/xfs_dir2_leaf.c |    2 +-
 fs/xfs/libxfs/xfs_dir2_node.c |    6 +++---
 fs/xfs/xfs_attr_inactive.c    |    6 +++---
 fs/xfs/xfs_attr_list.c        |    2 +-
 fs/xfs/xfs_buf.c              |   25 +++++++++++++++++++++++++
 fs/xfs/xfs_buf.h              |    2 ++
 fs/xfs/xfs_error.c            |    2 ++
 fs/xfs/xfs_inode.c            |    4 ++--
 12 files changed, 49 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d8053bc96c4d..24b71e3d401a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -721,7 +721,7 @@ xfs_alloc_update_counters(
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
-		xfs_buf_corruption_error(agbp);
+		xfs_buf_mark_corrupt(agbp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fed537a4353d..208f8f56be0a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2346,7 +2346,7 @@ xfs_attr3_leaf_lookup_int(
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2365,11 +2365,11 @@ xfs_attr3_leaf_lookup_int(
 			break;
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index fd300dc93ca4..0599a3ee7d88 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1762,7 +1762,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 875e04f82541..b6e03b58a5d6 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -590,7 +590,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -603,7 +603,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1624,7 +1624,7 @@ xfs_da3_node_lookup_int(
 		}
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1639,7 +1639,7 @@ xfs_da3_node_lookup_int(
 
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1647,7 +1647,7 @@ xfs_da3_node_lookup_int(
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a131b520aac7..95d2a3f92d75 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1383,7 +1383,7 @@ xfs_dir2_leaf_removename(
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index a0cc5e240306..dbd1e901da92 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -439,7 +439,7 @@ xfs_dir2_leaf_to_node(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_d.di_size / args->geo->blksize) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 
@@ -513,7 +513,7 @@ xfs_dir2_leafn_add(
 	 * into other peoples memory
 	 */
 	if (index < 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -800,7 +800,7 @@ xfs_dir2_leafn_lookup_for_entry(
 
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index fe8f60b59ec4..c42f90e16b4f 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -145,7 +145,7 @@ xfs_attr3_node_inactive(
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return -EFSCORRUPTED;
 	}
@@ -194,7 +194,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			xfs_buf_corruption_error(child_bp);
+			xfs_buf_mark_corrupt(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
 			error = -EFSCORRUPTED;
 			break;
@@ -289,7 +289,7 @@ xfs_attr3_root_inactive(
 		break;
 	default:
 		error = -EFSCORRUPTED;
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d37743bdf274..945fe9a6428b 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -279,7 +279,7 @@ xfs_attr_node_list_lookup(
 	return 0;
 
 out_corruptbuf:
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 11a97bc35f70..9d26e37f78f5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -16,6 +16,8 @@
 #include "xfs_log.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
 
 static kmem_zone_t *xfs_buf_zone;
 
@@ -1572,6 +1574,29 @@ xfs_buf_zero(
 	}
 }
 
+/*
+ * Log a message about and stale a buffer that a caller has decided is corrupt.
+ *
+ * This function should be called for the kinds of metadata corruption that
+ * cannot be detect from a verifier, such as incorrect inter-block relationship
+ * data.  Do /not/ call this function from a verifier function.
+ *
+ * The buffer must not be dirty prior to the call.  Afterwards, the buffer will
+ * be marked stale, but b_error will not be set.  The caller is responsible for
+ * releasing the buffer or fixing it.
+ */
+void
+__xfs_buf_mark_corrupt(
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
+{
+	ASSERT(bp->b_log_item == NULL ||
+	       !(bp->b_log_item->bli_flags & XFS_BLI_DIRTY));
+
+	xfs_buf_corruption_error(bp);
+	xfs_buf_stale(bp);
+}
+
 /*
  *	Handling of buffer targets (buftargs).
  */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1c2640771b9e..deaa9c2607af 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -272,6 +272,8 @@ static inline int xfs_buf_submit(struct xfs_buf *bp)
 }
 
 void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
+void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
+#define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* Buffer Utility Routines */
 extern void *xfs_buf_offset(struct xfs_buf *, size_t);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 331765afc53e..57068d4ffba2 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -345,6 +345,8 @@ xfs_corruption_error(
  * Complain about the kinds of metadata corruption that we can't detect from a
  * verifier, such as incorrect inter-block relationship data.  Does not set
  * bp->b_error.
+ *
+ * Call xfs_buf_mark_corrupt, not this function.
  */
 void
 xfs_buf_corruption_error(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..0368347bb348 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2135,7 +2135,7 @@ xfs_iunlink_update_bucket(
 	 * head of the list.
 	 */
 	if (old_value == new_agino) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2269,7 +2269,7 @@ xfs_iunlink(
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 

