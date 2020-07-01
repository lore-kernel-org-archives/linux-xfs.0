Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E2DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12F312078D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FAvFrGy+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732556AbgGAQvZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732525AbgGAQvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/l9AWpZXFFOxsrk3+0TznxZQjWL+FNAtx/9p0cKrjs=;
        b=FAvFrGy+8Wzzje8qY5w+75Tlr0iDKYY31zsypGHLyukY1BC3YvRtWxMxjeQazl0b86J9Sc
        StXee2lT9Qbs5sTEmdI7ytCD4/thQSFdjdRsmRXcbOWNeRrEYrxcc701ExQp6GS2B0soYg
        suhg9euS4xrsUDzm8K2hYcRgb71g5s0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-NzWnCjtyNj-CVQI4-gLsoQ-1; Wed, 01 Jul 2020 12:51:19 -0400
X-MC-Unique: NzWnCjtyNj-CVQI4-gLsoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E838C18FF660
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:17 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0A995C6C0
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:17 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] xfs: create helper for ticket-less log res ungrant
Date:   Wed,  1 Jul 2020 12:51:08 -0400
Message-Id: <20200701165116.47344-3-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
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
 
+/*
+ * Restore log reservation directly to the grant heads.
+ */
+void
+xfs_log_ungrant_bytes(
+	struct xfs_mount	*mp,
+	int			bytes)
+{
+	struct xlog		*log = mp->m_log;
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
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
-	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
-
+	xfs_log_ungrant_bytes(log->l_mp, bytes);
 	trace_xfs_log_ticket_ungrant_exit(log, ticket);
 
-	xfs_log_space_wake(log->l_mp);
 	xfs_log_ticket_put(ticket);
 }
 
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
 
-- 
2.21.3

