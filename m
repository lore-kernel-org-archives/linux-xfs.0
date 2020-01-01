Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6638C47409
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB76D20733
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iUsolnuj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xav109466
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=sz1KCbikLUY3j/lZ8ItJ7bEL5dy8rjVEL2500CMDL4Q=;
 b=iUsolnujxnZwqLaqi1EiJzfQ0IGusQ2b/B1Nhmwmerm11kG38ihSBh9QWVzBFVFyXy/K
 LqDytzQWIz4DLMucCq4vhunMJZib/FtbfTX86t/oulMEYhgOxm2PwzNeD2rf5Pensh7z
 PEN/NWlJ1CuZRUjwl2ZkZwfD90uzPtAOpT/e3gln5Ol+caWY8KM+YWRtUO5heOHL3KMx
 +eBvtWAc6lWcpoO4DGD0RciZt7p8GualKbZfOZobQYckWs0kjcMknwzaHIswKXqS+X+N
 UWP67HB8DcFzTw7qh+7yAj7S5tWYyRph9zFo4oWjN/W6YeGj7xs9zcHYg/y3pZ2LMfDA +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vDv190284
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrfy4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:58 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00118JmD027304
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:19 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:18 -0800
Subject: [PATCH 3/6] xfs: remove the separate cowblocks worker
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:16 -0800
Message-ID: <157784089644.1361683.7890861415824276394.stgit@magnolia>
In-Reply-To: <157784087594.1361683.5987233633798863051.stgit@magnolia>
References: <157784087594.1361683.5987233633798863051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the separate cowblocks work items and knob so that we can control
and run everything from a single blockgc work queue.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_globals.c |    7 ++---
 fs/xfs/xfs_icache.c  |   73 ++++++++++++++++----------------------------------
 fs/xfs/xfs_icache.h  |    5 +--
 fs/xfs/xfs_linux.h   |    3 +-
 fs/xfs/xfs_mount.h   |    6 +---
 fs/xfs/xfs_super.c   |   11 +++-----
 fs/xfs/xfs_sysctl.c  |   15 ++--------
 fs/xfs/xfs_sysctl.h  |    3 +-
 8 files changed, 39 insertions(+), 84 deletions(-)


diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 4e747384ad26..8c082acb42fe 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -8,8 +8,8 @@
 /*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
  * other XFS code uses these values.  Times are measured in centisecs (i.e.
- * 100ths of a second) with the exception of eofb_timer and cowb_timer, which
- * are measured in seconds.
+ * 100ths of a second) with the exception of blockgc_timer, which is measured
+ * in seconds.
  */
 xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
@@ -28,8 +28,7 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
-	.eofb_timer	= {	1,		300,		3600*24},
-	.cowb_timer	= {	1,		1800,		3600*24},
+	.blockgc_timer	= {	1,		300,		3600*24},
 };
 
 struct xfs_globals xfs_globals = {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 294143608813..133b88c6681b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -958,18 +958,18 @@ xfs_ici_walk_all(
 }
 
 /*
- * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
+ * Background scanning to trim preallocated space. This is queued based on the
+ * 'speculative_prealloc_lifetime' tunable (5m by default).
  */
-void
-xfs_queue_eofblocks(
-	struct xfs_mount *mp)
+static void
+xfs_queue_blockgc(
+	struct xfs_mount	*mp)
 {
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_eofblocks_work,
-				   msecs_to_jiffies(xfs_eofb_secs * 1000));
+		queue_delayed_work(mp->m_blockgc_workqueue,
+				   &mp->m_blockgc_work,
+				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
 }
 
@@ -988,41 +988,19 @@ xfs_blockgc_scan(
 	return xfs_icache_free_cowblocks(mp, eofb);
 }
 
+/* Background worker that trims preallocated space. */
 void
-xfs_eofblocks_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_eofblocks_work);
-	xfs_icache_free_eofblocks(mp, NULL);
-	xfs_queue_eofblocks(mp);
-}
-
-/*
- * Background scanning to trim preallocated CoW space. This is queued
- * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
- * (We'll just piggyback on the post-EOF prealloc space workqueue.)
- */
-void
-xfs_queue_cowblocks(
-	struct xfs_mount *mp)
+xfs_blockgc_worker(
+	struct work_struct	*work)
 {
-	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_cowblocks_work,
-				   msecs_to_jiffies(xfs_cowb_secs * 1000));
-	rcu_read_unlock();
-}
+	struct xfs_mount	*mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_blockgc_work);
+	int			error;
 
