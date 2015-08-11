Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CD4D7F50
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 18:50:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 296118F8035
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 16:50:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KZ2wOngBFJNEPAFz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 16:50:41 -0700 (PDT)
Date: Tue, 11 Aug 2015 16:50:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: readahead of dir3 data blocks should use the read
	verifier
Message-ID: <20150811235038.GL10043@birch.djwong.org>
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

In the dir3 data block readahead function, use the regular read
verifier to check the block's CRC and spot-check the block contents
instead of directly calling only the spot-checking routine.  This
prevents corrupted directory data blocks from being read into the
kernel, which can lead to garbage ls output and directory loops (if
say one of the entries contains slashes and other junk).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index de1ea16..534bbf2 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -252,7 +252,8 @@ xfs_dir3_data_reada_verify(
 		return;
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
-		xfs_dir3_data_verify(bp);
+		bp->b_ops = &xfs_dir3_data_buf_ops;
+		bp->b_ops->verify_read(bp);
 		return;
 	default:
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
