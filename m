Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2E3F7F89
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23B4FAC00E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tFYv1StbY6YwvqsM for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:39 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048B-FP
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-00020K-Du
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
Date: Fri, 19 Jul 2013 16:25:15 +1000
Message-Id: <1374215120-7271-45-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Now that we have the size of the object before the formatting pass
is called, we can allocation the log vector and it's buffer in a
single allocation rather than two separate allocations.

Store the size of the allocated buffer in the log vector so that
we potentially avoid allocation for future modifications of the
object.

While touching this code, remove the IOP_FORMAT definition.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.h     |  1 +
 fs/xfs/xfs_log_cil.c | 94 ++++++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_trans.h   |  1 -
 3 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e63d9e1..1c45848 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -27,6 +27,7 @@ struct xfs_log_vec {
 	struct xfs_log_item	*lv_item;	/* owner */
 	char			*lv_buf;	/* formatted buffer */
 	int			lv_buf_len;	/* size of formatted buffer */
+	int			lv_size;	/* size of allocated lv */
 };
 
 #define XFS_LOG_VEC_ORDERED	(-1)
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4e10872..08943c8 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -80,6 +80,35 @@ xlog_cil_init_post_recovery(
 								log->l_curr_block);
 }
 
+STATIC void
+xlog_cil_lv_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	int	index;
+	char	*ptr;
+
+	/* format new vectors into array */
+	lip->li_ops->iop_format(lip, lv->lv_iovecp);
+
+	/* copy data into existing array */
+	ptr = lv->lv_buf;
+	for (index = 0; index < lv->lv_niovecs; index++) {
+		struct xfs_log_iovec *vec = &lv->lv_iovecp[index];
+
+		memcpy(ptr, vec->i_addr, vec->i_len);
+		vec->i_addr = ptr;
+		ptr += vec->i_len;
+	}
+
+	/*
+	 * some size calculations for log vectors over-estimate, so we'll see
+	 * this as not using the entire buffer here. Hence just check ofr
+	 * overruns on debug kernels.
+	 */
+	ASSERT(ptr > lv->lv_buf && ptr <= lv->lv_buf + lv->lv_buf_len);
+}
+
 /*
  * Format log item into a flat buffers
  *
@@ -111,7 +140,7 @@ xlog_cil_prepare_log_vecs(
 	struct xfs_trans	*tp)
 {
 	struct xfs_log_item_desc *lidp;
-	struct xfs_log_vec	*lv = NULL;
+	struct xfs_log_vec	*prev_lv = NULL;
 	struct xfs_log_vec	*ret_lv = NULL;
 
 
@@ -123,12 +152,10 @@ xlog_cil_prepare_log_vecs(
 
 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		struct xfs_log_item *lip = lidp->lid_item;
-		struct xfs_log_vec *new_lv;
-		void	*ptr;
-		int	index;
-		int	len = 0;
-		uint	niovecs = 0;
-		uint	nbytes = 0;
+		struct xfs_log_vec *lv;
+		int	niovecs = 0;
+		int	nbytes = 0;
+		int	buf_size;
 		bool	ordered = false;
 
 		/* Skip items which aren't dirty in this transaction. */
@@ -150,48 +177,39 @@ xlog_cil_prepare_log_vecs(
 		if (niovecs == XFS_LOG_VEC_ORDERED) {
 			ordered = true;
 			niovecs = 0;
+			nbytes = 0;
 		}
 
-		new_lv = kmem_zalloc(sizeof(*new_lv) +
-				niovecs * sizeof(struct xfs_log_iovec),
-				KM_SLEEP|KM_NOFS);
+		/* calc buffer size */
+		buf_size = sizeof(struct xfs_log_vec) + nbytes +
+				niovecs * sizeof(struct xfs_log_iovec);
 
-		new_lv->lv_item = lip;
-		new_lv->lv_niovecs = niovecs;
+		/* allocate new data chunk */
+		lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
+		lv->lv_item = lip;
+		lv->lv_size = buf_size;
+		lv->lv_niovecs = niovecs;
 		if (ordered) {
 			/* track as an ordered logvec */
-			new_lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
-			goto next;
+			ASSERT(lip->li_lv == NULL);
+			lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
+			goto insert;
 		}
 
 		/* The allocated iovec region lies beyond the log vector. */
-		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
-
-		/* build the vector array and calculate it's length */
-		IOP_FORMAT(new_lv->lv_item, new_lv->lv_iovecp);
-		for (index = 0; index < new_lv->lv_niovecs; index++)
-			len += new_lv->lv_iovecp[index].i_len;
+		lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
 
-		new_lv->lv_buf_len = len;
-		new_lv->lv_buf = kmem_alloc(new_lv->lv_buf_len,
-				KM_SLEEP|KM_NOFS);
-		ptr = new_lv->lv_buf;
-
-		for (index = 0; index < new_lv->lv_niovecs; index++) {
-			struct xfs_log_iovec *vec = &new_lv->lv_iovecp[index];
-
-			memcpy(ptr, vec->i_addr, vec->i_len);
-			vec->i_addr = ptr;
-			ptr += vec->i_len;
-		}
-		ASSERT(ptr == new_lv->lv_buf + new_lv->lv_buf_len);
+		/* The allocated data region lies beyond the iovec region */
+		lv->lv_buf = (char *)lv + buf_size - nbytes;
+		lv->lv_buf_len = nbytes;
 
-next:
+		xlog_cil_lv_item_format(lip, lv);
+insert:
 		if (!ret_lv)
-			ret_lv = new_lv;
+			ret_lv = lv;
 		else
-			lv->lv_next = new_lv;
-		lv = new_lv;
+			prev_lv->lv_next = lv;
+		prev_lv = lv;
 	}
 
 	return ret_lv;
@@ -228,7 +246,6 @@ xfs_cil_prepare_item(
 
 		*len += lv->lv_buf_len - old->lv_buf_len;
 		*diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
-		kmem_free(old->lv_buf);
 		kmem_free(old);
 	} else {
 		/* new lv, must pin the log item */
@@ -354,7 +371,6 @@ xlog_cil_free_logvec(
 
 	for (lv = log_vector; lv; ) {
 		struct xfs_log_vec *next = lv->lv_next;
-		kmem_free(lv->lv_buf);
 		kmem_free(lv);
 		lv = next;
 	}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 97144ec..24bbdcd 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,7 +77,6 @@ struct xfs_item_ops {
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 };
 
-#define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
 #define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
 #define IOP_PUSH(ip, list)	(*(ip)->li_ops->iop_push)(ip, list)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
