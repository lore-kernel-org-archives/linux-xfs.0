Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AE1C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2FC92064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z/BQjmMu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgAABJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48622 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xDo091251
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=stQ7EBXTkayRr6lZsbEuhjOMule4++zBcsx86DiYues=;
 b=Z/BQjmMu7sewTYA8wr4JHw8Lw4zdOKsk6+xplojx21C7EZYozl1lKafCAUmVoc4uSoVq
 SGWmJUI6ATHT8okeQ8uzW6aRyu8+fbDyhe64vO1YY4KRg6o48jfbP2C5MM0Mr1HcX2Db
 Vd9raaxPzfZh0QU2MBlJoCsvrm6eonSCBQ6J8l45aB+/tamLM4DNdVmtH9V2AH3lDF4x
 AhveCiWrw3bPoGJW2b1gDR+1xbiQpU2Zb10Jsj6ySMB3Mhr5PIK3OEqJi2tZNdr8NS8U
 hT+gJY+EvC/5QB63RDpdGaD0vhLGGhKrl6clabJ85YdwvqfqRPIvjoYHWvf0WZ+YujJr Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vqo172064
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x8gj915ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00118dIP010856
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:39 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:39 -0800
Subject: [PATCH 6/6] xfs: parallelize block preallocation garbage collection
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:35 -0800
Message-ID: <157784091539.1361683.10265501485703077036.stgit@magnolia>
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

Split the block preallocation garbage collection work into per-AG work
items so that we can take advantage of parallelization.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   51 +++++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_mount.c  |    3 +++
 fs/xfs/xfs_mount.h  |    5 +++--
 fs/xfs/xfs_super.c  |   25 +++++++++++++++++++++++--
 4 files changed, 68 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 622fdd747099..1a09d4854266 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -963,12 +963,12 @@ xfs_ici_walk_all(
  */
 static void
 xfs_queue_blockgc(
-	struct xfs_mount	*mp)
+	struct xfs_perag	*pag)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
-		queue_delayed_work(mp->m_blockgc_workqueue,
-				   &mp->m_blockgc_work,
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCK_GC_TAG))
+		queue_delayed_work(pag->pag_mount->m_blockgc_workqueue,
+				   &pag->pag_blockgc_work,
 				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
 }
@@ -988,6 +988,16 @@ xfs_blockgc_scan_inode(
 	return xfs_inode_free_cowblocks(ip, args);
 }
 
+/* Scan an AG's inodes for block preallocations that we can remove. */
+static int
+xfs_blockgc_scan_pag(
+	struct xfs_perag	*pag,
+	struct xfs_eofblocks	*eofb)
+{
+	return xfs_ici_walk_ag(pag->pag_mount, pag, xfs_blockgc_scan_inode,
+			eofb, XFS_ICI_BLOCK_GC_TAG, 0);
+}
+
 /* Scan all incore inodes for block preallocations that we can remove. */
 static inline int
 xfs_blockgc_scan(
@@ -1003,22 +1013,35 @@ void
 xfs_blockgc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_blockgc_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_blockgc_work);
 	int			error;
 
-	error = xfs_blockgc_scan(mp, NULL);
+	error = xfs_blockgc_scan_pag(pag, NULL);
 	if (error)
-		xfs_info(mp, "preallocation gc worker failed, err=%d", error);
-	xfs_queue_blockgc(mp);
+		xfs_info(pag->pag_mount,
+				"AG %u preallocation gc worker failed, err=%d",
+				pag->pag_agno, error);
+	xfs_queue_blockgc(pag);
 }
 
+#define for_each_perag_tag(mp, next_agno, pag, tag) \
+	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+	     (pag) != NULL; \
+	     (next_agno) = (pag)->pag_agno + 1, \
+	     xfs_perag_put(pag), \
+	     (pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
+
 /* Disable post-EOF and CoW block auto-reclamation. */
 void
 xfs_blockgc_stop(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_blockgc_work);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCK_GC_TAG)
+		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1026,7 +1049,11 @@ void
 xfs_blockgc_start(
 	struct xfs_mount	*mp)
 {
-	xfs_queue_blockgc(mp);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCK_GC_TAG)
+		xfs_queue_blockgc(pag);
 }
 
 /*
@@ -1666,7 +1693,7 @@ __xfs_inode_set_blocks_tag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
-		xfs_queue_blockgc(ip->i_mount);
+		xfs_queue_blockgc(pag);
 
 		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
 				_RET_IP_);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 626c62bbe8d6..ea74bd3be0bf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -126,6 +126,7 @@ __xfs_free_perag(
 {
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
+	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -146,6 +147,7 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		mutex_destroy(&pag->pag_ici_reclaim_lock);
@@ -201,6 +203,7 @@ xfs_initialize_perag(
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
+		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		if (xfs_buf_hash_init(pag))
 			goto out_free_pag;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bf05b57bc128..296223c2b782 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -155,8 +155,6 @@ typedef struct xfs_mount {
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_blockgc_work; /* background prealloc blocks
-						     trimming */
 	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
@@ -355,6 +353,9 @@ typedef struct xfs_perag {
 	/* Blocks reserved for the reverse mapping btree. */
 	struct xfs_ag_resv	pag_rmapbt_resv;
 
+	/* background prealloc block trimming */
+	struct delayed_work	pag_blockgc_work;
+
 	/* reference count */
 	uint8_t			pagf_refcount_level;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e734a2a663ac..03d95bf0952c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -510,7 +510,8 @@ xfs_init_mount_workqueues(
 		goto out_destroy_cil;
 
 	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
+			mp->m_super->s_id);
 	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
 
@@ -1372,6 +1373,25 @@ xfs_fc_validate_params(
 	return 0;
 }
 
+/*
+ * Constrain the number of threads that we start for background work.  This
+ * is the estimated parallelism of the filesystem capped to the unbound work
+ * queue maximum.
+ *
+ * We can't set this when we allocate the workqueues because the thread count
+ * derives from AG count, and we can't know that until we're far enough through
+ * setup to read the superblock, which requires functioning workqueues.
+ */
+static inline void
+xfs_configure_background_workqueues(
+	struct xfs_mount	*mp)
+{
+	unsigned int		max_active = xfs_guess_metadata_threads(mp);
+
+	max_active = min_t(unsigned int, max_active, WQ_UNBOUND_MAX_ACTIVE);
+	workqueue_set_max_active(mp->m_blockgc_workqueue, max_active);
+}
+
 static int
 xfs_fc_fill_super(
 	struct super_block	*sb,
@@ -1437,6 +1457,8 @@ xfs_fc_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	xfs_configure_background_workqueues(mp);
+
 	error = xfs_setup_devices(mp);
 	if (error)
 		goto out_free_sb;
@@ -1768,7 +1790,6 @@ static int xfs_init_fs_context(
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_blockgc_work, xfs_blockgc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

