Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLRUjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:39:35 -0500
Subject: [PATCH 2/6] xfs: fix symbolic enum printing in ftrace output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:39:29 -0800
Message-ID: <154516556916.31776.11831175710375975166.stgit@magnolia>
In-Reply-To: <154516555511.31776.9868161112615886200.stgit@magnolia>
References: <154516555511.31776.9868161112615886200.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, sandeen@sandeen.net

From: Darrick J. Wong <darrick.wong@oracle.com>

ftrace's __print_symbolic() has a (very poorly documented) requirement
that any enum values used in the symbol to string translation table be
wrapped in a TRACE_DEFINE_ENUM so that the enum value can be encoded in
the ftrace ring buffer.  Fix this unsatisfied requirement.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_types.h |    4 ++++
 fs/xfs/xfs_aops.h         |    3 +++
 fs/xfs/xfs_trace.h        |   19 +++++++++++++++++++
 3 files changed, 26 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 05e8fa558f3e..e03508a650c4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -100,6 +100,10 @@ typedef void *		xfs_failaddr_t;
  */
 #define MAXNAMELEN	256
 
+/*
+ * This enum is used in string mapping in xfs_trace.h; please keep the
+ * TRACE_DEFINE_ENUMs for it up to date.
+ */
 typedef enum {
 	XFS_LOOKUP_EQi, XFS_LOOKUP_LEi, XFS_LOOKUP_GEi
 } xfs_lookup_t;
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 494b4338446e..e5c23948a8ab 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -10,6 +10,9 @@ extern struct bio_set xfs_ioend_bioset;
 
 /*
  * Types of I/O for bmap clustering and I/O completion tracking.
+ *
+ * This enum is used in string mapping in xfs_trace.h; please keep the
+ * TRACE_DEFINE_ENUMs for it up to date.
  */
 enum {
 	XFS_IO_HOLE,		/* covers region without any block allocation */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cabe5c8010b0..deac0b3e64c2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -640,6 +640,16 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
 
+/*
+ * ftrace's __print_symbolic requires that all enum values be wrapped in the
+ * TRACE_DEFINE_ENUM macro so that the enum value can be encoded in the ftrace
+ * ring buffer.  Somehow this was only worth mentioning in the ftrace sample
+ * code.
+ */
+TRACE_DEFINE_ENUM(PE_SIZE_PTE);
+TRACE_DEFINE_ENUM(PE_SIZE_PMD);
+TRACE_DEFINE_ENUM(PE_SIZE_PUD);
+
 TRACE_EVENT(xfs_filemap_fault,
 	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
 		 bool write_fault),
@@ -1208,6 +1218,12 @@ DEFINE_EVENT(xfs_readpage_class, name,	\
 DEFINE_READPAGE_EVENT(xfs_vm_readpage);
 DEFINE_READPAGE_EVENT(xfs_vm_readpages);
 
+TRACE_DEFINE_ENUM(XFS_IO_HOLE);
+TRACE_DEFINE_ENUM(XFS_IO_DELALLOC);
+TRACE_DEFINE_ENUM(XFS_IO_UNWRITTEN);
+TRACE_DEFINE_ENUM(XFS_IO_OVERWRITE);
+TRACE_DEFINE_ENUM(XFS_IO_COW);
+
 DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
 		 int type, struct xfs_bmbt_irec *irec),
@@ -2610,6 +2626,9 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 #define DEFINE_AG_EXTENT_EVENT(name) DEFINE_DISCARD_EVENT(name)
 
 /* ag btree lookup tracepoint class */
+TRACE_DEFINE_ENUM(XFS_LOOKUP_EQi);
+TRACE_DEFINE_ENUM(XFS_LOOKUP_LEi);
+TRACE_DEFINE_ENUM(XFS_LOOKUP_GEi);
 #define XFS_AG_BTREE_CMP_FORMAT_STR \
 	{ XFS_LOOKUP_EQ,	"eq" }, \
 	{ XFS_LOOKUP_LE,	"le" }, \
