Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E10357F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 23:06:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E2BFAC007
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 21:06:23 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XMVTIaq0vynXQNVx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 21:06:18 -0700 (PDT)
Date: Mon, 24 Aug 2015 21:06:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: libxfs: verifier should set buffer error when da block has a bad
	magic number
Message-ID: <20150825040609.GT10043@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

If xfs_da3_node_read_verify() doesn't recognize the magic number of a
buffer it's just read, set the buffer error to -EFSCORRUPTED so that
the error can be sent up to userspace.  Without this patch we'll
ASSERT on the bad magic eventually while trying to traverse or change
the block, but we really ought to fail fast in the verifier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 2385f8c..ec4a5a1 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -238,6 +238,7 @@ xfs_da3_node_read_verify(
 
 	/* corrupt block */
 	xfs_verifier_error(bp);
+	xfs_buf_ioerror(bp, -EFSCORRUPTED);
 }
 
 const struct xfs_buf_ops xfs_da3_node_buf_ops = {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
