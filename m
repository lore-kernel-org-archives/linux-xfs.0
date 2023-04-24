Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C653FC77B61
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 22:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjDXWvI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjDXWvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 18:51:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4177694
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 15:51:06 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33OKhvXx013537
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 22:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=O5Hn3MxjDnBnK+lHjho/BLrzYpIzYb0NuJ+dv2FXZ2I=;
 b=v3NNeUoAXIFtVWiF7kfynKv34x3bItvbKxiF1ASi8Wnb3FAzoc5UdJYV1TPfz5s8a6Gv
 aNIh9Y5A5hBMciInS/Kt6abYvkI+Rmb525C+ejhj9CbKSDgeC6ELNaUOSWpXfQgjb4ai
 4SMUecVaxrJRPRGrc7sdRY5W4HMdf0DRxziMIf85YqvYlFH1ultoT5D97kx95MxLnhtn
 ewQci4snjbajoIQB+jycwqvAthKidCft6kwOXqimQJ1E+p4tyIiXHDTCiOSdpjLKZZo5
 Kipp87no5CdaSP/jjxo9JlMxH0te/TH8T/QOmYGfAHOBNjBD5xeGHQCrGLQ2f9qotj8u wA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q47mcv39b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 22:51:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33OKOYm2032837
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 22:51:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q4615wkyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 22:51:04 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33OMp3u2023985
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 22:51:03 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-158-90.vpn.oracle.com [10.159.158.90])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3q4615wky2-1;
        Mon, 24 Apr 2023 22:51:03 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH] xfs: avoid freeing multiple extents from same AG in pending transactions
Date:   Mon, 24 Apr 2023 15:51:02 -0700
Message-Id: <20230424225102.23402-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_11,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304240207
X-Proofpoint-GUID: IJgCJ4g2En6BAfqi8nkni7LPPh-4S_0A
X-Proofpoint-ORIG-GUID: IJgCJ4g2En6BAfqi8nkni7LPPh-4S_0A
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To avoid possible deadlock when allocating AGFL blocks, change the behaviour.
The orignal hehaviour for freeing extents in an EFI is that the extents in
the EFI were processed one by one in the same transaction. When the second
and subsequent extents are being processed, we have produced busy extents for
previous extents. If the second and subsequent extents are from the same AG
as the busy extents are, we have the risk of deadlock when allocating AGFL
blocks. A typical calltrace for the deadlock is like this:

	#0	context_switch() kernel/sched/core.c:3881
	#1	__schedule() kernel/sched/core.c:5111
	#2	schedule() kernel/sched/core.c:5186
	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
	#17	mount_bdev() fs/super.c:1417
	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
	#19	legacy_get_tree() fs/fs_context.c:647
	#20	vfs_get_tree() fs/super.c:1547
	#21	do_new_mount() fs/namespace.c:2843
	#22	do_mount() fs/namespace.c:3163
	#23	ksys_mount() fs/namespace.c:3372
	#24	__do_sys_mount() fs/namespace.c:3386
	#25	__se_sys_mount() fs/namespace.c:3383
	#26	__x64_sys_mount() fs/namespace.c:3383
	#27	do_syscall_64() arch/x86/entry/common.c:296
	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180

The deadlock could happen at both IO time and log recover time.

To avoid above deadlock, this patch changes the extent free procedure.
1) it always let the first extent from the EFI go (no change).
2) increase the (new) AG counter when it let a extent go.
3) for the 2nd+ extents, if the owning AGs ready have pending extents
   don't let the extent go with current transaction. Instead, move the
   extent in question and subsequent extents to a new EFI and try the new
   EFI again with new transaction (by rolling current transaction).
4) for the EFD to orginal EFI, fill it with all the extents from the original
   EFI.
5) though the new EFI is placed after original EFD, it's safe as they are in
   same in-memory transaction.
