Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C01C4727D
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 366582145D
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYohsqno"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgI2OMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbgI2OMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 10:12:34 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601388752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjGhBz0B+WwBkRgRGbq33Dp5snPCFkpiwdw6DrSTnDU=;
        b=OYohsqnoPl31Y8t1L1x0Rr4NI4psbqxz2uMwHnzSDGLopzdL3dVRm62rQF4RVq/zHjbzg9
        MyHJUDv5Y9KFGbE2uIqmzTc4wRVuMTY/LKjzxrgLK7wyM9fCF7DBQx5BXsqm/8MO3+w+i+
        8A0axqFUfqjjoSnXkmkIZRljKiMtdOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-kkkjr3yUOH-ep6AV6wBD5Q-1; Tue, 29 Sep 2020 10:12:30 -0400
X-MC-Unique: kkkjr3yUOH-ep6AV6wBD5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88F3410BBEC6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-202.rdu2.redhat.com [10.10.113.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AFE619C4F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 1/3] xfs: skip dquot reservations if quota is inactive
Date:   Tue, 29 Sep 2020 10:12:26 -0400
Message-Id: <20200929141228.108688-2-bfoster@redhat.com>
In-Reply-To: <20200929141228.108688-1-bfoster@redhat.com>
References: <20200929141228.108688-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The dquot reservation helper currently performs the associated
reservation for any provided dquots. The dquots could have been
acquired from inode references or explicit dquot allocation
requests. Some reservation callers may have already checked that the
associated quota subsystem is active (xfs_qm_dqget() returns an
error otherwise), while others might not have checked at all
(xfs_trans_reserve_quota_nblks() passes the inode references).
Further, subsequent dquot modifications do actually check that the
associated quota is active before making transactional changes
(xfs_trans_mod_dquot_byino()).

Given all of that, the behavior to unconditionally perform
reservation on any provided dquots is somewhat ad hoc. While it is
currently harmless, it is not without side effect. If the quota is
inactive by the time a transaction attempts a quota reservation, the
dquot will be attached to the transaction and subsequently logged,
even though no dquot modifications are ultimately made.

This is a problem for upcoming quotaoff changes that intend to
implement a strict transactional barrier for logging dquots during a
quotaoff operation. If a dquot is logged after the subsystem
deactivated and the barrier released, a subsequent log recovery can
incorrectly replay dquot changes into the filesystem.

Therefore, update the dquot reservation path to also check that a
particular quota mode is active before associating a dquot with a
transaction. This should have no noticeable impact on the current
code that already accommodates checking active quota state at points
before and after quota reservations are made.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 133fc6fc3edd..547ba824542e 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -39,14 +39,12 @@ xfs_trans_dqjoin(
 }
 
 /*
- * This is called to mark the dquot as needing
- * to be logged when the transaction is committed.  The dquot must
- * already be associated with the given transaction.
- * Note that it marks the entire transaction as dirty. In the ordinary
- * case, this gets called via xfs_trans_commit, after the transaction
- * is already dirty. However, there's nothing stop this from getting
- * called directly, as done by xfs_qm_scall_setqlim. Hence, the TRANS_DIRTY
- * flag.
+ * This is called to mark the dquot as needing to be logged when the transaction
+ * is committed. The dquot must already be associated with the given
+ * transaction. Note that it marks the entire transaction as dirty. In the
+ * ordinary case, this gets called via xfs_trans_commit, after the transaction
+ * is already dirty. However, there's nothing stop this from getting called
+ * directly, as done by xfs_qm_scall_setqlim. Hence, the TRANS_DIRTY flag.
  */
 void
 xfs_trans_log_dquot(
@@ -770,19 +768,19 @@ xfs_trans_reserve_quota_bydquots(
 
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
-	if (udqp) {
+	if (XFS_IS_UQUOTA_ON(mp) && udqp) {
 		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
 		if (error)
 			return error;
 	}
 
-	if (gdqp) {
+	if (XFS_IS_GQUOTA_ON(mp) && gdqp) {
 		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
 		if (error)
 			goto unwind_usr;
 	}
 
-	if (pdqp) {
+	if (XFS_IS_PQUOTA_ON(mp) && pdqp) {
 		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
 		if (error)
 			goto unwind_grp;
-- 
2.25.4

