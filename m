Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27FE67F8D
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:51:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 076BB304051
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oHRm1KRLIsFbixi4 for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:49 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9AFpmJg015919
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:48 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r9AFpmSv006402
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 02/12] xfsprogs: reserve v5 superblock read-only compat.
	feature bit for finobt
Date: Thu, 10 Oct 2013 11:51:02 -0400
Message-Id: <1381420272-13249-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
References: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
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
 include/xfs_sb.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index c8d8898..83e037b 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -583,6 +583,7 @@ xfs_sb_has_compat_feature(
 	return (sbp->sb_features_compat & feature) != 0;
 }
 
+#define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL 0
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
@@ -635,6 +636,12 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
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