-void
-xfs_cowblocks_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_cowblocks_work);
-	xfs_icache_free_cowblocks(mp, NULL);
-	xfs_queue_cowblocks(mp);
+	error = xfs_blockgc_scan(mp, NULL);
+	if (error)
+		xfs_info(mp, "preallocation gc worker failed, err=%d", error);
+	xfs_queue_blockgc(mp);
 }
 
 /*
@@ -1628,7 +1606,6 @@ xfs_inode_free_blocks(
 static void
 __xfs_inode_set_blocks_tag(
 	struct xfs_inode	*ip,
-	void			(*execute)(struct xfs_mount *mp),
 	unsigned long		iflag)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1663,7 +1640,7 @@ __xfs_inode_set_blocks_tag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
-		execute(ip->i_mount);
+		xfs_queue_blockgc(ip->i_mount);
 
 		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
 				_RET_IP_);
@@ -1678,8 +1655,7 @@ xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_eofblocks_tag(ip);
-	return __xfs_inode_set_blocks_tag(ip, xfs_queue_eofblocks,
-			XFS_IEOFBLOCKS);
+	return __xfs_inode_set_blocks_tag(ip, XFS_IEOFBLOCKS);
 }
 
 static void
@@ -1837,8 +1813,7 @@ xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_cowblocks_tag(ip);
-	return __xfs_inode_set_blocks_tag(ip, xfs_queue_cowblocks,
-			XFS_ICOWBLOCKS);
+	return __xfs_inode_set_blocks_tag(ip, XFS_ICOWBLOCKS);
 }
 
 void
@@ -1854,8 +1829,7 @@ void
 xfs_stop_block_reaping(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_eofblocks_work);
-	cancel_delayed_work_sync(&mp->m_cowblocks_work);
+	cancel_delayed_work_sync(&mp->m_blockgc_work);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1863,6 +1837,5 @@ void
 xfs_start_block_reaping(
 	struct xfs_mount	*mp)
 {
-	xfs_queue_eofblocks(mp);
-	xfs_queue_cowblocks(mp);
+	xfs_queue_blockgc(mp);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 3bf3862e6a32..b155cffb9d77 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -63,14 +63,11 @@ int xfs_inode_free_blocks(struct xfs_mount *mp, bool sync);
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
-void xfs_eofblocks_worker(struct work_struct *);
-void xfs_queue_eofblocks(struct xfs_mount *);
+void xfs_blockgc_worker(struct work_struct *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
-void xfs_cowblocks_worker(struct work_struct *);
-void xfs_queue_cowblocks(struct xfs_mount *);
 
 int xfs_ici_walk_all(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, void *args),
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 8738bb03f253..c725ba78ace5 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -97,8 +97,7 @@ typedef __u32			xfs_nlink_t;
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
-#define xfs_eofb_secs		xfs_params.eofb_timer.val
-#define xfs_cowb_secs		xfs_params.cowb_timer.val
+#define xfs_blockgc_secs	xfs_params.blockgc_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e8a8fef307bf..bf05b57bc128 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -155,9 +155,7 @@ typedef struct xfs_mount {
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_eofblocks_work; /* background eof blocks
-						     trimming */
-	struct delayed_work	m_cowblocks_work; /* background cow blocks
+	struct delayed_work	m_blockgc_work; /* background prealloc blocks
 						     trimming */
 	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
@@ -172,7 +170,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct *m_eofblocks_workqueue;
+	struct workqueue_struct *m_blockgc_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 
 	/*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5c7eef1ac240..1092ee25a148 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -509,9 +509,9 @@ xfs_init_mount_workqueues(
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
-	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
+	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
 			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
-	if (!mp->m_eofblocks_workqueue)
+	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
@@ -522,7 +522,7 @@ xfs_init_mount_workqueues(
 	return 0;
 
 out_destroy_eofb:
-	destroy_workqueue(mp->m_eofblocks_workqueue);
+	destroy_workqueue(mp->m_blockgc_workqueue);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_cil:
@@ -540,7 +540,7 @@ xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	destroy_workqueue(mp->m_sync_workqueue);
-	destroy_workqueue(mp->m_eofblocks_workqueue);
+	destroy_workqueue(mp->m_blockgc_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
@@ -1768,8 +1768,7 @@ static int xfs_init_fs_context(
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
-	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
+	INIT_DELAYED_WORK(&mp->m_blockgc_work, xfs_blockgc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 31b3bdbd2eba..4e9474095421 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -162,21 +162,12 @@ static struct ctl_table xfs_table[] = {
 	},
 	{
 		.procname	= "speculative_prealloc_lifetime",
-		.data		= &xfs_params.eofb_timer.val,
+		.data		= &xfs_params.blockgc_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.eofb_timer.min,
-		.extra2		= &xfs_params.eofb_timer.max,
-	},
-	{
-		.procname	= "speculative_cow_prealloc_lifetime",
-		.data		= &xfs_params.cowb_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.cowb_timer.min,
-		.extra2		= &xfs_params.cowb_timer.max,
+		.extra1		= &xfs_params.blockgc_timer.min,
+		.extra2		= &xfs_params.blockgc_timer.max,
 	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index aecccceee4ca..c8ad129b42e7 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -35,8 +35,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
-	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
-	xfs_sysctl_val_t cowb_timer;	/* Interval between cowb scan wakeups */
+	xfs_sysctl_val_t blockgc_timer;	/* Interval between blockgc scans */
 } xfs_param_t;
 
 /*

