Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2871C3F2CE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 17:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1B1120679
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 17:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c/B+z0ON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbgCPRXQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 13:23:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29482 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731745AbgCPRXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 13:23:16 -0400
X-Greylist: delayed 6496 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 13:23:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584379395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNI79X6LXUoSmyayTk7jy/34Q/yfZAWHYshJWxicvHg=;
        b=c/B+z0ONgU9S7gFpUrZYZm3enLCzw9zO5vpulQTHNV74HhjSmzQiOOxuwrafyeiXTIFh3n
        LRYu9KpIXnUmgfsGpO6c57Sdmb0EgL+6KKkyewNRiBFEM5i/ZLoMv7yS73p2cZ8BGkdKos
        p2TjgQRj2RsPE4WWEWtTWjOpIsuv3n4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-pIGEez63Od6bmYkH6ZYcUQ-1; Mon, 16 Mar 2020 13:23:13 -0400
X-MC-Unique: pIGEez63Od6bmYkH6ZYcUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C611198F34D
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 17:00:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 238115C1B2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 17:00:33 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: factor out quotaoff intent AIL removal and memory free
Date:   Mon, 16 Mar 2020 13:00:31 -0400
Message-Id: <20200316170032.19552-2-bfoster@redhat.com>
In-Reply-To: <20200316170032.19552-1-bfoster@redhat.com>
References: <20200316170032.19552-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

AIL removal of the quotaoff start intent and free of both intents is
hardcoded to the ->iop_committed() handler of the end intent. Factor
out the start intent handling code so it can be used in a future
patch to properly handle quotaoff errors. Use xfs_trans_ail_remove()
instead of the _delete() variant to acquire the AIL lock and also
handle cases where an intent might not reside in the AIL at the
time of a failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot_item.c | 29 ++++++++++++++++++++---------
 fs/xfs/xfs_dquot_item.h |  1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d60647d7197b..2b816e9b4465 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -307,18 +307,10 @@ xfs_qm_qoffend_logitem_committed(
 {
 	struct xfs_qoff_logitem	*qfe =3D QOFF_ITEM(lip);
 	struct xfs_qoff_logitem	*qfs =3D qfe->qql_start_lip;
-	struct xfs_ail		*ailp =3D qfs->qql_item.li_ailp;
=20
-	/*
-	 * Delete the qoff-start logitem from the AIL.
-	 * xfs_trans_ail_delete() drops the AIL lock.
-	 */
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
+	xfs_qm_qoff_logitem_relse(qfs);
=20
-	kmem_free(qfs->qql_item.li_lv_shadow);
 	kmem_free(lip->li_lv_shadow);
-	kmem_free(qfs);
 	kmem_free(qfe);
 	return (xfs_lsn_t)-1;
 }
@@ -336,6 +328,25 @@ static const struct xfs_item_ops xfs_qm_qoff_logitem=
_ops =3D {
 	.iop_push	=3D xfs_qm_qoff_logitem_push,
 };
=20
+/*
+ * Delete the quotaoff intent from the AIL and free it. On success,
+ * this should only be called for the start item. It can be used for
+ * either on shutdown or abort.
+ */
+void
+xfs_qm_qoff_logitem_relse(
+	struct xfs_qoff_logitem	*qoff)
+{
+	struct xfs_log_item	*lip =3D &qoff->qql_item;
+
+	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
+	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
+	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+	kmem_free(lip->li_lv_shadow);
+	kmem_free(qoff);
+}
+
 /*
  * Allocate and initialize an quotaoff item of the correct quota type(s)=
.
  */
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 3bb19e556ade..2b86a43d7ce2 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -28,6 +28,7 @@ void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
 struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
 		struct xfs_qoff_logitem *start,
 		uint flags);
+void xfs_qm_qoff_logitem_relse(struct xfs_qoff_logitem *);
 struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
 		struct xfs_qoff_logitem *startqoff,
 		uint flags);
--=20
2.21.1

