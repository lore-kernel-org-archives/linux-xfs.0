Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D16817F53
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:49:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B83128F8040
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:49:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EwpH8M7F4x00A557 for
	<xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:49:45 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s14Hnisr004567
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:44 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s14HniPP007403
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 02/11] xfs: reserve v5 superblock read-only compat. feature
	bit for finobt
Date: Tue,  4 Feb 2014 12:49:33 -0500
Message-Id: <1391536182-9048-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
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

Reserve a v5 read-only compatibility feature bit for the finobt and
create the xfs_sb_version_hasfinobt() helper to determine whether
an fs has the feature enabled.

The finobt does not change existing on-disk structures, but must
remain consistent with the ialloc btree. Modifications from older
kernels would violate that constrant. Therefore, we restrict older
kernels to read-only mounts of finobt-enabled filesystems.

Note that this does not yet enable the ability to rw mount a finobt
fs (by setting the feature bit in the XFS_SB_FEAT_RO_COMPAT_ALL
mask).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_sb.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 35061d4..070a7f6 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -585,6 +585,7 @@ xfs_sb_has_compat_feature(
 	return (sbp->sb_features_compat & feature) != 0;
 }
 
+#define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL 0
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
@@ -639,6 +640,12 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
+static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
+}
+
 /*
  * end of superblock version macros
  */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
