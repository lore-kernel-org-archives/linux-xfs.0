Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E87C43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B022087C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIIITR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:19:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38962 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgIIITR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 04:19:17 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A68458243E2
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 18:19:14 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJx-00005K-FP
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:13 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJx-004yO0-2F
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: EFI recovery needs it's own transaction reservation
Date:   Wed,  9 Sep 2020 18:19:10 +1000
Message-Id: <20200909081912.1185392-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909081912.1185392-1-david@fromorbit.com>
References: <20200909081912.1185392-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=JTkEanIKHGTgUDm-kJgA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Recovering an EFI currently uses a itruncate reservation, which is
designed for a rolling transaction that modifies the BMBT and
logs the EFI in one commit, then frees the space and logs the EFD in
the second commit.

Recovering the EFI only requires the second transaction in this
pair, and hence has a smaller log space requirement than a truncate
operation. Hence when the extent free is being processed at runtime,
the log reservation that is held by the filesystem is only enough to
complete the extent free, not the entire truncate operation.

Hence if the EFI pins the tail of the log and the log fills up while
the extent is being freed, the amount of reserved free space in the
log is not enough to start another entire truncate operation. Hence
if we crash at this point, log recovery will deadlock with the EFI
pinning the tail of the log and the log not having enough free space
to reserve an itruncate transaction.

As such, EFI recovery needs it's own log space reservation separate
to the itruncate reservation. We only need what is required free the
extent, and this matches the space we have reserved at runtime for
this operation and hence should prevent the recovery deadlock from
occurring.

This patch adds the new reservation in a way that minimises the
change such that it should be back-portable to older kernels easily.
Follow up patches will factor and rework the reservations to be more
correct and more tightly defined.

Note: this would appear to be a generic problem with intent
recovery; we use the entire operation reservation for recovery,
not the reservation that was held at runtime after the intent was
logged. I suspect all intents are going to require their own
reservation as a result.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 10 ++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  2 ++
 fs/xfs/xfs_extfree_item.c      |  2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52e..da2ec052ac0a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -916,6 +916,16 @@ xfs_trans_resv_calc(
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	/*
+	 * Log recovery reservations for intent replay
+	 *
+	 * EFI recovery is itruncate minus the initial transaction that logs
+	 * logs the EFI.
+	 */
+	resp->tr_efi.tr_logres = resp->tr_itruncate.tr_logres;
+	resp->tr_efi.tr_logcount = resp->tr_itruncate.tr_logcount - 1;
+	resp->tr_efi.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7241ab28cf84..13173b3eaac9 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -50,6 +50,8 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_efi;		/* EFI log item recovery */
+
 };
 
 /* shorthand way of accessing reservation structure */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6cb8cd11072a..1ea9ab4cd44e 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -618,7 +618,7 @@ xfs_efi_item_recover(
 		}
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_efi, 0, 0, 0, &tp);
 	if (error)
 		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
-- 
2.28.0

