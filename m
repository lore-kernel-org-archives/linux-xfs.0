Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 472D17F3F
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 20:24:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCD70AC001
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 18:24:12 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GnjgyJZ48RgRvc6d for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 18:24:11 -0800 (PST)
Message-ID: <52F83849.4040209@sandeen.net>
Date: Sun, 09 Feb 2014 20:24:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/6] xfs: skip pointless CRC updates after verifier failures
References: <52F83630.4020008@redhat.com>
In-Reply-To: <52F83630.4020008@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Most write verifiers don't update CRCs after the verifier
has failed and the buffer has been marked in error.  These
two didn't, but should.

Add returns to the verifier failure block, 
since the buffer won't be written anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_alloc_btree.c  |    1 +
 fs/xfs/xfs_ialloc_btree.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 1308542..144d3b0 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -373,6 +373,7 @@ xfs_allocbt_write_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
 
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index c8fa5bb..0028c50 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -261,6 +261,7 @@ xfs_inobt_write_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
 
-- 1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
