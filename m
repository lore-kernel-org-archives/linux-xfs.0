Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5218C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99F4D222D0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2kmhAME"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfKMOX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46298 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727559AbfKMOX5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdCt0DF4Oq8T2gUoVXbx4ynJe9R0exXFbbZMgjxSZKI=;
        b=X2kmhAMEf556cA+PG5QRL44ghphsATzFgf92bKm/cAAHN/SawfWVzA0pE1o7tX3KM9iCgw
        2gHhv6JH0WIxGER0ETY/S2W23eT6hS+7qpjL53DuO70jlaovSujmijZRADu8m+7z17ljMY
        U4ff++d5v5CMaFTD3ruCg1SrNZ58OUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-cAxSJrIPO7KsinIl3MzEuA-1; Wed, 13 Nov 2019 09:23:55 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F317C1345C1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:54 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5874D4D9E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:54 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/11] xfs: Remove KM_* flags
Date:   Wed, 13 Nov 2019 15:23:34 +0100
Message-Id: <20191113142335.1045631-11-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: cAxSJrIPO7KsinIl3MzEuA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We now use slab flags directly, so get rid of KM_flags and the
kmem_flags_convert() function.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.h | 37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 9249323567ce..791e770be0eb 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -15,43 +15,6 @@
  * General memory allocation interfaces
  */
=20
-typedef unsigned __bitwise xfs_km_flags_t;
-#define KM_NOFS=09=09((__force xfs_km_flags_t)0x0004u)
-#define KM_MAYFAIL=09((__force xfs_km_flags_t)0x0008u)
-#define KM_ZERO=09=09((__force xfs_km_flags_t)0x0010u)
-
-/*
- * We use a special process flag to avoid recursive callbacks into
- * the filesystem during transactions.  We will also issue our own
- * warnings, so we explicitly skip any generic ones (silly of us).
- */
-static inline gfp_t
-kmem_flags_convert(xfs_km_flags_t flags)
-{
-=09gfp_t=09lflags;
-
-=09BUG_ON(flags & ~(KM_NOFS|KM_MAYFAIL|KM_ZERO));
-
-=09lflags =3D GFP_KERNEL | __GFP_NOWARN;
-=09if (flags & KM_NOFS)
-=09=09lflags &=3D ~__GFP_FS;
-
-=09/*
-=09 * Default page/slab allocator behavior is to retry for ever
-=09 * for small allocations. We can override this behavior by using
-=09 * __GFP_RETRY_MAYFAIL which will tell the allocator to retry as long
-=09 * as it is feasible but rather fail than retry forever for all
-=09 * request sizes.
-=09 */
-=09if (flags & KM_MAYFAIL)
-=09=09lflags |=3D __GFP_RETRY_MAYFAIL;
-
-=09if (flags & KM_ZERO)
-=09=09lflags |=3D __GFP_ZERO;
-
-=09return lflags;
-}
-
 extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags);
 extern void *kmem_alloc_large(size_t size, gfp_t);
 static inline void  kmem_free(const void *ptr)
--=20
2.23.0

