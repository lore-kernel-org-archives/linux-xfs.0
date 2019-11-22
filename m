Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76CFC33C9A
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B90AB2071C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J7Yv5q7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVSTb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:19:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726695AbfKVSTb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 13:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574446769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdLKScOTN1R8UT4rsr3UdZGuQTd0bmL7sNW935swoQM=;
        b=J7Yv5q7IPFrente9OScy88jOChdCiKZ/enclyObNK6xGjOpmKVYIel/s0nhmmS6CTEZqlW
        67L746jVh67XlqNOlKBwr2aAJC/BJLCn4nTT6f9mTefUs2wAFfG8G7clhlHfEU0WgMEQ3j
        uEMBnq1BHBdC0sPdKxEi+/kdY6ErhtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-WEr5Y64pPvKELIUexlu5mA-1; Fri, 22 Nov 2019 13:19:28 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F99F8024C8
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:27 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1637E9F47
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v2 PATCH 2/3] xfs: prototype automatic intent relogging mechanism
Date:   Fri, 22 Nov 2019 13:19:26 -0500
Message-Id: <20191122181927.32870-3-bfoster@redhat.com>
In-Reply-To: <20191122181927.32870-1-bfoster@redhat.com>
References: <20191122181927.32870-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: WEr5Y64pPvKELIUexlu5mA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Makefile          |   1 +
 fs/xfs/xfs_log.c         |   9 +++
 fs/xfs/xfs_log_priv.h    |   1 +
 fs/xfs/xfs_trans.c       |   2 +-
 fs/xfs/xfs_trans.h       |  13 ++++
 fs/xfs/xfs_trans_relog.c | 130 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_trans_relog.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index aceca2f9a3db..c4664a972e50 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -92,6 +92,7 @@ xfs-y=09=09=09=09+=3D xfs_aops.o \
 =09=09=09=09   xfs_symlink.o \
 =09=09=09=09   xfs_sysfs.o \
 =09=09=09=09   xfs_trans.o \
+=09=09=09=09   xfs_trans_relog.o \
 =09=09=09=09   xfs_xattr.o \
 =09=09=09=09   kmem.o
