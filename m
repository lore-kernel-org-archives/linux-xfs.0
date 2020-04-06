Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45F5C2BA19
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DF521D7F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BIa0nzsY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgDFMgi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42372 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgDFMgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtfDitbHqj7UDT/T3jF2Q6LlVQtM8OAZ9G+ILpaaOkU=;
        b=BIa0nzsY8xpFf7ir2Dnsyzv0LceOYEqwfvNXs2HQM/2WaUUaz5xH2qJN3UAK/MMhDdR6SN
        DRPCbTmGZLBNvrfpF07aTpKMox/riC5KvE7eLBiIwbbkhM5NtBcZyMg3rUGg2QmG3of89T
        XNM5zH8ETHr2eVOpkCflFa9nWF3DUYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-4q-oBF28PXGFXHInYRduGw-1; Mon, 06 Apr 2020 08:36:35 -0400
X-MC-Unique: 4q-oBF28PXGFXHInYRduGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8779D477
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E61460BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:34 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 02/10] xfs: create helper for ticket-less log res ungrant
Date:   Mon,  6 Apr 2020 08:36:24 -0400
Message-Id: <20200406123632.20873-3-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Log reservation is currently acquired and released via log tickets.
The relog mechanism introduces behavior where relog reservation is
transferred between transaction log tickets and an external pool of
relog reservation for active relog items. Certain contexts will be
able to release outstanding relog reservation without the need for a
log ticket. Factor out a helper to allow byte granularity log
reservation ungrant.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 20 ++++++++++++++++----
 fs/xfs/xfs_log.h |  1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00fda2e8e738..d6b63490a78b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2980,6 +2980,21 @@ xfs_log_ticket_regrant(
 	xfs_log_ticket_put(ticket);
 }
=20
+/*
+ * Restore log reservation directly to the grant heads.
+ */
+void
+xfs_log_ungrant_bytes(
+	struct xfs_mount	*mp,
+	int			bytes)
+{
+	struct xlog		*log =3D mp->m_log;
+
+	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
+	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
+	xfs_log_space_wake(mp);
+}
+
 /*
  * Give back the space left from a reservation.
  *
@@ -3018,12 +3033,9 @@ xfs_log_ticket_ungrant(
 		bytes +=3D ticket->t_unit_res*ticket->t_cnt;
 	}
=20
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
-	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
-
+	xfs_log_ungrant_bytes(log->l_mp, bytes);
 	trace_xfs_log_ticket_ungrant_exit(log, ticket);
=20
-	xfs_log_space_wake(log->l_mp);
 	xfs_log_ticket_put(ticket);
 }
=20
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 1412d6993f1e..6d2f30f42245 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -125,6 +125,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 			  uint8_t		   clientid,
 			  bool		   permanent);
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
+void	  xfs_log_ungrant_bytes(struct xfs_mount *mp, int bytes);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
=20
--=20
2.21.1

