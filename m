Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AB1C47423
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FF4208B8
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 14:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dnHyDzAw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgI2OMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:12:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728459AbgI2OMf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 10:12:35 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601388753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsJpb/fB9N2tnTgMAPR+TrCcW7bOGwWvI1wZ4HLXGDc=;
        b=dnHyDzAwKcU716ijaQB0jfPfqwHRIithjs7ye8vzH15WpO07/xdNRLOwqPwNJnq1XJprqq
        gEyDfGM/J6LOjIQVaE4mI5VgRmTks4B0K5fJ4Z6dLhqSyIVPGtojbqsH2sTKRHZ2nbu0fr
        mULO2bh+1MAhUbxKZW7UwuXlgs6Z1oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-UJs102HHO_Gv0s39NTXVdg-1; Tue, 29 Sep 2020 10:12:31 -0400
X-MC-Unique: UJs102HHO_Gv0s39NTXVdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 520F51DE01
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:30 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-202.rdu2.redhat.com [10.10.113.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14E7A19C4F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2020 14:12:30 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 3/3] xfs: rework quotaoff logging to avoid log deadlock on active fs
Date:   Tue, 29 Sep 2020 10:12:28 -0400
Message-Id: <20200929141228.108688-4-bfoster@redhat.com>
In-Reply-To: <20200929141228.108688-1-bfoster@redhat.com>
References: <20200929141228.108688-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The quotaoff operation logs two log items. The start item is
committed first, followed by the bulk of the in-core quotaoff
processing, and then the quotaoff end item is committed to release
the start item from the log. The problem with this mechanism is that
quite a bit of processing can be required to release dquots from all
in-core inodes and subsequently flush/purge all dquots in the
system. This processing work doesn't generally generate much log
traffic itself, but the start item pins the tail of the log. If an
external workload consumes the remaining log space before the
transaction for the end item is allocated, a log deadlock can occur.

The purpose of the separate start and end log items is primarily to
ensure that log recovery does not incorrectly recover dquot data
after an fs crash where a quotaoff was in progress. If we only
logged a single quotaoff item, for example, it could fall behind the
tail of the log before the last dquot modification was made and
incorrectly replay dquot changes that might have occurred after the
start item committed but before quotaoff deactivated the quota.

With that context, we can make some small changes to the quotaoff
algorithm to provide the same general log ordering guarantee without
such a large window to create a log deadlock vector. Rather than
place a start item in the log for the duration of quotaoff
processing, we can quiesce the transaction subsystem up front to
guarantee that no further dquots are logged from that point forward.
IOW, we freeze the transaction subsystem, commit the start item in a
synchronous transaction that forces the log, deactivate the
associated quota such that subsequent transactions no longer modify
associated dquots, unfreeze the transaction subsystem and finally
commit the quotaoff end item. The transaction freeze is somewhat of
a heavy weight operation, but quotaoff is already a rare, slow and
performance disruptive operation.

Altogether, this means that the dquot rele/purge sequence occurs
after the quotaoff end item has committed and thus can technically
fall off the active range of the log. This is safe because the
remaining processing is all in-core work that doesn't involve
logging dquots and we've guaranteed that no further dquots can be
modified by external transactions. This allows quotaoff to complete
without risking log deadlock regardless of how much dquot processing
is required.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 36 ++++++++++++++++--------------------
 fs/xfs/xfs_trans_dquot.c |  2 ++
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ca1b57d291dc..97844f33f70f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -29,7 +29,8 @@ xfs_qm_log_quotaoff(
 	int			error;
 	struct xfs_qoff_logitem	*qoffi;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
+				XFS_TRANS_NO_WRITECOUNT, &tp);
 	if (error)
 		goto out;
 
@@ -169,14 +170,18 @@ xfs_qm_scall_quotaoff(
 	if ((mp->m_qflags & flags) == 0)
 		goto out_unlock;
 
+	xfs_trans_freeze(mp);
+
 	/*
 	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
 	 * and synchronously. If we fail to write, we should abort the
 	 * operation as it cannot be recovered safely if we crash.
 	 */
 	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
-	if (error)
+	if (error) {
+		xfs_trans_unfreeze(mp);
 		goto out_unlock;
+	}
 
 	/*
 	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
@@ -191,6 +196,15 @@ xfs_qm_scall_quotaoff(
 	 */
 	mp->m_qflags &= ~inactivate_flags;
 
+	xfs_trans_unfreeze(mp);
+
+	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
+	if (error) {
+		/* We're screwed now. Shutdown is the only option. */
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		goto out_unlock;
+	}
+
 	/*
 	 * Give back all the dquot reference(s) held by inodes.
 	 * Here we go thru every single incore inode in this file system, and
@@ -216,24 +230,6 @@ xfs_qm_scall_quotaoff(
 	 */
 	xfs_qm_dqpurge_all(mp, dqtype);
 
-	/*
-	 * Transactions that had started before ACTIVE state bit was cleared
-	 * could have logged many dquots, so they'd have higher LSNs than
-	 * the first QUOTAOFF log record does. If we happen to crash when
-	 * the tail of the log has gone past the QUOTAOFF record, but
-	 * before the last dquot modification, those dquots __will__
-	 * recover, and that's not good.
-	 *
-	 * So, we have QUOTAOFF start and end logitems; the start
-	 * logitem won't get overwritten until the end logitem appears...
-	 */
-	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
-	if (error) {
-		/* We're screwed now. Shutdown is the only option. */
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		goto out_unlock;
-	}
-
 	/*
 	 * If all quotas are completely turned off, close shop.
 	 */
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 547ba824542e..9839b83e732a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -52,6 +52,8 @@ xfs_trans_log_dquot(
 	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
+	/* quotaoff expects no dquots logged after deactivation */
+	ASSERT(xfs_this_quota_on(tp->t_mountp, xfs_dquot_type(dqp)));
 
 	/* Upgrade the dquot to bigtime format if possible. */
 	if (dqp->q_id != 0 &&
-- 
2.25.4

