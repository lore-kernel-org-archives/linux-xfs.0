Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18626C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D537A206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FS6MXURp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:10:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:10:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119iCS089415
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=klQCh5+ucwyhQAeqp6cfUlnZ7kdPovPae5iLUjYBu9s=;
 b=FS6MXURpHK+9pj0NIrk1VcPAy3XrjHHnDfVikrNn7tY/5FDYvR2ixGAdWwXceYffduau
 jAZCD9m8Hrfiu3C7PYCe02vqqgYfsSKgBI/l+BknoTsVaV8n+OH/nK4gFj1GOJIuL/55
 PmxH+H3/xg2lfy5Orx7W+UqWzpiSYKy8wm0HWPoa6bzfj7cges9wPo3o29BlB8Qa2se1
 qlZ9R+/iQ6gJeFG5L3vhF0qFq+TJKChDRg9TU++VVZSaRmT+oxYfxtvPdud5Syk+Yxo5
 oyVHkYc/OMCzXSWzqFszKWXAudiS4dZTgZX32TDb4jMa6egtdn1BnvmyiiIpFjrjuwGO TA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vS1045375
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medfbuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011AHXt011431
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:17 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:17 -0800
Subject: [PATCH 1/5] xfs: introduce online scrub freeze
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:15 -0800
Message-ID: <157784101517.1364003.5910967632575916795.stgit@magnolia>
In-Reply-To: <157784100871.1364003.10658176827446969836.stgit@magnolia>
References: <157784100871.1364003.10658176827446969836.stgit@magnolia>
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

Introduce a new 'online scrub freeze' that we can use to lock out all
filesystem modifications and background activity so that we can perform
global scans in order to rebuild metadata.  This introduces a new IFLAG
to the scrub ioctl to indicate that userspace is willing to allow a
freeze.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    6 +++
 fs/xfs/scrub/common.c  |   89 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/scrub.c   |    7 ++++
 fs/xfs/scrub/scrub.h   |    1 +
 fs/xfs/xfs_mount.h     |    7 ++++
 fs/xfs/xfs_super.c     |   47 +++++++++++++++++++++++++
 fs/xfs/xfs_trans.c     |    5 ++-
 8 files changed, 160 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 121c520189b9..40bdea01eff4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -717,7 +717,11 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1 << 7)
 
-#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
+/* i: Allow scrub to freeze the filesystem to perform global scans. */
+#define XFS_SCRUB_IFLAG_FREEZE_OK	(1 << 8)
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR | \
+				 XFS_SCRUB_IFLAG_FREEZE_OK)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
 				 XFS_SCRUB_OFLAG_PREEN | \
 				 XFS_SCRUB_OFLAG_XFAIL | \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 402d42a277f4..71f49f2478d7 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -601,9 +601,13 @@ xchk_trans_alloc(
 	struct xfs_scrub	*sc,
 	uint			resblks)
 {
+	uint			flags = 0;
+
+	if (sc->flags & XCHK_FS_FROZEN)
+		flags |= XFS_TRANS_NO_WRITECOUNT;
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
-				resblks, 0, 0, &sc->tp);
+				resblks, 0, flags, &sc->tp);
 
 	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
 }
