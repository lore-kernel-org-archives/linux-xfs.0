Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BF1C79DD3
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3892475E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnYygAAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbfLMRNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 12:13:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50541 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728453AbfLMRNE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 12:13:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576257183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwlou5WbSD8CQGyyzmWQEiuYNVpACM6xlEvpdfqwxFM=;
        b=HnYygAADagU9we0nvY/Y5PUuDgCJ9G1B5KOQD3+gDUFKkjRRLwAcraUbpMwyHy7ZhHSS3p
        hdWq0Tq+7QJJ2kWfiWDnYRWqIbU78URemf5OQX7aScX2ACg/VA4sZeq6HyxhfL8cXhGQja
        KL5oBZXpclB0txMrkoa0QQLMMynuHA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-ixrY5woQN3Gi-JdI9VC8HA-1; Fri, 13 Dec 2019 12:12:59 -0500
X-MC-Unique: ixrY5woQN3Gi-JdI9VC8HA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBEA11005512
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:58 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B8E219C4F
        for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2019 17:12:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: open code insert range extent split helper
Date:   Fri, 13 Dec 2019 12:12:56 -0500
Message-Id: <20191213171258.36934-2-bfoster@redhat.com>
In-Reply-To: <20191213171258.36934-1-bfoster@redhat.com>
References: <20191213171258.36934-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The insert range operation currently splits the extent at the target
offset in a separate transaction and lock cycle from the one that
shifts extents. In preparation for reworking insert range into an
atomic operation, lift the code into the caller so it can be easily
condensed to a single rolling transaction and lock cycle and
eliminate the helper. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 32 ++------------------------------
 fs/xfs/libxfs/xfs_bmap.h |  3 ++-
 fs/xfs/xfs_bmap_util.c   | 14 +++++++++++++-
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a9ad1f991ba3..2bba0f983e4f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6021,8 +6021,8 @@ xfs_bmap_insert_extents(
  * @split_fsb is a block where the extents is split.  If split_fsb lies =
in a
  * hole or the first block of extents, just return 0.
  */
-STATIC int
-xfs_bmap_split_extent_at(
+int
+xfs_bmap_split_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb)
@@ -6138,34 +6138,6 @@ xfs_bmap_split_extent_at(
 	return error;
 }
=20
-int
-xfs_bmap_split_extent(
-	struct xfs_inode        *ip,
-	xfs_fileoff_t           split_fsb)
-{
-	struct xfs_mount        *mp =3D ip->i_mount;
-	struct xfs_trans        *tp;
-	int                     error;
-
-	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
-			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
-	if (error)
-		return error;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-	error =3D xfs_bmap_split_extent_at(tp, ip, split_fsb);
-	if (error)
-		goto out;
-
-	return xfs_trans_commit(tp);
-
-out:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /* Deferred mapping is only for real extents in the data fork. */
 static bool
 xfs_bmap_is_update_needed(
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 14d25e0b7d9c..f3259ad5c22c 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -222,7 +222,8 @@ int	xfs_bmap_can_insert_extents(struct xfs_inode *ip,=
 xfs_fileoff_t off,
 int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done, xfs_fileoff_t stop_fsb);
-int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offs=
et);
+int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2efd78a9719e..829ab1a804c9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1139,7 +1139,19 @@ xfs_insert_file_space(
 	 * is not the starting block of extent, we need to split the extent at
 	 * stop_fsb.
 	 */
-	error =3D xfs_bmap_split_extent(ip, stop_fsb);
+	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error =3D xfs_bmap_split_extent(tp, ip, stop_fsb);
+	if (error)
+		goto out_trans_cancel;
+
+	error =3D xfs_trans_commit(tp);
 	if (error)
 		return error;
=20
--=20
2.20.1

