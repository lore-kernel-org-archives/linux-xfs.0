Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ECIJ9m092231 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 07:18:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YlU7ltDFkDUQ5ROe for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 05:19:26 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8ECJPPf002588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q8ECJP9K022250
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 8/8] xfs: add background scanning to clear EOFBLOCKS inodes
Date: Fri, 14 Sep 2012 08:19:55 -0400
Message-Id: <1347625195-6369-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
References: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
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
is based on the new eofb_timer tunable (default to 5m). The
background scanner performs unfiltered, best effort scans (which
skips inodes under lock contention or with a dirty cache mapping).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_globals.c |    1 +
 fs/xfs/xfs_linux.h   |    1 +
 fs/xfs/xfs_mount.h   |    2 ++
 fs/xfs/xfs_sync.c    |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysctl.c  |    9 +++++++++
 fs/xfs/xfs_sysctl.h  |    1 +
 6 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 76e81cf..fda9a66 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -40,4 +40,5 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
+	.eofb_timer	= {	1*100,		300*100,	7200*100},
 };
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 828662f..bbad99b 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -118,6 +118,7 @@
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
+#define xfs_eofb_centisecs	xfs_params.eofb_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index deee09e..bf5ecfa 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -199,6 +199,8 @@ typedef struct xfs_mount {
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_sync_work;	/* background sync work */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct delayed_work	m_eofblocks_work; /* background eof blocks
+						     trimming */
 	struct work_struct	m_flush_work;	/* background inode flush */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 13cd9da..778cf6a 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -532,6 +532,31 @@ xfs_flush_worker(
 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
 }
 
+/*
+ * Background scanning to trim post-EOF preallocated space. This is queued
+ * based on the 'eofb_centisecs' tunable (5m by default).
+ */
+STATIC void
+xfs_queue_eofblocks(
+	struct xfs_mount *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+		queue_delayed_work(xfs_syncd_wq, &mp->m_eofblocks_work,
+			msecs_to_jiffies(xfs_eofb_centisecs * 10));
+	rcu_read_unlock();
+}
+
+STATIC void
+xfs_eofblocks_worker(
+struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+				struct xfs_mount, m_eofblocks_work);
+	xfs_inodes_free_eofblocks(mp, SYNC_TRYLOCK, NULL);
+	xfs_queue_eofblocks(mp);
+}
+
 int
 xfs_syncd_init(
 	struct xfs_mount	*mp)
@@ -539,6 +564,7 @@ xfs_syncd_init(
 	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
 	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 
 	xfs_syncd_queue_sync(mp);
 
@@ -551,6 +577,7 @@ xfs_syncd_stop(
 {
 	cancel_delayed_work_sync(&mp->m_sync_work);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	cancel_delayed_work_sync(&mp->m_eofblocks_work);
 	cancel_work_sync(&mp->m_flush_work);
 }
 
@@ -1101,6 +1128,9 @@ xfs_inode_set_eofblocks_tag(
 				   XFS_ICI_EOFBLOCKS_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
+		/* kick off background trimming */
+		xfs_queue_eofblocks(ip->i_mount);
+
 		trace_xfs_perag_set_eofblocks(ip->i_mount, pag->pag_agno,
 					      -1, _RET_IP_);
 	}
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index ee2d2ad..45d74fc 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -202,6 +202,15 @@ static ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.fstrm_timer.min,
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
+	{
+		.procname	= "eofb_centisecs",
+		.data		= &xfs_params.eofb_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.eofb_timer.min,
+		.extra2		= &xfs_params.eofb_timer.max,
+	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
 	{
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index b9937d4..bd8e157 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -47,6 +47,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
+	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
 } xfs_param_t;
 
 /*
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
