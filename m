Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA6BfUDj255288 for <xfs@oss.sgi.com>; Sat, 6 Nov 2010 06:41:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B00DF1C1F455
	for <xfs@oss.sgi.com>; Sat,  6 Nov 2010 04:42:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cgZ88trW1ddywv2o for
	<xfs@oss.sgi.com>; Sat, 06 Nov 2010 04:42:56 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PEhAe-0006cS-9j
	for xfs@oss.sgi.com; Sat, 06 Nov 2010 11:42:56 +0000
Date: Sat, 6 Nov 2010 07:42:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: fix a few compiler warnings with CONFIG_XFS_QUOTA=n
Message-ID: <20101106114256.GC25395@infradead.org>
References: <20101106114226.GA25395@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101106114226.GA25395@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Andi Kleen reported that gcc-4.5 gives lots of warnings for him inside the
XFS code.  It turned out most of them are due to the quota stubs beeing
macros, and gcc now complaining about macros evaluating to 0 that are not
assigned to variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2010-11-02 13:59:34.388491017 -0400
+++ xfs/fs/xfs/xfs_quota.h	2010-11-02 14:06:14.308491018 -0400
@@ -346,8 +346,17 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip,
 #define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
-#define xfs_trans_reserve_quota_nblks(tp, ip, nblks, ninos, flags)	(0)
-#define xfs_trans_reserve_quota_bydquots(tp, mp, u, g, nb, ni, fl)	(0)
+static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
+		struct xfs_inode *ip, long nblks, long ninos, uint flags)
+{
+	return 0;
+}
+static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
+		struct xfs_mount *mp, struct xfs_dquot *udqp,
+		struct xfs_dquot *gdqp, long nblks, long nions, uint flags)
+{
+	return 0;
+}
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -357,11 +366,14 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip,
 #define xfs_qm_dqdetach(ip)
 #define xfs_qm_dqrele(d)
 #define xfs_qm_statvfs(ip, s)
-#define xfs_qm_sync(mp, fl)						(0)
+static inline int xfs_qm_sync(struct xfs_mount *mp, int flags)
+{
+	return 0;
+}
 #define xfs_qm_newmount(mp, a, b)					(0)
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
-#define xfs_qm_unmount_quotas(mp)					(0)
+#define xfs_qm_unmount_quotas(mp)
 #endif /* CONFIG_XFS_QUOTA */
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
