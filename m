Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8274EC43215
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BC772067D
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTYKZJJk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKVSTb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:19:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29517 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726705AbfKVSTa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 13:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574446770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qPo0z2c6uL+IP0iWk/Dew8QgM3QDOBAiOKjiMQpyKXo=;
        b=LTYKZJJkchRQKY+RoogYGzMc2onNgwxysbMs/OkmhYcOyOomr77rnTw9lEhmj6QvXbr1Up
        GiwFinGvtksPe9P9pMCXmWmXmlS7alPh/iFQ9tLfvyoKNVyTpgzRASMF018EAPVJ6LhfTW
        jBp/07Ky1kC90LT41QT0ObywL595/M4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-7zNHOT4BPc-beI8cBROSpQ-1; Fri, 22 Nov 2019 13:19:28 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCC031883522
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:27 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84A4A6E71F
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:27 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v2 PATCH 3/3] xfs: automatically relog quotaoff start intent
Date:   Fri, 22 Nov 2019 13:19:27 -0500
Message-Id: <20191122181927.32870-4-bfoster@redhat.com>
In-Reply-To: <20191122181927.32870-1-bfoster@redhat.com>
References: <20191122181927.32870-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 7zNHOT4BPc-beI8cBROSpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  3 ++-
 fs/xfs/xfs_dquot_item.c        | 13 +++++++++++++
 fs/xfs/xfs_qm_syscalls.c       |  9 ++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.=
c
index c55cd9a3dec9..88e222d0947a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -866,7 +866,8 @@ xfs_trans_resv_calc(
 =09resp->tr_qm_setqlim.tr_logcount =3D XFS_DEFAULT_LOG_COUNT;
=20
 =09resp->tr_qm_quotaoff.tr_logres =3D xfs_calc_qm_quotaoff_reservation(mp)=
;
-=09resp->tr_qm_quotaoff.tr_logcount =3D XFS_DEFAULT_LOG_COUNT;
+=09resp->tr_qm_quotaoff.tr_logcount =3D XFS_DEFAULT_PERM_LOG_COUNT;
+=09resp->tr_qm_quotaoff.tr_logflags |=3D XFS_TRANS_PERM_LOG_RES;
=20
 =09resp->tr_qm_equotaoff.tr_logres =3D
 =09=09xfs_calc_qm_quotaoff_end_reservation();
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d60647d7197b..57b7c9b731b1 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -288,6 +288,18 @@ xfs_qm_qoff_logitem_format(
 =09xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
 }
=20
+/*
+ * XXX: simulate relog callback with hardcoded ->iop_committed() callback
+ */
+static xfs_lsn_t
+xfs_qm_qoff_logitem_committed(
+=09struct xfs_log_item=09*lip,
+=09xfs_lsn_t=09=09lsn)
+{
+=09xfs_trans_relog_queue(lip);
+=09return lsn;
+}
+
 /*
  * There isn't much you can do to push a quotaoff item.  It is simply
  * stuck waiting for the log to be flushed to disk.
@@ -333,6 +345,7 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem=
_ops =3D {
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops =3D {
 =09.iop_size=09=3D xfs_qm_qoff_logitem_size,
 =09.iop_format=09=3D xfs_qm_qoff_logitem_format,
+=09.iop_committed=09=3D xfs_qm_qoff_logitem_committed,
 =09.iop_push=09=3D xfs_qm_qoff_logitem_push,
 };
=20
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..3f15f8576027 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
=20
 STATIC int
 xfs_qm_log_quotaoff(
@@ -50,7 +51,7 @@ xfs_qm_log_quotaoff(
 =09 * We don't care about quotoff's performance.
 =09 */
 =09xfs_trans_set_sync(tp);
-=09error =3D xfs_trans_commit(tp);
+=09error =3D xfs_trans_relog(tp, &qoffi->qql_item);
 =09if (error)
 =09=09goto out;
=20
@@ -227,7 +228,13 @@ xfs_qm_scall_quotaoff(
 =09 *
 =09 * So, we have QUOTAOFF start and end logitems; the start
 =09 * logitem won't get overwritten until the end logitem appears...
+=09 *
+=09 * XXX: qoffend expects qoffstart in the AIL but not in the CIL. Force
+=09 * the log after cancelling relogging to prevent item reinsert...
 =09 */
+=09//ssleep(3);
+=09xfs_trans_relog_cancel(&qoffstart->qql_item);
+=09xfs_log_force(mp, XFS_LOG_SYNC);
 =09error =3D xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
 =09if (error) {
 =09=09/* We're screwed now. Shutdown is the only option. */
--=20
2.20.1

