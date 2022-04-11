Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FA5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiDKAeF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiDKAeD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:03 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24011101C8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6885253AD22
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMq-Ck
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjS-Bo
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/17] xfs: convert da btree operations flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:40 +1000
Message-Id: <20220411003147.2104423-11-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=AR0yTNBFOIPYUhVLj-UA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_da_btree.h | 16 ++++++++--------
 fs/xfs/xfs_trace.h           |  8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0faf7d9ac241..7b0f986e5cb5 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -76,19 +76,19 @@ typedef struct xfs_da_args {
 	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
 	int		rmtblkcnt2;	/* remote attr value block count */
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
-	int		op_flags;	/* operation flags */
+	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
 } xfs_da_args_t;
 
 /*
  * Operation flags:
  */
-#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
-#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
-#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
-#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
-#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
-#define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
+#define XFS_DA_OP_JUSTCHECK	(1u << 0) /* check for ok with no space */
+#define XFS_DA_OP_RENAME	(1u << 1) /* this is an atomic rename op */
+#define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation */
+#define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
+#define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
+#define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -197,7 +197,7 @@ int	xfs_da3_node_read_mapped(struct xfs_trans *tp, struct xfs_inode *dp,
  * Utility routines.
  */
 
-#define XFS_DABUF_MAP_HOLE_OK	(1 << 0)
+#define XFS_DABUF_MAP_HOLE_OK	(1u << 0)
 
 int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
 int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b141ef78c755..989ecda904db 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1924,7 +1924,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__field(int, namelen)
 		__field(xfs_dahash_t, hashval)
 		__field(xfs_ino_t, inumber)
-		__field(int, op_flags)
+		__field(uint32_t, op_flags)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
@@ -1990,7 +1990,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 		__field(xfs_dahash_t, hashval)
 		__field(unsigned int, attr_filter)
 		__field(unsigned int, attr_flags)
-		__field(int, op_flags)
+		__field(uint32_t, op_flags)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
@@ -2097,7 +2097,7 @@ DECLARE_EVENT_CLASS(xfs_dir2_space_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__field(int, op_flags)
+		__field(uint32_t, op_flags)
 		__field(int, idx)
 	),
 	TP_fast_assign(
@@ -2128,7 +2128,7 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__field(int, op_flags)
+		__field(uint32_t, op_flags)
 		__field(int, src_idx)
 		__field(int, dst_idx)
 		__field(int, count)
-- 
2.35.1

