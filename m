Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089C9C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7CDD2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cPTSSQ9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgAABJm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABJm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119eg9091654
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4AkJxBoM3op4qhuSPnGb328kKxkTM0LbeYU+cPgC97s=;
 b=cPTSSQ9pEkP8kj1L+rn8jMt5Kj6B3hnpvarey425jGdRr7nSPuBVGIwItBQd9rJzgsgK
 xEH0O+nCcvjn3mZ6SO9pKPWSErlYt39jKniWplew8vlIgJibtSbQcY4DMiGchf5LS2P+
 SCw87A4eJMGrc9E9/hid3qNGJteuCzjVcyHZGVcKNc+OvoDsjzZLtHavYOhsfZMJ9vIK
 Z/R/D65Z9X2t/aQzkhqZhrmExRmnPK8vwLzaf9mStKNU5e2H6KvE9DEACzrPDwpr0KnP
 e4XSHZLfKtFOI1JzXfLK/wobzctklO0zbLTOeS2Ouot8Xjos48NEHRkY/nCP/4b2jbQ9 qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uv8190222
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrfyun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:40 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00119dWP031590
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:39 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:39 -0800
Subject: [PATCH 09/10] xfs: parallelize inode inactivation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:36 -0800
Message-ID: <157784097668.1362752.16785191645786207862.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
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

Split the inode inactivation work into per-AG work items so that we can
take advantage of parallelization.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |    2 +
 fs/xfs/xfs_icache.c   |   90 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_icache.h   |    2 +
 fs/xfs/xfs_mount.c    |    3 ++
 fs/xfs/xfs_mount.h    |    4 ++
 fs/xfs/xfs_super.c    |    5 ++-
 6 files changed, 90 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 52fc05ee7ef8..402d42a277f4 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -910,6 +910,7 @@ xchk_stop_reaping(
 {
 	sc->flags |= XCHK_REAPING_DISABLED;
 	xfs_blockgc_stop(sc->mp);
+	xfs_inactive_cancel_work(sc->mp);
 }
 
 /* Restart background reaping of resources. */
@@ -917,6 +918,7 @@ void
 xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
+	xfs_inactive_schedule_now(sc->mp);
 	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 13b318dc2e89..5240e9e517d7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2130,12 +2130,12 @@ xfs_inode_clear_cowblocks_tag(
 /* Queue a new inode inactivation pass if there are reclaimable inodes. */
 static void
 xfs_inactive_work_queue(
-	struct xfs_mount        *mp)
+	struct xfs_perag	*pag)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INACTIVE_TAG))
-		queue_delayed_work(mp->m_inactive_workqueue,
-				&mp->m_inactive_work,
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INACTIVE_TAG))
+		queue_delayed_work(pag->pag_mount->m_inactive_workqueue,
+				&pag->pag_inactive_work,
 				msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
 	rcu_read_unlock();
 }
@@ -2158,7 +2158,7 @@ xfs_perag_set_inactive_tag(
 	spin_unlock(&mp->m_perag_lock);
 
 	/* schedule periodic background inode inactivation */
-	xfs_inactive_work_queue(mp);
+	xfs_inactive_work_queue(pag);
 
 	trace_xfs_perag_set_inactive(mp, pag->pag_agno, -1, _RET_IP_);
 }
@@ -2275,6 +2275,19 @@ static const struct xfs_ici_walk_ops	xfs_inactive_iwalk_ops = {
 	.iwalk		= xfs_inactive_inode,
 };
 
+/*
+ * Inactivate the inodes in an AG. Even if the filesystem is corrupted, we
+ * still need to clear the INACTIVE iflag so that we can move on to reclaiming
+ * the inode.
+ */
+static int
+xfs_inactive_inodes_pag(
+	struct xfs_perag	*pag)
+{
+	return xfs_ici_walk_ag(pag, &xfs_inactive_iwalk_ops, 0, NULL,
+			XFS_ICI_INACTIVE_TAG);
+}
+
 /*
  * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
  * corrupted, we still need to clear the INACTIVE iflag so that we can move
@@ -2294,8 +2307,9 @@ void
 xfs_inactive_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_inactive_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_inactive_work);
+	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
 	/*
@@ -2310,12 +2324,31 @@ xfs_inactive_worker(
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
 
-	error = xfs_inactive_inodes(mp, NULL);
+	error = xfs_inactive_inodes_pag(pag);
 	if (error && error != -EAGAIN)
 		xfs_err(mp, "inode inactivation failed, error %d", error);
 
 	sb_end_write(mp->m_super);
-	xfs_inactive_work_queue(mp);
+	xfs_inactive_work_queue(pag);
+}
+
+/* Wait for all background inactivation work to finish. */
+static void
+xfs_inactive_flush(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG) {
+		bool		flush;
+
+		spin_lock(&pag->pag_ici_lock);
+		flush = pag->pag_ici_inactive > 0;
+		spin_unlock(&pag->pag_ici_lock);
+		if (flush)
+			flush_delayed_work(&pag->pag_inactive_work);
+	}
 }
 
 /* Flush all inode inactivation work that might be queued. */
