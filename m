Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 935F47F50
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:43:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62207304051
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:43:53 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OBHY0vUIIrPvzA53 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:43:49 -0700 (PDT)
Subject: [PATCH 01/10] libxfs: readahead of dir3 data blocks should use the
	read verifier
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:43:44 -0700
Message-ID: <20150815014344.1839.12045.stgit@birch.djwong.org>
In-Reply-To: <20150815014338.1839.37405.stgit@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
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

In the dir3 data block readahead function, use the regular read
verifier to check the block's CRC and spot-check the block contents
instead of calling the spot-checking routine directly.  This prevents
corrupted directory data blocks from being read into the kernel, which
can lead to garbage ls output and directory loops (if say one of the
entries contains invalid characters).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_dir2_data.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index c475ba8..466e096 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -250,7 +250,8 @@ xfs_dir3_data_reada_verify(
 		return;
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
-		xfs_dir3_data_verify(bp);
+		bp->b_ops = &xfs_dir3_block_buf_ops;
+		bp->b_ops->verify_read(bp);
 		return;
 	default:
 		xfs_buf_ioerror(bp, -EFSCORRUPTED);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
