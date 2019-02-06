Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfBFQzn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 11:55:43 -0500
Subject: [PATCH 8/9] xfs: add tracepoints for high level iunlink operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 06 Feb 2019 08:55:30 -0800
Message-ID: <154947212991.22369.15293288136239645176.stgit@magnolia>
In-Reply-To: <154947207759.22369.11575570374120223292.stgit@magnolia>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add tracepoints so we can associate high level operations with low level
updates.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c |    3 +++
 fs/xfs/xfs_trace.h |   25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aeca536e3e75..53a9c8c26d18 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2047,6 +2047,7 @@ xfs_iunlink(
 	int			error;
 
 	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
 	error = xfs_read_agi(mp, tp, agno, &agibp);
@@ -2192,6 +2193,8 @@ xfs_iunlink_remove(
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
+	trace_xfs_iunlink_remove(ip);
+
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
 	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fbec8f0e1a9a..a6e384a642b1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3423,6 +3423,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		  __entry->new_ptr)
 );
 
+DECLARE_EVENT_CLASS(xfs_ag_inode_class,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+	),
+	TP_printk("dev %d:%d agno %u agino %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno, __entry->agino)
+)
+
+#define DEFINE_AGINODE_EVENT(name) \
+DEFINE_EVENT(xfs_ag_inode_class, name, \
+	TP_PROTO(struct xfs_inode *ip), \
+	TP_ARGS(ip))
+DEFINE_AGINODE_EVENT(xfs_iunlink);
+DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
