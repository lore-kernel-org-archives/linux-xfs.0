Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B4577F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:04:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A75FAC005
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 08:04:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Mf5hdG2OdKyMIvAy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 08:04:20 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OF4GrO003624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 11:04:19 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAoE030181
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 18/18] xfs: enable sparse inode chunks for v5 superblocks
Date: Thu, 24 Jul 2014 10:23:08 -0400
Message-Id: <1406211788-63206-19-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Enable the use and processing of sparse inode chunks.  Fix the
xfs_sb_version_hassparseinodes() helper to allow the allocation of
sparse chunks on v5 format superblocks. Add the incompat. feature bit to
the *_ALL mask such that fs' with sparse chunks can be mounted.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 6f48de9..f2299b7 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -511,7 +511,8 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
+		 XFS_SB_FEAT_INCOMPAT_SPINODES)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -561,7 +562,7 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 {
-	return 0; /* not yet enabled */
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
 /*
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
