Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27540834D
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:41:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0A1FAC005
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dskvRzVpYoeXs6Bp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:44 -0700 (PDT)
Subject: [PATCH 103/145] xfs: provide switch to force filesystem to
	copy-on-write all the time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:41:37 -0700
Message-ID: <146612769744.16048.10282280464454097330.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Make it possible to force XFS to use copy on write all the time, at
least if reflink is turned on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_priv.h  |    2 ++
 libxfs/xfs_refcount.c |    6 ++++++
 2 files changed, 8 insertions(+)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 41f6b96..527bd49 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -517,4 +517,6 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 
+#define xfs_always_cow	(false)
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index e03a9b7..855ab54 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1189,6 +1189,12 @@ xfs_refcount_find_shared(
 
 	trace_xfs_refcount_find_shared(mp, agno, agbno, aglen);
 
+	if (xfs_always_cow) {
+		*fbno = agbno;
+		*flen = aglen;
+		return 0;
+	}
+
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 	if (error)
 		goto out;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
