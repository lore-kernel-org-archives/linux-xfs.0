Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfAACWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:22:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012FDLA174239
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx454-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:22:47 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012Mkf9015675
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:46 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012Mkkq027294
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:22:46 GMT
Subject: [PATCH 03/13] xfs: refactor the v4 group/project inode pointer
 switch
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:22:45 -0800
Message-ID: <154630936571.21716.17710862173783712576.stgit@magnolia>
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

Refactor the group and project quota inode pointer switcheroo that
happens only on v4 filesystems into a separate function prior to
enhancing the xfs_qm_qino_alloc function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   79 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 58be2ef90351..b5f2853a5009 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -742,6 +742,53 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+/*
+ * Switch the group and project quota in-core inode pointers if needed.
+ *
+ * On v4 superblocks that don't have separate pquotino, we share an inode
+ * between gquota and pquota. If the on-disk superblock has GQUOTA and the
+ * filesystem is now mounted with PQUOTA, just use sb_gquotino for sb_pquotino
+ * and vice-versa.
+ */
+STATIC int
+xfs_qm_qino_switch(
+	struct xfs_mount	*mp,
+	struct xfs_inode	**ip,
+	unsigned int		flags,
+	bool			*need_alloc)
+{
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	if (xfs_sb_version_has_pquotino(&mp->m_sb) ||
+	    !(flags & (XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)))
+		return 0;
+
+	if ((flags & XFS_QMOPT_PQUOTA) &&
+	    (mp->m_sb.sb_gquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_gquotino;
+		if (mp->m_sb.sb_pquotino != NULLFSINO)
+			return -EFSCORRUPTED;
+	} else if ((flags & XFS_QMOPT_GQUOTA) &&
+		   (mp->m_sb.sb_pquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_pquotino;
+		if (mp->m_sb.sb_gquotino != NULLFSINO)
+			return -EFSCORRUPTED;
+	}
+
+	if (ino == NULLFSINO)
+		return 0;
+
+	error = xfs_iget(mp, NULL, ino, 0, 0, ip);
+	if (error)
+		return error;
+
+	mp->m_sb.sb_gquotino = NULLFSINO;
+	mp->m_sb.sb_pquotino = NULLFSINO;
+	*need_alloc = false;
+	return 0;
+}
+
 /*
  * Create an inode and return with a reference already taken, but unlocked
  * This is how we create quota inodes
@@ -762,35 +809,9 @@ xfs_qm_qino_alloc(
 	bool		need_alloc = true;
 
 	*ip = NULL;
-	/*
-	 * With superblock that doesn't have separate pquotino, we
-	 * share an inode between gquota and pquota. If the on-disk
-	 * superblock has GQUOTA and the filesystem is now mounted
-	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
-	 * vice-versa.
-	 */
-	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
-			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
-		xfs_ino_t ino = NULLFSINO;
-
-		if ((flags & XFS_QMOPT_PQUOTA) &&
-			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_gquotino;
-			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
-		} else if ((flags & XFS_QMOPT_GQUOTA) &&
-			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_pquotino;
-			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
-		}
-		if (ino != NULLFSINO) {
-			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
-			if (error)
-				return error;
-			mp->m_sb.sb_gquotino = NULLFSINO;
-			mp->m_sb.sb_pquotino = NULLFSINO;
-			need_alloc = false;
-		}
-	}
+	error = xfs_qm_qino_switch(mp, ip, flags, &need_alloc);
+	if (error)
+		return error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
 			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
