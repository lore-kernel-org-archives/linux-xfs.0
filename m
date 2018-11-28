Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35798 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbeK2KbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:31:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNNtc8156813
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:56 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nxxkqn6xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:56 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wASNRt6M013491
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:55 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wASNRtK8010710
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:55 GMT
Subject: [PATCH 9/9] xfs: scrub should flag dir/attr offsets that aren't
 mappable with xfs_dablk_t
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:27:54 -0800
Message-ID: <154344767468.3835.13052378017840578886.stgit@magnolia>
In-Reply-To: <154344761877.3835.7785580513047409388.stgit@magnolia>
References: <154344761877.3835.7785580513047409388.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach scrub to flag extent maps that exceed the range that can be mapped
with a xfs_dablk_t.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_types.c |   11 +++++++++++
 fs/xfs/libxfs/xfs_types.h |    1 +
 fs/xfs/scrub/bmap.c       |   27 +++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 3306fc42cfad..8e03e88a2f1a 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -204,3 +204,14 @@ xfs_verify_icount(
 	xfs_icount_range(mp, &min, &max);
 	return icount >= min && icount <= max;
 }
+
+/* Sanity-checking of dir/attr block offsets. */
+bool
+xfs_verify_dablk(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		dabno)
+{
+	xfs_dablk_t		max_dablk = -1U;
+
+	return dabno < max_dablk;
+}
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b9e6c89284c3..05e8fa558f3e 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -166,5 +166,6 @@ bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
+bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
 
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index e1d11f3223e3..a703cd58a90e 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -281,6 +281,31 @@ xchk_bmap_extent_xref(
 	xchk_ag_free(info->sc, &info->sc->sa);
 }
 
+/*
+ * Directories and attr forks should never have blocks that can't be addressed
+ * by a xfs_dablk_t.
+ */
+STATIC void
+xchk_bmap_dirattr_extent(
+	struct xfs_inode	*ip,
+	struct xchk_bmap_info	*info,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		off;
+
+	if (!S_ISDIR(VFS_I(ip)->i_mode) && info->whichfork != XFS_ATTR_FORK)
+		return;
+
+	if (!xfs_verify_dablk(mp, irec->br_startoff))
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
+	off = irec->br_startoff + irec->br_blockcount - 1;
+	if (!xfs_verify_dablk(mp, off))
+		xchk_fblock_set_corrupt(info->sc, info->whichfork, off);
+}
+
 /* Scrub a single extent record. */
 STATIC int
 xchk_bmap_extent(
@@ -305,6 +330,8 @@ xchk_bmap_extent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
+	xchk_bmap_dirattr_extent(ip, info, irec);
+
 	/* There should never be a "hole" extent in either extent list. */
 	if (irec->br_startblock == HOLESTARTBLOCK)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
