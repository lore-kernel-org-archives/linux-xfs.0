Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FAE47FD1
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:33:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D69B5AC002
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:33:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UNCSJEAfFlpwon18 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:33:47 -0700 (PDT)
Subject: [PATCH 06/24] xfs: add refcount btree support to growfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:33:37 -0700
Message-ID: <20150729223337.17414.92008.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
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

Modify the growfs code to initialize new refcount btree blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsops.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9aabefb..4d39a30 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -260,6 +260,10 @@ xfs_growfs_data_private(
 		agf->agf_longest = cpu_to_be32(tmpsize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			agf->agf_refcount_root = cpu_to_be32(XFS_REFC_BLOCK(mp));
+			agf->agf_refcount_level = cpu_to_be32(1);
+		}
 
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
@@ -503,6 +507,28 @@ xfs_growfs_data_private(
 				goto error0;
 		}
 
+		/*
+		 * refcount btree root block
+		 */
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_REFC_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_refcountbt_buf_ops);
+			if (!bp) {
+				error = -ENOMEM;
+				goto error0;
+			}
+
+			xfs_btree_init_block(mp, bp, XFS_REFC_CRC_MAGIC,
+					     0, 0, agno,
+					     XFS_BTREE_CRC_BLOCKS);
+
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+			if (error)
+				goto error0;
+		}
 	}
 	xfs_trans_agblocks_delta(tp, nfree);
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