@@ -2323,8 +2356,8 @@ void
 xfs_inactive_force(
 	struct xfs_mount	*mp)
 {
-	queue_delayed_work(mp->m_inactive_workqueue, &mp->m_inactive_work, 0);
-	flush_delayed_work(&mp->m_inactive_work);
+	xfs_inactive_schedule_now(mp);
+	xfs_inactive_flush(mp);
 }
 
 /*
@@ -2336,9 +2369,40 @@ void
 xfs_inactive_shutdown(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_inactive_work);
-	flush_workqueue(mp->m_inactive_workqueue);
+	xfs_inactive_cancel_work(mp);
 	xfs_inactive_inodes(mp, NULL);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
 }
+
+/* Cancel all queued inactivation work. */
+void
+xfs_inactive_cancel_work(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG)
+		cancel_delayed_work_sync(&pag->pag_inactive_work);
+	flush_workqueue(mp->m_inactive_workqueue);
+}
+
+/* Cancel all pending deferred inactivation work and reschedule it now. */
+void
+xfs_inactive_schedule_now(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG) {
+		spin_lock(&pag->pag_ici_lock);
+		if (pag->pag_ici_inactive) {
+			cancel_delayed_work(&pag->pag_inactive_work);
+			queue_delayed_work(mp->m_inactive_workqueue,
+					&pag->pag_inactive_work, 0);
+		}
+		spin_unlock(&pag->pag_ici_lock);
+	}
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d6e79e7b5d94..a82b473b88a2 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -86,5 +86,7 @@ void xfs_inactive_worker(struct work_struct *work);
 int xfs_inactive_inodes(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 void xfs_inactive_force(struct xfs_mount *mp);
 void xfs_inactive_shutdown(struct xfs_mount *mp);
+void xfs_inactive_cancel_work(struct xfs_mount *mp);
+void xfs_inactive_schedule_now(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 27729a8c8c12..b9b37eff4063 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -127,6 +127,7 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
+	ASSERT(!delayed_work_pending(&pag->pag_inactive_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -148,6 +149,7 @@ xfs_free_perag(
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+		cancel_delayed_work_sync(&pag->pag_inactive_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		mutex_destroy(&pag->pag_ici_reclaim_lock);
@@ -204,6 +206,7 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+		INIT_DELAYED_WORK(&pag->pag_inactive_work, xfs_inactive_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		if (xfs_buf_hash_init(pag))
 			goto out_free_pag;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 51f88b56bbbe..87a62b0543ec 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -162,7 +162,6 @@ typedef struct xfs_mount {
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_inactive_work; /* background inode inactive */
 	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
@@ -366,6 +365,9 @@ typedef struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
+	/* background inode inactivation */
+	struct delayed_work	pag_inactive_work;
+
 	/* reference count */
 	uint8_t			pagf_refcount_level;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 14c5d002c358..fced499ecdc9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -521,7 +521,8 @@ xfs_init_mount_workqueues(
 		goto out_destroy_eofb;
 
 	mp->m_inactive_workqueue = alloc_workqueue("xfs-inactive/%s",
-			WQ_MEM_RECLAIM | WQ_FREEZABLE, 0, mp->m_super->s_id);
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
+			mp->m_super->s_id);
 	if (!mp->m_inactive_workqueue)
 		goto out_destroy_sync;
 
@@ -1449,6 +1450,7 @@ xfs_configure_background_workqueues(
 
 	max_active = min_t(unsigned int, max_active, WQ_UNBOUND_MAX_ACTIVE);
 	workqueue_set_max_active(mp->m_blockgc_workqueue, max_active);
+	workqueue_set_max_active(mp->m_inactive_workqueue, max_active);
 }
 
 static int
@@ -1856,7 +1858,6 @@ static int xfs_init_fs_context(
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_inactive_work, xfs_inactive_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

