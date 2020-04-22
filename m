Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79358C55192
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D7D2098B
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZcHh4zO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgDVRyk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:54:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36357 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726605AbgDVRyk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQO7C5tkSZhmSxt/KZrxZrFrQuw5t2vwDNmNjag/kII=;
        b=CZcHh4zOp11zIF/cbRArBBHBq1Udm6wkcvNsMkAuVZIDFAh/GiHNhgHVM138DZc40kBQrn
        ypMKQ7rmuybXNmpfjFvsZWdiDqnMC6XA+FZrDR85jvlTLT7Kl3vFCyphTkooZWVvhJJ5dY
        MhPqChi7Hu9HKlYle/ogHwrWQAdZBDM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-ic3A-tNtOByf2TkcbzhqsA-1; Wed, 22 Apr 2020 13:54:36 -0400
X-MC-Unique: ic3A-tNtOByf2TkcbzhqsA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B98C8100CCC4
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:35 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74AF76084A
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:35 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 12/13] xfs: random buffer write failure errortag
Date:   Wed, 22 Apr 2020 13:54:28 -0400
Message-Id: <20200422175429.38957-13-bfoster@redhat.com>
In-Reply-To: <20200422175429.38957-1-bfoster@redhat.com>
References: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index c28a93d2fd8c..4d2151deacef 100644
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
+		bio->bi_status =3D errno_to_blk_status(-EIO);
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

