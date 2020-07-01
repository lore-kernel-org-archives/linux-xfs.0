Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41075C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 210D420771
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a54HKeTz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbgGAQv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34784 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732561AbgGAQvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mLaeC0bAIn1f4jBZgiYGOFQJ0ynuWLVeif+dg9mEP5M=;
        b=a54HKeTzM9BiXiYHP3E/zSRke0L1wTSi004Hwrx/Brc31BHIMaE1wTW3jg9zD4znZ44Jr0
        Es7TRNrN713YCaU1e+R245PVa9deztTwlOg8AgcTTn3HUATua3OuvRABMrPonxtC0uAkKK
        4OV+az8V1sQ30zy1aj/x+jaRpoxriiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-pD4BUMQJNTGA_azWV95uUQ-1; Wed, 01 Jul 2020 12:51:22 -0400
X-MC-Unique: pD4BUMQJNTGA_azWV95uUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0819E107ACCA
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:21 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B92E25C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 09/10] xfs: create an error tag for random relog reservation
Date:   Wed,  1 Jul 2020 12:51:15 -0400
Message-Id: <20200701165116.47344-10-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Create an errortag to enable relogging on random transactions. Since
relogging requires extra transaction reservation, artificially bump
the reservation on selected transactions and tag them with the relog
flag such that the requisite reservation overhead is added by the
ticket allocation code. This allows subsequent random buffer relog
events to target transactions where reservation is included. This is
necessary to avoid transaction reservation overruns on non-relog
transactions.

Note that this does not yet enable relogging of any particular
items. The tag will be reused in a subsequent patch to enable random
buffer relogging.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_errortag.h |  4 +++-
 fs/xfs/xfs_error.c           |  3 +++
 fs/xfs/xfs_trans.c           | 21 ++++++++++++++++-----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 53b305dea381..8f360cfc666c 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -56,7 +56,8 @@
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
-#define XFS_ERRTAG_MAX					36
+#define XFS_ERRTAG_RELOG				36
+#define XFS_ERRTAG_MAX					37
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -97,5 +98,6 @@
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
+#define XFS_RANDOM_RELOG				XFS_RANDOM_DEFAULT
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7f6e20899473..562e00f7dcf5 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_FORCE_SUMMARY_RECALC,
 	XFS_RANDOM_IUNLINK_FALLBACK,
 	XFS_RANDOM_BUF_IOERROR,
+	XFS_RANDOM_RELOG,
 };
 
 struct xfs_errortag_attr {
@@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
+XFS_ERRORTAG_ATTR_RW(relog,		XFS_ERRTAG_RELOG);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
 	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
+	XFS_ERRORTAG_ATTR_LIST(relog),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 310beaccbc4c..df94ca45c7c8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_defer.h"
 #include "xfs_log_priv.h"
+#include "xfs_errortag.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -176,9 +177,10 @@ xfs_trans_reserve(
 	if (resp->tr_logres > 0) {
 		bool	permanent = false;
 		bool	relog	  = (tp->t_flags & XFS_TRANS_RELOG);
+		int	logres = resp->tr_logres;
 
 		ASSERT(tp->t_log_res == 0 ||
-		       tp->t_log_res == resp->tr_logres);
+		       tp->t_log_res == logres);
 		ASSERT(tp->t_log_count == 0 ||
 		       tp->t_log_count == resp->tr_logcount);
 
@@ -194,9 +196,18 @@ xfs_trans_reserve(
 			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
 			error = xfs_log_regrant(mp, tp->t_ticket);
 		} else {
-			error = xfs_log_reserve(mp,
-						resp->tr_logres,
-						resp->tr_logcount,
+			/*
+			 * Enable relog overhead on random transactions to support
+			 * random item relogging.
+			 */
+			if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RELOG) &&
+			    !relog) {
+				tp->t_flags |= XFS_TRANS_RELOG;
+				relog = true;
+				logres <<= 1;
+			}
+
+			error = xfs_log_reserve(mp, logres, resp->tr_logcount,
 						&tp->t_ticket, XFS_TRANSACTION,
 						permanent, relog);
 		}
@@ -204,7 +215,7 @@ xfs_trans_reserve(
 		if (error)
 			goto undo_blocks;
 
-		tp->t_log_res = resp->tr_logres;
+		tp->t_log_res = logres;
 		tp->t_log_count = resp->tr_logcount;
 	}
 
-- 
2.21.3

