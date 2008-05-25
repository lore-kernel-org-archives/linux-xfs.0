Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 12:06:57 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PJ6s3t022212
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:06:55 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3BDB1B973DE
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:45 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 6DTXgFk594ODTRPY for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:45 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4PJ7bF3014083
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 21:07:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4PJ7bOO014081
	for xfs@oss.sgi.com; Sun, 25 May 2008 21:07:37 +0200
Date: Sun, 25 May 2008 21:07:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] don't leak m_fsname/m_rtname/m_logname
Message-ID: <20080525190736.GA13372@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add a helper to free the m_fsname/m_rtname/m_logname allocations and use
it properly for all mount failure cases.  Also switch the allocations
for these to kstrdup while we're at it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-22 19:30:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-22 19:30:44.000000000 +0200
@@ -1079,6 +1079,15 @@ xfssyncd(
 }
 
 STATIC void
+xfs_free_fsname(
+	struct xfs_mount	*mp)
+{
+	kfree(mp->m_fsname);
+	kfree(mp->m_rtname);
+	kfree(mp->m_logname);
+}
+
+STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)
 {
@@ -1139,6 +1148,7 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
+	xfs_free_fsname(mp);
 	kfree(mp);
 }
 
@@ -1408,6 +1418,8 @@ xfs_start_flags(
 	struct xfs_mount_args	*ap,
 	struct xfs_mount	*mp)
 {
+	int			error;
+
 	/* Values are in BBs */
 	if ((ap->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
 		/*
@@ -1440,17 +1452,27 @@ xfs_start_flags(
 			ap->logbufsize);
 		return XFS_ERROR(EINVAL);
 	}
+
+	error = ENOMEM;
+
 	mp->m_logbsize = ap->logbufsize;
 	mp->m_fsname_len = strlen(ap->fsname) + 1;
-	mp->m_fsname = kmem_alloc(mp->m_fsname_len, KM_SLEEP);
-	strcpy(mp->m_fsname, ap->fsname);
+
+	mp->m_fsname = kstrdup(ap->fsname, GFP_KERNEL);
+	if (!mp->m_fsname)
+		goto out;
+
 	if (ap->rtname[0]) {
-		mp->m_rtname = kmem_alloc(strlen(ap->rtname) + 1, KM_SLEEP);
-		strcpy(mp->m_rtname, ap->rtname);
+		mp->m_rtname = kstrdup(ap->rtname, GFP_KERNEL);
+		if (!mp->m_rtname)
+			goto out_free_fsname;
+
 	}
+
 	if (ap->logname[0]) {
-		mp->m_logname = kmem_alloc(strlen(ap->logname) + 1, KM_SLEEP);
-		strcpy(mp->m_logname, ap->logname);
+		mp->m_logname = kstrdup(ap->logname, GFP_KERNEL);
+		if (!mp->m_logname)
+			goto out_free_rtname;
 	}
 
 	if (ap->flags & XFSMNT_WSYNC)
@@ -1523,6 +1545,14 @@ xfs_start_flags(
 	if (ap->flags & XFSMNT_DMAPI)
 		mp->m_flags |= XFS_MOUNT_DMAPI;
 	return 0;
+
+
+ out_free_rtname:
+	kfree(mp->m_rtname);
+ out_free_fsname:
+	kfree(mp->m_fsname);
+ out:
+	return error;
 }
 
 /*
@@ -1683,10 +1713,10 @@ xfs_fs_fill_super(
 	 */
 	error = xfs_start_flags(args, mp);
 	if (error)
-		goto out_destroy_counters;
+		goto out_free_fsname;
 	error = xfs_readsb(mp, flags);
 	if (error)
-		goto out_destroy_counters;
+		goto out_free_fsname;
 	error = xfs_finish_flags(args, mp);
 	if (error)
 		goto out_free_sb;
@@ -1748,7 +1778,8 @@ xfs_fs_fill_super(
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
- out_destroy_counters:
+ out_free_fsname:
+	xfs_free_fsname(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
  out_put_qmops:
@@ -1784,7 +1815,7 @@ xfs_fs_fill_super(
 	IRELE(mp->m_rootip);
 
 	xfs_unmountfs(mp);
-	goto out_destroy_counters;
+	goto out_free_fsname;
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-05-22 19:31:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-05-22 19:31:29.000000000 +0200
@@ -146,13 +146,6 @@ xfs_mount_free(
 	mutex_destroy(&mp->m_growlock);
 	if (mp->m_quotainfo)
 		XFS_QM_DONE(mp);
-
-	if (mp->m_fsname != NULL)
-		kmem_free(mp->m_fsname);
-	if (mp->m_rtname != NULL)
-		kmem_free(mp->m_rtname);
-	if (mp->m_logname != NULL)
-		kmem_free(mp->m_logname);
 }
 
 /*
