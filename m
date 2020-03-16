Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC8EC18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 17:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7918720409
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 17:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gkdozjgw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbgCPRXQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 13:23:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:33005 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732051AbgCPRXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 13:23:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584379395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sjslMVATCdoW4uvpRqA8UEbT2N1vFjGgUszZ6BYMdDI=;
        b=Gkdozjgw/U5O+663nzmogdX+ZxUgVlAgIfu0edbAZAbpqk939EXknNDDtYMhRvCvRqWtGu
        H/ZZVPQVYjC9fiOHZld/OD2lKvPW39+cewwVwoa89zEMRkimJtbt0EG43yBl3FqjTjTFPa
        qw2Ug6vq1OqQmI1PXH98dml01lMZen8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-UGykQd_4OQS3HuNqfplvWw-1; Mon, 16 Mar 2020 13:23:13 -0400
X-MC-Unique: UGykQd_4OQS3HuNqfplvWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D49F9198F34E
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 17:00:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F6735C1B2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 17:00:33 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix unmount hang and memory leak on shutdown during quotaoff
Date:   Mon, 16 Mar 2020 13:00:32 -0400
Message-Id: <20200316170032.19552-3-bfoster@redhat.com>
In-Reply-To: <20200316170032.19552-1-bfoster@redhat.com>
References: <20200316170032.19552-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

AIL removal of the quotaoff start intent and free of both quotaoff
intents is currently limited to the ->iop_committed() handler of the
end intent. This executes when the end intent is committed to the
on-disk log and marks the completion of the operation. The problem
with this is it assumes the success of the operation. If a shutdown
or other error occurs during the quotaoff, it's possible for the
quotaoff task to exit without removing the start intent from the
AIL. This results in an unmount hang as the AIL cannot be emptied.
Further, no other codepath frees the intents and so this is also a
memory leak vector.

First, update the high level quotaoff error path to directly remove
and free the quotaoff start intent if it still exists in the AIL at
the time of the error. Next, update both of the start and end
quotaoff intents with an ->iop_release() callback to properly handle
transaction abort.

This means that If the quotaoff start transaction aborts, it frees
the start intent in the transaction commit path. If the filesystem
shuts down before the end transaction allocates, the quotaoff
sequence removes and frees the start intent. If the end transaction
aborts, it removes the start intent and frees both. This ensures
that a shutdown does not result in a hung unmount and that memory is
not leaked regardless of when a quotaoff error occurs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot_item.c  | 15 +++++++++++++++
 fs/xfs/xfs_qm_syscalls.c | 13 +++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 2b816e9b4465..cf65e2e43c6e 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -315,17 +315,32 @@ xfs_qm_qoffend_logitem_committed(
 	return (xfs_lsn_t)-1;
 }
=20
+STATIC void
+xfs_qm_qoff_logitem_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_qoff_logitem	*qoff =3D QOFF_ITEM(lip);
+
+	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
+		if (qoff->qql_start_lip)
+			xfs_qm_qoff_logitem_relse(qoff->qql_start_lip);
+		xfs_qm_qoff_logitem_relse(qoff);
+	}
+}
+
 static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops =3D {
 	.iop_size	=3D xfs_qm_qoff_logitem_size,
 	.iop_format	=3D xfs_qm_qoff_logitem_format,
 	.iop_committed	=3D xfs_qm_qoffend_logitem_committed,
 	.iop_push	=3D xfs_qm_qoff_logitem_push,
+	.iop_release	=3D xfs_qm_qoff_logitem_release,
 };
=20
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops =3D {
 	.iop_size	=3D xfs_qm_qoff_logitem_size,
 	.iop_format	=3D xfs_qm_qoff_logitem_format,
 	.iop_push	=3D xfs_qm_qoff_logitem_push,
+	.iop_release	=3D xfs_qm_qoff_logitem_release,
 };
=20
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..5d5ac65aa1cc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -29,8 +29,6 @@ xfs_qm_log_quotaoff(
 	int			error;
 	struct xfs_qoff_logitem	*qoffi;
=20
-	*qoffstartp =3D NULL;
-
 	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp)=
;
 	if (error)
 		goto out;
@@ -62,7 +60,7 @@ xfs_qm_log_quotaoff(
 STATIC int
 xfs_qm_log_quotaoff_end(
 	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*startqoff,
+	struct xfs_qoff_logitem	**startqoff,
 	uint			flags)
 {
 	struct xfs_trans	*tp;
@@ -73,9 +71,10 @@ xfs_qm_log_quotaoff_end(
 	if (error)
 		return error;
=20
-	qoffi =3D xfs_trans_get_qoff_item(tp, startqoff,
+	qoffi =3D xfs_trans_get_qoff_item(tp, *startqoff,
 					flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
+	*startqoff =3D NULL;
=20
 	/*
 	 * We have to make sure that the transaction is secure on disk before w=
e
@@ -103,7 +102,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	struct xfs_qoff_logitem	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart =3D NULL;
=20
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -228,7 +227,7 @@ xfs_qm_scall_quotaoff(
 	 * So, we have QUOTAOFF start and end logitems; the start
 	 * logitem won't get overwritten until the end logitem appears...
 	 */
-	error =3D xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
+	error =3D xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
 	if (error) {
 		/* We're screwed now. Shutdown is the only option. */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
@@ -261,6 +260,8 @@ xfs_qm_scall_quotaoff(
 	}
=20
 out_unlock:
+	if (error && qoffstart)
+		xfs_qm_qoff_logitem_relse(qoffstart);
 	mutex_unlock(&q->qi_quotaofflock);
 	return error;
 }
--=20
2.21.1

