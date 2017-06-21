Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49301 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdFUBLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 21:11:53 -0400
Subject: [PATCH 4/4] xfs: convert drop_writes to use the errortag mechanism
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Jun 2017 18:11:48 -0700
Message-ID: <149800750838.23118.17160603017676771034.stgit@birch.djwong.org>
In-Reply-To: <149800747210.23118.6423951814449227184.stgit@birch.djwong.org>
References: <149800747210.23118.6423951814449227184.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

We now have enhanced error injection that can control the frequency
with which errors happen, so convert drop_writes to use this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c |    3 +++
 fs/xfs/xfs_error.h |   14 +++++++++++++-
 fs/xfs/xfs_iomap.c |    2 +-
 fs/xfs/xfs_mount.h |   24 ------------------------
 fs/xfs/xfs_sysfs.c |   42 ------------------------------------------
 5 files changed, 17 insertions(+), 68 deletions(-)


diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 81f260f..40a15e2 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_REFCOUNT_FINISH_ONE,
 	XFS_RANDOM_BMAP_FINISH_ONE,
 	XFS_RANDOM_AG_RESV_CRITICAL,
+	XFS_RANDOM_DROP_WRITES,
 };
 
 struct xfs_errortag_attr {
@@ -157,6 +158,7 @@ XFS_ERRORTAG_ATTR_RW(refcount_continue_update,	XFS_ERRTAG_REFCOUNT_CONTINUE_UPDA
 XFS_ERRORTAG_ATTR_RW(refcount_finish_one,	XFS_ERRTAG_REFCOUNT_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
+XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -187,6 +189,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(refcount_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(bmap_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
+	XFS_ERRORTAG_ATTR_LIST(drop_writes),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 083a6fc..cd7881f 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -96,7 +96,18 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
-#define XFS_ERRTAG_MAX					28
+
+/*
+ * DEBUG mode instrumentation to test and/or trigger delayed allocation
+ * block killing in the event of failed writes. When enabled, all
+ * buffered writes are silenty dropped and handled as if they failed.
+ * All delalloc blocks in the range of the write (including pre-existing
+ * delalloc blocks!) are tossed as part of the write failure error
+ * handling sequence.
+ */
+#define XFS_ERRTAG_DROP_WRITES				28
+
+#define XFS_ERRTAG_MAX					29
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -129,6 +140,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
 #define XFS_RANDOM_BMAP_FINISH_ONE			1
 #define XFS_RANDOM_AG_RESV_CRITICAL			4
+#define XFS_RANDOM_DROP_WRITES				1
 
 #ifdef DEBUG
 extern int xfs_errortag_init(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 304b79d..86f1a9f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1097,7 +1097,7 @@ xfs_file_iomap_end_delalloc(
 	 * Behave as if the write failed if drop writes is enabled. Set the NEW
 	 * flag to force delalloc cleanup.
 	 */
-	if (xfs_mp_drop_writes(mp)) {
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DROP_WRITES)) {
 		iomap->flags |= IOMAP_F_NEW;
 		written = 0;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 931e9fc..e0792d0 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -205,16 +205,6 @@ typedef struct xfs_mount {
 	 */
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
-
-	/*
-	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
-	 * block killing in the event of failed writes. When enabled, all
-	 * buffered writes are silenty dropped and handled as if they failed.
-	 * All delalloc blocks in the range of the write (including pre-existing
-	 * delalloc blocks!) are tossed as part of the write failure error
-	 * handling sequence.
-	 */
-	bool			m_drop_writes;
 #endif
 } xfs_mount_t;
 
@@ -333,20 +323,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
 }
 
-#ifdef DEBUG
-static inline bool
-xfs_mp_drop_writes(struct xfs_mount *mp)
-{
-	return mp->m_drop_writes;
-}
-#else
-static inline bool
-xfs_mp_drop_writes(struct xfs_mount *mp)
-{
-	return 0;
-}
-#endif
-
 /* per-AG block reservation data structures*/
 enum xfs_ag_resv_type {
 	XFS_AG_RESV_NONE = 0,
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index b86148a..3e52662 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -90,49 +90,7 @@ to_mp(struct kobject *kobject)
 	return container_of(kobj, struct xfs_mount, m_kobj);
 }
 
-#ifdef DEBUG
-
-STATIC ssize_t
-drop_writes_store(
-	struct kobject		*kobject,
-	const char		*buf,
-	size_t			count)
-{
-	struct xfs_mount	*mp = to_mp(kobject);
-	int			ret;
-	int			val;
-
-	ret = kstrtoint(buf, 0, &val);
-	if (ret)
-		return ret;
-
-	if (val == 1)
-		mp->m_drop_writes = true;
-	else if (val == 0)
-		mp->m_drop_writes = false;
-	else
-		return -EINVAL;
-
-	return count;
-}
-
-STATIC ssize_t
-drop_writes_show(
-	struct kobject		*kobject,
-	char			*buf)
-{
-	struct xfs_mount	*mp = to_mp(kobject);
-
-	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_drop_writes ? 1 : 0);
-}
-XFS_SYSFS_ATTR_RW(drop_writes);
-
-#endif /* DEBUG */
-
 static struct attribute *xfs_mp_attrs[] = {
-#ifdef DEBUG
-	ATTR_LIST(drop_writes),
-#endif
 	NULL,
 };
 

