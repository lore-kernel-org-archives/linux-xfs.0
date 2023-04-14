Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB0CC77B76
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 22:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDNW6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 18:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjDNW6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 18:58:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F4C769A
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 15:58:39 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EMOaKN007175
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=ugVKYn16VrcIopcgq4EirafBuc03xBI98ntg62RKUFI=;
 b=LccKpwydktqJ/HvI3j3zB69vzSsfApKsrSp8UBNdTMNQrIWGw/kXsoKYelvV4YQT0/XD
 6rVB0cMBR3Eu+rwNyCZ/O8rARSgabg2g1/EVQYQEL3MeyA5Fu4ubnjbBsRnHXp8Hb7e+
 KUslhjS9dtXcVgYnBjXMEGVmbZ/z8dyhn96hxpc0upp8jn2MQLWrevLo8XOfcGK5+/Lk
 +iAZvvVS2DnhFmiI8y8ERYe/GhbIdkwIDvAyBo9KRx6Me+9cfHtbd78MUVASk/BFlZEf
 ECdFfyVQ1xDqVpwYA8TQnKd8dtATyCRdbmuq2BlMi/ca1tLdLmG3N+PHi8lodJpYpYUn Jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bw737m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EKv5WH011370
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw96nvpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33EMwaq0026359
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-159-110.vpn.oracle.com [10.159.159.110])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3puw96nvnq-3;
        Fri, 14 Apr 2023 22:58:37 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH 2/2] xfs: log recovery stage split EFIs with multiple extents
Date:   Fri, 14 Apr 2023 15:58:36 -0700
Message-Id: <20230414225836.8952-3-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
In-Reply-To: <20230414225836.8952-1-wen.gang.wang@oracle.com>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140202
X-Proofpoint-GUID: Y4fhCyxaz8-_ZdmHXWZHWtPb5PWl5IpN
X-Proofpoint-ORIG-GUID: Y4fhCyxaz8-_ZdmHXWZHWtPb5PWl5IpN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At log recovery stage, we need to split EFIs with multiple extents. For each
orginal multiple-extent EFI, split it into new EFIs each including one extent
from the original EFI. By that we avoid deadlock when allocating blocks for
AGFL waiting for the held busy extents by current transaction to be flushed.

 For the original EFI, the process is
 1. Create and log new EFIs each covering one extent from the
    original EFI.
 2. Don't free extent with the original EFI.
 3. Log EFD for the original EFI.
    Make sure we log the new EFIs and original EFD in this order:
      new EFI 1
      new EFI 2
      ...
      new EFI N
      original EFD
 The original extents are freed with the new EFIs.

