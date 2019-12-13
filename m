Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F066C79DD2
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 638562475E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQ0wn4Sf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfLMRNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 12:13:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22745 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728499AbfLMRND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 12:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576257182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwkYKiUHtj7CaDxXi8Sh1vXISywARsb34IjL34MhF44=;
        b=CQ0wn4SfSBczgwCMWwoZAm1Xj0Epn2g0mRh0I2CaI1qFQ5TGgwQI52V+3Kc8MyT8pCbGwq
        JmbJ6S4V+O5W5ScmcZnT9VzzM8uXye8ICR/fNkYPBM7YAjzbEIvspCRZPIoVEPIenn7qW8
        79aR7/Vr4/mIzh5S7eqXneyYgBDXSDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-I_zOUdGoNkuipWD7XrcYBA-1; Fri, 13 Dec 2019 12:13:00 -0500
X-MC-Unique: I_zOUdGoNkuipWD7XrcYBA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EDEC801E70
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:59 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EB5919C4F
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:59 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: rework collapse range into an atomic operation
Date:   Fri, 13 Dec 2019 12:12:58 -0500
Message-Id: <20191213171258.36934-4-bfoster@redhat.com>
In-Reply-To: <20191213171258.36934-1-bfoster@redhat.com>
References: <20191213171258.36934-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The collapse range operation uses a unique transaction and ilock
cycle for the hole punch and each extent shift iteration of the
overall operation. While the hole punch is safe as a separate
operation due to the iolock, cycling the ilock after each extent
shift is risky similar to insert range.

To avoid this problem, make collapse range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and finish dfops on each iteration to perform pending frees and roll
the transaction. Remove the unnecessary quota reservation as
collapse range can only ever merge extents (and thus remove extent
records and potentially free bmap blocks). The dfops call
automatically relogs the inode to keep it moving in the log. This
guarantees that nothing else can change the extent mapping of an
inode while a collapse range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 555c8b49a223..1c34a34997ca 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1050,7 +1050,6 @@ xfs_collapse_file_space(
 	int			error;
 	xfs_fileoff_t		next_fsb =3D XFS_B_TO_FSB(mp, offset + len);
 	xfs_fileoff_t		shift_fsb =3D XFS_B_TO_FSB(mp, len);
-	uint			resblks =3D XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	bool			done =3D false;
=20
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
@@ -1066,32 +1065,34 @@ xfs_collapse_file_space(
 	if (error)
 		return error;
=20
-	while (!error && !done) {
-		error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
-					&tp);
-		if (error)
-			break;
+	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+	if (error)
+		return error;
=20
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error =3D xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
-				ip->i_gdquot, ip->i_pdquot, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
-		if (error)
-			goto out_trans_cancel;
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
=20
+	while (!done) {
 		error =3D xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
 				&done);
 		if (error)
 			goto out_trans_cancel;
+		if (done)
+			break;
=20
-		error =3D xfs_trans_commit(tp);
+		/* finish any deferred frees and roll the transaction */
+		error =3D xfs_defer_finish(&tp);
+		if (error)
+			goto out_trans_cancel;
 	}
=20
+	error =3D xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
=20
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
=20
--=20
2.20.1

