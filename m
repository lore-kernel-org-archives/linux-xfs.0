Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBA4C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 19:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2CA821741
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 19:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JerHrKhD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgBETFB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 14:05:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727478AbgBETFB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 14:05:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580929500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C3weXlvUoGKt40kPvHk0XiV4P9cVo6G9WmHDJh5T/fE=;
        b=JerHrKhDWLCPrbwXoHBbqiGatQSbe4dyE9nDtPDrtwLGTMzfobwCQyesN5P4tg8S9xx1h4
        7TijFJrUTaiIfVdkemkp7Ef8amrV1ORIUdf4Lx2oNVN51rmbXMvius2NhCultVh8FInc+3
        Q8SGGJQe+SRXM49ve061FYeBKZ9UPB0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-JFtaoK2_Oxyw3O2J6zuliA-1; Wed, 05 Feb 2020 14:04:57 -0500
X-MC-Unique: JFtaoK2_Oxyw3O2J6zuliA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDD1C1083E83
        for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2020 19:04:56 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-123-99.rdu2.redhat.com [10.10.123.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9473D5C1B2
        for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2020 19:04:56 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: xchk_xattr_listent() fix context->seen_enough to -ECANCELED
Date:   Wed,  5 Feb 2020 13:04:55 -0600
Message-Id: <20200205190455.1834330-1-billodo@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Commit e7ee96dfb8c (xfs: remove all *_ITER_ABORT values)
replaced *_ITER_ABORT values with -ECANCELED. The replacement
in the case of scrub/attr.c xchk_xattr_listent() is in
error (context->seen_enough =3D 1;). Instead of '1', use
the intended -ECANCELED.

Fixes: e7ee96dfb8c (xfs: remove all *_ITER_ABORT values)
Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/scrub/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d9f0dd444b80..5d0590f78973 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -171,7 +171,7 @@ xchk_xattr_listent(
 					     args.blkno);
 fail_xref:
 	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		context->seen_enough =3D 1;
+		context->seen_enough =3D -ECANCELED;
 	return;
 }
=20
--=20
2.24.1

