Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 757807CED
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:58:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E91A8AC001
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:58:23 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8RxXbyqXR33pYK55 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:58:22 -0700 (PDT)
Subject: [PATCH 20/47] xfs: increase XFS_BTREE_MAXLEVELS to fit the rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:58:17 -0700
Message-ID: <146907709719.25461.3104352212846077948.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

By my calculations, a 1,073,741,824 block AG with a 1k block size
can attain a maximum height of 9.  Assuming a record size of 24
bytes, a key/ptr size of 44 bytes, and half-full btree nodes,
we'd need 53,687,092 blocks for the records and ~6 million blocks
for the keys.  That requires a btree of height 9.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b8bbb21..629ef4f 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -133,7 +133,7 @@ do {    \
 	}       \
 } while (0)
 
-#define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
+#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
 
 struct xfs_btree_ops {
 	/* size of the key and record structures */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
