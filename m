Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CF157F66
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EEF48F808E
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EUXXZtDnC4p6DCr8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:04 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id C879A8E4ED
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig3dF016920
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 01/28] xfs: create individual inode alloc. helper
Date: Tue,  2 Jun 2015 14:41:34 -0400
Message-Id: <1433270521-62026-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

Inode allocation from sparse inode records must filter the ir_free mask
against ir_holemask.  In preparation for this requirement, create a
helper to allocate an individual inode from an inode record.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_ialloc.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 2b4e4e0..a1cf1dd 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -727,6 +727,16 @@ xfs_ialloc_get_rec(
 }
 
 /*
+ * Return the offset of the first free inode in the record.
+ */
+STATIC int
+xfs_inobt_first_free_inode(
+	struct xfs_inobt_rec_incore	*rec)
+{
+	return xfs_lowbit64(rec->ir_free);
+}
+
+/*
  * Allocate an inode using the inobt-only algorithm.
  */
 STATIC int
@@ -956,7 +966,7 @@ newino:
 	}
 
 alloc_inode:
-	offset = xfs_lowbit64(rec.ir_free);
+	offset = xfs_inobt_first_free_inode(&rec);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
@@ -1205,7 +1215,7 @@ xfs_dialloc_ag(
 	if (error)
 		goto error_cur;
 
-	offset = xfs_lowbit64(rec.ir_free);
+	offset = xfs_inobt_first_free_inode(&rec);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
