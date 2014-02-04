Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 629CD7F57
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:49:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2EF2AC006
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:49:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ec7EL4yOOcB2y9J7 for
	<xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:49:45 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s14Hnj7M000954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:45 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s14HnigC002026
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 09/11] xfs: add finobt support to growfs
Date: Tue,  4 Feb 2014 12:49:40 -0500
Message-Id: <1391536182-9048-10-git-send-email-bfoster@redhat.com>
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

Add finobt support to growfs. Initialize the agi root/level fields
and the root finobt block.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_fsops.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 02fb943..96e4eb0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -316,6 +316,10 @@ xfs_growfs_data_private(
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
+			agi->agi_free_level = cpu_to_be32(1);
+		}
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 			agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 
@@ -407,6 +411,34 @@ xfs_growfs_data_private(
 		xfs_buf_relse(bp);
 		if (error)
 			goto error0;
+
+		/*
+		 * FINO btree root block
+		 */
+		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+			bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_inobt_buf_ops);
+			if (!bp) {
+				error = ENOMEM;
+				goto error0;
+			}
+
+			if (xfs_sb_version_hascrc(&mp->m_sb))
+				xfs_btree_init_block(mp, bp, XFS_FIBT_CRC_MAGIC,
+						     0, 0, agno,
+						     XFS_BTREE_CRC_BLOCKS);
+			else
+				xfs_btree_init_block(mp, bp, XFS_FIBT_MAGIC, 0,
+						     0, agno, 0);
+
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+			if (error)
+				goto error0;
+		}
+
 	}
 	xfs_trans_agblocks_delta(tp, nfree);
 	/*
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
