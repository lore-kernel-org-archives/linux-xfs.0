Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 394C229DF7
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 15:33:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1A9830404E
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:33:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yrHLeRvy6mDRu1Mc for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:33:37 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3LKXbR3010436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:33:37 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3LKXao6023374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:33:37 -0400
Message-ID: <535580A1.20806@redhat.com>
Date: Mon, 21 Apr 2014 15:33:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix Q_XQUOTARM ioctl
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
To: xfs-oss <xfs@oss.sgi.com>

The Q_XQUOTARM quotactl was not working properly, because
we weren't passing around proper flags.  The xfs_fs_set_xstate()
ioctl handler used the same flags for Q_XQUOTAON/OFF as
well as for Q_XQUOTARM, but Q_XQUOTAON/OFF look for
XFS_UQUOTA_ACCT, XFS_UQUOTA_ENFD, XFS_GQUOTA_ACCT etc,
i.e. quota type + state, while Q_XQUOTARM looks only for
the type of quota, i.e. XFS_DQ_USER, XFS_DQ_GROUP etc.

Unfortunately these flag spaces overlap a bit, so we
got semi-random results for Q_XQUOTARM; i.e. the value
for XFS_DQ_USER == XFS_UQUOTA_ACCT, etc.  yeargh.

Split out the flag conversion from userspace to kernelspace,
depending on the quotactl that is being executed; add 2 new
helpers to do this, so that we send the right flags to the
lower-level functions.

This has been broken more or less forever, AFAICT.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index af33caf..6f14b8f 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -66,19 +66,11 @@ xfs_fs_get_xstatev(
 	return -xfs_qm_scall_getqstatv(mp, fqs);
 }
 
+/* Convert quotactl flags to internal flags for Q_XQUOTAON/OFF */
 STATIC int
-xfs_fs_set_xstate(
-	struct super_block	*sb,
-	unsigned int		uflags,
-	int			op)
+xfs_qm_import_flags(unsigned int uflags)
 {
-	struct xfs_mount	*mp = XFS_M(sb);
-	unsigned int		flags = 0;
-
-	if (sb->s_flags & MS_RDONLY)
-		return -EROFS;
-	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
+	unsigned int flags = 0;
 
 	if (uflags & FS_QUOTA_UDQ_ACCT)
 		flags |= XFS_UQUOTA_ACCT;
@@ -93,16 +85,52 @@ xfs_fs_set_xstate(
 	if (uflags & FS_QUOTA_PDQ_ENFD)
 		flags |= XFS_PQUOTA_ENFD;
 
+	return flags;
+}
+
+/* Convert quotactl flags to internal flags for Q_XQUOTARM */
+STATIC int
+xfs_qm_import_qtype_flags(unsigned int uflags)
+{
+	unsigned int flags = 0;
+
+	if (uflags & FS_USER_QUOTA)
+		flags |= XFS_DQ_USER;
+	if (uflags & FS_GROUP_QUOTA)
+		flags |= XFS_DQ_GROUP;
+	if (uflags & FS_USER_QUOTA)
+		flags |= XFS_DQ_PROJ;
+
+	return flags;
+}
+
+STATIC int
+xfs_fs_set_xstate(
+	struct super_block	*sb,
+	unsigned int		uflags,
+	int			op)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+	unsigned int		flags;
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+
 	switch (op) {
 	case Q_XQUOTAON:
+		flags = xfs_qm_import_flags(uflags);
 		return -xfs_qm_scall_quotaon(mp, flags);
 	case Q_XQUOTAOFF:
 		if (!XFS_IS_QUOTA_ON(mp))
 			return -EINVAL;
+		flags = xfs_qm_import_flags(uflags);
 		return -xfs_qm_scall_quotaoff(mp, flags);
 	case Q_XQUOTARM:
 		if (XFS_IS_QUOTA_ON(mp))
 			return -EINVAL;
+		flags = xfs_qm_import_qtype_flags(uflags);
 		return -xfs_qm_scall_trunc_qfiles(mp, flags);
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
