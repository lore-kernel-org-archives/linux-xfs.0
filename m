Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 997207FA3
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 13:53:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 231D630407A
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 11:53:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QKCUuPCgmztkfJzR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 11:53:07 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t16Jr7dB016997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:08 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t16Jr7Ia010099
	for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 05/18] xfs: create macros/helpers for dealing with sparse
	inode chunks
Date: Fri,  6 Feb 2015 14:52:52 -0500
Message-Id: <1423252385-3063-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
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

Sparse inode chunks allow the traditional inode btree record format to
describe an inode chunk that is not fully allocated and/or contiguous.
The granularity of a sparse chunk is defined by the the 16-bit holemask
field in the inode record. Assuming 64 inodes per full chunk, a single
holemask bit accounts for 4 inodes.

Define a constant for the number of inodes per holemask bit and a helper
function to easily detect sparse inode chunks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 6c2f1be..b2faced 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1285,6 +1285,10 @@ typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
 #define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
 
+#define XFS_INOBT_HOLEMASK_BITS		(NBBY * sizeof(__uint16_t))
+#define XFS_INODES_PER_HOLEMASK_BIT	\
+	(XFS_INODES_PER_CHUNK / (NBBY * sizeof(__uint16_t)))
+
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
 	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
@@ -1309,6 +1313,11 @@ typedef struct xfs_inobt_rec_incore {
 	xfs_inofree_t	ir_free;	/* free inode mask */
 } xfs_inobt_rec_incore_t;
 
+static inline bool xfs_inobt_issparse(uint16_t holemask)
+{
+	/* non-zero holemask represents a sparse rec. */
+	return holemask;
+}
 
 /*
  * Key structure
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
