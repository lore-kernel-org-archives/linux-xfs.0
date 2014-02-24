Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3DDBA7F52
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 09:11:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF503AC005
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 07:11:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P2PNFXRyKHhGruwj for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 07:11:12 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1OFB4UW028007
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 10:11:09 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1OEU4QD004027
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 09:30:04 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 02/11] xfs: reserve v5 superblock read-only compat. feature
	bit for finobt
Date: Mon, 24 Feb 2014 09:29:54 -0500
Message-Id: <1393252203-7423-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1393252203-7423-1-git-send-email-bfoster@redhat.com>
References: <1393252203-7423-1-git-send-email-bfoster@redhat.com>
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

Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
