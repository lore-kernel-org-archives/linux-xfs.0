Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7969C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 11:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9162120732
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 11:41:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ey0nSfPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKOLls (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:41:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35638 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbfKOLls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 06:41:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573818106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=B4369xy8Ncbw0ZxOPsAK59ZUJx3GH2jT1TyjUhPy+oc=;
        b=ey0nSfPxirNFvwlpIhbdE10Naozj+BL19fsuD+6bBPFBj6pee4p9b+oukyr/K3pUFVqcld
        bmg7BSpcAKY2Z7WhH8yr8/GYDGwiKjDeZvXT/xPGrif8/iQ10gpB7oBZh1BgWBZb6USEr/
        nNa69g/eDK5q+fyGFQDgcBViAs3eorI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-mK9XUKeCOcOjCqfAf7KdQw-1; Fri, 15 Nov 2019 06:41:39 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80F4C107ACC6
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 11:41:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EB381019624
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 11:41:38 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix attr leaf header freemap.size underflow
Date:   Fri, 15 Nov 2019 06:41:37 -0500
Message-Id: <20191115114137.55415-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: mK9XUKeCOcOjCqfAf7KdQw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The leaf format xattr addition helper xfs_attr3_leaf_add_work()
adjusts the block freemap in a couple places. The first update drops
the size of the freemap that the caller had already selected to
place the xattr name/value data. Before the function returns, it
also checks whether the entries array has encroached on a freemap
range by virtue of the new entry addition. This is necessary because
the entries array grows from the start of the block (but end of the
block header) towards the end of the block while the name/value data
grows from the end of the block in the opposite direction. If the
associated freemap is already empty, however, size is zero and the
subtraction underflows the field and causes corruption.

This is reproduced rarely by generic/070. The observed behavior is
that a smaller sized freemap is aligned to the end of the entries
list, several subsequent xattr additions land in larger freemaps and
the entries list expands into the smaller freemap until it is fully
consumed and then underflows. Note that it is not otherwise a
corruption for the entries array to consume an empty freemap because
the nameval list (i.e. the firstused pointer in the xattr header)
starts beyond the end of the corrupted freemap.

Update the freemap size modification to account for the fact that
the freemap entry can be empty and thus stale.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 85ec5945d29f..86155260d8b9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1510,7 +1510,9 @@ xfs_attr3_leaf_add_work(
 =09for (i =3D 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 =09=09if (ichdr->freemap[i].base =3D=3D tmp) {
 =09=09=09ichdr->freemap[i].base +=3D sizeof(xfs_attr_leaf_entry_t);
-=09=09=09ichdr->freemap[i].size -=3D sizeof(xfs_attr_leaf_entry_t);
+=09=09=09ichdr->freemap[i].size -=3D
+=09=09=09=09min_t(uint16_t, ichdr->freemap[i].size,
+=09=09=09=09=09=09sizeof(xfs_attr_leaf_entry_t));
 =09=09}
 =09}
 =09ichdr->usedbytes +=3D xfs_attr_leaf_entsize(leaf, args->index);
--=20
2.20.1

