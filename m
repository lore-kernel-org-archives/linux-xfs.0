Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87517C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 21:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D4522071F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 21:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJd082lo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKVVb3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 16:31:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47458 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbfKVVb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 16:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574458288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OuD2qwDVr3dnXJSwEeUqLcgb/DPf1i/I9Ms0+Tno0Rc=;
        b=OJd082lo/KgnhqGHjYjc7xssS0MGr+AvCGFO6qHCqB4R+kZYOkZS4ADG6dbJ24A1xSqfkc
        PU+p7S9XrFtFV7hlI2vX4u/oFYfrhNb7Tr9h9U/sVBhLld+3Num/0TOGdYABbraYEpUMBW
        irl1jCSkBHllvkLZlp9CpyPduPjdkug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-grmRMr4JPaGoaBhZYa0fjA-1; Fri, 22 Nov 2019 16:31:27 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B0E2107ACE6
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 21:31:26 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-122-148.rdu2.redhat.com [10.10.122.148])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B0F719C58;
        Fri, 22 Nov 2019 21:31:25 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     esandeen@redhat.com
Cc:     linux-xfs@vger.kernel.org, John Pittman <jpittman@redhat.com>
Subject: [PATCH] xfsprogs: add missing carriage returns in libxfs/rdwr.c
Date:   Fri, 22 Nov 2019 16:31:22 -0500
Message-Id: <20191122213122.13327-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: grmRMr4JPaGoaBhZYa0fjA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In libxfs/rdwr.c, there are several fprintf() calls that are
missing trailing carriage returns. This translates to the
following CLI prompt being on the same line as the message.
Add missing carriage returns, alleviating the issue.

Fixes: 0a7942b38215 ("libxfs: don't discard dirty buffers")
Signed-off-by: John Pittman <jpittman@redhat.com>
---
 libxfs/rdwr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7080cd9c..3f69192d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -651,7 +651,7 @@ __libxfs_getbufr(int blen)
 =09pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 =09bp->b_ops =3D NULL;
 =09if (bp->b_flags & LIBXFS_B_DIRTY)
-=09=09fprintf(stderr, "found dirty buffer (bulk) on free list!");
+=09=09fprintf(stderr, "found dirty buffer (bulk) on free list!\n");
=20
 =09return bp;
 }
@@ -1224,7 +1224,7 @@ libxfs_brelse(
 =09=09return;
 =09if (bp->b_flags & LIBXFS_B_DIRTY)
 =09=09fprintf(stderr,
-=09=09=09"releasing dirty buffer to free list!");
+=09=09=09"releasing dirty buffer to free list!\n");
=20
 =09pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
 =09list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
@@ -1245,7 +1245,7 @@ libxfs_bulkrelse(
 =09list_for_each_entry(bp, list, b_node.cn_mru) {
 =09=09if (bp->b_flags & LIBXFS_B_DIRTY)
 =09=09=09fprintf(stderr,
-=09=09=09=09"releasing dirty buffer (bulk) to free list!");
+=09=09=09=09"releasing dirty buffer (bulk) to free list!\n");
 =09=09count++;
 =09}
=20
--=20
2.17.2

