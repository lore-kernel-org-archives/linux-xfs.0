Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfAACXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:23:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E408173564
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jqx45k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:23:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012NBRJ030731
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:11 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012NBBZ027491
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:11 GMT
Subject: [PATCH 07/13] xfs: load metadata inode directory at mount time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:23:10 -0800
Message-ID: <154630939020.21716.3079946986143648994.stgit@magnolia>
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Load the metadata directory inode into memory at mount time and release
it at unmount time.  We also make sure that the obsolete inode pointers
in the superblock are not logged or read from the superblock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c    |   31 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.c |    2 +-
 fs/xfs/xfs_mount.c        |   20 ++++++++++++++++++--
 fs/xfs/xfs_mount.h        |    1 +
 4 files changed, 51 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 8ffb5c1b2843..86ba6a2cb3bb 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -524,6 +524,25 @@ __xfs_sb_from_disk(
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
+
+	if (xfs_sb_version_hasmetadir(to)) {
+		/*
+		 * Set metadirino here and null out the in-core fields for
+		 * the other inodes because metadir initialization will load
+		 * them later.
+		 */
+		to->sb_metadirino = be64_to_cpu(from->sb_rbmino);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
+
+		/*
+		 * We don't have to worry about quota inode conversion here
+		 * because metadir requires a v5 filesystem.
+		 */
+		to->sb_uquotino = NULLFSINO;
+		to->sb_gquotino = NULLFSINO;
+		to->sb_pquotino = NULLFSINO;
+	}
 }
 
 void
@@ -665,6 +684,18 @@ xfs_sb_to_disk(
 		if (xfs_sb_version_hasmetauuid(from))
 			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	}
+
+	if (xfs_sb_version_hasmetadir(from)) {
+		/*
+		 * Save metadirino here and null out the on-disk fields for
+		 * the other inodes, at least until we reuse the fields.
+		 */
+		to->sb_rbmino = cpu_to_be64(from->sb_metadirino);
+		to->sb_rsumino = cpu_to_be64(NULLFSINO);
+		to->sb_uquotino = cpu_to_be64(NULLFSINO);
+		to->sb_gquotino = cpu_to_be64(NULLFSINO);
+		to->sb_pquotino = cpu_to_be64(NULLFSINO);
+	}
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index d05ccfabbc9c..089c5d865746 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -153,7 +153,7 @@ xfs_verify_dir_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	if (xfs_internal_inum(mp, ino))
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb) && xfs_internal_inum(mp, ino))
 		return false;
 	return xfs_verify_ino(mp, ino);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b895368c64fb..68b9ba7245e8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -672,6 +672,16 @@ xfs_mountfs_imeta(
 {
 	int			error;
 
+	/* Load the metadata directory inode into memory. */
+	if (xfs_sb_version_hasmetadir(&mp->m_sb)) {
+		error = xfs_imeta_iget(mp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error) {
+			xfs_warn(mp, "Failed metadir ino init: %d", error);
+			return error;
+		}
+	}
+
 	error = xfs_imeta_mount(mp);
 	if (error) {
 		xfs_warn(mp, "Failed to load metadata inode info, error %d",
@@ -921,7 +931,7 @@ xfs_mountfs(
 
 	error = xfs_mountfs_imeta(mp);
 	if (error)
-		goto out_log_dealloc;
+		goto out_free_metadir;
 
 	/*
 	 * Get and sanity-check the root inode.
@@ -933,7 +943,7 @@ xfs_mountfs(
 		xfs_warn(mp,
 			"Failed to read root inode 0x%llx, error %d",
 			sbp->sb_rootino, -error);
-		goto out_log_dealloc;
+		goto out_free_metadir;
 	}
 
 	ASSERT(rip != NULL);
@@ -1079,6 +1089,9 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+ out_free_metadir:
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
 	/*
 	 * Cancel all delayed reclaim work and reclaim the inodes directly.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
@@ -1143,6 +1156,9 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
+
 	/*
 	 * We can potentially deadlock here if we have an inode cluster
 	 * that has been freed has its buffer still pinned in memory because
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 34f2cf96ec27..2845a51f1a36 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -103,6 +103,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
+	struct xfs_inode	*m_metadirip;	/* metadata inode directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