6) The new AG counter for pending extent freeings is decremented after the
   log items in in-memory transaction is committed to CIL.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c    |   1 +
 fs/xfs/libxfs/xfs_ag.h    |   5 ++
 fs/xfs/xfs_extfree_item.c | 111 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log_cil.c      |  24 ++++++++-
 4 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 86696a1c6891..61ef61e05668 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -378,6 +378,7 @@ xfs_initialize_perag(
 		pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
 
+		atomic_set(&pag->pag_nr_pending_extents, 0);
 		error = xfs_buf_hash_init(pag);
 		if (error)
 			goto out_remove_pag;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 5e18536dfdce..5950bc36a32c 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -82,6 +82,11 @@ struct xfs_perag {
 	uint16_t	pag_sick;
 	spinlock_t	pag_state_lock;
 
+	/*
+	 * Number of concurrent extent freeings (not committed to CIL yet)
+	 * on this AG.
+	 */
+	atomic_t	pag_nr_pending_extents;
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
 	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
 	unsigned int	pagb_gen;	/* generation count for pagb_tree */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 011b50469301..1dbf36d9c1c9 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -336,6 +336,75 @@ xfs_trans_get_efd(
 	return efdp;
 }
 
+/*
+ * Fill the EFD with all extents from the EFI and set the counter.
+ * Note: the EFD should comtain at least one extents already.
+ */
+static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
+{
+	struct xfs_efi_log_item	*efip = efdp->efd_efip;
+	uint			i;
+
+	i = efdp->efd_next_extent;
+	ASSERT(i > 0);
+	for (; i < efip->efi_format.efi_nextents; i++) {
+		efdp->efd_format.efd_extents[i] =
+			efip->efi_format.efi_extents[i];
+	}
+	efdp->efd_next_extent = i;
+}
+
+/*
+ * Check if xefi is the first in the efip.
+ * Returns true if so, ad false otherwise
+ */
+static bool xfs_is_first_extent_in_efi(struct xfs_efi_log_item *efip,
+				  struct xfs_extent_free_item *xefi)
+{
+	return efip->efi_format.efi_extents[0].ext_start ==
+					xefi->xefi_startblock;
+}
+
+/*
+ * Check if the xefi needs to be in a new transaction.
+ * efip is the containing EFI of xefi.
+ * Return true if so, false otherwise.
+ */
+static bool xfs_extent_free_need_new_trans(struct xfs_mount *mp,
+				    struct xfs_efi_log_item *efip,
+				    struct xfs_extent_free_item *xefi)
+{
+	bool			ret = true;
+	int			nr_pre;
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+
+	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
+	pag = xfs_perag_get(mp, agno);
+	/* The first extent in EFI is always OK to go */
+	if (xfs_is_first_extent_in_efi(efip, xefi)) {
+		atomic_inc(&pag->pag_nr_pending_extents);
+		ret = false;
+		goto out_put;
+	}
+
+	/*
+	 * Now the extent is the 2nd or subsequent in the efip. We need
+	 * new transaction if the AG already has busy extents pending.
+	 */
+	nr_pre = atomic_inc_return(&pag->pag_nr_pending_extents) - 1;
+	/* No prevoius pending extent freeing to this AG */
+	if (nr_pre == 0) {
+		ret = false;
+		goto out_put;
+	}
+
+	atomic_dec(&pag->pag_nr_pending_extents);
+out_put:
+	xfs_perag_put(pag);
+	return ret;
+}
+
 /*
  * Free an extent and log it to the EFD. Note that the transaction is marked
  * dirty regardless of whether the extent free succeeds or fails to support the
@@ -356,6 +425,28 @@ xfs_trans_free_extent(
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
 							xefi->xefi_startblock);
 	int				error;
+	struct xfs_efi_log_item		*efip = efdp->efd_efip;
+
+	if (xfs_extent_free_need_new_trans(mp, efip, xefi)) {
+		/*
+		 * This should be the 2nd+ extent, we don't have to mark the
+		 * transaction and efd dirty, those are already done with the
+		 * first extent.
+		 */
+		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
+		ASSERT(tp->t_flags & XFS_TRANS_HAS_INTENT_DONE);
+		ASSERT(test_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags));
+
+		xfs_fill_efd_with_efi(efdp);
+
+		/*
+		 * A preious extent in same AG is processed with the current
+		 * transaction. To avoid possible AGFL allocation deadlock,
+		 * we roll the transaction and then restart with this extent
+		 * with new transaction.
+		 */
+		return -EAGAIN;
+	}
 
 	oinfo.oi_owner = xefi->xefi_owner;
 	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
@@ -369,6 +460,13 @@ xfs_trans_free_extent(
 	error = __xfs_free_extent(tp, xefi->xefi_startblock,
 			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	if (error) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, agno);
+		atomic_dec(&pag->pag_nr_pending_extents);
+		xfs_perag_put(pag);
+	}
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -476,7 +574,8 @@ xfs_extent_free_finish_item(
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 
 	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
+	if (error != -EAGAIN)
+		kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 
@@ -632,7 +731,15 @@ xfs_efi_item_recover(
 		fake.xefi_startblock = extp->ext_start;
 		fake.xefi_blockcount = extp->ext_len;
 
-		error = xfs_trans_free_extent(tp, efdp, &fake);
+		if (error == 0)
+			error = xfs_trans_free_extent(tp, efdp, &fake);
+
+		if (error == -EAGAIN) {
+			ASSERT(i > 0);
+			xfs_free_extent_later(tp, fake.xefi_startblock,
+			fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
+			continue;
+		}
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					extp, sizeof(*extp));
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index eccbfb99e894..97eda4487db0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -16,6 +16,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_trace.h"
+#include "xfs_ag.h"
 
 struct workqueue_struct *xfs_discard_wq;
 
@@ -643,8 +644,29 @@ xlog_cil_insert_items(
 		cilpcp->space_used += len;
 	}
 	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy))
+	if (!list_empty(&tp->t_busy)) {
+		struct xfs_perag	*last_pag = NULL;
+		xfs_agnumber_t		last_agno = -1;
+		struct xfs_extent_busy	*ebp;
+
+		/*
+		 * Pending extent freeings are committed to CIL, now it's
+		 * to let other extent freeing on same AG go.
+		 */
+		list_for_each_entry(ebp, &tp->t_busy, list) {
+			if (ebp->agno != last_agno) {
+				last_agno = ebp->agno;
+				if (last_pag)
+					xfs_perag_put(last_pag);
+				last_pag = xfs_perag_get(tp->t_mountp, last_agno);
+			}
+			atomic_dec(&last_pag->pag_nr_pending_extents);
+		}
+		if (last_pag)
+			xfs_perag_put(last_pag);
+
 		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
+	}
 
 	/*
 	 * Now update the order of everything modified in the transaction
-- 
2.21.0 (Apple Git-122.2)

