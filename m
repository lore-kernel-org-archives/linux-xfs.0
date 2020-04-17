Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D45C38A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7297920857
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oen9T4x/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgDQPJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:09:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48362 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728567AbgDQPJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNVK9eLDDV1r6IH4OGj/VF/51UCqF7N6jSNhxVZlvOM=;
        b=Oen9T4x/nu4Zajn9kajwPBbcPj8aXOzS3nibjlnOOO9Z85bP4+VZY476Wi3KQiNVTYB2KZ
        UBTS0l45IrPnAzi3PAsIpoXmVNnhEg5focca3ZAtIiuvWzy0HBn539MvjxcL+/xdhpRinV
        uVUEu+MWt+QUfo3eHYGnWtjPPwsUH04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-GNHGWts2OnCnFeLEFklpLw-1; Fri, 17 Apr 2020 11:09:06 -0400
X-MC-Unique: GNHGWts2OnCnFeLEFklpLw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FD128017F3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:05 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2998060BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:05 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: random buffer write failure errortag
Date:   Fri, 17 Apr 2020 11:08:59 -0400
Message-Id: <20200417150859.14734-13-bfoster@redhat.com>
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce an error tag to randomly fail async buffer writes. This is
primarily to facilitate testing of the XFS error configuration
mechanism.

Signed-off-by: Brian Foster <bfoster@redhat.com>
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
index 5120fed06075..a305db779156 100644
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

