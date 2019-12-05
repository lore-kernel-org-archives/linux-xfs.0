Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79FFC2D0BF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B43F124249
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JP2zLJ1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfLERul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 12:50:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48496 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730093AbfLERul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 12:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575568239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XkDUkMCcxV+21HfHnZ8OhGe3WUt7hxvp+J03sU78Sc=;
        b=JP2zLJ1dLn3ceUpcDlXKK28uuASOKn5DZe/dA2edcQvC+eCwfQX4E2mKjjxGnC1pULVNDl
        8+oAxvWXQzHfujcZfh8w3Bcq6jdE0zeX1wfBcYTUFwVp7f2Z1Z1dTD2SHvnX1iXobgJr7c
        UJp4Xh+ZtYLrqzXwZRY+sCWNnGqv56U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-BzFF3ub2NveWqcUlKBTTLA-1; Thu, 05 Dec 2019 12:50:38 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84662800D41
        for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2019 17:50:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43FF410013D9
        for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2019 17:50:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v4 2/2] xfs: automatically relog the quotaoff start intent
Date:   Thu,  5 Dec 2019 12:50:37 -0500
Message-Id: <20191205175037.52529-3-bfoster@redhat.com>
In-Reply-To: <20191205175037.52529-1-bfoster@redhat.com>
References: <20191205175037.52529-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: BzFF3ub2NveWqcUlKBTTLA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The quotaoff operation has a rare but longstanding deadlock vector
in terms of how the operation is logged. A quotaoff start intent is
logged (synchronously) at the onset to ensure recovery can continue
with the operation before in-core changes are made. This quotaoff
intent pins the log tail while the quotaoff sequence scans and
purges dquots from all in-core inodes. While this operation
generally doesn't generate much log traffic on its own, it can be
time consuming. If unrelated filesystem activity consumes remaining
log space before quotaoff is able to allocate the quotaoff end
intent, the filesystem locks up indefinitely.

quotaoff cannot allocate the end intent before the scan because the
latter can result in transaction allocation itself in certain
indirect cases (releasing an inode, for example). Further, rolling
the original transaction is difficult because the scanning work
occurs multiple layers down where caller context is lost and not
much information is available to determine how often to roll the
transaction.

To address this problem, enable automatic relogging of the quotaoff
start intent. Trigger a relog whenever AIL pushing finds the item at
the tail of the log. When complete, wait for relogging to complete
as the end intent expects to be able to permanently remove the start
intent from the log subsystem. This ensures that the log tail is
kept moving during a particularly long quotaoff operation and avoids
deadlock via unrelated fs activity.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot_item.c  | 7 +++++++
 fs/xfs/xfs_qm_syscalls.c | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d60647d7197b..ea5123678466 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -297,6 +297,13 @@ xfs_qm_qoff_logitem_push(
 =09struct xfs_log_item=09*lip,
 =09struct list_head=09*buffer_list)
 {
+=09struct xfs_log_item=09*mlip =3D xfs_ail_min(lip->li_ailp);
+
+=09if (test_bit(XFS_LI_RELOG, &lip->li_flags) &&
+=09    !test_bit(XFS_LI_RELOGGED, &lip->li_flags) &&
+=09    !XFS_LSN_CMP(lip->li_lsn, mlip->li_lsn))
+=09=09return XFS_ITEM_RELOG;
+
 =09return XFS_ITEM_LOCKED;
 }
=20
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..b68a08e87c30 100644
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
@@ -37,6 +38,7 @@ xfs_qm_log_quotaoff(
=20
 =09qoffi =3D xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT)=
;
 =09xfs_trans_log_quotaoff_item(tp, qoffi);
+=09xfs_trans_enable_relog(&qoffi->qql_item);
=20
 =09spin_lock(&mp->m_sb_lock);
 =09mp->m_sb.sb_qflags =3D (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
@@ -69,6 +71,13 @@ xfs_qm_log_quotaoff_end(
 =09int=09=09=09error;
 =09struct xfs_qoff_logitem=09*qoffi;
=20
+=09/*
+=09 * startqoff must be in the AIL and not the CIL when the end intent
+=09 * commits to ensure it is not readded to the AIL out of order. Wait on
+=09 * relog activity to drain to isolate startqoff to the AIL.
+=09 */
+=09xfs_trans_disable_relog(&startqoff->qql_item, true);
+
 =09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp=
);
 =09if (error)
 =09=09return error;
--=20
2.20.1

