Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C16C2BB54
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2904A221EB
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ibtJhXJv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgDFMgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35776 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgDFMgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgEwxMau1Fn+2+3dl4Neb/rSwczg8z3UEnhB1hb5RRs=;
        b=ibtJhXJvK9gn3hqVq9SXIkOZz5VaTgmYHyuKIxFH3FwsW57BJBcPlg4IidahciGqXsNDD0
        gfXsT566ccxQx0KTh+yKqD+PksiT0+5WdUOKl+pUfMauvthNTJUytGdgPmqr7sb5o5qpJa
        z6uiexrcfmxCPftj+eaNFu4v9/HhZCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-UGcdGyxsME2rlx1yHR6QuA-1; Mon, 06 Apr 2020 08:36:37 -0400
X-MC-Unique: UGcdGyxsME2rlx1yHR6QuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 530BC8017FF
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:36 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A05960C63
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:35 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 06/10] xfs: automatically relog the quotaoff start intent
Date:   Mon,  6 Apr 2020 08:36:28 -0400
Message-Id: <20200406123632.20873-7-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The quotaoff operation has a rare but longstanding deadlock vector
in terms of how the operation is logged. A quotaoff start intent is
logged (synchronously) at the onset to ensure recovery can handle
the operation if interrupted before in-core changes are made. This
quotaoff intent pins the log tail while the quotaoff sequence scans
and purges dquots from all in-core inodes. While this operation
generally doesn't generate much log traffic on its own, it can be
time consuming. If unrelated, concurrent filesystem activity
consumes remaining log space before quotaoff is able to acquire log
reservation for the quotaoff end intent, the filesystem locks up
indefinitely.

quotaoff cannot allocate the end intent before the scan because the
latter can result in transaction allocation itself in certain
indirect cases (releasing an inode, for example). Further, rolling
the original transaction is difficult because the scanning work
occurs multiple layers down where caller context is lost and not
much information is available to determine how often to roll the
transaction.

To address this problem, enable automatic relogging of the quotaoff
start intent. This automatically relogs the intent whenever AIL
pushing finds the item at the tail of the log. When quotaoff
completes, wait for relogging to complete as the end intent expects
to be able to permanently remove the start intent from the log
subsystem. This ensures that the log tail is kept moving during a
particularly long quotaoff operation and avoids the log reservation
deadlock.

Note that the quotaoff reservation calculation does not need to be
updated for relog as it already (incorrectly) accounts for two
quotaoff intents.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot_item.c  | 26 ++++++++++++++++++++++++++
 fs/xfs/xfs_qm_syscalls.c | 12 +++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index baad1748d0d1..22f8b0750afc 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
=20
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip=
)
 {
@@ -298,6 +299,13 @@ xfs_qm_qoff_logitem_push(
 	struct xfs_log_item	*lip,
 	struct list_head	*buffer_list)
 {
+	struct xfs_log_item	*mlip =3D xfs_ail_min(lip->li_ailp);
+
+	if (test_bit(XFS_LI_RELOG, &lip->li_flags) &&
+	    !test_bit(XFS_LI_RELOG_QUEUED, &lip->li_flags) &&
+	    !XFS_LSN_CMP(lip->li_lsn, mlip->li_lsn))
+		return XFS_ITEM_RELOG;
+
 	return XFS_ITEM_LOCKED;
 }
=20
@@ -329,6 +337,23 @@ xfs_qm_qoff_logitem_release(
 	}
 }
=20
+STATIC void
+xfs_qm_qoff_logitem_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	int			res;
+
+	res =3D xfs_relog_calc_res(lip);
+
+	xfs_trans_add_item(tp, lip);
+	tp->t_ticket->t_curr_res +=3D res;
+	tp->t_ticket->t_unit_res +=3D res;
+	tp->t_log_res +=3D res;
+	tp->t_flags |=3D XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
+}
+
 static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops =3D {
 	.iop_size	=3D xfs_qm_qoff_logitem_size,
 	.iop_format	=3D xfs_qm_qoff_logitem_format,
@@ -342,6 +367,7 @@ static const struct xfs_item_ops xfs_qm_qoff_logitem_=
ops =3D {
 	.iop_format	=3D xfs_qm_qoff_logitem_format,
 	.iop_push	=3D xfs_qm_qoff_logitem_push,
 	.iop_release	=3D xfs_qm_qoff_logitem_release,
+	.iop_relog	=3D xfs_qm_qoff_logitem_relog,
 };
=20
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5d5ac65aa1cc..dc154051ec7b 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_trans_priv.h"
=20
 STATIC int
 xfs_qm_log_quotaoff(
@@ -29,12 +30,14 @@ xfs_qm_log_quotaoff(
 	int			error;
 	struct xfs_qoff_logitem	*qoffi;
=20
-	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp)=
;
+	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
+				XFS_TRANS_RELOG, &tp);
 	if (error)
 		goto out;
=20
 	qoffi =3D xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT)=
;
 	xfs_trans_log_quotaoff_item(tp, qoffi);
+	xfs_trans_relog_item(tp, &qoffi->qql_item);
=20
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_qflags =3D (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
@@ -71,6 +74,13 @@ xfs_qm_log_quotaoff_end(
 	if (error)
 		return error;
=20
+	/*
+	 * startqoff must be in the AIL and not the CIL when the end intent
+	 * commits to ensure it is not readded to the AIL out of order. Wait on
+	 * relog activity to drain to isolate startqoff to the AIL.
+	 */
+	xfs_trans_relog_item_cancel(tp, &(*startqoff)->qql_item, true);
+
 	qoffi =3D xfs_trans_get_qoff_item(tp, *startqoff,
 					flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
--=20
2.21.1

