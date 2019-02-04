Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbfBDR7g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 12:59:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x14HnGug038830
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:35 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qd98mxq90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Feb 2019 17:59:34 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x14HxS9d024815
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:29 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x14HxSRr024198
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:28 GMT
Subject: [PATCH 04/10] xfs: refactor AGI unlinked bucket updates
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Feb 2019 09:59:27 -0800
Message-ID: <154930316722.31814.1440085628512350921.stgit@magnolia>
In-Reply-To: <154930313674.31814.17994684613232167921.stgit@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Split the AGI unlinked bucket updates into a separate function.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   66 +++++++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_trace.h |   26 ++++++++++++++++++++
 2 files changed, 73 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 435901c7c674..8c4a1d198de8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1880,6 +1880,43 @@ xfs_inactive(
 	xfs_qm_dqdetach(ip);
 }
 
+/*
+ * Point the AGI unlinked bucket at an inode and log the results.  The caller
+ * is responsible for validating the old value.
+ */
+STATIC int
+xfs_iunlink_update_bucket(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agibp,
+	unsigned int		bucket_index,
+	xfs_agino_t		new_agino)
+{
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agibp);
+	xfs_agino_t		old_value;
+	int			offset;
+
+	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
+
+	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
+			old_value, new_agino);
+
+	/*
+	 * We should never find the head of the list already set to the value
+	 * passed in because either we're adding or removing ourselves from the
+	 * head of the list.
+	 */
+	if (old_value == new_agino)
+		return -EFSCORRUPTED;
+
+	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
+	offset = offsetof(struct xfs_agi, agi_unlinked) +
+			(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	return 0;
+}
+
 /*
  * This is called when the inode's link count goes to 0 or we are creating a
  * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
@@ -1949,15 +1986,10 @@ xfs_iunlink(
 		xfs_inobp_check(mp, ibp);
 	}
 
-	/*
-	 * Point the bucket head pointer at the inode being inserted.
-	 */
-	ASSERT(agino != 0);
-	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
-	offset = offsetof(xfs_agi_t, agi_unlinked) +
-		(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_log_buf(tp, agibp, offset,
-			  (offset + sizeof(xfs_agino_t) - 1));
+	/* Point the head of the list to point to this inode. */
+	error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
+	if (error)
+		goto out;
 	pag->pagi_unlinked_count++;
 out:
 	xfs_perag_put(pag);
@@ -2041,16 +2073,12 @@ xfs_iunlink_remove(
 		} else {
 			xfs_trans_brelse(tp, ibp);
 		}
-		/*
-		 * Point the bucket head pointer at the next inode.
-		 */
-		ASSERT(next_agino != 0);
-		ASSERT(next_agino != agino);
-		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
-		offset = offsetof(xfs_agi_t, agi_unlinked) +
-			(sizeof(xfs_agino_t) * bucket_index);
-		xfs_trans_log_buf(tp, agibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
+
+		/* Point the head of the list to the next unlinked inode. */
+		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
+				next_agino);
+		if (error)
+			goto out;
 	} else {
 		/*
 		 * We need to search the list for the inode being freed.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6fcc893dfc91..c10478e7e49a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3371,6 +3371,32 @@ DEFINE_TRANS_EVENT(xfs_trans_roll);
 DEFINE_TRANS_EVENT(xfs_trans_add_item);
 DEFINE_TRANS_EVENT(xfs_trans_free_items);
 
+TRACE_EVENT(xfs_iunlink_update_bucket,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int bucket,
+		 xfs_agino_t old_ptr, xfs_agino_t new_ptr),
+	TP_ARGS(mp, agno, bucket, old_ptr, new_ptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, bucket)
+		__field(xfs_agino_t, old_ptr)
+		__field(xfs_agino_t, new_ptr)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->bucket = bucket;
+		__entry->old_ptr = old_ptr;
+		__entry->new_ptr = new_ptr;
+	),
+	TP_printk("dev %d:%d agno %u bucket %u old 0x%x new 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bucket,
+		  __entry->old_ptr,
+		  __entry->new_ptr)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
