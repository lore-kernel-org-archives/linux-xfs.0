Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42186 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbfAACSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:18:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012FYGI019623
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:18:06 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pp0btp783-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:18:06 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012I6SG022350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:18:06 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012I5ke000973
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:18:06 GMT
Subject: [PATCH 12/12] xfs: wait for deferred inactivation when destroying
 unlinked inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:18:04 -0800
Message-ID: <154630908468.16693.4548983851684057794.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've constructed a mechanism to batch background inode
inactivation work, we actually want in some cases to throttle the amount
of backlog work that the frontend can generate.  We do this by making
destroy_inode wait for inactivation when we're deleting things, assuming
that deleted inodes are dropped and destroyed in process context and not
from fs reclaim.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h |   11 ++++
 fs/xfs/xfs_super.c  |   12 ++++
 fs/xfs/xfs_trace.h  |    2 +
 4 files changed, 180 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e1210beb9d0b..064c5de9dce3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1822,6 +1822,23 @@ xfs_inactive_force(
 	}
 }
 
+/* Flush all inode inactivation work that might be queued for this AG. */
+static void
+xfs_inactive_force_ag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(mp, agno);
+	if (xfs_pag_has_inactive(pag)) {
+		queue_delayed_work(mp->m_inactive_workqueue,
+				&pag->pag_inactive_work, 0);
+		flush_delayed_work(&pag->pag_inactive_work);
+	}
+	xfs_perag_put(pag);
+}
+
 /*
  * Flush all inode inactivation work that might be queued and make sure the
  * delayed work item is not queued.
@@ -1843,6 +1860,144 @@ xfs_inactive_deactivate(
 	xfs_inactive_inodes(mp, NULL);
 }
 
+/*
+ * Decide if this inode is a candidate for unlinked inactivation throttling.
+ * We have to decide this prior to setting the NEED_INACTIVE iflag because
+ * once we flag the inode for inactivation we can't access it any more.
+ */
+enum xfs_iwait
+xfs_iwait_check(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned long long	x;
+	unsigned long long	y;
+	bool			rt = XFS_IS_REALTIME_INODE(ip);
+
+	/*
+	 * Don't wait unless we're doing a deletion inactivation.  We assume
+	 * that unlinked inodes that lose all their refcount are dropped,
+	 * evicted, and destroyed immediately in the context of the unlink()ing
+	 * process.
+	 */
+	if (VFS_I(ip)->i_nlink > 0)
+		return XFS_IWAIT_NEVER;
+
+	/*
+	 * If we're being called from kswapd we're in background memory reclaim
+	 * context.  There's no point in making it wait for ondisk metadata
+	 * updates, which themselves require memory allocations.
+	 */
+	if (current->flags & PF_KSWAPD)
+		return XFS_IWAIT_NEVER;
+
+	/*
+	 * Always wait for directory removal so we clean up any files that
+	 * were in that directory.
+	 */
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		trace_xfs_inactive_iwait_all(ip);
+		return XFS_IWAIT_ALL;
+	}
+
+	/* Heavily fragmented files take a while to delete. */
+	x = XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) +
+	    XFS_IFORK_NEXTENTS(ip, XFS_ATTR_FORK) +
+	    XFS_IFORK_NEXTENTS(ip, XFS_COW_FORK);
+	y = rt ? 256 : 32 * mp->m_sb.sb_agcount;
+	if (x >= y) {
+		trace_xfs_inactive_iwait_inode(ip);
+		return XFS_IWAIT_INODE;
+	}
+
+	return XFS_IWAIT_UNDECIDED;
+}
+
+/*
+ * Wait for deferred inode inactivation of an unlinked inode being destroyed.
+ *
+ * The deferred inode inactivation mechanism provides for background batching
+ * of whatever on-disk metadata updates are necessary to free an inode and all
+ * the resources it holds.  In theory this should speed up deletion by enabling
+ * us to inactivate in inode number order.
+ *
+ * However, there are a few situations where we actually /want/ to throttle
+ * unlinking.  Specifically, if we're unlinking fragmented files or removing
+ * entire directory trees, we should wait instead of allowing an enormous
+ * processing backlog that causes update storms later.
+ *
+ * We will wait for inactivation to finish under the following circumstances:
+ *  - Removing a directory
+ *  - Removing a heavily fragmented file
+ *  - A large number of blocks could be freed by inactivation
+ *  - A large number of inodes could be freed by inactivation
+ */
+void
+xfs_inactive_wait(
+	struct xfs_mount	*mp,
+	enum xfs_iwait		iwait,
+	xfs_agnumber_t		agno)
+{
+	unsigned long long	x;
+	unsigned long long	y;
+
+	switch (iwait) {
+	case XFS_IWAIT_NEVER:
+		return;
+	case XFS_IWAIT_ALL:
+	case XFS_IWAIT_INODE:
+		goto wait;
+	default:
+		break;
+	}
+
+	iwait = XFS_IWAIT_ALL;
+
+	/* More than 1/4 of an AG space could be freed by inactivation. */
+	x = percpu_counter_read_positive(&mp->m_dinactive);
+	y = mp->m_sb.sb_agblocks / 4;
+	if (x >= y)
+		goto wait;
+
+	/* Less than 1/16 of the datadev is free. */
+	x = percpu_counter_read_positive(&mp->m_fdblocks);
+	y = mp->m_sb.sb_dblocks / 16;
+	if (x <= y)
+		goto wait;
+
+	/* More than 1/4 of the rtdev could be freed by inactivation. */
+	y = mp->m_sb.sb_rblocks;
+	if (y > 0) {
+		x = percpu_counter_read_positive(&mp->m_rinactive);
+		if (x >= y / 4)
+			goto wait;
+
+		/* Less than 1/16 of the rtdev is free. */
+		x = mp->m_sb.sb_frextents * mp->m_sb.sb_rextsize;
+		if (x <= y / 16)
+			goto wait;
+	}
+
+	/* A lot of inodes could be freed by inactivation. */
+	x = percpu_counter_read_positive(&mp->m_iinactive);
+	y = XFS_INODES_PER_CHUNK * 4 * (unsigned long long)mp->m_sb.sb_agcount;
+	if (x >= y)
+		goto wait;
+
+	return;
+wait:
+	switch (iwait) {
+	case XFS_IWAIT_ALL:
+		xfs_inactive_force(mp);
+		break;
+	case XFS_IWAIT_INODE:
+		xfs_inactive_force_ag(mp, agno);
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index fd4073debd6e..f9c917700ea5 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -128,4 +128,15 @@ void xfs_inactive_force(struct xfs_mount *mp);
 void xfs_inactive_deactivate(struct xfs_mount *mp);
 int xfs_inactive_free_quota(struct xfs_inode *ip);
 
+enum xfs_iwait {
+	XFS_IWAIT_NEVER = -1,
+	XFS_IWAIT_UNDECIDED,
+	XFS_IWAIT_ALL,
+	XFS_IWAIT_INODE,
+};
+
+enum xfs_iwait xfs_iwait_check(struct xfs_inode *ip);
+void xfs_inactive_wait(struct xfs_mount *mp, enum xfs_iwait decision,
+		       xfs_agnumber_t agno);
+
 #endif
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b7f37a87f187..1141413c53c0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -979,6 +979,8 @@ xfs_fs_destroy_inode(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	enum xfs_iwait		caniwait = XFS_IWAIT_NEVER;
 	bool			need_inactive;
 
 	trace_xfs_destroy_inode(ip);
@@ -991,6 +993,7 @@ xfs_fs_destroy_inode(
 	if (need_inactive) {
 		trace_xfs_inode_set_need_inactive(ip);
 		xfs_inode_inactivation_prep(ip);
+		caniwait = xfs_iwait_check(ip);
 	} else if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
 		xfs_check_delalloc(ip, XFS_COW_FORK);
@@ -1015,6 +1018,15 @@ xfs_fs_destroy_inode(
 	 * reclaim tear down all inodes.
 	 */
 	xfs_inode_set_reclaim_tag(ip, need_inactive);
+
+	/*
+	 * Wait for inactivation of this inode if the inode has zero nlink.
+	 * This cannot be done in fs reclaim context, which means we assume
+	 * that unlinked inodes that lose all their refcount are dropped,
+	 * evicted, and destroyed immediately in the context of the unlink()ing
+	 * process and are never fed to the LRU for reclaim.
+	 */
+	xfs_inactive_wait(mp, caniwait, agno);
 }
 
 static void
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d2e5e6a794b5..02683ec06164 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -646,6 +646,8 @@ DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
 DEFINE_INODE_EVENT(xfs_inode_reclaiming);
 DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
 DEFINE_INODE_EVENT(xfs_inode_inactivating);
+DEFINE_INODE_EVENT(xfs_inactive_iwait_all);
+DEFINE_INODE_EVENT(xfs_inactive_iwait_inode);
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
