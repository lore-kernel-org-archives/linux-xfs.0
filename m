Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95EEBwt053250 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:14:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pqqK6RcYHmrt3B1X for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:15:37 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EFbrP029143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q95EFbPR022123
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 10/10] xfs: add background scanning to clear eofblocks
	inodes
Date: Fri,  5 Oct 2012 10:17:16 -0400
Message-Id: <1349446636-8611-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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

Create a new mount workqueue and delayed_work to enable background
scanning and freeing of eofblocks inodes. The scanner kicks in once
speculative preallocation occurs and stops requeueing itself when
no eofblocks inodes exist.

The scan interval is based on the new
'background_prealloc_discard_period' tunable (default to 5m). The
background scanner performs unfiltered, best effort scans (which
skips inodes under lock contention or with a dirty cache mapping).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_globals.c |    1 +
 fs/xfs/xfs_icache.c  |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h  |    1 +
 fs/xfs/xfs_linux.h   |    1 +
 fs/xfs/xfs_mount.c   |    2 ++
 fs/xfs/xfs_mount.h   |    3 +++
 fs/xfs/xfs_super.c   |    9 +++++++++
 fs/xfs/xfs_sysctl.c  |    9 +++++++++
 fs/xfs/xfs_sysctl.h  |    1 +
 9 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 76e81cf..efea30a 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -40,4 +40,5 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
+	.eofb_timer	= {	1,		300,		7200},
 };
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ffd7f86..1ab560c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -615,6 +615,32 @@ restart:
 	return last_error;
 }
 
+/*
+ * Background scanning to trim post-EOF preallocated space. This is queued
+ * based on the 'background_prealloc_discard_period' tunable (5m by default).
+ */
+STATIC void
+xfs_queue_eofblocks(
+	struct xfs_mount *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+		queue_delayed_work(mp->m_eofblocks_workqueue,
+				   &mp->m_eofblocks_work,
+				   msecs_to_jiffies(xfs_eofb_secs * 1000));
+	rcu_read_unlock();
+}
+
+void
+xfs_eofblocks_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+				struct xfs_mount, m_eofblocks_work);
+	xfs_icache_free_eofblocks(mp, SYNC_TRYLOCK, NULL);
+	xfs_queue_eofblocks(mp);
+}
+
 int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
@@ -1268,6 +1294,9 @@ xfs_inode_set_eofblocks_tag(
 				   XFS_ICI_EOFBLOCKS_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
+		/* kick off background trimming */
+		xfs_queue_eofblocks(ip->i_mount);
+
 		trace_xfs_perag_set_eofblocks(ip->i_mount, pag->pag_agno,
 					      -1, _RET_IP_);
 	}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index b46716c..0089286 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -38,6 +38,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, int, struct xfs_eofblocks *);
+void xfs_eofblocks_worker(struct work_struct *);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 828662f..0a134ca 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -118,6 +118,7 @@
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
+#define xfs_eofb_secs		xfs_params.eofb_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6f1c997..41ae7e1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1428,6 +1428,8 @@ xfs_unmountfs(
 	__uint64_t		resblks;
 	int			error;
 
+	cancel_delayed_work_sync(&mp->m_eofblocks_work);
+
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
 	IRELE(mp->m_rootip);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a631ca3..dc306a0 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -196,6 +196,8 @@ typedef struct xfs_mount {
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct delayed_work	m_eofblocks_work; /* background eof blocks
+						     trimming */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
@@ -207,6 +209,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_log_workqueue;
+	struct workqueue_struct *m_eofblocks_workqueue;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5e6c5b8..e6b3083 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -874,8 +874,15 @@ xfs_init_mount_workqueues(
 	if (!mp->m_log_workqueue)
 		goto out_destroy_reclaim;
 
+	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
+			WQ_NON_REENTRANT, 0, mp->m_fsname);
+	if (!mp->m_eofblocks_workqueue)
+		goto out_destroy_log;
+
 	return 0;
 
+out_destroy_log:
+	destroy_workqueue(mp->m_log_workqueue);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_cil:
@@ -892,6 +899,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_eofblocks_workqueue);
 	destroy_workqueue(mp->m_log_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
@@ -1375,6 +1383,7 @@ xfs_fs_fill_super(
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index ee2d2ad..3136d45 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -202,6 +202,15 @@ static ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.fstrm_timer.min,
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
+	{
+		.procname	= "background_prealloc_discard_period",
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