=20
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0c0c035c5be0..4f4c6b38621a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1531,12 +1531,20 @@ xlog_alloc_log(
 =09if (!log->l_ioend_workqueue)
 =09=09goto out_free_iclog;
=20
+=09log->l_relog_workqueue =3D alloc_workqueue("xfs-relog/%s",
+=09=09=09WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
+=09=09=09mp->m_super->s_id);
+=09if (!log->l_relog_workqueue)
+=09=09goto out_destroy_workqueue;
+
 =09error =3D xlog_cil_init(log);
 =09if (error)
 =09=09goto out_destroy_workqueue;
 =09return log;
=20
 out_destroy_workqueue:
+=09if (log->l_relog_workqueue)
+=09=09destroy_workqueue(log->l_relog_workqueue);
 =09destroy_workqueue(log->l_ioend_workqueue);
 out_free_iclog:
 =09for (iclog =3D log->l_iclog; iclog; iclog =3D prev_iclog) {
@@ -2008,6 +2016,7 @@ xlog_dealloc_log(
 =09}
=20
 =09log->l_mp->m_log =3D NULL;
+=09destroy_workqueue(log->l_relog_workqueue);
 =09destroy_workqueue(log->l_ioend_workqueue);
 =09kmem_free(log);
 }=09/* xlog_dealloc_log */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b192c5a9f9fd..4d557a82eb73 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -349,6 +349,7 @@ struct xlog {
 =09struct xfs_cil=09=09*l_cilp;=09/* CIL log is working with */
 =09struct xfs_buftarg=09*l_targ;        /* buftarg of log */
 =09struct workqueue_struct=09*l_ioend_workqueue; /* for I/O completions */
+=09struct workqueue_struct=09*l_relog_workqueue; /* for auto relog */
 =09struct delayed_work=09l_work;=09=09/* background flush work */
 =09uint=09=09=09l_flags;
 =09uint=09=09=09l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..37011fc803fc 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -923,7 +923,7 @@ xfs_trans_committed_bulk(
  * have already been unlocked as if the commit had succeeded.
  * Do not reference the transaction structure after this call.
  */
-static int
+int
 __xfs_trans_commit(
 =09struct xfs_trans=09*tp,
 =09bool=09=09=09regrant)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..066d4aca8416 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -48,6 +48,7 @@ struct xfs_log_item {
 =09struct xfs_log_vec=09=09*li_lv;=09=09/* active log vector */
 =09struct xfs_log_vec=09=09*li_lv_shadow;=09/* standby vector */
 =09xfs_lsn_t=09=09=09li_seq;=09=09/* CIL commit seq */
+=09void=09=09=09=09*li_priv;
 };
=20
 /*
@@ -143,6 +144,14 @@ typedef struct xfs_trans {
 =09unsigned long=09=09t_pflags;=09/* saved process flags state */
 } xfs_trans_t;
=20
+struct xfs_trans_relog {
+=09struct work_struct=09tr_work;
+=09unsigned int=09=09tr_log_res;
+=09unsigned int=09=09tr_log_count;
+=09struct xlog_ticket=09*tr_tic;
+=09struct xfs_log_item=09*tr_lip;
+};
+
 /*
  * XFS transaction mechanism exported interfaces that are
  * actually macros.
@@ -231,7 +240,11 @@ bool=09=09xfs_trans_buf_is_dirty(struct xfs_buf *bp);
 void=09=09xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
=20
 int=09=09xfs_trans_commit(struct xfs_trans *);
+int=09=09__xfs_trans_commit(struct xfs_trans *, bool);
 int=09=09xfs_trans_roll(struct xfs_trans **);
+int=09=09xfs_trans_relog(struct xfs_trans *, struct xfs_log_item *);
+void=09=09xfs_trans_relog_cancel(struct xfs_log_item *);
+void=09=09xfs_trans_relog_queue(struct xfs_log_item *);
 int=09=09xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
 void=09=09xfs_trans_cancel(xfs_trans_t *);
 int=09=09xfs_trans_ail_init(struct xfs_mount *);
diff --git a/fs/xfs/xfs_trans_relog.c b/fs/xfs/xfs_trans_relog.c
new file mode 100644
index 000000000000..af139aa501f6
--- /dev/null
+++ b/fs/xfs/xfs_trans_relog.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_trans_resv.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_mount.h"
+#include "xfs_log_priv.h"
+#include "xfs_log.h"
+
+/*
+ * Helper to commit and regrant the log ticket as if the transaction is be=
ing
+ * rolled. The ticket is expected to be held by the caller and can be reus=
ed in
+ * a subsequent transaction.
+ */
+static int
+xfs_trans_commit_regrant(
+=09struct xfs_trans=09*tp)
+{
+=09struct xfs_mount=09*mp =3D tp->t_mountp;
+=09struct xlog_ticket=09*tic =3D tp->t_ticket;
+=09int=09=09=09error;
+
+=09ASSERT(atomic_read(&tic->t_ref) > 1);
+=09error =3D __xfs_trans_commit(tp, true);
+=09if (!error)
+=09=09error =3D xfs_log_regrant(mp, tic);
+=09return error;
+}
+
+static void
+xfs_relog_worker(
+=09struct work_struct=09*work)
+{
+=09struct xfs_trans_relog=09*trp =3D container_of(work,
+=09=09=09=09=09struct xfs_trans_relog, tr_work);
+=09struct xfs_log_item=09*lip =3D trp->tr_lip;
+=09struct xfs_mount=09*mp =3D lip->li_mountp;
+=09struct xfs_trans_res=09resv =3D {};
+=09struct xfs_trans=09*tp;
+=09int=09=09=09error;
+
+=09error =3D xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
+=09if (error)
+=09=09return;
+
+=09/* associate the caller ticket with our empty transaction */
+=09tp->t_log_res =3D trp->tr_log_res;
+=09tp->t_log_count =3D trp->tr_log_count;
+=09tp->t_flags |=3D XFS_TRANS_PERM_LOG_RES;
+=09tp->t_ticket =3D xfs_log_ticket_get(trp->tr_tic);
+
+=09xfs_trans_add_item(tp, lip);
+=09tp->t_flags |=3D XFS_TRANS_DIRTY;
+=09set_bit(XFS_LI_DIRTY, &lip->li_flags);
+
+=09/* commit the transaction and regrant the ticket for the next time */
+=09error =3D xfs_trans_commit_regrant(tp);
+=09ASSERT(!error);
+}
+
+void
+xfs_trans_relog_queue(
+=09struct xfs_log_item=09*lip)
+{
+=09struct xfs_mount=09*mp =3D lip->li_mountp;
+=09struct xfs_trans_relog=09*trp =3D lip->li_priv;
+
+=09if (!trp)
+=09=09return;
+
+=09queue_work(mp->m_log->l_relog_workqueue, &trp->tr_work);
+}
+
+/*
+ * Commit the caller transaction, regrant the ticket and use it for automa=
tic
+ * relogging of the provided log item.
+ */
+int
+xfs_trans_relog(
+=09struct xfs_trans=09*tp,
+=09struct xfs_log_item=09*lip)
+{
+=09struct xfs_trans_relog=09*trp;
+=09int=09=09=09error;
+
+=09trp =3D kmem_zalloc(sizeof(struct xfs_trans_relog), KM_MAYFAIL);
+=09if (!trp) {
+=09=09xfs_trans_cancel(tp);
+=09=09return -ENOMEM;
+=09}
+
+=09INIT_WORK(&trp->tr_work, xfs_relog_worker);
+=09trp->tr_lip =3D lip;
+=09trp->tr_tic =3D xfs_log_ticket_get(tp->t_ticket);
+=09trp->tr_log_res =3D tp->t_log_res;
+=09trp->tr_log_count =3D tp->t_log_count;
+=09lip->li_priv =3D trp;
+
+=09error =3D xfs_trans_commit_regrant(tp);
+=09if (error) {
+=09=09xfs_log_ticket_put(trp->tr_tic);
+=09=09kmem_free(trp);
+=09}
+
+=09return error;
+}
+
+void
+xfs_trans_relog_cancel(
+=09struct xfs_log_item=09*lip)
+{
+=09struct xfs_trans_relog=09*trp =3D lip->li_priv;
+=09struct xfs_mount=09*mp =3D lip->li_mountp;
+
+=09/* cancel queued relog task */
+=09cancel_work_sync(&trp->tr_work);
+=09lip->li_priv =3D NULL;
+
+=09/* release log reservation and free ticket */
+=09ASSERT(atomic_read(&trp->tr_tic->t_ref) =3D=3D 1);
+=09xfs_log_done(mp, trp->tr_tic, NULL, false);
+=09kmem_free(trp);
+}
--=20
2.20.1

