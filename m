Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D6E97F50
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:16:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5B7E30405F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 08:16:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xziAgKnllxeOb3YL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 08:16:09 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OFG8MB020274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 11:16:08 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAdt017005
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 05/18] xfs: create macros/helpers for dealing with sparse
	inode chunks
Date: Thu, 24 Jul 2014 10:22:55 -0400
Message-Id: <1406211788-63206-6-git-send-email-bfoster@redhat.com>
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

Sparse inode chunks allow the traditional inode btree record format to
describe an inode chunk that is not fully allocated and/or contiguous.
Define a couple constants that set requirements for allocation and
management of such chunks. Also define a helper to easily detect sparse
inode chunks.

The granularity of a sparse chunk is defined by the the 16-bit holemask
field in the inode record. Assuming 64 inodes per full chunk, a single
holemask bit accounts for 4 inodes. The minimum allocation requirement
for a sparse inode chunk is defined as the minimum number of blocks
required to meet the 4 inode granularity.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 39022d9..0baad50 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -211,6 +211,11 @@ typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
 #define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
 
+#define XFS_INODES_PER_SPCHUNK		\
+	(XFS_INODES_PER_CHUNK / (NBBY * sizeof(__uint16_t)))
+#define XFS_INOBT_MIN_SPCHUNKLEN(sb)	\
+	(roundup(XFS_INODES_PER_SPCHUNK, sb.sb_inopblock) / sb.sb_inopblock)
+
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
 	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
@@ -234,6 +239,10 @@ typedef struct xfs_inobt_rec_incore {
 	xfs_inofree_t	ir_free;	/* free inode mask */
 } xfs_inobt_rec_incore_t;
 
+static inline bool xfs_inobt_issparse(struct xfs_inobt_rec_incore *rec)
+{
+	return rec->ir_holemask == 0 ? false : true;
+}
 
 /*
  * Key structure
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
