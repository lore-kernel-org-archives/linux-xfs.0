Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RJo1Nm237167 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 14:50:02 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LNhBy5lc1yEriim8 for
	<xfs@oss.sgi.com>; Mon, 27 Aug 2012 12:50:52 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7RJopxt029042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q7RJopfL032581
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 4/4] xfs: add background scanning to clear EOFBLOCKS inodes
Date: Mon, 27 Aug 2012 15:51:51 -0400
Message-Id: <1346097111-4476-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Create a delayed_work to enable background scanning and freeing
of EOFBLOCKS inodes. The scanner kicks in once speculative
preallocation occurs and stops requeueing itself when no EOFBLOCKS
inodes exist.

Scans are queued on the existing syncd workqueue and the interval
is tied to the syncd interval, which is a default of 30s. The
minimum file size for a background scan is hardcoded to 100MB.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.h |    2 ++
 fs/xfs/xfs_sync.c  |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h  |    3 +++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 05a05a7..a966bf4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -204,6 +204,8 @@ typedef struct xfs_mount {
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_sync_work;	/* background sync work */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct delayed_work	m_eofblocks_work; /* background eof blocks
+						     trimming */
 	struct work_struct	m_flush_work;	/* background inode flush */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 27c3c46..bd1ca90 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -489,6 +489,34 @@ xfs_flush_worker(
 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
 }
 
+/*
+ * Background scanning to trim post-EOF preallocated space. This is queued
+ * based on the syncd tunable (30s by default).
+ *
+ * TODO: Do we want an independent tunable (and default.. off by default)?
+ */
+STATIC void
+xfs_queue_eofblocks(
+	struct xfs_mount *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+		queue_delayed_work(xfs_syncd_wq, &mp->m_eofblocks_work,
+			msecs_to_jiffies(xfs_syncd_centisecs * 10));
+	rcu_read_unlock();
+}
+
+STATIC void
+xfs_eofblocks_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+				struct xfs_mount, m_eofblocks_work);
+	xfs_inodes_free_eofblocks(mp, XFS_DQ_PROJ, XFS_PROJID_DEFAULT,
+		XFS_EOFBLOCKS_DEFAULT_MINFILESIZE, 0);
+	xfs_queue_eofblocks(mp);
+}
+
 int
 xfs_syncd_init(
 	struct xfs_mount	*mp)
@@ -496,6 +524,7 @@ xfs_syncd_init(
 	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
 	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 
 	xfs_syncd_queue_sync(mp);
 
@@ -508,6 +537,7 @@ xfs_syncd_stop(
 {
 	cancel_delayed_work_sync(&mp->m_sync_work);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	cancel_delayed_work_sync(&mp->m_eofblocks_work);
 	cancel_work_sync(&mp->m_flush_work);
 }
 
@@ -1159,6 +1189,9 @@ __xfs_inode_set_eofblocks_tag(
 				   XFS_ICI_EOFBLOCKS_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
+		/* kick off background trimming */
+		xfs_queue_eofblocks(ip->i_mount);
+
 		trace_xfs_perag_set_eofblocks(ip->i_mount, pag->pag_agno,
 					      -1, _RET_IP_);
 	}
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 78aca41..3ce8c3f 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -45,6 +45,9 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 
 #define EOFBLOCKS_WAIT		0x0001
 
+/* TODO: should we have a tunable? */
+#define XFS_EOFBLOCKS_DEFAULT_MINFILESIZE 1024 * 1024 * 100
+
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_inodes_free_eofblocks(struct xfs_mount *, int, uint32_t, uint64_t, int);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
