Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55496 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfBDSAD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 13:00:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x14HnKj1039295
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 18:00:01 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qd97eppks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Feb 2019 18:00:01 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x14I00JY001913
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 18:00:00 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x14I00pu024508
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 18:00:00 GMT
Subject: [PATCH 09/10] xfs: add tracepoints for high level iunlink operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Feb 2019 09:59:58 -0800
Message-ID: <154930319873.31814.12430374692247625444.stgit@magnolia>
In-Reply-To: <154930313674.31814.17994684613232167921.stgit@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add tracepoints so we can associate high level operations with low level
updates.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    2 ++
 fs/xfs/xfs_trace.h |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fac9562ecd39..b9696d762c8f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2023,6 +2023,7 @@ xfs_iunlink(
 
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	pag = xfs_perag_get(mp, agno);
+	trace_xfs_iunlink(ip);
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
 	error = xfs_read_agi(mp, tp, agno, &agibp);
@@ -2188,6 +2189,7 @@ xfs_iunlink_remove(
 	int			error;
 
 	pag = xfs_perag_get(mp, agno);
+	trace_xfs_iunlink_remove(ip);
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
 	error = xfs_read_agi(mp, tp, agno, &agibp);
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
