Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD5727CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 22:46:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C483AC003
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:46:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id WkjebfEonaPm9l9O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:46:36 -0700 (PDT)
Date: Mon, 29 Aug 2016 20:46:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: pass the inode cluster offset when copying inodes
Message-ID: <20160830034631.GL22760@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

In copy_inode_chunk, we try to determine whether or not an inode is
free as part of copying the inode records.  The macros involved in
testing ir_free require both the inode record and the offset of an
inode within that chunk.  Prior to sparse inode support, the loop
index "i" was also the inode chunk offset; however, when sparse
support was added, "i" became the inode offset within a cluster and
"ioff" became the inode cluster offset within an inode chunk.
Therefore, it is necessary to pass "ioff + i" to do the free-ness
calculation correctly.

This was discovered while trying to take metadumps of fs images for
scrub testing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index e82b660..c769958 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2292,7 +2292,7 @@ copy_inode_chunk(
 
 			/* process_inode handles free inodes, too */
 			if (!process_inode(agno, agino + ioff + i, dip,
-			    XFS_INOBT_IS_FREE_DISK(rp, i)))
+			    XFS_INOBT_IS_FREE_DISK(rp, ioff + i)))
 				goto pop_out;
 
 			inodes_copied++;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
