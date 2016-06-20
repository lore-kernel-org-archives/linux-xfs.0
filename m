Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E8747CB1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 12:12:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3D35304048
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 10:12:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p4pHsfo6gDQDmrp9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 10:12:06 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 0B0E9A1288
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 17:12:06 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-179.bos.redhat.com [10.18.41.179])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5KHC5LA009623
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 13:12:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/3] xfs: inobt record insert/delete tracepoints
Date: Mon, 20 Jun 2016 13:12:04 -0400
Message-Id: <1466442724-13544-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1466442724-13544-1-git-send-email-bfoster@redhat.com>
References: <1466442724-13544-1-git-send-email-bfoster@redhat.com>
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

Add tracepoints for inobt record insert and delete. Be sure to
distinguish between the inobt and finobt in the tracepoints as the
record lifecycles differ between the trees.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 16 +++++++++++++---
 fs/xfs/xfs_trace.h         | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fdaeee8..114b020 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -186,6 +186,8 @@ xfs_inobt_insert(
 		}
 		ASSERT(i == 0);
 
+		trace_xfs_irec_insert(mp, btnum, agno, thisino,
+				      XFS_INODES_PER_CHUNK);
 		error = xfs_inobt_insert_rec(cur, XFS_INOBT_HOLEMASK_FULL,
 					     XFS_INODES_PER_CHUNK,
 					     XFS_INODES_PER_CHUNK,
@@ -234,6 +236,8 @@ xfs_inobt_delete(
 		XFS_WANT_CORRUPTED_GOTO(mp, rec.ir_startino == agino,
 					out_error);
 
+		trace_xfs_irec_delete(mp, cur->bc_btnum, agno, rec.ir_startino,
+				      rec.ir_count);
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto out_error;
@@ -729,6 +733,8 @@ xfs_inobt_insert_sprec(
 		goto error;
 	/* if nothing there, insert a new record and return */
 	if (i == 0) {
+		trace_xfs_irec_insert(mp, btnum, agno, nrec->ir_startino,
+				      nrec->ir_count);
 		error = xfs_inobt_insert_rec(cur, nrec->ir_holemask,
 					     nrec->ir_count, nrec->ir_freecount,
 					     nrec->ir_free, &i);
@@ -1789,10 +1795,13 @@ xfs_dialloc_ag(
 	 */
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
-	if (rec.ir_freecount)
+	if (rec.ir_freecount) {
 		error = xfs_inobt_update(cur, &rec);
-	else
+	} else {
+		trace_xfs_irec_delete(mp, cur->bc_btnum, agno, rec.ir_startino,
+				      rec.ir_count);
 		error = xfs_btree_delete(cur, &i);
+	}
 	if (error)
 		goto error_cur;
 
@@ -2261,7 +2270,8 @@ xfs_difree_finobt(
 		 * something is out of sync.
 		 */
 		XFS_WANT_CORRUPTED_GOTO(mp, ibtrec->ir_freecount == 1, error);
-
+		trace_xfs_irec_insert(mp, cur->bc_btnum, agno,
+				      ibtrec->ir_startino, ibtrec->ir_count);
 		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
 					     ibtrec->ir_count,
 					     ibtrec->ir_freecount,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ea94ee0..3e27cdc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -786,6 +786,38 @@ TRACE_EVENT(xfs_irec_merge_post,
 		  __entry->holemask)
 )
 
+DECLARE_EVENT_CLASS(xfs_irec_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agnumber_t agno,
+		 xfs_agino_t agino, int count),
+	TP_ARGS(mp, btnum, agno, agino, count),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(int, count)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->btnum = btnum;
+		__entry->agno = agno;
+		__entry->agino = agino;
+		__entry->count = count;
+	),
+	TP_printk("dev %d:%d %s agno %d agino 0x%x count %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->btnum == XFS_BTNUM_INOi ? "ibt" : "fibt",
+		  __entry->agno, __entry->agino, __entry->count)
+)
+
+#define DEFINE_IREC_EVENT(name) \
+DEFINE_EVENT(xfs_irec_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agnumber_t agno, \
+		 xfs_agino_t agino, int count), \
+	TP_ARGS(mp, btnum, agno, agino, count))
+DEFINE_IREC_EVENT(xfs_irec_insert);
+DEFINE_IREC_EVENT(xfs_irec_delete);
+
 #define DEFINE_IREF_EVENT(name) \
 DEFINE_EVENT(xfs_iref_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