The example log items:

 rbbn 41572 rec_lsn: 1638833,41568 Oper 18: tid: d746ea5d  len: 48 flags: None
 EFI  nextents:2 id:ffff8b10b5a13c28        --> orginal EFI
 EFI id=ffff8b10b5a13c28 (0x5de4c42, 256)
 EFI id=ffff8b10b5a13c28 (0x5de4942, 256)

 rbbn 39041 rec_lsn: 1638834,39040 Oper 2: tid: 4e651c99  len: 32 flags: None
 EFI  nextents:1 id:ffff9fef39f4c528	    --> new EFI 1
 EFI id=ffff9fef39f4c528 (0x5de4c42, 256)
 -----------------------------------------------------------------------------
 rbbn 39041 rec_lsn: 1638834,39040 Oper 3: tid: 4e651c99  len: 32 flags: None
 EFI  nextents:1 id:ffff9fef39f4f548	    --> new EFI 2
 EFI id=ffff9fef39f4f548 (0x5de4942, 256)
 -----------------------------------------------------------------------------
 rbbn 39041 rec_lsn: 1638834,39040 Oper 4: tid: 4e651c99  len: 48 flags: None
 EFD  nextents:2 id:ffff8b10b5a13c28	    --> EFD to original EFI
 EFD id=ffff8b10b5a13c28 (0x5de4c42, 256)
 EFD id=ffff8b10b5a13c28 (0x5de4942, 256)
 -----------------------------------------------------------------------------
 rbbn 39041 rec_lsn: 1638834,39040 Oper 5: tid: 4e651c99  len: 32 flags: None
 EFD  nextents:1 id:ffff9fef39f4c528	    --> EFD to new EFI 1
 EFD id=ffff9fef39f4c528 (0x5de4c42, 256)

 ......

 rbbn 39057 rec_lsn: 1638834,39056 Oper 2: tid: e3264681  len: 32 flags: None
 EFD  nextents:1 id:ffff9fef39f4f548	    --> EFD to new EFI 2
 EFD id=ffff9fef39f4f548 (0x5de4942, 256)

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_extfree_item.c | 104 ++++++++++++++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 011b50469301..b00b44234397 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -595,7 +595,11 @@ xfs_efi_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
+	int				nr_ext = efip->efi_format.efi_nextents;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	struct xfs_efi_log_item		**new_efis, *new_efip;
+	struct xfs_efd_log_item		*new_efdp;
+	struct xfs_extent_free_item	fake;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	int				i;
@@ -606,7 +610,7 @@ xfs_efi_item_recover(
 	 * EFI.  If any are bad, then assume that all are bad and
 	 * just toss the EFI.
 	 */
-	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+	for (i = 0; i < nr_ext; i++) {
 		if (!xfs_efi_validate_ext(mp,
 					&efip->efi_format.efi_extents[i])) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -619,28 +623,106 @@ xfs_efi_item_recover(
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)
 		return error;
-	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
-	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		struct xfs_extent_free_item	fake = {
-			.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
-		};
+	memset(&fake, 0, sizeof(fake));
+	fake.xefi_owner = XFS_RMAP_OWN_UNKNOWN;
+
+	if (nr_ext <= 1) {
+		efdp = xfs_trans_get_efd(tp, efip,
+				efip->efi_format.efi_nextents);
+
+		for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+			struct xfs_extent		*extp;
+
+			extp = &efip->efi_format.efi_extents[i];
+
+			fake.xefi_startblock = extp->ext_start;
+			fake.xefi_blockcount = extp->ext_len;
+
+			error = xfs_trans_free_extent(tp, efdp, &fake);
+			if (error == -EFSCORRUPTED)
+				XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+						extp, sizeof(*extp));
+			if (error)
+				goto abort_error;
+
+		}
+
+		return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	}
+
+	/*
+	 * Log recovery stage, we need to split a EFI into new EFIs if the
+	 * original EFI includes more than one extents. Check the change of
+	 * XFS_EFI_MAX_FAST_EXTENTS for the reason.
+	 * For the original EFI, the process is
+	 * 1. Create and log new EFIs each covering one extent from the
+	 *    original EFI.
+	 * 2. Don't free extent with the original EFI.
+	 * 3. Log EFD for the original EFI.
+	 *    Make sure we log the new EFIs and original EFD in this order:
+	 *	new EFI 1
+	 *	new EFI 2
+	 *	...
+	 *	new EFI N
+	 *	original EFD
+	 * The original extents are freed with the new EFIs.
+	 */
+	new_efis = kmem_zalloc(sizeof(*new_efis) * nr_ext, 0);
+	if (!new_efis) {
+		error = -ENOMEM;
+		goto abort_error;
+	}
+	for (i = 0; i < nr_ext; i++) {
 		struct xfs_extent		*extp;
 
+		new_efip = xfs_efi_init(mp, 1);
 		extp = &efip->efi_format.efi_extents[i];
 
 		fake.xefi_startblock = extp->ext_start;
 		fake.xefi_blockcount = extp->ext_len;
+		xfs_trans_add_item(tp, &new_efip->efi_item);
+		xfs_extent_free_log_item(tp, new_efip, &fake);
+		new_efis[i] = new_efip;
+	}
+
+	/*
+	 * The new EFIs are in transaction now, add original EFD with
+	 * full extents.
+	 */
+	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
+	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
+	efdp->efd_next_extent = nr_ext;
+	for (i = 0; i < nr_ext; i++)
+		efdp->efd_format.efd_extents[i] =
+			efip->efi_format.efi_extents[i];
 
-		error = xfs_trans_free_extent(tp, efdp, &fake);
+	/*
+	 * Now process the new EFIs.
+	 * Current transaction is a new one, there are no defered
+	 * works attached. It's safe to use the following first
+	 * xfs_trans_roll() to commit it.
+	 */
+	for (i = 0; i < nr_ext; i++) {
+		struct xfs_extent		*extp;
+
+		new_efip = new_efis[i];
+		new_efdp = xfs_trans_get_efd(tp, new_efip, 1);
+		extp = &new_efip->efi_format.efi_extents[0];
+		fake.xefi_startblock = extp->ext_start;
+		fake.xefi_blockcount = extp->ext_len;
+		error = xfs_trans_free_extent(tp, new_efdp, &fake);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					extp, sizeof(*extp));
-		if (error)
+						extp, sizeof(*extp));
+		if (!error)
+			error = xfs_trans_roll(&tp);
+		if (error) {
+			kmem_free(new_efis);
 			goto abort_error;
-
+		}
 	}
-
+	kmem_free(new_efis);
 	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
-- 
2.21.0 (Apple Git-122.2)

