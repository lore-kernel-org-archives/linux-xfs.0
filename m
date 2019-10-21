Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5EECA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 13:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F9512089C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 13:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MbmNNAzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfJUNOJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 09:14:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51824 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726767AbfJUNOI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 09:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571663647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pfhu+YDxg6fHZJTyduIog71uZAsrTA1RuxJ4SEN5Ihs=;
        b=MbmNNAzVR2eQ99tzrQA0doMe+4cO4vc/3aVzVwkkav4aNUX/H6xxrRjFWnK+yYZa1+FZ8E
        R5p8wDGz31l/mlVMq3cVjJoDRIwGGsj2zcQz+yQdI1Y1CefOLYXO7UtIxCdS5M1QHpu8eE
        Eoi5RCB0kQxcBhDfeEqEzrIfiAnVIxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-Y2OCRVbuOVaHr_5s-Ep_9A-1; Mon, 21 Oct 2019 09:14:05 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B67EF800D41
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 13:14:04 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 743FE5EE1D
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 13:14:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix sparse warning on allocation cursor initialization
Date:   Mon, 21 Oct 2019 09:14:04 -0400
Message-Id: <20191021131404.30089-1-bfoster@redhat.com>
In-Reply-To: <201910200432.0NRV75fO%lkp@intel.com>
References: <201910200432.0NRV75fO%lkp@intel.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Y2OCRVbuOVaHr_5s-Ep_9A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

sparse complains about the initialization used for the allocation
cursor:

>> fs/xfs/libxfs/xfs_alloc.c:1170:41: sparse: sparse: Using plain integer a=
s NULL pointer

Fix it by removing the unnecessary initialization value.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e9f74eb92073..925eba9489d5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1471,7 +1471,7 @@ STATIC int
 xfs_alloc_ag_vextent_near(
 =09struct xfs_alloc_arg=09*args)
 {
-=09struct xfs_alloc_cur=09acur =3D {0,};
+=09struct xfs_alloc_cur=09acur =3D {};
 =09int=09=09=09error;=09=09/* error code */
 =09int=09=09=09i;=09=09/* result code, temporary */
 =09xfs_agblock_t=09=09bno;
--=20
2.20.1

