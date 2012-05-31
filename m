Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VI5b3C058068 for <xfs@oss.sgi.com>; Thu, 31 May 2012 13:05:38 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id Ihzd4yNKbF4AwVxq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 May 2012 11:05:36 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] xfs: use standard (u)intptr_t types
Date: Thu, 31 May 2012 20:05:34 +0200
Message-Id: <1338487534-14575-2-git-send-email-jengelh@inai.de>
In-Reply-To: <1338487534-14575-1-git-send-email-jengelh@inai.de>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, joe@perches.com, bpm@sgi.com, linux-kernel@vger.kernel.org

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 fs/xfs/xfs_extfree_item.c |    2 +-
 fs/xfs/xfs_filestream.c   |   34 +++++++++++++++++-----------------
 fs/xfs/xfs_log.c          |   10 +++++-----
 fs/xfs/xfs_trans_ail.c    |    6 +++---
 fs/xfs/xfs_types.h        |   11 -----------
 5 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index feb36d7..2dfef98 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -239,7 +239,7 @@ xfs_efi_init(
 
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
 	efip->efi_format.efi_nextents = nextents;
-	efip->efi_format.efi_id = (__psint_t)(void*)efip;
+	efip->efi_format.efi_id = (intptr_t)(void*)efip;
 	atomic_set(&efip->efi_next_extent, 0);
 
 	return efip;
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 5170306..a05595e 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -42,24 +42,24 @@ xfs_filestreams_trace(
 	int		type,	/* type of trace */
 	const char	*func,	/* source function */
 	int		line,	/* source line number */
-	__psunsigned_t	arg0,
-	__psunsigned_t	arg1,
-	__psunsigned_t	arg2,
-	__psunsigned_t	arg3,
-	__psunsigned_t	arg4,
-	__psunsigned_t	arg5)
+	uintptr_t	arg0,
+	uintptr_t	arg1,
+	uintptr_t	arg2,
+	uintptr_t	arg3,
+	uintptr_t	arg4,
+	uintptr_t	arg5)
 {
 	ktrace_enter(xfs_filestreams_trace_buf,
-		(void *)(__psint_t)(type | (line << 16)),
+		(void *)(intptr_t)(type | (line << 16)),
 		(void *)func,
-		(void *)(__psunsigned_t)current_pid(),
+		(void *)(uintptr_t)current_pid(),
 		(void *)mp,
-		(void *)(__psunsigned_t)arg0,
-		(void *)(__psunsigned_t)arg1,
-		(void *)(__psunsigned_t)arg2,
-		(void *)(__psunsigned_t)arg3,
-		(void *)(__psunsigned_t)arg4,
-		(void *)(__psunsigned_t)arg5,
+		(void *)(uintptr_t)arg0,
+		(void *)(uintptr_t)arg1,
+		(void *)(uintptr_t)arg2,
+		(void *)(uintptr_t)arg3,
+		(void *)(uintptr_t)arg4,
+		(void *)(uintptr_t)arg5,
 		NULL, NULL, NULL, NULL, NULL, NULL);
 }
 
@@ -71,9 +71,9 @@ xfs_filestreams_trace(
 #define TRACE5(mp,t,a0,a1,a2,a3,a4)	TRACE6(mp,t,a0,a1,a2,a3,a4,0)
 #define TRACE6(mp,t,a0,a1,a2,a3,a4,a5) \
 	xfs_filestreams_trace(mp, t, __func__, __LINE__, \
-				(__psunsigned_t)a0, (__psunsigned_t)a1, \
-				(__psunsigned_t)a2, (__psunsigned_t)a3, \
-				(__psunsigned_t)a4, (__psunsigned_t)a5)
+				(uintptr_t)a0, (uintptr_t)a1, \
+				(uintptr_t)a2, (uintptr_t)a3, \
+				(uintptr_t)a4, (uintptr_t)a5)
 
 #define TRACE_AG_SCAN(mp, ag, ag2) \
 		TRACE2(mp, XFS_FSTRM_KTRACE_AGSCAN, ag, ag2);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6b965bf..70f6f73 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3382,7 +3382,7 @@ xlog_verify_iclog(xlog_t	 *log,
 	xlog_in_core_2_t	*xhdr;
 	xfs_caddr_t		ptr;
 	xfs_caddr_t		base_ptr;
-	__psint_t		field_offset;
+	intptr_t		field_offset;
 	__uint8_t		clientid;
 	int			len, i, j, k, op_len;
 	int			idx;
@@ -3421,7 +3421,7 @@ xlog_verify_iclog(xlog_t	 *log,
 		ophead = (xlog_op_header_t *)ptr;
 
 		/* clientid is only 1 byte */
-		field_offset = (__psint_t)
+		field_offset = (intptr_t)
 			       ((xfs_caddr_t)&(ophead->oh_clientid) - base_ptr);
 		if (syncing == B_FALSE || (field_offset & 0x1ff)) {
 			clientid = ophead->oh_clientid;
@@ -3444,13 +3444,13 @@ xlog_verify_iclog(xlog_t	 *log,
 				(unsigned long)field_offset);
 
 		/* check length */
-		field_offset = (__psint_t)
+		field_offset = (intptr_t)
 			       ((xfs_caddr_t)&(ophead->oh_len) - base_ptr);
 		if (syncing == B_FALSE || (field_offset & 0x1ff)) {
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
-			idx = BTOBBT((__psint_t)&ophead->oh_len -
-				    (__psint_t)iclog->ic_datap);
+			idx = BTOBBT((intptr_t)&ophead->oh_len -
+				    (intptr_t)iclog->ic_datap);
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9c51448..def28e0 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -187,7 +187,7 @@ xfs_trans_ail_cursor_next(
 {
 	struct xfs_log_item	*lip = cur->item;
 
-	if ((__psint_t)lip & 1)
+	if ((intptr_t)lip & 1)
 		lip = xfs_ail_min(ailp);
 	if (lip)
 		cur->item = xfs_ail_next(ailp, lip);
@@ -225,7 +225,7 @@ xfs_trans_ail_cursor_clear(
 	list_for_each_entry(cur, &ailp->xa_cursors, list) {
 		if (cur->item == lip)
 			cur->item = (struct xfs_log_item *)
-					((__psint_t)cur->item | 1);
+					((intptr_t)cur->item | 1);
 	}
 }
 
@@ -316,7 +316,7 @@ xfs_ail_splice(
 	 * find the place in the AIL where the items belong.
 	 */
 	lip = cur ? cur->item : NULL;
-	if (!lip || (__psint_t) lip & 1)
+	if (!lip || (intptr_t)lip & 1)
 		lip = __xfs_trans_ail_cursor_last(ailp, lsn);
 
 	/*
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index 398cf68..7e0639a 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -43,17 +43,6 @@ typedef char *			xfs_caddr_t;	/* <core address> type */
 typedef __u32			xfs_dev_t;
 typedef __u32			xfs_nlink_t;
 
-/* __psint_t is the same size as a pointer */
-#if (BITS_PER_LONG == 32)
-typedef __int32_t __psint_t;
-typedef __uint32_t __psunsigned_t;
-#elif (BITS_PER_LONG == 64)
-typedef __int64_t __psint_t;
-typedef __uint64_t __psunsigned_t;
-#else
-#error BITS_PER_LONG must be 32 or 64
-#endif
-
 #endif	/* __KERNEL__ */
 
 typedef __uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
