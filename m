Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF60CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99393205C9
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:13:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PJhPgz/H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfJUMN3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:13:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20982 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727256AbfJUMN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 08:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571660006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdHkWpxy+F1KCcRsfAdo/ujoe/rUVH8BfNudXI5Jknk=;
        b=PJhPgz/HVBgLWIstoEVN1uR60FZc9UeKGrT4lpo1A3/6lOkdaM95P02bjUs59LDjct2vjV
        /407HJ69bB3fhwGRvpBSIuUOJs7/8JZnB1/eDTihiN4y21ApKycNZ2tUNeKTAHuJyKmB0r
        bajKkbQvSe+YXeT7lmklNUzmD4tOY1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-sEItk00OMZW6Mrd6qMcY5g-1; Mon, 21 Oct 2019 08:13:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C5CF800D41
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 12:13:24 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 431ED5D9E2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 12:13:24 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: don't set bmapi total block req where minleft is sufficient
Date:   Mon, 21 Oct 2019 08:13:22 -0400
Message-Id: <20191021121322.25659-3-bfoster@redhat.com>
In-Reply-To: <20191021121322.25659-1-bfoster@redhat.com>
References: <20191021121322.25659-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: sEItk00OMZW6Mrd6qMcY5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_bmapi_write() takes a total block requirement parameter that is
passed down to the block allocation code and is used to specify the
total block requirement of the associated transaction. This is used
to try and select an AG that can not only satisfy the requested
extent allocation, but can also accommodate subsequent allocations
that might be required to complete the transaction. For example,
additional bmbt block allocations may be required on insertion of
the resulting extent to an inode data fork.

While it's important for callers to calculate and reserve such extra
blocks in the transaction, it is not necessary to pass the total
value to xfs_bmapi_write() in all cases. The latter automatically
sets minleft to ensure that sufficient free blocks remain after the
allocation attempt to expand the format of the associated inode
(i.e., such as extent to btree conversion, btree splits, etc).
Therefore, any callers that pass a total block requirement of the
bmap mapping length plus worst case bmbt expansion essentially
specify the additional reservation requirement twice. These callers
can pass a total of zero to rely on the bmapi minleft policy.

Beyond being superfluous, the primary motivation for this change is
that the total reservation logic in the bmbt code is dubious in
scenarios where minlen < maxlen and a maxlen extent cannot be
allocated (which is more common for data extent allocations where
contiguity is not required). The total value is based on maxlen in
the xfs_bmapi_write() caller. If the bmbt code falls back to an
allocation between minlen and maxlen, that allocation will not
succeed until total is reset to minlen, which essentially throws
away any additional reservation included in total by the caller. In
addition, the total value is not reset until after alignment is
dropped, which means that such callers drop alignment far too
aggressively than necessary.

Update all callers of xfs_bmapi_write() that pass a total block
value of the mapping length plus bmbt reservation to instead pass
zero and rely on xfs_bmapi_minleft() to enforce the bmbt reservation
requirement. This trades off slightly less conservative AG selection
for the ability to preserve alignment in more scenarios.
xfs_bmapi_write() callers that incorporate unrelated or additional
reservations in total beyond what is already included in minleft
must continue to use the former.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 fs/xfs/xfs_bmap_util.c   | 4 ++--
 fs/xfs/xfs_dquot.c       | 4 ++--
 fs/xfs/xfs_iomap.c       | 4 ++--
 fs/xfs/xfs_reflink.c     | 4 ++--
 fs/xfs/xfs_rtalloc.c     | 3 +--
 6 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c118577deaa9..65e38bd954d1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4505,7 +4505,6 @@ xfs_bmapi_convert_delalloc(
 =09bma.wasdel =3D true;
 =09bma.offset =3D bma.got.br_startoff;
 =09bma.length =3D max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
-=09bma.total =3D XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
 =09bma.minleft =3D xfs_bmapi_minleft(tp, ip, whichfork);
 =09if (whichfork =3D=3D XFS_COW_FORK)
 =09=09bma.flags =3D XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f443703065e..15547e089565 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -964,8 +964,8 @@ xfs_alloc_file_space(
 =09=09xfs_trans_ijoin(tp, ip, 0);
=20
 =09=09error =3D xfs_bmapi_write(tp, ip, startoffset_fsb,
-=09=09=09=09=09allocatesize_fsb, alloc_type, resblks,
-=09=09=09=09=09imapp, &nimaps);
+=09=09=09=09=09allocatesize_fsb, alloc_type, 0, imapp,
+=09=09=09=09=09&nimaps);
 =09=09if (error)
 =09=09=09goto error0;
=20
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index aeb95e7391c1..b924dbd63a7d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -305,8 +305,8 @@ xfs_dquot_disk_alloc(
 =09/* Create the block mapping. */
 =09xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
 =09error =3D xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
-=09=09=09XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
-=09=09=09XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
+=09=09=09XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
+=09=09=09&nmaps);
 =09if (error)
 =09=09return error;
 =09ASSERT(map.br_blockcount =3D=3D XFS_DQUOT_CLUSTER_SIZE_FSB);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f780e223b118..27f2030690e2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -277,8 +277,8 @@ xfs_iomap_write_direct(
 =09 * caller gave to us.
 =09 */
 =09nimaps =3D 1;
-=09error =3D xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-=09=09=09=09bmapi_flags, resblks, imap, &nimaps);
+=09error =3D xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0=
,
+=09=09=09=09imap, &nimaps);
 =09if (error)
 =09=09goto out_res_cancel;
=20
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0f08153b4994..3aa56cac1a47 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -410,8 +410,8 @@ xfs_reflink_allocate_cow(
 =09/* Allocate the entire reservation as unwritten blocks. */
 =09nimaps =3D 1;
 =09error =3D xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcoun=
t,
-=09=09=09XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
-=09=09=09resblks, imap, &nimaps);
+=09=09=09XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, imap,
+=09=09=09&nimaps);
 =09if (error)
 =09=09goto out_unreserve;
=20
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4a48a8c75b4f..d42b5a2047e0 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -792,8 +792,7 @@ xfs_growfs_rt_alloc(
 =09=09 */
 =09=09nmap =3D 1;
 =09=09error =3D xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
-=09=09=09=09=09XFS_BMAPI_METADATA, resblks, &map,
-=09=09=09=09=09&nmap);
+=09=09=09=09=09XFS_BMAPI_METADATA, 0, &map, &nmap);
 =09=09if (!error && nmap < 1)
 =09=09=09error =3D -ENOSPC;
 =09=09if (error)
--=20
2.20.1