@@ -922,3 +926,86 @@ xchk_start_reaping(
 	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
+
+/*
+ * Exclusive Filesystem Access During Scrub and Repair
+ * ===================================================
+ *
+ * While most scrub activity can occur while the filesystem is live, there
+ * are certain scenarios where we cannot tolerate concurrent metadata updates.
+ * We therefore must freeze the filesystem against all other changes.
+ *
+ * The typical scenarios envisioned for scrub freezes are (a) to lock out all
+ * other filesystem changes in order to check the global summary counters,
+ * and anything else that requires unusual behavioral semantics.
+ *
+ * The typical scenarios envisioned for repair freezes are (a) to avoid ABBA
+ * deadlocks when need to take locks in an unusual order; or (b) to update
+ * global filesystem state.  For example, reconstruction of a damaged reverse
+ * mapping btree requires us to hold the AG header locks while scanning
+ * inodes, which goes against the usual inode -> AG header locking order.
+ *
+ * A note about inode reclaim: when we freeze the filesystem, users can't
+ * modify things and periodic background reclaim of speculative preallocations
+ * and copy-on-write staging extents is stopped.  However, the scrub/repair
+ * thread must be careful about evicting an inode from memory -- if the
+ * eviction would require a transaction, we must defer the iput until after
+ * the scrub freeze.  The reasons for this are twofold: first, scrub/repair
+ * already have a transaction and xfs can't nest transactions; and second, we
+ * froze the fs to prevent modifications that we can't control directly.
+ * This guarantee is made by freezing the inode inactivation worker while
+ * frozen.
+ *
+ * Userspace is prevented from freezing or thawing the filesystem during a
+ * repair freeze by the ->freeze_super and ->thaw_super superblock operations,
+ * which block any changes to the freeze state while a repair freeze is
+ * running through the use of the m_scrub_freeze mutex.  It only makes sense
+ * to run one scrub/repair freeze at a time, so the mutex is fine.
+ *
+ * Scrub/repair freezes cannot be initiated during a regular freeze because
+ * freeze_super does not allow nested freeze.  Repair activity that does not
+ * require a repair freeze is also prevented from running during a regular
+ * freeze because transaction allocation blocks on the regular freeze.  We
+ * assume that the only other users of XFS_TRANS_NO_WRITECOUNT transactions
+ * either aren't modifying space metadata in a way that would affect repair,
+ * or that we can inhibit any of the ones that do.
+ *
+ * Note that thaw_super and freeze_super can call deactivate_locked_super
+ * which can free the xfs_mount.  This can happen if someone freezes the block
+ * device, unmounts the filesystem, and thaws the block device.  Therefore, we
+ * must be careful about who gets to unlock the repair freeze mutex.  See the
+ * comments in xfs_fs_put_super.
+ */
+
+/* Start a scrub/repair freeze. */
+int
+xchk_fs_freeze(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_FREEZE_OK))
+		return -EUSERS;
+
+	mutex_lock(&sc->mp->m_scrub_freeze);
+	error = freeze_super(sc->mp->m_super);
+	if (error) {
+		mutex_unlock(&sc->mp->m_scrub_freeze);
+		return error;
+	}
+	sc->flags |= XCHK_FS_FROZEN;
+	return 0;
+}
+
+/* Release a scrub/repair freeze. */
+int
+xchk_fs_thaw(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	sc->flags &= ~XCHK_FS_FROZEN;
+	error = thaw_super(sc->mp->m_super);
+	mutex_unlock(&sc->mp->m_scrub_freeze);
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b8a5a408c267..93b52869daae 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -148,6 +148,8 @@ int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 void xchk_stop_reaping(struct xfs_scrub *sc);
 void xchk_start_reaping(struct xfs_scrub *sc);
+int xchk_fs_freeze(struct xfs_scrub *sc);
+int xchk_fs_thaw(struct xfs_scrub *sc);
 
 /* Do we need to invoke the repair tool? */
 static inline bool xfs_scrub_needs_repair(struct xfs_scrub_metadata *sm)
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ff0b9c8d3de7..37ed41c05e88 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -152,6 +152,8 @@ xchk_teardown(
 	struct xfs_inode	*ip_in,
 	int			error)
 {
+	int				err2;
+
 	xchk_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -168,6 +170,11 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
+	if (sc->flags & XCHK_FS_FROZEN) {
+		err2 = xchk_fs_thaw(sc);
+		if (!error && err2)
+			error = err2;
+	}
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 99c4a3021284..f96fd11eceb1 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -89,6 +89,7 @@ struct xfs_scrub {
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
 #define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
+#define XCHK_FS_FROZEN		(1 << 3)  /* we froze the fs to do things */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 237a15a136c8..579b6d7c3c75 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -212,6 +212,13 @@ typedef struct xfs_mount {
 	 * inactivating all the inodes.
 	 */
 	struct wait_queue_head	m_inactive_wait;
+
+	/*
+	 * Only allow one thread to initiate a repair freeze at a time.  We
+	 * also use this to block userspace from changing the freeze state
+	 * while a repair freeze is in progress.
+	 */
+	struct mutex		m_scrub_freeze;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index af1fe32247cf..e3dbe7344982 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -761,6 +761,21 @@ xfs_mount_free(
 {
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
+
+	/*
+	 * fs freeze takes an active reference to the filesystem and fs thaw
+	 * drops it.  If a filesystem on a frozen (dm) block device is
+	 * unmounted before the block device is thawed, we can end up tearing
+	 * down the super from within thaw_super when the device is thawed.
+	 * xfs_fs_thaw_super grabbed the scrub repair mutex before calling
+	 * thaw_super, so we must avoid freeing a locked mutex.  At this point
+	 * we know we're the only user of the filesystem, so we can safely
+	 * unlock the scrub/repair mutex if it's still locked.
+	 */
+	if (mutex_is_locked(&mp->m_scrub_freeze))
+		mutex_unlock(&mp->m_scrub_freeze);
+
+	mutex_destroy(&mp->m_scrub_freeze);
 	kmem_free(mp);
 }
 
@@ -963,13 +978,41 @@ xfs_fs_unfreeze(
 /*
  * Before we get to stage 1 of a freeze, force all the inactivation work so
  * that there's less work to do if we crash during the freeze.
+ *
+ * Don't let userspace freeze while scrub has the filesystem frozen.  Note
+ * that freeze_super can free the xfs_mount, so we must be careful to recheck
+ * XFS_M before trying to access anything in the xfs_mount afterwards.
  */
 STATIC int
 xfs_fs_freeze_super(
 	struct super_block	*sb)
 {
+	int			error;
+
 	xfs_inactive_force(XFS_M(sb));
-	return freeze_super(sb);
+	mutex_lock(&XFS_M(sb)->m_scrub_freeze);
+	error = freeze_super(sb);
+	if (XFS_M(sb))
+		mutex_unlock(&XFS_M(sb)->m_scrub_freeze);
+	return error;
+}
+
+/*
+ * Don't let userspace thaw while scrub has the filesystem frozen.  Note that
+ * thaw_super can free the xfs_mount, so we must be careful to recheck XFS_M
+ * before trying to access anything in the xfs_mount afterwards.
+ */
+STATIC int
+xfs_fs_thaw_super(
+	struct super_block	*sb)
+{
+	int			error;
+
+	mutex_lock(&XFS_M(sb)->m_scrub_freeze);
+	error = thaw_super(sb);
+	if (XFS_M(sb))
+		mutex_unlock(&XFS_M(sb)->m_scrub_freeze);
+	return error;
 }
 
 /*
@@ -1172,6 +1215,7 @@ static const struct super_operations xfs_super_operations = {
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.freeze_super		= xfs_fs_freeze_super,
+	.thaw_super		= xfs_fs_thaw_super,
 };
 
 static int
@@ -1855,6 +1899,7 @@ static int xfs_init_fs_context(
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
+	mutex_init(&mp->m_scrub_freeze);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3a0e0a6d1a0d..4a19aec1886f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -323,9 +323,12 @@ xfs_trans_alloc(
 
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
-	 * they're allowed to run while we're frozen.
+	 * they're allowed to run while we're frozen.  Scrub is allowed to
+	 * freeze the filesystem in order to obtain exclusive access to the
+	 * filesystem.
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
+	        !mutex_is_locked(&mp->m_scrub_freeze) &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	atomic_inc(&mp->m_active_trans);
 

