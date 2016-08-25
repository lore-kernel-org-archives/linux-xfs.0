Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F14D87CA3
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:28:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F88E8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:39 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id NH7nvWx7VDBnAbfN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:37 -0700 (PDT)
Subject: [PATCH 02/13] xfs/122: decrease the log update done item sizes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:28:32 -0700
Message-ID: <147216771202.32641.9018236822745566504.stgit@birch.djwong.org>
In-Reply-To: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Redundant fields were removed from the rmap/refcount/bmap update done
log items, so fix the size tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index b20011e..06d1432 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -61,10 +61,10 @@ sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56
 sizeof(struct xfs_btree_block) = 72
-sizeof(struct xfs_bud_log_format) = 48
+sizeof(struct xfs_bud_log_format) = 16
 sizeof(struct xfs_bui_log_format) = 48
 sizeof(struct xfs_clone_args) = 32
-sizeof(struct xfs_cud_log_format) = 32
+sizeof(struct xfs_cud_log_format) = 16
 sizeof(struct xfs_cui_log_format) = 32
 sizeof(struct xfs_da3_blkinfo) = 56
 sizeof(struct xfs_da3_intnode) = 64
@@ -90,7 +90,7 @@ sizeof(struct xfs_rmap_rec) = 24
 sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32
 sizeof(struct xfs_rtrmap_root) = 4
-sizeof(struct xfs_rud_log_format) = 48
+sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 48
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
