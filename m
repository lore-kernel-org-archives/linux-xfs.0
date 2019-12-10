Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43972C00454
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 13:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 182612077B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 13:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dw5NEvBO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfLJNXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 08:23:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727531AbfLJNXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 08:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575984222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D8JfQHwWFx7xmqDBrSHgo/WK10YN7tv32dZFqLE/zR8=;
        b=dw5NEvBOjLVU4qVTT3hG5lGAN99KBhbYzv2eeyevNtedt4Kq8YrhniUQHZk4UYrASDGSpB
        c0SRByhqKqfDGB38i5L91+9HNMX7PeIaHcXXeqNOCnl4a8At2Ju8CzjBjSM5bvD+Cu90h9
        5W3wRKcnPEYvl9HgYQPSiq7SEHJb8Fg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-W-Eavp2ONNS0yE--tHSgBw-1; Tue, 10 Dec 2019 08:23:41 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46AAB801E66
        for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2019 13:23:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0506A5C1B0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2019 13:23:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: stabilize insert range start boundary to avoid COW writeback race
Date:   Tue, 10 Dec 2019 08:23:40 -0500
Message-Id: <20191210132340.11330-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: W-Eavp2ONNS0yE--tHSgBw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

generic/522 (fsx) occasionally fails with a file corruption due to
an insert range operation. The primary characteristic of the
corruption is a misplaced insert range operation that differs from
the requested target offset. The reason for this behavior is a race
between the extent shift sequence of an insert range and a COW
writeback completion that causes a front merge with the first extent
in the shift.

The shift preparation function flushes and unmaps from the target
offset of the operation to the end of the file to ensure no
modifications can be made and page cache is invalidated before file
data is shifted. An insert range operation then splits the extent at
the target offset, if necessary, and begins to shift the start
offset of each extent starting from the end of the file to the start
offset. The shift sequence operates at extent level and so depends
on the preparation sequence to guarantee no changes can be made to
the target range during the shift. If the block immediately prior to
the target offset was dirty and shared, however, it can undergo
writeback and move from the COW fork to the data fork at any point
during the shift. If the block is contiguous with the block at the
start offset of the insert range, it can front merge and alter the
start offset of the extent. Once the shift sequence reaches the
target offset, it shifts based on the latest start offset and
silently changes the target offset of the operation and corrupts the
file.

To address this problem, update the shift preparation code to
stabilize the start boundary along with the full range of the
insert. Also update the existing corruption check to fail if any
extent is shifted with a start offset behind the target offset of
the insert range. This prevents insert from racing with COW
writeback completion and fails loudly in the event of an unexpected
extent shift.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This has survived a couple fstests runs (upstream) so far as well as an
overnight loop test of generic/522 (on RHEL). The RHEL based kernel just
happened to be where this was originally diagnosed and provides a fairly
reliable failure rate of within 30 iterations or so. The current test is
at almost 70 iterations and still running.

Brian

 fs/xfs/libxfs/xfs_bmap.c |  3 +--
 fs/xfs/xfs_bmap_util.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a9ad1f991ba3..4a802b3abe77 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5972,8 +5972,7 @@ xfs_bmap_insert_extents(
 =09=09goto del_cursor;
 =09}
=20
-=09if (XFS_IS_CORRUPT(mp,
-=09=09=09   stop_fsb >=3D got.br_startoff + got.br_blockcount)) {
+=09if (XFS_IS_CORRUPT(mp, stop_fsb > got.br_startoff)) {
 =09=09error =3D -EFSCORRUPTED;
 =09=09goto del_cursor;
 =09}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2efd78a9719e..e62fb5216341 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -992,6 +992,7 @@ xfs_prepare_shift(
 =09struct xfs_inode=09*ip,
 =09loff_t=09=09=09offset)
 {
+=09struct xfs_mount=09*mp =3D ip->i_mount;
 =09int=09=09=09error;
=20
 =09/*
@@ -1004,6 +1005,17 @@ xfs_prepare_shift(
 =09=09=09return error;
 =09}
=20
+=09/*
+=09 * Shift operations must stabilize the start block offset boundary alon=
g
+=09 * with the full range of the operation. If we don't, a COW writeback
+=09 * completion could race with an insert, front merge with the start
+=09 * extent (after split) during the shift and corrupt the file. Start
+=09 * with the block just prior to the start to stabilize the boundary.
+=09 */
+=09offset =3D round_down(offset, 1 << mp->m_sb.sb_blocklog);
+=09if (offset)
+=09=09offset -=3D (1 << mp->m_sb.sb_blocklog);
+
 =09/*
 =09 * Writeback and invalidate cache for the remainder of the file as we'r=
e
 =09 * about to shift down every extent from offset to EOF.
--=20
2.20.1

