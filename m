Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B17FCA9EB0
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE7520873
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYEBouxA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfJUMN1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:13:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49641 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727171AbfJUMN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 08:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571660006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M2HItLcEmEbhV/6b8X36XyNthPIRotJVZaLSiaUFkis=;
        b=RYEBouxA+PvCj+Txe2x02N9O2idupVZEIMgwZFxOJzAYZOiNLGjaQYkKcJg6QfXgVf1RHh
        E0oWDX2Ou9NeoBoBp2v5S3mcak0qAAF+X39Hpc0K/b674n2+uDWg+mdaVjAHrlajrfhXkW
        3LNPTRMB1t+dzIcII6p64XYg2z5K39A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-d1GQ-xLzPEGbfNPp_DANVg-1; Mon, 21 Oct 2019 08:13:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 222E05ED
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 12:13:24 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2BA05D9E2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 12:13:23 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs: cap longest free extent to maximum allocatable
Date:   Mon, 21 Oct 2019 08:13:21 -0400
Message-Id: <20191021121322.25659-2-bfoster@redhat.com>
In-Reply-To: <20191021121322.25659-1-bfoster@redhat.com>
References: <20191021121322.25659-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: d1GQ-xLzPEGbfNPp_DANVg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Cap longest extent to the largest we can allocate based on limits
calculated at mount time. Dynamic state (such as finobt blocks)
can result in the longest free extent exceeding the size we can
allocate, and that results in failure to align full AG allocations
when the AG is empty.

Result:

xfs_io-4413  [003]   426.412459: xfs_alloc_vextent_loopfailed: dev 8:96 agn=
o 0 agbno 32 minlen 243968 maxlen 244000 mod 0 prod 1 minleft 1 total 26214=
8 alignment 32 minalignslop 0 len 0 type NEAR_BNO otype START_BNO wasdel 0 =
wasfromfl 0 resv 0 datatype 0x5 firstblock 0xffffffffffffffff

minlen and maxlen are now separated by the alignment size, and
allocation fails because args.total > free space in the AG.

[bfoster: Added xfs_bmap_btalloc() changes.]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c  | 18 +++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 533b04aaf6f6..9dead25d2e70 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1989,7 +1989,8 @@ xfs_alloc_longest_free_extent(
 =09 * reservations and AGFL rules in place, we can return this extent.
 =09 */
 =09if (pag->pagf_longest > delta)
-=09=09return pag->pagf_longest - delta;
+=09=09return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
+=09=09=09=09pag->pagf_longest - delta);
=20
 =09/* Otherwise, let the caller try for 1 block if there's space. */
 =09return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 02469d59c787..c118577deaa9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3500,13 +3500,11 @@ xfs_bmap_btalloc(
 =09=09=09args.mod =3D args.prod - args.mod;
 =09}
 =09/*
-=09 * If we are not low on available data blocks, and the
-=09 * underlying logical volume manager is a stripe, and
-=09 * the file offset is zero then try to allocate data
-=09 * blocks on stripe unit boundary.
-=09 * NOTE: ap->aeof is only set if the allocation length
-=09 * is >=3D the stripe unit and the allocation offset is
-=09 * at the end of file.
+=09 * If we are not low on available data blocks, and the underlying
+=09 * logical volume manager is a stripe, and the file offset is zero then
+=09 * try to allocate data blocks on stripe unit boundary. NOTE: ap->aeof
+=09 * is only set if the allocation length is >=3D the stripe unit and the
+=09 * allocation offset is at the end of file.
 =09 */
 =09if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
 =09=09if (!ap->offset) {
@@ -3514,9 +3512,11 @@ xfs_bmap_btalloc(
 =09=09=09atype =3D args.type;
 =09=09=09isaligned =3D 1;
 =09=09=09/*
-=09=09=09 * Adjust for alignment
+=09=09=09 * Adjust minlen to try and preserve alignment if we
+=09=09=09 * can't guarantee an aligned maxlen extent.
 =09=09=09 */
-=09=09=09if (blen > args.alignment && blen <=3D args.maxlen)
+=09=09=09if (blen > args.alignment &&
+=09=09=09    blen <=3D args.maxlen + args.alignment)
 =09=09=09=09args.minlen =3D blen - args.alignment;
 =09=09=09args.minalignslop =3D 0;
 =09=09} else {
--=20
2.20.1

