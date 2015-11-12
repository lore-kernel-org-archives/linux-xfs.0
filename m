Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4747C7F4E
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 20:09:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE156AC002
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:08:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ql00IiG8jmWvamcW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:08:50 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 72EBBC05E140
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 02:08:50 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAC28nX1025358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 21:08:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: print XFS_WANT_CORRUPTED info with -vvv
Message-ID: <5643F4B1.40500@redhat.com>
Date: Wed, 11 Nov 2015 20:08:49 -0600
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

In the kernel, the XFS_WANT_CORRUPTED_* macros print the
caller information via XFS_ERROR_REPORT, but in userspace
this is silenced, because i.e. xfs_repair's job is to find
and fix corruption, not to complain loudly about it.

However, there are times when we would like to know if
we've hit an unexpected corruption point.  To that end,
make "xfs_repair -vvv" enable noisiness from these macros,
so that they will print the function and line of the caller.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 5ec6866..67f3b05 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -143,6 +143,7 @@ typedef struct xfs_perag {
 #define LIBXFS_MOUNT_32BITINOOPT	0x0004
 #define LIBXFS_MOUNT_COMPAT_ATTR	0x0008
 #define LIBXFS_MOUNT_ATTR2		0x0010
+#define LIBXFS_MOUNT_WANT_CORRUPTED	0x0020
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9135aac..0f4d3e5 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -147,10 +147,25 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
 #define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
 #define XFS_TEST_ERROR(expr,a,b,c)	( expr )
-#define XFS_WANT_CORRUPTED_GOTO(mp, expr, l)	\
-		{ (mp) = (mp); if (!(expr)) { error = -EFSCORRUPTED; goto l; } }
-#define XFS_WANT_CORRUPTED_RETURN(mp, expr)	\
-		{ (mp) = (mp); if (!(expr)) { return -EFSCORRUPTED; } }
+#define XFS_WANT_CORRUPTED_GOTO(mp, expr, l)				\
+{									\
+	if (!(expr)) {							\
+		if ((mp)->m_flags & LIBXFS_MOUNT_WANT_CORRUPTED)	\
+			printf("WANT_CORRUPTED_GOTO at %s:%d\n",	\
+				__func__, __LINE__);			\
+		error = -EFSCORRUPTED;					\
+		goto l;							\
+	}								\
+}
+#define XFS_WANT_CORRUPTED_RETURN(mp, expr)				\
+{									\
+	if (!(expr)) {							\
+		if ((mp)->m_flags & LIBXFS_MOUNT_WANT_CORRUPTED)	\
+			printf("WANT_CORRUPTED_RETURN at %s:%d\n",	\
+				__func__, __LINE__);			\
+		return -EFSCORRUPTED;					\
+	}								\
+}
 
 #ifdef __GNUC__
 #define __return_address	__builtin_return_address(0)
diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 0394c50..1b4d9e3 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -158,7 +158,7 @@ outputs its progress every 15 minutes. Reporting is only activated when
 ag_stride is enabled.
 .TP
 .B \-v
-Verbose output.
+Verbose output.  May be specified multiple times to increase verbosity.
 .TP
 .B \-d
 Repair dangerously. Allow
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index bed2ff5..1aeac5b 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -695,6 +695,10 @@ main(int argc, char **argv)
 	}
 	mp->m_log = &log;
 
+	/* Spit out function & line on these corruption macros */
+	if (verbose > 2)
+		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
+
 	/*
 	 * set XFS-independent status vars from the mount/sb structure
 	 */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
