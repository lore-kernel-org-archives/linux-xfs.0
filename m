Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 23:25:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G6Pk6Q017540
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:25:46 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F961235148
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:26:43 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id YiiCHG0b4qDDgmkZ for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:26:43 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5G6QYNW006023
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 08:26:34 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5G6QYep006021
	for xfs@oss.sgi.com; Mon, 16 Jun 2008 08:26:34 +0200
Date: Mon, 16 Jun 2008 08:26:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill XFS_PURGE_INODE
Message-ID: <20080616062634.GA5971@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Just a useless alias for IRELE.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-06-05 20:21:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-06-05 20:22:37.000000000 +0200
@@ -444,11 +444,11 @@ xfs_qm_unmount_quotas(
 		}
 	}
 	if (uqp) {
-		 XFS_PURGE_INODE(uqp);
+		 IRELE(uqp);
 		 mp->m_quotainfo->qi_uquotaip = NULL;
 	}
 	if (gqp) {
-		XFS_PURGE_INODE(gqp);
+		IRELE(gqp);
 		mp->m_quotainfo->qi_gquotaip = NULL;
 	}
 out:
@@ -1239,11 +1239,11 @@ xfs_qm_destroy_quotainfo(
 	xfs_qm_list_destroy(&qi->qi_dqlist);
 
 	if (qi->qi_uquotaip) {
-		XFS_PURGE_INODE(qi->qi_uquotaip);
+		IRELE(qi->qi_uquotaip);
 		qi->qi_uquotaip = NULL; /* paranoia */
 	}
 	if (qi->qi_gquotaip) {
-		XFS_PURGE_INODE(qi->qi_gquotaip);
+		IRELE(qi->qi_gquotaip);
 		qi->qi_gquotaip = NULL;
 	}
 	mutex_destroy(&qi->qi_quotaofflock);
@@ -1393,7 +1393,7 @@ xfs_qm_qino_alloc(
 	 * locked exclusively and joined to the transaction already.
 	 */
 	ASSERT(xfs_isilocked(*ip, XFS_ILOCK_EXCL));
-	VN_HOLD(XFS_ITOV((*ip)));
+	IHOLD(*ip);
 
 	/*
 	 * Make the changes in the superblock, and log those too.
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2008-05-23 09:31:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c	2008-06-05 20:21:09.000000000 +0200
@@ -362,11 +362,11 @@ xfs_qm_scall_quotaoff(
 	 * if we don't need them anymore.
 	 */
 	if ((dqtype & XFS_QMOPT_UQUOTA) && XFS_QI_UQIP(mp)) {
-		XFS_PURGE_INODE(XFS_QI_UQIP(mp));
+		IRELE(XFS_QI_UQIP(mp));
 		XFS_QI_UQIP(mp) = NULL;
 	}
 	if ((dqtype & (XFS_QMOPT_GQUOTA|XFS_QMOPT_PQUOTA)) && XFS_QI_GQIP(mp)) {
-		XFS_PURGE_INODE(XFS_QI_GQIP(mp));
+		IRELE(XFS_QI_GQIP(mp));
 		XFS_QI_GQIP(mp) = NULL;
 	}
 out_error:
Index: linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_quota_priv.h	2008-05-23 09:31:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h	2008-06-05 20:21:09.000000000 +0200
@@ -158,9 +158,6 @@ for ((dqp) = (qlist)->qh_next; (dqp) != 
 #define XFS_IS_SUSER_DQUOT(dqp)		\
 	(!((dqp)->q_core.d_id))
 
-#define XFS_PURGE_INODE(ip)		\
-	IRELE(ip);
-
 #define DQFLAGTO_TYPESTR(d)	(((d)->dq_flags & XFS_DQ_USER) ? "USR" : \
 				 (((d)->dq_flags & XFS_DQ_GROUP) ? "GRP" : \
 				 (((d)->dq_flags & XFS_DQ_PROJ) ? "PRJ":"???")))
