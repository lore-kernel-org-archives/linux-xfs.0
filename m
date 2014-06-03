Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 282027F61
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:19:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9C1FAC004
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:19:14 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id x3QypP9VNLeS9Gqh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:19:13 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s539J7I2029155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:19:12 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539J62K014068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:19:07 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539J616016578 for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:19:06 GMT
Message-ID: <538D9307.7030308@oracle.com>
Date: Tue, 03 Jun 2014 17:19:03 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 10/10] xfs: mark xfs_qm_quotacheck as static
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

xfs_qm_quotacheck() is not used outside of xfs_qm.c.  Mark it static and
move it around in the file to avoid a forward declaration.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_qm.c | 189 ++++++++++++++++++++++++++++----------------------------
 fs/xfs/xfs_qm.h |   1 -
 2 files changed, 94 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6d26759..4a3ba18 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -221,100 +221,6 @@ xfs_qm_unmount(
 	}
 }
 
-
-/*
- * This is called from xfs_mountfs to start quotas and initialize all
- * necessary data structures like quotainfo.  This is also responsible for
- * running a quotacheck as necessary.  We are guaranteed that the superblock
- * is consistently read in at this point.
- *
- * If we fail here, the mount will continue with quota turned off. We don't
- * need to inidicate success or failure at all.
- */
-void
-xfs_qm_mount_quotas(
-	xfs_mount_t	*mp)
-{
-	int		error = 0;
-	uint		sbf;
-
-	/*
-	 * If quotas on realtime volumes is not supported, we disable
-	 * quotas immediately.
-	 */
-	if (mp->m_sb.sb_rextents) {
-		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
-		mp->m_qflags = 0;
-		goto write_changes;
-	}
-
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
-
-	/*
-	 * Allocate the quotainfo structure inside the mount struct, and
-	 * create quotainode(s), and change/rev superblock if necessary.
-	 */
-	error = xfs_qm_init_quotainfo(mp);
-	if (error) {
-		/*
-		 * We must turn off quotas.
-		 */
-		ASSERT(mp->m_quotainfo == NULL);
-		mp->m_qflags = 0;
-		goto write_changes;
-	}
-	/*
-	 * If any of the quotas are not consistent, do a quotacheck.
-	 */
-	if (XFS_QM_NEED_QUOTACHECK(mp)) {
-		error = xfs_qm_quotacheck(mp);
-		if (error) {
-			/* Quotacheck failed and disabled quotas. */
-			return;
-		}
-	}
-	/* 
-	 * If one type of quotas is off, then it will lose its
-	 * quotachecked status, since we won't be doing accounting for
-	 * that type anymore.
-	 */
-	if (!XFS_IS_UQUOTA_ON(mp))
-		mp->m_qflags &= ~XFS_UQUOTA_CHKD;
-	if (!XFS_IS_GQUOTA_ON(mp))
-		mp->m_qflags &= ~XFS_GQUOTA_CHKD;
-	if (!XFS_IS_PQUOTA_ON(mp))
-		mp->m_qflags &= ~XFS_PQUOTA_CHKD;
-
- write_changes:
-	/*
-	 * We actually don't have to acquire the m_sb_lock at all.
-	 * This can only be called from mount, and that's single threaded. XXX
-	 */
-	spin_lock(&mp->m_sb_lock);
-	sbf = mp->m_sb.sb_qflags;
-	mp->m_sb.sb_qflags = mp->m_qflags & XFS_MOUNT_QUOTA_ALL;
-	spin_unlock(&mp->m_sb_lock);
-
-	if (sbf != (mp->m_qflags & XFS_MOUNT_QUOTA_ALL)) {
-		if (xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS)) {
-			/*
-			 * We could only have been turning quotas off.
-			 * We aren't in very good shape actually because
-			 * the incore structures are convinced that quotas are
-			 * off, but the on disk superblock doesn't know that !
-			 */
-			ASSERT(!(XFS_IS_QUOTA_RUNNING(mp)));
-			xfs_alert(mp, "%s: Superblock update failed!",
-				__func__);
-		}
-	}
-
-	if (error) {
-		xfs_warn(mp, "Failed to initialize disk quotas.");
-		return;
-	}
-}
-
 /*
  * Called from the vfsops layer.
  */
