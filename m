Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3811C2BA2B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A39CD21D7F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jqh82WVG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgDFMgl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31358 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728000AbgDFMgl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvvC4xC5phYqySWw9mG5mHi26cYNkk3iyHHo8HBoJ+U=;
        b=Jqh82WVGydDXsmFz/UBNA1avlyS7ud2Z4BaOgt9RsffWIfa2iWlT9vxXzfBY3XbUzDZ9b2
        U2Bz3ZyvX/a47SFz9Okhzs51ZWNgqmv3INEPPPWVt4HGT+5Y1ATLTSEHC7yTM9iaqMDCSz
        ltYbDz81ewqzxZ+/xcq00taifg463dY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-fMDUAmoWN-KkaVejo1d0mw-1; Mon, 06 Apr 2020 08:36:38 -0400
X-MC-Unique: fMDUAmoWN-KkaVejo1d0mw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F88C19251A4
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B30960BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 09/10] xfs: create an error tag for random relog reservation
Date:   Mon,  6 Apr 2020 08:36:31 -0400
Message-Id: <20200406123632.20873-10-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
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
index 79e6c4fb1d8a..ca7bcadb9455 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -55,7 +55,8 @@
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
-#define XFS_ERRTAG_MAX					35
+#define XFS_ERRTAG_RELOG				35
+#define XFS_ERRTAG_MAX					36
=20
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -95,5 +96,6 @@
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
+#define XFS_RANDOM_RELOG				XFS_RANDOM_DEFAULT
=20
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a21e9cc6516a..9d1f9b4c50ea 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -53,6 +53,7 @@ static unsigned int xfs_errortag_random_default[] =3D {
 	XFS_RANDOM_FORCE_SCRUB_REPAIR,
 	XFS_RANDOM_FORCE_SUMMARY_RECALC,
 	XFS_RANDOM_IUNLINK_FALLBACK,
+	XFS_RANDOM_RELOG,
 };
=20
 struct xfs_errortag_attr {
@@ -162,6 +163,7 @@ XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_=
REF);
 XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
+XFS_ERRORTAG_ATTR_RW(relog,		XFS_ERRTAG_RELOG);
=20
 static struct attribute *xfs_errortag_attrs[] =3D {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -199,6 +201,7 @@ static struct attribute *xfs_errortag_attrs[] =3D {
 	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
 	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
+	XFS_ERRORTAG_ATTR_LIST(relog),
 	NULL,
 };
=20
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 31ef5f671341..d7ca70a35d33 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_defer.h"
 #include "xfs_log_priv.h"
+#include "xfs_errortag.h"
=20
 kmem_zone_t	*xfs_trans_zone;
=20
@@ -179,9 +180,10 @@ xfs_trans_reserve(
 	if (resp->tr_logres > 0) {
 		bool	permanent =3D false;
 		bool	relog	  =3D (tp->t_flags & XFS_TRANS_RELOG);
+		int	logres =3D resp->tr_logres;
=20
 		ASSERT(tp->t_log_res =3D=3D 0 ||
-		       tp->t_log_res =3D=3D resp->tr_logres);
+		       tp->t_log_res =3D=3D logres);
 		ASSERT(tp->t_log_count =3D=3D 0 ||
 		       tp->t_log_count =3D=3D resp->tr_logcount);
=20
@@ -197,9 +199,18 @@ xfs_trans_reserve(
 			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
 			error =3D xfs_log_regrant(mp, tp->t_ticket);
 		} else {
-			error =3D xfs_log_reserve(mp,
-						resp->tr_logres,
-						resp->tr_logcount,
+			/*
+			 * Enable relog overhead on random transactions to support
+			 * random item relogging.
+			 */
+			if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RELOG) &&
+			    !relog) {
+				tp->t_flags |=3D XFS_TRANS_RELOG;
+				relog =3D true;
+				logres <<=3D 1;
+			}
+
+			error =3D xfs_log_reserve(mp, logres, resp->tr_logcount,
 						&tp->t_ticket, XFS_TRANSACTION,
 						permanent, relog);
 		}
@@ -207,7 +218,7 @@ xfs_trans_reserve(
 		if (error)
 			goto undo_blocks;
=20
-		tp->t_log_res =3D resp->tr_logres;
+		tp->t_log_res =3D logres;
 		tp->t_log_count =3D resp->tr_logcount;
 	}
=20
--=20
2.21.1

