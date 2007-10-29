Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 16:35:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TNZfOO031905
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 16:35:43 -0700
Date: Tue, 30 Oct 2007 10:35:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] show all mount args in /proc/mounts
Message-ID: <20071029233543.GQ995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@sgi.com

There are several mount options that don't show up in /proc/mounts.
Add them in and clean up the showargs code at the same time.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_vfsops.c |   74 ++++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-10-25 10:09:35.025053878 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-10-25 10:34:08.177844260 +1000
@@ -1838,15 +1838,17 @@ done:
 	return 0;
 }
 
+struct proc_xfs_info {
+	int	flag;
+	char	*str;
+};
+
 int
 xfs_showargs(
 	struct xfs_mount	*mp,
 	struct seq_file		*m)
 {
-	static struct proc_xfs_info {
-		int	flag;
-		char	*str;
-	} xfs_info[] = {
+	static struct proc_xfs_info xfs_info_set[] = {
 		/* the few simple ones we can get from the mount struct */
 		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
 		{ XFS_MOUNT_INO64,		"," MNTOPT_INO64 },
@@ -1855,14 +1857,30 @@ xfs_showargs(
 		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
 		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
 		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
+		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
+		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
+		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
+		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
+		{ 0, NULL }
+	};
+	static struct proc_xfs_info xfs_info_unset[] = {
+		/* the few simple ones we can get from the mount struct */
+		{ XFS_MOUNT_IDELETE,		"," MNTOPT_IKEEP },
+		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
+		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
+		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
 		{ 0, NULL }
 	};
 	struct proc_xfs_info	*xfs_infop;
 
-	for (xfs_infop = xfs_info; xfs_infop->flag; xfs_infop++) {
+	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
 		if (mp->m_flags & xfs_infop->flag)
 			seq_puts(m, xfs_infop->str);
 	}
+	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
+		if (!(mp->m_flags & xfs_infop->flag))
+			seq_puts(m, xfs_infop->str);
+	}
 
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
@@ -1885,41 +1903,23 @@ xfs_showargs(
 		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (!(mp->m_flags & XFS_MOUNT_IDELETE))
-		seq_printf(m, "," MNTOPT_IKEEP);
-	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE))
-		seq_printf(m, "," MNTOPT_LARGEIO);
-
-	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS))
-		seq_printf(m, "," MNTOPT_64BITINODE);
-	if (mp->m_flags & XFS_MOUNT_GRPID)
-		seq_printf(m, "," MNTOPT_GRPID);
-
-	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_UQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_USRQUOTA);
-		else
-			seq_puts(m, "," MNTOPT_UQUOTANOENF);
-	}
-
-	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_PRJQUOTA);
-		else
-			seq_puts(m, "," MNTOPT_PQUOTANOENF);
-	}
-
-	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_OQUOTA_ENFD)
-			seq_puts(m, "," MNTOPT_GRPQUOTA);
-		else
-			seq_puts(m, "," MNTOPT_GQUOTANOENF);
-	}
+	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
+		seq_puts(m, "," MNTOPT_USRQUOTA);
+	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
+		seq_puts(m, "," MNTOPT_UQUOTANOENF);
+
+	if (mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
+		seq_puts(m, "," MNTOPT_PRJQUOTA);
+	else if (mp->m_qflags & XFS_PQUOTA_ACCT)
+		seq_puts(m, "," MNTOPT_PQUOTANOENF);
+
+	if (mp->m_qflags & (XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD))
+		seq_puts(m, "," MNTOPT_GRPQUOTA);
+	else if (mp->m_qflags & XFS_GQUOTA_ACCT)
+		seq_puts(m, "," MNTOPT_GQUOTANOENF);
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, "," MNTOPT_NOQUOTA);
 
-	if (mp->m_flags & XFS_MOUNT_DMAPI)
-		seq_puts(m, "," MNTOPT_DMAPI);
 	return 0;
 }
