Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4B5C79DD1
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23060247D7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heunZ1ij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfLMRND (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 12:13:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21973 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728453AbfLMRND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 12:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576257181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wzvEQw/+O+ETUDcGPqQq1dwpqJK9rd7JfL9EeC3OR3s=;
        b=heunZ1ije6wMmoo+hFs6N6vPORXHHr7H5K+8hiibG4aE3b7f9pT/CFj1LBO5X0lztdTaPa
        +CVTn2OVImXiPw9WO+fBzdmTr8yg9r+GXAefVkPlWdkt7UNtrHJcFqx5xlfeU0ZhEoLmdL
        PstlJpAzb8XxTS1y5OUSmOqKqnpP+RE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-5-Kgi_c4PaO0TnrcQsHS7w-1; Fri, 13 Dec 2019 12:13:00 -0500
X-MC-Unique: 5-Kgi_c4PaO0TnrcQsHS7w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D4F5911AC
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:59 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFAB319C4F
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: rework insert range into an atomic operation
Date:   Fri, 13 Dec 2019 12:12:57 -0500
Message-Id: <20191213171258.36934-3-bfoster@redhat.com>
In-Reply-To: <20191213171258.36934-1-bfoster@redhat.com>
References: <20191213171258.36934-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The insert range operation uses a unique transaction and ilock cycle
for the extent split and each extent shift iteration of the overall
operation. While this works, it is risks racing with other
operations in subtle ways such as COW writeback modifying an extent
tree in the middle of a shift operation.

To avoid this problem, make insert range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and relog the inode to keep it moving in the log. This guarantees
that nothing else can change the extent mapping of an inode while
an insert range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 829ab1a804c9..555c8b49a223 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1134,47 +1134,41 @@ xfs_insert_file_space(
 	if (error)
 		return error;
=20
-	/*
-	 * The extent shifting code works on extent granularity. So, if stop_fs=
b
-	 * is not the starting block of extent, we need to split the extent at
-	 * stop_fsb.
-	 */
 	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
 	if (error)
 		return error;
=20
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
=20
+	/*
+	 * The extent shifting code works on extent granularity. So, if stop_fs=
b
+	 * is not the starting block of extent, we need to split the extent at
+	 * stop_fsb.
+	 */
 	error =3D xfs_bmap_split_extent(tp, ip, stop_fsb);
 	if (error)
 		goto out_trans_cancel;
=20
-	error =3D xfs_trans_commit(tp);
-	if (error)
-		return error;
-
-	while (!error && !done) {
-		error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
-					&tp);
+	do {
+		error =3D xfs_trans_roll_inode(&tp, ip);
 		if (error)
-			break;
+			goto out_trans_cancel;
=20
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		error =3D xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, stop_fsb);
 		if (error)
 			goto out_trans_cancel;
+	} while (!done);
=20
-		error =3D xfs_trans_commit(tp);
-	}
-
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

