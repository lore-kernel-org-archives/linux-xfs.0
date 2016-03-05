Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 65A357CAE
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:38:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38ADD8F8035
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:38:29 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hRzkT0pPI6H5TBgp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:38:27 -0800 (PST)
Subject: [PATCH 09/12] xfs/122: support rmapxbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:38:16 -0800
Message-ID: <20160305003815.28738.81125.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Support the extended rmap btree key structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index c590166..451871e 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -77,8 +77,9 @@ sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
-sizeof(struct xfs_rmap_key) = 20
+sizeof(struct xfs_rmap_key) = 4
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rmapx_key) = 20
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 336

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
