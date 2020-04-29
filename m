Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF7BC83010
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46108208FE
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVB0wWVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgD2RWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgD2RWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RH7zbJV6VZB8lPEmJKtiv8Ld+uaUBW56C2rKP8lyeE8=;
        b=VVB0wWVfkrTCC+E/AffK+K1EwJNHHg8CYJPjXR2SIQwymzslcqe0py1BvtlgRjnCjz7OnD
        NTkEwABs/SsK1Fy6i+JmoI2fwO25OfXDhF5jUYW+65e3Wg0hQrJvDuM7crRRAir6MNRasz
        Tmx1Aeel4uKtzyxr5pgI4KC3KOQOc3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Ljr0jLWRPpewc9MaJ4P5nA-1; Wed, 29 Apr 2020 13:22:04 -0400
X-MC-Unique: Ljr0jLWRPpewc9MaJ4P5nA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A89931083E87
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:03 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EC665C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 15/17] xfs: random buffer write failure errortag
Date:   Wed, 29 Apr 2020 13:21:51 -0400
Message-Id: <20200429172153.41680-16-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce an error tag to randomly fail async buffer writes. This is
primarily to facilitate testing of the XFS error configuration
mechanism.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_buf.c             | 6 ++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 79e6c4fb1d8a..2486dab19023 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -55,7 +55,8 @@
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
-#define XFS_ERRTAG_MAX					35
+#define XFS_ERRTAG_BUF_IOERROR				35
+#define XFS_ERRTAG_MAX					36
=20
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -95,5 +96,6 @@
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
+#define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
=20
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8f0f605de579..61629efd56ee 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1289,6 +1289,12 @@ xfs_buf_bio_end_io(
 	struct bio		*bio)
 {
 	struct xfs_buf		*bp =3D (struct xfs_buf *)bio->bi_private;
+	struct xfs_mount	*mp =3D bp->b_mount;
+
+	if (!bio->bi_status &&
+	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_IOERROR))
+		bio->bi_status =3D BLK_STS_IOERR;
=20
 	/*
 	 * don't overwrite existing errors - otherwise we can lose errors on
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a21e9cc6516a..7f6e20899473 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -53,6 +53,7 @@ static unsigned int xfs_errortag_random_default[] =3D {
 	XFS_RANDOM_FORCE_SCRUB_REPAIR,
 	XFS_RANDOM_FORCE_SUMMARY_RECALC,
 	XFS_RANDOM_IUNLINK_FALLBACK,
+	XFS_RANDOM_BUF_IOERROR,
 };
=20
 struct xfs_errortag_attr {
@@ -162,6 +163,7 @@ XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_=
REF);
 XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
+XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
=20
 static struct attribute *xfs_errortag_attrs[] =3D {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -199,6 +201,7 @@ static struct attribute *xfs_errortag_attrs[] =3D {
 	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
 	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
+	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	NULL,
 };
=20
--=20
2.21.1

