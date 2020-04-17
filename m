Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A9AC38A2E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F390721924
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZHbdQ1/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgDQPJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:09:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728852AbgDQPJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r/P9fWlZZlP1VXzxENU8G2/Bi5QqxOKryo3/Ck9Brg8=;
        b=aZHbdQ1/l5eWkomBj2qfo3iV/uq0DlkX3RZeoAxzAX/5YRpQnMiFIaG6SI4REWr/Fa4ajV
        umsTgx7fiyc7RapZdTO2IU2kvRAW60rBcUqXFs+nD7qEQ9Rg6vy1LhCcH8RxGwxbIUefYJ
        51UGlgid/UXElZl+d/6m4kwh6ftn+h8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-ZGjLdPJVPP6Fbfs3zHXoiA-1; Fri, 17 Apr 2020 11:09:04 -0400
X-MC-Unique: ZGjLdPJVPP6Fbfs3zHXoiA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8EA380268B
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:03 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F77760BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/12] xfs: remove unnecessary quotaoff intent item push handler
Date:   Fri, 17 Apr 2020 11:08:55 -0400
Message-Id: <20200417150859.14734-9-bfoster@redhat.com>
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The quotaoff intent item push handler unconditionally returns locked
status because it remains AIL resident until removed by the
quotafoff end intent. xfsaild_push_item() already returns pinned
status for items (generally intents) without a push handler. This is
effectively the same behavior for the purpose of quotaoff, so remove
the unnecessary quotaoff push handler.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot_item.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 5a7808299a32..582b3796a0c9 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -274,18 +274,6 @@ xfs_qm_qoff_logitem_format(
 	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
 }
=20
-/*
- * There isn't much you can do to push a quotaoff item.  It is simply
- * stuck waiting for the log to be flushed to disk.
- */
-STATIC uint
-xfs_qm_qoff_logitem_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_LOCKED;
-}
-
 STATIC xfs_lsn_t
 xfs_qm_qoffend_logitem_committed(
 	struct xfs_log_item	*lip,
@@ -318,14 +306,12 @@ static const struct xfs_item_ops xfs_qm_qoffend_log=
item_ops =3D {
 	.iop_size	=3D xfs_qm_qoff_logitem_size,
 	.iop_format	=3D xfs_qm_qoff_logitem_format,
 	.iop_committed	=3D xfs_qm_qoffend_logitem_committed,
-	.iop_push	=3D xfs_qm_qoff_logitem_push,
 	.iop_release	=3D xfs_qm_qoff_logitem_release,
 };
=20
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops =3D {
 	.iop_size	=3D xfs_qm_qoff_logitem_size,
 	.iop_format	=3D xfs_qm_qoff_logitem_format,
-	.iop_push	=3D xfs_qm_qoff_logitem_push,
 	.iop_release	=3D xfs_qm_qoff_logitem_release,
 };
=20
--=20
2.21.1

