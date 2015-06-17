Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CBEF7F9D
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:57:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 029BE8F8066
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:57:28 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LZiMCo1EY3qwh7O4 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:57:26 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5B25-0003YB-OL
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:57:26 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] xfs: remove __psint_t and __psunsigned_t
Date: Wed, 17 Jun 2015 12:55:28 +0200
Message-Id: <1434538532-6566-2-git-send-email-hch@lst.de>
In-Reply-To: <1434538532-6566-1-git-send-email-hch@lst.de>
References: <1434538532-6566-1-git-send-email-hch@lst.de>
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

Replace uses of __psint_t with the proper uintptr_t and ptrdiff_t types,
and remove the defintions of __psint_t and __psunsigned_t.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c |  2 +-
 fs/xfs/xfs_linux.h        | 11 -----------
 fs/xfs/xfs_log.c          | 10 +++++-----
 fs/xfs/xfs_trans_ail.c    |  6 +++---
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index cb7fe64..adc8f8f 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -239,7 +239,7 @@ xfs_efi_init(
 
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
 	efip->efi_format.efi_nextents = nextents;
-	efip->efi_format.efi_id = (__psint_t)(void*)efip;
+	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
 	atomic_set(&efip->efi_next_extent, 0);
 	atomic_set(&efip->efi_refcount, 2);
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 7c7842c..1637a95 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -41,17 +41,6 @@ typedef char *			xfs_caddr_t;	/* <core address> type */
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
 #include "xfs_types.h"
 
 #include "kmem.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c8d09ef..68e22b6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3766,7 +3766,7 @@ xlog_verify_iclog(
 	xlog_in_core_2_t	*xhdr;
 	xfs_caddr_t		ptr;
 	xfs_caddr_t		base_ptr;
-	__psint_t		field_offset;
+	ptrdiff_t		field_offset;
 	__uint8_t		clientid;
 	int			len, i, j, k, op_len;
 	int			idx;
@@ -3803,7 +3803,7 @@ xlog_verify_iclog(
 		ophead = (xlog_op_header_t *)ptr;
 
 		/* clientid is only 1 byte */
-		field_offset = (__psint_t)
+		field_offset = (ptrdiff_t)
 			       ((xfs_caddr_t)&(ophead->oh_clientid) - base_ptr);
 		if (!syncing || (field_offset & 0x1ff)) {
 			clientid = ophead->oh_clientid;
@@ -3826,13 +3826,13 @@ xlog_verify_iclog(
 				(unsigned long)field_offset);
 
 		/* check length */
-		field_offset = (__psint_t)
+		field_offset = (ptrdiff_t)
 			       ((xfs_caddr_t)&(ophead->oh_len) - base_ptr);
 		if (!syncing || (field_offset & 0x1ff)) {
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
-			idx = BTOBBT((__psint_t)&ophead->oh_len -
-				    (__psint_t)iclog->ic_datap);
+			idx = BTOBBT((uintptr_t)&ophead->oh_len -
+				    (uintptr_t)iclog->ic_datap);
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 573aefb..1098cf4 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -159,7 +159,7 @@ xfs_trans_ail_cursor_next(
 {
 	struct xfs_log_item	*lip = cur->item;
 
-	if ((__psint_t)lip & 1)
+	if ((uintptr_t)lip & 1)
 		lip = xfs_ail_min(ailp);
 	if (lip)
 		cur->item = xfs_ail_next(ailp, lip);
@@ -196,7 +196,7 @@ xfs_trans_ail_cursor_clear(
 	list_for_each_entry(cur, &ailp->xa_cursors, list) {
 		if (cur->item == lip)
 			cur->item = (struct xfs_log_item *)
-					((__psint_t)cur->item | 1);
+					((uintptr_t)cur->item | 1);
 	}
 }
 
@@ -287,7 +287,7 @@ xfs_ail_splice(
 	 * find the place in the AIL where the items belong.
 	 */
 	lip = cur ? cur->item : NULL;
-	if (!lip || (__psint_t) lip & 1)
+	if (!lip || (uintptr_t)lip & 1)
 		lip = __xfs_trans_ail_cursor_last(ailp, lsn);
 
 	/*
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
