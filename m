Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A97C11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4EC6246BF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WIEgpNF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgB0OsK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:48:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729969AbgB0Nn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xBO7XFaQ4Q2SAQVY0hNR9OS7IAuRDc8MaivqtJGyOY=;
        b=WIEgpNF1rFXhh20ZtZ6UkG3g9/g0QwUNXKoP34D9bHIkL1aMUyGvtX3vv13VRa2apqATYB
        0tqJLDz3fuBrCw88HlvCxAflgyM8hkCb/21YFKscRgFI0jJFM5nBe70DBQD5Y005UrDTGS
        14IujU2sS+D7Nxd+X8gReTkLBL399T0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-FubtAjoGPs68uPRq0rZ3aQ-1; Thu, 27 Feb 2020 08:43:25 -0500
X-MC-Unique: FubtAjoGPs68uPRq0rZ3aQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FF6418A8C88
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:24 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67F975D9CD
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:24 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 8/9] xfs: create an error tag for random relog reservation
Date:   Thu, 27 Feb 2020 08:43:20 -0500
Message-Id: <20200227134321.7238-9-bfoster@redhat.com>
In-Reply-To: <20200227134321.7238-1-bfoster@redhat.com>
References: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Create an errortag to randomly enable relogging on permanent
transactions. This only stresses relog reservation management and
does not enable relogging of any particular items. The tag will be
reused in a subsequent patch to enable random item relogging.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 fs/xfs/xfs_trans.c           | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

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
index 331765afc53e..2838b909287e 100644
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
index f7f2411ead4e..24e0208b74b8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_errortag.h"
=20
 kmem_zone_t	*xfs_trans_zone;
=20
@@ -263,6 +264,11 @@ xfs_trans_alloc(
 	struct xfs_trans	*tp;
 	int			error;
=20
+	/* relogging requires permanent transactions */
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RELOG) &&
+	    resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
+		flags |=3D XFS_TRANS_RELOG;
+
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting u=
p
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
--=20
2.21.1

