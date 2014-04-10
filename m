Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28A967F85
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:08:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13B948F8040
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id shHKPnsXpafUTR8g for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:39 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AG8c5x008803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:38 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3AG8cBY022358
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 02/11] xfs: reserve v5 superblock read-only compat. feature
	bit for finobt
Date: Thu, 10 Apr 2014 12:08:27 -0400
Message-Id: <1397146116-42546-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
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
index f7b2fe7..7f53a85 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -587,6 +587,7 @@ xfs_sb_has_compat_feature(
 	return (sbp->sb_features_compat & feature) != 0;
 }
 
+#define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL 0
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
@@ -641,6 +642,12 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
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