@@ -1330,7 +1236,7 @@ out_unlock:
  * Walk thru all the filesystem inodes and construct a consistent view
  * of the disk quota world. If the quotacheck fails, disable quotas.
  */
-int
+STATIC int
 xfs_qm_quotacheck(
 	xfs_mount_t	*mp)
 {
@@ -1467,6 +1373,99 @@ xfs_qm_quotacheck(
 }
 
 /*
+ * This is called from xfs_mountfs to start quotas and initialize all
+ * necessary data structures like quotainfo.  This is also responsible for
+ * running a quotacheck as necessary.  We are guaranteed that the superblock
+ * is consistently read in at this point.
+ *
+ * If we fail here, the mount will continue with quota turned off. We don't
+ * need to inidicate success or failure at all.
+ */
+void
+xfs_qm_mount_quotas(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+	uint			sbf;
+
+	/*
+	 * If quotas on realtime volumes is not supported, we disable
+	 * quotas immediately.
+	 */
+	if (mp->m_sb.sb_rextents) {
+		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
+		mp->m_qflags = 0;
+		goto write_changes;
+	}
+
+	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+
+	/*
+	 * Allocate the quotainfo structure inside the mount struct, and
+	 * create quotainode(s), and change/rev superblock if necessary.
+	 */
+	error = xfs_qm_init_quotainfo(mp);
+	if (error) {
+		/*
+		 * We must turn off quotas.
+		 */
+		ASSERT(mp->m_quotainfo == NULL);
+		mp->m_qflags = 0;
+		goto write_changes;
+	}
+	/*
+	 * If any of the quotas are not consistent, do a quotacheck.
+	 */
+	if (XFS_QM_NEED_QUOTACHECK(mp)) {
+		error = xfs_qm_quotacheck(mp);
+		if (error) {
+			/* Quotacheck failed and disabled quotas. */
+			return;
+		}
+	}
+	/*
+	 * If one type of quotas is off, then it will lose its
+	 * quotachecked status, since we won't be doing accounting for
+	 * that type anymore.
+	 */
+	if (!XFS_IS_UQUOTA_ON(mp))
+		mp->m_qflags &= ~XFS_UQUOTA_CHKD;
+	if (!XFS_IS_GQUOTA_ON(mp))
+		mp->m_qflags &= ~XFS_GQUOTA_CHKD;
+	if (!XFS_IS_PQUOTA_ON(mp))
+		mp->m_qflags &= ~XFS_PQUOTA_CHKD;
+
+ write_changes:
+	/*
+	 * We actually don't have to acquire the m_sb_lock at all.
+	 * This can only be called from mount, and that's single threaded. XXX
+	 */
+	spin_lock(&mp->m_sb_lock);
+	sbf = mp->m_sb.sb_qflags;
+	mp->m_sb.sb_qflags = mp->m_qflags & XFS_MOUNT_QUOTA_ALL;
+	spin_unlock(&mp->m_sb_lock);
+
+	if (sbf != (mp->m_qflags & XFS_MOUNT_QUOTA_ALL)) {
+		if (xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS)) {
+			/*
+			 * We could only have been turning quotas off.
+			 * We aren't in very good shape actually because
+			 * the incore structures are convinced that quotas are
+			 * off, but the on disk superblock doesn't know that !
+			 */
+			ASSERT(!(XFS_IS_QUOTA_RUNNING(mp)));
+			xfs_alert(mp, "%s: Superblock update failed!",
+				__func__);
+		}
+	}
+
+	if (error) {
+		xfs_warn(mp, "Failed to initialize disk quotas.");
+		return;
+	}
+}
+
+/*
  * This is called after the superblock has been read in and we're ready to
  * iget the quota inodes.
  */
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 797fd46..3a07a93 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -157,7 +157,6 @@ struct xfs_dquot_acct {
 #define XFS_QM_RTBWARNLIMIT	5
 
 extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
-extern int		xfs_qm_quotacheck(struct xfs_mount *);
 extern int		xfs_qm_write_sb_changes(struct xfs_mount *, __int64_t);
 
 /* dquot stuff */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
