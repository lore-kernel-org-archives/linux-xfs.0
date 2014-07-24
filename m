Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9CBE7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:54:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 969A9AC009
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:54:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 255dPdzpDUF6gw8a (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:54:12 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OEsBwY007147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:54:12 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAFj029062
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 10/18] xfs: set sparse inodes feature bit when a sparse chunk
	is allocated
Date: Thu, 24 Jul 2014 10:23:00 -0400
Message-Id: <1406211788-63206-11-git-send-email-bfoster@redhat.com>
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

The sparse chunk inode record format is backwards compatible with old
format inobt records as long as full chunks are allocated. The holemask
field uses higher order bytes of the freecount. While sparse chunks can
be enabled on previously unsupported fs, older kernel drivers cannot
parse sparse inode records.

Set the feature incompatible bit once a sparse inode chunk is allocated
to prevent older XFS drivers from tripping over the new format.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4226b1b..4dd45c2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -407,6 +407,27 @@ error:
 	return error;
 }
 
+STATIC void
+xfs_sbversion_add_spinodes(
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
+					    XFS_SB_FEAT_INCOMPAT_SPINODES))
+		return;
+
+	spin_lock(&mp->m_sb_lock);
+	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
+					    XFS_SB_FEAT_INCOMPAT_SPINODES)) {
+		spin_unlock(&mp->m_sb_lock);
+		return;
+	}
+
+	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
+	spin_unlock(&mp->m_sb_lock);
+	xfs_mod_sb(tp, XFS_SB_FEATURES_INCOMPAT);
+}
+
 /*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
@@ -631,6 +652,18 @@ xfs_ialloc_ag_alloc(
 		if (error)
 			return error;
 	}
+
+	/*
+	 * Set an incompat feature bit as old drivers can't parse sparse
+	 * records. Pre-sparse inode chunk drivers will include the
+	 * holemask in the higher order freecount bits, resulting in a
+	 * bogus value.
+	 *
+	 * XXX: when is this bit removed?
+	 */
+	if (xfs_inobt_issparse(&rec))
+		xfs_sbversion_add_spinodes(tp, args.mp);
+
 	/*
 	 * Log allocation group header fields
 	 */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
