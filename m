Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4DBF37F58
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:32:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFEFBAC009
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:32:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Fk6dCBFRoDG2v1u9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:32:35 -0700 (PDT)
Subject: [PATCH 02/11] libxfs: verifier should set buffer error when da
	block has a bad magic number
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:32:33 -0700
Message-ID: <20150826003233.23973.47226.stgit@birch.djwong.org>
In-Reply-To: <20150826003220.23973.59731.stgit@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
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

If xfs_da3_node_read_verify() doesn't recognize the magic number of a
buffer it's just read, set the buffer error to -EFSCORRUPTED so that
the error can be sent up to userspace.  Without this patch we'll
notice the bad magic eventually while trying to traverse or change
the block, but we really ought to fail early in the verifier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_da_btree.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index c874164..289dc1e 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -229,6 +229,7 @@ xfs_da3_node_read_verify(
 			bp->b_ops->verify_read(bp);
 			return;
 		default:
+			xfs_buf_ioerror(bp, -EFSCORRUPTED);
 			break;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
