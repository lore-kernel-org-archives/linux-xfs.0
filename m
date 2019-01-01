Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56754 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfAACX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:23:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012GKRn169434
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:24 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2pnxedxav4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:23:24 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012NNwd031011
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:23 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012NNNv004502
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:23 GMT
Subject: [PATCH 09/13] xfs: enforce metadata inode flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:23:22 -0800
Message-ID: <154630940242.21716.6515771914516209462.stgit@magnolia>
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

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    5 +++++
 fs/xfs/scrub/common.c         |    3 ++-
 fs/xfs/scrub/inode_repair.c   |    3 +++
 fs/xfs/scrub/scrub.c          |    1 +
 fs/xfs/xfs_icache.c           |    4 +++-
 fs/xfs/xfs_inode.c            |    8 ++++++++
 fs/xfs/xfs_itable.c           |    6 ++++++
 7 files changed, 28 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8fa1050c1ae2..debacf69f126 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -557,6 +557,11 @@ xfs_dinode_verify(
 
 	flags2 = be64_to_cpu(dip->di_flags2);
 
+	/* don't allow the metadata iflag if we don't have metadir */
+	if ((flags2 & XFS_DIFLAG2_METADATA) &&
+	    !xfs_sb_version_hasmetadir(&mp->m_sb))
+		return __this_address;
+
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
 	     !xfs_sb_version_hasreflink(&mp->m_sb))
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index c881b18dd799..c5cbe245082c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -722,7 +722,8 @@ xchk_get_inode(
 				error, __return_address);
 		return error;
 	}
-	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
+	if (VFS_I(ip)->i_generation != sc->sm->sm_gen ||
+	    xfs_is_metadata_inode(ip)) {
 		xfs_irele(ip);
 		return -ENOENT;
 	}
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 3c9ac9e046fd..c036481a2407 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -168,6 +168,9 @@ xrep_dinode_flags(
 		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (flags2 & XFS_DIFLAG2_REFLINK)
 		flags2 &= ~XFS_DIFLAG2_DAX;
+	if (!xfs_sb_version_hasmetadir(&mp->m_sb) &&
+	    (flags2 & XFS_DIFLAG2_METADATA))
+		flags2 &= ~XFS_DIFLAG2_METADATA;
 	dip->di_flags = cpu_to_be16(flags);
 	dip->di_flags2 = cpu_to_be64(flags2);
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 943dbec82d60..5f176575dad7 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -184,6 +184,7 @@ xchk_teardown(
 		if (sc->ilock_flags)
 			xfs_iunlock(sc->ip, sc->ilock_flags);
 		if (sc->ip != ip_in &&
+		    !xfs_is_metadata_inode(sc->ip) &&
 		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7c459e37396d..2881716e1c9e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -927,7 +927,9 @@ xfs_imeta_iget(
 	if (error)
 		return error;
 
-	if (ftype == XFS_DIR3_FT_UNKNOWN ||
+	if ((xfs_sb_version_hasmetadir(&mp->m_sb) &&
+	     !xfs_is_metadata_inode(ip)) ||
+	    ftype == XFS_DIR3_FT_UNKNOWN ||
 	    xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype) {
 		xfs_irele(ip);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d2de7cd87b07..6a3a8137af4d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -609,8 +609,13 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
+	if (xfs_is_metadata_inode(*ipp))
+		goto out_irele;
+
 	return 0;
 
+out_irele:
+	xfs_irele(*ipp);
 out_free_name:
 	if (ci_name)
 		kmem_free(ci_name->name);
@@ -2658,6 +2663,9 @@ void
 xfs_imeta_irele(
 	struct xfs_inode	*ip)
 {
+	ASSERT(!xfs_sb_version_hasmetadir(&ip->i_mount->m_sb) ||
+	       xfs_is_metadata_inode(ip));
+
 	xfs_irele(ip);
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 8c6ca9d364ec..c8aa7c6295c2 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -54,6 +54,12 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out_free;
 
+	if (xfs_is_metadata_inode(ip)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		xfs_irele(ip);
+		goto out_free;
+	}
+
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
