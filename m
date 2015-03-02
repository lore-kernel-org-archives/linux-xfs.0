Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 878AF7F60
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 07:28:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5617230404E
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 05:28:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RZ6o0MDJLuRhghfa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 05:28:10 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22DS9CN029649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:09 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t22DS9lu012626
	for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 09/18] xfs: use actual inode count for sparse records in
	bulkstat/inumbers
Date: Mon,  2 Mar 2015 08:27:59 -0500
Message-Id: <1425302888-4962-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
References: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
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

The bulkstat and inumbers mechanisms make the assumption that inode
records consist of a full 64 inode chunk in several places. For example,
this is used to track how many inodes have been processed overall as
well as to determine whether a record has allocated inodes that must be
handled.

This assumption is invalid for sparse inode records. While sparse inodes
will be marked as free in the ir_free mask, they are not accounted as
free in ir_freecount because they cannot be allocated. Therefore,
ir_freecount may be less than 64 inodes in an inode record for which all
physically allocated inodes are free (and in turn ir_freecount < 64 does
not signify that the record has allocated inodes).

The new in-core inobt record format includes the ir_count field. This
holds the number of true, physical inodes tracked by the record. The
in-core ir_count field is always valid as it is hardcoded to
XFS_INODES_PER_CHUNK when sparse inodes is not enabled. Use ir_count to
handle inode records correctly in bulkstat in a generic manner.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_itable.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 8042989..f41b0c3 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -252,7 +252,7 @@ xfs_bulkstat_grab_ichunk(
 		}
 
 		irec->ir_free |= xfs_inobt_maskn(0, idx);
-		*icount = XFS_INODES_PER_CHUNK - irec->ir_freecount;
+		*icount = irec->ir_count - irec->ir_freecount;
 	}
 
 	return 0;
@@ -415,6 +415,8 @@ xfs_bulkstat(
 				goto del_cursor;
 			if (icount) {
 				irbp->ir_startino = r.ir_startino;
+				irbp->ir_holemask = r.ir_holemask;
+				irbp->ir_count = r.ir_count;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
@@ -447,13 +449,15 @@ xfs_bulkstat(
 			 * If this chunk has any allocated inodes, save it.
 			 * Also start read-ahead now for this chunk.
 			 */
-			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
+			if (r.ir_freecount < r.ir_count) {
 				xfs_bulkstat_ichunk_ra(mp, agno, &r);
 				irbp->ir_startino = r.ir_startino;
+				irbp->ir_holemask = r.ir_holemask;
+				irbp->ir_count = r.ir_count;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
-				icount += XFS_INODES_PER_CHUNK - r.ir_freecount;
+				icount += r.ir_count - r.ir_freecount;
 			}
 			error = xfs_btree_increment(cur, 0, &stat);
 			if (error || stat == 0) {
@@ -599,8 +603,7 @@ xfs_inumbers(
 		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
 		buffer[bufidx].xi_startino =
 			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
-		buffer[bufidx].xi_alloccount =
-			XFS_INODES_PER_CHUNK - r.ir_freecount;
+		buffer[bufidx].xi_alloccount = r.ir_count - r.ir_freecount;
 		buffer[bufidx].xi_allocmask = ~r.ir_free;
 		if (++bufidx == bcount) {
 			long	written;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
